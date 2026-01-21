-- This also define the namespace and should be the first file loaded

local A, GreyHandling = ...
GreyHandling.frame = CreateFrame("Frame")
GreyHandling.loot_frame = CreateFrame("Frame")
GreyHandling.chat_frame = CreateFrame("Frame")
GreyHandling.member_leave_frame = CreateFrame("Frame")
GreyHandling.only_one_item_is_cheapest = true
GreyHandling.now = nil
GreyHandling.later = nil
GreyHandling.functions = {}
GreyHandling.db = {}
GreyHandling.SELL_PRICE_TEXT = format("%s:", SELL_PRICE)
GreyHandling.IS_CLASSIC = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
GreyHandling.NAME = "GreyHandling"
GreyHandling.SHORT_NAME = "GH"
GreyHandling.DISPLAY_NAME = "Grey Handling"
GreyHandling.MAX_CHAR_IN_CHAT_LOOT_MESSAGE = 255
GreyHandling.DEVELOPMENT_VERSION = false -- /console scriptErrors 1
GreyHandling.DEV_TRADE_ONLY = true
GetAddOnMetadata = GetAddOnMetadata or C_AddOns.GetAddOnMetadata
IsAddOnLoaded = IsAddOnLoaded or C_AddOns.IsAddOnLoaded
GreyHandling.DESCRIPTION = GetAddOnMetadata(GreyHandling.NAME, "NOTES")
GreyHandling.options = {}
GreyHandling.options.frame = CreateFrame("FRAME")
GreyHandling.CHAT_COMMAND = "/gh"
GreyHandling.options.DEFAULT_TALKATIVE = true
GreyHandling.options.DEFAULT_VERBOSE = true
GreyHandling.options.DEFAULT_SHOW_PRICE = true
GreyHandling.options.DEFAULT_SHOW_API_FAIL = false
GreyHandling.options.DEFAULT_WHAT_IS_JUNK = GreyHandling["Grey Items"]
GreyHandling.options.DEFAULT_DEACTIVATE_DEFAULT_KEYBIND = false
GreyHandling.options.DEFAULT_SHOW_CHEAPEST_ALWAYS = true
GreyHandling.options.DEFAULT_SOURCE_OF_ITEM_PRICE = GreyHandling["TSM Market Price, and Vendor Price"]
GreyHandling.options.AUCTION_HOUSE_CUT = 1.05 -- Could be higher, because if it's close to vendor price it's probably also hard to sell.
GreyHandling.calculationThrottled = false
GreyHandling.redPrint = "ff4d4d"
GreyHandling.greyPrint = "a0a0a0"
GreyHandling.bluePrint = "6699ff"


local numberOfTries = 0
while not C_ChatInfo.RegisterAddonMessagePrefix(GreyHandling.NAME) and numberOfTries < 10 do
  GreyHandling.print(format(GreyHandling["Failed to create communication channel (%s))"], numberOfTries))
  numberOfTries = numberOfTries + 1
end

function GreyHandling.print(str)
    -- |cff is a wow keyword
	print("|cff"..GreyHandling.greyPrint..tostring(GreyHandling.SHORT_NAME).."|r: "..str)
end
