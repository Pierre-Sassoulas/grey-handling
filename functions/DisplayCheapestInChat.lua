local A, GreyHandling = ...

function GreyHandling.functions.GetCheapestMessage(text, item)
	local details = ""
	if item.itemCount == 1 then
		details = GetContainerItemLink(item.bag, item.slot)
	elseif item.potentialPrice == item.currentPrice then
		details = format(GreyHandling["A full stack of %s"], GetContainerItemLink(item.bag, item.slot))
	else
		details = format("%s %s/%s",
			GetContainerItemLink(item.bag, item.slot),
			item.itemCount,
			item.itemStackCount
		)
	end
	return format("%s %s (%s)", text, details, GetCoinTextureString(item.currentPrice))
end

function GreyHandling.functions.DisplayCheapestInChat(text, item)
	if GreyHandlingIsVerbose then
		GreyHandling.print(GreyHandling.functions.GetCheapestMessage(text, item))
	end
end
