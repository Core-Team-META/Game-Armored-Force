local AIPlayer = require(script:GetCustomProperty("_AIPlayer"))

-- Tank Custom Properties:
-- INFO
local identifier = script:GetCustomProperty("Identifier")
local Constants_API = require(script:GetCustomProperty("Constants_API"))

-- Impact vfx
local TankImpact_1 = script:GetCustomProperty("TankImpact_1")
local TankImpact_2 = script:GetCustomProperty("TankImpact_2")
local TankImpact_3 = script:GetCustomProperty("TankImpact_3")
local TankImpact_4 = script:GetCustomProperty("TankImpact_4")

 
local tankData =  Constants_API:WaitForConstant("Tanks").GetTankFromId(tonumber(identifier)) 
local Type = tankData.type
local tierValue = tankData.tier

-- TURRET
local reloadSpeed = tankData.reload
local upgradedReload = tankData.reloadUpgraded
local projectileSpeed = tankData.projectileSpeed
local projectileLength = tankData.projectileLength
local projectileRadius = tankData.projectileRadius
local damagePerShot = tankData.damage
local upgradedDamage = tankData.damageUpgraded
local allowHoldDownFiring = tankData.allowHoldDownFiring
local turretTraverseSpeed = tankData.turret
local upgradedTraverse = tankData.turretUpgraded
local turretElevationSpeed = tankData.elevation
local upgradedElevation = tankData.elevationUpgraded
local maxElevationAngle = tankData.maxElevation
local minDepressionAngle = tankData.maxDepression
local horizontalCannonAngles = tankData.horizontalAngles

-- SHELL
local hitPoints = tankData.hitPoints
local upgradedHitPoints = tankData.hitPointsUpgraded
local viewRange = tankData.viewRange

-- ENGINE
local topSpeed = tankData.topSpeed
local upgradedTopSpeed = tankData.topSpeedUpgraded
local acceleration = tankData.acceleration
local upgradedAcceleration = tankData.accelerationUpgraded
local turningSpeed = tankData.turningSpeed
local upgradedTurningSpeed = tankData.turningSpeedUpgraded

-- Main Component References
local templateReferences = script:GetCustomProperty("TemplateReferences"):WaitForObject()
local target = script:GetCustomProperty("Target"):WaitForObject()

if not (Game.GetCurrentSceneName() == "Main") then
	while not _G["standardcombo.Combat.Wrap"] do
		Task.Wait()
	end
end
local COMBAT = _G["standardcombo.Combat.Wrap"]

-- Selected/Active Tank Stats
local reloadTime = nil
local projectileDamage = nil
local tankHitPoints = nil
local traverseSpeed = nil
local elevationSpeed = nil
local chassisTemplate = nil

-- Object References
local hitbox = nil
local chassis = nil
local turret = nil
local cannon = nil
local cannonGuide = nil
local muzzle = nil
local projectile = nil
local explosion = nil
local destroyedTankTempate = nil
local destroyedTank = nil

-- Player Reference
local driver = nil
local isAI = false

-- Additional Local Variables
local originalSpeed = 0
local originalFriction = 0
local originalAcceleration = 0
local originalTurnSpeed = 0
local ramCooldown = false
local rollbackTable = {}
local lastRollbackPosition = 0
local aimTask = nil
local reloading = false
local flipping = false
local trackStatus = 0
local playerWhoBurned = nil
local turretDown = false
local barrelDown = false
local trackTask = nil
local burnTask = nil
local turretDamagedTask = nil
local checkStuckTankTask = nil
local bindingPressedListener = nil
local diedEventListener = nil
local destroyedListener = nil
local consumableListener = nil
local armorImpactListeners = {}
local armorReleaseListeners = {}
local vehicleCollideCount = 0
local treadRepairTime = 10
local fireRepairTime = 10
local turretRepairTime = 10
local fireDamage = 10

--local MAX_ANGULAR_VELOCITY = 150
local MIN_NOT_STUCK_VELOCITY = 20
local MAX_NOT_FLIPPED_ANGLE = 10
local MAX_ROLLBACK_COUNT = 10


local REAR_END_FIRE_CHANCE = 25
local FIAT_DAMAGE_STATE_CHANCE = 20
local STANDARD_DAMAGE_STATE_CHANCE = 25

--[[
local REAR_END_FIRE_CHANCE = 100
local FIAT_DAMAGE_STATE_CHANCE = 100
local STANDARD_DAMAGE_STATE_CHANCE = 100
]]
local PROJECTILE_WAIT_LIMIT = 100

local UPGRADE_TYPES = {"TURRET", "HULL", "ENGINE", "CREW"}

local function RaycastResultFromPointRotationDistance(point, rotation, distance)
	
	local azimuth = rotation.z
	local altitude = rotation.y
	
	if azimuth < 0 then
		azimuth = azimuth + 360
	end
	
	azimuth = azimuth * math.pi/180
	
	if altitude < 0 then
		altitude = altitude + 360
	end
	
	altitude = altitude * math.pi/180
	
	local direction = Vector3.New(math.cos(azimuth) * math.cos(altitude), math.sin(azimuth) * math.cos(altitude), math.sin(altitude))
	local destination = (direction * distance) + point
	local point = World.Raycast(point, destination)
	
	if point then
		destination = point:GetImpactPosition()
	end
	
	return destination

end

function GetDriver()

	return driver

end

function AssignDriver(newDriver, hp)

	isAI = newDriver:IsA("AIPlayer")
--print("assigning a driver.  AI?", isAI)
--print("new driver: " .. tostring(newDriver))

	if (not isAI) and (Object.IsValid(driver) or not Object.IsValid(newDriver) or not newDriver:IsA("Player")) then
