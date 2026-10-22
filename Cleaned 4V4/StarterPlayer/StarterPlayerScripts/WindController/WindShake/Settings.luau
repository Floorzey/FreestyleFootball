local settings = {}

function settings.new(argument, argument_2)
    local create_result = table.create(3)
    local wind_power = argument:GetAttribute("WindPower")
    local wind_speed = argument:GetAttribute("WindSpeed")
    local wind_direction = argument:GetAttribute("WindDirection")
    create_result.WindPower = typeof(wind_power) == "number" and wind_power or argument_2.WindPower
    create_result.WindSpeed = typeof(wind_speed) == "number" and wind_speed or argument_2.WindSpeed
    create_result.WindDirection = typeof(wind_direction) == "Vector3" and wind_direction or argument_2.WindDirection
    local connection = argument:GetAttributeChangedSignal("WindPower"):Connect(function()
        wind_power = argument:GetAttribute("WindPower")
        create_result.WindPower = typeof(wind_power) == "number" and wind_power or argument_2.WindPower
    end)
    local connection_2 = argument:GetAttributeChangedSignal("WindSpeed"):Connect(function()
        wind_speed = argument:GetAttribute("WindSpeed")
        create_result.WindSpeed = typeof(wind_speed) == "number" and wind_speed or argument_2.WindSpeed
    end)
    local connection_3 = argument:GetAttributeChangedSignal("WindDirection"):Connect(function()
        wind_direction = argument:GetAttribute("WindDirection")
        create_result.WindDirection = typeof(wind_direction) == "Vector3" and wind_direction or argument_2.WindDirection
    end)

    function create_result.Destroy(argument_3)
        connection:Disconnect()
        connection_2:Disconnect()
        connection_3:Disconnect()
        table.clear(create_result)
    end

    return create_result
end

return settings
