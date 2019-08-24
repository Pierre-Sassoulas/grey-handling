local A, GreyHandling = ...

function GreyHandling.functions.numberLootedFromChatMessage(chat_message)
	local event = {}
	local position = string.find(chat_message, " x")
	if position == nil then
		return 1
	end
	return tonumber(string.sub(chat_message, position+2))
end