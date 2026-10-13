local _ = game:GetService("UserInputService")
local run_service = game:GetService("RunService")
local samples = script.Parent:WaitForChild("Samples")
local mouse_movement = require(script.Parent:WaitForChild("MouseMovement"))
local slider = {}
slider.__index = slider

local function lerp(argument, argument_2, argument_3)
    return argument + ((argument_2 - argument) * argument_3)
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

function slider.Create(self)
    local sliders = self.ColorPicker.Instance:WaitForChild("Sliders")
    local instance = samples:WaitForChild("SliderSample"):Clone()
    instance.Name = string.format("%02d", self.Priority)
    instance.Text.Text = self.TextLabel
    instance.Parent = sliders
    self.Instance = instance
end

function slider.SetValue(self, argument)
    self.Value = math.clamp(argument, 0, 1)
    if self.OnManualChange then
        self.OnManualChange(self.Value)
    end
    self:UpdateVisual()
end

function slider.SetVisible(self, visible)
    self.Visible = visible
    self.Instance.Visible = self.Visible
end

function slider.UpdateVisual(self)
    local slider_2 = self.Instance:WaitForChild("Slider")
    local select = slider_2:WaitForChild("Select")
    local input = self.Instance:WaitForChild("Input")
    select.Position = UDim2.new(0, -3 + (((slider_2.Size.X.Offset - 14) - -3) * self.Value), 0.5, 0)
    input.Text = math.round(self.Value * self.MaxValue)
    if not self.OnValueChanged then
        return
    end
    self.OnValueChanged()
end

function slider.ColorAdjusted(self)
    if not self.GetValue then
        return
    end
    self.Value = self.GetValue()
    self:UpdateVisual()
end

function slider.Init(self)
    self:Create()
    self:SetVisible(false)
    local slider_button = self.Instance:WaitForChild("SliderButton")
    local slider_2 = self.Instance:WaitForChild("Slider")
    self._mouseMovement = mouse_movement.new(function()
        local clamped_value = math.clamp(
            ((self.ColorPicker:GetMousePos() - Vector2.new(4, 0)).X - slider_2.AbsolutePosition.X)
                / (slider_2.AbsoluteSize.X - 10),
            0,
            1
        )
        if self.Value == clamped_value then
            return
        end
        self:SetValue(clamped_value)
        if not self.ColorPicker.Params.RealTimeEventCalling then
            return
        end
        self.ColorPicker:_fireColorChanged()
    end)
    self._mouseMovement:OnDisconnect(function()
        self.ColorPicker:_fireColorChanged()
        self.ColorPicker:WriteHistory()
    end)
    slider_button.MouseButton1Down:Connect(function()
        self._mouseMovement:Connect()
    end)
    local input = self.Instance:WaitForChild("Input")
    input.FocusLost:Connect(function()
        self:SetValue((tonumber(input.Text) or 0) / self.MaxValue)
        self.ColorPicker:WriteHistory()
        self.ColorPicker:_fireColorChanged()
    end)
end

function slider.Destroy(self)
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

return slider
