local A, GreyHandling = ...

function GreyHandling.functions.numberLootedFromChatMessage(chat_message)
	local position = string.find(chat_message, "]")
	if position == nil then
		return 1
	end
	local numberStartIndex = position
	for i=position, GreyHandling.MAX_CHAR_IN_CHAT_LOOT_MESSAGE, 1 do
		if tonumber(string.sub(chat_message, i, i)) ~= nil then
			-- TODO if the character is a number what is at his left is a number
			-- This won't work for language that work from the right to the left
			numberStartIndex = i
			break
		end
	end
	local number = tonumber(string.sub(chat_message, numberStartIndex))
	if not number then
		return 1
	end
	return number
end
