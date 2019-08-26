local A, GreyHandling = ...

function GreyHandling.functions.DisplayCheapest(text, item)
	if GreyHandling.options.VERBOSE then
		if item.itemCount == 1 then
			print(
				text, GetContainerItemLink(item.bag, item.slot), "worth", GetCoinTextureString(item.currentPrice),
				"(max ", GetCoinTextureString(item.potentialPrice), ")"
			)
		elseif item.potentialPrice == item.currentPrice then
			print(
				text, "A full stack of", GetContainerItemLink(item.bag, item.slot), "worth",
				GetCoinTextureString(item.potentialPrice)
			)
		else
			print(
				text, GetContainerItemLink(item.bag, item.slot), item.itemCount, "*",
				GetCoinTextureString(item.vendorPrice),	"=", GetCoinTextureString(item.currentPrice),
				"(max ", GetCoinTextureString(item.potentialPrice), ")"
			)
		end
	end
end

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
				if (itemRarity == 0 and vendorPrice > 0) then
					-- or (itemRarity == 1 and
					-- (itemClassID == LE_ITEM_CLASS_WEAPON or itemClassID == LE_ITEM_CLASS_ARMOR))
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
	local exchange = {}
	-- If we need to throw some
	exchange.item = itemLink
	exchange["realLoss"] = (itemStackCount - ourCount - theirCount) * vendorPrice
	if exchange["realLoss"] > 0 then
		exchange["realLoss"] = 0
	end
	-- What we give
	exchange["giveOurLoss"] = ourCount * vendorPrice
	exchange["takeTheirLoss"] = theirCount * vendorPrice
	-- What we get
	exchange["takeOurGain"] =  theirCount * vendorPrice
	local giveTheirGainIfFull = (itemStackCount - theirCount) * vendorPrice
	if giveTheirGainIfFull > ourCount * vendorPrice then
		exchange["giveTheirGain"] = ourCount * vendorPrice
	else
		exchange["giveTheirGain"] = giveTheirGainIfFull
	end
	--print(format("If we give %s, we loose %s they win %s", itemLink,
--			GetCoinTextureString(exchange["giveOurLoss"]), GetCoinTextureString(exchange["giveTheirGain"])))
	--print(format("If they give %s, they loose %s, we win %s", itemLink,
--		GetCoinTextureString(exchange["takeTheirLoss"]), GetCoinTextureString(exchange["takeOurGain"])))
	return exchange
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
					local ourGain = takenValues["takeOurGain"] - givenValues["giveOurLoss"]
					local theirGain = givenValues["giveTheirGain"] - takenValues["takeTheirLoss"]
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
						fair = {itemGiven=itemGiven, itemTaken=itemTaken, ourGain=ourGain, theirGain=theirGain,
							totalGain=totalGain, fairness=fairness, playerId=player_id}
					end
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

function GreyHandling.functions.GlowCheapestGrey()
    local now, later = GreyHandling.functions.GetCheapestItem()
	--local egoist, altruist, fair = GreyHandling.functions.GetBestExchange()
	local fair = GreyHandling.functions.GetBestExchange()
	if now.bag and now.slot then
		if now.bag==later.bag and now.slot==later.slot or now.potentialPrice == later.potentialPrice then
			-- Only one item is the cheapest
			GreyHandling.functions.DisplayCheapest("Cheapest:", now)
			PickupContainerItem(now.bag, now.slot)
			if GreyHandling.options.TALKATIVE then
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
			GreyHandling.functions.DisplayCheapest("Cheapest now:", now)
			GreyHandling.functions.DisplayCheapest("Cheapest later:", later)
			if IsAddOnLoaded("Inventorian") then
				if GreyHandling.options.VERBOSE then
					print("GreyHandling: It seems you're using Inventorian. Please note that the feature for glowing two items is not yet fully supported.")
				end
			else
				GreyHandling.functions.SetBagItemGlow(now.bag, now.slot, "bags-glow-orange")
				GreyHandling.functions.SetBagItemGlow(later.bag, later.slot, "bags-glow-orange")
			end
		end
	end
	if fair.itemGiven and fair.itemTaken then
		local exchange_value = "They win one bag space "
		if fair.theirGain > 0 then
			exchange_value = format("%sand %s, ", exchange_value, GetCoinTextureString(fair.theirGain))
		else
			exchange_value = format("%sand loose %s, ", exchange_value, GetCoinTextureString(-fair.theirGain))
		end
		exchange_value = format("%syou win 1 bag space and ", exchange_value)
		if fair.ourGain > 0 then
			exchange_value = format("%s%s", exchange_value, GetCoinTextureString(fair.ourGain))
		else
			exchange_value = format("%sloose %s", exchange_value, GetCoinTextureString(-fair.ourGain))
		end
		local bag, slot = GreyHandling.functions.GetBagAndSlot(fair.itemGiven)
		if bad and slot then
			GreyHandling.functions.SetBagItemGlow(bag, slot, "bags-glow-orange")
		end
		msg = format("You could give %s your %s in exchange of their %s. %s.", GreyHandling.data.names[fair.playerId],
			fair.itemGiven, fair.itemTaken, exchange_value)
		print(msg)
		-- SendChatMessage(msg)
		--else
		--	print("GreyHandling: There are no grey items to throw away. Maybe you don't need this Hearthstone after all? ;)")
	end
end