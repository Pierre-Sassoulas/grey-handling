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

function GreyHandling.testHandleChatLootMessageChinese()
    -- Signature : GreyHandling.functions.handleChatMessageLoot(chat_message, player_name, line_number, player_id, k, l, m, n, o)
    local _, mageWater = GetItemInfo("魔法淡水") -- Conjured Fresh Water
    GreyHandling.functions.handleChatMessageLoot("你制造了：[魔法淡水]x14", "TestOtherName-TestOtherServer", 122, nil)
    assert (14 == GreyHandling.db.getItemInfoForPlayer("TestOtherName-TestOtherServer", mageWater, "number"))
end

function GreyHandling.allTests()
    print(format("%s: WARNING! You're using the development version, the data store is reset for test case", GreyHandling.NAME))
    -- GreyHandling.db.reset()
    print("Testing NumberLootedFromChatMessage...")
    GreyHandling.testNumberLootedFromChatMessage()
    print("Testing IsLootCouncilMessage...")
    GreyHandling.testIsLootCouncilMessage()
    print("Testing MutuallyBeneficialExchange...")
    GreyHandling.testMutuallyBeneficialExchange()
    --print("Testing HandleChatLootMessage in French...")
    --GreyHandling.testHandleChatLootMessageFrench()
    --print("Testing HandleChatLootMessage in Chinese...")
    --GreyHandling.testHandleChatLootMessageChinese()
    print("Test succesfful if there was only messages started by testing!")
end
