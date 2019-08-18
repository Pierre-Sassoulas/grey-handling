local A, GreyHandling = ...

GreyHandling.options.panel = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer);
GreyHandling.options.panel.name = GreyHandling.DISPLAY_NAME
local title = GreyHandling.options.panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(GreyHandling.DISPLAY_NAME)
local description = GreyHandling.options.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
description:SetText(GreyHandling.DESCRIPTION)
description:SetJustifyH("LEFT")
description:SetJustifyV("TOP")

local function displayOptions()
	if GreyHandling.options.TALKATIVE then
		talkative = "talk"
	else
		talkative = "do not talk"
	end
	if GreyHandling.options.VERBOSE then
		verbose = "talk to you,"
	else
		verbose = "keep to himself around you,"
	end
	if GreyHandling.options.SHOW_PRICE then
		price = "show"
	else
		price "do not show"
	end
	print("GreyHandling: I", talkative, "to your friends,", verbose, "and", price, "item's prices.");
end

GreyHandling.options.display = displayOptions

function GreyHandling.options.panel.default()
	GreyHandling.options.TALKATIVE = true
	GreyHandling.options.VERBOSE = true
	GreyHandling.options.SHOW_PRICE = true
end

GreyHandling.options.frame:RegisterEvent("ADDON_LOADED")
GreyHandling.options.frame:RegisterEvent("PLAYER_LOGOUT")

function GreyHandling.options.frame:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == addOnName then
		if GreyHandling.options.TALKATIVE == nil then
			GreyHandling.options.TALKATIVE = true
		end
		if GreyHandling.options.VERBOSE == nil then
			GreyHandling.options.VERBOSE = true
		end
		if GreyHandling.options.SHOW_PRICE == nil then
			GreyHandling.options.SHOW_PRICE = true
		end
		GreyHandling.options.display()
	end

end

GreyHandling.options.frame:SetScript("OnEvent", GreyHandling.options.frame.OnEvent);
SLASH_GREYHANDLINGOPTION1 = GreyHandling.OPTION_COMMAND;
function SlashCmdList.GREYHANDLINGOPTION(msg)
	GreyHandling.options.display()
end
