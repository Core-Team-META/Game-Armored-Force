local Constants_API = require(script:GetCustomProperty('Constants_API'))
local Folder = script:GetCustomProperty("Folder"):WaitForObject()

local Data = {}

for _, tank in pairs(Folder:GetChildren()) do
    local idString = (tank:GetCustomProperty('id'))
    local id = tonumber(idString)
    local upgradeId = nil
    local upgradeType = nil

    --print("==============================================")
    --print("TANK: " .. idString)
    
    Data[id] = {}

    for key, value in pairs(tank:GetCustomProperties()) do
        Data[id][key] = value
    end
    
    for _, upgrade in pairs(tank:GetChildren()) do
    	upgradeId = upgrade:GetCustomProperty("upgradeID")
    	upgradeType = upgrade:GetCustomProperty("upgradeType")
    	
    	if not Data[id][upgradeType] then
    		Data[id][upgradeType] = {}
    	end
    	
    	Data[id][upgradeType][upgradeId] = {}
    	
    	--print("-------------------------------------")
    	--print(upgradeId)
    	
    	for key, value in pairs(upgrade:GetCustomProperties()) do
    		Data[id][upgradeType][upgradeId][key] = value
    		--print(key .. " : " .. tostring(value))
    	end
    end
    
    Data[id]["skins"] = {}
end

local Tanks = {}
Tanks.Data = Data

Tanks.GetTankFromName = function(name)
    for key, tank in pairs(Tanks.Data) do
        if tank.name == name then
            return tank
        end
    end
end
Tanks.GetTankFromId = function(id)
    return Tanks.Data[id]
end
Tanks.GetTanksInTier = function(Tier)
    local tanks = {}
    for key, tank in pairs(Tanks.Data) do
        if tank.tier == Tier then
            table.insert(tanks, tank)
        end
    end
    return tanks
end
Tanks.GetTanksInType = function(Type)
    local tanks = {}
    for key, tank in pairs(Tanks.Data) do
        if tank.type == Type then
            table.insert(tanks, tank)
        end
    end
    return tanks
end
Tanks.FilterByKey = function(key, rank)
    local tanks = {}
    for _, tank in pairs(Tanks.Data) do
        if tank[key] == rank then
            table.insert(tanks, tank)
        end
    end
    return tanks
end

Tanks.GetTanks = function()
    return Tanks.Data
end

Tanks.NumberOfTanks = function()
    local int = 0
    for key, value in pairs(Tanks.Data) do
        int = int + 1
    end
    return int
end
Tanks.GetPurchaseCost = function(id)
    local tank = Tanks.GetTankFromId(tonumber(id))
    if tank then
        return {resource = tostring(tank.purchaseCurrencyName), amount = tonumber(tank.purchaseCost)}	
    end
end
Tanks.IsValidID = function(id)
    return Tanks.GetTanks()[id] ~= nil
end

Tanks.TANK_TYPE = {
    Light = {Name = 'Light'},
    Medium = {Name = 'Medium'},
    Heavy = {Name = 'Heavy'},
    TankDestroyer = {Name = 'Tank Destroyer'}
}

Tanks.TEAMS = {
    Allies = 1,
    Axis = 2,
}

Tanks.EquipResource = "EquippedTank"

function Tanks.GetHighestDamage()
	return 1000
end

function Tanks.GetLowestDamage()
	return 40
end

function Tanks.GetHighestReload()
	return 12 -- true highest is 10, set slightly higher than actual max to compensate for high reload vehicles (jagdtiger)
end

function Tanks.GetLowestReload()
	return 1
end

function Tanks.GetHighestTurretSpeed()
	return 100
end

function Tanks.GetLowestTurretSpeed()
	return 5
end

function Tanks.GetHighestHitPoints()
	return 2350
end

function Tanks.GetLowestHitPoints()
	return 400
end

function Tanks.GetHighestTopSpeed()
	return 2700 -- was 4100, set lower to make it easier to compare stats of other tanks.
end

function Tanks.GetLowestTopSpeed()
	return 300
end

function Tanks.GetHighestAcceleration()
	return 4600
end

function Tanks.GetLowestAcceleration()
	return 200
end

function Tanks.GetHighestTraverse()
	return 70
end

function Tanks.GetLowestTraverse()
	return 20
end

function Tanks.GetHighestElevation()
	return 35
end

function Tanks.GetLowestElevation()
	return 5
end

function Tanks.GetHighestTurningSpeed() 
	return 100 -- true highest turning speed is 1500, lowering value for average of 
end

function Tanks.GetLowestTurningSpeed() 
	return 20
end

Constants_API:Register('Tanks', Tanks)
