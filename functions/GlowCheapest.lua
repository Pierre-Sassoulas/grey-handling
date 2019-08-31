local A, GreyHandling = ...

function GreyHandling.functions.GetBagAndSlot(itemLink)
	for bagID = 0, NUM_BAG_SLOTS do
		for bagSlot = 1, GetContainerNumSlots(bagID) do
			local testedItemLink = GetContainerItemLink(bagID, bagSlot)
			if testedItemLink == itemLink then
				return bagID, bagSlot
			end
		end
	end
end

function GreyHandling.functions.GetCheapestItem()
	local now = {}
	now.currentPrice = nil
	local later = {}
	later.potentialPrice = nil
	for bagID = 0, NUM_BAG_SLOTS do
		for bagSlot = 1, GetContainerNumSlots(bagID) do
			if IsAddOnLoaded("ArkInventory") then
				local loc_id, bag_id = ArkInventory.BlizzardBagIdToInternalId(bagID)
				local _, item = ArkInventory.API.ItemFrameGet( loc_id, bag_id, bagSlot)
				ActionButton_HideOverlayGlow(item)
			end
			local itemid = GetContainerItemID(bagID, bagSlot)

			local _, itemCount = GetContainerItemInfo(bagID, bagSlot)
			if itemid then
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
					itemEquipLoc, itemIcon, vendorPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID,
					isCraftingReagent = GetItemInfo(itemid)
				local isJunk = nil
				if IsAddOnLoaded("Scrap") then
					isJunk = Scrap:IsJunk(itemid, bagID, bagSlot)
				else
					isJunk = (itemRarity == 0 and vendorPrice > 0)
				end
				if  isJunk then
					local _, itemCount = GetContainerItemInfo(bagID, bagSlot)
                    local currentDurability, maximumDurability = GetContainerItemDurability(bagID, bagSlot)
                    local modifier = 1
                    if currentDurability and maximumDurability then
                        modifier= currentDurability / maximumDurability
                    end
					local currentVendorPrice = vendorPrice * itemCount * modifier
					local potentialVendorPrice = vendorPrice * itemStackCount
					if now.currentPrice == nil or now.currentPrice > currentVendorPrice then
						now.currentPrice = currentVendorPrice
						now.potentialPrice = potentialVendorPrice
						now.itemCount = itemCount
						now.vendorPrice = vendorPrice
						now.bag = bagID
						now.slot = bagSlot
					end
					if later.potentialPrice == nil or
							later.potentialPrice > potentialVendorPrice or
							(later.potentialPrice==potentialVendorPrice and later.currentPrice > currentVendorPrice) then
						later.currentPrice = currentVendorPrice
						later.potentialPrice = potentialVendorPrice
						later.itemCount = itemCount
						later.vendorPrice = vendorPrice
						later.bag = bagID
						later.slot = bagSlot
					end
				end
			end
		end
	end
    return now, later
end

function GreyHandling.functions.CreateExchange(itemLink, ourCount, theirCount, vendorPrice, itemStackCount)
	-- When we have no bag space we'll have to throw some
	local lossCount = itemStackCount - ourCount - theirCount
	if lossCount > 0 then
		lossCount = 0
	end
	return {
		item = itemLink,
		vendorPrice = vendorPrice,
		ourCount = ourCount,
		theirCount = theirCount,
		lossCount = lossCount,
	}
end

function GreyHandling.functions.displayTrade(message, trade)
	local exchange_value = ""
	-- print(trade.theirGain)
	if trade.theirGain < 0 then
		if trade.ourGain > 0 then
			exchange_value = format("You should give them %s as compensation", GetCoinTextureString(trade.ourGain))
		else
			exchange_value = format("We loose %s and they loose %s", GetCoinTextureString(-trade.ourGain), GetCoinTextureString(-trade.theirGain))
		end
	else
		if trade.theirGain > 0 then
			exchange_value = format("They should give you %s as compensation", GetCoinTextureString(trade.theirGain))
		else
			exchange_value = format("They loose %s", GetCoinTextureString(-trade.theirGain))
		end
	end
	print(format("%s Give %s to %s and take %s (%s)", message, trade.itemGiven, trade.playerId, trade.itemTaken, exchange_value))
end

