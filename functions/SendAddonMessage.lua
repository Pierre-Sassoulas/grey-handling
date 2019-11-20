local A, GreyHandling = ...

function GreyHandling.sendVersionToParty()
	C_ChatInfo.SendAddonMessage(GreyHandling.NAME, GetAddOnMetadata(GreyHandling.NAME, "VERSION"))
end

function GreyHandling.functions.ExchangeMyJunkPlease(target)
	target = target or "PARTY"
	local message = ""
	local freeSpace = 0
	for bagID = 0, NUM_BAG_SLOTS do
		freeSpace = freeSpace + GetContainerNumFreeSlots(bagID);
		for bagSlot = 1, GetContainerNumSlots(bagID) do
			local itemid = GetContainerItemID(bagID, bagSlot)
			if itemid and IsAddOnLoaded("Scrap") and Scrap:IsJunk(itemid, bagID, bagSlot) then
				local _, _, _, _, _, _, _, itemStackCount = GetItemInfo(itemid)
				local _, itemCount = GetContainerItemInfo(bagID, bagSlot)
				if itemCount%itemStackCount ~=0 then -- We don't want to exchange our full stack
					-- If someone has a lot of bag space we might.
					message = format("%s %s-%s", message, itemid, itemCount)
				end
			end
		end
	end
	message = format("v-%s b-%s %s", GetAddOnMetadata(GreyHandling.NAME, "VERSION"), freeSpace, message)
	if message ~= "" then
		if target == "PARTY" then
			C_ChatInfo.SendAddonMessage(GreyHandling.NAME, message)
		else

			C_ChatInfo.SendAddonMessage(GreyHandling.NAME, message, "WHISPER", target)
		end
	end
end

function GreyHandling.functions.SomeoneAskForExchange(text, channel, sender, target, zoneChannelID, localID, name, instanceID)
	-- print(text, "-", channel, "-", sender, "-",  target, "-", zoneChannelID, "-", localID, "-",  name, "-", instanceID)
	if sender == GreyHandling.data.playerNameWithServer and not GreyHandling.DEVELOPMENT_VERSION then
		return -- We don't read our own message, except in debug because it helps to dev
	end
	-- print(text, "-", channel, "-", sender, "-",  target, "-", zoneChannelID, "-", localID,"-",  name, "-", instanceID)
	local freeStack = ""
	GreyHandling.data.items[sender] = nil
	for itemid, itemCount in string.gmatch(text, "(%w+)-(%w+)") do
		if itemid == "b" then
			GreyHandling.db.initializePlayer(sender, itemCount)
			-- print(format("%s has %s bag spaces.", sender, GreyHandling.db.getRemainingBagSpaceForPlayer(sender)))
		elseif itemid == "v" then
			local playerVersion = GetAddOnMetadata(GreyHandling.NAME, "VERSION")
			if itemCount>playerVersion then
				GreyHandling.print(
					format(GreyHandling["%s has %s of %s, it means you could upgrade your own version."], sender, itemCount,
					GreyHandling.NAME)
				)
			end
		else
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
			itemEquipLoc, itemIcon, vendorPrice = GetItemInfo(itemid)
			if not itemLink then
				-- We can have problem if the user do not have item in cache.
				-- (Happens when the teammate had previous object we did not see)
				break
			end
			freeStack = format("%s%s*%s, ", freeStack, itemLink, itemStackCount - itemCount%itemStackCount)
			GreyHandling.db.setItemForPlayer(sender, itemLink, vendorPrice, itemStackCount, itemCount, 1)
		end
	end
	GreyHandling.print(format(GreyHandling["%s sent you their current list of exchangeable items."], sender))
	--if GreyHandlingIsVerbose and target=="WHISPER" then
	--print(
--		format("%s: %s has %s bag spaces available and can also stack %son top of that.",
--			GreyHandling.NAME, sender, GreyHandling.db.getRemainingBagSpaceForPlayer(sender), freeStack
--		)
--	)
	--end
end
