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
		GlowCheapestGrey()
	end
end

GreyHandling.options = {};
GreyHandling.options.panel = CreateFrame("Frame", "GreyHandlingPanel", UIParent);
GreyHandling.options.panel.name = "Grey Handling"
InterfaceOptions_AddCategory(GreyHandling.options.panel);
local title = GreyHandling.options.panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("GreyHandling options")
local greyHandlingDescription = GreyHandling.options.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
greyHandlingDescription:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
greyHandlingDescription:SetText([[This addon display the price of object in bag for Wow Classic.

It can also be activated with the ctrl key while holding shift in order to:
- Select the cheapest grey object, so you can exchange it or throw it away
with one click
- If the cheapest object is ambiguous it open your bad and make the two least
profitable grey objects glows orange in your bags:
    - One is the cheapeast right now (Ie : Right now you have 4 destroyed
    skins worth 20 coppers, max stack will be 20 for 1 silver)
    - One is the cheapest if you stack it to the max (Ie : Right now you
    have 10 shitty claws worth 40 copper, max stack will be 20 for
    80 coppers)

 Optionally it can :
 - Ask around if someone want to exchange the grey object if they have bag
 space left
 - Explain ambiguous choice for the cheapest object in your chat
 - Not display object price because you're playing retail and this is already
  done by the Wow client]])
greyHandlingDescription:SetJustifyH("LEFT")
greyHandlingDescription:SetJustifyV("TOP")
local frame = CreateFrame("FRAME"); -- Need a frame to respond to events
frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
frame:RegisterEvent("PLAYER_LOGOUT"); -- Fired when about to log out

function GreyHandling.options.panel.default()
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
