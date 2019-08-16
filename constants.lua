-- This also define the namespace and should be the first file loaded

local A, GreyHandling = ...
GreyHandling.frame = CreateFrame("Frame")
GreyHandling.loot_frame = CreateFrame("Frame")
GreyHandling.functions = {}
GreyHandling.SELL_PRICE_TEXT = format("%s:", SELL_PRICE)
GreyHandling.IS_CLASSIC = true
GreyHandling.NAME = "GreyHandling"
GreyHandling.DISPLAY_NAME = "Grey Handling"
GreyHandling.DESCRIPTION = GetAddOnMetadata(GreyHandling.NAME, "NOTES")
GreyHandling.options = {}
GreyHandling.options.frame = CreateFrame("FRAME")
GreyHandling.OPTION_COMMAND = "/gho"
GreyHandling.options.DEFAULT_TALKATIVE = true
GreyHandling.options.DEFAULT_VERBOSE = true
GreyHandling.options.DEFAULT_SHOW_PRICE = true
GreyHandling.data = {}
local ourName=UnitName("player")
local realmName=GetRealmName()
GreyHandling.data.ourName = format("%s-%s", ourName, string.gsub(realmName, "%s+", ""))
GreyHandling.data.names = {}
GreyHandling.data.items = {}

-- Test data remove in production
--[[
local test_object_1 = "Dent plate émoussée"
local test_object_2 = "Incisive dentelée"
local test_object_3 = "Fourrure miteuse"
GreyHandling.data.names["PlayerID1AEBCFE1123123"] = "TestName-TestServer"
GreyHandling.data.items["PlayerID1AEBCFE1123123"] = {}
GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_1] = {}
GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_1]["itemStackCount"] = 100
GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_1]["vendorPrice"] = 14699
GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_1]["number"] = 12
GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_2] = {}
GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_2]["itemStackCount"] = 20
GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_2]["vendorPrice"] = 12685
GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_2]["number"] = 5
GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_3] = {}
GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_3]["itemStackCount"] = 20
GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_3]["vendorPrice"] = 2932
GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_3]["number"] = 1
--]]
-- End Test data


--- localization helpers

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