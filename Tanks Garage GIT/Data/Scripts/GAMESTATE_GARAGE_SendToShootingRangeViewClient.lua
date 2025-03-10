local CONSTANTS_API = require(script:GetCustomProperty("MetaAbilityProgressionConstants_API"))
local Ease3D = require(script:GetCustomProperty("Ease3D"))
local API_Tutorial = require(script:GetCustomProperty("API_Tutorial"))
local _Constants_API = require(script:GetCustomProperty("Constants_API"))
local TanksAPI = _Constants_API:WaitForConstant("Tanks")

local mainManagerServer = script:GetCustomProperty("GAMESTATE_MainManagerServer"):WaitForObject()
local overrideCamera = script:GetCustomProperty("OverrideCamera"):WaitForObject()
local sendToShootingRangeViewUI = script:GetCustomProperty("SendToShootingRangeViewUI"):WaitForObject()
local blackScreen = script:GetCustomProperty("BlackScreen"):WaitForObject()
local door = script:GetCustomProperty("Door"):WaitForObject()
local equippedTankInGarage = script:GetCustomProperty("EquippedTankInGarage"):WaitForObject()
local returnToGarageTrigger = script:GetCustomProperty("ReturnToGarageTrigger"):WaitForObject()
local spawnLocation = script:GetCustomProperty("SpawnOutsideGarageLocation"):WaitForObject()
local mainUI = script:GetCustomProperty("MainUI"):WaitForObject()
local Spotlight = script:GetCustomProperty("Spotlight"):WaitForObject()
local SFX1 = script:GetCustomProperty("SFX1"):WaitForObject()
local SFX2 = script:GetCustomProperty("SFX2"):WaitForObject()
local SFX3 = script:GetCustomProperty("SFX3"):WaitForObject()
local SFXStinger1 = script:GetCustomProperty("SFXStinger1"):WaitForObject()
local SFXMusic = script:GetCustomProperty("SFXMusic"):WaitForObject()
local defaultSkins = script:GetCustomProperty("DefaultSkins"):WaitForObject()
local returnToGarage = script:GetCustomProperty("ReturnToGarage"):WaitForObject()
local TutorialFinishedPopup = script:GetCustomProperty("TutorialFinishedPopup")
local JoinBattle = script:GetCustomProperty("JoinBattle"):WaitForObject()
local Tutorial_JoinBattlePanel = script:GetCustomProperty("Tutorial_JoinBattlePanel"):WaitForObject()
local TutorialCompletePopupNoReward = script:GetCustomProperty("TutorialCompletePopupNoReward")

local thisComponent = "SHOOTING_RANGE"

local localPlayer = Game.GetLocalPlayer()
local spamPrevent = false

local garageModel = {}
local garageModelWheels = nil

local rememberSlot = nil

function CheckPlayerIsInState(state)

	local property = nil
	
	if not rememberSlot then

		for i = 1, 16 do 
			property = mainManagerServer:GetCustomProperty("P" .. tostring(i))
			if string.find(property, localPlayer.id) then
				rememberSlot = "P" .. tostring(i)
				if string.find(property, state) then
					return true
				else 
					return false	
				end
			end
		end
		
	else 
		property = mainManagerServer:GetCustomProperty(rememberSlot)
		
		if string.find(property, localPlayer.id) then	
			if string.find(property, state) then
				return true	
			else 
				return false	
			end
		end
	end

end

function SendBackToGarage(trigger, other)

	if other ~= localPlayer and not other:IsA("Vehicle") then
		return
	end
		
	if other:IsA("Vehicle") then
		other = other.driver
	end
	
	if other ~= localPlayer then
		return
	end
	
	if sendToShootingRangeViewUI.isEnabled then
		return
	end
	
	sendToShootingRangeViewUI.isEnabled = true
	returnToGarage.visibility = Visibility.FORCE_OFF
	JoinBattle.visibility = Visibility.FORCE_OFF
	
	Ease3D.EasePosition(door, Vector3.UP * 850, 2, Ease3D.EasingEquation.QUADRATIC, Ease3D.EasingDirection.OUT)
	SFX1:Play()
	Task.Wait(0.2)
	SFX2:Play()
	Task.Wait(1.4)
	SFX3:Play()
	
	Task.Wait(1)
	
	for i = 1, 100 do 
		
		blackScreen:SetColor(Color.New(0, 0, 0, i/100))
			
		Task.Wait(0.01)
			
	end
				
	while not CheckPlayerIsInState("GARAGE_STATE") do 
		Events.BroadcastToServer("PlayerStateChanged", "GARAGE_STATE")
		Task.Wait(1)	
	end
	
	door:SetPosition(Vector3.ZERO)
	
	SFXMusic:Play()
	Spotlight.visibility = Visibility.FORCE_ON
	equippedTankInGarage.visibility = Visibility.INHERIT
	
	Task.Wait(2)
				
	for i = 100, 1, -1 do 
		blackScreen:SetColor(Color.New(0, 0, 0, i/100))	
		Task.Wait(0.01)	
	end
	
	sendToShootingRangeViewUI.isEnabled = false	
	
