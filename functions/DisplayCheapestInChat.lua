local A, GreyHandling = ...

function GreyHandling.functions.DisplayCheapestInChat(text, item)
	if GreyHandlingIsVerbose then
		local details = ""
		if item.itemCount == 1 then
			details = format("%s worth %s (max %s)",
				GetContainerItemLink(item.bag, item.slot),
				GetCoinTextureString(item.currentPrice),
				GetCoinTextureString(item.potentialPrice)
			)
		elseif item.potentialPrice == item.currentPrice then
			details = format("A full stack of %s worth %s",
				GetContainerItemLink(item.bag, item.slot),
				GetCoinTextureString(item.potentialPrice)
			)
		else
			details = format("%s*%s=%s (max %s)",
				GetContainerItemLink(item.bag, item.slot),
				item.itemCount,
				GetCoinTextureString(item.currentPrice),
				GetCoinTextureString(item.potentialPrice)
			)
		end
		print(format("%s: %s%s", GreyHandling.NAME, text, details))
	end
end
