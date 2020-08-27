local A, GreyHandling = ...

function GreyHandling.functions.getPrice(link, itemSellPrice)
    if not(link) then
        if itemSellPrice then
            return itemSellPrice
        else
            return 0
        end
    end
    if IsAddOnLoaded("TradeSkillMaster") and not(GreyHandlingSourceOfItemPrice == GreyHandling["Vendor Price"]) then
		local tsmSellPrice = TSM_API.GetCustomPriceValue("dbMarket", TSM_API.ToItemString(link))
        if not(itemSellPrice) or tsmSellPrice and tsmSellPrice > itemSellPrice * GreyHandling.options.AUCTION_HOUSE_CUT then
            itemSellPrice = tsmSellPrice
        end
    end
    return itemSellPrice
end

function GreyHandling.functions.GetItemInfo(link)
    local _, itemLink, _, _, _, _, _, itemStackCount, _, _, itemSellPrice, itemClassID, itemSubClassID = GetItemInfo(link)
    return itemLink, itemStackCount, GreyHandling.functions.getPrice(link, itemSellPrice), itemClassID, itemSubClassID
end

function GreyHandling.functions.ToolTipHook(t)
    local link = select(2, t:GetItem())
    if not link then
        return
    end
    local itemLink, itemStackCount, itemSellPrice, itemClassID, itemSubClassID = GreyHandling.functions.GetItemInfo(link)
    if GreyHandlingShowPrice then
        -- local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
        -- itemEquipLoc, itemIcon, vendorPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo(link)
        --print(
        -- "- itemName", itemName, "- itemLink", itemLink, "- ItemRarity", itemRarity, "- ItemLevel", itemLevel,
        -- "- itemMinLevel", itemMinLevel, "- itemType", itemType, "- ItemSubType", itemSubType, "- ItemStackCount",
        --   itemStackCount, "- ItemEquipLoc", itemEquipLoc, "- ItemIcon", itemIcon,
        --    "- VendorPrice", vendorPrice, "- ItemClassID", itemClassID, "- ItemSubClassId", itemSubClassID,
        --    "- bindType", bindType, "- expacID",  expacID,"- ItemSetID",  itemSetID, "- isCraftingReagent", isCraftingReagent
        --)
        if not itemSellPrice or itemSellPrice <= 0 or not itemStackCount then
            -- Can be a quest item, mild spices, or hearthstone for example
            GameTooltip:AddLine(GreyHandling["Cannot be sold"], "1", "0.5", "0.5")
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
            if itemClassID == LE_ITEM_CLASS_WEAPON or itemClassID == LE_ITEM_CLASS_ARMOR and itemSubClassID ~= LE_ITEM_ARMOR_GENERIC then
                -- TODO Take into account the damage to stuff (price go down not linearly)
                -- Ie stuff is worth 18 coppers at 60/60, but 6 copper at 45/60
                -- bagID, bagSlot = from t ?
                -- local currentDurability, maximumDurability = GetContainerItemDurability(bagID, bagSlot)
                if GreyHandling.IS_CLASSIC then
                    SetTooltipMoney(t, itemSellPrice, nil, format("%s %s", SELL_PRICE, GreyHandling["(100% durability)"]))
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
        local now, later = GreyHandling.functions.GetCheapestJunk()
        -- local texture, itemCount, locked, quality, readable, lootable, itemLink = GetContainerItemInfo(now.bag, now.slot);
        if now.bag and later.bag then
            local message = ""
            local _, nowitemCount, _, _, _, _, nowitemLink = GetContainerItemInfo(now.bag, now.slot);
            local _, lateritemCount, _, _, _, _, lateritemLink = GetContainerItemInfo(later.bag, later.slot);
            if nowitemLink==itemLink then
                if nowitemLink==lateritemLink then
                    message = GreyHandling["Cheapest (now and later)"]
                else
                    message = GreyHandling["Cheapest (right now)"]
                end
            end
            if lateritemLink==itemLink and nowitemLink~=lateritemLink then
                message = GreyHandling["Cheapest (later)"]
            end
            GameTooltip:AddLine(message, 1, 0.5, 0.5)
        end
    end
end
