local A, GreyHandling = ...

function GreyHandling.functions.DisplayMutuallyBeneficialTradeInChat(exchange)
	local msg = ""
	if exchange.theirGain ~= -exchange.ourGain then
		if exchange.theirGain > 0 then
			msg = format("They win %s. ", GetCoinTextureString(exchange.theirGain))
		else
			msg = format("They loose %s. ", GetCoinTextureString(-exchange.theirGain))
		end
	end
	if exchange.ourGain > 0 then
		msg = format("%sYou should give them %s", msg, GetCoinTextureString(exchange.ourGain))
	else
		msg = format("%sYou could ask for %s", msg, GetCoinTextureString(-exchange.ourGain))
	end
	return format(
		"Exchange your %s*%s for %s's %s*%s : %s", exchange.itemGiven, exchange.ourCount, GreyHandling.data.names[exchange.playerId],
		exchange.itemTaken, exchange.theirCount, msg
	)
end
