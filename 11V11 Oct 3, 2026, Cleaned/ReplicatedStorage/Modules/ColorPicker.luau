local user_input_service = game:GetService("UserInputService")
local _ = game:GetService("TweenService")
local run_service = game:GetService("RunService")
local gui_service = game:GetService("GuiService")
local local_player = game.Players.LocalPlayer
local picker_modes = script:WaitForChild("PickerModes")
local samples = script:WaitForChild("Samples")
local values = {}
values.Circle = require(picker_modes:WaitForChild("Circle"))
values.Square = require(picker_modes:WaitForChild("Square"))
values.Triangle = require(picker_modes:WaitForChild("Triangle"))
local builtin_sliders = require(script:WaitForChild("BuiltinSliders"))
local mouse_movement = require(script:WaitForChild("MouseMovement"))
local window_resize = require(script:WaitForChild("WindowResize"))
local history = require(script:WaitForChild("History"))
local color_picker = {}
color_picker.__index = color_picker
color_picker.COLOR_SPACE = { HSV = 1, RGB = 2 }
color_picker.PICKER_MODE = { TRIANGLE = "Triangle", CIRCLE = "Circle", SQUARE = "Square" }

local function template(argument, argument_2)
    local values_2 = {}
    local value, value_2 = nil, nil
    for key, item in pairs(argument_2) do
        value = argument[key]
        if value == nil then
            value = item
        end
        if typeof(value) ~= "table" then
            value_2 = value
            values_2[key] = value_2
            continue
        end
        value_2 = template(value, item) or value
        values_2[key] = value_2
    end
    return values_2
end

function color_picker.new(argument)
    local instance = setmetatable({}, color_picker)
    local mouse_pos_offset = instance:GetMousePos() + Vector2.new(20, 20)
    instance.Params = template(argument or {}, {
        RealTimeEventCalling = false,
        EnableTransparency = false,
        Scale = 1,
        Parent = "new",
        ZIndex = 1,
        Position = UDim2.fromOffset(mouse_pos_offset.X, mouse_pos_offset.Y),
        PickerMode = color_picker.PICKER_MODE.CIRCLE,
        ColorSpace = color_picker.COLOR_SPACE.HSV,
    })
    instance.History = history.new()
    instance.PickerModes = {}
    instance.Sliders = {}
    instance.Color = { Hue = 0, Saturation = 1, Value = 1 }
    instance:_init()
    return instance
end

function color_picker.GetHSV(self)
    return self.Color.Hue, self.Color.Saturation, self.Color.Value
end

function color_picker.GetColor(self)
    return Color3.fromHSV(self:GetHSV())
end

function color_picker.SetColor(self, argument)
    local hue, saturation, value = argument:ToHSV()
    self.Color.Hue = hue
    self.Color.Saturation = saturation
    self.Color.Value = value
    self:_updateColorVisuals()
    self:WriteHistory()
    self:_fireColorChanged()
end

function color_picker.GetTransparency(self)
    if not self.Params.EnableTransparency then
        print("ColorPicker:GetTransparency - Transparency isn't enabled")
    end
    return self.Color.Transparency
end

function color_picker.SetTransparency(self, argument)
    if self.Params.EnableTransparency then
        self.Color.Transparency = math.clamp(argument, 0, 1)
        self:_updateColorVisuals()
    else
        print("ColorPicker:SetTransparency - Transparency isn't enabled")
    end
end

function color_picker._setSliderVisible(self, argument, argument_2)
    if argument_2 and argument.GetValue then
        argument.Value = argument.GetValue()
        argument:UpdateVisual()
    end
    argument:SetVisible(argument_2)
end