end

function ResetComponent()

	equippedTankInGarage:SetPosition(Vector3.ZERO)

end


function ToggleThisComponent(requestedPlayerState)

	if requestedPlayerState == thisComponent then
		localPlayer.clientUserData.isInGarage = false
		local secondarySFX = localPlayer.clientUserData.garageModel.reference:FindDescendantByName("TankEngineLoopSFX")
		secondarySFX:Play()
	
		mainUI.visibility = Visibility.FORCE_OFF
		SFXMusic:Stop()
		SFXStinger1:Play()

		Task.Wait(2.5)

		localPlayer:SetOverrideCamera(overrideCamera)
		
		Ease3D.EasePosition(equippedTankInGarage, Vector3.FORWARD * 2000, 4, Ease3D.EasingEquation.QUADRATIC, Ease3D.EasingDirection.IN)
		
		Ease3D.EasePosition(door, Vector3.UP * 850, 2, Ease3D.EasingEquation.QUADRATIC, Ease3D.EasingDirection.OUT)
		SFX1:Play()
		Task.Wait(0.2)
		SFX2:Play()
		Task.Wait(1.4)
		SFX3:Play()
		
		Task.Wait(1)
		
		blackScreen:SetColor(Color.New(0, 0, 0, 0))
	
		sendToShootingRangeViewUI.isEnabled = true
				
		for i = 1, 100 do 
		
			blackScreen:SetColor(Color.New(0, 0, 0, i/100))
			
			Task.Wait(0.01)
			
		end
		
		Spotlight.visibility = Visibility.FORCE_OFF
		equippedTankInGarage.visibility = Visibility.FORCE_OFF
				
		while not CheckPlayerIsInState("SHOOTING_RANGE_STATE") do 
		
			Events.BroadcastToServer("PlayerStateChanged", "SHOOTING_RANGE_STATE")
		
			Task.Wait(0.1)
			
		end
		
		--localPlayer:ClearOverrideCamera()
		
		--[[
		while (localPlayer:GetWorldPosition() - spawnLocation:GetWorldPosition()).size > 100 do -- wait for respawn.
		
			Task.Wait(0.1)
			
		end
		]]
		
		Task.Wait(2) -- wait for tank to settle.
		
		for i = 100, 1, -1 do 
		
			blackScreen:SetColor(Color.New(0, 0, 0, i/100))
			
			Task.Wait(0.01)
			
		end
		
		Ease3D.EasePosition(door, Vector3.ZERO, 2, Ease3D.EasingEquation.QUADRATIC, Ease3D.EasingDirection.IN)
		SFX1:Play()
		Task.Wait(0.2)
		SFX2:Play()
		Task.Wait(1.4)
		SFX3:Play()
		
		sendToShootingRangeViewUI.isEnabled = false
		returnToGarage.visibility = Visibility.FORCE_ON
		
		if(localPlayer:GetResource(API_Tutorial.GetTutorialResource()) >= API_Tutorial.TutorialPhase.JoinBattle) then
			JoinBattle.visibility = Visibility.FORCE_ON
		end
		
		secondarySFX:Stop()
		
	else 
	
		ResetComponent()
				
	end
	
end

function ChangeGarageModel(id) 
	if not id or id == "" then return end
	for i, child in ipairs(equippedTankInGarage:GetChildren()) do
		if(string.match(child.name, "SKIN") and Object.IsValid(child)) then
			child:Destroy()
		end
	end
	
	SetGarageModelFromEquippedTank(localPlayer, id)
		
	local newModel = World.SpawnAsset(garageModel, {parent = equippedTankInGarage})	
	local modelSFX = newModel:FindDescendantsByType("Audio")
	
	local wheels = newModel:FindDescendantByName("WHEEL_SET")
	
	if Object.IsValid(wheels) then
		wheels.visibility = Visibility.INHERIT
	end
		
	for _, s in ipairs(modelSFX) do
		s:Stop()
	end
	
	local vehicleIDString = tostring(id)
	
	if tonumber(id) < 10 and not string.find(vehicleIDString, "0") then
		vehicleIDString = "0" .. vehicleIDString
	end	

	if not localPlayer.clientUserData.garageModel then
		localPlayer.clientUserData.garageModel = {}
	end
	
	localPlayer.clientUserData.garageModel.reference = newModel
	localPlayer.clientUserData.garageModel.id = vehicleIDString
		
	Events.Broadcast("INITIALIZE_SKIN", localPlayer)
	Events.Broadcast("RENEW_SKIN_DATA")
	
