local SELL_PRICE_TEXT = format("%s:", SELL_PRICE)
local f = CreateFrame("Frame")
local isClassic = true
local addOnName = "GreyHandling"

local ThisAddon_Defaults = {
  ["Options"] = {
    ["MasterOnOff"] = "On",
    ["version"] = "1.0",
    ["debug"] = false,
    ["More Random Variables"] = Value,
  },
};


local function SetBagItemGlow(bagID, slotID, color)
	local item = nil
	for i = 1, NUM_CONTAINER_FRAMES, 1 do
		local frame = _G["ContainerFrame"..i]
		if frame:GetID() == bagID and frame:IsShown() then
			item = _G["ContainerFrame"..i.."Item"..(GetContainerNumSlots(bagID) + 1 - slotID)]
		end
	end
	if item then
		item.NewItemTexture:SetAtlas(color)
		item.NewItemTexture:Show()
		item.flashAnim:Play()
		item.newitemglowAnim:Play()
	end
end

local function GlowCheapestGrey()
	local minPriceNow = nil
	local bagNumNow = nil
	local slotNumNow = nil
	local minPriceFuture = nil
	local currentPriceFuture = nil
	local currentNumberFuture = nil
	local bagNumFuture = nil
	local slotNumFuture = nil
	for bagID = 0, NUM_BAG_SLOTS do
		for bagSlot = 1, GetContainerNumSlots(bagID) do
			local itemid = GetContainerItemID(bagID, bagSlot)
			local itemLink = GetContainerItemLink(bagID, bagSlot)
			local _, itemCount = GetContainerItemInfo(bagID, bagSlot)
			if itemid then
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
					itemEquipLoc, itemIcon, vendorPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID,
					isCraftingReagent = GetItemInfo(itemid)
				if itemRarity == 0 and vendorPrice > 0 then
					local _, itemCount = GetContainerItemInfo(bagID, bagSlot)
					local currentVendorPrice = vendorPrice * itemCount
					local potentialVendorPrice = vendorPrice * itemStackCount
					if minPriceNow == nil then
						minPriceNow = currentVendorPrice
						bagNumNow = bagID
						slotNumNow = bagSlot
					elseif minPriceNow > currentVendorPrice then
						minPriceNow = currentVendorPrice
						bagNumNow = bagID
						slotNumNow = bagSlot
					end
					if minPriceFuture == nil then
						minPriceFuture = potentialVendorPrice
						currentPriceFuture = vendorPrice * itemCount
						currentNumberFuture = itemCount
						bagNumFuture = bagID
						slotNumFuture = bagSlot
					elseif minPriceFuture > potentialVendorPrice then
						minPriceFuture = potentialVendorPrice
						currentPriceFuture = vendorPrice * itemCount
						currentNumberFuture = itemCount
						bagNumFuture = bagID
						slotNumFuture = bagSlot
					end
				end
			end
		end
	end
	if bagNumNow and slotNumNow then
		SetBagItemGlow(bagNumNow, slotNumNow, "bags-glow-orange")
		if bagNumNow==bagNumFuture and slotNumNow==slotNumFuture then
			itemLink = GetContainerItemLink(bagNumNow, slotNumNow)
			if VERBOSE then
				print("Cheapest:", itemLink, GetCoinTextureString(minPriceNow))
			end
			PickupContainerItem(bagNumNow,slotNumNow)
			if TALKATIVE then
				if currentNumberFuture == 1 then
					msg = format("I can give you %s if you have some bag space left.", itemLink)
				else
					msg = format("I can give you %s*%s if you have some bag space left.", itemLink, currentNumberFuture)
				end
				SendChatMessage(msg)
			end
			CloseAllBags()
		else
			if VERBOSE then
				print("Cheapest now:", GetContainerItemLink(bagNumNow, slotNumNow), GetCoinTextureString(minPriceNow))
				print("Cheapest later:", currentNumberFuture, "*", GetContainerItemLink(bagNumFuture, slotNumFuture), GetCoinTextureString(currentPriceFuture),
				"(max ", GetCoinTextureString(minPriceFuture), ")")
			end
			SetBagItemGlow(bagNumFuture, slotNumFuture, "bags-glow-orange")
		end
	else
		print("GreyHandling : No grey to throw, maybe you don't need this hearthstone after all ;) ?")
	end
end

function f:OnEvent(event, key, state)
	if key == "LCTRL" and state == 1 and IsShiftKeyDown() then
		OpenAllBags()
		GlowCheapestGrey()
	end
end

local function SetGameToolTipPrice(tt)
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

local function SetItemRefToolTipPrice(tt)
	local itemLink = select(2, tt:GetItem())
	if itemLink then
		local itemSellPrice = select(11, GetItemInfo(itemLink))
		if itemSellPrice and itemSellPrice > 0 then
			SetTooltipMoney(tt, itemSellPrice, nil, SELL_PRICE_TEXT)
		end
	end
end

GreyHandling = {};
GreyHandling.panel = CreateFrame("Frame", "GreyHandlingPanel", UIParent);
GreyHandling.panel.name = "GreyHandling";
InterfaceOptions_AddCategory(GreyHandling.panel);
local title = GreyHandling.panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("GreyHandling options")
local sometext = GreyHandling.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
sometext:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
sometext:SetText("Let GreyHandling offer your grey around!")

local frame = CreateFrame("FRAME"); -- Need a frame to respond to events
frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
frame:RegisterEvent("PLAYER_LOGOUT"); -- Fired when about to log out

function GreyHandling.panel.default()
	TALKATIVE = true
	VERBOSE = true
	SHOW_PRICE = true
end

function frame:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == addOnName then
		if TALKATIVE == nil then
			TALKATIVE = true
		end
		if VERBOSE == nil then
			VERBOSE = true
		end
		if SHOW_PRICE == nil then
			SHOW_PRICE = true
		end
	end
end

frame:SetScript("OnEvent", frame.OnEvent);
SLASH_HAVEWEMET1 = "/gho";
function SlashCmdList.HAVEWEMET(msg)
	if TALKATIVE then
		talkative = "talk"
	else
		talkative = "do not talk"
	end
	if VERBOSE then
		verbose = "talk to you,"
	else
		verbose = "keep to himself around you,"
	end
	if SHOW_PRICE then
		price = "show"
	else
		price "do not show"
	end
	print("GreyHandling", talkative, "to your friends,", verbose, "and", price, "item's prices.");
end

print("GreyHandling: Launch by hitting ctrl while holding shift.")
GameTooltip:HookScript("OnTooltipSetItem", SetGameToolTipPrice)
ItemRefTooltip:HookScript("OnTooltipSetItem", SetItemRefToolTipPrice)
f:RegisterEvent("MODIFIER_STATE_CHANGED")
f:SetScript("OnEvent", f.OnEvent)
