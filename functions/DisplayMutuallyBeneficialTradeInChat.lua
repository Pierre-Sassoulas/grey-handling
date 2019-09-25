local A, GreyHandling = ...

function GreyHandling.functions.DisplayMutuallyBeneficialTradeInChat(exchange)
	local multiplicator = "*"
	local msg = ""..exchange.itemGiven..multiplicator..exchange.ourCount
	if exchange.lossCountGiven ~= 0 then
		msg = msg.."|cff"..GreyHandling.redPrint.." (their stack overflow by "..exchange.lossCountGiven..")|r "
	end
	if exchange.ourGain > 0 then
		msg = format("%s and %s", msg, GetCoinTextureString(exchange.ourGain))
	end
	msg = msg.." for |cff"..GreyHandling.bluePrint..exchange.playerId.."|r's "..exchange.itemTaken..multiplicator..exchange.theirCount
	if exchange.lossCountTaken ~= 0 then
		msg = msg.."|cff"..GreyHandling.redPrint.." (your stack overflow by "..exchange.lossCountTaken..")|r "
	end
	if exchange.ourGain < 0 then
		msg = format("%s and %s", msg, GetCoinTextureString(-exchange.ourGain))
	end
	return msg
end
