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

function GreyHandling.options.display()
	if GreyHandling.options.TALKATIVE then
		talkative = "talk"
	else
		talkative = "do not talk"
	end
	if GreyHandling.options.VERBOSE then
		verbose = "talk to you,"
	else
		verbose = "keep to myself around you,"
	end
	if GreyHandling.options.SHOW_PRICE then
		price = "show"
	else
		price = "do not show"
	end
	print("GreyHandling: I", talkative, "to your friends,", verbose, "and", price, "item's prices.");
end

function GreyHandling.options.panel.default()
	GreyHandling.options.TALKATIVE = false
	GreyHandling.options.VERBOSE = false
	GreyHandling.options.SHOW_PRICE = false
	GH_TALKATIVE = GreyHandling.options.TALKATIVE
	GH_VERBOSE = GreyHandling.options.VERBOSE
	GH_SHOW_PRICE = GreyHandling.options.SHOW_PRICE
end

GreyHandling.options.frame:RegisterEvent("ADDON_LOADED")
GreyHandling.options.frame:RegisterEvent("PLAYER_LOGOUT")

function GreyHandling.options.frame:OnEvent(event, key)
	if key ~= GreyHandling.NAME then
      return -- not us, return
    end
	if event == "ADDON_LOADED" then
		if GH_TALKATIVE == nil then
			GreyHandling.options.TALKATIVE = GreyHandling.options.DEFAULT_TALKATIVE
			GH_TALKATIVE = GreyHandling.options.DEFAULT_TALKATIVE
		else
			GreyHandling.options.TALKATIVE = GH_TALKATIVE
		end
		if  GH_VERBOSE == nil then
			GreyHandling.options.VERBOSE = GreyHandling.options.DEFAULT_VERBOSE
			GH_VERBOSE = GreyHandling.options.DEFAULT_VERBOSE
		else
			GreyHandling.options.VERBOSE = GH_VERBOSE
		end
		if GH_SHOW_PRICE == nil then
			GreyHandling.options.SHOW_PRICE = GreyHandling.options.DEFAULT_SHOW_PRICE
			GH_SHOW_PRICE = GreyHandling.options.DEFAULT_SHOW_PRICE
		else
			GreyHandling.options.SHOW_PRICE = GH_SHOW_PRICE
		end
	end
	if event == "PLAYER_LOGOUT" then
		GH_TALKATIVE = GreyHandling.options.TALKATIVE
		GH_VERBOSE = GreyHandling.options.VERBOSE
		GH_SHOW_PRICE = GreyHandling.options.SHOW_PRICE
	end
end

GreyHandling.options.frame:SetScript("OnEvent", GreyHandling.options.frame.OnEvent);
SLASH_GREYHANDLINGOPTION1 = GreyHandling.OPTION_COMMAND;
function SlashCmdList.GREYHANDLINGOPTION(msg)
	GreyHandling.options.display()
end
