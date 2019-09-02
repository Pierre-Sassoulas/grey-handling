local A, GreyHandling = ...

local playerName=UnitName("player")
local realmName=GetRealmName()
if GreyHandling.IS_CLASSIC then
  GreyHandling.data.playerName = playerName
else
  GreyHandling.data.playerName = format("%s-%s", playerName, string.gsub(realmName, "%s+", ""))
end
