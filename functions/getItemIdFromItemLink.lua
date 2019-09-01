local A, GreyHandling = ...

--[[
	Taken here : https://bitbucket.org/Kjasi/libkjasi/src/48396478046986fa634f35b6ab746cc943ff0042/Kjasi.lua
	Get the ID Number and Type from a link.

	The returned Type variable lets you identify the type of link. If an ItemID is passed, then the type is "id".

	If link is an item, and isFull is set, then the full ID string is returned.
	if link is a currency, and getSlot is set, returns the index in the player's currency list, with a type of "currencyIndex"
	If link is a quest, returns the Quest ID number, and the Quest's Level. Raid, Group and Dungeon quests are also specified by the Quest's level.
	Otherwise, it returns just the ID number.
]]
function GreyHandling.functions.getIDNumber(link, isFull, getSlot)
	assert(link, "LibKjasi:getIDNumber: bad argument #1: Expected a string, got nil.")
	assert((type(link)=="string")or(type(link)=="number"),"LibKjasi:getIDNumber: bad argument #1: Expected a string or number, got "..type(link)..".")
	if (type(link)=="string") then
		assert(strfind(link,":") ~= nil, "LibKjasi:getIDNumber: bad argument #1: Supplied string is not a valid link.")
	else
		return tonumber(link), "id"
	end
	local justID = string.gsub(link,".-\124H([^\124]*)\124h.-\124h", "%1")
	local itype, itemid, enchant, gem1, gem2, gem3, gem4, suffixID, uniqueID, level, upgradeId, instanceDifficultyID, numBonusIDs, bonusID1, bonusID2 = strsplit(":",justID)

	if (itype == "item") and (isFull) then
		return string.gsub(justID, "\124", "\124\124"), tostring(itype)
	elseif (itype == "currency") and (getSlot) then
		for i=1,GetCurrencyListSize() do
			local name, ih = GetCurrencyListInfo(i)
			if (ih == false) then
				if (name == lib:getNamefromLink(link)) then
					return tonumber(i), "currencyIndex"
				end
			end
		end
	elseif (itype == "quest") then
		local questlevel = enchant
		return tonumber(itemid), tostring(itype), tonumber(string.match(questlevel,"%d+")), tostring(questlevel)
		-- questlevel is returned as both a string and a number, because raid, group and dungeon quests add a character to the end of the quest's level
	else
		return tonumber(itemid), tostring(itype)
	end
end
