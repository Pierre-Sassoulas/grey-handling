local A, GreyHandling = ...

function GreyHandling.functions.GetBagAndSlot(itemLink)
	for bagID = 0, NUM_BAG_SLOTS do
		for bagSlot = 1, GetContainerNumSlots(bagID) do
			local testedItemLink = GetContainerItemLink(bagID, bagSlot)
			if testedItemLink == itemLink then
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
			local bag, slot = GreyHandling.functions.GetBagAndSlot(exchange.itemGiven)
			if bag and slot then
				GreyHandling.functions.SetBagItemGlow(bag, slot, "bags-glow-green")
			end
			GreyHandling.print(GreyHandling.functions.DisplayMutuallyBeneficialTradeInChat(exchange))
			-- SendChatMessage(msg)
		end
	end
	if not foundExchange then
		GreyHandling.print("|cff"..GreyHandling.redPrint.."No mutually beneficial trade found.".."|r")
	end
	return foundSomething
end
