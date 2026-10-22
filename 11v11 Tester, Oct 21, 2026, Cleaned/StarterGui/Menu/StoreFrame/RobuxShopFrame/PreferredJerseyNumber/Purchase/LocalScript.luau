function updatePrice(argument)
    if argument then
        local price_in_robux = game:GetService("MarketplaceService")
            :GetProductInfo(script:GetAttribute("ProductInfo"), Enum.InfoType.Product).PriceInRobux
        script.Parent.Text = "BUY - R$" .. price_in_robux

        return
    end

    local price_in_robux_2 = game:GetService("MarketplaceService")
        :GetProductInfo(script:GetAttribute("GamePassInfo"), Enum.InfoType.GamePass).PriceInRobux
    script.Parent.Text = "BUY - R$" .. price_in_robux_2
end

updatePrice(false)

script.Parent.Parent.Parent.Parent.GiftRecipient.Changed:Connect(function()
    if script.Parent.Parent.Parent.Parent.GiftRecipient.Text == "" then
        updatePrice(false)

        return
    end

    updatePrice(true)
end)
