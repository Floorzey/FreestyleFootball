local square = {}
square.__index = square

function square.new(color_picker)
    local instance = setmetatable({}, square)
    instance.ColorPicker = color_picker
    instance:Init()
    return instance
end

function square.Init(self)
    local canvas_group = Instance.new("CanvasGroup")
    canvas_group.BackgroundTransparency = 0
    canvas_group.BackgroundColor3 = Color3.new(1, 1, 1)
    canvas_group.Size = UDim2.fromScale(1, 1)
    canvas_group.Parent = self.ColorPicker.Instance:WaitForChild("Picker")
    local ui_corner = Instance.new("UICorner")
    ui_corner.CornerRadius = UDim.new(0, 6)
    ui_corner.Parent = canvas_group
    local ui_gradient = Instance.new("UIGradient")
    ui_gradient.Color = ColorSequence.new(Color3.new(1, 1, 1))
    ui_gradient.Parent = canvas_group
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0
    frame.Size = UDim2.fromScale(1, 1)
    frame.Parent = canvas_group
    local ui_gradient_2 = Instance.new("UIGradient")
    ui_gradient_2.Color = ColorSequence.new(Color3.new(0, 0, 0))
    ui_gradient_2.Rotation = -90
    ui_gradient_2.Transparency =
        NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
    ui_gradient_2.Parent = frame
    self.Instance = canvas_group
    self.Gradient = ui_gradient
end

function square.SetVisible(self, visible)
    self.Instance.Visible = visible
end

function square.GetColor(self, argument)
    return self.ColorPicker.Color.Hue, math.clamp(argument.X, 0, 1), (math.clamp(1 - argument.Y, 0, 1))
end

function square.GetPointerPositionFromColor(self, argument, argument_2, argument_3)
    return UDim2.fromScale(argument_2, 1 - argument_3)
end

function square.ColorChanged(self)
    self.Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(self.ColorPicker.Color.Hue, 1, 1)),
    })
end

return square
