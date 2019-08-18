local A, GreyHandling = ...

local f = CreateFrame("Frame")
function f:OnEvent(event, key, state)
	if key == "LCTRL" and state == 1 and IsShiftKeyDown() then
		OpenAllBags()
		GreyHandling.functions.GlowCheapestGrey()
	end
end

function GreyHandling.options.panel.default()
	TALKATIVE = true
	VERBOSE = true
	SHOW_PRICE = true
end

local frame = CreateFrame("FRAME"); -- Need a frame to respond to events
frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
frame:RegisterEvent("PLAYER_LOGOUT"); -- Fired when about to log out

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
SLASH_GREYHANDLINGOPTION1 = "/gho";
function SlashCmdList.GREYHANDLINGOPTION(msg)
	GreyHandling.options.display()
end

print("GreyHandling: Launch by hitting ctrl while holding shift. (/gho)")
InterfaceOptions_AddCategory(GreyHandling.options.panel);
GameTooltip:HookScript("OnTooltipSetItem", SetGameToolTipPrice)
ItemRefTooltip:HookScript("OnTooltipSetItem", SetItemRefToolTipPrice)
f:RegisterEvent("MODIFIER_STATE_CHANGED")
f:SetScript("OnEvent", f.OnEvent)
