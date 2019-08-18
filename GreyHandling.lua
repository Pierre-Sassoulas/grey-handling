local A, GreyHandling = ...

local SELL_PRICE_TEXT = format("%s:", SELL_PRICE)
local f = CreateFrame("Frame")

local ThisAddon_Defaults = {
  ["Options"] = {
    ["MasterOnOff"] = "On",
    ["version"] = "1.0",
    ["debug"] = false,
    ["More Random Variables"] = Value,
  },
};

function f:OnEvent(event, key, state)
	if key == "LCTRL" and state == 1 and IsShiftKeyDown() then
		OpenAllBags()
		GreyHandling.functions.GlowCheapestGrey()
	end
end

InterfaceOptions_AddCategory(GreyHandling.options.panel);

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

function greyHandlingOption()
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


frame:SetScript("OnEvent", frame.OnEvent);
SLASH_GREYHANDLINGOPTION1 = "/gho";
function SlashCmdList.GREYHANDLINGOPTION(msg)
	greyHandlingOption()
end

print("GreyHandling: Launch by hitting ctrl while holding shift. (/gho)")
GameTooltip:HookScript("OnTooltipSetItem", SetGameToolTipPrice)
ItemRefTooltip:HookScript("OnTooltipSetItem", SetItemRefToolTipPrice)
f:RegisterEvent("MODIFIER_STATE_CHANGED")
f:SetScript("OnEvent", f.OnEvent)
