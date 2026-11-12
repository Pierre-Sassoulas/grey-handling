GetContainerNumSlots = GetContainerNumSlots or C_Container.GetContainerNumSlots
GetContainerNumFreeSlots = GetContainerNumFreeSlots or C_Container.GetContainerNumFreeSlots
GetContainerItemID = GetContainerItemID or C_Container.GetContainerItemID
GetContainerItemDurability = GetContainerItemDurability or C_Container.GetContainerItemDurability
GetItemInfo = GetItemInfo or C_Item.GetItemInfo
GetCoinTextureString = GetCoinTextureString or C_CurrencyInfo.GetCoinTextureString
GetItemQualityColor = GetItemQualityColor or function(quality)
    local c = ITEM_QUALITY_COLORS[quality]
    return c.r, c.g, c.b, c.hex
end
if not GreyHandling.IS_CLASSIC then
    -- In retail 12.x, MoneyFrame reads protected frame sizes and crashes when
    -- called from addon-tainted code. Replace with a plain AddLine.
    SetTooltipMoney = function(tooltip, amount, _, prefix)
        tooltip:AddLine(format("%s %s", prefix or "", GetCoinTextureString(amount)), 1, 1, 1)
    end
end
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
