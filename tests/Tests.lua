local A, GreyHandling = ...

function GreyHandling.checkAPI()
    local n_ok, n_missing = 0, 0
    local function check(label, value)
        if value ~= nil then
            n_ok = n_ok + 1
        else
            n_missing = n_missing + 1
            GreyHandling.print("|cffff4d4d[MISSING]|r " .. label)
        end
    end
    local function checkGroup(label, func)
        if func == nil then
            n_missing = n_missing + 1
            GreyHandling.print("|cffff4d4d[GROUP-MISSING]|r " .. label)
        else
            n_ok = n_ok + 1
            GreyHandling.print("|cffffff00[GROUP]|r " .. label .. " = " .. tostring(func()))
        end
    end

    GreyHandling.print("=== API Check ===")

    -- Aliased globals (removed from global namespace in retail)
    check("GetItemInfo",               GetItemInfo)
    check("GetCoinTextureString",       GetCoinTextureString)
    check("GetItemQualityColor",        GetItemQualityColor)
    check("GetContainerNumSlots",       GetContainerNumSlots)
    check("GetContainerNumFreeSlots",   GetContainerNumFreeSlots)
    check("GetContainerItemID",         GetContainerItemID)
    check("GetContainerItemDurability", GetContainerItemDurability)
    check("GetAddOnMetadata",           GetAddOnMetadata)
    check("IsAddOnLoaded",              IsAddOnLoaded)

    -- C_ APIs backing the aliases
    check("C_Item.GetItemInfo",                C_Item and C_Item.GetItemInfo)
    check("C_CurrencyInfo.GetCoinTextureString", C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString)
    check("C_AddOns.GetAddOnMetadata",         C_AddOns and C_AddOns.GetAddOnMetadata)
    check("C_AddOns.IsAddOnLoaded",            C_AddOns and C_AddOns.IsAddOnLoaded)

    -- C_Container (used both via alias and directly)
    check("C_Container.GetContainerNumSlots",       C_Container and C_Container.GetContainerNumSlots)
    check("C_Container.GetContainerNumFreeSlots",   C_Container and C_Container.GetContainerNumFreeSlots)
    check("C_Container.GetContainerItemID",         C_Container and C_Container.GetContainerItemID)
    check("C_Container.GetContainerItemDurability", C_Container and C_Container.GetContainerItemDurability)
    check("C_Container.GetContainerItemInfo",       C_Container and C_Container.GetContainerItemInfo)
    check("C_Container.GetContainerItemLink",       C_Container and C_Container.GetContainerItemLink)

    -- Chat / timer
    check("C_ChatInfo.RegisterAddonMessagePrefix", C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix)
    check("C_ChatInfo.SendAddonMessage",           C_ChatInfo and C_ChatInfo.SendAddonMessage)
    check("C_Timer.After",                         C_Timer and C_Timer.After)

    -- Tooltip
    check("TooltipDataProcessor",                       TooltipDataProcessor)
    check("TooltipDataProcessor.AddTooltipPostCall",    TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall)
    check("TooltipUtil.GetDisplayedItem",               TooltipUtil and TooltipUtil.GetDisplayedItem)
    check("SetTooltipMoney",                            SetTooltipMoney)
    check("GameTooltip.SetLootItem",                    GameTooltip and GameTooltip.SetLootItem)

    -- Loot & UI
    check("GetLootSlotLink",                        GetLootSlotLink)
    check("GetLootSlotInfo",                        GetLootSlotInfo)
    check("OpenAllBags",                            OpenAllBags)
    check("CloseAllBags",                           CloseAllBags)
    check("GetMouseFocus",                          GetMouseFocus)
    check("Settings.RegisterCanvasLayoutCategory",  Settings and Settings.RegisterCanvasLayoutCategory)
    check("Settings.RegisterAddOnCategory",         Settings and Settings.RegisterAddOnCategory)

    -- Constants / tables
    check("NUM_BAG_SLOTS",         NUM_BAG_SLOTS)
    check("SELL_PRICE",            SELL_PRICE)
    check("ITEM_QUALITY_COLORS[0]", ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[0])
    check("LE_ITEM_CLASS_WEAPON",  LE_ITEM_CLASS_WEAPON)
    check("LE_ITEM_CLASS_ARMOR",   LE_ITEM_CLASS_ARMOR)
    check("LE_ITEM_ARMOR_GENERIC", LE_ITEM_ARMOR_GENERIC)

    -- Group APIs: check existence and show solo return value
    checkGroup("GetNumGroupMembers()", GetNumGroupMembers)
    checkGroup("IsInGroup()",          IsInGroup)
    checkGroup("IsInRaid()",           IsInRaid)
    check("GetRaidRosterInfo",         GetRaidRosterInfo)

    local total = n_ok + n_missing
    if n_missing == 0 then
        GreyHandling.print(format("|cff00ff00API check: %d/%d OK|r", n_ok, total))
    else
        GreyHandling.print(format("|cffff4d4dAPI check: %d/%d OK, %d MISSING (see above)|r", n_ok, total, n_missing))
    end
