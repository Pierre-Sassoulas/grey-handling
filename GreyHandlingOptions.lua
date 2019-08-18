local A, GreyHandling = ...

local panel = CreateFrame("Frame", "GreyHandlingPanel", UIParent);
panel.name = GreyHandling.addOnDisplayName
local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(format("%s options", GreyHandling.addOnDisplayName))
local description = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
description:SetText(GreyHandling.description)
description:SetJustifyH("LEFT")
description:SetJustifyV("TOP")

local function displayOptions()
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


GreyHandling.options.panel = panel
GreyHandling.options.display = displayOptions
