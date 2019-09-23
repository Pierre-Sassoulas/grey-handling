local A, GreyHandling = ...

function GreyHandling.functions.DisplayMutuallyBeneficialTradeInChat(exchange)
	local multiplicator = "*"
	local msg = ""..exchange.itemGiven..multiplicator..exchange.ourCount
	if exchange.ourGain > 0 then
		msg = format("%s and %s", msg, GetCoinTextureString(exchange.ourGain))
	end
	msg = msg.." for |cFF6699ff"..exchange.playerId.."|r's "..exchange.itemTaken..multiplicator..exchange.theirCount
	if exchange.ourGain < 0 then
		msg = format("%s and %s", msg, GetCoinTextureString(-exchange.ourGain))
	end
	return msg
end