end

function GreyHandling.testNumberLootedFromChatMessage()
    assert(14 == GreyHandling.functions.numberLootedFromChatMessage("你制造了：[魔法淡水]x14"), "Can't parse conjuring bread in chinese")
    assert (20 == GreyHandling.functions.numberLootedFromChatMessage("Vous créez：[Petit pain de manne invoqué] x20"), "Can't parse conjuring bread in french")
    assert (2 == GreyHandling.functions.numberLootedFromChatMessage("Vous recevez le butin ：[Viande séchée coriace] x2."), "Can't parse multi object loot in french")
    assert (1 == GreyHandling.functions.numberLootedFromChatMessage("Vous recevez le butin ：[Oeil de tigre]."), "Can't parse single object loot in french")
    assert (1 == GreyHandling.functions.numberLootedFromChatMessage("Ваша добыча: [Медная руда]."), "Can't parse single object loot in russian")
    assert (1 == GreyHandling.functions.numberLootedFromChatMessage("Вы получаете предмет: [Мушкет капера]."), "Can't parse single quest object loot in russian")
    assert (3 == GreyHandling.functions.numberLootedFromChatMessage("Фогги получает добычу: [Синячник]x3."), "Can't parse multi object loot in russian")
    assert (1 == GreyHandling.functions.numberLootedFromChatMessage("Ваша добыча: [Маленькая блестящая жемчужина]."), "Can't parse object looted from roll in russian")
end

function GreyHandling.testIsLootCouncilMessage()
    assert (GreyHandling.functions.isLootCouncilMessage("[Butin] Vous avez choisi cupidité pour ：[Oeil de tigre]."), "Can't parse loot council in french")
    assert (GreyHandling.functions.isLootCouncilMessage("[Butin] Vous avez choisi cupidité pour ：[Oeil de tigre]."), "Can't parse loot council in french")
    assert (GreyHandling.functions.isLootCouncilMessage("[Butin] : Jet de cupidite 36 pour ：[Oeil de tigre] par Lonistar."), "Can't parse loot council in french")
    assert (GreyHandling.functions.isLootCouncilMessage("[Butin] : Bachin a gagné ：[Oeil de tigre]."), "Can't parse loot council in french")
    assert (not GreyHandling.functions.isLootCouncilMessage("Vous créez：[Petit pain de manne invoqué] x20."), "Detect loot council for no reason in french")
    assert (not GreyHandling.functions.isLootCouncilMessage("Vous recevez le butin ：[Oeil de tigre]."), "Detect loot council for no reason in french")
end

