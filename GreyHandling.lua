local A, GreyHandling = ...

print(format("%s: Launch by hitting left CTRL while holding SHIFT. (%s)", GreyHandling.NAME, GreyHandling.OPTION_COMMAND))
InterfaceOptions_AddCategory(GreyHandling.options.panel);
GameTooltip:HookScript("OnTooltipSetItem", GreyHandling.functions.ToolTipHook)
ItemRefTooltip:HookScript("OnTooltipSetItem", GreyHandling.functions.ToolTipHook)

function GreyHandling.frame:OnEvent(event, key, state)
	if key == "LCTRL" and state == 1 and IsShiftKeyDown() then
        if GreyHandling.DEVELOPMENT_VERSION then
            GreyHandling.allTests()
            print("All tests passed successfully.")
        end
		OpenAllBags()
		local foundSomething = false
		foundSomething = GreyHandling.functions.HandleCheapestJunk(foundSomething)
		foundSomething = GreyHandling.functions.HandleMutuallyBeneficialTrades(foundSomething)
		if not foundSomething then
			CloseAllBags()
		end
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





