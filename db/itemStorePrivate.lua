local A, GreyHandling = ...

function GreyHandling.db.playerItemInitialized(playerName, itemLink)
    return GreyHandling.data.items[playerName] and GreyHandling.data.items[playerName][itemLink]
end

function GreyHandling.functions.playerHasItem(playerName, itemLink)
    return GreyHandling.db.playerItemInitialized(playerName, itemLink) and GreyHandling.db.getItemInfoForPlayer(playerName, itemLink, "number") > 0
end

function GreyHandling.db.initializePlayer(playerName, bagSpace)
	if not GreyHandling.data.items[playerName] then
		bagSpace = bagSpace or 181 -- 36*5 + 1
		GreyHandling.data.items[playerName] = {bagSpace=bagSpace}
	end
end

function GreyHandling.db.initializeItem(playerName, itemLink, vendorPrice, itemStackCount)
	-- print(playerName, itemLink, vendorPrice, itemStackCount)
	GreyHandling.db.initializePlayer(playerName)
	if not GreyHandling.data.items[playerName][itemLink] then
		GreyHandling.data.items[playerName][itemLink] = {
            itemStackCount=itemStackCount, vendorPrice = vendorPrice, number=0, confidence=0
        }
	end
end
