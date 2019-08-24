local A, GreyHandling = ...

GreyHandling.data.party = {}

function GreyHandling.functions.numberLooted(chat_message)
	local event = {}
	local position = string.find(chat_message, " x")
	if position == nil then
		return 1
	end
	return tonumber(string.sub(chat_message, position+2))
end

function GreyHandling.functions.suggestStackExchange()

end

function GreyHandling.functions.handleLoot(chat_message, player_name, a, b, c, d, e, f, g, h, line_number ,player_id, k, l, m, n, o)
	if GreyHandling.data.names[player_id] == nil then
		GreyHandling.data.names[player_id] = player_name
	end
	if GreyHandling.data.items[player_id] == nil then
		GreyHandling.data.items[player_id] = {}
	end
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
		itemEquipLoc, itemIcon, vendorPrice = GetItemInfo(chat_message)
	if GreyHandling.data.items[player_id][itemLink] == nil then
		GreyHandling.data.items[player_id][itemLink] = {}
		GreyHandling.data.items[player_id][itemLink]["itemStackCount"] = itemStackCount
		local our = GetItemCount(itemLink)
		if our == nil then
			GreyHandling.data.items[player_id][itemLink]["number"] = 0
		else
			-- We can initialize properly only if its us as long as we have no communication
			GreyHandling.data.items[player_id][itemLink]["number"] = our
		end
	end
	print(format("The player %s (%s) had %s*%s (max %s)", player_name, player_id, itemLink, GreyHandling.data.items[player_id][itemLink]["number"], GreyHandling.data.items[player_id][itemLink]["itemStackCount"] ))
	if itemStackCount == 1 then
		return -- We can't optimize stacking for items that do not stack, we do not optimize stacking for green or rare
	end
	local number= GreyHandling.functions.numberLooted(chat_message)
	GreyHandling.data.items[player_id][itemLink]["number"] = GreyHandling.data.items[player_id][itemLink]["number"] + number
	print(format("The player %s (%s) now have %s*%s (max %s)", player_name, player_id, itemLink, GreyHandling.data.items[player_id][itemLink]["number"], GreyHandling.data.items[player_id][itemLink]["itemStackCount"] ))
end


function GreyHandling.frame:OnEvent(event, key, state, a, b, c, d, e, f, g, h, i ,j, k,l, m, n, o)

	if event == "MODIFIER_STATE_CHANGED" and key == "LCTRL" and state == 1 and IsShiftKeyDown() then
		OpenAllBags()
		GreyHandling.functions.GlowCheapestGrey()
	elseif event == "CHAT_MSG_LOOT" then
		GreyHandling.functions.handleLoot(key, state, a, b, c, d, e, f, g, h, i ,j, k,l, m, n, o)
	end
end



print(format("%s: Launch by hitting left CTRL while holding SHIFT. (%s)", GreyHandling.NAME, GreyHandling.OPTION_COMMAND))
InterfaceOptions_AddCategory(GreyHandling.options.panel);
GameTooltip:HookScript("OnTooltipSetItem", GreyHandling.functions.ToolTipHook)
ItemRefTooltip:HookScript("OnTooltipSetItem", GreyHandling.functions.ToolTipHook)
GreyHandling.frame:RegisterEvent("MODIFIER_STATE_CHANGED")
GreyHandling.frame:RegisterEvent("CHAT_MSG_LOOT")
GreyHandling.frame:SetScript("OnEvent", GreyHandling.frame.OnEvent)