end

function SetGarageModelFromEquippedTank(player, tankId)
	 
	local selectedId = tankId

	if not tankId  then
	
		while not player:GetResource(TanksAPI.EquipResource) do
			Task.Wait(0.1)
		end
		
		selectedId = player:GetResource(TanksAPI.EquipResource)
	end
		
	local id = tostring(selectedId)
		
	if tonumber(selectedId) < 10 and not string.find(id, "0") then
		id = "0" .. id
	end
	
	garageModel = defaultSkins:GetCustomProperty(id)
	
	if not garageModel then
		garageModel = defaultSkins:GetCustomProperty("Default")
	end

end

function ToggleGarage(player, binding)

	if binding == "ability_extra_35" and not sendToShootingRangeViewUI.isEnabled and not localPlayer.clientUserData.isInGarage then
		SendBackToGarage(returnToGarageTrigger, localPlayer)
	end
	
	if binding == "ability_extra_34" and localPlayer:GetResource(API_Tutorial.GetTutorialResource()) >= API_Tutorial.TutorialPhase.JoinBattle then
		if spamPrevent then return end		
		if localPlayer:GetResource(API_Tutorial.GetTutorialResource()) == API_Tutorial.TutorialPhase.JoinBattle then
			spamPrevent = true
			Tutorial_JoinBattlePanel:FindDescendantByName("COMPLETION_PANEL").visibility = Visibility.FORCE_ON	
			Tutorial_JoinBattlePanel:FindDescendantByName("Objective_1").text = "Press [G] to join a battle (1/1)"	
			if localPlayer:GetResource(API_Tutorial.GetTutorialRewardResource()) < API_Tutorial.TutorialPhase.JoinBattle then
				local panel = World.SpawnAsset(TutorialFinishedPopup, {parent = World.FindObjectByName("Tutorial UI")})
				panel.lifeSpan = 3
			else
				local panel = World.SpawnAsset(TutorialCompletePopupNoReward, {parent = World.FindObjectByName("Tutorial UI")})
				panel.lifeSpan = 3
			end			
			Task.Wait(2)	
			Tutorial_JoinBattlePanel:FindDescendantByName("COMPLETION_PANEL").visibility = Visibility.FORCE_OFF		
			Events.BroadcastToServer("AdvanceTutorial", API_Tutorial.TutorialPhase.Upgrade, true)	
			Tutorial_JoinBattlePanel:FindDescendantByName("Objective_1").text = "Press [G] to join a battle (0/1)"
		end
		Events.BroadcastToServer("SEND_TO_MAP", "Frontline")
		Task.Wait(2)
		spamPrevent = false
	end
end

function InitializeComponent()

	Task.Wait(1)

	SetGarageModelFromEquippedTank(localPlayer)

	sendToShootingRangeViewUI.visibility = Visibility.INHERIT
	sendToShootingRangeViewUI.isEnabled = false
	
	local newModel = World.SpawnAsset(garageModel, {parent = equippedTankInGarage})	
	local modelSFX = newModel:FindDescendantByName("TankEngineAndMovementLoopSFX")
	local secondarySFX = newModel:FindDescendantByName("TankEngineLoopSFX")
	
	Task.Wait()
	
	if modelSFX then
		modelSFX:Destroy()
	end
	if secondarySFX then
		secondarySFX:Stop()
	end
	
	local wheels = newModel:FindDescendantByName("WHEEL_SET")
	
	if Object.IsValid(wheels) then
		wheels.visibility = Visibility.INHERIT
	end
		
	local vehicleID = localPlayer:GetResource(TanksAPI.EquipResource)
	local vehicleIDString = tostring(vehicleID)
	
	if tonumber(vehicleID) < 10 and not string.find(vehicleIDString, "0") then
		vehicleIDString = "0" .. vehicleIDString
	end	

	if not localPlayer.clientUserData.garageModel then
		localPlayer.clientUserData.garageModel = {}
	end
	
	localPlayer.clientUserData.garageModel.reference = newModel
	localPlayer.clientUserData.garageModel.id = vehicleIDString
	
	Events.Broadcast("SET_SKIN", localPlayer, vehicleID, nil)
		
end

InitializeComponent()

Events.Connect("ENABLE_GARAGE_COMPONENT", ToggleThisComponent)
Events.Connect("CHANGE_EQUIPPED_TANK", ChangeGarageModel)

localPlayer.bindingPressedEvent:Connect(ToggleGarage)
returnToGarageTrigger.beginOverlapEvent:Connect(SendBackToGarage)