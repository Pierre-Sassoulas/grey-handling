local A, GreyHandling = ...

local L = GreyHandling:GetLocalization()

function GreyHandling.functions.ToolTipHook(t)
    if not MerchantFrame:IsShown() and GreyHandling.options.SHOW_PRICE then
        local link = select(2, t:GetItem())
        if not link then
            return
        end
        local _, _, _, _, _, _, _, itemStackCount, _, _, itemSellPrice, itemClassID = GetItemInfo(link)
        if not itemSellPrice or itemSellPrice <= 0 then
            -- Can be a quest item for example
            return
        end
        if itemStackCount > 1 then
            local c = GetMouseFocus()
            if not c then
                error("nil GetMouseFocus()")
            end
            local bn = c:GetName() and (c:GetName() .. "Count")
            local count = c.count or (c.Count and c.Count:GetText()) or (c.Quantity and c.Quantity:GetText()) or (bn and _G[bn] and _G[bn]:GetText())
            count = tonumber(count) or 1
            if count <= 1 then
                count = 1
            end
            -- local to_add = 1 + string.len(format("%s%s", count, itemSellPrice))
            if count ~= itemStackCount then
                SetTooltipMoney(t, count*itemSellPrice, nil, format("%s (%s*%s)", SELL_PRICE, count, GetCoinTextureString(itemSellPrice)))
            end
            -- to_add = to_add - string.len(format("%s", itemStackCount))
            -- local formatting_space = ""
            -- print("Adding", to_add)
            -- for i = 0,to_add,1
            -- do
            --     formatting_space = format("%s ", formatting_space)
            -- end
            SetTooltipMoney(t, itemStackCount * itemSellPrice, nil, format("%s (%s)", SELL_PRICE, itemStackCount))
            -- SetTooltipMoney(t, curValue, nil, format("Max %s*%s (%s)", GetCoinTextureString(itemSellPrice), itemStackCount, GetCoinTextureString(maxValue)))
        else
            if itemClassID == LE_ITEM_CLASS_WEAPON or itemClassID == LE_ITEM_CLASS_ARMOR then
                -- TODO Take into account the damage to stuff (price go down not linearly)
                -- Ie stuff is worth 18 coppers at 60/60, but 6 copper at 45/60
                -- slot = From link ??
                -- print(GetInventoryItemDurability(slot))
                SetTooltipMoney(t, itemSellPrice, nil, format("%s %s", SELL_PRICE, "(Decreases fast if damaged)"))
            else
                SetTooltipMoney(t, itemSellPrice, nil, format("%s", SELL_PRICE))
            end
        end
        return true
    end
end
