local A, GreyHandling = ...

if IsAddOnLoaded("ArkInventory") or IsAddOnLoaded("ArkInventoryClassic") then
    hooksecurefunc(ArkInventory.API, "ItemFrameUpdated", GreyHandling.functions.AISetBagItemGlow)


end
