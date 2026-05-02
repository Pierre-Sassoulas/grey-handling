local A, GreyHandling = ...

local function GetTotalFreeBagSlots()
    local free = 0
    for bagID = 0, NUM_BAG_SLOTS do
        local f = GetContainerNumFreeSlots(bagID)
        if f then
            free = free + f
        end
    end
    return free
end

local function GetStackableSpaceForItem(itemLink)
    local _, _, _, _, _, _, _, itemStackCount = GetItemInfo(itemLink)
    if not itemStackCount or itemStackCount <= 1 then
        return 0
    end
    local lootItemID = GreyHandling.functions.getIDNumber(itemLink)
    if not lootItemID then
        return 0
    end
    local space = 0
    for bagID = 0, NUM_BAG_SLOTS do
        for bagSlot = 1, GetContainerNumSlots(bagID) do
            if GetContainerItemID(bagID, bagSlot) == lootItemID then
                local stackCount = GetItemCount(bagID, bagSlot)
                if stackCount > 0 and stackCount < itemStackCount then
                    space = space + (itemStackCount - stackCount)
                end
            end
        end
    end
    return space
end

function GreyHandling.functions.LootTooltipHook(tooltip, slot)
    if not GreyHandlingShowPrice or not slot then
        return
    end
    local link = GetLootSlotLink(slot)
    if not link then
        return
    end
    if GetTotalFreeBagSlots() > 0 then
        return
    end
    local stackableSpace = GetStackableSpaceForItem(link)
    if stackableSpace > 0 then
        tooltip:AddLine(
            format(GreyHandling["Take it: you can stack %s more."], stackableSpace),
            0.5, 1, 0.5
        )
        tooltip:Show()
        return
    end
    local now = GreyHandling.now
    if not now or not now.itemLink or not now.currentPrice then
        tooltip:AddLine(GreyHandling["Bag full and no junk to drop."], 1, 0.5, 0.5)
        tooltip:Show()
        return
    end
    local _, _, count = GetLootSlotInfo(slot)
    count = tonumber(count) or 1
    local _, _, _, _, _, _, _, _, _, _, vendorPrice = GetItemInfo(link)
    local price = GreyHandling.functions.getPrice(link, vendorPrice)
    if not price or price <= 0 then
        tooltip:AddLine(GreyHandling["Leave on corpse (loot has no value)."], 1, 0.5, 0.5)
        tooltip:Show()
        return
    end
    local lootValue = price * count
    if lootValue > now.currentPrice then
        tooltip:AddLine(
            format(GreyHandling["Take it: worth %s more than your cheapest junk."],
                GetCoinTextureString(lootValue - now.currentPrice)
            ),
            0.5, 1, 0.5
        )
    else
        tooltip:AddLine(
            format(GreyHandling["Leave on corpse: cheapest junk is worth %s more."],
                GetCoinTextureString(now.currentPrice - lootValue)
            ),
            1, 0.5, 0.5
        )
    end
    tooltip:Show()
end