function GreyHandling.testMutuallyBeneficialExchange()
    -- GreyHandling.db.addItemFromStringForPlayer(playerName, itemString, vendorPrice, itemStackCount, number)
    GreyHandling.db.addItemFromStringForPlayer("TestName-TestServer", "Dent plate émoussée", 14699, 100, 12)
    GreyHandling.db.addItemFromStringForPlayer("TestName-TestServer", "Incisive dentelée", 12685, 20, 5)
    GreyHandling.db.addItemFromStringForPlayer("TestName-TestServer", "Fourrure miteuse", 2932, 20, 1)
    GreyHandling.db.addItemFromStringForPlayer("OtherName-TestServer", "Cuir léger", 300, 20, 164)
    GreyHandling.db.addItemFromStringForPlayer("TestName-TestServer", "Cuir moyen", 300, 20, 1224)
    GreyHandling.db.addItemFromStringForPlayer("TestName-TestServer", "Cuir lourd", 150, 20, 119)
    GreyHandling.db.addItemFromStringForPlayer("TestName-TestServer", "Cuir épais", 300, 20, 219)
    GreyHandling.db.addItemFromStringForPlayer("OtherName-TestServer", "Morue Rochécaille crue", 150, 20, 119)
    GreyHandling.db.addItemFromStringForPlayer("TestName-TestServer", "Cuir robuste", 500, 20, 259)
    GreyHandling.db.addItemFromStringForPlayer("TestName-TestServer", "Peau de raptor", 208, 10, 119)
    GreyHandling.db.addItemFromStringForPlayer("TestName-TestServer", "Dorépine", 500, 20, 259)
    GreyHandling.db.addItemFromStringForPlayer("TestName-TestServer", "Fleur de feu", 500, 20, 259)
    GreyHandling.db.addItemFromStringForPlayer("TestName-TestServer", "Bec acéré", 804, 5, 3)
    GreyHandling.db.addItemFromStringForPlayer("OtherName-TestServer", "Serre de busard", 71, 5, 9)
end

function GreyHandling.testHandleChatLootMessageFrench()
    -- Signature : GreyHandling.functions.handleChatMessageLoot(chat_message, player_name, line_number, player_id, k, l, m, n, o)
    local itemLinkText =  "|cff9d9d9d|Hitem:3299::::::::20:257::::::|h[Fractured Canine]|h|r"
    local _, ItemLink = GetItemInfo(itemLinkText)
    GreyHandling.functions.handleChatMessageLoot(format("Vous recevez le butin : %s.", "TestOtherName-TestOtherServer", itemLinkText), 120, "PlayerID1AEBCFEE1123123")
    GreyHandling.functions.handleChatMessageLoot(format("TestName-TestServer reçoit le butin : %s x2.", itemLinkText), "TestName-TestServer", 121, "PlayerID2AEBCFE1123124")
    GreyHandling.functions.handleChatMessageLoot(format("[Butin] Vous avez choisi cupidité pour ：%s.", itemLinkText), "TestOtherName-TestOtherServer", 125, "PlayerID1AEBCFEE1123123")
    assert (1 == GreyHandling.db.getItemInfoForPlayer("TestOtherName-TestOtherServer", ItemLink, "number"))
    assert (2 == GreyHandling.db.getItemInfoForPlayer("TestName-TestServer", ItemLink, "number"))
end

function GreyHandling.testCreateExchange()
    -- Signature : GreyHandling.functions.CreateExchange(itemLink, ourCount, theirCount, vendorPrice, itemStackCount)
    local exchange = {}
    local itemLink = "DoesNotMatter"
    local vendorPrice = 100 -- doesn't matter either
    local itemStackCount = 20
    exchange = GreyHandling.functions.CreateExchange(itemLink, 5, 2, vendorPrice, itemStackCount)
    assert (exchange.isPerfect)
    assert (exchange.lossCount == 0)
    exchange = GreyHandling.functions.CreateExchange(itemLink, 15, 7, vendorPrice, itemStackCount)
    assert (not exchange.isPerfect)
    assert (exchange.lossCount == 2)
    exchange = GreyHandling.functions.CreateExchange(itemLink, 165, 222, vendorPrice, itemStackCount)
    assert (exchange.isPerfect)
    assert (exchange.lossCount == 0)
    exchange = GreyHandling.functions.CreateExchange(itemLink, 215, 207, vendorPrice, itemStackCount)
    assert (not exchange.isPerfect)
    assert (exchange.lossCount == 2)
    exchange = GreyHandling.functions.CreateExchange(itemLink, 19, 19, vendorPrice, itemStackCount)
    assert (not exchange.isPerfect)
    assert (exchange.lossCount == 18)
end

