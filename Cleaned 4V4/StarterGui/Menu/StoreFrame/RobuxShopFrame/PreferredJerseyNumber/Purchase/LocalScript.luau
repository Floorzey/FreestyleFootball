function updatePrice(argument)
    if argument then
        script.Parent.Text = "BUY - R$"
            .. game:GetService("MarketplaceService")
                :GetProductInfo(script:GetAttribute("ProductInfo"), Enum.InfoType.Product).PriceInRobux
    else
        script.Parent.Text = "BUY - R$"
            .. game:GetService("MarketplaceService")
                :GetProductInfo(script:GetAttribute("GamePassInfo"), Enum.InfoType.GamePass).PriceInRobux
    end
end

updatePrice(false)

script.Parent.Parent.Parent.Parent.GiftRecipient.Changed:Connect(function()
    if script.Parent.Parent.Parent.Parent.GiftRecipient.Text == "" then
        updatePrice(false)
    else
        updatePrice(true)
    end
end)
