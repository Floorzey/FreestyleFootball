--[[
    Script Path: Game/StarterGui/Menu/StoreFrame/RobuxShopFrame/PreferredJerseyNumber/Purchase/LocalScript
    Class: LocalScript
    Time: 2026-10-03 12:27:08
--]]

function updatePrice(a1)
    --[[
      name: updatePrice
      line: 1
    ]]
    if a1 then
        script.Parent.Text = "BUY - R$" .. game:GetService("MarketplaceService"):GetProductInfo(script:GetAttribute("ProductInfo"), Enum.InfoType.Product).PriceInRobux
    else
        script.Parent.Text = "BUY - R$" .. game:GetService("MarketplaceService"):GetProductInfo(script:GetAttribute("GamePassInfo"), Enum.InfoType.GamePass).PriceInRobux
    end
end
updatePrice(false)
script.Parent.Parent.Parent.Parent.GiftRecipient.Changed:Connect(
    function()
        --[[
          line: 15
        ]]
        if script.Parent.Parent.Parent.Parent.GiftRecipient.Text == "" then
            updatePrice(false)
        else
            updatePrice(true)
        end
    end
)