local A, GreyHandling = ...


local function SetBagItemGlow(bagID, slotID, color)
	local item = nil
	if IsAddOnLoaded("OneBag3") then
		item = _G["OneBagFrameBag"..bagID.."Item"..slotID]
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

GreyHandling.functions.SetBagItemGlow = SetBagItemGlow