local A, GreyHandling = ...

function GreyHandling.functions.CreateExchange(itemLink, ourCount, theirCount, vendorPrice, itemStackCount)
	ourCount = ourCount%itemStackCount
	theirCount = theirCount%itemStackCount
	-- A perfect trade is a trade without stack overflow (a bag space will be created)
	local isPerfect = ourCount + theirCount < itemStackCount
	local lossCount = ourCount + theirCount - itemStackCount
	if lossCount < 0 then
		lossCount = 0
	end
	-- print(format("Creating exchange %s %s %s %s %s", itemLink, ourCount, theirCount, itemStackCount, lossCount)
	return {
		item = itemLink,
		vendorPrice = vendorPrice,
		ourCount = ourCount,
		theirCount = theirCount,
		lossCount = lossCount,
		isPerfect = isPerfect
	}
end

function GreyHandling.functions.isBetterExchange(bestExchange, currentExchange)
	if not bestExchange.greyHandlingGain then
		-- Best exchange was not initialized, the current exchange is the only exchange
		return true
	end
	if bestExchange.isPerfectGiven and bestExchange.isPerfectTaken then
		return currentExchange.isPerfectGiven and currentExchange.isPerfectTaken and currentExchange.greyHandlingGain > bestExchange.greyHandlingGain
	end
	if not bestExchange.isPerfectGiven and currentExchange.isPerfectGiven then
		return true
	end
	if not bestExchange.isPerfectTaken and currentExchange.isPerfectTaken then
		return true
	end
	if currentExchange.greyHandlingGain > bestExchange.greyHandlingGain then
		-- Exchange involve pricier objects
		return true
	end
	return false
end

function GreyHandling.functions.getBestExchange(bestExchange, player_id, given, taken)
	if given.item ~= taken.item then
		--print(
		--	given.item, given.ourCount, GetCoinTextureString(given.vendorPrice),
		--	taken.item, taken.theirCount, GetCoinTextureString(taken.vendorPrice)
		--)
		local givenValue =  given.ourCount * given.vendorPrice
		local takenValue = taken.theirCount * taken.vendorPrice
		local ourGain = takenValue - givenValue - given.lossCount * given.vendorPrice
		local theirGain = givenValue - takenValue - taken.lossCount * taken.vendorPrice
		local totalGain = givenValue + takenValue
		local potentialGain = given.ourCount * given.vendorPrice
		local greyHandlingGain = totalGain + potentialGain
		local currentExchange =  {
			itemGiven=given.item, itemTaken=taken.item, ourGain=ourGain, theirGain=theirGain,
			ourCount=given.ourCount, theirCount=taken.theirCount, greyHandlingGain=greyHandlingGain,
			isPerfectGiven = given.isPerfect, isPerfectTaken = taken.isPerfect,
			lossCountGiven = given.lossCount, lossCountTaken = taken.lossCount,
			playerId=player_id,
		}
		if GreyHandling.functions.isBetterExchange(bestExchange, currentExchange) then
			return currentExchange
		end
	end
	return bestExchange
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
				exchanges[player_id][itemLink] = GreyHandling.functions.CreateExchange(
					itemLink, ourCount,	itemInformation.number, itemInformation.vendorPrice,
					itemInformation.itemStackCount, itemInformation.confidence
				)
			end
		end
	end
	local bestExchangeForCurrentPlayer = nil
	local hasGreyHandling = nil
	for player_id, item_link_values in pairs(exchanges) do
		if not bestExchangeForCurrentPlayer then
			bestExchangeForCurrentPlayer = {greyHandlingGain=nil, isPerfect=false}
			hasGreyHandling = nil
		end
		for itemGiven, givenValues in pairs(item_link_values) do
			for itemTaken, takenValues in pairs(item_link_values) do
				if takenValues.confidence == 1 then
					hasGreyHandling = True
				end
				if hasGreyHandling and takenValues.confidence ~= 1 then
					-- We don't want to consider non scrap if the user said it's not scrap by GH communication
					break
				end
				bestExchangeForCurrentPlayer = GreyHandling.functions.getBestExchange(
					bestExchangeForCurrentPlayer, player_id, givenValues, takenValues
				)
			end
		end
		table.insert(bestExchanges, bestExchangeForCurrentPlayer)
		bestExchangeForCurrentPlayer = nil
	end
	return bestExchanges
end
