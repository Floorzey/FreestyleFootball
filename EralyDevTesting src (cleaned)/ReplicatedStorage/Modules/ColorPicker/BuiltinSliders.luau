local slider = require(script.Parent:WaitForChild("Slider"))
local color_sequence = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.16666666666666666, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.3333333333333333, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.6666666666666666, Color3.fromRGB(0, 0, 255)),
    ColorSequenceKeypoint.new(0.8333333333333334, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
})

return {
    Transparency = function(argument)
        local slider_2 = slider.new(argument, "T", 4, 100)
        local gradient = slider_2.Instance:WaitForChild("Slider"):WaitForChild("Gradient")
        gradient.Transparency =
            NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
        local image_label = Instance.new("ImageLabel")
        image_label.BackgroundTransparency = 1
        image_label.Position = UDim2.fromOffset(4, 4)
        image_label.Size = UDim2.new(0, 165, 1, -8)
        image_label.Image = "rbxassetid://111137375763311"
        image_label.ImageTransparency = 0.5
        image_label.ScaleType = Enum.ScaleType.Tile
        image_label.TileSize = UDim2.fromOffset(10, 10)
        image_label.ZIndex = -1
        local ui_corner = Instance.new("UICorner")
        ui_corner.CornerRadius = UDim.new(0.5, 0)
        ui_corner.Parent = image_label
        image_label.Parent = slider_2.Instance

        function slider_2.OnManualChange(transparency)
            argument.Color.Transparency = transparency
            argument:_updateColorVisuals()
        end

        function slider_2.GetValue()
            return argument.Color.Transparency or 0
        end

        function slider_2.OnValueChanged()
            gradient.Color = ColorSequence.new(argument:GetColor())
        end

        return slider_2
    end,

    Hue = function(argument)
        local slider_2 = slider.new(argument, "H", 1, 360)
        slider_2.Instance:WaitForChild("Slider"):WaitForChild("Gradient").Color = color_sequence

        function slider_2.OnManualChange(hue)
            argument.Color.Hue = hue
            argument:_updateColorVisuals()
        end

        function slider_2.GetValue()
            return argument.Color.Hue or 0
        end

        return slider_2
    end,

    Saturation = function(argument)
        local slider_2 = slider.new(argument, "S", 2, 100)

        function slider_2.OnManualChange(saturation)
            argument.Color.Saturation = saturation
            argument:_updateColorVisuals()
        end

        function slider_2.GetValue()
            return argument.Color.Saturation or 0
        end

        function slider_2.OnValueChanged()
            local hue = argument.Color.Hue
            local _ = argument.Color.Saturation
            local value = argument.Color.Value
            slider_2.Instance:WaitForChild("Slider"):WaitForChild("Gradient").Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, 1, value)),
            })
        end

        return slider_2
    end,

    Value = function(argument)
        local slider_2 = slider.new(argument, "V", 3, 100)

        function slider_2.OnManualChange(value)
            argument.Color.Value = value
            argument:_updateColorVisuals()
        end

        function slider_2.GetValue()
            return argument.Color.Value or 0
        end

        function slider_2.OnValueChanged()
            local hue = argument.Color.Hue
            local saturation = argument.Color.Saturation
            local _ = argument.Color.Value
            slider_2.Instance:WaitForChild("Slider"):WaitForChild("Gradient").Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, saturation, 1)),
            })
        end

        return slider_2
    end,

    Red = function(argument)
        local slider_2 = slider.new(argument, "R", 1, 255)

        function slider_2.OnManualChange(argument_2)
            local color = argument:GetColor()
            local color2 = argument.Color
            local color4 = argument.Color
            local color5 = argument.Color
            local hue, saturation, value = Color3.new(argument_2, color.G, color.B):ToHSV()
            color2.Hue = hue
            color4.Saturation = saturation
            color5.Value = value
            argument:_updateColorVisuals()
        end

        function slider_2.GetValue()
            return argument:GetColor().R or 0
        end

        function slider_2.OnValueChanged()
            local color = argument:GetColor()
            local g = color.G
            local b = color.B
            slider_2.Instance:WaitForChild("Slider"):WaitForChild("Gradient").Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(0, g, b)),
                ColorSequenceKeypoint.new(1, Color3.new(1, g, b)),
            })
        end

        return slider_2
    end,

    Green = function(argument)
        local slider_2 = slider.new(argument, "G", 2, 255)

        function slider_2.OnManualChange(argument_2)
            local color = argument:GetColor()
            local color2 = argument.Color
            local color4 = argument.Color
            local color5 = argument.Color
            local hue, saturation, value = Color3.new(color.R, argument_2, color.B):ToHSV()
            color2.Hue = hue
            color4.Saturation = saturation
            color5.Value = value
            argument:_updateColorVisuals()
        end

        function slider_2.GetValue()
            return argument:GetColor().G or 0
        end

        function slider_2.OnValueChanged()
            local color = argument:GetColor()
            local r = color.R
            local b = color.B
            slider_2.Instance:WaitForChild("Slider"):WaitForChild("Gradient").Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(r, 0, b)),
                ColorSequenceKeypoint.new(1, Color3.new(r, 1, b)),
            })
        end

        return slider_2
    end,

    Blue = function(argument)
        local slider_2 = slider.new(argument, "B", 3, 255)

        function slider_2.OnManualChange(argument_2)
            local color = argument:GetColor()
            local color2 = argument.Color
            local color4 = argument.Color
            local color5 = argument.Color
            local hue, saturation, value = Color3.new(color.R, color.G, argument_2):ToHSV()
            color2.Hue = hue
            color4.Saturation = saturation
            color5.Value = value
            argument:_updateColorVisuals()
        end

        function slider_2.GetValue()
            return argument:GetColor().B or 0
        end

        function slider_2.OnValueChanged()
            local color = argument:GetColor()
            local r = color.R
            local g = color.G
            slider_2.Instance:WaitForChild("Slider"):WaitForChild("Gradient").Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(r, g, 0)),
                ColorSequenceKeypoint.new(1, Color3.new(r, g, 1)),
            })
        end

        return slider_2
    end,
}
