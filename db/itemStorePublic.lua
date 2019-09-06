local A, GreyHandling = ...


function GreyHandling.db.getItemInfoForPlayer(playerName, itemLink, infoName)
    return GreyHandling.data.items[playerName][itemLink][infoName]
end

function GreyHandling.db.setItemInfoForPlayer(playerName, itemLink, infoName, value)
    GreyHandling.data.items[playerName][itemLink][infoName] = value
end

function GreyHandling.db.setItemForPlayer(playerName, itemLink, vendorPrice, itemStackCount, number)
    -- print("In GreyHandling.db.addItemForPlayer :", playerName, itemLink, vendorPrice, itemStackCount, number)
    if not GreyHandling.db.playerItemInitialized(playerName, itemLink) then
        GreyHandling.db.initializeItem(playerName, itemLink, vendorPrice, itemStackCount)
    end
    GreyHandling.db.setItemInfoForPlayer(playerName, itemLink, "number", number)
end

function GreyHandling.db.addItemForPlayer(playerName, itemLink, vendorPrice, itemStackCount, number)
    if not GreyHandling.db.playerItemInitialized(playerName, itemLink) then
        GreyHandling.db.initializeItem(playerName, itemLink, vendorPrice, itemStackCount)
    end
    local old_number = GreyHandling.db.getItemInfoForPlayer(playerName, itemLink, "number")
    GreyHandling.db.setItemInfoForPlayer(playerName, itemLink, "number", old_number + number)
end
