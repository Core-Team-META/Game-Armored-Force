local AdminData = require(script:GetCustomProperty("AdminData"))
local commands = {}
local messagePrefix = "[SERVER]"

local ragdollData = {}

commands = {
    ["/adminall"] = {
        OnCommandCalledClient = function (player, message)
        end,
        OnCommandCalledServer = function (player, message)
            local split = {CoreString.Split(message)}
            local trimMessage = CoreString.Trim(message, split[1])
            local players = Game.FindPlayersInSphere(player:GetWorldPosition(), 3000)
            Chat.BroadcastMessage(string.format("[ADMIN] %s:%s", player.name, trimMessage), {players = players})
        end,
        OnCommandReceivedClient = function (player, message)
            local split = {CoreString.Split(message)}
            local trimMessage = CoreString.Trim(message, split[1])
            local players = Game.FindPlayersInSphere(player:GetWorldPosition(), 3000)
            -- Events.Broadcast("SpawnChatMessage", player, trimMessage, Color.ORANGE, players)
        end,
        description = "Shows admin message in chat to all players",
        requireMessage = true,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.Admin
    },
    
    ["/tp"] = {
        OnCommandCalledClient = function (player, message)       
        end,
        OnCommandCalledServer = function (player, message)
        	local playerName = CoreString.Trim(message, message)
--print(playerName)
        	for _, p in ipairs(Game.GetPlayers()) do
        		if string.find(p.name, playerName) then
        			local vehicle = player.occupiedVehicle
        			local otherVehicle = p.occupiedVehicle
        			vehicle:SetWorldPosition(otherVehicle:GetWorldPosition() + Vector3.New(500, 500, 500))
        		end
        	end
        end,
        OnCommandReceivedClient = function (player, message)
        end,
        description = "teleport to selected player. Format: /tp <otherPlayerName>",
        requireMessage = false,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.Admin
    },
        
    ["/unlockallupgrades"] = {
        OnCommandCalledClient = function (player, message)       
        end,
        OnCommandCalledServer = function (player, message)
        	for _, v in ipairs(player.serverUserData.techTreeProgress) do
        		if (v.id ~= "08") then
	        		for x, y in pairs(v.turret) do
	        			v.turret[x] = "2"
	        		end
	        		for x, y in pairs(v.hull) do
	        			v.hull[x] = "2"
	        		end
	        		for x, y in pairs(v.engine) do
	        			v.engine[x] = "2"
	        		end
	        		for x, y in pairs(v.crew) do
	        			v.crew[x] = "2"
	        		end	        		
	        	end
        	end
        end,
        OnCommandReceivedClient = function (player, message)
        	for _, v in ipairs(player.clientUserData.techTreeProgress) do
        		if (v.id ~= "08") then
	        		for x, y in pairs(v.turret) do
	        			v.turret[x] = "2"
	        		end
	        		for x, y in pairs(v.hull) do
	        			v.hull[x] = "2"
	        		end
	        		for x, y in pairs(v.engine) do
	        			v.engine[x] = "2"
	        		end
	        		for x, y in pairs(v.crew) do
	        			v.crew[x] = "2"
	        		end	        		
	        	end
        	end
        end,
        description = "unlock all tank upgrades",
        requireMessage = false,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.Admin
    },
    
    ["/resetallupgrades"] = {
        OnCommandCalledClient = function (player, message)       
        end,
        OnCommandCalledServer = function (player, message)
        	for _, v in ipairs(player.serverUserData.techTreeProgress) do
        		if (v.id ~= "08") then
	        		for x, y in pairs(v.turret) do
	        			v.turret[x] = "0"
	        		end
	        		for x, y in pairs(v.hull) do
	        			v.hull[x] = "0"
	        		end
	        		for x, y in pairs(v.engine) do
	        			v.engine[x] = "0"
	        		end
	        		for x, y in pairs(v.crew) do
	        			v.crew[x] = "0"
	        		end	        		
	        	end
        	end
        end,
        OnCommandReceivedClient = function (player, message)
        	for _, v in ipairs(player.clientUserData.techTreeProgress) do
        		if (v.id ~= "08") then
	        		for x, y in pairs(v.turret) do
	        			v.turret[x] = "0"
	        		end
	        		for x, y in pairs(v.hull) do
	        			v.hull[x] = "0"
	        		end
	        		for x, y in pairs(v.engine) do
	        			v.engine[x] = "0"
	        		end
	        		for x, y in pairs(v.crew) do
	        			v.crew[x] = "0"
	        		end	        		
	        	end
        	end
        end,
        description = "unlock all tank upgrades",
        requireMessage = false,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.Admin
    },
    
    ["/unlockalltanks"] = {
        OnCommandCalledClient = function (player, message)       
        end,
        OnCommandCalledServer = function (player, message)
        	for _, v in ipairs(player.serverUserData.techTreeProgress) do
        		if (v.id ~= "01") and (v.id ~= "18") and (v.id ~= "08") then
	        		v.researched = true
	        		v.purchased = true
	        	end
        	end
        end,
        OnCommandReceivedClient = function (player, message)
        end,
        description = "unlock all tanks (requires restart)",
        requireMessage = false,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.Admin
    },
    
    ["/reverttanks"] = {
        OnCommandCalledClient = function (player, message)       
        end,
        OnCommandCalledServer = function (player, message)
        	Events.Broadcast("COMMAND_OVERRRIDE", player, "REVERT_TANKS", nil)
        	for _, v in ipairs(player.serverUserData.techTreeProgress) do
        		if (v.id ~= "01") and (v.id ~= "18") then
	        		v.researched = false
	        		v.purchased = false
	        	end
        	end
        end,
        OnCommandReceivedClient = function (player, message)
        end,
        description = "revert all tank progress (requires restart)",
        requireMessage = false,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.Admin
    },
    
    ["/reverttankstorage"] = {
        OnCommandCalledClient = function (player, message)       
        end,
        OnCommandCalledServer = function (player, message)
        	for section in (message.." "):gmatch("(.-) ") do
        		if not string.find(section, "reverttankstorage") then
        			Events.Broadcast("COMMAND_OVERRRIDE", player, "REVERT_STORAGE", section)
				end
        	end  
        end,
        OnCommandReceivedClient = function (player, message)
        end,
        description = "revert tank storage using a backup (requires backup version and game restart)",
        requireMessage = false,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.Admin
    },
    
    ["/resettankstorage"] = {
        OnCommandCalledClient = function (player, message)       
        end,
        OnCommandCalledServer = function (player, message)
        	for section in (message.." "):gmatch("(.-) ") do
        		if not string.find(section, "reverttankstorage") then
        			Events.Broadcast("COMMAND_OVERRRIDE", player, "RESET_STORAGE", section)
				end
        	end  
        end,
        OnCommandReceivedClient = function (player, message)
        end,
        description = "revert tank storage using a backup (requires backup version and game restart)",
        requireMessage = false,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.Admin
    },
    
     ["/forcemap"] = {
        OnCommandCalledClient = function (player, message)       
        end,
        OnCommandCalledServer = function (player, message)
        	for section in (message.." "):gmatch("(.-) ") do
        		local number = tonumber(section)
        		if number then
        			Events.Broadcast("FORCE_SELECTED_MAP", number)
        		end
        	end         	
        end,
        OnCommandReceivedClient = function (player, message)
        	for section in (message.." "):gmatch("(.-) ") do
        		local number = tonumber(section)
        		if number then
        			Chat.LocalMessage("Forced Map" .. tostring(number))
        		end
        	end 
        end,
        description = "Force map to be selected. Format: /forcemap <mapNumber>",
        requireMessage = false,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.Admin
    },
    
    ["/playerxp"] = {
        OnCommandCalledClient = function (player, message)
        	
        	for section in (message.." "):gmatch("(.-) ") do

        		if tonumber(section) then
        		
        			Chat.LocalMessage("Setting XP resource to " .. section)
        			
        			return
        			
        		end
        	
        	end

        	Chat.LocalMessage("ERROR: command does not contain a valid resource amount. Format: /playerxp <XPValue>")
        end,
        OnCommandCalledServer = function (player, message)
        	
        	for section in (message.." "):gmatch("(.-) ") do

        		if tonumber(section) then
        		
        			player:SetResource("XP", tonumber(section))
        			
        			return
        			
        		end
        	
        	end
        	
        end,
        OnCommandReceivedClient = function (player, message)
        end,
        description = "Set the player xp value (determines rank). Format: /playerxp <XPValue>",
        requireMessage = false,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.HigherAdmin
    },
    
    ["/parts"] = {
        OnCommandCalledClient = function (player, message)
        
            local resourceFound = nil
        	local number = nil
        	
        	for section in (message.." "):gmatch("(.-) ") do
        	
        		number = tonumber(section)
        	
        		if number then
        		
        			if number > 0 and number <= 33 then
        		
        				resourceFound = section
        				
        			elseif resourceFound then
        				
        				Chat.LocalMessage("Setting T_" .. resourceFound .. "tank parts resource to " .. tostring(number))
        				
        				return
        			end
        		
        		end
        	
        	end
        	
        	
        	
        	Chat.LocalMessage("ERROR: command does not contain a tankID or valid resource amount. Format: /parts <tankID> <tankPartsValue>")
        end,
        OnCommandCalledServer = function (player, message)
        
        	local resourceFound = nil
        	local number = nil
        	
        	for section in (message.." "):gmatch("(.-) ") do
        	
        		number = tonumber(section)
        	
        		if number then
        		
        			if number > 0 and number <= 33 then
        		
        				resourceFound = section
        				
        			elseif resourceFound then
        			
        				player:SetResource("T_" .. resourceFound .. "RP", number)
        				
        			end
        		
        		end
        	
        	end
        end,
        OnCommandReceivedClient = function (player, message)
        end,
        description = "Set the XP resource of a tank. Format: /tp <tankID> <tankPartsValue>",
        requireMessage = false,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.HigherAdmin
    },
    
    ["/uparts"] = {
        OnCommandCalledClient = function (player, message)
        	
        	for section in (message.." "):gmatch("(.-) ") do

        		if tonumber(section) then
        		
        			Chat.LocalMessage("Setting Universal Parts resource to " .. section)
        			
        			return
        			
        		end
        	
        	end

        	Chat.LocalMessage("ERROR: command does not contain a valid resource amount. Format: /uparts <universalPartsValue>")
        end,
        OnCommandCalledServer = function (player, message)
        	
        	for section in (message.." "):gmatch("(.-) ") do

        		if tonumber(section) then
        		
        			player:SetResource("Free XP", tonumber(section))
        			
        			return
        			
        		end
        	
        	end
        	
        end,
        OnCommandReceivedClient = function (player, message)
        end,
        description = "Set the Silver resource of the player. Format: /uparts <universalPartsValue>",
        requireMessage = false,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.HigherAdmin
    },
    
    ["/sl"] = {
        OnCommandCalledClient = function (player, message)
        	
        	for section in (message.." "):gmatch("(.-) ") do

        		if tonumber(section) then
        		
        			Chat.LocalMessage("Setting Silver resource to " .. section)
        			
        			return
        			
        		end
        	
        	end

        	Chat.LocalMessage("ERROR: command does not contain a valid resource amount. Format: /sl <silverValue>")
        end,
        OnCommandCalledServer = function (player, message)
        	
        	for section in (message.." "):gmatch("(.-) ") do

        		if tonumber(section) then
        		
        			player:SetResource("Silver", tonumber(section))
        			
        			return
        			
        		end
        	
        	end
        	
        end,
        OnCommandReceivedClient = function (player, message)
        end,
        description = "Set the Silver resource of the player. Format: /sl <silverValue>",
        requireMessage = false,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.HigherAdmin
    },
    
    ["/gold"] = {
        OnCommandCalledClient = function (player, message)
        	
        	for section in (message.." "):gmatch("(.-) ") do

        		if tonumber(section) then
        		
        			Chat.LocalMessage("Setting Gold resource to " .. section)
        			
        			return
        			
        		end
        	
        	end

        	Chat.LocalMessage("ERROR: command does not contain a valid resource amount. Format: /gold <GoldValue>")
        end,
        OnCommandCalledServer = function (player, message)
        	
        	for section in (message.." "):gmatch("(.-) ") do

        		if tonumber(section) then
        		
        			player:SetResource("Gold", tonumber(section))
        			
        			return
        			
        		end
        	
        	end
        	
        end,
        OnCommandReceivedClient = function (player, message)
        end,
        description = "Set the Silver resource of the player. Format: /gold <GoldValue>",
        requireMessage = false,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.HigherAdmin
    },
    
    ["/equip"] = {
        OnCommandCalledClient = function (player, message)       
        end,
        OnCommandCalledServer = function (player, message)
        	local number = nil
        	local upgradeAppled = false
        	
        	player.serverUserData.TankUpgradeOverride = {}
        	
        	for section in (message.." "):gmatch("(.-) ") do
        		if upgradeAppled then
	        		number = tonumber(section)
	        		if number and number > 0 and number < 34 then
	        			Events.Broadcast("SET_EQUIPPED_TANK", player, section)
	        			return
	        		end
	        	elseif section == "0" then
        			player.serverUserData.TankUpgradeOverride = {0, 0, 0}
        			upgradeAppled = true
        		elseif section == "1" then
        			player.serverUserData.TankUpgradeOverride = {2, 2, 2}
        			upgradeAppled = true
        		elseif string.find(section, ",") then
        			for _, part in pairs{CoreString.Split(section, ",")} do
        				number = tonumber(part)
        				if number and number == 1 then
        					number = 2
        				end
        				if number then
        					table.insert(player.serverUserData.TankUpgradeOverride, number)
        				end
        			end
        			upgradeAppled = true
	        	end
        	end 
        	
        end,
        OnCommandReceivedClient = function (player, message)
        end,
        description = "Equip a specific tank with a specified upgrade. 0 for no upgrades, 1 for all upgrades, and x,x,x for specific upgrades. Format: /equip <upgrade> <tankID>",
        requireMessage = false,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.Admin
    },
    
     ["/forcemap"] = {
        OnCommandCalledClient = function (player, message)       
        end,
        OnCommandCalledServer = function (player, message)
        	for section in (message.." "):gmatch("(.-) ") do
        		local number = tonumber(section)
        		if number then
        			Events.Broadcast("FORCE_SELECTED_MAP", number)
        		end
        	end         	
        end,
        OnCommandReceivedClient = function (player, message)
        	for section in (message.." "):gmatch("(.-) ") do
        		local number = tonumber(section)
        		if number then
        			Chat.LocalMessage("Forced Map" .. tostring(number))
        		end
        	end 
        end,
        description = "Force map to be selected. Format: /forcemap <mapNumber>",
        requireMessage = false,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.Admin
    },
    
    ["/respawn"] = {
        OnCommandCalledClient = function (player, message)       
        end,
        OnCommandCalledServer = function (player, message)
        	player:Respawn()        	
        end,
        OnCommandReceivedClient = function (player, message)
        end,
        description = "Respawn (for casese when falling through the map).",
        requireMessage = false,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.Admin
    },
    ["/fps"] = {
        OnCommandCalledClient = function (player, message)
        end,
        OnCommandCalledServer = function (player, message)
        end,
        OnCommandReceivedClient = function (player, message)
        end,
        description = "shows a list of available commands",
        requireMessage = false,
        adminOnly = false,
        adminRank = AdminData.AdminRanks.None
    },

    ["/help"] = {
        OnCommandCalledClient = function (player, message)
            for i, v in pairs(commands) do
                if (i ~= "/adminall") then
                    if v.adminRank <= (AdminData.Rank[player.name] or AdminData.AdminRanks.None) then 
                        Chat.LocalMessage(i .. ": " .. v.description)
                    end
                end
            end
        end,
        OnCommandCalledServer = function (player, message)
        end,
        OnCommandReceivedClient = function (player, message)
        end,
        description = "shows a list of available commands",
        requireMessage = false,
        adminOnly = false,
        adminRank = AdminData.AdminRanks.None
    },

    ["/fillteams"] = {
        OnCommandCalledClient = function (player, message)
        end,
        OnCommandCalledServer = function (player, message)
            local teamSize = 2
            for section in (message.." "):gmatch("(.-) ") do
                if tonumber(section) then
                    teamSize = tonumber(section)
                end
            end

            Events.Broadcast("FILL_TEAMS_WITH_AI", teamSize)
        end,
        OnCommandReceivedClient = function (player, message)
        end,
        description = "fills the teams with AI tanks",
        requireMessage = false,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.Admin
    },

    ["/testai"] = {
        OnCommandCalledClient = function (player, message)
        end,
        OnCommandCalledServer = function (player, message)
            Events.Broadcast("SPAWN_TEST_AI", player)
        end,
        OnCommandReceivedClient = function (player, message)
        end,
        description = "spawns an enemy to test with",
        requireMessage = false,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.Admin
    },

    ["/setrank"] = {
        OnCommandCalledClient = function(player,message)
        end,
        OnCommandCalledServer = function(player,message)
            --set rank here lol
            local messageParts = {CoreString.Split(message," ")}
            if tonumber(messageParts[2]) then
                player:SetResource("LEVEL",tonumber(messageParts[2]))
                player:SetResource("XP",0)
            end
        end,
        OnCommandReceivedClient = function(player,message)
        end,
        description = "sets player's profile rank",
        requireMessage = false,
        adminOnly = true,
        adminRank = AdminData.AdminRanks.Admin
    },
--[[     ["/ragdoll"] = {
        OnCommandCalledClient = function (player, message)
            Chat.LocalMessage(messagePrefix.." toggle player ragdoll")
        end,
        OnCommandCalledServer = function (player, message)
            if not ragdollData[player] then
                player:EnableRagdoll("lower_spine", .4)
                player:EnableRagdoll("right_shoulder", .2)
                player:EnableRagdoll("left_shoulder", .6)
                player:EnableRagdoll("right_hip", .6)
                player:EnableRagdoll("left_hip", .6)
                ragdollData[player] = true
            else
                player:DisableRagdoll()
                ragdollData[player] = nil
            end
        end,
        OnCommandReceivedClient = function (player, message)
        end,
        description = "ragdoll player",
        requireMessage = false,
        adminOnly = false
    },
]]



}

return commands