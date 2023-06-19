local A, GreyHandling = ...

InterfaceOptions_AddCategory(GreyHandling.options.panel);
-- TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, GreyHandling.functions.ToolTipHook)

GreyHandling.print(
	format(GreyHandling["Launch %s with left CTRL while holding SHIFT. (or %s)"],
	GreyHandling.NAME, GreyHandling.CHAT_COMMAND)
)

-- See Bindings.xml
BINDING_NAME_GH_ALL = GreyHandling["Launch GreyHandling"]
BINDING_NAME_GH_TRADE = GreyHandling["Search for trades only"]
BINDING_NAME_GH_THROW = GreyHandling["Throw cheapest item only"]
BINDING_HEADER_GH = GreyHandling.NAME


function GreyHandling.isCheapest(bag, slot)
	local now, later = GreyHandling.functions.GetCheapestJunk()
	return (bag==now.bag and slot==now.slot) or (later.bag == bag and later.slot == slot)
end

function GreyHandling.isMutuallyBeneficialTrade(bag, slot)
	local bestExchanges = GreyHandling.functions.GetBestExchanges()
	for i, exchange in pairs(bestExchanges) do
		if exchange.itemGiven and exchange.itemTaken then
			local exchangeBag, exchangeSlot = GreyHandling.functions.GetBagAndSlot(exchange.itemGiven, exchange.ourCount)
			if exchangeBag == bag and exchangeSlot == slot then
				return true
			end
		end
	end
	return false
end

function GreyHandlingMain()
	if GreyHandling.DEVELOPMENT_VERSION then
		GreyHandling.allTests()
	end
	GreyHandling.functions.ExchangeMyJunkPlease()
	local foundSomething = false
	OpenAllBags()
	local isInGroup = GetNumGroupMembers() > 0
	if isInGroup or GreyHandling.DEVELOPMENT_VERSION then
		foundSomething = GreyHandling.functions.HandleMutuallyBeneficialTrades(foundSomething)
	end
	if GreyHandlingShowCheapestAlways or not foundSomething then
		foundSomething = GreyHandling.functions.HandleCheapestJunk(foundSomething)
	end
	if not foundSomething then
		CloseAllBags()
	end
end

function GreyHandlingSearchForCheapest()
	OpenAllBags()
	if not GreyHandling.functions.HandleCheapestJunk(false) then
		CloseAllBags()
	end
end

function GreyHandlingSearchForTrade()
	OpenAllBags()
	local isInGroup = GetNumGroupMembers() > 0
	if isInGroup or GreyHandling.DEVELOPMENT_VERSION then
		if not GreyHandling.functions.HandleMutuallyBeneficialTrades(false) then
			CloseAllBags()
		end
	else
		GreyHandling.print("|cff"..GreyHandling.redPrint..GreyHandling["Not in a group."].."|r")
	end
end

function GreyHandling.frame:OnEvent(event, key, state)
	if state == 0 then
		-- Isn't it convenient to just calculate for every keybind released instead of thinking hard about events in
		-- other addons and complicated hooks ?
		GreyHandling.functions.CalculateCheapestJunk()
	end
	if not GreyHandlingDeactivateDefaultKeybind and key == "LCTRL" and state == 1 and IsShiftKeyDown() then
		GreyHandlingMain()
	end
end
GreyHandling.frame:RegisterEvent("MODIFIER_STATE_CHANGED")
GreyHandling.frame:SetScript("OnEvent", GreyHandling.frame.OnEvent)

GreyHandling.loot_frame:RegisterEvent("CHAT_MSG_LOOT")
GreyHandling.loot_frame:SetScript("OnEvent", GreyHandling.loot_frame.OnLoot)

function GreyHandling.chat_frame:OnChat(event, addon,  text, channel, sender, target, zoneChannelID, localID, name, instanceID)
	if addon == GreyHandling.NAME then
		GreyHandling.functions.SomeoneAskForExchange(text, channel, sender, target, zoneChannelID, localID, name, instanceID)
	end
end
GreyHandling.chat_frame:RegisterEvent("CHAT_MSG_ADDON")
GreyHandling.chat_frame:SetScript("OnEvent", GreyHandling.chat_frame.OnChat)

GreyHandling.options.frame:SetScript("OnEvent", GreyHandling.options.frame.OnEvent);
SLASH_GREYHANDLINGOPTION1 = GreyHandling.CHAT_COMMAND;
function SlashCmdList.GREYHANDLINGOPTION(msg)
	GreyHandlingMain()
end

GreyHandling.member_leave_frame:RegisterEvent("GROUP_LEFT")
GreyHandling.member_leave_frame:SetScript("OnEvent", GreyHandling.member_leave_frame.OnLeave)

if IsAddOnLoaded("ArkInventory") or IsAddOnLoaded("ArkInventoryClassic") then
	hooksecurefunc(ArkInventory.API, "ItemFrameUpdated", GreyHandling.functions.AISetBagItemGlow)
end

local UpdateCheapestFrame = CreateFrame("FRAME", "GreyHandlingUpdateCheapestFrame");
UpdateCheapestFrame:RegisterEvent("UNIT_INVENTORY_CHANGED");
UpdateCheapestFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
UpdateCheapestFrame:SetScript("OnEvent", GreyHandling.functions.CalculateCheapestJunk);

local UpdateCheapestPositionFrame = CreateFrame("FRAME", "GreyHandlingUpdateCheapestFrame");
UpdateCheapestPositionFrame:RegisterEvent("BAG_UPDATE");
UpdateCheapestPositionFrame:SetScript("OnEvent",  GreyHandling.functions.UpdateCheapestJunkPosition);
