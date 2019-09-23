local A, GreyHandling = ...

local L = GreyHandling:GetLocalization()

function GreyHandling.functions.ToolTipHook(t)
    if GreyHandlingShowPrice then
        local link = select(2, t:GetItem())
        if not link then
            return
        end
        local _, _, _, _, _, _, _, itemStackCount, _, _, itemSellPrice, itemClassID = GetItemInfo(link)
        -- local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
        -- itemEquipLoc, itemIcon, vendorPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo(link)
        --print(
        -- "- itemName", itemName, "- itemLink", itemLink, "- ItemRarity", itemRarity, "- ItemLevel", itemLevel,
        -- "- itemMinLevel", itemMinLevel, "- itemType", itemType, "- ItemSubType", itemSubType, "- ItemStackCount",
        --   itemStackCount, "- ItemEquipLoc", itemEquipLoc, "- ItemIcon", itemIcon,
        --    "- VendorPrice", vendorPrice, "- ItemClassID", itemClassID, "- ItemSubClassId", itemSubClassID,
        --    "- bindType", bindType, "- expacID",  expacID,"- ItemSetID",  itemSetID, "- isCraftingReagent", isCraftingReagent
        --)
        if not itemSellPrice or itemSellPrice <= 0 then
            -- Can be a quest item, mild spices, or hearthstone for example
            GameTooltip:AddLine("Cannot be sold", "1", "0.5", "0.5")
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
            SetTooltipMoney(t, itemSellPrice, nil, format("%s (1) :", SELL_PRICE))
            if count ~= itemStackCount and count ~= 1 and GreyHandling.IS_CLASSIC then
                SetTooltipMoney(t, count*itemSellPrice, nil, format("%s (%s) :", SELL_PRICE, count))
            end
            SetTooltipMoney(t, itemStackCount * itemSellPrice, nil, format("%s (%s) :", SELL_PRICE, itemStackCount))
        else
            if itemClassID == LE_ITEM_CLASS_WEAPON or itemClassID == LE_ITEM_CLASS_ARMOR then
                -- TODO Take into account the damage to stuff (price go down not linearly)
                -- Ie stuff is worth 18 coppers at 60/60, but 6 copper at 45/60
                -- bagID, bagSlot = from t ?
                -- local currentDurability, maximumDurability = GetContainerItemDurability(bagID, bagSlot)
                if GreyHandling.IS_CLASSIC then
                    SetTooltipMoney(t, itemSellPrice, nil, format("%s %s", SELL_PRICE, "(100% durability)"))
                end
            else
                SetTooltipMoney(t, itemSellPrice, nil, format("%s", SELL_PRICE))
            end
        end
        for playerName, items in pairs(GreyHandling.data.items) do
            if not playerName then
                break
            end
            for items_id, itemInformation  in pairs(items) do
                if items_id == link then
                    if itemInformation.confidence == 1 then
                        GameTooltip:AddLine(
                            format("(G) %s: %s/%s", playerName, itemInformation.number,
                                itemInformation.itemStackCount), 0.5, 1, 0.5
                        )
                    else
                        GameTooltip:AddLine(
                            format("(?) %s: %s/%s", playerName, itemInformation.number,
                                itemInformation.itemStackCount), 0.5, 0.5, 1
                        )
                    end
                end
            end
	    end
    end
end
