GetContainerNumSlots = GetContainerNumSlots or C_Container.GetContainerNumSlots
GetContainerItemID = GetContainerItemID or C_Container.GetContainerItemID
GetContainerItemDurability = GetContainerItemDurability or C_Container.GetContainerItemDurability
-- Need this to still be nil in GetItemCount
-- local GetContainerItemInfo = GetContainerItemInfo or C_Container.GetContainerItemInfo

function GetItemCount(bagID, bagSlot)
    local itemInfo = C_Container.GetContainerItemInfo(bagID, bagSlot)
    return itemInfo and itemInfo.stackCount or 0
end

function GetItemCountAndLink(bagID, bagSlot)
    local itemInfo = C_Container.GetContainerItemInfo(bagID, bagSlot)
    if itemInfo then
        return itemInfo.stackCount, itemInfo.hyperlink
    end
    return 0, nil
end
