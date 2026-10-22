game:GetService("UserInputService")
game:GetService("RunService")
local samples = script.Parent:WaitForChild("Samples")
local mouse_movement = require(script.Parent:WaitForChild("MouseMovement"))
local slider = {}
slider.__index = slider

local function lerp(argument, argument_2, argument_3)
    return argument + (argument_2 - argument) * argument_3
end

function slider.new(color_picker, text_label, priority, max_value)
    local instance = setmetatable({}, slider)
    instance.ColorPicker = color_picker
    instance.TextLabel = text_label
    instance.Priority = priority
    instance.MaxValue = max_value
    instance.Visible = true
    instance.Value = 0
    instance:Init()

    return instance
end

function slider.Create(argument)
    local sliders = argument.ColorPicker.Instance:WaitForChild("Sliders")
    local instance = samples:WaitForChild("SliderSample"):Clone()
    instance.Name = string.format("%02d", argument.Priority)
    instance.Text.Text = argument.TextLabel
    instance.Parent = sliders
    argument.Instance = instance
end

function slider.SetValue(argument: table, argument_2: number)
    argument.Value = math.clamp(argument_2, 0, 1)

    if argument.OnManualChange then
        argument.OnManualChange(argument.Value)
    end

    argument:UpdateVisual()
end

function slider.SetVisible(argument: table, visible: boolean)
    argument.Visible = visible
    argument.Instance.Visible = argument.Visible
end

function slider.UpdateVisual(argument)
    local slider_2 = argument.Instance:WaitForChild("Slider")
    local select = slider_2:WaitForChild("Select")
    local input = argument.Instance:WaitForChild("Input")
    select.Position = UDim2.new(0, -3 + (slider_2.Size.X.Offset - 14 - -3) * argument.Value, 0.5, 0)
    input.Text = math.round(argument.Value * argument.MaxValue)

    if argument.OnValueChanged then
        argument.OnValueChanged()
    end
end

function slider.ColorAdjusted(argument)
    if argument.GetValue then
        argument.Value = argument.GetValue()
        argument:UpdateVisual()
    end
end

function slider.Init(argument)
    argument:Create()
    argument:SetVisible(false)
    local slider_button = argument.Instance:WaitForChild("SliderButton")
    local slider_2 = argument.Instance:WaitForChild("Slider")
    argument._mouseMovement = mouse_movement.new(function()
        local quotient = ((argument.ColorPicker:GetMousePos() - Vector2.new(4, 0)).X - slider_2.AbsolutePosition.X)
            / (slider_2.AbsoluteSize.X - 10)
        local clamped_value = math.clamp(quotient, 0, 1)

        if argument.Value ~= clamped_value then
            argument:SetValue(clamped_value)

            if argument.ColorPicker.Params.RealTimeEventCalling then
                argument.ColorPicker:_fireColorChanged()
            end
        end
    end)

    argument._mouseMovement:OnDisconnect(function()
        argument.ColorPicker:_fireColorChanged()
        argument.ColorPicker:WriteHistory()
    end)

    slider_button.MouseButton1Down:Connect(function()
        argument._mouseMovement:Connect()
    end)

    local input = argument.Instance:WaitForChild("Input")

    input.FocusLost:Connect(function()
        argument:SetValue((tonumber(input.Text) or 0) / argument.MaxValue)
        argument.ColorPicker:WriteHistory()
        argument.ColorPicker:_fireColorChanged()
    end)
end

function slider.Destroy(argument)
    if argument._mouseMovement then
        argument._mouseMovement:Destroy()
        argument._mouseMovement = nil
    end

    if argument.Instance then
        argument.Instance:Destroy()
        argument.Instance = nil
    end
end

return slider
