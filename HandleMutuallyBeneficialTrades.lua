local A, GreyHandling = ...

function GreyHandling.functions.GetBagAndSlot(itemLink, ourCount)
	for bagID = 0, NUM_BAG_SLOTS do
		for bagSlot = 1, GetContainerNumSlots(bagID) do
			local _, testedItemCount, _, _, _, _, testedItemLink = GetContainerItemInfo(bagID, bagSlot)
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
