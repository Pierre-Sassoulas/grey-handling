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

	-- OPTIMIZATION: Simple caching - only recalculate when data actually changes
	local cachedBestExchanges = nil

	-- Function to get cached best exchanges
	local function GetCachedBestExchanges()
		if cachedBestExchanges == nil then
			cachedBestExchanges = GreyHandling.functions.GetBestExchanges()
		end
		return cachedBestExchanges
	end

	-- Function to invalidate cache when data changes
	local function InvalidateExchangeCache()
		cachedBestExchanges = nil
	end

	-- Hook into functions that change the data to invalidate cache
	local originalAddItemForPlayer = GreyHandling.db.addItemForPlayer
	GreyHandling.db.addItemForPlayer = function(...)
		InvalidateExchangeCache()
		return originalAddItemForPlayer(...)
	end

	local originalSetItemForPlayer = GreyHandling.db.setItemForPlayer
	GreyHandling.db.setItemForPlayer = function(...)
		InvalidateExchangeCache()
		return originalSetItemForPlayer(...)
	end

	local originalRemovePlayerThatLeft = GreyHandling.db.removePlayerThatLeft
	GreyHandling.db.removePlayerThatLeft = function(...)
		InvalidateExchangeCache()
		return originalRemovePlayerThatLeft(...)
	end

	local originalRemovePlayer = GreyHandling.db.removePlayer
	GreyHandling.db.removePlayer = function(...)
		InvalidateExchangeCache()
		return originalRemovePlayer(...)
	end

	if Addon.Rules and Addon.Rules.New then
		Addon.Rules:New('greyhandling', 'Grey Handling', 'Interface\\Addons\\GreyHandling\\Art\\GreyHandlingIcon', function(player, bag, slot, bagInfo, itemInfo)
			if itemInfo.id and bag and slot then
				if GreyHandling.isCheapest(bag, slot) then
					return true
				end
				return GreyHandling.isMutuallyBeneficialTrade(bag, slot)
			end
		end)
	else
		GreyHandling.print(format("%s: Bagnon Rules API not available. Item filtering disabled.", GreyHandling.NAME))
	end

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

		-- Check if this is the cheapest item
		local cheapest = GreyHandling.isCheapest(bag, slot)
		if cheapest then
			self.IconBorder:SetVertexColor(1, 0.1, 0.1)
			self.IconBorder:SetTexture([[Interface\Artifacts\RelicIconFrame]])
			self.IconBorder:Show()
		end

		-- OPTIMIZATION: Use cached best exchanges instead of calling GetBestExchanges() every time
		if bag and slot then
			local bestExchanges = GetCachedBestExchanges()
			local trade = false

			-- Check if this item is part of a mutually beneficial trade
			for i, exchange in pairs(bestExchanges) do
				if exchange.itemGiven and exchange.itemTaken then
					local exchangeBag, exchangeSlot = GreyHandling.functions.GetBagAndSlot(exchange.itemGiven, exchange.ourCount)
					if exchangeBag == bag and exchangeSlot == slot then
						trade = true
						break
					end
				end
			end

			if trade then
				self.IconBorder:SetVertexColor(0.1, 1, 0.1)
				self.IconBorder:SetTexture([[Interface\Artifacts\RelicIconFrame]])
				self.IconBorder:Show()
			end
		end
	end

	-- Hook into events that change player inventory to invalidate cache
	local cacheInvalidationFrame = CreateFrame("Frame")
	cacheInvalidationFrame:RegisterEvent("GROUP_LEFT")
	cacheInvalidationFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	cacheInvalidationFrame:SetScript("OnEvent", function(self, event, ...)
		InvalidateExchangeCache()
	end)

	--[[ Update Events ]]--

	--local function UpdateBags()
	--Addon:UpdateFrames()
	--end

	--hooksecurefunc(GreyHandling, 'VARIABLES_LOADED', UpdateBags)
	--hooksecurefunc(GreyHandling, 'ToggleJunk', UpdateBags)
	--Scrap.HasSpotlight = true
end
