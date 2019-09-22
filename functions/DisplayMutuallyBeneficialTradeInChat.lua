local A, GreyHandling = ...

function GreyHandling.functions.DisplayMutuallyBeneficialTradeInChat(exchange)
	local multiplicator = "*"
	local msg = "|cFF6699ff"..exchange.playerId.."|r - "..exchange.itemGiven..multiplicator..exchange.ourCount
	if exchange.ourGain > 0 then
		msg = format("%s and %s", msg, GetCoinTextureString(exchange.ourGain))
	end
	msg = msg.." for their "..exchange.itemTaken..multiplicator..exchange.theirCount
	if exchange.ourGain < 0 then
		msg = format("%s and %s", msg, GetCoinTextureString(-exchange.ourGain))
	end
	return msg
end
