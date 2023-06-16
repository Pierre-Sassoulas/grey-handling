local A, GreyHandling = ...

local function bagErrorMessage(now, addonName)
	GreyHandling.print("|cff"..GreyHandling.redPrint..GreyHandling["Picked cheapest item now because glows in bag does'nt work yet for "]..addonName..".|r")
	C_Container.PickupContainerItem(now.bag, now.slot)
end

function GreyHandling.functions.HandleCheapestJunk(foundSomething)
	GreyHandling.functions.CalculateCheapestJunk() -- Required as long as changing the scrap junk list does not trigger a calculation
	local now, later = GreyHandling.functions.GetCheapestJunk()
	if now.bag and now.slot then
		foundSomething = true
		if GreyHandling.only_one_item_is_cheapest then
			GreyHandling.functions.DisplayCheapestInChat(GreyHandling["Cheapest:"], now)
			C_Container.PickupContainerItem(now.bag, now.slot)
			-- DeleteCursorItem() Dangerous auto-delete
			if GreyHandlingIsTalkative then
				local itemLink = C_Container.GetContainerItemLink(now.bag, now.slot)
				local whatToGive
				if now.itemCount == 1 then
					whatToGive = format("%s", itemLink)
				else
					whatToGive = format("%s*%s", itemLink, now.itemCount)
				end
				SendChatMessage(format(GreyHandling["I can give you %s if you have enough bag places."], whatToGive))
			end
			GreyHandling.functions.SetBagItemGlow(now.bag, now.slot, 1, 0.1, 0.1)
			CloseAllBags()
		else
			-- Two items can be considered cheapest
			GreyHandling.functions.DisplayCheapestInChat(GreyHandling["Cheapest now:"], now)
			GreyHandling.functions.DisplayCheapestInChat(GreyHandling["Cheapest later:"], later)
			if IsAddOnLoaded("Inventorian") then
				bagErrorMessage(now, "Inventorian")
			end
			GreyHandling.functions.SetBagItemGlow(now.bag, now.slot, 1, 0.1, 0.1)
			GreyHandling.functions.SetBagItemGlow(later.bag, later.slot, 1, 0.1, 0.1)
		end
	else
		GreyHandling.print("|cff"..GreyHandling.redPrint..GreyHandling["No junk found in bag."].."|r")
	end
	return foundSomething
end
