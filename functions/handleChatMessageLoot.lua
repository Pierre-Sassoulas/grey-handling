local A, GreyHandling = ...

function GreyHandling.functions.getItemNameFromChatMessage(chatMessage)
	-- https://stackoverflow.com/questions/6077423/how-to-string-find-the-square-bracket-character-in-lua
	return string.sub(chatMessage, string.find(chatMessage, "%[") + 1 , string.find(chatMessage, "]") -1)
end

function GreyHandling.functions.isLootCouncilMessage(chatMessage)
	-- https://stackoverflow.com/questions/6077423/how-to-string-find-the-square-bracket-character-in-lua
	return string.find(chatMessage, "%[") < 2
end

function GreyHandling.functions.handleChatMessageLoot(chatMessage, playerName, lineNumber, playerId, k, l, m, n, o)
	-- print("Handling", chatMessage, "-",  playerName, "-",  lineNumber, "-",  playerId, "-",  GreyHandling.data.playerName)
	if GreyHandling.data.playerName == playerName then
		-- print("This is the player, we don't need to add", chatMessage, " to our data store.")
		return -- We can get the player items reliably with GetItemCount()
	end
	if GreyHandling.functions.isLootCouncilMessage(chatMessage) then
		-- We don't analyse loot council message
		return
	end
	if not playerName or playerName == "" then
		local version = ""
		if GreyHandling.IS_CLASSIC then
		  version = "WOW classic"
		else
		  version = "WOW retail"
		end
		if GreyHandlingShowAPIFail and GreyHandling.DEVELOPMENT_VERSION then
			print(format("%s: Something went wrong, this addon is for '%s' please check your version of GreyHandling.", GreyHandling.NAME, version))
		end
		return
	end
	-- chatMessage contain an item link, and work like one as of patch 8.2.0
	local itemId = GreyHandling.functions.getIDNumber(chatMessage)
	local itemName = GreyHandling.functions.getItemNameFromChatMessage(chatMessage)
	if not itemId then
		if GreyHandlingShowAPIFail and GreyHandling.DEVELOPMENT_VERSION then
			print(format("Cannot treat '%s' looted by %s.", itemName, playerName))
		end
		return
	end
	local _, itemLink, _, _, _, _, _, itemStackCount, _, _, vendorPrice, _, _, bindType = GetItemInfo(itemId)
	if not itemLink then
		if GreyHandlingShowAPIFail and GreyHandling.DEVELOPMENT_VERSION then
			print(format("Did not manage to retrieve '%s' looted by %s with itemID %s.", itemName, playerName, itemId))
		end
		return
	end
	if itemStackCount == 1 or bindType == 1 or bindType == 4 then
		-- We can't optimize stacking for items that do not stack
		-- We can't trade item that bind on pick up
		-- No one want to trade quest item
		return
	end
	local number= GreyHandling.functions.numberLootedFromChatMessage(chatMessage)
	-- print("Number found", number, chatMessage)
	GreyHandling.db.addItemForPlayer(playerName, itemLink, vendorPrice, itemStackCount, number)
end
