local A, GreyHandling = ...

function GreyHandling.functions.DisplayMutuallyBeneficialTradeInChat(exchange)
	local msg = ""
	if exchange.ourGain > 0 then
		msg = format("%sGive %s", msg, GetCoinTextureString(exchange.ourGain))
	elseif exchange.ourGain == 0 then
		msg = "It's a fair trade"
	else
		msg = format("%sAsk for %s", msg, GetCoinTextureString(-exchange.ourGain))
	end
	return format(
		"%s : %s*%s for their %s*%s : %s", exchange.playerId, exchange.itemGiven, exchange.ourCount,
		exchange.itemTaken, exchange.theirCount, msg
	)
end