--print("returning")
		return
	end
	
	Task.Wait()
	
	local baseForPosition = newDriver
	
	local newScriptPosition = baseForPosition:GetWorldPosition()
	local newScriptRotation = baseForPosition:GetWorldRotation()
	local moreIdealPositionRaycast = World.Raycast(newScriptPosition + Vector3.UP * 1000, newScriptPosition - Vector3.UP * 1000, {ignorePlayers = true})
	
	if moreIdealPositionRaycast then
		newScriptPosition = moreIdealPositionRaycast:GetImpactPosition()
	end
	
	newScriptPosition = newScriptPosition + Vector3.UP * 500
	
	script:SetWorldPosition(newScriptPosition)
	script:SetWorldRotation(newScriptRotation)

	driver = newDriver
	
	SetTankModifications()
	
	driver.maxHitPoints = tankHitPoints
	driver.hitPoints = type(hp) == "number" and CoreMath.Round(tankHitPoints * hp) or tankHitPoints
	
	local newHitbox = templateReferences:GetCustomProperty("DefaultHitbox")
	local tankGarage = World.FindObjectByName("TANK_VP_TankGarage")
	
	projectile = templateReferences:GetCustomProperty("Projectile")
	explosion = templateReferences:GetCustomProperty("ProjectileExplosion")
	destroyedTankTempate = templateReferences:GetCustomProperty("DestroyedTank")
	
	chassis = World.SpawnAsset(chassisTemplate)
	
	local originalGravity = chassis.gravityScale
	chassis.gravityScale = 0
	--chassis:SetWorldPosition(script:GetWorldPosition())
	--chassis:SetWorldRotation(script:GetWorldRotation())
	chassis:SetWorldTransform(script:GetWorldTransform())
	
	Task.Wait()

	if not isAI then
		chassis:SetDriver(driver)
	else
		local identifier = script:GetCustomProperty("Identifier")
		driver:AssignToTank(chassis, identifier)
	end

	originalSpeed = chassis.maxSpeed
	chassis.maxSpeed = originalSpeed
	originalFriction = chassis.tireFriction
	chassis.tireFriction = chassis.tireFriction
	chassis.brakeStrength = 100
	chassis.coastBrakeStrength = 70
	originalAcceleration = chassis.accelerationRate
	chassis.accelerationRate = originalAcceleration
	
	if chassis.turnSpeed then
		chassis.turnSpeed = originalTurnSpeed
	elseif chassis.turnRadius then
		chassis.turnRadius = originalTurnSpeed
	end
	
	originalFriction = chassis.tireFriction
	chassis.brakeStrength = 100
	chassis.coastBrakeStrength = 70
		
	hitbox = World.SpawnAsset(newHitbox, {parent = chassis, scale = Vector3.ONE * 1.1})
	turret = hitbox:FindDescendantByName("Turret")
	cannon = hitbox:FindDescendantByName("Cannon")
	cannonGuide = hitbox:FindDescendantByName("CannonGuide")
	muzzle = hitbox:FindDescendantByName("Muzzle")
	
	if not (Game.GetCurrentSceneName() == "Main") then
		_G.lookup.tanks[driver].chassis = chassis
		_G.lookup.tanks[driver].target = target
		_G.lookup.tanks[driver].muzzle = muzzle
		_G.lookup.tanks[driver].turret = turret
		_G.lookup.tanks[driver].script = script
	end
	
	Task.Wait()
	
	driver.isCollidable = false
	driver.isVisible = false
	
	Task.Wait()
	
	if not isAI then
		driver:AttachToCoreObject(turret)
	end
	
	hitbox:SetPosition(Vector3.ZERO)
	
	if turret and horizontalCannonAngles <= 0 then
		turret:LookAtContinuous(target, true, traverseSpeed/57)
	end
	
	cannonGuide:LookAtContinuous(target, false)

	script:SetNetworkedCustomProperty("ChassisReference", chassis)
	script:SetNetworkedCustomProperty("HitboxReference", hitbox)
	script:SetNetworkedCustomProperty("DriverID", driver.id)
	
	for _, t in pairs(hitbox:FindDescendantsByType("Trigger")) do
	 	armorImpactListeners[t] = t.beginOverlapEvent:Connect(OnArmorHit)
	 	armorReleaseListeners[t] = t.endOverlapEvent:Connect(OnArmorRelease)
	end
	
	if not isAI then
		bindingPressedListener = driver.bindingPressedEvent:Connect(OnBindingPressed)
		consumableListener = Events.Connect(driver.id .. "RepairTank", OnConsumableUsed)
	end
	diedEventListener = driver.diedEvent:Connect(OnDeath)

	Task.Wait()
	script:SetNetworkedCustomProperty("TankReady", true)
	
	SetServerData()
	
	checkStuckTankTask = Task.Spawn(CheckStuckTank, 0)
	checkStuckTankTask.repeatCount = -1
	checkStuckTankTask.repeatInterval = 0.5
	
	Task.Wait(0.5)
	
	chassis.gravityScale = originalGravity

end

function AssignOwner(newOwner)

	script:SetNetworkedCustomProperty("DriverID", newOwner.id)

end

function SetServerData()
	
	driver.serverUserData.currentTankData.chassis = chassis
	driver.serverUserData.currentTankData.hitbox = hitbox
	driver.serverUserData.currentTankData.viewRange = viewRange
	driver.serverUserData.currentTankData.fullDamage = projectileDamage
	driver.serverUserData.currentTankData.type = Type
	driver.serverUserData.currentTankData.id = identifier
	driver.serverUserData.currentTankData.controlScript = script

end

