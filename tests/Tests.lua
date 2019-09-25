local A, GreyHandling = ...

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
    -- GreyHandling.db.addItemForPlayer(playerName, itemLink, vendorPrice, itemStackCount, number)
    GreyHandling.db.addItemForPlayer("TestName-TestServer", "Dent plate émoussée", 14699, 100, 12)
    GreyHandling.db.addItemForPlayer("TestName-TestServer", "Incisive dentelée", 12685, 20, 5)
    GreyHandling.db.addItemForPlayer("TestName-TestServer", "Fourrure miteuse", 2932, 20, 1)
    GreyHandling.db.addItemForPlayer("OtherName-TestServer", "Cuir léger", 300, 20, 164)
    GreyHandling.db.addItemForPlayer("TestName-TestServer", "Cuir moyen", 300, 20, 1224)
    GreyHandling.db.addItemForPlayer("TestName-TestServer", "Cuir lourd", 150, 20, 119)
    GreyHandling.db.addItemForPlayer("TestName-TestServer", "Cuir épais", 300, 20, 219)
    GreyHandling.db.addItemForPlayer("TestName-TestServer", "Cuir lourd", 150, 20, 119)
    GreyHandling.db.addItemForPlayer("TestName-TestServer", "Peau de raptor", 208, 10, 119)
    GreyHandling.db.addItemForPlayer("TestName-TestServer", "Bec acéré", 804, 5, 3)
    GreyHandling.db.addItemForPlayer("OtherName-TestServer", "Serre de busard", 71, 5, 9)
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
    local vendorPrice = 100 -- does'nt matter either
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
    -- GreyHandling.db.reset()
    GreyHandling.print("Testing NumberLootedFromChatMessage...")
    GreyHandling.testNumberLootedFromChatMessage()
    GreyHandling.print("Testing IsLootCouncilMessage...")
    GreyHandling.testIsLootCouncilMessage()
    GreyHandling.print("Testing MutuallyBeneficialExchange...")
    GreyHandling.testMutuallyBeneficialExchange()
    GreyHandling.print("Testing CreateExchange...")
    GreyHandling.testCreateExchange()
    GreyHandling.print("Testing BestExchange...")
    GreyHandling.testBestExchange()
    --print("Testing HandleChatLootMessage in French...")
    --GreyHandling.testHandleChatLootMessageFrench()
    --print("Testing HandleChatLootMessage in Chinese...")
    --GreyHandling.testHandleChatLootMessageChinese()
    GreyHandling.print("Test succesfful if there was only messages started by testing!")
end
