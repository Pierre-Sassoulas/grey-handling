local A, GreyHandling = ...

local SELL_PRICE_TEXT = format("%s:", SELL_PRICE)

function SetGameToolTipPrice(tt)
	if not MerchantFrame:IsShown() and SHOW_PRICE then
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
				SetTooltipMoney(tt, cost, nil, SELL_PRICE_TEXT)
			end
		end
	end
end

function SetItemRefToolTipPrice(tt)
	local itemLink = select(2, tt:GetItem())
	if itemLink then
		local itemSellPrice = select(11, GetItemInfo(itemLink))
		if itemSellPrice and itemSellPrice > 0 then
			SetTooltipMoney(tt, itemSellPrice, nil, SELL_PRICE_TEXT)
		end
	end
end

GreyHandling.functions.SetItemRefToolTipPrice = SetItemRefToolTipPrice
GreyHandling.functions.SetGameToolTipPrice = SetGameToolTipPrice