local A, GreyHandling = ...

local function bagErrorMessage(now, addonName)
	GreyHandling.print("|cff"..GreyHandling.redPrint.."Picked cheapest item now because glows in bag does'nt work yet for "..addonName..".|r")
	PickupContainerItem(now.bag, now.slot)
end

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
				bagErrorMessage(now, "Inventorian")
			elseif IsAddOnLoaded("Bagnon") or IsAddOnLoaded("Combuctor") then
				bagErrorMessage(now, "Bagnon or Combuctor")
			end
			GreyHandling.functions.SetBagItemGlow(now.bag, now.slot, "bags-glow-orange")
			GreyHandling.functions.SetBagItemGlow(later.bag, later.slot, "bags-glow-orange")
			if IsAddOnLoaded("ArkInventory") or IsAddOnLoaded("ArkInventoryClassic") then
				GreyHandling.print("|cff"..GreyHandling.redPrint.."Sorry about the permanent glow, you can relaunch without problem.|r")
			end
		end
	else
		GreyHandling.print("|cff"..GreyHandling.redPrint.."No junk found in bag.".."|r")
	end
	return foundSomething
end
