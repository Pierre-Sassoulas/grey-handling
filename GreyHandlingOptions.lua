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

GreyHandling.options.panel = panel
