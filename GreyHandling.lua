local A, GreyHandling = ...

GreyHandling.print(format("Launch %s by hitting left CTRL while holding SHIFT. (%s)", GreyHandling.NAME, GreyHandling.OPTION_COMMAND))
InterfaceOptions_AddCategory(GreyHandling.options.panel);
GameTooltip:HookScript("OnTooltipSetItem", GreyHandling.functions.ToolTipHook)
ItemRefTooltip:HookScript("OnTooltipSetItem", GreyHandling.functions.ToolTipHook)

BINDING_NAME_GH_ALL = "Launch GreyHandling"
BINDING_NAME_GH_TRADE = "Search for trades only"
BINDING_NAME_GH_THROW = "Throw cheapest item only"
BINDING_HEADER_GH = GreyHandling.NAME

function GreyHandling.isCheapest(bag, slot)
	local now, later = GreyHandling.functions.GetCheapestJunk()
	return (bag==now.bag and slot==now.slot) or (later.bag == bag and later.slot == slot)
end

function GreyHandling.isMutuallyBeneficialTrade(bag, slot)
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

function GreyHandlingMain()
	if GreyHandling.DEVELOPMENT_VERSION then
		GreyHandling.allTests()
		GreyHandling.print("All tests passed successfully.")
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
		GreyHandling.print("|cff"..GreyHandling.redPrint.."Not in a group.".."|r")
	end
end

function GreyHandling.frame:OnEvent(event, key, state)
	if not GreyHandlingDeactivateDefaultKeybind and key == "LCTRL" and state == 1 and IsShiftKeyDown() then
		GreyHandlingMain()
	end
end
GreyHandling.frame:RegisterEvent("MODIFIER_STATE_CHANGED")
GreyHandling.frame:SetScript("OnEvent", GreyHandling.frame.OnEvent)

function GreyHandling.loot_frame:OnLoot(event, chat_message, player_name_retail, a, b, player_name_classic, d, e, f, g, h, line_number, player_id, k, l, m, n, o)
	-- print(event, "-", chat_message, "-", player_name_retail, "-", a,  "-", b, "-",  player_name_classic, "-",  d, "-",  e, "-", f, "-",  g, "-",  h, "-",  line_number,  "-", player_id, "-",  k, "-",  l, "-", m, "-",  n, "-",  o)
	if GreyHandling.IS_CLASSIC then
		GreyHandling.functions.handleChatMessageLoot(chat_message, player_name_classic, line_number, player_id, k, l, m, n, o)
	else
		GreyHandling.functions.handleChatMessageLoot(chat_message, player_name_retail, line_number, player_id, k, l, m, n, o)
	end
end
GreyHandling.loot_frame:RegisterEvent("CHAT_MSG_LOOT")
GreyHandling.loot_frame:SetScript("OnEvent", GreyHandling.loot_frame.OnLoot)

function GreyHandling.chat_frame:OnChat(event, addon,  text, channel, sender, target, zoneChannelID, localID, name, instanceID)
	if addon == GreyHandling.NAME then
		GreyHandling.functions.SomeoneAskForExchange(text, channel, sender, target, zoneChannelID, localID, name, instanceID)
	--elseif addon == GreyHandling.ADDON_CHAT_VERSION then
		--print(addon, text)
	end
end
GreyHandling.chat_frame:RegisterEvent("CHAT_MSG_ADDON")
GreyHandling.chat_frame:SetScript("OnEvent", GreyHandling.chat_frame.OnChat)

function GreyHandling.member_leave_frame:OnLeave(event, addon,  text, channel, sender, target, zoneChannelID, localID, name, instanceID)
	local playerNames = {}
	for raidIndex = 1, GetNumGroupMembers() do
		local name = GetRaidRosterInfo(raidIndex)
		playerNames[name] = true
	end
	GreyHandling.db.removePlayerThatLeft(playerNames)
end
GreyHandling.member_leave_frame:RegisterEvent("GROUP_LEFT")
GreyHandling.member_leave_frame:SetScript("OnEvent", GreyHandling.member_leave_frame.OnLeave)

if IsAddOnLoaded("ArkInventory") or IsAddOnLoaded("ArkInventoryClassic") then
	hooksecurefunc(ArkInventory.API, "ItemFrameUpdated", GreyHandling.functions.AISetBagItemGlow)
end