function SetTankModifications()

	if not driver.serverUserData.currentTankData then
		driver.serverUserData.currentTankData = {}
	end
	
	local modifications = nil
	
	reloadTime = reloadSpeed
	projectileDamage = damagePerShot
	traverseSpeed = turretTraverseSpeed
	
	tankHitPoints = hitPoints
	
	elevationSpeed = turretElevationSpeed
	chassisTemplate = templateReferences:GetCustomProperty("DefaultChassis")
	originalSpeed = topSpeed
	originalAcceleration = acceleration
	originalTurnSpeed = turningSpeed

	if isAI then
		--modifications = {0, 0, 0} -- 2, 2, 2 \ 0, 0, 0
		return
	else
		if driver.serverUserData.techTreeProgress then
			for x, entry in ipairs(driver.serverUserData.techTreeProgress) do
				if entry.id == identifier then
					modifications = entry
				end
			end
		end

		if not modifications then
			warn("COULD NOT FIND TANK ID " .. identifier)
			return
		end
		
		--[[
		if driver.serverUserData.TankUpgradeOverride and #driver.serverUserData.TankUpgradeOverride > 0 then
			--print("Overriding tank upgrades")
			modifications = driver.serverUserData.TankUpgradeOverride 
		end
		]]
	end
	
	local currentModType = nil
	local upgradeStatName = ""
	local upgradeStatValue = 0
	
	local additionalTreadsCount = 0	
	local additionalExtinguisherCount = 0
	
	for _, type in ipairs(UPGRADE_TYPES) do
		if type == "TURRET" then
			currentModType = modifications.turret
		elseif type == "HULL" then
			currentModType = modifications.hull
		elseif type == "ENGINE" then
			currentModType = modifications.engine
		elseif type == "CREW" then
			currentModType = modifications.crew
		end
		
		if not tankData[type] then
			break
		end
		
		for id, progress in pairs(currentModType) do
			if tonumber(progress) > 1 then
				if not tankData[type][id] then
					warn(id .. " does not exist in database")
					break
				end
				
				for i = 1, 4 do 
					upgradeStatName = tankData[type][id]["stat" .. tostring(i) .. "Name"]
					upgradeStatValue = tankData[type][id]["stat" .. tostring(i) .. "Value"]
					
					if not upgradeStatName or not upgradeStatValue then
						warn(id .. " for " .. tostring(identifier) .. " is missing data in database")
						break
					end
					-- BASE UPGRADES:
					if upgradeStatName == "AIM" then
						traverseSpeed = traverseSpeed + upgradeStatValue
						elevationSpeed = elevationSpeed + upgradeStatValue
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					elseif upgradeStatName == "AIMBOOST" then
						traverseSpeed = traverseSpeed + turretTraverseSpeed * upgradeStatValue
						elevationSpeed = elevationSpeed + turretElevationSpeed * upgradeStatValue
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					elseif upgradeStatName == "RELOADBOOST" then
						reloadTime = reloadTime + reloadSpeed * upgradeStatValue
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					elseif upgradeStatName == "DAMAGE" then
						projectileDamage = projectileDamage + upgradeStatValue
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					elseif upgradeStatName == "HITPOINTS" then
						tankHitPoints = tankHitPoints + upgradeStatValue
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					elseif upgradeStatName == "SPEED" then
						originalSpeed = originalSpeed + upgradeStatValue
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					elseif upgradeStatName == "SPEEDBOOST" then
						originalSpeed = originalSpeed + topSpeed * upgradeStatValue
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					elseif upgradeStatName == "ACCELERATION" then
						originalAcceleration = originalAcceleration + upgradeStatValue
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					elseif upgradeStatName == "TURNING" then
						originalTurnSpeed = originalTurnSpeed + upgradeStatValue
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					elseif upgradeStatName == "TURNINGBOOST" then
						originalTurnSpeed = originalTurnSpeed + turningSpeed * upgradeStatValue
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					-- ADDITIONAL CREW UPGRADES:
					elseif upgradeStatName == "AUTOTREAD" then
						treadRepairTime = treadRepairTime - upgradeStatValue
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					elseif upgradeStatName == "AUTOEXTINGUISHER" then
						fireRepairTime = fireRepairTime - upgradeStatValue
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					elseif upgradeStatName == "AUTOREPAIR" then
						turretRepairTime = turretRepairTime - upgradeStatValue
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					elseif upgradeStatName == "FIRERESISTANCE" then
						fireDamage = fireDamage - upgradeStatValue
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					elseif upgradeStatName == "PROJECTILESPEED" then
						projectileSpeed = projectileSpeed * (1 + upgradeStatValue)
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					elseif upgradeStatName == "SPOTTING" then
						viewRange = viewRange * (1 + upgradeStatValue)
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					elseif upgradeStatName == "FREETREAD" then
						additionalTreadsCount = additionalTreadsCount + upgradeStatValue
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					elseif upgradeStatName == "FREEEXTINGUISHER" then
						additionalExtinguisherCount = additionalExtinguisherCount + upgradeStatValue
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					elseif upgradeStatName == "PARTSGAIN" then
						driver.serverUserData.currentTankData.additionalPartsGain = upgradeStatValue
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					elseif upgradeStatName == "SILVERGAIN" then
						driver.serverUserData.currentTankData.additionalSilverGain = upgradeStatValue
						print(id .. " " .. upgradeStatName .. " applied for " .. driver.name)
					end
				end 
			end
		end 
	end	
	
	viewRange = math.ceil(viewRange)
	
	if driver:IsA("Player") then
		Events.Broadcast("SET_CONSUMABLES", driver, additionalTreadsCount, additionalExtinguisherCount)
	end
	
	print("ALL MODS APPLIED TO " .. driver.name)
				
end

