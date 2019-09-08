local A, GreyHandling = ...


function GreyHandling.db.getItemInfoForPlayer(playerName, itemLink, infoName)
    return GreyHandling.data.items[playerName][itemLink][infoName]
end

function GreyHandling.db.setItemInfoForPlayer(playerName, itemLink, infoName, value)
    GreyHandling.data.items[playerName][itemLink][infoName] = value
end

function GreyHandling.db.setRemainingBagSpaceForPlayer(playerName, bagSpace)
    GreyHandling.db.initializePlayer(playerName, bagSpace)
end

function GreyHandling.db.getRemainingBagSpaceForPlayer(playerName)
    GreyHandling.db.initializePlayer(playerName)
    return GreyHandling.data.items[playerName]["bagSpace"]
end

function GreyHandling.db.removePlayer(playerName)
    GreyHandling.data.items[playerName] = nil
end

function GreyHandling.db.setItemForPlayer(playerName, itemLink, vendorPrice, itemStackCount, number, confidence)
    -- print("In GreyHandling.db.addItemForPlayer :", playerName, itemLink, vendorPrice, itemStackCount, number)
    confidence = confidence or 0
    if not GreyHandling.db.playerItemInitialized(playerName, itemLink) then
        GreyHandling.db.initializeItem(playerName, itemLink, vendorPrice, itemStackCount)
    end
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
                print(format("%s: Forgetting about %s's bag.", GreyHandling.NAME, existingPlayerName))
            end
            GreyHandling.data.items[existingPlayerName] = nil
        end
    end
end

function GreyHandling.db.addItemForPlayer(playerName, itemLink, vendorPrice, itemStackCount, number, confidence)
    confidence = confidence or 0
    if not GreyHandling.db.playerItemInitialized(playerName, itemLink) then
        GreyHandling.db.initializeItem(playerName, itemLink, vendorPrice, itemStackCount)
    end
    local old_number = GreyHandling.db.getItemInfoForPlayer(playerName, itemLink, "number")
    GreyHandling.db.setItemInfoForPlayer(playerName, itemLink, "number", old_number + number)
    GreyHandling.db.setItemInfoForPlayer(playerName, itemLink, "confidence", confidence)
end
