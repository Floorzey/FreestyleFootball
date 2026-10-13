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

function circle.Init(self)
    local image_label = Instance.new("ImageLabel")
    image_label.Size = UDim2.fromScale(1, 1)
    image_label.BackgroundTransparency = 1
    image_label.Image = "rbxassetid://117857197662540"
    image_label.Parent = self.ColorPicker.Instance:WaitForChild("Picker")
    self.Instance = image_label
end

function circle.SetVisible(self, visible)
    self.Instance.Visible = visible
end

function circle.GetColor(self, argument)
    local vector = (argument - Vector2.new(0.5, 0.5)) * Vector2.new(1, -1)
    return math.clamp((math.atan2(vector.Y, vector.X) + math.pi) / math.tau, 0, 1),
        math.clamp(vector.Magnitude * 2, 0, 1),
        self.ColorPicker.Color.Value
end

function circle.GetPointerPositionFromColor(self, argument, argument_2, argument_3)
    local argument_offset_offset = argument * math.pi * 2
    return UDim2.fromScale(
        0.5 - ((math.cos(argument_offset_offset) / 2) * argument_2),
        0.5 + ((math.sin(argument_offset_offset) / 2) * argument_2)
    )
end

return circle