function ApplyDamage(object, enemy, attackData, amount)
	--if object:IsA("AIPlayer") then
	--	object:ApplyDamage(attackData)
	--else
		COMBAT.ApplyDamage(attackData)
	--end
	--[[if enemy:IsA("AIPlayer") then
		enemy:AddResource("TankDamage", CoreMath.Round(amount))
	end]]--
end

function OnDeath(player, damage)
	
	if bindingPressedListener then
		bindingPressedListener:Disconnect()
	end
	
	if diedEventListener then
		diedEventListener:Disconnect()
	end
	
	if checkStuckTankTask then
		checkStuckTankTask:Cancel()
	end
	
	local tankPosition = hitbox:GetWorldPosition()
	local tankRotation = hitbox:GetWorldRotation()
	
	if driver:IsA("Player") then
		driver:Detach()
	elseif driver:IsA("AIPlayer") then
		driver:Destroy(chassis)
	end
	hitbox:Destroy()
	chassis:Destroy()
	driver.isCollidable = true
	script:SetNetworkedCustomProperty("TankReady", false)
	
	local destroyedTank = World.SpawnAsset(destroyedTankTempate, {parent = tankGarage, position = tankPosition, rotation = tankRotation})

	if driver:IsA("Player") then
		driver:AttachToCoreObject(destroyedTank)
	end

	destroyedTank.lifeSpan = 15

	Task.Wait()
	
	if Object.IsValid(driver) then
		driver:ResetVelocity()
		driver:AttachToCoreObject(destroyedTank)
	end
	
end

function OnDestroy(object)
	
	if destroyedListener then
		destroyedListener:Disconnect()
		destroyedListener = nil
	end
	
	if bindingPressedListener then
		bindingPressedListener:Disconnect()
		bindingPressedListener = nil
	end
	
	if diedEventListener then
		diedEventListener:Disconnect()
		diedEventListener = nil
	end
	
	if consumableListener then
		consumableListener:Disconnect()
		consumableListener = nil
	end
	
	for _, a in pairs(armorImpactListeners) do
		a:Disconnect()
		a = nil
	end
	
	for _, a in pairs(armorReleaseListeners) do
		a:Disconnect()
		a = nil
	end
	
	if Object.IsValid(hitbox) then
		hitbox:Destroy()
	end
	if Object.IsValid(chassis) then
		chassis:Destroy()
	end

end

function OnBindingPressed(player, binding)
	
	if player ~= driver then
		return
	end
	
	if binding == "ability_primary" and not player:IsBindingPressed("ability_extra_14") then
		FireProjectile(player)
	elseif binding == "ability_extra_40" and Environment.IsMultiplayerPreview() then
		driver:Die()
	end


end


function HandleAITankShot(aiDriver)
	if aiDriver ~= driver then return end
	--print("Firing tank", aiDriver)
	FireProjectile(aiDriver)
end


function HandleAITankAim(aiDriver, pos)
	if aiDriver ~= driver then return end
	target:SetWorldPosition(pos)
end



function FireProjectile(player)

	if reloading or barrelDown or (player ~= driver) then
		return
	end
	
	reloading = true

	local aimVector = muzzle:GetWorldRotation() * Vector3.FORWARD
	if player:IsA("AIPlayer") then
		local targetPos = target:GetWorldPosition() + Vector3.UP * math.random(75, 150)
		local targetAimVector = (targetPos - muzzle:GetWorldPosition()):GetNormalized()
		aimVector.z = targetAimVector.z 
	end

	local firedProjectile = Projectile.Spawn(projectile, cannon:GetWorldPosition(), aimVector)
	firedProjectile.speed = 0
	
	if player:IsA("Player") then
		firedProjectile.owner = player
	else
		firedProjectile.serverUserData.owner = player
	end
	firedProjectile.gravityScale = 0
	firedProjectile.lifeSpan = 5
	firedProjectile.capsuleRadius = projectileRadius 
	firedProjectile.capsuleLength = projectileLength * 7
	
	firedProjectile.lifeSpanEndedEvent:Connect(ProjectileExpired)
	firedProjectile.impactEvent:Connect(ProjectileImpacted)
	
	Task.Wait()
	
	--firedProjectile.shouldDieOnImpact = true
	firedProjectile.speed = projectileSpeed
	firedProjectile.serverUserData.dataSet = true
	
	Events.BroadcastToAllPlayers("ANIMATE_FIRING", player.id, reloadTime)

	--#TODO This should be tied into the constants file
	player:AddResource("TOTALSHOTSFIRED", 1)
	Task.Wait(reloadTime + 0.1)
	
	reloading = false

end

function ProjectileImpacted(expiredProjectile, other)

	if other.type == "TreadedVehicle" or other.type == "Vehicle" then
		if other == driver.serverUserData.currentTankData.chassis then
			return
		end
	end
    
    expiredProjectile.speed = 0
    ProjectileExpired(expiredProjectile)
    expiredProjectile.lifeSpan = 0.5

	--[[
	if not other:IsA("Vehicle") or expiredProjectile.serverUserData.hitOnce or (other.driver == driver) or (other.serverUserData.owner == driver) then
		return
	end
--print("damage stuff")
	
	expiredProjectile.serverUserData.hitOnce = true
	
	local potentialDamage = driver.serverUserData.currentTankData.fullDamage
	local totalDamage = math.floor(potentialDamage - potentialDamage * 0.2)
	local damageDealt = Damage.New(totalDamage)
	
	if driver:IsA("Player") then
		damageDealt.sourcePlayer = driver
	end
	damageDealt.reason = DamageReason.COMBAT
	if not COMBAT then
		other.driver:ApplyDamage(damageDealt)
	else
		local attackData = {
			object = other.driver,
			damage = damageDealt,
			source = driver,
			position = nil,
			rotation = nil,
			tags = {id = "Projectile"}
		}
		ApplyDamage(driver, other.driver, attackData, damageDealt.amount)
	end

	]]
	
