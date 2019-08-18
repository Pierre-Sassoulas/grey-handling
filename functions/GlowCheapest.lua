local A, GreyHandling = ...

local function DisplayCheapest(text, item) -- bag, slot, vendorPrice, itemCount, currentPrice, potentialPrice)
	if item.itemCount == 1 then
		print(
			text, GetContainerItemLink(item.bag, item.slot), "worth", GetCoinTextureString(item.vendorPrice),
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

GreyHandling.functions.DisplayCheapest =  DisplayCheapest

local function GlowCheapestGrey()
	local now = {}
	now.currentPrice = nil
	local later = {}
	later.potentialPrice = nil
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
					if now.currentPrice == nil or now.currentPrice > currentVendorPrice then
						now.currentPrice = currentVendorPrice
						now.potentialPrice = potentialVendorPrice
						now.itemCount = itemCount
						now.vendorPrice = vendorPrice
						now.bag = bagID
						now.slot = bagSlot
					end
					if later.potentialPrice == nil or later.potentialPrice > potentialVendorPrice then
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
	if now.bag and now.slot then
		if now.bag==later.bag and now.slot==later.slot or now.potentialPrice == later.potentialPrice then
			-- Only one object is the clear cheapest
			if VERBOSE then
				GreyHandling.functions.DisplayCheapest("Cheapest:", now)
			end
			PickupContainerItem(now.bag, now.slot)
			if TALKATIVE then
				local itemLink = GetContainerItemLink(now.bag, now.slot)
				if now.itemCount == 1 then
					msg = format("I can give you %s if you have some bag space left.", itemLink)
				else
					msg = format("I can give you %s*%s if you have some bag space left.", itemLink, now.itemCount)
				end
				SendChatMessage(msg)
			end
			CloseAllBags()
		else
			-- Two objects can be considered cheapest
			if VERBOSE then
				GreyHandling.functions.DisplayCheapest("Cheapest now:", now)
				GreyHandling.functions.DisplayCheapest("Cheapest later:", later)
			end
			GreyHandling.functions.SetBagItemGlow(now.bag, now.slot, "bags-glow-orange")
			GreyHandling.functions.SetBagItemGlow(later.bag, later.slot, "bags-glow-orange")
		end
	else
		print("GreyHandling : No grey to throw, maybe you don't need this hearthstone after all ;) ?")
	end
end

GreyHandling.functions.GlowCheapestGrey =  GlowCheapestGrey