function color_picker._updateColorSpace(self)
    local text_label =
        self.Instance:WaitForChild("Middle"):WaitForChild("Right"):WaitForChild("ColorSpace"):WaitForChild("TextLabel")
    local is_color_space = self.ColorSpace == color_picker.COLOR_SPACE.HSV
    local text
    if is_color_space then
        text = "HSV"
    else
        text = "RGB"
    end
    text_label.Text = text
    self:_setSliderVisible(self.Sliders.Hue, is_color_space)
    self:_setSliderVisible(self.Sliders.Saturation, is_color_space)
    self:_setSliderVisible(self.Sliders.Value, is_color_space)
    self:_setSliderVisible(self.Sliders.Red, not is_color_space)
    self:_setSliderVisible(self.Sliders.Green, not is_color_space)
    self:_setSliderVisible(self.Sliders.Blue, not is_color_space)
    self:_updateSize()
end

function color_picker.SetColorSpace(self, color_space)
    self.ColorSpace = color_space
    self:_updateColorSpace()
end

function color_picker._updatePickerMode(self)
    for key, item in pairs(self.PickerModes) do
        item:SetVisible(key == self.PickerMode)
    end
    local image_transparency = nil
    for _, child in pairs(self.Instance:WaitForChild("Options"):WaitForChild("PickerMode"):GetChildren()) do
        if not (child:IsA("Frame")) then
            continue
        end
        local visible = child.Name == self.PickerMode
        local icon = child.Icon
        if visible then
            image_transparency = 0
        else
            image_transparency = 0.5
        end
        icon.ImageTransparency = image_transparency
        child.Selected.Visible = visible
    end
    self:_updateColorVisuals()
end

function color_picker.SetPickerMode(self, picker_mode)
    self.PickerMode = picker_mode
    self:_updatePickerMode()
end

function color_picker._getPickerMode(self, argument)
    if not self.PickerModes[argument] then
        self.PickerModes[argument] = values[argument].new(self)
    end
    return self.PickerModes[argument]
end

function color_picker._fireColorChanged(self)
    self._colorChangedEvent:Fire(self:GetColor(), self.Color.Transparency or 0)
end

function color_picker.GetMousePos(self)
    return user_input_service:GetMouseLocation() - Vector2.new(0, gui_service.TopbarInset.Height)
end

function color_picker._updateColorVisuals(self)
    local get_picker_mode_result = self:_getPickerMode(self.PickerMode)
    local hsv, value, value_2 = self:GetHSV()
    local select = self.Instance:WaitForChild("Picker"):WaitForChild("Select")
    select.ImageColor3 =
        Color3.fromHSV(0, 0, ((self.PickerMode == color_picker.PICKER_MODE.CIRCLE) and (0.4 + value_2 * 0.6)) or 1)
    select.Position = get_picker_mode_result:GetPointerPositionFromColor(hsv, value, value_2)
    if get_picker_mode_result.ColorChanged then
        get_picker_mode_result:ColorChanged()
    end
    local middle = self.Instance:WaitForChild("Middle")
    local color = middle:WaitForChild("Right"):WaitForChild("Color")
    color.BackgroundColor3 = self:GetColor()
    color.BackgroundTransparency = self.Color.Transparency or 0
    local input = middle:WaitForChild("Hex"):WaitForChild("Input")
    input.Text = string.format("#%s", self:GetColor():ToHex())
    for _, item in pairs(self.Sliders) do
        if not item.Visible then
            continue
        end
        if item.GetValue then
            item:ColorAdjusted()
        end
    end
end

function color_picker._updateSize(self)
    local number = 0
    for _, item in pairs(self.Sliders) do
        number = (item.Visible and (number + 1)) or number
    end
    local instance = self.Instance
    instance.Size = UDim2.fromOffset(238, 256 + (((number > 0) and (number * 26)) or 0))
end