end

function ProjectileExpired(expiredProjectile)
	local activeExplosion = World.SpawnAsset(explosion, {position = expiredProjectile:GetWorldPosition()})
	activeExplosion.lifeSpan = 6
	
end

function OnArmorHit(trigger, other)	
	if other.type == "Projectile" then
		local count = 0
		
		while Object.IsValid(other) and not other.serverUserData.dataSet and (count <= PROJECTILE_WAIT_LIMIT) do
			Task.Wait()
			count = count + 1
		end
		
		if not Object.IsValid(other) then
			return
		end
				
        local enemyPlayer = other.owner -- for player
		if not other.owner and other.serverUserData.owner then -- for bot
			--enemyPlayer = AIPlayer.FindAIDriver(other)
			enemyPlayer = other.serverUserData.owner
		end
		
		if not enemyPlayer or other.serverUserData.hitOnce or enemyPlayer == driver then -- if projectile is marked or does not have owner yet
--print("enemy player could not be identified")
			return
		end
		
		--print("Armor hit")
		other.serverUserData.hitOnce = true
		other.speed = 0
		other.capsuleRadius = 0
		other.capsuleLength = 0
		other.lifeSpan = 0.1
				
		if not enemyPlayer or not enemyPlayer.serverUserData.currentTankData or enemyPlayer.team == driver.team then
--print("enemy not valid")
--print(enemyPlayer)
--print(enemyPlayer.serverUserData)
--print(enemyPlayer.serverUserData.currentTankData)
--print(enemyPlayer.team, driver.team)
			return
		end
		
		local armorValue = trigger:GetCustomProperty("ArmorValue")
		local potentialDamage = enemyPlayer.serverUserData.currentTankData.fullDamage
		local totalDamage = math.floor(potentialDamage - potentialDamage * armorValue)
		local damageDealt = Damage.New(totalDamage)

		if enemyPlayer:IsA("Player") then
			damageDealt.sourcePlayer = enemyPlayer
		end
		damageDealt.reason = DamageReason.COMBAT
		
		if not COMBAT then
			driver:ApplyDamage(damageDealt)
		else
			local attackData = {
				object = driver,
				damage = damageDealt,
				source = enemyPlayer,
				position = nil,
				rotation = nil,
				tags = {id = "Projectile"}
			}
			
			ApplyDamage(enemyPlayer, driver, attackData, damageDealt.amount)
			