function GreyHandling.functions.GetBestExchange()
	local exchanges = {}
	for player_id, items in pairs(GreyHandling.data.items) do
		for itemLink, itemInformation  in pairs(items) do
			local ourCount = GetItemCount(itemLink)
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
				itemEquipLoc, itemIcon, vendorPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID,
				isCraftingReagent = GetItemInfo(itemLink)
			if ourCount ~= 0 then
				if exchanges[player_id] == nil then
					exchanges[player_id] = {}
				end
				exchanges[player_id][itemLink] = GreyHandling.functions.CreateExchange(itemLink, ourCount,
					itemInformation.number, itemInformation.vendorPrice, itemInformation.itemStackCount
				)
			end
		end
	end
	--local egoist = {itemGiven=nil, itemTaken=nil, ourGain=0, theirGain=0, totalGain=0, fairness=nil, playerId=nil}
	--local altruist = {itemGiven=nil, itemTaken=nil, ourGain=0, theirGain=0, totalGain=0, fairness=nil, playerId=nil}
	local fair = {itemGiven=nil, itemTaken=nil, ourGain=0, theirGain=0, totalGain=0, fairness=nil, playerId=nil}
	for player_id, item_link_values in pairs(exchanges) do
		for itemGiven, givenValues in pairs(item_link_values) do
			for itemTaken, takenValues in pairs(item_link_values) do
				if itemGiven ~= itemTaken then
					-- print(itemGiven.item, givenValues.ourCount, GetCoinTextureString(givenValues.vendorPrice), itemTaken.item, takenValues.theirCount, GetCoinTextureString(takenValues.vendorPrice))
					local given =  givenValues.ourCount * givenValues.vendorPrice
					local taken = takenValues.theirCount * takenValues.vendorPrice
					local ourGain = taken - given - givenValues.lossCount * givenValues.vendorPrice
					local theirGain = given - taken - takenValues.lossCount * takenValues.vendorPrice
					local totalGain = theirGain + ourGain
					local fairness = (theirGain - ourGain) * (theirGain - ourGain)
	--				if ourGain > egoist.ourGain then
	--					egoist = {itemGiven=itemGiven, itemTaken=itemTaken, ourGain=ourGain, theirGain=theirGain,
	--						totalGain=totalGain, fairness=fairness, playerId=player_id}
	--				end
	--				if theirGain > altruist.theirGain then
	--					altruist = {itemGiven=itemGiven, itemTaken=itemTaken, ourGain=ourGain, theirGain=theirGain,
	--						totalGain=totalGain, fairness=fairness, playerId=player_id}
	--				end
					if fair.fairness==nil or fairness < fair.fairness then
						fair = {itemGiven=itemGiven, itemTaken=itemTaken, ourGain=ourGain, theirGain=theirGain,ourCount=givenValues.ourCount,
								theirCount=takenValues.theirCount,
							totalGain=totalGain, fairness=fairness, playerId=player_id}
					end
					--print(GreyHandling.functions.userPrintableExchange(
--							{itemGiven=itemGiven, itemTaken=itemTaken, ourGain=ourGain, theirGain=theirGain, ourCount=givenValues.ourCount,
--								theirCount=takenValues.theirCount,
							--totalGain=totalGain, fairness=fairness, playerId=player_id }
						--)
					--)
				end
			end

		end
	end
	--GreyHandling.functions.displayTrade("Egoist trade:", egoist)
	--GreyHandling.functions.displayTrade("Altruist trade:", altruist)
	-- GreyHandling.functions.displayTrade("Fairer trade:", fair)
	--return egoist, altruist, fair
	return fair
end

function GreyHandling.functions.userPrintableExchange(exchange)
	local msg = ""
	if exchange.theirGain ~= -exchange.ourGain then
		if exchange.theirGain > 0 then
			msg = format("They win %s. ", GetCoinTextureString(exchange.theirGain))
		else
			msg = format("They loose %s. ", GetCoinTextureString(-exchange.theirGain))
		end
	end
	if exchange.ourGain > 0 then
		msg = format("%sYou should give them %s", msg, GetCoinTextureString(exchange.ourGain))
	else
		msg = format("%sYou could ask for %s", msg, GetCoinTextureString(-exchange.ourGain))
	end
	return format(
		"Exchange your %s*%s for %s's %s*%s : %s", exchange.itemGiven, exchange.ourCount, GreyHandling.data.names[exchange.playerId],
		exchange.itemTaken, exchange.theirCount, msg
	)
end

function GreyHandling.functions.GlowCheapestGrey()
	local foundSomething = nil
    local now, later = GreyHandling.functions.GetCheapestItem()
	--local egoist, altruist, fair = GreyHandling.functions.GetBestExchange()
	local fair = GreyHandling.functions.GetBestExchange()
	if now.bag and now.slot then
		foundSomething = true
		if now.bag==later.bag and now.slot==later.slot or now.potentialPrice == later.potentialPrice then
			-- Only one item is the cheapest
			GreyHandling.functions.DisplayCheapestInChat("Cheapest:", now)
			PickupContainerItem(now.bag, now.slot)
			if GreyHandlingIsTalkative then
				local itemLink = GetContainerItemLink(now.bag, now.slot)
				if now.itemCount == 1 then
					msg = format("I can give you %s if you have enough bag places.", itemLink)
				else
					msg = format("I can give you %s*%s if you have enough bag places.", itemLink, now.itemCount)
				end
				SendChatMessage(msg)
			end
			GreyHandling.functions.SetBagItemGlow(now.bag, now.slot, "bags-glow-orange")
			CloseAllBags()
		else
			-- Two items can be considered cheapest
			GreyHandling.functions.DisplayCheapestInChat("Cheapest now:", now)
			GreyHandling.functions.DisplayCheapestInChat("Cheapest later:", later)
			if IsAddOnLoaded("Inventorian") then
				if GreyHandlingIsVerbose then
					print("GreyHandling: It seems you're using Inventorian. Please note that the feature for glowing two items is not yet fully supported.")
				end
			else
				GreyHandling.functions.SetBagItemGlow(now.bag, now.slot, "bags-glow-orange")
				GreyHandling.functions.SetBagItemGlow(later.bag, later.slot, "bags-glow-orange")
			end
		end
	else
		print("No grey found in bag.")
	end
	if fair.itemGiven and fair.itemTaken then
		foundSomething = true
		local bag, slot = GreyHandling.functions.GetBagAndSlot(fair.itemGiven)
		if bag and slot then
			GreyHandling.functions.SetBagItemGlow(bag, slot, "bags-glow-orange")
		end
		print(GreyHandling.functions.userPrintableExchange(fair))
		-- SendChatMessage(msg)
		--else
		--	print("GreyHandling: There are no grey items to throw away. Maybe you don't need this Hearthstone after all? ;)")
	else
		print("No mutually beneficial trade found.")
	end
	if not foundSomething then
		CloseAllBags()
	end
end