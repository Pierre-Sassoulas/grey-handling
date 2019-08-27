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

-- Variable for easy positioning
lastcheckbox = description
local function CreateCheckbox(text, tooltip, script)
    -- Thanks to BattlePetBreedId author (Simca@Malfurion and Hugh@Burning Blade)
    local checkbox = CreateFrame("CheckButton", nil, GreyHandling.options.panel, "UICheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", lastcheckbox, "BOTTOMLEFT", 0, 0)
    checkbox:SetSize(32, 32)
    checkbox.text:SetFontObject("GameFontNormal")
    checkbox.tooltip = tooltip
    checkbox:SetScript("OnClick", script);
    checkbox.text:SetText(" " .. text)
    lastcheckbox = checkbox
    return checkbox
end

local function change_value_verbose()
    GreyHandlingIsVerbose = not GreyHandlingIsVerbose
end

local function change_value_talkative()
    GreyHandlingIsTalkative = not GreyHandlingIsTalkative
end

local function change_value_show_price()
    GreyHandlingShowPrice = not GreyHandlingShowPrice
end

-- definition order matter here lastcheckbox is global!
local CheckboxTalkative = CreateCheckbox(
    "Automatically offer to trade the grey item in chat (displayed to everyone)",
    "",
    change_value_talkative
)
local CheckboxVerbose = CreateCheckbox(
    "Explain the logic behind the two chepeast items (displayed to you only)",
    "",
    change_value_verbose
)
local CheckboxShowPrice = CreateCheckbox(
    "Display vendor sell prices in item tooltips (might be redondant with another addon)",
    "",
    change_value_show_price
)

function GreyHandling.options.display()
	if GreyHandlingIsTalkative then
		talkative = "talk"
	else
		talkative = "do not talk"
	end
	if GreyHandlingIsVerbose then
		verbose = "talk to you,"
	else
		verbose = "keep to myself around you,"
	end
	if GreyHandlingShowPrice then
		price = "show"
	else
		price = "do not show"
	end
	print("GreyHandling: I", talkative, "to your friends,", verbose, "and", price, "item's prices.");
end

function GreyHandling.options.panel.default()
	GreyHandlingIsTalkative = GreyHandling.options.DEFAULT_TALKATIVE
	GreyHandlingIsVerbose = GreyHandling.options.DEFAULT_VERBOSE
	GreyHandlingShowPrice = GreyHandling.options.DEFAULT_SHOW_PRICE
end

GreyHandling.options.frame:RegisterEvent("ADDON_LOADED")
GreyHandling.options.frame:RegisterEvent("PLAYER_LOGOUT")

function GreyHandling.options.frame:OnEvent(event, key)
	if key ~= GreyHandling.NAME then
      return -- not us, return
    end
	if event == "ADDON_LOADED" then
		if GreyHandlingIsTalkative == nil then
			GreyHandlingIsTalkative = GreyHandling.options.DEFAULT_TALKATIVE
		end
		if  GreyHandlingIsVerbose == nil then
			GreyHandlingIsVerbose = GreyHandling.options.DEFAULT_VERBOSE
		end
		if GreyHandlingShowPrice == nil then
			GreyHandlingShowPrice = GreyHandling.options.DEFAULT_SHOW_PRICE
		end
	end
	if event == "PLAYER_LOGOUT" then
		GreyHandlingIsTalkative = GreyHandlingIsTalkative
		GreyHandlingIsVerbose = GreyHandlingIsVerbose
		GreyHandlingShowPrice = GreyHandlingShowPrice
	end
end

GreyHandling.options.frame:SetScript("OnEvent", GreyHandling.options.frame.OnEvent);
SLASH_GREYHANDLINGOPTION1 = GreyHandling.OPTION_COMMAND;
function SlashCmdList.GREYHANDLINGOPTION(msg)
	GreyHandling.options.display()
end