--print(enemyPlayer.name .. " dealing " .. tostring(totalDamage) .. "to" .. driver.name)
		end
		
        local dmgPercent = totalDamage / potentialDamage

        -- #FIXME => Need to add template refs
        if dmgPercent >= 0.8 then
            World.SpawnAsset(TankImpact_1, {position = other:GetWorldPosition()})
        elseif dmgPercent < 0.8 and dmgPercent >= 0.5 then
            World.SpawnAsset(TankImpact_2, {position = other:GetWorldPosition()})
        elseif dmgPercent < 0.5 and dmgPercent >= 0.3 then
            World.SpawnAsset(TankImpact_3, {position = other:GetWorldPosition()})
        else
            World.SpawnAsset(TankImpact_4, {position = other:GetWorldPosition()})
        end

		local armorName = trigger.name
		
		if armorName == "LEFTTRACK" or armorName == "RIGHTTRACK" then
			armorName = "TRACK"
		end

		if enemyPlayer:IsA("Player") then
			Events.BroadcastToPlayer(enemyPlayer, "ShowDamageFeedback", totalDamage, armorName, trigger:GetWorldPosition(), driver.id)
		else

		end
		if driver:IsA("Player") then
			Events.BroadcastToPlayer(driver, "ShowHitFeedback", totalDamage, armorName, trigger:GetWorldPosition())
		end
		
		local possibleDamageState = math.random(100)
		
		if tonumber(enemyPlayer.serverUserData.currentTankData.id) == 26 then
			if possibleDamageState > FIAT_DAMAGE_STATE_CHANCE then
				return
			end
		else 
			if possibleDamageState > STANDARD_DAMAGE_STATE_CHANCE then
				return
			end		
		end
		
		if string.find(trigger.name, "TRACK") and not trackTask then
			if trigger.name == "LEFTTRACK" then
				trackStatus = 1	
			elseif trigger.name == "RIGHTTRACK" then
				trackStatus = 2
			end

			if Object.IsValid(driver) then
				Events.Broadcast("PlayerTrackedTank", driver)
			end

			trackTask = Task.Spawn(OnTracked, 0)
			if enemyPlayer:IsA("Player") then
				Events.BroadcastToPlayer(enemyPlayer, "INFLICTED_STATE", "TRACK")
			end
		elseif armorName == "HULLREAR" and not burnTask then
			playerWhoBurned = enemyPlayer

			if Object.IsValid(driver) then
				Events.Broadcast("PlayerBurntTank", driver)
			end

			burnTask = Task.Spawn(OnBurning, 0)
			if enemyPlayer:IsA("Player") then
				Events.BroadcastToPlayer(enemyPlayer, "INFLICTED_STATE", "FIRE")
			end
		elseif string.find(armorName, "TURRET") and not turretDamagedTask then
			local pickTurretDamage = math.random(100)
			if pickTurretDamage <= 50 then

				if Object.IsValid(driver) then
					Events.Broadcast("PlayerDamageTurret", driver)
				end

				turretDamagedTask = Task.Spawn(OnDamagedTurret, 0)
				if enemyPlayer:IsA("Player") then
					Events.BroadcastToPlayer(enemyPlayer, "INFLICTED_STATE", "TURRET")
				end
			else 

				if Object.IsValid(driver) then
					Events.Broadcast("PlayerDamageBarrel", driver)
				end

				turretDamagedTask = Task.Spawn(OnDamagedBarrel, 0)
				if enemyPlayer:IsA("Player") then
					Events.BroadcastToPlayer(enemyPlayer, "INFLICTED_STATE", "BARREL")
				end
			end
		end
	elseif other.type == "TreadedVehicle" or other.type == "Vehicle" then
		vehicleCollideCount = vehicleCollideCount + 1
		
		local otherIsAI = false
		local enemyPlayer = other.driver
		if enemyPlayer == nil then
			enemyPlayer = AIPlayer.FindAIDriver(other)
			otherIsAI = true
		end
		local armorName = trigger.name
		
		if armorName == "LEFTTRACK" or armorName == "RIGHTTRACK" or enemyPlayer == nil or enemyPlayer.team == driver.team then
			return
		end
	
		local otherVehicleSpeed = other:GetVelocity().size
		local thisVehicleSpeed = chassis:GetVelocity().size
		
		
		local otherRotation = other:GetWorldRotation().z 
		local thisRotation = chassis:GetWorldRotation().z
		
		local rotationDifference = math.abs(otherRotation - thisRotation)
		
		local netSpeed = 0
		
		--print(rotationDifference)
		
		if rotationDifference < 90 then
			netSpeed =math.abs(otherVehicleSpeed - thisVehicleSpeed)
			--print("collision angle less than 90")
		else 
			netSpeed = otherVehicleSpeed + thisVehicleSpeed
			--print("collision angle more than 90")
		end
		
		if netSpeed < 400 then
			return
		end
		
		if ramCooldown then
			return
		end
		
		ramCooldown = true
		local cooldownTask = Task.Spawn(ResetRamCooldown)
		
		local ramDamage = ((netSpeed + other.mass * 0.03) * thisVehicleSpeed) / (50 * (thisVehicleSpeed + 1)) + 20
		
		if armorName == "HULLFRONT" then
			ramDamage = ramDamage/4
		end
		
		ramDamage = math.floor(ramDamage)
		
		local damageDealt = Damage.New(ramDamage)
		
		if not otherIsAI then
			damageDealt.sourcePlayer = enemyPlayer
		end
		damageDealt.reason = DamageReason.COMBAT
		--driver:ApplyDamage(damageDealt)


		if Object.IsValid(driver) then
			Events.Broadcast("PlayerRammedTank", playerWhoBurned)
		end
		
		if driver:IsA("Player") then
			damageDealt.sourcePlayer = driver
		end
		damageDealt.reason = DamageReason.COMBAT
		
		if not COMBAT then
			driver:ApplyDamage(damageDealt)	
		else 
			local attackData = {
				object = enemyPlayer,
				damage = damageDealt,
				source = driver,
				position = nil,
				rotation = nil,
				tags = {id = "Ram"}
			}
			ApplyDamage(driver, enemyPlayer, attackData, damageDealt.amount)
			   
		
	   	end
	   	
		if enemyPlayer:IsA("Player") then
			Events.BroadcastToPlayer(enemyPlayer, "ShowDamageFeedback", ramDamage, armorName, trigger:GetWorldPosition(), driver.id)
	  	end
	  	if driver:IsA("Player") then
			Events.BroadcastToPlayer(driver, "ShowHitFeedback", ramDamage, armorName, trigger:GetWorldPosition())
		end
		
		if otherVehicleSpeed > thisVehicleSpeed then
			return
		end
		
		local possibleDamageState = math.random(100)
				
		if possibleDamageState > REAR_END_FIRE_CHANCE then
			return
		end		
		
		if armorName == "HULLREAR" and not burnTask then
			playerWhoBurned = enemyPlayer
			burnTask = Task.Spawn(OnBurning, 0)
			--#TODO Currently only players can get caught on fire - Morticai
			if enemyPlayer:IsA("Player") and driver:IsA("Player") then
				Events.BroadcastToPlayer(driver, "INFLICTED_STATE", "FIRE")
			end
		end
	end
	
end

function OnArmorRelease(trigger, other)
	
	if other.type == "TreadedVehicle" or other.type == "Vehicle" then
		vehicleCollideCount = vehicleCollideCount - 1
	end
end

function ResetRamCooldown()

	Task.Wait(1)
	ramCooldown = false
		
end

function OnConsumableUsed(consumableType)

	if consumableType == "TRACK" then
		if trackTask then
			trackTask:Cancel()
		end
		
		driver.movementControlMode = MovementControlMode.FACING_RELATIVE
		script:SetNetworkedCustomProperty("Tracked", 0)
		trackStatus = 0
		Events.Broadcast("ToggleConsumable", driver, "TRACK", false)
		
		Task.Wait(2)
		
		trackTask = nil
	elseif consumableType == "EXTINGUISH" then
		if burnTask then
			burnTask:Cancel()
		end	
		
		script:SetNetworkedCustomProperty("Burning", false)
		playerWhoBurned = nil
		Events.Broadcast("ToggleConsumable", driver, "EXTINGUISH", false)
		chassis.maxSpeed = originalSpeed
		
		Task.Wait(2)
		
		burnTask = nil

	elseif consumableType == "TURRET" then
		if turretDamagedTask then
			turretDamagedTask:Cancel()
		end	
		
		script:SetNetworkedCustomProperty("TurretDown", false)
		script:SetNetworkedCustomProperty("BarrelDown", false)
		turret:LookAtContinuous(target, true, traverseSpeed/57)
		turretDown = false
		barrelDown = false
		Events.Broadcast("ToggleConsumable", driver, "TURRET", false)
		
		Task.Wait(2)
		
		turretDamagedTask = nil
	end

