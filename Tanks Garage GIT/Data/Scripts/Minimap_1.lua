--[[
Minimap UI
v1.0
by: standardcombo

1. Place the Minimap UI template into your hierarchy.
2. Edit the contents of the "3D" folder, to match the level design of your game.
3. Use Plane 1m or World Text objects. For the Planes, only rotate them on Z or it will look incorrect.

Tips:
- It's fast to get a rough minimap working, but fine tuning all the edges takes time and patience.
- Change the color of the map elements by editing the "Tint" custom property on the 3D objects.
- When not working on the minimap geometry, toggle its visibility and lock it in the hierarchy.

--]]

local ROOT = script.parent
local MAP_PANEL = script:GetCustomProperty("UIPanel"):WaitForObject()
local MAP_PIECE_TEMPLATE = script:GetCustomProperty("MinimapPiece")
local LABEL_TEMPLATE = script:GetCustomProperty("MinimapLabel")
local OBJECTIVE_PIECE_TEMPLATE = script:GetCustomProperty("ObjectivePiece")

local PLAYER_TEMPLATE = script:GetCustomProperty("MinimapPlayer")
local LIGHT_TANK_TEMPLATE = script:GetCustomProperty("MinimapLightTank")
local MEDIUM_TANK_TEMPLATE = script:GetCustomProperty("MinimapMediumTank")
local HEAVY_TANK_TEMPLATE = script:GetCustomProperty("MinimapHeavyTank")
local DESTROYER_TANK_TEMPLATE = script:GetCustomProperty("MinimapDestroyerTank")
local TANK_TEMPLATE = script:GetCustomProperty("MinimapTank")

local GRADIENT_HEIGHT = script:GetCustomProperty("GradientHeight")
local COLOR_LOW = script:GetCustomProperty("ColorLow")
local COLOR_HIGH = script:GetCustomProperty("ColorHigh")
local BORDER_COLOR = script:GetCustomProperty("BorderColor")
local BORDER_SIZE = script:GetCustomProperty("BorderSize")

local worldShapes = ROOT:FindDescendantsByType("StaticMesh")
local worldTexts = ROOT:FindDescendantsByType("WorldText")

local spottingServer = script:GetCustomProperty("GAMEHELPER_SpottingServer"):WaitForObject()
local mainGameStateManager = script:GetCustomProperty("GAMESTATE_MainGameStateManagerServer"):WaitForObject()
local minimapComponents = script:GetCustomProperty("MinimapComponents"):WaitForObject()

function CheckSpotting(player)
	
	for i=1, 16 do
	
		if spottingServer:GetCustomProperty("P" .. tostring(i)) == player.id then
			
			return true
			
		end
		
	end
	
	return false
	
end

if #worldShapes <= 0 then
	error("Minimap needs at least one 3D shape placed in-world.")
	return
end

-- Establish 3D bounds
local boundsLeft
local boundsRight
local boundsTop
local boundsBottom
local boundsHigh
local boundsLow

local TeamBasesObjectives = {}
local BaseObjectiveObjects = script:GetCustomProperty("BaseObjectiveObjects"):WaitForObject() --World.FindObjectByName("GAMESTATE_TeamBasesServerObjects")

for _,shape in ipairs(worldShapes) do
	shape.isEnabled = false
	
	local pos = shape:GetWorldPosition()
	local size = shape:GetWorldScale() * 50
	local l = pos.x - size.x
	local r = pos.x + size.x
	local t = pos.y - size.y
	local b = pos.y + size.y
	
	if (not boundsLeft or l < boundsLeft) then
		boundsLeft = l
	end
	if (not boundsRight or r > boundsRight) then
		boundsRight = r
	end
	if (not boundsTop or t < boundsTop) then
		boundsTop = t
	end
	if (not boundsBottom or b > boundsBottom) then
		boundsBottom = b
	end
	if (not boundsHigh or pos.z > boundsHigh) then
		boundsHigh = pos.z
	end
	if (not boundsLow or pos.z < boundsLow) then
		boundsLow = pos.z
	end
end

