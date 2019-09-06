local A, GreyHandling = ...

function GreyHandling.sendVersionToParty()
	C_ChatInfo.SendAddonMessage(GreyHandling.NAME, GetAddOnMetadata(GreyHandling.NAME, "VERSION"))
end

function GreyHandling.functions.ExchangeMyJunkPlease(target)
	target = target or "PARTY"
	local message = ""
	for bagID = 0, NUM_BAG_SLOTS do
		for bagSlot = 1, GetContainerNumSlots(bagID) do
			local itemid = GetContainerItemID(bagID, bagSlot)
			if itemid and IsAddOnLoaded("Scrap") and Scrap:IsJunk(itemid, bagID, bagSlot) then
				-- local _, _, _, _, _, _, _, itemStackCount = GetItemInfo(itemid)
				local _, itemCount = GetContainerItemInfo(bagID, bagSlot)
				-- if itemCount%itemStackCount ~=0 then -- We don't want to exchange our full stack
				-- If someone has a lot of bag space we do.
				message = format("%s %s-%s", message, itemid, itemCount)
			end
		end
	end
	if message ~= "" then
		if target == "PARTY" then
			C_ChatInfo.SendAddonMessage(GreyHandling.NAME, message)
		else

			C_ChatInfo.SendAddonMessage(GreyHandling.NAME, message, "WHISPER", target)
		end
	end
end

function GreyHandling.functions.SomeoneAskForExchange(text, channel, sender, target, zoneChannelID, localID, name, instanceID)
	print(text, "-", channel, "-", sender, "-",  target, "-", zoneChannelID, "-", localID, "-",  name, "-", instanceID)
	if sender == GreyHandling.data.playerNameWithServer and not GreyHandling.DEVELOPMENT_VERSION then
		return -- We don't read our own message, except in debug because it helps to dev
	end
	-- print(text, "-", channel, "-", sender, "-",  target, "-", zoneChannelID, "-", localID,"-",  name, "-", instanceID)
	for itemid, itemCount in string.gmatch(text, "(%w+)-(%w+)") do
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
		itemEquipLoc, itemIcon, vendorPrice = GetItemInfo(itemid)
		GreyHandling.db.setItemForPlayer(sender, itemLink, vendorPrice, itemStackCount, itemCount, 1)
	end
	-- if GreyHandlingIsVerbose and target=="PARTY" then
	print(format("%s: Informations about %s's bag updated", GreyHandling.NAME, sender))
	-- GreyHandling.functions.ExchangeMyJunkPlease(sender)
--	local fair = GreyHandling.functions.GetBestExchange()
	--if fair.itemGiven and fair.itemTaken then
	--	foundSomething = true
	--	local bag, slot = GreyHandling.functions.GetBagAndSlot(fair.itemGiven)
	--	if bag and slot then
	--		GreyHandling.functions.SetBagItemGlow(bag, slot, "bags-glow-green")
	--	end
	--	print(GreyHandling.functions.DisplayMutuallyBeneficialTradeInChat(fair))
	--end
	-- end
end