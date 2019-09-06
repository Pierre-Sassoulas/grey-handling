local A, GreyHandling = ...

local playerName=UnitName("player")
local realmName=GetRealmName()
GreyHandling.data.playerNameWithoutServer = playerName
GreyHandling.data.playerNameWithServer = format("%s-%s", playerName, string.gsub(realmName, "%s+", ""))
if GreyHandling.IS_CLASSIC then
  GreyHandling.data.playerName = playerName
else
  GreyHandling.data.playerName = format("%s-%s", playerName, string.gsub(realmName, "%s+", ""))
end