boundsLeft = -script:GetCustomProperty("BoundsWidth") * 0.5
boundsTop = -script:GetCustomProperty("BoundsHeight") * 0.5
boundsRight = script:GetCustomProperty("BoundsWidth") * 0.5
boundsBottom = script:GetCustomProperty("BoundsHeight") * 0.5
local boundsWidth = (boundsRight - boundsLeft)
local boundsHeight = boundsBottom - boundsTop

-- Precompute coeficients
local scaleX = MAP_PANEL.width / boundsWidth
local scaleY = scaleX

if boundsHeight > boundsWidth then
	scaleY = MAP_PANEL.height / boundsHeight
	scaleX = scaleY
end

local scaleLabels = scaleY * 0.15
--local offsetX = 0
--local offsetY = 0
--if boundsWidth > boundsHeight then
--	offsetY = 

-- Spawn 2D shapes
function AddForShape(shape)
	local pos = shape:GetWorldPosition()
	local rot = shape:GetWorldRotation()
	local size = shape:GetWorldScale() * 100
	
	local mapPiece = World.SpawnAsset(MAP_PIECE_TEMPLATE, {parent = MAP_PANEL})
	
	mapPiece.x = (pos.x - boundsLeft) * scaleX
	mapPiece.y = (pos.y - boundsTop) * scaleY
	local w = size.x * scaleX
	local h = size.y * scaleY
	mapPiece.width = CoreMath.Round(w)
	mapPiece.height = CoreMath.Round(h)
	
	mapPiece.rotationAngle = rot.z
	
	return mapPiece
end

-- Border
for _,shape in ipairs(worldShapes) do
	--local mapPiece = AddForShape(shape)
	--mapPiece.width = mapPiece.width + BORDER_SIZE * 2
	--mapPiece.height = mapPiece.height + BORDER_SIZE * 2
	-- Color
	--mapPiece:SetColor(BORDER_COLOR)
end

-- Fill
for _,shape in ipairs(worldShapes) do
	--local mapPiece = AddForShape(shape)
	-- Color
	--local baseColor = shape:GetCustomProperty("Tint") or Color.WHITE
	--if GRADIENT_HEIGHT then
	--	local posZ = shape:GetWorldPosition().z
	--	local heightNormalized = (posZ - boundsLow) / (boundsHigh - boundsLow)
	--	local color = Color.Lerp(COLOR_LOW, COLOR_HIGH, heightNormalized)
	--	mapPiece:SetColor(color * baseColor)
	--else
	--	mapPiece:SetColor(baseColor)
	--end
end

-- Team Bases Game Mode Objectives
for _, objective in ipairs(BaseObjectiveObjects:GetChildren()) do
	local objectiveSet = {}
	
	objectiveSet[1] = World.SpawnAsset(OBJECTIVE_PIECE_TEMPLATE, {parent = MAP_PANEL})

	local center = objective:GetChildren()[1]	
	local edge = objective:GetChildren()[2]
	local pos = center:GetWorldPosition()
	
	local name = objectiveSet[1]:GetCustomProperty("ObjectiveName"):WaitForObject()
	name.text = string.sub(center.name, 1, 1)
	
	local radius = (center:GetWorldPosition() - edge:GetWorldPosition()).size
	
	objectiveSet[1].width = CoreMath.Round(radius * 2 * scaleX)
	objectiveSet[1].height = objectiveSet[1].width
	
	objectiveSet[1].x = (pos.x - boundsLeft) * scaleX
	objectiveSet[1].y = (pos.y - boundsTop) * scaleY
	
	if name.text == "A" then
		objectiveSet[1].team = 1
	elseif  name.text == "B" then
		objectiveSet[1].team = 2
	end
	
	objectiveSet[2] = objective:FindDescendantByName(string.sub(center.name, 1, 1) .. "PointVisual")
	objectiveSet[1].visibility = objectiveSet[2].visibility
	table.insert(TeamBasesObjectives, objectiveSet)	
end

