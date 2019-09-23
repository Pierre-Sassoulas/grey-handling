local A, GreyHandling = ...

function GreyHandling.functions.DisplayCheapestInChat(text, item)
	if GreyHandlingIsVerbose then
		local details = ""
		if item.itemCount == 1 then
			details = GetContainerItemLink(item.bag, item.slot)
		elseif item.potentialPrice == item.currentPrice then
			details = format("A full stack of %s", GetContainerItemLink(item.bag, item.slot))
		else
			details = format("%s %s/%s",
				GetContainerItemLink(item.bag, item.slot),
				item.itemCount,
				item.itemStackCount
			)
		end
		print(format("%s %s (%s)", text, details, GetCoinTextureString(item.currentPrice)))
	end
end
