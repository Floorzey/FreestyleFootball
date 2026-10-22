local circle = {}
circle.__index = circle

local function to_polar(vector)
    return math.atan2(vector.Y, vector.X), vector.Magnitude
end

function circle.new(color_picker)
    local instance = setmetatable({}, circle)
    instance.ColorPicker = color_picker
    instance:Init()

    return instance
end

function circle.Init(argument)
    local image_label = Instance.new("ImageLabel")
    image_label.Size = UDim2.fromScale(1, 1)
    image_label.BackgroundTransparency = 1
    image_label.Image = "rbxassetid://117857197662540"
    image_label.Parent = argument.ColorPicker.Instance:WaitForChild("Picker")
    argument.Instance = image_label
end

function circle.SetVisible(argument, visible)
    argument.Instance.Visible = visible
end

function circle.GetColor(argument, argument_2)
    local vector = (argument_2 - Vector2.new(0.5, 0.5)) * Vector2.new(1, -1)
    local angle = math.atan2(vector.Y, vector.X)
    local magnitude = vector.Magnitude

    return math.clamp((angle + 3.141592653589793) / 6.283185307179586, 0, 1),
        math.clamp(magnitude * 2, 0, 1),
        argument.ColorPicker.Color.Value
end

function circle.GetPointerPositionFromColor(argument, argument_2, argument_3, argument_4)
    local product = argument_2 * 3.141592653589793 * 2

    return UDim2.fromScale(0.5 - math.cos(product) / 2 * argument_3, 0.5 + math.sin(product) / 2 * argument_3)
end

return circle
