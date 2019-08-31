local A, GreyHandling = ...

function GreyHandling.testNumberLootedFromChatMessage()
    assert(14 == GreyHandling.functions.numberLootedFromChatMessage("你制造了：[魔法淡水]x14"), "Can't parse conjuring bread in chinese")
    assert (20 == GreyHandling.functions.numberLootedFromChatMessage("Vous créez：[Petit pain de manne invoqué] x20"), "Can't parse conjuring bread in french")
    assert (2 == GreyHandling.functions.numberLootedFromChatMessage("Vous recevez le butin ：[Viande séchée coriace] x2."), "Can't parse multi object loot in french")
    assert (1 == GreyHandling.functions.numberLootedFromChatMessage("Vous recevez le butin ：[Oeil de tigre]."), "Can't parse single object loot in french")
end

function GreyHandling.testMutuallyBeneficialExchange()
    local test_object_1 = "Dent plate émoussée"
    local test_object_2 = "Incisive dentelée"
    local test_object_3 = "Fourrure miteuse"
    GreyHandling.data.items["TestName-TestServer"] = {}
    GreyHandling.data.items["TestName-TestServer"][test_object_1] = {}
    GreyHandling.data.items["TestName-TestServer"][test_object_1]["itemStackCount"] = 100
    GreyHandling.data.items["TestName-TestServer"][test_object_1]["vendorPrice"] = 14699
    GreyHandling.data.items["TestName-TestServer"][test_object_1]["number"] = 12
    GreyHandling.data.items["TestName-TestServer"][test_object_2] = {}
    GreyHandling.data.items["TestName-TestServer"][test_object_2]["itemStackCount"] = 20
    GreyHandling.data.items["TestName-TestServer"][test_object_2]["vendorPrice"] = 12685
    GreyHandling.data.items["TestName-TestServer"][test_object_2]["number"] = 5
    GreyHandling.data.items["TestName-TestServer"][test_object_3] = {}
    GreyHandling.data.items["TestName-TestServer"][test_object_3]["itemStackCount"] = 20
    GreyHandling.data.items["TestName-TestServer"][test_object_3]["vendorPrice"] = 2932
    GreyHandling.data.items["TestName-TestServer"][test_object_3]["number"] = 1
end

function GreyHandling.testHandleChatLootMessageFrench()
    -- Signature : GreyHandling.functions.handleChatMessageLoot(chat_message, player_name, line_number, player_id, k, l, m, n, o)
    local _, oeilDeTigreLink = GetItemInfo("Oeil de tigre")
    GreyHandling.functions.handleChatMessageLoot("Vous recevez le butin : [Oeil de tigre].", "TestOtherName-TestOtherServer", 120, "PlayerID1AEBCFEE1123123")
    GreyHandling.functions.handleChatMessageLoot("TestName-TestServer reçoit le butin : [Oeil de tigre] x2.", "TestName-TestServer", 121, "PlayerID2AEBCFE1123124")
    assert (1 == GreyHandling.data.items["TestOtherName-TestOtherServer"][oeilDeTigreLink].number)
    assert (2 == GreyHandling.data.items["TestName-TestServer"][oeilDeTigreLink]["number"])
end

function GreyHandling.testHandleChatLootMessageChinese()
    -- Signature : GreyHandling.functions.handleChatMessageLoot(chat_message, player_name, line_number, player_id, k, l, m, n, o)
    local _, mageWater = GetItemInfo("魔法淡水") -- Conjured Fresh Water
    GreyHandling.functions.handleChatMessageLoot("你制造了：[魔法淡水]x14", "TestOtherName-TestOtherServer", 122, nil)
    assert (14 == GreyHandling.data.items["TestOtherName-TestOtherServer"][mageWater]["number"])
end

function GreyHandling.allTests()
    GreyHandling.data = {}
    GreyHandling.data.items = {}
    print("Testing NumberLootedFromChatMessage...")
    GreyHandling.testNumberLootedFromChatMessage()
    print("Testing MutuallyBeneficialExchange...")
    GreyHandling.testMutuallyBeneficialExchange()
    print("Testing HandleChatLootMessage in French...")
    GreyHandling.testHandleChatLootMessageFrench()
    -- print("Testing HandleChatLootMessage in Chinese...")
    -- GreyHandling.testHandleChatLootMessageChinese()
end
