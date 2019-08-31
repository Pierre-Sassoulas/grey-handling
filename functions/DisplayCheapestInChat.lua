local A, GreyHandling = ...

function GreyHandling.functions.DisplayCheapestInChat(text, item)
	if GreyHandlingIsVerbose then
		if item.itemCount == 1 then
			print(
				text, GetContainerItemLink(item.bag, item.slot), "worth", GetCoinTextureString(item.currentPrice),
				"(max ", GetCoinTextureString(item.potentialPrice), ")"
			)
		elseif item.potentialPrice == item.currentPrice then
			print(
				text, "A full stack of", GetContainerItemLink(item.bag, item.slot), "worth",
				GetCoinTextureString(item.potentialPrice)
			)
		else
			print(
				text, GetContainerItemLink(item.bag, item.slot), item.itemCount, "*",
				GetCoinTextureString(item.vendorPrice),	"=", GetCoinTextureString(item.currentPrice),
				"(max ", GetCoinTextureString(item.potentialPrice), ")"
			)
		end
	end
end
