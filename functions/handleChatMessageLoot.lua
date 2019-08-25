local A, GreyHandling = ...

function GreyHandling.functions.updatePlayersList(player_id, player_name)
	if GreyHandling.data.names[player_id] == nil then
		GreyHandling.data.names[player_id] = player_name
	end
	if GreyHandling.data.items[player_id] == nil then
		GreyHandling.data.items[player_id] = {}
	end
end

function GreyHandling.functions.initPlayerItem(player_id, itemLink, itemStackCount, vendorPrice)
	GreyHandling.data.items[player_id][itemLink] = {}
	GreyHandling.data.items[player_id][itemLink]["itemStackCount"] = itemStackCount
	GreyHandling.data.items[player_id][itemLink]["vendorPrice"] = vendorPrice
	-- We can initialize this properly as long as we have no communication between players
	GreyHandling.data.items[player_id][itemLink]["number"] = 0
end

function GreyHandling.functions.handleChatMessageLoot(chat_message, player_name, line_number, player_id, k, l, m, n, o)
	if GreyHandling.data.ourName == player_name then
		return -- We can get the player items reliably with GetItemCount()
	end
	GreyHandling.functions.updatePlayersList(player_id, player_name)
	-- chat_message contain an item link, and work like one as of patch 8.2.0
	local _, itemLink, _, _, _, _, _, itemStackCount, _, _, vendorPrice = GetItemInfo(chat_message)
	if itemStackCount == 1 then
		return -- We can't optimize stacking for items that do not stack
	end
	if GreyHandling.data.items[player_id][itemLink] == nil then
		GreyHandling.functions.initPlayerItem(player_id, itemLink, itemStackCount, vendorPrice)
	end
	local number= GreyHandling.functions.numberLootedFromChatMessage(chat_message)
	GreyHandling.data.items[player_id][itemLink]["number"] = GreyHandling.data.items[player_id][itemLink]["number"] + number
	local remaining = itemStackCount - GetItemCount(itemLink) - GreyHandling.data.items[player_id][itemLink]["number"]
	if remaining > 0 then
		print(format("%s could be interested by an exchange of %s (Can stack all yours and then %s more.).", player_name, itemLink, remaining))
	end
	--print(format("%s now have %s*%s (max %s)", player_name, itemLink, GreyHandling.data.items[player_id][itemLink]["number"],
	--      GreyHandling.data.items[player_id][itemLink]["itemStackCount"]))
end