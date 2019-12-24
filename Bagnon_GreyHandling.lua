--[[
This file is based on the way Bagnon Scrap was coded.
--]]

local A, GreyHandling = ...
if IsAddOnLoaded("Bagnon") or IsAddOnLoaded("Combuctor") then
	local Addon = Bagnon
	if not Addon then
		Addon = Combuctor
	end
	local ItemSlot
    if Addon.ItemSlot then
        -- Retrocompatibility with old version of Bagnon
        ItemSlot = Addon.ItemSlot
    elseif Addon.Item then
        -- Compatibility with new version of Bagnon following change here :
        -- https://github.com/tullamods/Bagnon/commit/66ef9412fa7d3f6eb9ec91930316ec3818213abd
        ItemSlot = Addon.Item
    else
        GreyHandling.print(format("%s cannot work properly with Bagnon or Combuctor. Please open a Github Issue.", GreyHandling.NAME))
        return
    end
	local UpdateBorder = ItemSlot.UpdateBorder
	local r, g, b = GetItemQualityColor(0)

	Addon.Rules:New('greyhandling', 'Grey Handling', 'Interface\\Addons\\GreyHandling\\Art\\GreyHandlingIcon', function(player, bag, slot, bagInfo, itemInfo)
		if itemInfo.id and bag and slot then
			if GreyHandling.isCheapest(bag, slot) then
				return true
			end
			return GreyHandling.isMutuallyBeneficialTrade(bag, slot)
		end
	end)

	function ItemSlot:UpdateBorder()
		local id = self.info.id
		local online = not self.info.cached
		local bag = online and self:GetBag()
		local slot = online and self:GetID()
		local junk = nil
		if IsAddOnLoaded("Scrap") then
			junk = Scrap:IsJunk(id, bag, slot)
		end
		UpdateBorder(self)
		self.JunkIcon:SetShown(junk)
		if junk then
			self.IconBorder:SetVertexColor(r, g, b)
			self.IconBorder:Show()
			self.IconGlow:SetVertexColor(r, g, b, Addon.sets.glowAlpha)
			self.IconGlow:Show()
		end
		local cheapest = GreyHandling.isCheapest(bag, slot)
		if cheapest then
			self.IconBorder:SetVertexColor(1, 0.1, 0.1)
			self.IconBorder:SetTexture([[Interface\Artifacts\RelicIconFrame]])
			self.IconBorder:Show()
			--self.IconGlow:SetTexture('Interface\\Addons\\GreyHandling\\Art\\GreyHandlingIcon')
			--self.IconGlow:Show()
		end
		local trade = GreyHandling.isMutuallyBeneficialTrade(bag, slot)
		if trade then
			self.IconBorder:SetVertexColor(0.1, 1, 0.1)
			self.IconBorder:SetTexture([[Interface\Artifacts\RelicIconFrame]])
			self.IconBorder:Show()
		end
	end


	--[[ Update Events ]]--

	--local function UpdateBags()
	--Addon:UpdateFrames()
	--end

	--hooksecurefunc(GreyHandling, 'VARIABLES_LOADED', UpdateBags)
	--hooksecurefunc(GreyHandling, 'ToggleJunk', UpdateBags)
	--Scrap.HasSpotlight = true
end
