local A, GreyHandling = ...

function GreyHandling.functions.CreateExchange(itemLink, ourCount, theirCount, vendorPrice, itemStackCount)
	-- When we have no bag space we'll have to throw some
	local lossCount = itemStackCount - ourCount - theirCount
	if lossCount > 0 then
		lossCount = 0
	end
	return {
		item = itemLink,
		vendorPrice = vendorPrice,
		ourCount = ourCount,
		theirCount = theirCount,
		lossCount = lossCount,
	}
end

function GreyHandling.functions.GetBestExchanges()
	local exchanges = {}
	local best_exchanges = {}
	for player_id, items in pairs(GreyHandling.data.items) do
		for itemLink, itemInformation  in pairs(items) do
			local ourCount = GetItemCount(itemLink)
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
				itemEquipLoc, itemIcon, vendorPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID,
				isCraftingReagent = GetItemInfo(itemLink)
			if ourCount ~= 0 then
				if exchanges[player_id] == nil then
					exchanges[player_id] = {}
				end
				exchanges[player_id][itemLink] = GreyHandling.functions.CreateExchange(itemLink, ourCount,
					itemInformation.number, itemInformation.vendorPrice, itemInformation.itemStackCount
				)
			end
		end
	end
	local egoist = {itemGiven=nil, itemTaken=nil, ourGain=0, theirGain=0, totalGain=0, fairness=nil, playerId=nil }
	local altruist = {itemGiven=nil, itemTaken=nil, ourGain=0, theirGain=0, totalGain=0, fairness=nil, playerId=nil }
	local fair = {itemGiven=nil, itemTaken=nil, ourGain=0, theirGain=0, totalGain=0, fairness=nil, playerId=nil}
	for player_id, item_link_values in pairs(exchanges) do
		for itemGiven, givenValues in pairs(item_link_values) do
			for itemTaken, takenValues in pairs(item_link_values) do
				if itemGiven ~= itemTaken then
					-- print(itemGiven.item, givenValues.ourCount, GetCoinTextureString(givenValues.vendorPrice), itemTaken.item, takenValues.theirCount, GetCoinTextureString(takenValues.vendorPrice))
					local given =  givenValues.ourCount * givenValues.vendorPrice
					local taken = takenValues.theirCount * takenValues.vendorPrice
					local ourGain = taken - given - givenValues.lossCount * givenValues.vendorPrice
					local theirGain = given - taken - takenValues.lossCount * takenValues.vendorPrice
					local totalGain = theirGain + ourGain
					local fairness = (theirGain - ourGain) * (theirGain - ourGain)
					local currentExchange =  {
						itemGiven=itemGiven, itemTaken=itemTaken, ourGain=ourGain, theirGain=theirGain,
						ourCount=givenValues.ourCount, theirCount=takenValues.theirCount, totalGain=totalGain,
						fairness=fairness, playerId=player_id
					}
					if ourGain > egoist.ourGain then
						egoist = currentExchange
					end
					if theirGain > altruist.theirGain then
						altruist = currentExchange
					end
					if fair.fairness==nil or fairness < fair.fairness then
						fair = currentExchange
					end
				end
			end

		end
	end
	--table.insert(best_exchanges, egoist)
	table.insert(best_exchanges, fair)
	--table.insert(best_exchanges, altruist)
	return best_exchanges
end
