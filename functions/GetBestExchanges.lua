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
	local bestExchanges = {}
	for player_id, items in pairs(GreyHandling.data.items) do
		for itemLink, itemInformation  in pairs(items) do
			local ourCount = GetItemCount(itemLink)
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
				itemEquipLoc, itemIcon, vendorPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID,
				isCraftingReagent = GetItemInfo(itemLink)
			if ourCount ~= 0 and ourCount%itemInformation.itemStackCount ~= 0 then
				if exchanges[player_id] == nil then
					exchanges[player_id] = {}
				end
				exchanges[player_id][itemLink] = GreyHandling.functions.CreateExchange(itemLink, ourCount,
					itemInformation.number%itemInformation.itemStackCount, itemInformation.vendorPrice,
					itemInformation.itemStackCount, itemInformation.confidence
				)
			end
		end
	end
	local bestExchangeForCurrentPlayer = nil
	local hasGreyHandling = nil
	for player_id, item_link_values in pairs(exchanges) do
		if not bestExchangeForCurrentPlayer then
			bestExchangeForCurrentPlayer = {
				itemGiven=nil, itemTaken=nil, ourGain=nil, theirGain=nil, ourCount=nil, theirCount=nil,
				greyHandlingGain=nil, fairness=nil, playerId=nil,
			}
			hasGreyHandling = nil
		end
		for itemGiven, givenValues in pairs(item_link_values) do
			for itemTaken, takenValues in pairs(item_link_values) do
				if itemGiven ~= itemTaken then
					-- print(itemGiven.item, givenValues.ourCount, GetCoinTextureString(givenValues.vendorPrice),
					-- itemTaken.item, takenValues.theirCount, GetCoinTextureString(takenValues.vendorPrice))
					if takenValues.confidence == 1 then
						hasGreyHandling = True
					end
					if hasGreyHandling and takenValues.confidence ~= 1 then
						-- We don't want to consider non scrap if the user said it's not scrap by GH communication
						break
					end
					local given =  givenValues.ourCount * givenValues.vendorPrice
					local taken = takenValues.theirCount * takenValues.vendorPrice
					local ourGain = taken - given - givenValues.lossCount * givenValues.vendorPrice
					local theirGain = given - taken - takenValues.lossCount * takenValues.vendorPrice
					local totalGain = given + taken
					local potentialGain = givenValues.ourCount * givenValues.vendorPrice
					local greyHandlingGain = totalGain + potentialGain
					local fairness = (theirGain - ourGain) * (theirGain - ourGain)
					local currentExchange =  {
						itemGiven=itemGiven, itemTaken=itemTaken, ourGain=ourGain, theirGain=theirGain,
						ourCount=givenValues.ourCount, theirCount=takenValues.theirCount, greyHandlingGain=greyHandlingGain,
						fairness=fairness, playerId=player_id
					}
					if not bestExchangeForCurrentPlayer.greyHandlingGain or greyHandlingGain > bestExchangeForCurrentPlayer.greyHandlingGain then
						bestExchangeForCurrentPlayer = currentExchange
					end
				end
			end
		end
		table.insert(bestExchanges, bestExchangeForCurrentPlayer)
		bestExchangeForCurrentPlayer = nil
	end
	return bestExchanges
end
