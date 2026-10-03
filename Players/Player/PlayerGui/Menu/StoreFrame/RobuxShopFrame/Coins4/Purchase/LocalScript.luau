--[[
    Script Path: Game/Players/Player/PlayerGui/Menu/StoreFrame/RobuxShopFrame/Coins4/Purchase/LocalScript
    Class: LocalScript
    Time: 2026-10-03 12:27:03
--]]

function updatePrice()
    --[[
      name: updatePrice
      line: 1
    ]]
    script.Parent.Text = "BUY - R$" .. game:GetService("MarketplaceService"):GetProductInfo(script:GetAttribute("ProductInfo"), Enum.InfoType.Product).PriceInRobux
end
updatePrice()
script.Parent.Parent.Parent.Parent.GiftRecipient.Changed:Connect(
    function()
        --[[
          line: 9
        ]]
        updatePrice()
    end
)