-- Labels
for _,text in ipairs(worldTexts) do
	text.isEnabled = false
	
	local pos = text:GetWorldPosition()
	local rot = text:GetWorldRotation()
	local size = text:GetWorldScale() * 100
	
	local label = World.SpawnAsset(LABEL_TEMPLATE, {parent = MAP_PANEL})
	
	label.x = (pos.x - boundsLeft) * scaleX
	label.y = (pos.y - boundsTop) * scaleY
	
	label.fontSize = size.z * scaleLabels
	
	label.text = text.text
	label:SetColor(text:GetColor())
end


function Tick()
	local localPlayer = Game.GetLocalPlayer()
	local allPlayers = Game.GetPlayers()

	if not _G.lookup or not _G.lookup.tanks then return end

	for k,v in pairs(_G.lookup.tanks) do
		--print("Inserting data for", v.name)
		table.insert(allPlayers, v)
	end
	
	for _,player in ipairs(allPlayers) do
		local indicator = GetIndicatorForPlayer(player)
		if Object.IsValid(indicator) then
			if player.isDead or player.team == localPlayer.team or CheckSpotting(player) then
				indicator.visibility = Visibility.INHERIT

				--local pos = player:GetWorldPosition()
				local pos = Vector3.ZERO
				if player:IsA("Player") then
					pos = player:GetWorldPosition()
				else
					if Object.IsValid(player.tank) then
						pos = player.tank:GetWorldPosition()
					end
				end

				indicator.x = (pos.x - boundsLeft) * scaleX
				indicator.y = (pos.y - boundsTop) * scaleY
			else
				indicator.visibility = Visibility.FORCE_OFF
			end
		else
			--print("no indicator")
		end
	end
	
	for _, objective in ipairs(TeamBasesObjectives) do
		objective[1].visibility = objective[2].visibility
	end
end

function GetIndicatorType(player)

	local tankType = nil
	
	if player.clientUserData.currentTankData then
		tankType = player.clientUserData.currentTankData.type
	end
	
	player.clientUserData.minimapType = tankType
	
	return TANK_TEMPLATE
	
	--[[
	if tankType == "Light" then
		return LIGHT_TANK_TEMPLATE
	elseif tankType == "Medium" then
		return MEDIUM_TANK_TEMPLATE
	elseif tankType == "Heavy" then
		return HEAVY_TANK_TEMPLATE
	elseif tankType == "Destroyer" then
		return DESTROYER_TANK_TEMPLATE
	end 
	
	--warn("COULD NOT FIND TANK TYPE FOR " .. player.name .. " : " .. tostring(player.clientUserData.minimapType))
	
	return PLAYER_TEMPLATE
	]]
end

function CheckIndicatorType(player)

	local tankType = nil
	
	if player.clientUserData.currentTankData then
		tankType = player.clientUserData.currentTankData.type
	end
	
	if player.clientUserData.minimapType == tankType then
		return true
	else
		return false			
	end
	
end

function GetIndicatorForPlayer(player)
	-- Return already created indicator
	
	if player.clientUserData.minimap and CheckIndicatorType(player) then
		-- Give the UI script a reference to player (probably happens on second update tick)
		if (not player.clientUserData.minimapScript) then
			local minimapScript = player.clientUserData.minimap:FindDescendantByType("Script")
			if minimapScript and minimapScript.context then
				minimapScript.context.SetPlayer(player)
				player.clientUserData.minimapScript = minimapScript
			end
		end
		return player.clientUserData.minimap
	end
	
	if Object.IsValid(player.clientUserData.minimap) then
		player.clientUserData.minimap:Destroy()
		player.clientUserData.minimapScript = nil
	end
	
	-- Spawn new indicator for this player
--print("Spawning an indicator for", player.name)
	local minimapPlayer = World.SpawnAsset(GetIndicatorType(player), {parent = MAP_PANEL})
	player.clientUserData.minimap = minimapPlayer
	return minimapPlayer
	
end


function StateSTART(manager, propertyName)

	if propertyName ~= "GameState" then
		return
	end
	
	if mainGameStateManager:GetCustomProperty("GameState") == "CARD_STATE" then
		minimapComponents.visibility = Visibility.FORCE_OFF
	end
		
end



mainGameStateManager.networkedPropertyChangedEvent:Connect(StateSTART)




