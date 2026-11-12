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
LE_ITEM_CLASS_WEAPON  = LE_ITEM_CLASS_WEAPON  or (Enum.ItemClass and Enum.ItemClass.Weapon) or 2
LE_ITEM_CLASS_ARMOR   = LE_ITEM_CLASS_ARMOR   or (Enum.ItemClass and Enum.ItemClass.Armor)  or 4
LE_ITEM_ARMOR_GENERIC = LE_ITEM_ARMOR_GENERIC or (Enum.ItemArmorSubclass and Enum.ItemArmorSubclass.Generic) or 0
if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
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
