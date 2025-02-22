-- Main Component References
local tankControllerServer = script:GetCustomProperty("TankControllerServer"):WaitForObject()

-- API
local identifier = tankControllerServer:GetCustomProperty("Identifier")
local Constants_API = require(script:GetCustomProperty("Constants_API"))

local tankData = Constants_API:WaitForConstant("Tanks").GetTankFromId(tonumber(identifier))

-- Visual Settings
local recoilRockingMultiplier = tankData.recoilRockingMultiplier
local recoilAmount = tankData.recoilAmount
local wheelSpeedModifier = tankData.wheelSpeedModifier

-- Other asset refs
local extinguishVFX = script:GetCustomProperty("ExtinguishVFX")

-- Object References
local adjustmentPoint = nil

local tankBodyClient = nil
local tankBodyServer = nil
local treadsLeft = nil
local treadsRight = nil
local leftWheels = nil
local rightWheels = nil

local turretClient = nil
local turretServer = nil
local cannonClient = nil
local cannonServer = nil
local barrelClient = nil

local shotSFX = nil
local flashVFX = nil

local trackedLeftState = nil
local trackedRightState = nil
local barrelDamageState = nil
local fireState = nil

-- Player Reference
local driver = nil

-- Additional Local Variables
local tankSet = false
local tankReady = false
local speedMultiplier = 0
local saluteOverride = false
local animateListener = nil
local destroyedListener = nil
local stateListener = nil

function GetDriver()
	return driver
end

function CheckTankReady()
	tankReady = tankControllerServer:GetCustomProperty("TankReady")

	if not tankReady then
		return
	end

	Task.Wait(1)
	local driverId = tankControllerServer:GetCustomProperty("DriverID")

	for _, p in ipairs(Game.GetPlayers()) do
		if p.id == driverId then
			driver = p
--print("found (player) driver on client: " .. driver.name)
		end
	end

	-- If we didn't find a driver, then it's probably an AI.
	-- Wait for AI data to replicate to us!
	if not driver then
		
		while _G.lookup == nil or _G.lookup.tanks == nil do 
			Task.Wait()
		end
		
		while not driver do
			Task.Wait()
			--print("---- Waiting to find driver", driverId, Environment.IsClient())
			driver = _G.lookup.tanks[driverId]
		end
		--print("found (AI) driver on client: " .. driver.name)
		--SetClientData()
	end

	

	local hitbox = tankControllerServer:GetCustomProperty("HitboxReference"):WaitForObject()

	tankBodyServer = tankControllerServer:GetCustomProperty("ChassisReference"):WaitForObject()
	tankBodyClient = World.SpawnAsset(GetSkin(driver), {parent = tankBodyServer, scale = Vector3.ONE * 1.1})

	tankBodyClient:SetPosition(Vector3.ZERO)
	tankBodyClient:SetRotation(Rotation.ZERO)

	Task.Wait(1)

	treadsLeft = tankBodyClient:FindDescendantByName("TreadsLeft")
	treadsRight = tankBodyClient:FindDescendantByName("TreadsRight")

	leftWheels = treadsLeft:FindDescendantsByName("Wheel")
	rightWheels = treadsRight:FindDescendantsByName("Wheel")

	turretServer = hitbox:FindDescendantByName("Turret")
	cannonServer = hitbox:FindDescendantByName("Cannon")

	adjustmentPoint = tankBodyClient:FindDescendantByName("AdjustmentPoint")
	turretClient = tankBodyClient:FindDescendantByName("Turret")
	cannonClient = tankBodyClient:FindDescendantByName("Cannon")
	barrelClient = tankBodyClient:FindDescendantByName("Barrel")
	shotSFX = tankBodyClient:FindDescendantByName("ShotSFX")
	flashVFX = tankBodyClient:FindDescendantByName("FlashVFX")

	fireState = tankBodyClient:FindDescendantByName("HullFire")
	trackedLeftState = tankBodyClient:FindDescendantByName("TreadsLeftDamaged")
	trackedRightState = tankBodyClient:FindDescendantByName("TreadsRightDamaged")
	barrelDamageState = tankBodyClient:FindDescendantByName("BarrelDamaged")

	stateListener = tankControllerServer.networkedPropertyChangedEvent:Connect(OnTankStateChanged)

	SetClientData()

	if driver == Game.GetLocalPlayer() then
		--driver:SetOverrideCamera(defaultCamera)
		Events.Broadcast("EquippedTankSet")
	end

	Events.Broadcast("EquippedTankDataSet", nil)
	Events.Broadcast("INITIALIZE_SKIN", driver)

	tankSet = true
