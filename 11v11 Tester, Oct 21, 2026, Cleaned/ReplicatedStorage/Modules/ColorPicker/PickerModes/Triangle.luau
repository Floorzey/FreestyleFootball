local triangle = {}
triangle.__index = triangle

local function height_to_triangle_height(argument)
    return argument / 0.8660254037844386 - 0.0669872981077807
end

local values = { Vector2.new(0.5, 0), Vector2.new(0, 1), Vector2.new(1, 1) }

function triangle.new(color_picker)
    local instance = setmetatable({}, triangle)
    instance.ColorPicker = color_picker
    instance:Init()

    return instance
end

function triangle.Init(argument)
    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.fromScale(1, 1)
    frame.Parent = argument.ColorPicker.Instance:WaitForChild("Picker")
    local image_label = Instance.new("ImageLabel")
    image_label.BackgroundTransparency = 1
    image_label.Size = UDim2.fromScale(1, 1)
    image_label.Image = "rbxassetid://119614645478849"
    image_label.ImageColor3 = Color3.new(1, 0, 0)
    image_label.ZIndex = 1
    image_label.Parent = frame
    local image_label2 = Instance.new("ImageLabel")
    image_label2.BackgroundTransparency = 1
    image_label2.Size = UDim2.fromScale(1, 1)
    image_label2.Image = "rbxassetid://114393129271758"
    image_label2.ImageColor3 = Color3.new(1, 1, 1)
    image_label2.ZIndex = 2
    image_label2.Parent = frame
    local image_label3 = Instance.new("ImageLabel")
    image_label3.BackgroundTransparency = 1
    image_label3.Size = UDim2.fromScale(1, 1)
    image_label3.Image = "rbxassetid://90395096352510"
    image_label3.ImageColor3 = Color3.new(1, 1, 1)
    image_label3.ZIndex = 3
    image_label3.Parent = frame
    argument.Instance = frame
    argument.ColorImage = image_label
end

function triangle.SetVisible(argument, visible)
    argument.Instance.Visible = visible
end

function triangle.GetColor(argument, argument_2)
    local x = argument_2.X
    local clamped_value = math.clamp(argument_2.Y / 0.8660254037844386 - 0.0669872981077807, 0, 1)
    local clamped_value_2 = math.clamp(x, 0.5 - clamped_value / 2, clamped_value / 2 + 0.5)
    local value_entry = values[1]
    local value_entry_2 = values[2]
    local value_entry_3 = values[3]
    local quotient = (
        (value_entry_2.Y - value_entry_3.Y) * (clamped_value_2 - value_entry_3.X)
        + (value_entry_3.X - value_entry_2.X) * (clamped_value - value_entry_3.Y)
    )
        / (
            (value_entry_2.Y - value_entry_3.Y) * (value_entry.X - value_entry_3.X)
            + (value_entry_3.X - value_entry_2.X) * (value_entry.Y - value_entry_3.Y)
        )
    local quotient_2 = (
        (value_entry_3.Y - value_entry.Y) * (clamped_value_2 - value_entry_3.X)
        + (value_entry.X - value_entry_3.X) * (clamped_value - value_entry_3.Y)
    )
        / (
            (value_entry_2.Y - value_entry_3.Y) * (value_entry.X - value_entry_3.X)
            + (value_entry_3.X - value_entry_2.X) * (value_entry.Y - value_entry_3.Y)
        )
    local clamped_value_3 = math.clamp(quotient, 0, 1)
    local clamped_value_4 = math.clamp(quotient_2, 0, 1)
    local clamped_value_5 = math.clamp(1 - quotient - quotient_2, 0, 1)
    local from_hsv_result = Color3.fromHSV(argument.ColorPicker.Color.Hue, 1, 1)
    local _, value, value_2 = Color3.new(
        clamped_value_3 * from_hsv_result.R + clamped_value_4 * 0 + clamped_value_5 * 1,
        clamped_value_3 * from_hsv_result.G + clamped_value_4 * 0 + clamped_value_5 * 1,
        clamped_value_3 * from_hsv_result.B + clamped_value_4 * 0 + clamped_value_5 * 1
    ):ToHSV()

    return argument.ColorPicker.Color.Hue, value, value_2
end

function triangle.GetPointerPositionFromColor(argument, argument_2, argument_3, argument_4)
    local interpolated_value =
        Vector2.new(0.5, 0):Lerp(Vector2.new(1, 1), 1 - argument_3):Lerp(Vector2.new(0, 1), 1 - argument_4)

    return UDim2.fromScale(interpolated_value.X, 0.0669872981077807 + interpolated_value.Y * 0.8660254037844386)
end

function triangle.ColorChanged(argument)
    argument.ColorImage.ImageColor3 = Color3.fromHSV(argument.ColorPicker.Color.Hue, 1, 1)
end

return triangle
