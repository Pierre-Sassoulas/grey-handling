--[[
This file is based on the way Bagnon Scrap was coded.
--]]

local A, GreyHandling = ...
if IsAddOnLoaded("Bagnon") or IsAddOnLoaded("Combuctor") then
	local Addon = Bagnon
	if not Addon then
		Addon = Combuctor
	end
	local ItemSlot = Addon.ItemSlot
	local UpdateBorder = ItemSlot.UpdateBorder
	local r, g, b = GetItemQualityColor(0)

	local function isCheapest(bag, slot)
		local now, later = GreyHandling.functions.GetCheapestJunk()
		return (bag==now.bag and slot==now.slot) or (later.bag == bag and later.slot == slot)
	end

	local function isTrade(bag, slot)
		local bestExchanges = GreyHandling.functions.GetBestExchanges()
		for i, exchange in pairs(bestExchanges) do
			if exchange.itemGiven and exchange.itemTaken then
				local exchangeBag, exchangeSlot = GreyHandling.functions.GetBagAndSlot(exchange.itemGiven)
				if exchangeBag == bag and exchangeSlot == slot then
					return true
				end
			end
		end
		return false
	end


	Addon.Rules:New('greyhandling', 'Grey Handling', 'Interface\\Addons\\GreyHandling\\Art\\GreyHandlingIcon', function(player, bag, slot, bagInfo, itemInfo)
		if itemInfo.id and bag and slot then
			if isCheapest(bag, slot) then
				return true
			end
			return isTrade(bag, slot)
		end
	end)

	function ItemSlot:UpdateBorder()
		local id = self.info.id
		local online = not self.info.cached
		local bag = online and self:GetBag()
		local slot = online and self:GetID()
		local junk = Scrap:IsJunk(id, bag, slot)
		UpdateBorder(self)
		self.JunkIcon:SetShown(Scrap_Icons and junk)
		if Scrap_Glow and junk then
			self.IconBorder:SetVertexColor(r, g, b)
			self.IconBorder:Show()
			self.IconGlow:SetVertexColor(r, g, b, Addon.sets.glowAlpha)
			self.IconGlow:Show()
		end
		local cheapest = isCheapest(bag, slot)
		if cheapest then
			self.IconBorder:SetVertexColor(1, 0.1, 0.1)
			self.IconBorder:SetTexture([[Interface\Artifacts\RelicIconFrame]])
			self.IconBorder:Show()
			--self.IconGlow:SetTexture('Interface\\Addons\\GreyHandling\\Art\\GreyHandlingIcon')
			--self.IconGlow:Show()
		end
		local trade = isTrade(bag, slot)
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

