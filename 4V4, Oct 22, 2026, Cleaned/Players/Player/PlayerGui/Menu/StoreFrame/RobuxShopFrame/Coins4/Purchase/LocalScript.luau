function updatePrice()
    script.Parent.Text = "BUY - R$"
        .. game:GetService("MarketplaceService")
            :GetProductInfo(script:GetAttribute("ProductInfo"), Enum.InfoType.Product).PriceInRobux
end

updatePrice()

script.Parent.Parent.Parent.Parent.GiftRecipient.Changed:Connect(function()
    updatePrice()
end)
