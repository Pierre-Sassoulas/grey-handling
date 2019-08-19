local A, GreyHandling = ...

local function SetGameToolTipPrice(tt)
	if not MerchantFrame:IsShown() and GreyHandling.options.SHOW_PRICE then
		-- TODO Take into account the damage to stuff (price go down not linearly)
		-- Ie stuff is worth 18 coppers at 60/60, but 6 copper at 45/60
		local itemLink = select(2, tt:GetItem())
		if itemLink then
			local itemSellPrice = select(11, GetItemInfo(itemLink))
			if itemSellPrice and itemSellPrice > 0 then
				local container = GetMouseFocus()
				local name = container:GetName()
				local object = container:GetObjectType()
				local count
				if object == "Button" then -- ContainerFrameItem, QuestInfoItem, PaperDollItem
					count = container.count
				elseif object == "CheckButton" then -- MailItemButton or ActionButton
					count = container.count or tonumber(container.Count:GetText())
				end
				local cost = (type(count) == "number" and count or 1) * itemSellPrice
				SetTooltipMoney(tt, cost, nil, GreyHandling.SELL_PRICE_TEXT)
			end
		end
	end
end

local function SetItemRefToolTipPrice(tt)
	local itemLink = select(2, tt:GetItem())
	if itemLink then
		local itemSellPrice = select(11, GetItemInfo(itemLink))
		if itemSellPrice and itemSellPrice > 0 then
			SetTooltipMoney(tt, itemSellPrice, nil, GreyHandling.SELL_PRICE_TEXT)
		end
	end
end

GreyHandling.functions.SetItemRefToolTipPrice = SetItemRefToolTipPrice
GreyHandling.functions.SetGameToolTipPrice = SetGameToolTipPrice