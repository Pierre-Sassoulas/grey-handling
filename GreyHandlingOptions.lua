local A, GreyHandling = ...

GreyHandling.options.panel = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer);
GreyHandling.options.panel.name = GreyHandling.DISPLAY_NAME

local function CreateCheckbox(text, tooltip, script, truth)
    -- Thanks to BattlePetBreedId author (Simca@Malfurion and Hugh@Burning Blade)
    local checkbox = CreateFrame("CheckButton", nil, GreyHandling.options.panel, "UICheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", lastcheckbox, "BOTTOMLEFT", 0, -5)
    checkbox:SetSize(24, 24)
    checkbox.text:SetFontObject("GameFontNormal")
    checkbox.tooltip = tooltip
    checkbox:SetScript("OnClick", script);
    checkbox.text:SetText(" " .. text)
	checkbox:SetChecked(truth)
    lastcheckbox = checkbox
    return checkbox
end

local function AddTextTitle(title)
	local textTitle = GreyHandling.options.panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	textTitle:SetPoint("TOPLEFT", lastcheckbox, "BOTTOMLEFT", 0, -20)
	textTitle:SetText(title)
    lastcheckbox = textTitle
    return textTitle
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

local function change_value_remind_about_scrap()
    GreyHandlingUseScrapJunkList = not GreyHandlingUseScrapJunkList
end

local function change_value_deactivate_default_keybind()
	GreyHandlingDeactivateDefaultKeybind = not GreyHandlingDeactivateDefaultKeybind
end

local function change_value_show_cheapeast_always()
	GreyHandlingShowCheapestAlways = not GreyHandlingShowCheapestAlways
end

function GreyHandling.options.display()
	local scrap = "I could use scrap to determine what is junk, if you had it."
	if IsAddOnLoaded("Scrap") then
		scrap = "I'm going to use Scrap to determine what is junk. "
	end
	local talkative = "I do not talk to your friends."
	if GreyHandlingIsTalkative then
		talkative = "I talk to your friends."
	end
	local verbose = "I keep to myself around you."
	if GreyHandlingIsVerbose then
		verbose = "I talk to you."
	end
	local price = "I do not show item's prices."
	if GreyHandlingShowPrice then
		price = "I show item's prices."
	end
	GreyHandling.print(format("%s %s %s And %s", scrap, talkative, verbose, price))
end

function GreyHandling.options.panel.default()
	GreyHandlingIsTalkative = GreyHandling.options.DEFAULT_TALKATIVE
	GreyHandlingIsVerbose = GreyHandling.options.DEFAULT_VERBOSE
	GreyHandlingShowPrice = GreyHandling.options.DEFAULT_SHOW_PRICE
	GreyHandlingUseScrapJunkList = GreyHandling.options.DEFAULT_USE_SCRAP_JUNK_LIST
	GreyHandlingDeactivateDefaultKeybind = GreyHandling.options.DEFAULT_DEACTIVATE_DEFAULT_KEYBIND
	GreyHandlingShowCheapestAlways = GreyHandling.options.DEFAULT_SHOW_CHEAPEST_ALWAYS
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
		if GreyHandlingUseScrapJunkList == nil then
			GreyHandlingUseScrapJunkList = GreyHandling.options.DEFAULT_USE_SCRAP_JUNK_LIST
		end
		if GreyHandlingDeactivateDefaultKeybind == nil then
			GreyHandlingDeactivateDefaultKeybind = GreyHandling.options.DEFAULT_DEACTIVATE_DEFAULT_KEYBIND
		end
		if GreyHandlingShowCheapestAlways == nil then
			GreyHandlingShowCheapestAlways = GreyHandling.options.DEFAULT_SHOW_CHEAPEST_ALWAYS
		end
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
		-- definition order matter here lastcheckbox is global!
		AddTextTitle("Keybinding")
		local CheckboxSuggestTrade = CreateCheckbox(
			"Deactivates the default keybind. You'll need to assign one yourself in 'KeyBinding' => 'Addons'", "",
			change_value_deactivate_default_keybind,  GreyHandlingDeactivateDefaultKeybind
		)
		local CheckboxShowAPIFail = CreateCheckbox(
			"Display and pick the cheapest items even if there is a mutually beneficial trade", "",
			change_value_show_cheapeast_always,  GreyHandlingShowCheapestAlways
		)
		AddTextTitle("Item tooltip")
		local CheckboxShowPrice = CreateCheckbox(
			"Display vendor sell prices (might be redondant with another addon)", "",
			change_value_show_price, GreyHandlingShowPrice
		)
		AddTextTitle("Determining what is junk for you")
		local CheckboxUseScrapJunkList = CreateCheckbox(
			"Use SCRAP junk list (Scrap consider some grey as valuable, and some white as scrap)", "",
			change_value_remind_about_scrap,  GreyHandlingUseScrapJunkList
		)
		--local iconPlacement = CreateFrame("Button", "IconPlacementDropDown", GreyHandling.options.panel, "UIDropDownMenuTemplate")
	    --iconPlacement:SetPoint("TOPLEFT", lastcheckbox, "BOTTOMLEFT", 0, 0)
		--lastcheckbox = iconPlacement
		--UIDropDownMenu_Initialize(IconPlacementDropDown, initIconPlacement)
		--UIDropDownMenu_SetWidth(IconPlacementDropDown, 110);
		--UIDropDownMenu_SetButtonWidth(IconPlacementDropDown, 110);
		AddTextTitle("Text in chat")
		local CheckboxVerbose = CreateCheckbox(
			"Explain the logic behind the two chepeast items (displayed to you)", "", change_value_verbose,
			GreyHandlingIsVerbose
		)
		local CheckboxTalkative = CreateCheckbox(
			"Automatically offer to trade the grey item (displayed to everyone)", "", change_value_talkative,
			GreyHandlingIsTalkative
		)
	end
	if event == "PLAYER_LOGOUT" then
		GreyHandlingIsTalkative = GreyHandlingIsTalkative
		GreyHandlingIsVerbose = GreyHandlingIsVerbose
		GreyHandlingShowPrice = GreyHandlingShowPrice
		GreyHandlingUseScrapJunkList = GreyHandlingUseScrapJunkList
		GreyHandlingDeactivateDefaultKeybind = GreyHandlingDeactivateDefaultKeybind
		GreyHandlingShowCheapestAlways = GreyHandlingShowCheapestAlways
	end
end

GreyHandling.options.frame:SetScript("OnEvent", GreyHandling.options.frame.OnEvent);
SLASH_GREYHANDLINGOPTION1 = GreyHandling.OPTION_COMMAND;
function SlashCmdList.GREYHANDLINGOPTION(msg)
	GreyHandling.options.display()
end