function GreyHandling.testBestExchange()
    -- Signature : function GreyHandling.functions.getBestExchange(bestExchange, player_id, itemGiven, givenValues, itemTaken, takenValues)
    -- itemX : itemLink
    -- values : {
    --		item = itemLink,
    --		vendorPrice = vendorPrice,
    --		ourCount = ourCount,
    --		theirCount = theirCount,
    --		lossCount = lossCount,
    --		isPerfect = isPerfect
    --	}
    local player_id = "DoesNotMatter-ServerName"
    local bestExchange = {greyHandlingGain=nil, isPerfect=false }
    local itemGiven = "item1"
    local itemTaken = "item2"
    local itemGivenValues = {
        item = itemGiven,
        vendorPrice = 100,
        ourCount = 10,
        theirCount = 10,
        lossCount = 0,
        isPerfect = true
    }
    local itemTakenValues = {
        item = itemTaken,
        vendorPrice = 100,
        ourCount = 10,
        theirCount = 10,
        lossCount = 0,
        isPerfect = true
    }
    assert (not bestExchange.isPerfect)
    assert (not bestExchange.greyHandlingGain)
    bestExchange = GreyHandling.functions.getBestExchange(bestExchange, player_id, itemGivenValues, itemTakenValues)
    -- assert (bestExchange.lossCount == 0)
    assert (bestExchange.itemGiven == itemGiven)
    assert (bestExchange.itemTaken == itemTaken)
    local betterItemGiven = "item3"
    -- If more value is exchanged the exchange is better
    local betterItemGivenValues = {
        item = betterItemGiven,
        vendorPrice = 1000,
        ourCount = 10,
        theirCount = 10,
        lossCount = 0,
        isPerfect = true
    }
    bestExchange = GreyHandling.functions.getBestExchange(bestExchange, player_id, betterItemGivenValues, itemTakenValues)
    assert (bestExchange.itemGiven == betterItemGiven)
    assert (bestExchange.itemTaken == itemTaken)
    local betterItemTaken = "item4"
    local betterItemTakenValues = {
        item = betterItemTaken,
        vendorPrice = 1000,
        ourCount = 10,
        theirCount = 10,
        lossCount = 0,
        isPerfect = true
    }
    bestExchange = GreyHandling.functions.getBestExchange(bestExchange, player_id, betterItemGivenValues, betterItemTakenValues)
    assert (bestExchange.itemGiven == betterItemGiven)
    assert (bestExchange.itemTaken == betterItemTaken)
end


function GreyHandling.testHandleChatLootMessageChinese()
    -- Signature : GreyHandling.functions.handleChatMessageLoot(chat_message, player_name, line_number, player_id, k, l, m, n, o)
    local _, mageWater = GetItemInfo("魔法淡水") -- Conjured Fresh Water
    GreyHandling.functions.handleChatMessageLoot("你制造了：[魔法淡水]x14", "TestOtherName-TestOtherServer", 122, nil)
    assert (14 == GreyHandling.db.getItemInfoForPlayer("TestOtherName-TestOtherServer", mageWater, "number"))
end

function GreyHandling.allTests()
    GreyHandling.print(format("WARNING! You're using the development version, the data store is reset for test case"))
    -- GreyHandling.checkAPI()  -- uncomment to audit the WoW API surface
    -- GreyHandling.db.reset()
    GreyHandling.testMutuallyBeneficialExchange()
    if GreyHandling.DEV_TRADE_ONLY then
        GreyHandling.print("We populated a fake database of item for your fake group.")
        return
    end
    GreyHandling.print("Testing NumberLootedFromChatMessage...")
    GreyHandling.testNumberLootedFromChatMessage()
    GreyHandling.print("Testing IsLootCouncilMessage...")
    GreyHandling.testIsLootCouncilMessage()
    GreyHandling.print("Testing CreateExchange...")
    GreyHandling.testCreateExchange()
    GreyHandling.print("Testing BestExchange...")
    GreyHandling.testBestExchange()
    --print("Testing HandleChatLootMessage in French...")
    --GreyHandling.testHandleChatLootMessageFrench()
    --print("Testing HandleChatLootMessage in Chinese...")
    --GreyHandling.testHandleChatLootMessageChinese()
    GreyHandling.print("Test successful if there was only messages started by testing!")
end
