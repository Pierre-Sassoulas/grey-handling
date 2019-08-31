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
    GreyHandling.data.names["PlayerID1AEBCFE1123123"] = "TestName-TestServer"
    GreyHandling.data.items["PlayerID1AEBCFE1123123"] = {}
    GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_1] = {}
    GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_1]["itemStackCount"] = 100
    GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_1]["vendorPrice"] = 14699
    GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_1]["number"] = 12
    GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_2] = {}
    GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_2]["itemStackCount"] = 20
    GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_2]["vendorPrice"] = 12685
    GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_2]["number"] = 5
    GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_3] = {}
    GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_3]["itemStackCount"] = 20
    GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_3]["vendorPrice"] = 2932
    GreyHandling.data.items["PlayerID1AEBCFE1123123"][test_object_3]["number"] = 1
end

function GreyHandling.testHandleChatLootMessage()

end

function GreyHandling.allTests()
    print("Testing NumberLootedFromChatMessage...")
    GreyHandling.testNumberLootedFromChatMessage()
    print("Testing MutuallyBeneficialExchange...")
    GreyHandling.testMutuallyBeneficialExchange()
end


