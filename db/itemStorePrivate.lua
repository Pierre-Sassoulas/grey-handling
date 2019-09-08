local A, GreyHandling = ...

function GreyHandling.db.uniformizePlayerName(playerName)
	if GreyHandling.IS_CLASSIC and not string.find(playerName, "-") then
		local realmName=GetRealmName()
		playerName = format("%s-%s", playerName, string.gsub(realmName, "%s+", ""))
	end
	return playerName
end

function GreyHandling.db.setItemInfoForPlayer(playerName, itemLink, infoName, value)
    local playerName = GreyHandling.db.initializePlayer(playerName)
    GreyHandling.db.initializeItem(playerName, itemLink)
    GreyHandling.data.items[playerName][itemLink][infoName] = value
end

function GreyHandling.functions.playerHasItem(playerName, itemLink)
	playerName = GreyHandling.db.uniformizePlayerName(playerName)
    return GreyHandling.data.items[playerName] and
            GreyHandling.data.items[playerName][itemLink] and
            GreyHandling.db.getItemInfoForPlayer(playerName, itemLink, "number") > 0
end

function GreyHandling.db.initializePlayer(playerName, bagSpace)
	playerName = GreyHandling.db.uniformizePlayerName(playerName)
	if not GreyHandling.data.items[playerName] then
		bagSpace = bagSpace or 181 -- 36*5 + 1
		GreyHandling.data.items[playerName] = {bagSpace=bagSpace}
    end
    return playerName
end

function GreyHandling.db.initializeItem(playerName, itemLink, vendorPrice, itemStackCount, number, confidence)
	-- print(playerName, itemLink, vendorPrice, itemStackCount)
	local playerName = GreyHandling.db.initializePlayer(playerName)
    vendorPrice = vendorPrice or 0
    itemStackCount = itemStackCount or 0
    number = number or 0
    confidence = confidence or 0
	if not GreyHandling.data.items[playerName][itemLink] then
		GreyHandling.data.items[playerName][itemLink] = {
            itemStackCount=itemStackCount, vendorPrice = vendorPrice, number=number, confidence=confidence
        }
    end
    return playerName
end
