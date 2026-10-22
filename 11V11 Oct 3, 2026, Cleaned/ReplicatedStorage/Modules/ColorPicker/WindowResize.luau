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

function window_resize.GetScaleBounds(self)
    return 1, (math.max(math.floor(self.ColorPicker.UI.AbsoluteSize.Y / 250), 2))
end

function window_resize.SetScale(self, argument)
    local scale = math.round(math.clamp(argument, self:GetScaleBounds()) * 100) / 100
    self.ScaleElement.Scale = scale
    self.InputBox.Text = tostring(scale)
end

function window_resize.Init(self)
    self.InputBox.FocusLost:Connect(function()
        self:SetScale(tonumber(self.InputBox.Text) or 1)
    end)
end

function window_resize.Create(self)
    local instance = script.Parent:WaitForChild("Samples"):WaitForChild("ResizeFrame"):Clone()
    instance.Frame.BackgroundTransparency = 1
    instance.Parent = self.ColorPicker.Instance
    instance.MouseEnter:Connect(function()
        local tween_properties = { BackgroundTransparency = 0.5 }
        tween_service
            :Create(
                instance.Frame,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                tween_properties
            )
            :Play()
    end)
    instance.MouseLeave:Connect(function()
        local tween_properties = { BackgroundTransparency = 1 }
        tween_service
            :Create(
                instance.Frame,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                tween_properties
            )
            :Play()
    end)
    self._mouseMovement = mouse_movement.new(function(argument, argument_2)
        local argument_offset = argument_2 + (self.ColorPicker:GetMousePos().X - argument.X) / self.Window.Size.X.Offset
        if math.abs(argument_2 - argument_offset) <= 0.05 then
            argument_offset = argument_2
        elseif math.abs(math.round(argument_offset) - argument_offset) <= 0.075 then
            argument_offset = math.round(argument_offset)
        end
        self:SetScale(argument_offset)
    end)
    local ui_scale = self.ColorPicker.Instance:WaitForChild("UIScale")
    instance.Button.MouseButton1Down:Connect(function()
        self._mouseMovement:Connect(self.ColorPicker:GetMousePos(), ui_scale.Scale)
    end)
    self.Instance = instance
end

function window_resize.Destroy(self)
    if self._mouseMovement then
        self._mouseMovement:Destroy()
        self._mouseMovement = nil
    end
    if not self.Instance then
        return
    end
    self.Instance:Destroy()
    self.Instance = nil
end

return window_resize
