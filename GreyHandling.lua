local A, GreyHandling = ...

GreyHandling.data.party = {}

function GreyHandling.functions.suggestStackExchange()

end

function GreyHandling.frame:OnEvent(event, key, state, a, b, c, d, e, f, g, h, i ,j, k,l, m, n, o)
	if event == "MODIFIER_STATE_CHANGED" and key == "LCTRL" and state == 1 and IsShiftKeyDown() then
		OpenAllBags()
		GreyHandling.functions.GlowCheapestGrey()
	elseif event == "CHAT_MSG_LOOT" then
		GreyHandling.functions.handleChatMessageLoot(key, state, a, b, c, d, e, f, g, h, i ,j, k,l, m, n, o)
	end
end

print(format("%s: Launch by hitting left CTRL while holding SHIFT. (%s)", GreyHandling.NAME, GreyHandling.OPTION_COMMAND))
InterfaceOptions_AddCategory(GreyHandling.options.panel);
GameTooltip:HookScript("OnTooltipSetItem", GreyHandling.functions.ToolTipHook)
ItemRefTooltip:HookScript("OnTooltipSetItem", GreyHandling.functions.ToolTipHook)
GreyHandling.frame:RegisterEvent("MODIFIER_STATE_CHANGED")
GreyHandling.frame:RegisterEvent("CHAT_MSG_LOOT")
GreyHandling.frame:SetScript("OnEvent", GreyHandling.frame.OnEvent)
