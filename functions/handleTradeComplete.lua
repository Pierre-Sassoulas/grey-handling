local A, GreyHandling = ...

local tradePartnerName = nil
local tradeCompleted = false

local function UpdateDatabaseAfterTrade()
    if not tradePartnerName or not tradeCompleted then
        return
    end

    local playerName = GreyHandling.data.playerName

    GreyHandling.db.initializePlayer(playerName)
    GreyHandling.db.initializePlayer(tradePartnerName)

    local hasChanges = false

    if GreyHandling.data.items[playerName] then
        for itemLink, itemInfo in pairs(GreyHandling.data.items[playerName]) do
            if itemLink ~= "bagSpace" and GreyHandling.isJunkByItemLink(itemLink) then
                local dbCount = itemInfo.number or 0
                local actualCount = C_Item.GetItemCount(itemLink)

                if actualCount < dbCount then
                    -- We gave this item
                    local amountTraded = dbCount - actualCount
                    hasChanges = true
                    GreyHandling.db.setItemInfoForPlayer(playerName, itemLink, "number", actualCount)
                    if not GreyHandling.data.items[tradePartnerName][itemLink] then
                        local _, _, _, _, _, _, _, itemStackCount, _, _, vendorPrice = GetItemInfo(itemLink)
                        GreyHandling.db.initializeItem(tradePartnerName, itemLink, vendorPrice, itemStackCount, 0, 0)
                    end
                    local partnerCount = GreyHandling.db.getItemInfoForPlayer(tradePartnerName, itemLink, "number")
                    GreyHandling.db.setItemInfoForPlayer(tradePartnerName, itemLink, "number", partnerCount + amountTraded)

                    if GreyHandlingIsVerbose then
                        GreyHandling.print(format("|cff%sGave:|r %sx%d to %s",
                            GreyHandling.bluePrint, itemLink, amountTraded, tradePartnerName))
                    end

                elseif actualCount > dbCount then
                    -- We received this item
                    local amountReceived = actualCount - dbCount
                    hasChanges = true

                    GreyHandling.db.setItemInfoForPlayer(playerName, itemLink, "number", actualCount)

                    if GreyHandling.data.items[tradePartnerName] and GreyHandling.data.items[tradePartnerName][itemLink] then
                        local partnerCount = GreyHandling.db.getItemInfoForPlayer(tradePartnerName, itemLink, "number")
                        GreyHandling.db.setItemInfoForPlayer(tradePartnerName, itemLink, "number", math.max(0, partnerCount - amountReceived))
                    end

                    if GreyHandlingIsVerbose then
                        GreyHandling.print(format("|cff%sReceived:|r %sx%d from %s",
                            GreyHandling.bluePrint, itemLink, amountReceived, tradePartnerName))
                    end
                end
            end
        end
    end

    local newItemLinks = {}
    for bagID = 0, NUM_BAG_SLOTS do
        for bagSlot = 1, GetContainerNumSlots(bagID) do
            if GreyHandling.isJunk(bagID, bagSlot) then
                local itemLink = C_Container.GetContainerItemLink(bagID, bagSlot)
                if itemLink and not newItemLinks[itemLink] and
                        (not GreyHandling.data.items[playerName][itemLink] or
                         GreyHandling.data.items[playerName][itemLink].number == 0) then
                    newItemLinks[itemLink] = true
                end
            end
        end
    end
    for itemLink in pairs(newItemLinks) do
        local count = C_Item.GetItemCount(itemLink)
        if count > 0 then
            hasChanges = true
            local _, _, _, _, _, _, _, itemStackCount, _, _, vendorPrice = GetItemInfo(itemLink)
            GreyHandling.db.initializeItem(playerName, itemLink, vendorPrice, itemStackCount, count, 0)
            GreyHandling.db.setItemInfoForPlayer(playerName, itemLink, "number", count)

            -- Update partner's count (if they had it)
            if GreyHandling.data.items[tradePartnerName] and GreyHandling.data.items[tradePartnerName][itemLink] then
                local partnerCount = GreyHandling.db.getItemInfoForPlayer(tradePartnerName, itemLink, "number")
                GreyHandling.db.setItemInfoForPlayer(tradePartnerName, itemLink, "number", math.max(0, partnerCount - count))
            end

            if GreyHandlingIsVerbose then
                GreyHandling.print(format("|cff%sReceived new:|r %sx%d from %s",
                    GreyHandling.bluePrint, itemLink, count, tradePartnerName))
            end
        end
    end

    if hasChanges then
        -- broadcast our updated inventory and recalculate
        GreyHandling.functions.ExchangeMyJunkPlease()
        GreyHandling.functions.CalculateCheapestJunk()
    end
end

function GreyHandling.trade_frame:OnEvent(event, ...)
    if event == "TRADE_SHOW" then
        local name, realm = UnitName("NPC")
        if name then
            if realm and realm ~= "" then
                name = format("%s-%s", name, realm)
            end
            tradePartnerName = GreyHandling.db.uniformizePlayerName(name)
            tradeCompleted = false
            if GreyHandlingIsVerbose then
                GreyHandling.print(format("Trading with %s", tradePartnerName))
            end
        end

    elseif event == "UI_INFO_MESSAGE" then
        local _, message = ...
        if message == ERR_TRADE_COMPLETE then
            tradeCompleted = true
        end

    elseif event == "TRADE_CLOSED" then
        if tradeCompleted and tradePartnerName then
            -- Small delay to ensure bags are updated
            C_Timer.After(0.2, UpdateDatabaseAfterTrade)
        end
        C_Timer.After(0.5, function()
            tradePartnerName = nil
            tradeCompleted = false
        end)
    end
end
