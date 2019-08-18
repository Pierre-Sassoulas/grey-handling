local A, GreyHandling = ...

function GreyHandling.frame:OnEvent(event, key, state)
	if key == "LCTRL" and state == 1 and IsShiftKeyDown() then
		OpenAllBags()
		GreyHandling.functions.GlowCheapestGrey()
	end
end

print("GreyHandling: Launch by hitting ctrl while holding shift. (/gho)")
InterfaceOptions_AddCategory(GreyHandling.options.panel);
GameTooltip:HookScript("OnTooltipSetItem", GreyHandling.functions.SetGameToolTipPrice)
ItemRefTooltip:HookScript("OnTooltipSetItem", GreyHandling.functions.SetItemRefToolTipPrice)
GreyHandling.frame:RegisterEvent("MODIFIER_STATE_CHANGED")
GreyHandling.frame:SetScript("OnEvent", GreyHandling.frame.OnEvent)
