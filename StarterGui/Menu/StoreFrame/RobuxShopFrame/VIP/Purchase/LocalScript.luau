--[[
    Script Path: Game/StarterGui/Menu/StoreFrame/RobuxShopFrame/VIP/Purchase/LocalScript
    Class: LocalScript
    Time: 2026-10-03 12:27:08
--]]

script.Parent.MouseButton1Down:Connect(
    function()
        --[[
          line: 1
        ]]
        game.MarketplaceService:PromptSubscriptionPurchase(game.Players.LocalPlayer, "EXP-197894242469413369")
    end
)