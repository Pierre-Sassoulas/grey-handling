GetContainerNumSlots = GetContainerNumSlots or C_Container.GetContainerNumSlots
GetContainerItemID = GetContainerItemID or C_Container.GetContainerItemID
GetContainerItemDurability = GetContainerItemDurability or C_Container.GetContainerItemDurability
-- Need this to still be nil in GetItemCount
-- local GetContainerItemInfo = GetContainerItemInfo or C_Container.GetContainerItemInfo

function GetItemCount(bagID, bagSlot)
	if C_Container then
		return GetContainerItemInfo(bagID, bagSlot).stackCount
	end
	local _, itemCount = GetContainerItemInfo(bagID, bagSlot)
	return itemCount
end

function GetItemCountAndLink(bagID, bagSlot)
	if C_Container then
		local itemTable = GetContainerItemInfo(bagID, bagSlot)
		return itemTable.stackCount, itemTable.itemLink
	end
	local _, testedItemCount, _, _, _, _, testedItemLink = GetContainerItemInfo(bagID, bagSlot)
	return testedItemCount, testedItemLink
end
