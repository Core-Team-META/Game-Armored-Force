local UTIL_API = require(script:GetCustomProperty("MetaAbilityProgressionUTIL_API"))
local _Constants_API = require(script:GetCustomProperty("Constants_API"))

local shopViewUI = script:GetCustomProperty("ShopViewUI"):WaitForObject()
local premiumTanks = script:GetCustomProperty("PremiumTanks"):WaitForObject()
local premiumTankEntry = script:GetCustomProperty("PremiumTankEntry")
local convertFreeXP = script:GetCustomProperty("ConvertFreeXP"):WaitForObject()
local tankXPEntry = script:GetCustomProperty("TankXPEntry")
local goldAmountText = script:GetCustomProperty("GoldAmountText"):WaitForObject()
local freeXPAmountText = script:GetCustomProperty("FreeXPAmountText"):WaitForObject()
local subscriptionTitle = script:GetCustomProperty("SubscriptionTitle"):WaitForObject()
local premiumSubscription = script:GetCustomProperty("PremiumSubscription")

local alliesPremiumButton = script:GetCustomProperty("ALLIES_PURCHASE_PREMIUM_BUTTON"):WaitForObject()
local axisPremiumButton = script:GetCustomProperty("AXIS_PURCHASE_PREMIUM_BUTTON"):WaitForObject()

 
local TANK_INFO  = _Constants_API:WaitForConstant("Tanks").GetTanks()
local CURRENCY = _Constants_API:WaitForConstant("Currency")
local TECHTREE = _Constants_API:WaitForConstant("TechTree")
local thisComponent = "SHOP_MENU"
local savedState = ""

local premiumTanksInfo = {}
local xpTanksInfo = {}
local xpTanksButtonInfo = {}
local xpTankString = ""
local totalXPTanks = 0

local localPlayer = Game.GetLocalPlayer()


function ToggleThisComponent(requestedPlayerState)

	savedState = requestedPlayerState
	
	if requestedPlayerState == thisComponent then

		freeXPAmountText.text = "Free XP: " .. tostring(localPlayer:GetResource(CURRENCY.FREERP.ResourceName))
		goldAmountText.text = "Gold: " .. tostring(localPlayer:GetResource(CURRENCY.GOLD.ResourceName))
		
		CheckPerks(localPlayer, premiumSubscription)
		CheckPremiumTankOwnership()
		PopulateXPTanks()
		
		Task.Wait(2)

		if savedState ~= thisComponent or shopViewUI.isEnabled then
			return
		end
	
		shopViewUI.isEnabled = true
	
	else
		Task.Wait(0.1)
		DisableThisComponent()
	end
	
end

function DisableThisComponent()
	
	shopViewUI.isEnabled = false
	
end

function OnResourceChanged(player, resource, amount)

	if resource == CURRENCY.FREERP.ResourceName then
		freeXPAmountText.text = "Free XP: " .. tostring(amount)
		PopulateXPTanks()
	elseif resource == CURRENCY.GOLD.ResourceName then
		goldAmountText.text = "Gold: " .. tostring(amount)
	end

end

function CheckPerks(player, perk)

	if player ~= localPlayer then
		return
	end

	if player:HasPerk(premiumSubscription) then
		subscriptionTitle.visibility = Visibility.INHERIT
	else
		subscriptionTitle.visibility = Visibility.FORCE_OFF
	end

end

function CheckPremiumTankOwnership()

	for x, t in pairs(localPlayer.clientUserData.techTreeProgress) do
		if t.purchased == true and premiumTanksInfo[t.id] then
			premiumTanksInfo[t.id].button.isInteractable = false
			premiumTanksInfo[t.id].button.text = "PURCHASED"
		end
	end

end

function AttemptPremiumPurchase(button)

	--print("attempting to purchase")
	if localPlayer:GetResource(CURRENCY.GOLD.ResourceName) >= premiumTanksInfo[button.id].cost then
		Events.BroadcastToServer("PurchasePremTank", premiumTanksInfo[button.id].id)
	else 
		AcknowledgePurchase(premiumTanksInfo[button.id].id, false)
	end
	
end

function AcknowledgePurchase(tankId, confirmed)
	
	if not premiumTanksInfo[tankId] then
		return
	end
	
	local button = premiumTanksInfo[tankId].button
		
	if not confirmed then
		if button then			
			button.isInteractable = false
			button.text = "NOT ENOUGH GOLD"
			Task.Wait(1)
			button.isInteractable = true
			button.text = "1000 Gold"			
		end
		return
	end
	
	for x, t in pairs(localPlayer.clientUserData.techTreeProgress) do
		if t.id == tankId then
			t.purchased = true
			t.researched = true
			for x, y in pairs(t.turret) do
				tank.turret[x] = 2
			end
			for x, y in pairs(t.hull) do
				tank.hull[x] = 2
			end
			for x, y in pairs(t.engine) do
				tank.engine[x] = 2
			end
			for x, y in pairs(t.crew) do
				tank.crew[x] = 2
			end
			--print("Purchase successful")
		end
	end
	
	if button then
		button.isInteractable = false
		button.text = "PURCHASED"
	end

end

function ConvertXP(button)

	if xpTankString ~= "" then
		Events.BroadcastToServer("ConvertXP", xpTankString)
	end

end