end

function GetSkin(player)
	local selectedSkin = tankData.Skin

	if (player ~= Game.GetLocalPlayer()) and tankData.SkinLoFi then
		selectedSkin = tankData.SkinLoFi
	end

	return selectedSkin
end

function SetClientData()
	if not driver then
		return
	end

	if not driver.clientUserData.currentTankData then
		driver.clientUserData.currentTankData = {}
	end
	
	local upgradeStatName = ""
	local upgradeStatValue = 0
	local currentViewRange = tankData.viewRange
	
	if driver.clientUserData.techTreeProgress then
		for _, e in pairs(driver.clientUserData.techTreeProgress) do
			if tonumber(e.id) == tonumber(tankData.id) then			
				for id, progress in pairs(e.crew) do
					if tonumber(progress) > 1 then	
					
						for i = 1, 4 do 
							upgradeStatName = tankData["CREW"][id]["stat" .. tostring(i) .. "Name"]
							upgradeStatValue = tankData["CREW"][id]["stat" .. tostring(i) .. "Value"]
							
							if not upgradeStatName or not upgradeStatValue then
								warn(id .. " for " .. tostring(identifier) .. " is missing data in database")
								break
							end
							
							if upgradeStatName == "SPOTTING" then
								currentViewRange = currentViewRange * (1 + upgradeStatValue)
								print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
							end
						end
					end
				end
				break
			end
		end
	end

	driver.clientUserData.currentTankData.chassis = tankBodyServer
	driver.clientUserData.currentTankData.skin = tankBodyClient
	driver.clientUserData.currentTankData.enemyOutline = tankBodyClient:FindDescendantByName("EnemyOutline")
	driver.clientUserData.currentTankData.allyOutline = tankBodyClient:FindDescendantByName("AllyOutline")
	driver.clientUserData.currentTankData.reloadSFX = tankBodyClient:FindDescendantByName("ReloadSFX")
	driver.clientUserData.currentTankData.type = tankData.type
	driver.clientUserData.currentTankData.id = identifier
	driver.clientUserData.currentTankData.name = tankData.name
	driver.clientUserData.currentTankData.teir = tankData.tier
	driver.clientUserData.currentTankData.viewRange = currentViewRange
	driver.clientUserData.currentTankData.controlScript = script
	driver.clientUserData.currentTankData.serverControlScript = tankControllerServer
end

function OnTankStateChanged(controllerServer, property)
	local value = controllerServer:GetCustomProperty(property)

	if property == "Tracked" and Object.IsValid(trackedLeftState) then
		if value == 1 then
			trackedLeftState.visibility = Visibility.INHERIT
			treadsLeft.visibility = Visibility.FORCE_OFF
		elseif value == 2 then
			trackedRightState.visibility = Visibility.INHERIT
			treadsRight.visibility = Visibility.FORCE_OFF
		else
			trackedLeftState.visibility = Visibility.FORCE_OFF
			trackedRightState.visibility = Visibility.FORCE_OFF
			treadsLeft.visibility = Visibility.INHERIT
			treadsRight.visibility = Visibility.INHERIT
		end
	elseif property == "Burning" and Object.IsValid(fireState) then
		if value then
			fireState.visibility = Visibility.INHERIT

			for _, i in ipairs(fireState:FindDescendantsByType("SFX")) do
				i:Play()
			end
		else
			if not Object.IsValid(fireState) then
				return
			end

			fireState.visibility = Visibility.FORCE_OFF

			World.SpawnAsset(extinguishVFX, {parent = fireState})

			for _, i in ipairs(fireState:FindDescendantsByType("SFX")) do
				i:Stop()
			end
		end
	elseif property == "BarrelDown" and Object.IsValid(barrelDamageState) then
		if value then
			barrelDamageState.visibility = Visibility.INHERIT
			barrelClient.visibility = Visibility.FORCE_OFF
		else
			barrelDamageState.visibility = Visibility.FORCE_OFF
			barrelClient.visibility = Visibility.INHERIT
		end
	elseif property == "TankReady" then
		tankReady = tankControllerServer:GetCustomProperty(property)
	elseif property == "WheelSpeedMultiplier" then
		wheelSpeedModifier = tankControllerServer:GetCustomProperty(property)
	end
