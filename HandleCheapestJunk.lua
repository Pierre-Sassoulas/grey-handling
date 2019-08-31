local A, GreyHandling = ...

function GreyHandling.functions.HandleCheapestJunk(foundSomething)
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
