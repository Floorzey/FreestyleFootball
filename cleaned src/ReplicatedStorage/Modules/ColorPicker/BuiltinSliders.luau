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
local builtin_sliders = {}

function builtin_sliders.Transparency(self)
    local slider_2 = slider.new(self, "T", 4, 100)
    local gradient = slider_2.Instance:WaitForChild("Slider"):WaitForChild("Gradient")
    gradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
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
    slider_2.OnManualChange = function(transparency)
        self.Color.Transparency = transparency
        self:_updateColorVisuals()
    end
    slider_2.GetValue = function()
        return self.Color.Transparency or 0
    end
    slider_2.OnValueChanged = function()
        gradient.Color = ColorSequence.new(self:GetColor())
    end
    return slider_2
end

function builtin_sliders.Hue(self)
    local slider_2 = slider.new(self, "H", 1, 360)
    slider_2.Instance:WaitForChild("Slider"):WaitForChild("Gradient").Color = color_sequence
    slider_2.OnManualChange = function(hue)
        self.Color.Hue = hue
        self:_updateColorVisuals()
    end
    slider_2.GetValue = function()
        return self.Color.Hue or 0
    end
    return slider_2
end

function builtin_sliders.Saturation(self)
    local slider_2 = slider.new(self, "S", 2, 100)
    slider_2.OnManualChange = function(saturation)
        self.Color.Saturation = saturation
        self:_updateColorVisuals()
    end
    slider_2.GetValue = function()
        return self.Color.Saturation or 0
    end
    slider_2.OnValueChanged = function()
        local gradient = slider_2.Instance:WaitForChild("Slider"):WaitForChild("Gradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(self.Color.Hue, 1, self.Color.Value)),
        })
    end
    return slider_2
end

function builtin_sliders.Value(self)
    local slider_2 = slider.new(self, "V", 3, 100)
    slider_2.OnManualChange = function(value)
        self.Color.Value = value
        self:_updateColorVisuals()
    end
    slider_2.GetValue = function()
        return self.Color.Value or 0
    end
    slider_2.OnValueChanged = function()
        local gradient = slider_2.Instance:WaitForChild("Slider"):WaitForChild("Gradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(self.Color.Hue, self.Color.Saturation, 1)),
        })
    end
    return slider_2
end

function builtin_sliders.Red(self)
    local slider_2 = slider.new(self, "R", 1, 255)
    slider_2.OnManualChange = function(argument)
        local color = self:GetColor()
        local hue, saturation, value = Color3.new(argument, color.G, color.B):ToHSV()
        self.Color.Hue = hue
        self.Color.Saturation = saturation
        self.Color.Value = value
        self:_updateColorVisuals()
    end
    slider_2.GetValue = function()
        return self:GetColor().R or 0
    end
    slider_2.OnValueChanged = function()
        local color = self:GetColor()
        local g = color.G
        local b = color.B
        local gradient = slider_2.Instance:WaitForChild("Slider"):WaitForChild("Gradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(0, g, b)),
            ColorSequenceKeypoint.new(1, Color3.new(1, g, b)),
        })
    end
    return slider_2
end

function builtin_sliders.Green(self)
    local slider_2 = slider.new(self, "G", 2, 255)
    slider_2.OnManualChange = function(argument)
        local color = self:GetColor()
        local hue, saturation, value = Color3.new(color.R, argument, color.B):ToHSV()
        self.Color.Hue = hue
        self.Color.Saturation = saturation
        self.Color.Value = value
        self:_updateColorVisuals()
    end
    slider_2.GetValue = function()
        return self:GetColor().G or 0
    end
    slider_2.OnValueChanged = function()
        local color = self:GetColor()
        local r = color.R
        local b = color.B
        local gradient = slider_2.Instance:WaitForChild("Slider"):WaitForChild("Gradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(r, 0, b)),
            ColorSequenceKeypoint.new(1, Color3.new(r, 1, b)),
        })
    end
    return slider_2
end

function builtin_sliders.Blue(self)
    local slider_2 = slider.new(self, "B", 3, 255)
    slider_2.OnManualChange = function(argument)
        local color = self:GetColor()
        local hue, saturation, value = Color3.new(color.R, color.G, argument):ToHSV()
        self.Color.Hue = hue
        self.Color.Saturation = saturation
        self.Color.Value = value
        self:_updateColorVisuals()
    end
    slider_2.GetValue = function()
        return self:GetColor().B or 0
    end
    slider_2.OnValueChanged = function()
        local color = self:GetColor()
        local r = color.R
        local g = color.G
        local gradient = slider_2.Instance:WaitForChild("Slider"):WaitForChild("Gradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(r, g, 0)),
            ColorSequenceKeypoint.new(1, Color3.new(r, g, 1)),
        })
    end
    return slider_2
end

return builtin_sliders
