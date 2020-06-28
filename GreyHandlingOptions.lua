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

local function change_value_deactivate_default_keybind()
	GreyHandlingDeactivateDefaultKeybind = not GreyHandlingDeactivateDefaultKeybind
end

local function change_value_show_cheapeast_always()
	GreyHandlingShowCheapestAlways = not GreyHandlingShowCheapestAlways
end


function GreyHandling.options.panel.default()
	GreyHandlingIsTalkative = GreyHandling.options.DEFAULT_TALKATIVE
	GreyHandlingIsVerbose = GreyHandling.options.DEFAULT_VERBOSE
	GreyHandlingShowPrice = GreyHandling.options.DEFAULT_SHOW_PRICE
	GreyHandlingWhatIsJunkValue = GreyHandling.options.DEFAULT_WHAT_IS_JUNK
	GreyHandlingDeactivateDefaultKeybind = GreyHandling.options.DEFAULT_DEACTIVATE_DEFAULT_KEYBIND
	GreyHandlingShowCheapestAlways = GreyHandling.options.DEFAULT_SHOW_CHEAPEST_ALWAYS
end

local function changeWhatIsJunkValue(self)
	UIDropDownMenu_SetSelectedID(WhatIsJunkValueDropDown, self:GetID())
	GreyHandlingWhatIsJunkValue = self.value
    -- Must recalculate cheapest object if this option change
    GreyHandling.functions.CalculateCheapestJunk()
end

local function initWhatIsJunkValue(self, level)
	local whatIsJunkValues = {}
	if IsAddOnLoaded("Scrap") then
		table.insert(whatIsJunkValues, GreyHandling["Junk according to Scrap"])
	end
	if IsAddOnLoaded("Peddler") then
		table.insert(whatIsJunkValues, GreyHandling["Marked for sell by Peddler"])
	end
	table.insert(whatIsJunkValues, GreyHandling["Grey Items"])
	table.insert(whatIsJunkValues, GreyHandling["Common Items"])
	table.insert(whatIsJunkValues, GreyHandling["Uncommon Items"])
	table.insert(whatIsJunkValues, GreyHandling["Rare Items"])
	table.insert(whatIsJunkValues, GreyHandling["All Items"])
	for index, whatIsJunkValue in pairs(whatIsJunkValues) do
		local whatIsJunkValueOption = UIDropDownMenu_CreateInfo()
		whatIsJunkValueOption.text = whatIsJunkValue
		whatIsJunkValueOption.value = whatIsJunkValue
		whatIsJunkValueOption.func = changeWhatIsJunkValue
		UIDropDownMenu_AddButton(whatIsJunkValueOption)
		if whatIsJunkValue == GreyHandlingWhatIsJunkValue then
			UIDropDownMenu_SetSelectedID(WhatIsJunkValueDropDown, index)
		end
	end
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
		if GreyHandlingWhatIsJunkValue == nil then
			GreyHandlingWhatIsJunkValue = GreyHandling.options.DEFAULT_WHAT_IS_JUNK
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
		AddTextTitle(GreyHandling["Default behavior"])
		local CheckboxShowAPIFail = CreateCheckbox(
			GreyHandling["Display and pick the cheapest items even if there is a mutually beneficial trade"], "",
			change_value_show_cheapeast_always,  GreyHandlingShowCheapestAlways
		)
		AddTextTitle(GreyHandling["Keybinding"])
		local CheckboxSuggestTrade = CreateCheckbox(
			GreyHandling["Deactivates the default keybind. (You'll need to assign one yourself in 'KeyBinding' => 'Addons')"], "",
			change_value_deactivate_default_keybind,  GreyHandlingDeactivateDefaultKeybind
		)
		AddTextTitle(GreyHandling["Item tooltip"])
		local CheckboxShowPrice = CreateCheckbox(
			GreyHandling["Display vendor sell prices (might be redondant with another addon)"], "",
			change_value_show_price, GreyHandlingShowPrice
		)
		AddTextTitle(GreyHandling["Text in chat"])
		local CheckboxVerbose = CreateCheckbox(
			GreyHandling["Explain the logic behind the two chepeast items (displayed to you)"], "", change_value_verbose,
			GreyHandlingIsVerbose
		)
		local CheckboxTalkative = CreateCheckbox(
			GreyHandling["Automatically offer to trade the cheapest item (displayed to everyone)"], "", change_value_talkative,
			GreyHandlingIsTalkative
		)
		AddTextTitle(GreyHandling["Determining what is junk for you"])
		local whatIsJunkValue = CreateFrame("Button", "WhatIsJunkValueDropDown", GreyHandling.options.panel, "UIDropDownMenuTemplate")
	    whatIsJunkValue:SetPoint("TOPLEFT", lastcheckbox, "BOTTOMLEFT", 0, -10)
		lastcheckbox = whatIsJunkValue
		UIDropDownMenu_Initialize(WhatIsJunkValueDropDown, initWhatIsJunkValue)
		UIDropDownMenu_SetWidth(WhatIsJunkValueDropDown, 200);
		UIDropDownMenu_SetButtonWidth(WhatIsJunkValueDropDown, 200);
	end
	if event == "PLAYER_LOGOUT" then
		GreyHandlingIsTalkative = GreyHandlingIsTalkative
		GreyHandlingIsVerbose = GreyHandlingIsVerbose
		GreyHandlingShowPrice = GreyHandlingShowPrice
		GreyHandlingWhatIsJunkValue = GreyHandlingWhatIsJunkValue
		GreyHandlingDeactivateDefaultKeybind = GreyHandlingDeactivateDefaultKeybind
		GreyHandlingShowCheapestAlways = GreyHandlingShowCheapestAlways
	end
end