end

function FiringAnimation(playerId, reloadTime)
	local player = Game.FindPlayer(playerId)
	if player == nil then
		return
	end

	if not saluteOverride then
		if player ~= driver or not Object.IsValid(tankBodyClient) then
			return
		end
	end

	reloadSpeed = reloadTime

	shotSFX:Play()

	local xRotation = 0
	local yRotation = 0

	local currentZ = turretClient:GetRotation().z

	if currentZ < 0 then
		currentZ = 360 + currentZ
	end

	if currentZ < 90 then
		xRotation = -((turretClient:GetRotation().z % 90) / 90) * recoilRockingMultiplier
		yRotation = (((90 - turretClient:GetRotation().z) % 90) / 90) * recoilRockingMultiplier
	elseif currentZ < 180 then
		xRotation = -(((90 - turretClient:GetRotation().z) % 90) / 90) * recoilRockingMultiplier
		yRotation = -((turretClient:GetRotation().z % 90) / 90) * recoilRockingMultiplier
	elseif currentZ < 270 then
		xRotation = ((turretClient:GetRotation().z % 90) / 90) * recoilRockingMultiplier
		yRotation = -(((90 - turretClient:GetRotation().z) % 90) / 90) * recoilRockingMultiplier
	else
		xRotation = (((90 - turretClient:GetRotation().z) % 90) / 90) * recoilRockingMultiplier
		yRotation = ((turretClient:GetRotation().z % 90) / 90) * recoilRockingMultiplier
	end

	shootShakeOverride = true

	if Object.IsValid(adjustmentPoint) then
		adjustmentPoint:RotateTo(Rotation.New(xRotation, yRotation, 0), 0.2, true)
	end

	flashVFX:Play()

	if Object.IsValid(barrelClient) then
		barrelClient:MoveTo(Vector3.New(-recoilAmount, 0, 0), 0.12, true)
	end

	Task.Wait(0.13)

	if Object.IsValid(barrelClient) then
		barrelClient:MoveTo(Vector3.ZERO, 0.2, true)
	end

	Task.Wait(0.07)

	if Object.IsValid(adjustmentPoint) then
		adjustmentPoint:RotateTo(Rotation.ZERO, 0.2, true)
	end
	
end

function PerformSalute()
	local gameStateManager = World.FindObjectByName("GAMESTATE_MainGameStateManagerServer")

	if not Object.IsValid(gameStateManager) then
		return
	elseif not Object.IsValid(tankControllerServer) then