function ToggleXPTanks(button)

	if not xpTanksButtonInfo[button.id].toggled and totalXPTanks < 10 then
		xpTanksButtonInfo[button.id].toggled = true
		button.text = "X"
		totalXPTanks = totalXPTanks + 1
	elseif  xpTanksButtonInfo[button.id].toggled then
		xpTanksButtonInfo[button.id].toggled = false
		button.text = "[   ]"
		totalXPTanks = totalXPTanks - 1
	else 
		warn("ERROR: exceeding 10 tank limit")
	end
	
	UpdateTotalXP()

end

function UpdateTotalXP()

	xpTankString = ""
	local totalAmount = 0

	for i, e in pairs(xpTanksInfo) do
		if e.toggled then
			xpTankString = xpTankString .. ":" .. i
			totalAmount = totalAmount + e.amount
		end
	end
	
	convertFreeXP:GetCustomProperty("XPToFreeXPText"):WaitForObject().text = "Convert " .. tostring(totalAmount) .. " XP"
	convertFreeXP:GetCustomProperty("GoldCostText"):WaitForObject().text = "for " .. tostring(math.ceil(totalAmount/100)) .. " Gold"
	
end

function PopulateXPTanks()

	xpTankString = ""
	totalXPTanks = 0
	totalAmount = 0

	for _, e in ipairs(xpTanksInfo) do
		e.listener:Disconnect()
	end
	
	for _, c in ipairs(convertFreeXP:GetCustomProperty("ScrollPanel"):WaitForObject():GetChildren()) do
		c:Destroy()
	end
	
	xpTanksInfo = {}
	xpTanksButtonInfo = {}
	
	local id = ""
	local name = ""
	local resourceAmount = 0
	local tankCount = 0
	
	for x, t in ipairs(TANK_INFO) do
		id = t.id
		name = t.name
		resourceAmount = localPlayer:GetResource(UTIL_API.GetTankRPString(tonumber(id)))
		
		if resourceAmount > 0 then
			xpTanksInfo[id] = {}
			xpTanksInfo[id].entry = World.SpawnAsset(tankXPEntry, {parent = convertFreeXP:GetCustomProperty("ScrollPanel"):WaitForObject()})
			xpTanksInfo[id].entry.y = tankCount * (xpTanksInfo[id].entry.height + 10)
			xpTanksInfo[id].button = xpTanksInfo[id].entry:GetCustomProperty("TankSelectButton"):WaitForObject()
			xpTanksInfo[id].listener = xpTanksInfo[id].button.clickedEvent:Connect(ToggleXPTanks)
			xpTanksInfo[id].entry:GetCustomProperty("XPAmount"):WaitForObject().text = name .. ": " .. tostring(resourceAmount) .. " RP"
			xpTanksInfo[id].amount = resourceAmount
			xpTanksInfo[id].toggled = false
			
			xpTanksButtonInfo[xpTanksInfo[id].button.id] = xpTanksInfo[id]
			
			tankCount = tankCount + 1
		end
	end
	
	UpdateTotalXP()
	
end

function PopulatePremiumTanks()

	local entryCount = 0
	local premiumEntry = nil
	local button = nil
	local cost = ""
	local id = ""
	
	--print("populating premium tanks")
	
	for x, t in ipairs(TANK_INFO) do
		if t.purchaseCurrencyName == "Gold" then
			local team = t.team
			
			if team == "Allies" then
				button = alliesPremiumButton
				--print("Allies button set")
			elseif team == "Axis" then
				button = axisPremiumButton
				--print("Axis button set")
			end
			
			--premiumEntry = World.SpawnAsset(premiumTankEntry, {parent = premiumTanks:GetCustomProperty("ScrollPanel"):WaitForObject()})
			cost = t.purchaseCost
			id = t.id

			--premiumEntry.y = entryCount * (premiumEntry.height + 10)
			--premiumEntry:GetCustomProperty("TankText"):WaitForObject().text = t:GetCustomProperty("Name")
			--premiumEntry:GetCustomProperty("CostText"):WaitForObject().text = "Gold: " .. cost
			--button.text = "PURCHASE"
			
			premiumTanksInfo[button.id] = {}
			premiumTanksInfo[button.id].cost = tonumber(cost)
			premiumTanksInfo[button.id].id = id
			premiumTanksInfo[id] = {}
			--premiumTanksInfo[id].entry = premiumEntry
			premiumTanksInfo[id].button = button
			
			button.clickedEvent:Connect(AttemptPremiumPurchase)
			
			for y, p in ipairs(localPlayer.clientUserData.techTreeProgress) do
				if p.id == id and p.purchased then
					button.isInteractable = false
					button.text = "PURCHASED"
				end
			end
			
			entryCount = entryCount + 1
		end
	end
	
	--print("finished setting up premium tanks")

end

function InitializeComponent()

	shopViewUI.visibility = Visibility.FORCE_ON
	
	shopViewUI.isEnabled = false
		
	localPlayer.perkChangedEvent:Connect(CheckPerks)
	localPlayer.resourceChangedEvent:Connect(OnResourceChanged)
	convertFreeXP:GetCustomProperty("ConvertButton"):WaitForObject().clickedEvent:Connect(ConvertXP)

end

InitializeComponent()

Events.Connect("ENABLE_GARAGE_COMPONENT", ToggleThisComponent)
Events.Connect("DISABLE_ALL_GARAGE_COMPONENTS", DisableThisComponent)
Events.Connect("TankClientDataSet", PopulatePremiumTanks)
Events.Connect("PremTankPurchased", AcknowledgePurchase)