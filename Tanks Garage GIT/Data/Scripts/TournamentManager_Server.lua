------------------------------------------------------------------------------------------------------------------------
-- Tournament Manager Server
-- Author Morticai (META) - (https://www.coregames.com/user/d1073dbcc404405cbef8ce728e53d380)
-- Date: 2021/8/24
-- Version 0.1.0
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
-- REQUIRES
------------------------------------------------------------------------------------------------------------------------
if true then
    return
end

while not _G.META_ACHIEVEMENTS do
    Task.Wait()
end
------------------------------------------------------------------------------------------------------------------------
-- OBJECTS
------------------------------------------------------------------------------------------------------------------------
local ROOT = script:GetCustomProperty("ROOT"):WaitForObject()
local TROPHY_LIST = script:GetCustomProperty("TrophyList"):WaitForObject()
local TID = ROOT:GetCustomProperty("ID")
------------------------------------------------------------------------------------------------------------------------
-- CONSTANTS
------------------------------------------------------------------------------------------------------------------------
local POINTS_WINNING_TEAM = 100
local POINTS_LOSTING_TEAM = 25
local POINTS_PER_DAMAGE = 0.05
local POINTS_PER_KILL = 20
local POINTS_PER_CAPTURE = 50
local MULTIPLIER_PER_PLAYER = 0.10 -- + 10% per player in game

local VIP = {
    Bot1 = true,
    Vitriol08 = true,
    Vitriol = true,
    Buckmonster = true,
    --ManticoreGames  = true,
    Basilisk = true,
    Mehaji = true,
    Griffin = true,
    Morticai = true,
    Bigglebuns = true,
    Rolok = true,
    Jarsa = true,
    standardcombo = true,
    blaking707 = true,
    Coderz = true,
    Datonare = true,
    Divided = true,
    estlogic = true,
    nicholasforeman = true,
    Ooccoo = true,
    Aggripina = true,
    AwkwardGameDev = true,
    Daddio = true,
    mjcortes782 = true,
    Keppu = true,
    KonzZwodrei = true,
    Melamoryxq = true,
    Mucusinator = true,
    WitcherSilver = true,
    AJ = true,
    riffraff = true,
    Sobchak = true,
    Scav = true,
    Tobs = true,
    Beekzor = true,
    aBomb = true,
    blackdheart = true,
    BreadMan = true,
    Bumblebear = true,
    bunnychen = true,
    Carbide = true,
    codeHeavy = true,
    CoreVideo = true,
    deadlyfishesMC = true,
    Dracowolfie = true,
    featurecreeper = true,
    Gabunir = true,
    JayDee = true,
    kytsu = true,
    lokii = true,
    Lucidish = true,
    manticoreian = true,
    max = true,
    mcamp = true,
    mrbigfists = true,
    Neurosin = true,
    pchiu = true,
    qualispec = true,
    Robotron = true,
    Sasha = true,
    SpaceBandit = true,
    Squirtle = true,
    Stanzilla = true,
    structbar = true,
    sumoflab = true,
    tjarvis = true,
    RyanZ = true,
    RebherCore = true,
    Memori = true,
    Nezberet = true,
    plasmabacon = true,
    Phyronnaz = true
}

local startDate = {
    year = 2021,
    month = 9,
    day = 14,
    hour = 17, -- 10am PDT
    min = 0,
    wday = 3,
    yday = 257
}

local endDate = {
    year = 2021,
    month = 9,
    day = 20,
    hour = 17, -- 10am PDT
    min = 0,
    wday = 2,
    yday = 263
}

local listeners = {}
local playerScore = {}
local playerData = {}

local trophyData = {}

local totalPlayers = 0
------------------------------------------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
------------------------------------------------------------------------------------------------------------------------

for i, child in ipairs(TROPHY_LIST:GetChildren()) do
    local trophy = {}
    trophy.id = child:GetCustomProperty("ID")
    trophy.name = child:GetCustomProperty("Name")
    trophy.min = child:GetCustomProperty("MinScore")
    trophy.max = child:GetCustomProperty("MaxScore")
    trophy.icon = child:GetCustomProperty("Icon")
    trophy.url = child:GetCustomProperty("GameURL")
    trophyData[i] = trophy
end

local function IsValidPlayer(object)
    return Object.IsValid(object) and object:IsA("Player")
end

local function SetCurrentTrophy(player, score)
    for _, trophy in ipairs(trophyData) do
        if score >= trophy.min and score <= trophy.max then
            _G.META_ACHIEVEMENTS.AddProgress(player, trophy.id, 2)
        end
    end
end

local function SetPlayerFlags(player)
    playerData[player] = {
        kills = 0,
        damage = 0,
        wonMatch = false,
        hasCaptured = false
    }

    player.serverUserData.TMS_killCredited = false
    player.serverUserData.TMS_diedInRound = false
end

local function CalculateScore(player, playerBonus)
    local currentDate = os.time(os.date("!*t"))
    if
        ((currentDate < os.time(startDate)) and not VIP[player.name]) or
            ((currentDate > os.time(endDate)) and not VIP[player.name])
     then
        warn("Event is not live.")
        return
    end


    local newScore = 0
    local captureScore = 0
    local damageScore = 0

    if not playerData[player] then
        SetPlayerFlags(player)
    end

    -- Give points to player based on team outcome
    local matchScore = 0
    if player.team == _G["GameWinner"] then
        matchScore = POINTS_WINNING_TEAM
        playerData[player].wonMatch = true
    else
        matchScore = POINTS_LOSTING_TEAM
    end
    --print(player.name .. " Match Score", matchScore, playerData[player].wonMatch)

    -- Give points to player based on kills
    local killScore = playerData[player].kills * POINTS_PER_KILL
    --print(player.name .. " Kill Score:", killScore, " Kills:", playerData[player].kills)
    -- Give Points to player based on damage
    damageScore = playerData[player].damage * POINTS_PER_DAMAGE

    --print(player.name .. " Damage Score:", damageScore, " Damage:", playerData[player].damage)
    -- Calculate total score
    newScore = matchScore + killScore + captureScore + damageScore

    --print(player.name .. " Pre-Bonus Score:", newScore)
    newScore = newScore + (newScore * playerBonus)

    --print(player.name .. " Post-Bonus Score:", newScore, "Bonus:", playerBonus)
    player:SetPrivateNetworkedData("NEWSCORE", CoreMath.Round(newScore))

    newScore = CoreMath.Round((playerScore[player] or 0) + newScore)
    player:SetPrivateNetworkedData("TSCORE", newScore)

    playerScore[player] = newScore
    SetCurrentTrophy(player, newScore)
end

local function OnRoundStart()
    local players = Game.GetPlayers()
    totalPlayers = #players

    for _, player in ipairs(players) do
        SetPlayerFlags(player)
    end
end

local function OnRoundEnd()
    local playerBonus = MULTIPLIER_PER_PLAYER * totalPlayers

    for _, player in ipairs(Game.GetPlayers()) do --
        if IsValidPlayer(player) then
            CalculateScore(player, playerBonus)
        end
    end
end

local function PlayerKilled(player, target, weaponType, isHeadShot)
    if player == target then
        return
    end

    if not playerData[player] then
        SetPlayerFlags(player)
    end

    playerData[player].kills = playerData[player].kills + 1

    target.serverUserData.TMS_killCredited = true
    target.serverUserData.TMS_diedInRound = true
end

------------------------------------------------------------------------------------------------------------------------
-- GLOBAL FUNCTIONS
------------------------------------------------------------------------------------------------------------------------

--@param object player
function LoadStorage(player)
    local data = Storage.GetPlayerData(player) or {}
    playerScore[player] = data[TID] or 0
    player:SetPrivateNetworkedData("TSCORE", playerScore[player])
end

--@param object player
function SaveStorage(player)
    local data = Storage.GetPlayerData(player) or {}
    data[TID] = playerScore[player] or 0
    Storage.SetPlayerData(player, data)
end

function OnPlayerDied(attackData)
    local target = attackData.object
    local source = attackData.source
    if IsValidPlayer(source) and (IsValidPlayer(target) or target:IsA("AIPlayer")) then
        if (target.isDead) and not target.serverUserData.TMS_killCredited then
            PlayerKilled(source, target)
        end
    end
end

function OnDamageTaken(attackData)
    local target = attackData.object
    local source = attackData.source
    local damage = attackData.damage
    if target == source then
        return
    end

    if IsValidPlayer(source) and (IsValidPlayer(target) or target:IsA("AIPlayer")) then
        if damage and damage.amount then
            playerData[source].damage = playerData[source].damage + damage.amount
        end
    end
end

function OnPlayerJoined(player)
    LoadStorage(player)
    SetPlayerFlags(player)
end

function OnPlayerLeft(player)
    SaveStorage(player)
    playerScore[player] = nil
    playerData[player] = nil
end

------------------------------------------------------------------------------------------------------------------------
-- LISTENERS
------------------------------------------------------------------------------------------------------------------------
Game.playerJoinedEvent:Connect(OnPlayerJoined)
Game.playerLeftEvent:Connect(OnPlayerLeft)

if Game.GetCurrentSceneName() ~= "Main" then
    Game.roundEndEvent:Connect(OnRoundEnd)
    Game.roundStartEvent:Connect(OnRoundStart)

    -- Server (Same Context) Broadcast Listeners
    Events.Connect("CombatWrapAPI.OnDamageTaken", OnDamageTaken)
    Events.Connect("CombatWrapAPI.ObjectHasDied", OnPlayerDied)
end