function color_picker._updateHistoryVisuals(self)
    local history_2 = self.Instance:WaitForChild("Options"):WaitForChild("History")
    local button = history_2:WaitForChild("Undo"):WaitForChild("Button")
    local button_2 = history_2:WaitForChild("Redo"):WaitForChild("Button")
    button.ImageTransparency = ((self.History._currentIndex <= 1) and 0.5) or 0
    button_2.ImageTransparency = ((self.History._currentIndex ~= #self.History.Records) and 0) or 0.5
end

function color_picker.WriteHistory(self)
    self.History:WriteHistory(table.clone(self.Color))
    self:_updateHistoryVisuals()
end

function color_picker.IncrementHistory(self, argument)
    local increment_history_result = self.History:IncrementHistory(argument)
    if not increment_history_result then
        return
    end
    self.Color = table.clone(increment_history_result)
    self:_updateHistoryVisuals()
    self:_updateColorVisuals()
    self:_fireColorChanged()
end

function color_picker._create(self)
    self.UI = self.Params.Parent
    if self.UI and self.UI ~= "new" then
        assert(
            self.UI.ZIndexBehavior == Enum.ZIndexBehavior.Sibling,
            "ColorPicker - ZIndexBehavior needs to be 'Sibling'"
        )
    else
        local screen_gui = Instance.new("ScreenGui")
        screen_gui.Name = "COLOR_PICKER_UI"
        screen_gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screen_gui.Parent = local_player:WaitForChild("PlayerGui")
        self.UI = screen_gui
        self._deleteUIOnClose = true
    end
    local instance = samples:WaitForChild("ColorPickerSample"):Clone()
    instance.Position = self.Params.Position
    instance.ZIndex = self.Params.ZIndex
    instance.Parent = self.UI
    self.Instance = instance
    local picker = self.Instance:WaitForChild("Picker")
    self._pickerMouseMovement = mouse_movement.new(function()
        local mouse_pos = self:GetMousePos()
        local color_2 = self.Color
        local color_3 = self.Color
        local color_4 = self.Color
        local hue, saturation, value_2 = self:_getPickerMode(self.PickerMode)
            :GetColor((mouse_pos - picker.AbsolutePosition) / picker.AbsoluteSize)
        color_2.Hue = hue
        color_3.Saturation = saturation
        color_4.Value = value_2
        self:_updateColorVisuals()
        if not self.Params.RealTimeEventCalling then
            return
        end
        self:_fireColorChanged()
    end)
    self._pickerMouseMovement:OnDisconnect(function()
        self:_fireColorChanged()
        self:WriteHistory()
    end)
    picker:WaitForChild("Button").MouseButton1Down:Connect(function()
        self._pickerMouseMovement:Connect()
    end)
    local middle = self.Instance:WaitForChild("Middle")
    local input = middle:WaitForChild("Hex"):WaitForChild("Input")
    input.FocusLost:Connect(function()
        local success, value_2 = pcall(function()
            return Color3.fromHex(input.Text)
        end)
        local color3 = (success and value_2) or (Color3.new(1, 1, 1))
        self:SetColor(color3)
    end)
    middle:WaitForChild("Right"):WaitForChild("ColorSpace"):WaitForChild("Button").MouseButton1Down:Connect(function()
        self:SetColorSpace(
            ((self.ColorSpace == color_picker.COLOR_SPACE.HSV) and color_picker.COLOR_SPACE.RGB)
                or color_picker.COLOR_SPACE.HSV
        )
    end)
    self._windowAdjust = mouse_movement.new(function(argument, argument_2)
        local zero = self:GetMousePos() or Vector2.zero
        local zero_offset = zero - argument
        self.Instance.Position = argument_2 + UDim2.fromOffset(zero_offset.X, zero_offset.Y)
    end)
    self.Instance:WaitForChild("Topbar"):WaitForChild("Button").MouseButton1Down:Connect(function()
        local window_adjust = self._windowAdjust
        local zero = self:GetMousePos() or Vector2.zero
        window_adjust:Connect(zero, self.Instance.Position)
    end)
    self.WindowResize = window_resize.new(self)
    if
        not user_input_service.TouchEnabled
        and user_input_service.KeyboardEnabled
        and user_input_service.MouseEnabled
    then
        self.WindowResize:Create()
    end
    self.WindowResize:SetScale(self.Params.Scale)
    for _, value in pairs(self.Instance:WaitForChild("Options"):WaitForChild("PickerMode"):GetChildren()) do
        if value:IsA("Frame") then
            value.Button.MouseButton1Down:Connect(function()
                self:SetPickerMode(value.Name)
            end)
        end
    end
    local history_2 = self.Instance:WaitForChild("Options"):WaitForChild("History")
    local button = history_2:WaitForChild("Undo"):WaitForChild("Button")
    local button_2 = history_2:WaitForChild("Redo"):WaitForChild("Button")
    local function history_action_mouse_down(argument)
        self:IncrementHistory(argument)
        local _ = nil
        local timestamp = os.clock()
        local timestamp_offset = timestamp + 0.5
        local connection = run_service.Heartbeat:Connect(function() end)
        _ = connection
    end
    button.MouseButton1Down:Connect(function()
        self:IncrementHistory(-1)
        local _ = nil
        local timestamp = os.clock()
        local timestamp_offset = timestamp + 0.5
        local number_offset = -1
        local connection = run_service.Heartbeat:Connect(function() end)
        _ = connection
    end)
    button_2.MouseButton1Down:Connect(function()
        self:IncrementHistory(1)
        local connection_2 = nil
        local timestamp = os.clock()
        local timestamp_offset = timestamp + 0.5
        local number = 1
        local connection = run_service.Heartbeat:Connect(function()
            if user_input_service:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                local timestamp_2 = os.clock()
                if timestamp_offset <= timestamp_2 then
                    self:IncrementHistory(number)
                    timestamp_offset = os.clock() + 0.1
                end
            else
                connection_2:Disconnect()
                connection_2 = nil
            end
        end)
        connection_2 = connection
    end)
    if self.Params.EnableTransparency then
        local color = self.Instance:WaitForChild("Middle"):WaitForChild("Right"):WaitForChild("Color")
        local image_label = Instance.new("ImageLabel")
        image_label.Image = "rbxassetid://111137375763311"
        image_label.ImageColor3 = Color3.new(1, 1, 1)
        image_label.ImageTransparency = 0.5
        image_label.ScaleType = Enum.ScaleType.Tile
        image_label.TileSize = UDim2.fromOffset(14, 14)
        image_label.ZIndex = -1
        image_label.BackgroundTransparency = 1
        image_label.Position = color.Position
        image_label.Size = color.Size
        image_label.Parent = color.Parent
        local ui_corner = Instance.new("UICorner")
        ui_corner.CornerRadius = UDim.new(0, 4)
        ui_corner.Parent = image_label
    end
end

function color_picker._init(self)
    self:_create()
    self._colorChangedEvent = Instance.new("BindableEvent")
    self.ColorChanged = self._colorChangedEvent.Event
    self._windowClosedEvent = Instance.new("BindableEvent")
    self.WindowClosed = self._windowClosedEvent.Event
    self.Sliders.Hue = builtin_sliders.Hue(self)
    self.Sliders.Saturation = builtin_sliders.Saturation(self)
    self.Sliders.Value = builtin_sliders.Value(self)
    self.Sliders.Red = builtin_sliders.Red(self)
    self.Sliders.Green = builtin_sliders.Green(self)
    self.Sliders.Blue = builtin_sliders.Blue(self)
    if self.Params.EnableTransparency then
        self.Sliders.Transparency = builtin_sliders.Transparency(self)
        self.Sliders.Transparency:SetVisible(true)
    end
    self:SetPickerMode(self.Params.PickerMode)
    self:SetColorSpace(self.Params.ColorSpace)
    self.Color.Hue = 0
    self.Color.Saturation = 0
    self.Color.Value = 1
    self:_updateColorVisuals()
    self:_updateSize()
    self.Instance.Visible = true
end

function color_picker.Destroy(self)
    for _, instance in pairs(self.Sliders) do
        instance:Destroy()
    end
    for _, item in pairs({
        "_colorChangedEvent",
        "_windowClosedEvent",
        "History",
        "_windowAdjust",
        "_pickerMouseMovement",
        "Instance",
        "WindowResize",
    }) do
        if item then
            self[item]:Destroy()
            self[item] = nil
        end
    end
    if not self.UI or not self._deleteUIOnClose then
        return
    end
    self.UI:Destroy()
    self.UI = nil
end

return color_picker
