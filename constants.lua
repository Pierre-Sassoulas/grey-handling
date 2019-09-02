-- This also define the namespace and should be the first file loaded

local A, GreyHandling = ...
GreyHandling.frame = CreateFrame("Frame")
GreyHandling.loot_frame = CreateFrame("Frame")
GreyHandling.chat_frame = CreateFrame("Frame")
GreyHandling.member_leave_frame = CreateFrame("Frame")
GreyHandling.functions = {}
GreyHandling.db = {}
GreyHandling.SELL_PRICE_TEXT = format("%s:", SELL_PRICE)
GreyHandling.IS_CLASSIC = nil
GreyHandling.NAME = "GreyHandling"
GreyHandling.SHORT_NAME = "GH"
GreyHandling.DISPLAY_NAME = "Grey Handling"
GreyHandling.MAX_CHAR_IN_CHAT_LOOT_MESSAGE = 255
GreyHandling.DEVELOPMENT_VERSION = false -- /console scriptErrors 1
GreyHandling.DESCRIPTION = GetAddOnMetadata(GreyHandling.NAME, "NOTES")
GreyHandling.options = {}
GreyHandling.options.frame = CreateFrame("FRAME")
GreyHandling.OPTION_COMMAND = "/gho"
GreyHandling.options.DEFAULT_TALKATIVE = true
GreyHandling.options.DEFAULT_VERBOSE = true
GreyHandling.options.DEFAULT_SHOW_PRICE = true
GreyHandling.options.DEFAULT_SHOW_API_FAIL = false
GreyHandling.options.DEFAULT_USE_SCRAP_JUNK_LIST = true
GreyHandling.options.DEFAULT_SUGGEST_TRADE = true
GreyHandling.options.DEFAULT_SHOW_CHEAPEST_ALWAYS = true
GreyHandling.redPrint = "ff4d4d"
GreyHandling.greyPrint = "a0a0a0"
GreyHandling.bluePrint = "6699ff"

local numberOfTries = 0
while not C_ChatInfo.RegisterAddonMessagePrefix(GreyHandling.NAME) and numberOfTries < 10 do
  GreyHandling.print(format("Failed to create communication channel (%s))", numberOfTries))
  numberOfTries = numberOfTries + 1
end

function GreyHandling.print(str)
    -- |cff is a wow keyword
	print("|cff"..GreyHandling.greyPrint..tostring(GreyHandling.SHORT_NAME).."|r: "..str)
end

-- localization helpers
-- returns the L array with meta suitable for
-- https://authors.curseforge.com/knowledge-base/world-of-warcraft/531-localization-substitutions
-- with lua_additive_table same-key-is-true handle-unlocalized=ignore
function GreyHandling:GetLocalization()
  local L = {}
  local Lmeta = {}
  Lmeta.__newindex = function(t, k, v)
    if v == true then -- allow for the shorter L["Foo bar"] = true
      v = k
    end
    rawset(t, k, v)
  end
  Lmeta.__index = function(t, k)
    rawset(t, k, k) -- cache it
    return k
  end
  setmetatable(L, Lmeta)
  return L
end

--- end of localization helpers