end

function OnTracked()
	Events.Broadcast("ToggleConsumable", driver, "TRACK", true)
	script:SetNetworkedCustomProperty("Tracked", trackStatus)
	driver.movementControlMode = MovementControlMode.NONE
	
	Task.Wait(treadRepairTime)
	
	driver.movementControlMode = MovementControlMode.FACING_RELATIVE
	script:SetNetworkedCustomProperty("Tracked", 0)
	Events.Broadcast("ToggleConsumable", driver, "TRACK", false)
	
	Task.Wait(2)
	
	trackStatus = 0
	trackTask = nil
	
end

function OnBurning()

	script:SetNetworkedCustomProperty("Burning", true)
	Events.Broadcast("ToggleConsumable", driver, "EXTINGUISH", true)
	chassis.maxSpeed = math.floor(originalSpeed/2)


	for i = fireRepairTime, 1, -1 do
		if driver.isDead then break end

		local damageDealt = Damage.New(fireDamage)
	
		if playerWhoBurned:IsA("Player") then
			damageDealt.sourcePlayer = playerWhoBurned
		end
		damageDealt.reason = DamageReason.COMBAT
		--driver:ApplyDamage(damageDealt)

		local attackData = {
			object = driver,
			damage = damageDealt,
			source = playerWhoBurned,
			position = nil,
			rotation = nil,
			tags = {id = "Burning"}
		}
		
		ApplyDamage(driver, playerWhoBurned, attackData, damageDealt.amount)
		   
	
		Task.Wait(1)
	end
	
	script:SetNetworkedCustomProperty("Burning", false)
	Events.Broadcast("ToggleConsumable", driver, "EXTINGUISH", false)
	if Object.IsValid(chassis) then
		chassis.maxSpeed = originalSpeed
	end
	
	Task.Wait(2)
	
	playerWhoBurned = nil
	burnTask = nil
	
end

function OnDamagedTurret()
	
	script:SetNetworkedCustomProperty("TurretDown", true)
	Events.Broadcast("ToggleConsumable", driver, "TURRET", true)
	turretDown = true
	
	if horizontalCannonAngles <= 0 then
		turret:LookAtContinuous(target, true, traverseSpeed/(57 * 5))
	end
	
	Task.Wait(turretRepairTime)
	
	if horizontalCannonAngles <= 0 then
		turret:LookAtContinuous(target, true, traverseSpeed/57)
	end
	
	script:SetNetworkedCustomProperty("TurretDown", false)
	Events.Broadcast("ToggleConsumable", driver, "TURRET", false)
	turretDown = false
	
	Task.Wait(2)
	
	turretDamagedTask = nil

end

function OnDamagedBarrel()

	script:SetNetworkedCustomProperty("BarrelDown", true)
	Events.Broadcast("ToggleConsumable", driver, "TURRET", true)
	barrelDown = true
	
	Task.Wait(turretRepairTime)
		
	script:SetNetworkedCustomProperty("BarrelDown", false)
	Events.Broadcast("ToggleConsumable", driver, "TURRET", false)
	barrelDown = false
	Task.Wait(2)
	
	turretDamagedTask = nil
	
end

function AdjustTurretAim()
	if not Object.IsValid(target) then
		return
	end
	
	local viewPosition = driver:GetViewWorldPosition()
	local viewRotation = driver:GetViewWorldRotation()
	local differenceZ = math.abs(viewRotation.z - turret:GetWorldRotation().z) % 360
	
	if differenceZ > 180 then
		differenceZ = 360 - differenceZ
	end

	target:MoveTo(RaycastResultFromPointRotationDistance(viewPosition, viewRotation, 100000), 0.01, false)
	
	if not Object.IsValid(cannon) or not Object.IsValid(cannonGuide) then
		return
	end
	
	local targetRotation = cannonGuide:GetRotation()
	local currentRotation = cannon:GetRotation()

	if targetRotation.y > maxElevationAngle then
		targetRotation.y = maxElevationAngle
	elseif targetRotation.y < minDepressionAngle then
		targetRotation.y = minDepressionAngle
	end
	
	local distance = math.abs(targetRotation.y - currentRotation.y) + 0.1
	
	if Object.IsValid(turret) and Object.IsValid(cannon) then
	
		if horizontalCannonAngles <= 0 then
			cannon:RotateTo(Rotation.New(0, targetRotation.y, 0), differenceZ / traverseSpeed, true) -- distance / elevationSpeed
		else
		
			if targetRotation.z > horizontalCannonAngles then
				targetRotation.z = horizontalCannonAngles
			elseif targetRotation.z < -horizontalCannonAngles then
				targetRotation.z = -horizontalCannonAngles
			end
			local distance = math.abs(math.sqrt((targetRotation.y - currentRotation.y) ^ 2 + (targetRotation.z - currentRotation.z) ^ 2)) + 0.1
			if not turretDown then
				cannon:RotateTo(Rotation.New(0, targetRotation.y, targetRotation.z), distance / elevationSpeed, true)
			else
				cannon:RotateTo(Rotation.New(0, targetRotation.y, targetRotation.z), distance / elevationSpeed * 0.2, true)
			end
		end
		
	end
	
end

function SaveRollbackPosition()
	
	lastRollbackPosition = lastRollbackPosition + 1
	
	if lastRollbackPosition > MAX_ROLLBACK_COUNT then
		lastRollbackPosition = 1
	end
	
	rollbackTable[lastRollbackPosition] = {chassis:GetWorldPosition(), chassis:GetWorldRotation()}

end

function GetRollbackPosition()
	
	lastRollbackPosition = lastRollbackPosition - 1
	
	if lastRollbackPosition < 1 then
		lastRollbackPosition = MAX_ROLLBACK_COUNT
	end
	
	return rollbackTable[lastRollbackPosition]

