local A, GreyHandling = ...

function GlowCheapestGrey()
	local minPriceNow = nil
	local bagNumNow = nil
	local slotNumNow = nil
	local minPriceFuture = nil
	local currentPriceFuture = nil
	local currentNumberFuture = nil
	local bagNumFuture = nil
	local slotNumFuture = nil
	for bagID = 0, NUM_BAG_SLOTS do
		for bagSlot = 1, GetContainerNumSlots(bagID) do
			local itemid = GetContainerItemID(bagID, bagSlot)
			local itemLink = GetContainerItemLink(bagID, bagSlot)
			local _, itemCount = GetContainerItemInfo(bagID, bagSlot)
			if itemid then
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
					itemEquipLoc, itemIcon, vendorPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID,
					isCraftingReagent = GetItemInfo(itemid)
				if itemRarity == 0 and vendorPrice > 0 then
					local _, itemCount = GetContainerItemInfo(bagID, bagSlot)
					local currentVendorPrice = vendorPrice * itemCount
					local potentialVendorPrice = vendorPrice * itemStackCount
					if minPriceNow == nil then
						minPriceNow = currentVendorPrice
						bagNumNow = bagID
						slotNumNow = bagSlot
					elseif minPriceNow > currentVendorPrice then
						minPriceNow = currentVendorPrice
						bagNumNow = bagID
						slotNumNow = bagSlot
					end
					if minPriceFuture == nil then
						minPriceFuture = potentialVendorPrice
						currentPriceFuture = vendorPrice * itemCount
						currentNumberFuture = itemCount
						bagNumFuture = bagID
						slotNumFuture = bagSlot
					elseif minPriceFuture > potentialVendorPrice then
						minPriceFuture = potentialVendorPrice
						currentPriceFuture = vendorPrice * itemCount
						currentNumberFuture = itemCount
						bagNumFuture = bagID
						slotNumFuture = bagSlot
					end
				end
			end
		end
	end
	if bagNumNow and slotNumNow then
		GreyHandling.functions.SetBagItemGlow(bagNumNow, slotNumNow, "bags-glow-orange")
		if bagNumNow==bagNumFuture and slotNumNow==slotNumFuture then
			itemLink = GetContainerItemLink(bagNumNow, slotNumNow)
			if VERBOSE then
				print("Cheapest:", itemLink, GetCoinTextureString(minPriceNow))
			end
			PickupContainerItem(bagNumNow,slotNumNow)
			if TALKATIVE then
				if currentNumberFuture == 1 then
					msg = format("I can give you %s if you have some bag space left.", itemLink)
				else
					msg = format("I can give you %s*%s if you have some bag space left.", itemLink, currentNumberFuture)
				end
				SendChatMessage(msg)
			end
			CloseAllBags()
		else
			if VERBOSE then
				print("Cheapest now:", GetContainerItemLink(bagNumNow, slotNumNow), GetCoinTextureString(minPriceNow)) --, "(max ", GetCoinTextureString(minPriceFuture), ")")
				print("Cheapest later:", currentNumberFuture, "*", GetContainerItemLink(bagNumFuture, slotNumFuture), GetCoinTextureString(currentPriceFuture),
				"(max ", GetCoinTextureString(minPriceFuture), ")")
			end
			GreyHandling.functions.SetBagItemGlow(bagNumFuture, slotNumFuture, "bags-glow-orange")
		end
	else
		print("GreyHandling : No grey to throw, maybe you don't need this hearthstone after all ;) ?")
	end
end

GreyHandling.functions.GlowCheapestGrey =  GlowCheapestGrey