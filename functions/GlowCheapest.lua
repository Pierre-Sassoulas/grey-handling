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

function GreyHandling.functions.GlowCheapestGrey()
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
				if (itemRarity == 0 and vendorPrice > 0) or
                    (itemRarity == 1 and (itemClassID == LE_ITEM_CLASS_WEAPON or itemClassID == LE_ITEM_CLASS_ARMOR))then
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
	if now.bag and now.slot then
		if now.bag==later.bag and now.slot==later.slot or now.potentialPrice == later.potentialPrice then
			-- Only one object is the clear cheapest
			GreyHandling.functions.DisplayCheapest("Cheapest:", now)
			PickupContainerItem(now.bag, now.slot)
			if GreyHandling.options.TALKATIVE then
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
			GreyHandling.functions.DisplayCheapest("Cheapest now:", now)
			GreyHandling.functions.DisplayCheapest("Cheapest later:", later)
			GreyHandling.functions.SetBagItemGlow(now.bag, now.slot, "bags-glow-orange")
			GreyHandling.functions.SetBagItemGlow(later.bag, later.slot, "bags-glow-orange")
		end
	else
		print("GreyHandling : No grey to throw, maybe you don't need this hearthstone after all ;) ?")
	end
end