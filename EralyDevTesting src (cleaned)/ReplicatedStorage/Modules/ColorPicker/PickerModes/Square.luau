local square = {}
square.__index = square

function square.new(color_picker)
    local instance = setmetatable({}, square)
    instance.ColorPicker = color_picker
    instance:Init()

    return instance
end

function square.Init(argument)
    local canvas_group = Instance.new("CanvasGroup")
    canvas_group.BackgroundTransparency = 0
    canvas_group.BackgroundColor3 = Color3.new(1, 1, 1)
    canvas_group.Size = UDim2.fromScale(1, 1)
    canvas_group.Parent = argument.ColorPicker.Instance:WaitForChild("Picker")
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
    local ui_gradient2 = Instance.new("UIGradient")
    ui_gradient2.Color = ColorSequence.new(Color3.new(0, 0, 0))
    ui_gradient2.Rotation = -90
    ui_gradient2.Transparency =
        NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
    ui_gradient2.Parent = frame
    argument.Instance = canvas_group
    argument.Gradient = ui_gradient
end

function square.SetVisible(argument, visible)
    argument.Instance.Visible = visible
end

function square.GetColor(argument, argument_2)
    return argument.ColorPicker.Color.Hue, math.clamp(argument_2.X, 0, 1), math.clamp(1 - argument_2.Y, 0, 1)
end

function square.GetPointerPositionFromColor(argument, argument_2, argument_3, argument_4)
    return UDim2.fromScale(argument_3, 1 - argument_4)
end

function square.ColorChanged(argument)
    argument.Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(argument.ColorPicker.Color.Hue, 1, 1)),
    })
end

return square
