--[[
Copyright 2019 Manticore Games, Inc. 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]
-- Internal custom properties
local AS = require(script:GetCustomProperty("API"))
local Constants_API = require(script:GetCustomProperty("Constants_API"))
local COMPONENT_ROOT = script:GetCustomProperty("ComponentRoot"):WaitForObject()
local NAMEPLATE_TEMPLATE = script:GetCustomProperty("NameplateTemplate")
local SEGMENT_SEPARATOR_TEMPLATE = script:GetCustomProperty("SegmentSeparatorTemplate")

-- User exposed properties
local SHOW_NAMES = COMPONENT_ROOT:GetCustomProperty("ShowNames")
local SHOW_HEALTHBARS = COMPONENT_ROOT:GetCustomProperty("ShowHealthbars")
local SHOW_ON_SELF = COMPONENT_ROOT:GetCustomProperty("ShowOnSelf")
local SHOW_ON_TEAMMATES = COMPONENT_ROOT:GetCustomProperty("ShowOnTeammates")
local MAX_DISTANCE_ON_TEAMMATES = COMPONENT_ROOT:GetCustomProperty("MaxDistanceOnTeammates")
local SHOW_ON_ENEMIES = COMPONENT_ROOT:GetCustomProperty("ShowOnEnemies")
local MAX_DISTANCE_ON_ENEMIES = COMPONENT_ROOT:GetCustomProperty("MaxDistanceOnEnemies")
local SHOW_ON_DEAD_PLAYERS = COMPONENT_ROOT:GetCustomProperty("ShowOnDeadPlayers")
local SCALE = COMPONENT_ROOT:GetCustomProperty("Scale")
local SHOW_NUMBERS = COMPONENT_ROOT:GetCustomProperty("ShowNumbers")
local ANIMATE_CHANGES = COMPONENT_ROOT:GetCustomProperty("AnimateChanges")
local CHANGE_ANIMATION_TIME = COMPONENT_ROOT:GetCustomProperty("ChangeAnimationTime")
local SHOW_SEGMENTS = COMPONENT_ROOT:GetCustomProperty("ShowSegments")
local SEGMENT_SIZE = COMPONENT_ROOT:GetCustomProperty("SegmentSize")

-- User exposed properties (colors)
local FRIENDLY_NAME_COLOR = COMPONENT_ROOT:GetCustomProperty("FriendlyNameColor")
local ENEMY_NAME_COLOR = COMPONENT_ROOT:GetCustomProperty("EnemyNameColor")
local BORDER_COLOR = COMPONENT_ROOT:GetCustomProperty("BorderColor")
local BACKGROUND_COLOR = COMPONENT_ROOT:GetCustomProperty("BackgroundColor")
local FRIENDLY_HEALTH_COLOR = COMPONENT_ROOT:GetCustomProperty("FriendlyHealthColor")
local ENEMY_HEALTH_COLOR = COMPONENT_ROOT:GetCustomProperty("EnemyHealthColor")
local DAMAGE_CHANGE_COLOR = COMPONENT_ROOT:GetCustomProperty("DamageChangeColor")
local HEAL_CHANGE_COLOR = COMPONENT_ROOT:GetCustomProperty("HealChangeColor")
local HEALTH_NUMBER_COLOR = COMPONENT_ROOT:GetCustomProperty("HealthNumberColor")

local spottingServer = script:GetCustomProperty("GAMEHELPER_SpottingServer"):WaitForObject()

local TANKS = Constants_API:WaitForConstant("Tanks").GetTanks()

local GameState = nil
local currentGameState = nil
local previousGameState = nil

if script:GetCustomProperty("GameState") then
	GameState = script:GetCustomProperty("GameState"):WaitForObject()
	currentGameState = GameState:GetCustomProperty("GameState")
end

function CheckSpotting(player)
	if Object.IsValid(player) then
		for i = 1, 16 do
			if spottingServer:GetCustomProperty("P" .. tostring(i)) == player.id then
				return true
			end
		end
	end

	return false
end

-- Check user properties
if MAX_DISTANCE_ON_TEAMMATES < 0.0 then
	warn("MaxDistanceOnTeammates cannot be negative")
	MAX_DISTANCE_ON_TEAMMATES = 0.0
end

if MAX_DISTANCE_ON_ENEMIES < 0.0 then
	warn("MaxDistanceOnEnemies cannot be negative")
	MAX_DISTANCE_ON_ENEMIES = 0.0
end

if SCALE <= 0.0 then
	warn("Scale must be positive")
	SCALE = 1.0
end

if CHANGE_ANIMATION_TIME <= 0.0 then
	warn("ChangeAnimationTime must be positive")
	CHANGE_ANIMATION_TIME = 1.0
end

if SEGMENT_SIZE <= 0.0 then
	warn("SegmentSize must be positive")
	SEGMENT_SIZE = 20.0
end

--Constants
-- In units of scale
local BORDER_WIDTH = 0.02
local NAMEPLATE_LAYER_THICKNESS = 0.01 -- To force draw order
local HEALTHBAR_WIDTH = 1.5
local HEALTHBAR_HEIGHT = 0.08

local LOCAL_PLAYER = Game.GetLocalPlayer()

-- Variables
local nameplates = {}

-- Player GetViewedPlayer()
-- Returns which player the local player is spectating (or themselves if not spectating)
function GetViewedPlayer()
	local specatatorTarget = AS.GetSpectatorTarget()

	if AS.IsSpectating() and specatatorTarget then
		return specatatorTarget
	end

	return LOCAL_PLAYER
end

-- nil OnPlayerJoined(Player)
-- Creates a nameplate for the local player to see the target player's status
function OnPlayerJoined(player)
	local nameplateRoot = World.SpawnAsset(NAMEPLATE_TEMPLATE)

	nameplates[player.id] = {}
	nameplates[player.id].templateRoot = nameplateRoot
	nameplates[player.id].borderPiece = nameplateRoot:GetCustomProperty("BorderPiece"):WaitForObject()
	nameplates[player.id].backgroundPiece = nameplateRoot:GetCustomProperty("BackgroundPiece"):WaitForObject()
	nameplates[player.id].healthPiece = nameplateRoot:GetCustomProperty("HealthPiece"):WaitForObject()
	nameplates[player.id].changePiece = nameplateRoot:GetCustomProperty("ChangePiece"):WaitForObject()
	nameplates[player.id].healthText = nameplateRoot:GetCustomProperty("HealthText"):WaitForObject()
	nameplates[player.id].nameText = nameplateRoot:GetCustomProperty("NameText"):WaitForObject()
	nameplates[player.id].tankText = nameplateRoot:GetCustomProperty("TankText"):WaitForObject()

	-- For animating changes. Each change clobbers the previous state.
	nameplates[player.id].lastHealthFraction = 1.0
	nameplates[player.id].lastHealthTime = 0.0
	nameplates[player.id].lastFrameHealthFraction = 1.0

	-- Setup static properties
	if player:IsA("Player") then
		nameplateRoot:AttachToPlayer(player, "nameplate")
		nameplateRoot:SetPosition(Vector3.New(0, 0, 400))
	else
		nameplateRoot.parent = player.tank
		nameplateRoot:SetPosition(Vector3.UP * 800)
	end
	nameplateRoot:SetScale(Vector3.New(SCALE, SCALE, SCALE))
	--nameplateRoot:SetPosition(Vector3.New(0, 0, 400))

	-- Static properties on pieces
	nameplates[player.id].borderPiece:SetScale(
		Vector3.New(NAMEPLATE_LAYER_THICKNESS, HEALTHBAR_WIDTH + 2.0 * BORDER_WIDTH, HEALTHBAR_HEIGHT + 2.0 * BORDER_WIDTH)
	)
	nameplates[player.id].borderPiece:SetPosition(Vector3.New(-4.0 * NAMEPLATE_LAYER_THICKNESS, 0.0, 0.0))
	nameplates[player.id].borderPiece:SetColor(BORDER_COLOR)
	nameplates[player.id].backgroundPiece:SetScale(
		Vector3.New(NAMEPLATE_LAYER_THICKNESS, HEALTHBAR_WIDTH, HEALTHBAR_HEIGHT)
	)
	nameplates[player.id].backgroundPiece:SetPosition(Vector3.New(-3.0 * NAMEPLATE_LAYER_THICKNESS, 0.0, 0.0))
	nameplates[player.id].backgroundPiece:SetColor(BACKGROUND_COLOR)
	nameplates[player.id].healthText:SetPosition(Vector3.New(50.0 * NAMEPLATE_LAYER_THICKNESS, 0.0, 0.0)) -- Text must be 50 units ahead as it doesn't have thickness
	nameplates[player.id].healthText:SetColor(HEALTH_NUMBER_COLOR)
	nameplates[player.id].nameText.text = player.name

	if player.clientUserData.currentTankData and player.clientUserData.currentTankData.name and player.clientUserData.currentTankData.teir then
		nameplates[player.id].tankText.text = player.clientUserData.currentTankData.name .. " [" .. tostring(player.clientUserData.currentTankData.teir) .. "]"
	elseif player.identifier then
		nameplates[player.id].tankText.text = TANKS[tonumber(player.identifier)].name
	else
		--nameplates[player.id].tankText.isEnabled = false
	end

	nameplates[player.id].borderPiece.visibility = Visibility.FORCE_OFF
	nameplates[player.id].backgroundPiece.visibility = Visibility.FORCE_OFF
	nameplates[player.id].healthPiece.visibility = Visibility.FORCE_OFF
	nameplates[player.id].changePiece.visibility = Visibility.FORCE_OFF
	nameplates[player.id].healthText.visibility = Visibility.FORCE_OFF
	nameplates[player.id].nameText.visibility = Visibility.FORCE_OFF

	nameplates[player.id].isVisible = false
	nameplates[player.id].changeFraction = 0
	nameplates[player.id].dirty = true
	nameplates[player.id].lastTeam = player.team

	if SHOW_HEALTHBARS then
		nameplates[player.id].borderPiece.visibility = Visibility.INHERIT
		nameplates[player.id].backgroundPiece.visibility = Visibility.INHERIT
		nameplates[player.id].healthPiece.visibility = Visibility.INHERIT

		if ANIMATE_CHANGES then
			nameplates[player.id].changePiece.visibility = Visibility.INHERIT
		end

		if SHOW_NUMBERS then
			nameplates[player.id].healthText.visibility = Visibility.INHERIT
		end
	end

	if SHOW_NAMES then
		nameplates[player.id].nameText.visibility = Visibility.INHERIT
	end

	if SHOW_SEGMENTS then
		nameplates[player.id].segmentSeparators = {}
	end
end

-- nil OnPlayerLeft(Player)
-- Destroy their nameplate
function OnPlayerLeft(player)
	if SHOW_SEGMENTS then
		for _, segmentSeparator in pairs(nameplates[player.id].segmentSeparators) do
			segmentSeparator:Destroy()
		end
	end
	if nameplates[player.id] and Object.IsValid(nameplates[player.id].templateRoot) then 
		nameplates[player.id].templateRoot:Destroy()
	end
	nameplates[player.id] = nil
end

-- bool IsNameplateVisible(Player)
-- Can we see this player's nameplate given team and distance properties?
function IsNameplateVisible(player)
	if (currentGameState == "VICTORY_STATE") or (currentGameState == "STATS_STATE") then
		return true
	end
	if player.isDead and not SHOW_ON_DEAD_PLAYERS then
		return false
	end

	if player == GetViewedPlayer() then
		return SHOW_ON_SELF
	end

	-- 0 distance is special, and means we always display them
	local playerPos = nil
	if player:IsA("Player") then
		playerPos = player:GetWorldPosition()
	elseif Object.IsValid(player.tank) then
		playerPos = player.tank:GetWorldPosition()
	end

	local viewedPlayer = GetViewedPlayer()
	if not playerPos then
		return
	end
	if player == viewedPlayer or Teams.AreTeamsFriendly(player.team, viewedPlayer.team) then
		if SHOW_ON_TEAMMATES then
			local viewedPos = viewedPlayer:GetWorldPosition()
			local distance = (playerPos - viewedPos).size
			if MAX_DISTANCE_ON_TEAMMATES == 0.0 or distance <= MAX_DISTANCE_ON_TEAMMATES then
				return true
			end
		end
	else
		if CheckSpotting(viewedPlayer) then
			local viewedPos = viewedPlayer:GetWorldPosition()
			local distance = (playerPos - viewedPos).size
			if MAX_DISTANCE_ON_ENEMIES == 0.0 or distance <= MAX_DISTANCE_ON_ENEMIES then
				return true
			end
		end
	end

	return false
end

-- nil RotateNameplate(CoreObject)
-- Called every frame to make nameplates align with the local view
function RotateNameplate(nameplate)
	local quat = Quaternion.New(LOCAL_PLAYER:GetViewWorldRotation())
	quat = quat * Quaternion.New(Vector3.UP, 180.0)
	nameplate.templateRoot:SetWorldRotation(Rotation.New(quat))
end

-- handler params: CoreObject_owner, string_propertyName
function OnGameStateChanged(object, string)
	if string == "GameState" then
		currentGameState = GameState:GetCustomProperty("GameState")
	end
end

-- nil Tick(float)
-- Update dynamic properties (ex. team, health, and health animation) of every nameplate
function Tick(deltaTime)
	local tankList = Game.GetPlayers()
	--print("lookups", _G.lookup, _G.lookup.tanks or "tanks not found")
	if Game.GetCurrentSceneName() ~= "Main" then
		if _G.lookup and _G.lookup.tanks then
			for k, v in pairs(_G.lookup.tanks) do
				--print(".....", v.name)
				table.insert(tankList, v)
			end
		else
			--print("No AI drivers...", _G.lookup)
		end
	end

	--for _, player in ipairs(Game.GetPlayers()) do
	for _, player in pairs(tankList) do
		--print("Handling nameplate for player", player.id)
		local nameplate = nameplates[player.id]

		if nameplate and not nameplate.recheck or nameplate and nameplate.recheck < time() then
			nameplate.dirty = true
			nameplate.recheck = time() + 3
		end

		if nameplate == nil and (player:IsA("AIPlayer") or player:IsA("Player")) then
			OnPlayerJoined(player)
			nameplate = nameplates[player.id]
		end
		
		if nameplate and (player:IsA("AIPlayer") or Object.IsValid(player)) and Object.IsValid(nameplate.templateRoot) then
			-- We calculate visibility every frame to handle when teams change
			local visible = IsNameplateVisible(player)
			--print(player.name .. " nameplate visible: " .. tostring(visible))
			if player.team ~= nameplate.lastTeam then
				nameplate.lastTeam = player.team
				nameplate.dirty = true
			end
			if not visible then
				if nameplate.isVisible == true then
					nameplate.dirty = true
				end
				-- due to player:setVisibility, enforce this each tick
				if nameplate.templateRoot.visibility ~= Visibility.FORCE_OFF then
					nameplate.templateRoot.visibility = Visibility.FORCE_OFF
				end
			else
				if nameplate.isVisible == false then
					nameplate.dirty = true
				end
				-- due to player:setVisibility, enforce this each tick
				if nameplate.templateRoot.visibility ~= Visibility.FORCE_ON then
					nameplate.templateRoot.visibility = Visibility.FORCE_ON
				end

				RotateNameplate(nameplate)

				if
					player.clientUserData.currentTankData and player.clientUserData.currentTankData.name and
						player.clientUserData.currentTankData.teir
				 then
					nameplate.tankText.text =
						player.clientUserData.currentTankData.name .. " [T" .. tostring(player.clientUserData.currentTankData.teir) .. "]"
				elseif player.identifier then
					nameplates[player.id].tankText.text =
						TANKS[tonumber(player.identifier)].name .. " [T" .. tostring(TANKS[tonumber(player.identifier)].tier) .. "]"
				end

				if SHOW_HEALTHBARS then
					local healthFraction = player.hitPoints / player.maxHitPoints
					local visibleHealthFraction = healthFraction -- For animating changes

					-- Set size and position of change piece
					if ANIMATE_CHANGES then
						local timeSinceChange = CoreMath.Clamp(time() - nameplate.lastHealthTime, 0.0, CHANGE_ANIMATION_TIME)
						local timeScale = 1.0 - timeSinceChange / CHANGE_ANIMATION_TIME
						local changeFraction = timeScale * (nameplate.lastHealthFraction - healthFraction)
						if changeFraction ~= nameplate.changeFraction then
							nameplate.changeFraction = changeFraction
							nameplate.dirty = true
						end

						-- Detect health changes to set the animation state
						if healthFraction ~= nameplate.lastFrameHealthFraction then
							-- If you just respawned, don't show it like a big heal
							if nameplate.lastFrameHealthFraction == 0.0 then
								nameplate.lastHealthTime = 0.0
								nameplate.lastHealthFraction = healthFraction
							else
								nameplate.lastHealthTime = time()
								nameplate.lastHealthFraction = nameplate.lastFrameHealthFraction
							end
							nameplate.dirty = true
						end
					end

					-- If health changed, mark as dirty
					if nameplate.lastFrameHealthFraction ~= healthFraction then
						nameplate.lastFrameHealthFraction = healthFraction
						nameplate.dirty = true
					end

					-- Update segments
					if SHOW_SEGMENTS then
						local nSegmentSeparators = math.ceil(player.maxHitPoints / SEGMENT_SIZE) - 1
						local healthScale = (HEALTHBAR_WIDTH + BORDER_WIDTH) / player.maxHitPoints
						local segmentBaseOffset = 100.0 * (HEALTHBAR_WIDTH + BORDER_WIDTH) / 2

						for i = 1, nSegmentSeparators - #nameplate.segmentSeparators do
							local segmentSeparator = World.SpawnAsset(SEGMENT_SEPARATOR_TEMPLATE, {parent = nameplate.templateRoot})
							segmentSeparator:SetColor(BORDER_COLOR)
							table.insert(nameplate.segmentSeparators, segmentSeparator)
						end

						for i = nSegmentSeparators + 1, #nameplate.segmentSeparators do
							local segmentSeparator = nameplate.segmentSeparators[i]
							segmentSeparator.visibility = Visibility.FORCE_OFF
						end

						for i = 1, nSegmentSeparators do
							local segmentSeparator = nameplate.segmentSeparators[i]
							segmentSeparator.visibility = Visibility.INHERIT
							segmentSeparator:SetScale(Vector3.New(NAMEPLATE_LAYER_THICKNESS, BORDER_WIDTH, HEALTHBAR_HEIGHT + BORDER_WIDTH))
							segmentSeparator:SetPosition(
								Vector3.New(-1.0 * NAMEPLATE_LAYER_THICKNESS, segmentBaseOffset - 100.0 * i * SEGMENT_SIZE * healthScale, 0.0)
							)
						end
					end
				end
			end

			if (currentGameState == "VICTORY_STATE") then
				nameplate.dirty = true
			end

			previousGameState = currentGameState

			if nameplate.dirty then
				nameplate.dirty = false
				nameplate.isVisible = visible

				if not visible then
					--nameplate.templateRoot.visibility = Visibility.FORCE_OFF
				else
					--nameplate.templateRoot.visibility = Visibility.INHERIT

					if SHOW_HEALTHBARS then
						local healthFraction = player.hitPoints / player.maxHitPoints
						local visibleHealthFraction = healthFraction -- For animating changes

						-- Set size and position of change piece
						if ANIMATE_CHANGES then
							local changeFraction = nameplate.changeFraction
							nameplate.changePiece:SetScale(
								Vector3.New(NAMEPLATE_LAYER_THICKNESS, HEALTHBAR_WIDTH * math.abs(nameplate.changeFraction), HEALTHBAR_HEIGHT)
							)

							if changeFraction == 0.0 then
								nameplate.changePiece.visibility = Visibility.FORCE_OFF
							else
								nameplate.changePiece.visibility = Visibility.INHERIT

								if changeFraction > 0.0 then -- Player took damage
									local changePieceOffset =
										50.0 * HEALTHBAR_WIDTH * (1.0 - changeFraction) - 100.0 * HEALTHBAR_WIDTH * healthFraction
									nameplate.changePiece:SetPosition(Vector3.New(-2.0 * NAMEPLATE_LAYER_THICKNESS, changePieceOffset, 0.0))
									nameplate.changePiece:SetColor(DAMAGE_CHANGE_COLOR)
								else -- Player was healed
									visibleHealthFraction = visibleHealthFraction + changeFraction
									local changePieceOffset =
										50.0 * HEALTHBAR_WIDTH * (1.0 + changeFraction) - 100.0 * HEALTHBAR_WIDTH * visibleHealthFraction
									nameplate.changePiece:SetPosition(Vector3.New(-2.0 * NAMEPLATE_LAYER_THICKNESS, changePieceOffset, 0.0))
									nameplate.changePiece:SetColor(HEAL_CHANGE_COLOR)
								end
							end
						end

						-- Set size and position of health bar
						local healthPieceOffset = 50.0 * HEALTHBAR_WIDTH * (1.0 - visibleHealthFraction)
						nameplate.healthPiece:SetScale(
							Vector3.New(NAMEPLATE_LAYER_THICKNESS, HEALTHBAR_WIDTH * visibleHealthFraction, HEALTHBAR_HEIGHT)
						)
						nameplate.healthPiece:SetPosition(Vector3.New(-2.0 * NAMEPLATE_LAYER_THICKNESS, healthPieceOffset, 0.0))

						-- Update hit point number
						if SHOW_NUMBERS then
							nameplate.healthText.text = string.format("%.0f / %.0f", player.hitPoints, player.maxHitPoints)
						end
					end

					-- Update name and health color based on teams
					if SHOW_NAMES then
						local nameColor = nil
						local healthColor = nil
						local scaling = nil

						if player == LOCAL_PLAYER or Teams.AreTeamsFriendly(player.team, LOCAL_PLAYER.team) then
							nameColor = FRIENDLY_NAME_COLOR
							healthColor = FRIENDLY_HEALTH_COLOR
							scaling = SCALE
						else
							nameColor = ENEMY_NAME_COLOR
							healthColor = ENEMY_HEALTH_COLOR
							scaling = SCALE * 2
						end

						if (currentGameState == "VICTORY_STATE") then
							scaling = SCALE * 0.7
						end

						nameplate.nameText:SetColor(nameColor)
						nameplate.tankText:SetColor(nameColor)
						nameplate.healthPiece:SetColor(healthColor)
						nameplate.templateRoot:SetScale(Vector3.New(scaling, scaling, scaling))
					end
				end
			end
		end
	end
end

-- Initialize
Game.playerJoinedEvent:Connect(OnPlayerJoined)
Game.playerLeftEvent:Connect(OnPlayerLeft)
if GameState then
	GameState.networkedPropertyChangedEvent:Connect(OnGameStateChanged)
end
