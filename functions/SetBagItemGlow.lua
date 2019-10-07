local A, GreyHandling = ...


function GreyHandling.functions.SetBagItemGlow(bagID, slotID, color)
	local itemFrame
	if IsAddOnLoaded("OneBag3") then
		itemFrame = _G["OneBagFrameBag"..bagID.."Item"..slotID]
	elseif IsAddOnLoaded("Inventorian") then
		return
    elseif IsAddOnLoaded("ArkInventory") or IsAddOnLoaded("ArkInventoryClassic") then
        local loc_id, bag_id = ArkInventory.BlizzardBagIdToInternalId(bagID)
        local framename, itemFrame = ArkInventory.API.ItemFrameGet(loc_id, bag_id, slotID)
        ActionButton_ShowOverlayGlow(itemFrame)
	else
		for i = 1, NUM_CONTAINER_FRAMES, 1 do
			local frame = _G["ContainerFrame"..i]
			if frame:GetID() == bagID and frame:IsShown() then
				itemFrame = _G["ContainerFrame"..i.."Item"..(GetContainerNumSlots(bagID) + 1 - slotID)]
			end
		end
	end
	if itemFrame then
		itemFrame.NewItemTexture:SetAtlas(color)
		itemFrame.NewItemTexture:Show()
		itemFrame.flashAnim:Play()
		itemFrame.newitemglowAnim:Play()
	end
end
