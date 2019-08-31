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
	--local egoist, altruist, fair = GreyHandling.functions.GetBestExchange()
	local fair = GreyHandling.functions.GetBestExchange()
	if fair.itemGiven and fair.itemTaken then
		foundSomething = true
		local bag, slot = GreyHandling.functions.GetBagAndSlot(fair.itemGiven)
		if bag and slot then
			GreyHandling.functions.SetBagItemGlow(bag, slot, "bags-glow-orange")
		end
		print(GreyHandling.functions.DisplayMutuallyBeneficialTradeInChat(fair))
		-- SendChatMessage(msg)
	else
		print(format("%s: No mutually beneficial trade found.", GreyHandling.NAME))
	end
	return foundSomething
end
