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

function GreyHandling.functions.displayCheapestJunk(foundSomething)
	local now, later = GreyHandling.functions.GetCheapestJunk()
	if now.bag and now.slot then
		foundSomething = true
		if now.bag==later.bag and now.slot==later.slot or now.potentialPrice == later.potentialPrice then
			-- Only one item is the cheapest
			GreyHandling.functions.DisplayCheapestInChat("Cheapest:", now)
			PickupContainerItem(now.bag, now.slot)
			if GreyHandlingIsTalkative then
				local itemLink = GetContainerItemLink(now.bag, now.slot)
				if now.itemCount == 1 then
					msg = format("I can give you %s if you have enough bag places.", itemLink)
				else
					msg = format("I can give you %s*%s if you have enough bag places.", itemLink, now.itemCount)
				end
				SendChatMessage(msg)
			end
			GreyHandling.functions.SetBagItemGlow(now.bag, now.slot, "bags-glow-orange")
			CloseAllBags()
		else
			-- Two items can be considered cheapest
			GreyHandling.functions.DisplayCheapestInChat("Cheapest now:", now)
			GreyHandling.functions.DisplayCheapestInChat("Cheapest later:", later)
			if IsAddOnLoaded("Inventorian") then
				if GreyHandlingIsVerbose then
					print(format("%s: For Inventorian glows in bag feature is not yet supported.", GreyHandling.NAME))
				end
			else
				GreyHandling.functions.SetBagItemGlow(now.bag, now.slot, "bags-glow-orange")
				GreyHandling.functions.SetBagItemGlow(later.bag, later.slot, "bags-glow-orange")
			end
		end
	else
		print(format("%s: No junk found in bag.", GreyHandling.NAME))
	end
	return foundSomething
end

function GreyHandling.functions.displayMutuallyBeneficialTrades(foundSomething)
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
