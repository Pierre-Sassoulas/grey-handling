local A, GreyHandling = ...

local function GlowCheapestGrey()
	local now = {}
	now.min = nil
	local later = {}
	later.min = nil
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
					if now.min == nil or now.min > currentVendorPrice then
						now.min = currentVendorPrice
						now.currentPrice = vendorPrice * itemCount
						now.currentNumber = itemCount
						now.bag = bagID
						now.slot = bagSlot
					end
					if later.min == nil or later.min > potentialVendorPrice then
						later.min = potentialVendorPrice
						later.currentPrice = vendorPrice * itemCount
						later.currentNumber = itemCount
						later.bag = bagID
						later.slot = bagSlot
					end
				end
			end
		end
	end
	if now.bag and now.slot then
		GreyHandling.functions.SetBagItemGlow(now.bag, now.slot, "bags-glow-orange")
		if now.bag==later.bag and now.slot==later.slot then
			itemLink = GetContainerItemLink(now.bag, now.slot)
			if VERBOSE then
				print("Cheapest:", itemLink, GetCoinTextureString(now.min))
			end
			PickupContainerItem(now.bag, now.slot)
			if TALKATIVE then
				if currentNumberFuture == 1 then
					msg = format("I can give you %s if you have some bag space left.", itemLink)
				else
					msg = format("I can give you %s*%s if you have some bag space left.", itemLink, later.currentNumber)
				end
				SendChatMessage(msg)
			end
			CloseAllBags()
		else
			if VERBOSE then
				print("Cheapest now:", GetContainerItemLink(now.bag, now.slot), GetCoinTextureString(now.min)) --, "(max ", GetCoinTextureString(later.min), ")")
				print("Cheapest later:", currentNumberFuture, "*", GetContainerItemLink(later.bag, later.slot), GetCoinTextureString(later.currentPrice),
				"(max ", GetCoinTextureString(later.min), ")")
			end
			GreyHandling.functions.SetBagItemGlow(later.bag, later.slot, "bags-glow-orange")
		end
	else
		print("GreyHandling : No grey to throw, maybe you don't need this hearthstone after all ;) ?")
	end
end

GreyHandling.functions.GlowCheapestGrey =  GlowCheapestGrey