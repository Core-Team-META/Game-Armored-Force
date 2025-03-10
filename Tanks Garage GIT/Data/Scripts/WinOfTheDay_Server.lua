
local UTIL = require(script:GetCustomProperty('MetaAbilityProgressionUTIL_API'))
local _Constants_API = require(script:GetCustomProperty('Constants_API'))
local KEYS = _Constants_API:WaitForConstant('Storage_Keys')
local STORAGE_NET_REF = KEYS.Achievements
local TankAPI = _Constants_API:WaitForConstant('Tanks') 
local TANK_CONTENT = TankAPI.GetTanks()

local tankTbl = {}
local playerDailyTbl = {}

local function BuildTankTable()
    for _, tank in ipairs(TANK_CONTENT) do
        tankTbl[tonumber(tank.id)] = tank.type
    end
end

local function SetDailyBonusStatus(player)
	while player:GetResource(TankAPI.EquipResource) == 0 do
		Task.Wait()
	end
	
    local currentId = player:GetResource(TankAPI.EquipResource)
    
    if playerDailyTbl[player.id][currentId] == 0 then
    	player:SetResource('DAILY_BONUS', 1)
    	print("Daily Bonus is enabled")
    else 
    	player:SetResource('DAILY_BONUS', 0)
    	print("Daily Bonus is not enabled")
    end
    
    --[[
    for tankId, value in pairs(playerDailyTbl[player.id]) do
        if tankId == currentId and tonumber(value) == 0 then
            player:SetResource('DAILY_BONUS', 1)
        elseif tankId == currentId and tonumber(value) == 1 then
            player:SetResource('DAILY_BONUS', 0)
        end
    end
    ]]
end

function SetWinning(player)
    local tankId = player:GetResource(TankAPI.EquipResource)
    if playerDailyTbl[player.id] and player:GetResource('DAILY_BONUS') == 1 then
        playerDailyTbl[player.id][tankId] = 1
        _G["BONUS"][player.id] = 1
        print("Daily bonus is given")
    end
end

function OnPlayerJoined(player)
    playerDailyTbl[player.id] = {}

    local data = Storage.GetSharedPlayerData(STORAGE_NET_REF, player)

    local dailyTbl = {}

    local shouldReset = false
    if data and data.DAILY and data.DAILY ~= '' then
        dailyTbl = UTIL.ConvertStringToTable(data.DAILY)
        if dailyTbl.TIME and dailyTbl.TIME ~= os.date('!*t').yday or not dailyTbl.TIME then
            shouldReset = true
        end
    end
    if (next(dailyTbl) and shouldReset) or not next(dailyTbl) then
        for tankId, _ in pairs(tankTbl) do
            dailyTbl[tankId] = 0
        end
        dailyTbl.TIME = os.date('!*t').yday
    end

    playerDailyTbl[player.id] = dailyTbl
    
    for x, y in pairs(playerDailyTbl[player.id]) do
    	print(tostring(x) .. " : " .. tostring(y))
    end

    if Game.GetCurrentSceneName() == 'Main' then
        player:SetPrivateNetworkedData('WinOfTheDay', dailyTbl)
    else 
    	SetDailyBonusStatus(player)	
    end
end

function OnPlayerLeft(player)
    local data = Storage.GetSharedPlayerData(STORAGE_NET_REF, player)
    if playerDailyTbl[player.id] then
        data.DAILY = UTIL.ConvertTableToString(playerDailyTbl[player.id])
    end
    Storage.SetSharedPlayerData(STORAGE_NET_REF, player, data)

    playerDailyTbl[player.id] = nil
end

------------------------------------------------------------------------------------------------------------------------
-- RESOURCE NAMES
------------------------------------------------------------------------------------------------------------------------
BuildTankTable()
Game.playerJoinedEvent:Connect(OnPlayerJoined)
Game.playerLeftEvent:Connect(OnPlayerLeft)
Events.Connect('SetDailyWin', SetWinning)

-- Local player preview fix due to global wait
if Environment.IsSinglePlayerPreview() then
    local player = Game.GetPlayers()[1]
    OnPlayerJoined(player)
end