--print("Invalid controller server")
		return
	end

	local currentState = gameStateManager:GetCustomProperty("GameState")

	if currentState ~= "VICTORY_STATE" then
		return
	end

	local owner = nil

	while not owner do
		local tankOwner = tankControllerServer:GetCustomProperty("DriverID")

		if tankOwner then
			for _, p in ipairs(Game.GetPlayers()) do
				if p.id == tankOwner then
					owner = p
				end
			end
		end

		Task.Wait()
	end

	tankBodyClient = World.SpawnAsset(tankData.Skin, {parent = script})
	tankBodyClient:SetPosition(Vector3.ZERO)
	tankBodyClient:SetRotation(Rotation.ZERO)

	for _, s in ipairs(tankBodyClient:FindDescendantsByType("Audio")) do
		s:Stop()
	end

	owner.clientUserData.currentTankData = nil
	owner.clientUserData.garageModel = {}
	owner.clientUserData.garageModel.id = tankControllerServer:GetCustomProperty("Identifier")
	owner.clientUserData.garageModel.reference = tankBodyClient
	Events.Broadcast("INITIALIZE_SKIN", owner)

	local tankId = tankControllerServer:GetCustomProperty("Identifier")

	if tankId == "26" then
		local wheels = tankBodyClient:FindDescendantByName("WHEEL_SET")
		wheels.visibility = Visibility.INHERIT
	end

	Task.Wait(1)

	adjustmentPoint = tankBodyClient:FindDescendantByName("AdjustmentPoint")
	turretClient = tankBodyClient:FindDescendantByName("Turret")
	cannonClient = tankBodyClient:FindDescendantByName("Cannon")
	barrelClient = tankBodyClient:FindDescendantByName("Barrel")

	shotSFX = tankBodyClient:FindDescendantByName("ShotSFX")
	flashVFX = tankBodyClient:FindDescendantByName("FlashVFX")

	local verticalLimit = tankControllerServer:GetCustomProperty("MaxElevationAngle")
	local horizontalLimit = tankControllerServer:GetCustomProperty("HorizontalCannonAngles")

	Task.Wait(1)

	if verticalLimit < 15 then
		if horizontalLimit > 0 then
			cannonClient:RotateTo(Rotation.New(0, vetricalLimit, -horizontalLimit + cannonClient:GetRotation().z), 1, true)
		else
			cannonClient:RotateTo(Rotation.New(0, verticalLimit, 0), 1, true)
			turretClient:RotateTo(Rotation.New(0, 0, -20 + cannonClient:GetRotation().z), 1, true)
		end
	else
		if horizontalLimit > 0 then
			cannonClient:RotateTo(Rotation.New(0, 15, -horizontalLimit + cannonClient:GetRotation().z), 1, true)
		else
			cannonClient:RotateTo(Rotation.New(0, 15, 0), 1, true)
			turretClient:RotateTo(Rotation.New(0, 0, -20 + cannonClient:GetRotation().z), 1, true)
		end
	end

	Task.Wait(1.5)

	saluteOverride = true
	FiringAnimation(owner.id, 0)
end

function SetWheelSpeed()
	if not Object.IsValid(tankBodyClient) then
		return
	end

	local leftSpeedMultiplier = 1
	local rightSpeedMultiplier = 1

	local movementSpeed = tankBodyServer:GetVelocity().size -- * speedMultiplier
	local rotationSpeed = tankBodyServer:GetAngularVelocity().z

	if rotationSpeed > 1 then
		leftSpeedMultiplier = 1
		rightSpeedMultiplier = 0.5
	elseif rotationSpeed < -1 then
		leftSpeedMultiplier = 0.5
		rightSpeedMultiplier = 1
	end

	--print("setting speed: " .. tostring(movementSpeed))
	for _, w in ipairs(leftWheels) do
		if Object.IsValid(w) then
			w:RotateContinuous(Rotation.New(0, -1, 0), movementSpeed * leftSpeedMultiplier * wheelSpeedModifier, true)
		end
	end

	for _, w in ipairs(rightWheels) do
		if Object.IsValid(w) then
			w:RotateContinuous(Rotation.New(0, -1, 0), movementSpeed * rightSpeedMultiplier * wheelSpeedModifier, true)
		end
	end
end

function OnDestroy(object)
	if destroyedListener then
		destroyedListener:Disconnect()
		destroyedListener = nil
	end

	if animateListener then
		animateListener:Disconnect()
		animateListener = nil
	end

	if saluteListener then
		saluteListener:Disconnect()
		saluteListener = nil
	end

	if stateListener then
		stateListener:Disconnect()
		stateListener = nil
	end

	if Object.IsValid(tankBodyClient) then
		tankBodyClient:Destroy()
	end
end

function Tick()
	if not tankSet then
		CheckTankReady()
		return
	end

	if not tankReady then
		if Object.IsValid(tankBodyClient) then
			tankBodyClient:Destroy()
		end
		tankSet = false
		return
	end

	if Object.IsValid(turretClient) and Object.IsValid(turretServer) then
		turretClient:RotateTo(turretServer:GetRotation(), 0.1, true)
	end

	if Object.IsValid(cannonClient) and Object.IsValid(cannonServer) then
		cannonClient:RotateTo(cannonServer:GetRotation(), 0.1, true)
	end

	SetWheelSpeed()
end

animateListener = Events.Connect("ANIMATE_FIRING", FiringAnimation)
destroyedListener = script.destroyEvent:Connect(OnDestroy)
PerformSalute()
