-- This also define the namespace and should be the first file loaded

local A, GreyHandling = ...
GreyHandling.frame = CreateFrame("Frame")
GreyHandling.functions = {}
GreyHandling.SELL_PRICE_TEXT = format("%s:", SELL_PRICE)
GreyHandling.IS_CLASSIC = true
GreyHandling.NAME = "GreyHandling"
GreyHandling.DISPLAY_NAME = "Grey Handling"
GreyHandling.DESCRIPTION = "Permit to help with your grey objects when your bags are full, and you have no vendor around"
GreyHandling.options = {}
GreyHandling.OPTION_COMMAND = "/gho"
GreyHandling.options.frame = CreateFrame("FRAME")
GreyHandling.options.TALKATIVE = true
GreyHandling.options.VERBOSE = true
GreyHandling.options.SHOW_PRICE = true
