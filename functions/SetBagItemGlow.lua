local A, GreyHandling = ...

function GreyHandling.functions.AISetBagItemGlow(itemFrame, loc_id, bag_id, slot_id)
	local now, later = GreyHandling.functions.GetCheapestJunk()
	if not now and not later then
		return
	end
	local now_loc, now_bag,  later_loc, later_bag
	if now.bag then
		now_loc, now_bag = ArkInventory.BlizzardBagIdToInternalId(now.bag)
	end
	if later.bag then
		later_loc, later_bag = ArkInventory.BlizzardBagIdToInternalId(later.bag)
	end
	if (loc_id == now_loc and now_bag == bag_id and slot_id == now.slot) or
			(loc_id == later_loc and later_bag == bag_id and slot_id == later.slot) then
		itemFrame.JunkIcon:SetShown(true)
		itemFrame.IconBorder:SetVertexColor(1, 0.1, 0.1)
		itemFrame.IconBorder:SetTexture([[Interface\Artifacts\RelicIconFrame]])
		itemFrame.IconBorder:Show()
	else
		itemFrame.IconBorder:SetVertexColor()
		itemFrame.IconBorder:SetTexture()
		itemFrame.IconBorder:Show()
	end
	local bestExchanges = GreyHandling.functions.GetBestExchanges()
	for i, exchange in pairs(bestExchanges) do
		if exchange.itemGiven and exchange.itemTaken then
			local bag, slot = GreyHandling.functions.GetBagAndSlot(exchange.itemGiven, exchange.ourCount)
			if bag and slot then
				local ai_loc, ai_bag = ArkInventory.BlizzardBagIdToInternalId(bag)
				if ai_loc == loc_id and ai_bag == bag_id and slot_id == slot then
					itemFrame.IconBorder:SetVertexColor(0.1, 1, 0.1)
					itemFrame.IconBorder:SetTexture([[Interface\Artifacts\RelicIconFrame]])
					itemFrame.IconBorder:Show()
				end
			end
		end
	end
end


function GreyHandling.functions.SetBagItemGlow(bagID, slotID, r, v, b)
	local itemFrame
	if IsAddOnLoaded("OneBag3") then
		itemFrame = _G["OneBagFrameBag"..bagID.."Item"..slotID]
	elseif IsAddOnLoaded("Inventorian") then
		return
    elseif IsAddOnLoaded("ArkInventory") or IsAddOnLoaded("ArkInventoryClassic") then
		return
	else
		for i = 1, NUM_CONTAINER_FRAMES, 1 do
			local frame = _G["ContainerFrame"..i]
			if frame:GetID() == bagID and frame:IsShown() then
				itemFrame = _G["ContainerFrame"..i.."Item"..(GetContainerNumSlots(bagID) + 1 - slotID)]
			end
		end
	end
	if itemFrame then
		itemFrame.IconBorder:SetVertexColor(r, v, b)
		itemFrame.IconBorder:SetTexture([[Interface\Artifacts\RelicIconFrame]])
		itemFrame.IconBorder:Show()
	end
end