end

function GetAngleDifference(vec1, vec2)

	return 57.3 * math.acos((vec1.x * vec2.x + vec1.y * vec2.y + vec1.z * vec2.z) / (vec1.size * vec2.size))
	
end

function CheckInput()

	local checkInput = driver:IsBindingPressed("ability_extra_21") and not driver:IsBindingPressed("ability_extra_31")
	checkInput = checkInput or (not driver:IsBindingPressed("ability_extra_21") and driver:IsBindingPressed("ability_extra_31"))
	checkInput = checkInput and not driver:IsBindingPressed("ability_extra_17")
	
	--[[
	if chassis.type == "TreadedVehicle" then
		checkInput = checkInput or (driver:IsBindingPressed("ability_extra_30") and not driver:IsBindingPressed("ability_extra_32"))
		checkInput = checkInput or (not driver:IsBindingPressed("ability_extra_30") and driver:IsBindingPressed("ability_extra_32"))
	end
	]]
	
	if not checkInput then
		return true
	elseif (chassis:GetVelocity().size > MIN_NOT_STUCK_VELOCITY) then
		SaveRollbackPosition()
		return true
	else 
		return false
	end
	
end

function CheckStuckTank()

	if not Object.IsValid(chassis) or not Object.IsValid(driver) or driver:IsA("AIPlayer") or (trackStatus > 0) or (vehicleCollideCount > 0) then return end
	
	for i = 1, 10 do
		if CheckInput() then
			return
		end
		Task.Wait(0.1)
	end

	
	local currentVector = chassis:GetWorldRotation() * Vector3.FORWARD
	local idealVector = Rotation.New(0, 0, chassis:GetWorldRotation().z) * Vector3.FORWARD
	
--print("rotation difference: " .. tostring(GetAngleDifference(currentVector, idealVector)))
		
	if GetAngleDifference(currentVector, idealVector) < MAX_NOT_FLIPPED_ANGLE then -- rollback mode
		local rollbackPosition = GetRollbackPosition()
		
		if not rollbackPosition then return end
		
		local currentPosition = {chassis:GetWorldPosition(), chassis:GetWorldRotation()}
		
		--[[
		for i = 1, 10 do
			chassis:SetWorldPosition(Vector3.Lerp(currentPosition[1], (rollbackPosition[1] + Vector3.UP * 10), i / 10))
			Task.Wait(0.1)
		end
		]]
		
		chassis:SetWorldPosition(rollbackPosition[1] + Vector3.UP * 10)
		chassis:SetWorldRotation(rollbackPosition[2])
		
		return
	else -- correct angle and add impulse mode
		chassis:SetWorldPosition(chassis:GetWorldPosition() + Vector3.UP * 10)
		
		Task.Wait()
		
		chassis:AddImpulse(chassis:GetWorldRotation() * Vector3.UP * 1200 * chassis.mass)
		chassis:SetWorldRotation(Rotation.New(0, 0, chassis:GetWorldRotation().z))
	end
	
end


function Tick()
	
	if Object.IsValid(hitbox) and Object.IsValid(driver) then
		
		if chassis.mass >= 50000 then
			local currentRotation = chassis:GetWorldRotation()
			if math.abs(currentRotation.x) >= 10 or math.abs(currentRotation.y) >= 10 then
				if chassis.maxSpeed == originalSpeed then
					chassis.maxSpeed = originalSpeed * 1.2
					chassis.tireFriction = originalFriction * 2
					chassis.accelerationRate = originalAcceleration * 1.40
					--print("boosting tank")
				end
			elseif math.abs(currentRotation.x) < 10 or math.abs(currentRotation.y) < 10 then
				if chassis.maxSpeed > originalSpeed then
					chassis.maxSpeed = originalSpeed
					chassis.tireFriction = originalFriction
					chassis.accelerationRate = originalAcceleration
					--print("Restoring tank stats")
				end
			end
			
			if not driver:IsBindingPressed("ability_extra_21") and not driver:IsBindingPressed("ability_extra_31") then 
				if chassis.turnSpeed == originalTurnSpeed then
					chassis.turnSpeed = math.floor(originalTurnSpeed * 1.1)
					--print("boosting turn speed")
				end
			elseif driver:IsBindingPressed("ability_extra_21") or driver:IsBindingPressed("ability_extra_31") then 
				if chassis.turnSpeed > originalTurnSpeed then
					chassis.turnSpeed = originalTurnSpeed
					--print("Restoring turn speed")
				end
			end
		end
	
		if not driver:IsBindingPressed("ability_secondary") then
			AdjustTurretAim()
		end
		
		if allowHoldDownFiring and driver:IsBindingPressed("ability_primary") then
			FireProjectile(driver)
		end

		--[[
	    local angularVelo = chassis:GetAngularVelocity()
	    if angularVelo.sizeSquared > MAX_ANGULAR_VELOCITY * MAX_ANGULAR_VELOCITY then
	      chassis:SetAngularVelocity(angularVelo:GetNormalized() * MAX_ANGULAR_VELOCITY)
	    end
	    ]]
    		
		if driver:IsBindingPressed("ability_extra_21") then -- W
			script:SetNetworkedCustomProperty("WheelSpeedMultiplier", 1)
		elseif driver:IsBindingPressed("ability_extra_31") then -- S
			script:SetNetworkedCustomProperty("WheelSpeedMultiplier", -1)
		end
		
	end
	
end


destroyedListener = script.destroyEvent:Connect(OnDestroy)
Events.Connect("AI_Tankshot", HandleAITankShot)
Events.Connect("AI_TankAim", HandleAITankAim)

