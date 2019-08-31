local A, GreyHandling = ...

local L = GreyHandling:GetLocalization()

function GreyHandling.functions.ToolTipHook(t)
    if GreyHandlingShowPrice and GreyHandling.HANDLE_MESSAGE_IS_BROKEN < 10 then
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
                return -- error("nil GetMouseFocus()")
            end
            local bn = c:GetName() and (c:GetName() .. "Count")
            local count = c.count or (c.Count and c.Count:GetText()) or (c.Quantity and c.Quantity:GetText()) or (bn and _G[bn] and _G[bn]:GetText())
            count = tonumber(count) or 1
            if count <= 1 then
                count = 1
            end
            if count ~= itemStackCount then
                if GreyHandling.IS_CLASSIC then
                    -- We don't have the real value in classic so we create everything on two lines
                    SetTooltipMoney(t, count*itemSellPrice, nil, format("%s (%s*%s) :", SELL_PRICE, count, GetCoinTextureString(itemSellPrice)))
                elseif count ~= 1 then
                    -- Changing the wow tooltip directly is hard because we'd need to recover the real value
                    -- So three lines it is
                    SetTooltipMoney(t, itemSellPrice, nil, format("%s (1) :", SELL_PRICE))
                end
            end
            SetTooltipMoney(t, itemStackCount * itemSellPrice, nil, format("%s (%s) :", SELL_PRICE, itemStackCount))
        else
            if itemClassID == LE_ITEM_CLASS_WEAPON or itemClassID == LE_ITEM_CLASS_ARMOR then
                -- TODO Take into account the damage to stuff (price go down not linearly)
                -- Ie stuff is worth 18 coppers at 60/60, but 6 copper at 45/60
                -- bagID, bagSlot = from t ?
                -- local currentDurability, maximumDurability = GetContainerItemDurability(bagID, bagSlot)
                SetTooltipMoney(t, itemSellPrice, nil, format("%s %s", SELL_PRICE, "(100% durability)"))
            else
                SetTooltipMoney(t, itemSellPrice, nil, format("%s", SELL_PRICE))
            end
        end
        for player_id, items in pairs(GreyHandling.data.items) do
            for items_id, itemInformation  in pairs(items) do
                if items_id == link then
                    GameTooltip:AddLine(
                        format("%s: %s/%s", GreyHandling.data.names[player_id], itemInformation.number,
                            itemInformation.itemStackCount)
                    )
                end
            end
	    end
    end
end
