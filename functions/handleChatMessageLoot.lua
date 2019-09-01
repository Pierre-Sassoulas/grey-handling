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
	-- print("Handling", chatMessage, "-",  playerName, "-",  lineNumber, "-",  playerId, "-",  GreyHandling.data.ourName)
	if GreyHandling.data.ourName == playerName then
		-- print("This is the player, we don't need to add", chatMessage, " to our data store.")
		return -- We can get the player items reliably with GetItemCount()
	end
	if not playerName or playerName == "" then
		local version = ""
		if GreyHandling.IS_CLASSIC then
		  version = "WOW classic"
		else
		  version = "WOW retail"
		end
		print(format("%s: Something went wrong, this addon is for '%s' please check your version of GreyHandling.", GreyHandling.NAME, version))
		return
	end
	if GreyHandling.functions.isLootCouncilMessage(chatMessage) then
		-- We don't analyse loot council message
		return
	end
	-- chatMessage contain an item link, and work like one as of patch 8.2.0
	local itemId = GreyHandling.functions.getIDNumber(chatMessage)
	local itemName = GreyHandling.functions.getItemNameFromChatMessage(chatMessage)
	if not itemId then
		print(format("Cannot treat '%s' looted by %s.", itemName, playerName))
		return
	end
	local _, itemLink, _, _, _, _, _, itemStackCount, _, _, vendorPrice, _, _, bindType = GetItemInfo(itemId)
	if not itemLink then
		print(format("Did not manage to retrieve '%s' looted by %s with itemID %s.", itemName, playerName, itemId))
		return
	end
	if itemStackCount == 1 or bindType == 1 or bindType == 4 then
		-- We can't optimize stacking for items that do not stack
		-- We can't trade item that bind on pick up
		-- No one want to trade quest item
		return
	end
	if not GreyHandling.data.items[playerName] then
		GreyHandling.data.items[playerName] = {}
	end
	-- print(itemLink)
	if not GreyHandling.data.items[playerName][itemLink] then
		GreyHandling.data.items[playerName][itemLink] = {}
		GreyHandling.data.items[playerName][itemLink]["itemStackCount"] = itemStackCount
		GreyHandling.data.items[playerName][itemLink]["vendorPrice"] = vendorPrice
		GreyHandling.data.items[playerName][itemLink]["number"] = 0
	end
	-- print("Chat message : ", chatMessage)
	local number= GreyHandling.functions.numberLootedFromChatMessage(chatMessage)
	-- print("Number found", number, chatMessage)
	GreyHandling.data.items[playerName][itemLink]["number"] = GreyHandling.data.items[playerName][itemLink]["number"] + number
	-- print(format("GreyHandling: (estimation) %s's %s current stack : %s/%s", playerName, itemLink, number, itemStackCount))
end
