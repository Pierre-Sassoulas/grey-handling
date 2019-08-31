local A, GreyHandling = ...

function GreyHandling.functions.numberLootedFromChatMessage(chat_message)
	local position = string.find(chat_message, " x")
	if position == nil then
		return 1
	end
	local number = tonumber(string.sub(chat_message, position+2))
	if not number then
		local error_msg = "Mutually beneficial trades will be less accurate. You can report this on Github."
		print(format("%s: Failed to parser a number in '%s', assuming it's 1. %s", GreyHandling.NAME, chat_message, error_msg))
		return 1
	end
	return number
end