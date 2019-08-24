local A, GreyHandling = ...

function GreyHandling.functions.handleChatMessageLoot(chat_message, player_name, a, b, c, d, e, f, g, h, line_number ,player_id, k, l, m, n, o)
	if GreyHandling.data.names[player_id] == nil then
		GreyHandling.data.names[player_id] = player_name
	end
	if GreyHandling.data.items[player_id] == nil then
		GreyHandling.data.items[player_id] = {}
	end
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
		itemEquipLoc, itemIcon, vendorPrice = GetItemInfo(chat_message)
	if GreyHandling.data.items[player_id][itemLink] == nil then
		GreyHandling.data.items[player_id][itemLink] = {}
		GreyHandling.data.items[player_id][itemLink]["itemStackCount"] = itemStackCount
		-- We can initialize properly only if its us as long as we have no communication between players
		GreyHandling.data.items[player_id][itemLink]["number"] = 0
	end
	print(
		format("The player %s (%s) had %s*%s (max %s)",
			player_name,
			player_id,
			itemLink,
			GreyHandling.data.items[player_id][itemLink]["number"],
			GreyHandling.data.items[player_id][itemLink]["itemStackCount"])
	)
	if itemStackCount == 1 then
		return -- We can't optimize stacking for items that do not stack
	end
	local number= GreyHandling.functions.numberLootedFromChatMessage(chat_message)
	GreyHandling.data.items[player_id][itemLink]["number"] = GreyHandling.data.items[player_id][itemLink]["number"] + number
	print(format("The player %s (%s) now have %s*%s (max %s)", player_name, player_id, itemLink, GreyHandling.data.items[player_id][itemLink]["number"], GreyHandling.data.items[player_id][itemLink]["itemStackCount"] ))
end