local A, GreyHandling = ...


function GreyHandling.functions.SetBagItemGlow(bagID, slotID, color)
	if IsAddOnLoaded("OneBag3") then
		item = _G["OneBagFrameBag"..bagID.."Item"..slotID]
	elseif IsAddOnLoaded("Inventorian") then
		return
    elseif IsAddOnLoaded("ArkInventory") or IsAddOnLoaded("ArkInventoryClassic") then
        local loc_id, bag_id = ArkInventory.BlizzardBagIdToInternalId(bagID)
        local framename, item = ArkInventory.API.ItemFrameGet( loc_id, bag_id, slotID)
        ActionButton_ShowOverlayGlow(item)
	else
		for i = 1, NUM_CONTAINER_FRAMES, 1 do
			local frame = _G["ContainerFrame"..i]
			if frame:GetID() == bagID and frame:IsShown() then
				item = _G["ContainerFrame"..i.."Item"..(GetContainerNumSlots(bagID) + 1 - slotID)]
			end
		end
	end
	if item then
		item.NewItemTexture:SetAtlas(color)
		item.NewItemTexture:Show()
		item.flashAnim:Play()
		item.newitemglowAnim:Play()
	end
end
