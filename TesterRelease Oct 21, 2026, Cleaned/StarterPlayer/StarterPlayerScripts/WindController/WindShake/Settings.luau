return {
    new = function(argument, argument_2)
        local create_result = table.create(3)
        local attribute = argument:GetAttribute("WindPower")
        local attribute2 = argument:GetAttribute("WindSpeed")
        local attribute3 = argument:GetAttribute("WindDirection")
        create_result.WindPower = typeof(attribute) == "number" and attribute or argument_2.WindPower
        create_result.WindSpeed = typeof(attribute2) == "number" and attribute2 or argument_2.WindSpeed
        create_result.WindDirection = typeof(attribute3) == "Vector3" and attribute3 or argument_2.WindDirection
        local connection = argument:GetAttributeChangedSignal("WindPower"):Connect(function()
            attribute = argument:GetAttribute("WindPower")
            create_result.WindPower = typeof(attribute) == "number" and attribute or argument_2.WindPower
        end)
        local connection_2 = argument:GetAttributeChangedSignal("WindSpeed"):Connect(function()
            attribute2 = argument:GetAttribute("WindSpeed")
            create_result.WindSpeed = typeof(attribute2) == "number" and attribute2 or argument_2.WindSpeed
        end)
        local connection_3 = argument:GetAttributeChangedSignal("WindDirection"):Connect(function()
            attribute3 = argument:GetAttribute("WindDirection")
            create_result.WindDirection = typeof(attribute3) == "Vector3" and attribute3 or argument_2.WindDirection
        end)

        function create_result.Destroy(argument_3)
            connection:Disconnect()
            connection_2:Disconnect()
            connection_3:Disconnect()
            table.clear(create_result)
        end

        return create_result
    end,
}
