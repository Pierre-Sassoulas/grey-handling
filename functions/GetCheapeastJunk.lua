local A, GreyHandling = ...

function GreyHandling.useScrap()
	return IsAddOnLoaded("Scrap") and GreyHandlingWhatIsJunkValue == GreyHandling["Junk according to Scrap"]
end

function GreyHandling.usePeddler()
	return IsAddOnLoaded("Peddler") and GreyHandlingWhatIsJunkValue == GreyHandling["Marked for sell by Peddler"]
end

function GreyHandling.isJunk(bagID, bagSlot)
	local itemid = GetContainerItemID(bagID, bagSlot)
	if itemid and GreyHandling.useScrap() then
		return Scrap:IsJunk(itemid, bagID, bagSlot)
	end
	return GreyHandling.isJunkByItemId(itemid, bagID, bagSlot)
end

function GreyHandling.isJunkByItemLink(itemLink)
	local _, itemLink = GetItemInfo(itemLink)
	if not itemLink then
		return false
	end
	local itemid = GreyHandling.functions.getIDNumber(itemLink)
	return GreyHandling.isJunkByItemId(itemid)
end

function GreyHandling.isJunkByItemId(itemid, bagID, bagSlot)
	if not itemid then
		return false
	end
	if GreyHandling.useScrap() then
		-- print("Using scrap to determine if "..itemid.." is junk.")
		return Scrap:IsJunk(itemid, bagID, bagSlot)
	elseif GreyHandling.usePeddler() then
		-- print("Using Peddler to determine if "..itemid.." is marked for sell.")
		local uniqueItemID = PeddlerAPI.getUniqueItemID(bagID, bagSlot)
		return PeddlerAPI.itemIsToBeSold(itemid, uniqueItemID)
	else
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
			itemEquipLoc, itemIcon, vendorPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID,
			isCraftingReagent = GetItemInfo(itemid)
		if not vendorPrice or vendorPrice <= 0 then
			return false
		end
		-- Grey Items (it's the default)
		local minRarity = 0
		if GreyHandlingWhatIsJunkValue == GreyHandling["Common Items"] then
			minRarity = 1
		end
		if GreyHandlingWhatIsJunkValue == GreyHandling["Uncommon Items"] then
			minRarity = 2
		end
		if GreyHandlingWhatIsJunkValue == GreyHandling["Rare Items"] then
			minRarity = 3
		end
		if GreyHandlingWhatIsJunkValue == GreyHandling["All Items"] then
			minRarity = 100
		end
		return itemRarity <= minRarity
	end
end

function GreyHandling.functions.CalculateCheapestJunk()
	local now = {}
	now.currentPrice = nil
	local later = {}
	later.potentialPrice = nil
	for bagID = 0, NUM_BAG_SLOTS do
		for bagSlot = 1, GetContainerNumSlots(bagID) do
			local itemid = GetContainerItemID(bagID, bagSlot)
			if itemid and GreyHandling.isJunk(bagID, bagSlot) then
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
					now.itemLink = itemLink
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
					later.itemLink = itemLink
					later.itemCount = itemCount
					later.itemStackCount = itemStackCount
					later.vendorPrice = vendorPrice
					later.bag = bagID
					later.slot = bagSlot
				end
			end
		end
	end
	GreyHandling.now = now
    GreyHandling.later = later
	if now.bag==later.bag and now.slot==later.slot or now.potentialPrice == later.potentialPrice then
		GreyHandling.only_one_item_is_cheapest = true
	else
		GreyHandling.only_one_item_is_cheapest = false
	end
	-- print("Calculated cheapest object")
end

function GreyHandling.functions.ItemDidNotMove(now_or_later)
	if not now_or_later.bag or not now_or_later.slot then
		return false
	end
	local _, testedItemCount, _, _, _, _, testedItemLink = GetContainerItemInfo(now_or_later.bag, now_or_later.slot)
	return now_or_later.itemLink == testedItemLink  and now_or_later.itemCount == testedItemCount
end

function GreyHandling.functions.UpdateCheapestJunkPosition()
	if not GreyHandling.now.itemLink then
		return
	end
	-- print("Checked that cheapest object position did not change.")
	if (GreyHandling.functions.ItemDidNotMove(GreyHandling.now) and
			(GreyHandling.only_one_item_is_cheapest or GreyHandling.functions.ItemDidNotMove(GreyHandling.later))
	) then
		return
	end
	-- print("Updated cheapest object position.")
	local bag, slot = GreyHandling.functions.GetBagAndSlot(GreyHandling.now.itemLink, GreyHandling.now.itemCount)
	GreyHandling.now.bag = bag
	GreyHandling.now.slot = slot
	if not GreyHandling.only_one_item_is_cheapest then
		bag, slot = GreyHandling.functions.GetBagAndSlot(
				GreyHandling.later.itemLink,
				GreyHandling.later.itemCount
		)
	end
	GreyHandling.later.bag = bag
	GreyHandling.later.slot = slot
end

function GreyHandling.functions.GetCheapestJunk()
	-- print("Just got cheapest without calculation")
	return GreyHandling.now, GreyHandling.later
end
