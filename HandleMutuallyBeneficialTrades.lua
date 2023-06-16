local A, GreyHandling = ...

function GreyHandling.loot_frame:OnLoot(event, chat_message, player_name_retail, a, b, player_name_classic, d, e, f, g,
										h, line_number, player_id, k, l, m, n, o)
	-- print(event, "-", chat_message, "-", player_name_retail, "-", a,  "-", b, "-",  player_name_classic, "-",  d,
	-- "-",  e, "-", f, "-",  g, "-",  h, "-",  line_number,  "-", player_id, "-",  k, "-",  l, "-", m, "-",  n, "-",  o)
	if GreyHandling.IS_CLASSIC then
		GreyHandling.functions.handleChatMessageLoot(chat_message, player_name_classic, line_number, player_id, k, l, m, n, o)
	else
		GreyHandling.functions.handleChatMessageLoot(chat_message, player_name_retail, line_number, player_id, k, l, m, n, o)
	end
end

function GreyHandling.member_leave_frame:OnLeave(event, addon,  text, channel, sender, target, zoneChannelID, localID, name, instanceID)
	local playerNames = {}
	for raidIndex = 1, GetNumGroupMembers() do
		local name = GetRaidRosterInfo(raidIndex)
		playerNames[name] = true
	end
	GreyHandling.db.removePlayerThatLeft(playerNames)
end

function GreyHandling.functions.GetBagAndSlot(itemLink, ourCount)
	for bagID = 0, NUM_BAG_SLOTS do
		for bagSlot = 1, C_Container.GetContainerNumSlots(bagID) do
			local _, testedItemCount, _, _, _, _, testedItemLink = C_Container.GetContainerItemInfo(bagID, bagSlot)
			if testedItemLink == itemLink and ourCount == testedItemCount then
				-- print(itemLink, testedItemLink, ourCount, testedItemCount)
				return bagID, bagSlot
			end
		end
	end
end

function GreyHandling.functions.HandleMutuallyBeneficialTrades(foundSomething)
	local bestExchanges = GreyHandling.functions.GetBestExchanges()
	local foundExchange = nil
	for i, exchange in pairs(bestExchanges) do
		if exchange.itemGiven and exchange.itemTaken then
			foundExchange = true
			foundSomething = true
			local bag, slot = GreyHandling.functions.GetBagAndSlot(exchange.itemGiven, exchange.ourCount)
			if bag and slot then
				GreyHandling.functions.SetBagItemGlow(bag, slot, 0.1, 1, 0.1)
			end
			GreyHandling.print(GreyHandling.functions.DisplayMutuallyBeneficialTradeInChat(exchange))
			-- SendChatMessage(msg)
		end
	end
	if not foundExchange then
		GreyHandling.print("|cff"..GreyHandling.redPrint..GreyHandling["No mutually beneficial trade found."].."|r")
	end
	return foundSomething
end
