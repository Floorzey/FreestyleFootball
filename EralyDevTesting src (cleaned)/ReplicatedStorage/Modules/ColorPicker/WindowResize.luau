local mouse_movement = require(script.Parent:WaitForChild("MouseMovement"))
local tween_service = game:GetService("TweenService")
local window_resize = {}
window_resize.__index = window_resize

function window_resize.new(color_picker)
    local instance = setmetatable({}, window_resize)
    instance.ColorPicker = color_picker
    instance.ScaleElement = color_picker.Instance:WaitForChild("UIScale")
    instance.Window = color_picker.Instance
    instance.InfoMenu = instance.Window:WaitForChild("Info")
    instance.InputBox = instance.InfoMenu:WaitForChild("Scale"):WaitForChild("Input")
    instance:Init()

    return instance
end

function window_resize.GetScaleBounds(argument)
    local rounded_value = math.floor(argument.ColorPicker.UI.AbsoluteSize.Y / 250)

    return 1, math.max(rounded_value, 2)
end

function window_resize.SetScale(argument, argument_2)
    local product = math.clamp(argument_2, argument:GetScaleBounds()) * 100
    local scale = math.round(product) / 100
    argument.ScaleElement.Scale = scale
    argument.InputBox.Text = tostring(scale)
end

function window_resize.Init(argument)
    argument.InputBox.FocusLost:Connect(function()
        argument:SetScale(tonumber(argument.InputBox.Text) or 1)
    end)
end

function window_resize.Create(argument)
    local instance = script.Parent:WaitForChild("Samples"):WaitForChild("ResizeFrame"):Clone()
    instance.Frame.BackgroundTransparency = 1
    instance.Parent = argument.ColorPicker.Instance

    instance.MouseEnter:Connect(function()
        tween_service
            :Create(instance.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 0.5,
            })
            :Play()
    end)

    instance.MouseLeave:Connect(function()
        tween_service
            :Create(instance.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 1,
            })
            :Play()
    end)

    argument._mouseMovement = mouse_movement.new(function(argument_2, argument_3)
        local sum = argument_3 + (argument.ColorPicker:GetMousePos().X - argument_2.X) / argument.Window.Size.X.Offset

        if math.abs(argument_3 - sum) <= 0.05 then
            sum = argument_3
        else
            local difference = math.round(sum) - sum

            if math.abs(difference) <= 0.075 then
                sum = math.round(sum)
            end
        end

        argument:SetScale(sum)
    end)
    local ui_scale = argument.ColorPicker.Instance:WaitForChild("UIScale")

    instance.Button.MouseButton1Down:Connect(function()
        local mouse_pos = argument.ColorPicker:GetMousePos()
        argument._mouseMovement:Connect(mouse_pos, ui_scale.Scale)
    end)

    argument.Instance = instance
end

function window_resize.Destroy(argument)
    if argument._mouseMovement then
        argument._mouseMovement:Destroy()
        argument._mouseMovement = nil
    end

    if argument.Instance then
        argument.Instance:Destroy()
        argument.Instance = nil
    end
end

return window_resize
