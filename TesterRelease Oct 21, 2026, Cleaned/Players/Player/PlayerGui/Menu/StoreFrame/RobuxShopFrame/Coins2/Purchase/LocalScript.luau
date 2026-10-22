function updatePrice()
    local price_in_robux = game:GetService("MarketplaceService")
        :GetProductInfo(script:GetAttribute("ProductInfo"), Enum.InfoType.Product).PriceInRobux
    script.Parent.Text = "BUY - R$" .. price_in_robux
end

updatePrice()

script.Parent.Parent.Parent.Parent.GiftRecipient.Changed:Connect(function()
    if script.Parent.Parent.Parent.Parent.GiftRecipient.Text == "" then
        updatePrice()

        return
    end

    updatePrice()
end)
