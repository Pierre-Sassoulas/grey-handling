local A, GreyHandling = ...


function GreyHandling.db.getItemInfoForPlayer(playerName, itemLink, infoName)
    playerName = GreyHandling.db.initializeItem(playerName, itemLink)
    return GreyHandling.data.items[playerName][itemLink][infoName]
end

function GreyHandling.db.setRemainingBagSpaceForPlayer(playerName, bagSpace)
    GreyHandling.db.initializePlayer(playerName, bagSpace)
end

function GreyHandling.db.getRemainingBagSpaceForPlayer(playerName)
    local playerName = GreyHandling.db.initializePlayer(playerName)
    return GreyHandling.data.items[playerName]["bagSpace"]
end

function GreyHandling.db.removePlayer(playerName)
    local playerName = GreyHandling.db.uniformizePlayerName(playerName)
    GreyHandling.data.items[playerName] = nil
end

function GreyHandling.db.setItemForPlayer(playerName, itemLink, vendorPrice, itemStackCount, number, confidence)
    -- print("In GreyHandling.db.addItemForPlayer :", playerName, itemLink, vendorPrice, itemStackCount, number)
    confidence = confidence or 0
    GreyHandling.db.initializeItem(playerName, itemLink, vendorPrice, itemStackCount, number, confidence)
    GreyHandling.db.setItemInfoForPlayer(playerName, itemLink, "number", number)
    GreyHandling.db.setItemInfoForPlayer(playerName, itemLink, "confidence", confidence)
end

function GreyHandling.db.removePlayerThatLeft(playerNames)
	for existingPlayerName, items in pairs(GreyHandling.data.items) do
        local shouldBeRemoved = true
        for playerName, _ in pairs(playerNames) do
            playerName = GreyHandling.db.uniformizePlayerName(playerName)
            if playerName == existingPlayerName then
                -- print(playerName, "exists and should not be removed.")
                shouldBeRemoved = false
            end
        end
        if shouldBeRemoved then
            if GreyHandlingIsVerbose then
                GreyHandling.print(format("Forgetting about %s's bag.", existingPlayerName))
            end
            GreyHandling.data.items[existingPlayerName] = nil
        end
    end
end

function GreyHandling.db.addItemFromStringForPlayer(playerName, itemString, vendorPrice, itemStackCount, number, confidence)
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
        itemEquipLoc, itemIcon, vendorPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID,
        isCraftingReagent = GetItemInfo(itemString)
    if not itemLink then
        print("Cannot add itemString:"..itemString)
        return
    end
    GreyHandling.db.addItemForPlayer(playerName, itemLink, vendorPrice, itemStackCount, number, confidence)
end

function GreyHandling.db.addItemForPlayer(playerName, itemLink, vendorPrice, itemStackCount, number, confidence)
    confidence = confidence or 0
    GreyHandling.db.initializeItem(playerName, itemLink, vendorPrice, itemStackCount)
    local old_number = GreyHandling.db.getItemInfoForPlayer(playerName, itemLink, "number")
    GreyHandling.db.setItemInfoForPlayer(playerName, itemLink, "number", old_number + number)
    GreyHandling.db.setItemInfoForPlayer(playerName, itemLink, "confidence", confidence)
end
