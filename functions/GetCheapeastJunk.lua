local A, GreyHandling = ...

function GreyHandling.isJunk(bagID, bagSlot)
	local itemid = GetContainerItemID(bagID, bagSlot)
	if itemid and IsAddOnLoaded("Scrap") and GreyHandlingUseScrapJunkList then
		return Scrap:IsJunk(itemid, bagID, bagSlot)
	end
	return GreyHandling.isJunkByItemId(itemid, bagID, bagSlot)
end

function GreyHandling.isJunkByItemLink(itemLink)
	local _, itemLink = GetItemInfo(itemLink)
	if not itemLink then
		return false
	end
	-- print("Is "..itemLink.." junk ?")
	local itemid = GreyHandling.functions.getIDNumber(itemLink)
	-- print("Itemid for "..itemLink.." is ".. itemid)
	return GreyHandling.isJunkByItemId(itemid)
end

function GreyHandling.isJunkByItemId(itemid, bagID, bagSlot)
	if not itemid then
		return false
	end
	if IsAddOnLoaded("Scrap") and GreyHandlingUseScrapJunkList then
		-- print("Using scrap to determine if "..itemid.." is junk.")
		return Scrap:IsJunk(itemid, bagID, bagSlot)
	else
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
			itemEquipLoc, itemIcon, vendorPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID,
			isCraftingReagent = GetItemInfo(itemid)
		return itemRarity == 0 and vendorPrice > 0
	end
end

function GreyHandling.functions.GetCheapestJunk()
	local now = {}
	now.currentPrice = nil
	local later = {}
	later.potentialPrice = nil
	for bagID = 0, NUM_BAG_SLOTS do
		for bagSlot = 1, GetContainerNumSlots(bagID) do
			if IsAddOnLoaded("ArkInventory") then
				local loc_id, bag_id = ArkInventory.BlizzardBagIdToInternalId(bagID)
				local _, item = ArkInventory.API.ItemFrameGet(loc_id, bag_id, bagSlot)
				ActionButton_HideOverlayGlow(item)
			end
			local itemid = GetContainerItemID(bagID, bagSlot)
			if itemid then
				if GreyHandling.isJunk(bagID, bagSlot) then
					local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
						itemEquipLoc, itemIcon, vendorPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID,
						isCraftingReagent = GetItemInfo(itemid)
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
						now.itemStackCount = itemStackCount
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
						later.itemStackCount = itemStackCount
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
