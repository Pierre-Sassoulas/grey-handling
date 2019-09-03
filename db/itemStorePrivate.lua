local A, GreyHandling = ...

function GreyHandling.db.playerItemInitialized(playerName, itemLink)
    return GreyHandling.data.items[playerName] and GreyHandling.data.items[playerName][itemLink]
end

function GreyHandling.functions.playerHasItem(playerName, itemLink)
    return GreyHandling.db.playerItemInitialized(playerName, itemLink) and GreyHandling.db.getItemInfoForPlayer(playerName, itemLink, "number") > 0
end

function GreyHandling.db.initializeItem(playerName, itemLink, vendorPrice, itemStackCount)
	if not GreyHandling.data.items[playerName] then
		GreyHandling.data.items[playerName] = {}
	end
	if not GreyHandling.data.items[playerName][itemLink] then
		GreyHandling.data.items[playerName][itemLink] = {
            itemStackCount=itemStackCount, vendorPrice = vendorPrice, number=0
        }
	end
end
