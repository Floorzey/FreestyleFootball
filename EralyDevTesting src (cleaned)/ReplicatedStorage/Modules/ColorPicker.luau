local user_input_service = game:GetService("UserInputService")
game:GetService("TweenService")
local run_service = game:GetService("RunService")
local gui_service = game:GetService("GuiService")
local local_player = game.Players.LocalPlayer
local picker_modes = script:WaitForChild("PickerModes")
local samples = script:WaitForChild("Samples")
local values = {
    Circle = require(picker_modes:WaitForChild("Circle")),
    Square = require(picker_modes:WaitForChild("Square")),
    Triangle = require(picker_modes:WaitForChild("Triangle")),
}
local builtin_sliders = require(script:WaitForChild("BuiltinSliders"))
local mouse_movement = require(script:WaitForChild("MouseMovement"))
local window_resize = require(script:WaitForChild("WindowResize"))
local history = require(script:WaitForChild("History"))
local color_picker = {}
color_picker.__index = color_picker
color_picker.COLOR_SPACE = {
    HSV = 1,
    RGB = 2,
}
color_picker.PICKER_MODE = {
    CIRCLE = "Circle",
    SQUARE = "Square",
    TRIANGLE = "Triangle",
}

local function template(argument, argument_2)
    local values_2 = {}

    for key, item in pairs(argument_2) do
        local argument_entry = argument[key]

        if argument_entry == nil then
            argument_entry = item
        end

        if typeof(argument_entry) == "table" then
            argument_entry = template(argument_entry, item) or argument_entry
        end

        values_2[key] = argument_entry
    end

    return values_2
end

function color_picker.new(argument)
    local instance = setmetatable({}, color_picker)
    local sum = instance:GetMousePos() + Vector2.new(20, 20)
    instance.Params = template(argument or {}, {
        Parent = "new",
        ZIndex = 1,
        Scale = 1,
        EnableTransparency = false,
        RealTimeEventCalling = false,
        Position = UDim2.fromOffset(sum.X, sum.Y),
        PickerMode = color_picker.PICKER_MODE.CIRCLE,
        ColorSpace = color_picker.COLOR_SPACE.HSV,
    })
    instance.History = history.new()
    instance.PickerModes = {}
    instance.Sliders = {}
    instance.Color = {
        Hue = 0,
        Saturation = 1,
        Value = 1,
    }
    instance:_init()

    return instance
end

function color_picker.GetHSV(argument)
    return argument.Color.Hue, argument.Color.Saturation, argument.Color.Value
end

function color_picker.GetColor(argument)
    return Color3.fromHSV(argument:GetHSV())
end

function color_picker.SetColor(argument, argument_2)
    local color = argument.Color
    local color2 = argument.Color
    local color4 = argument.Color
    local hue, saturation, value = argument_2:ToHSV()
    color.Hue = hue
    color2.Saturation = saturation
    color4.Value = value
    argument:_updateColorVisuals()
    argument:WriteHistory()
    argument:_fireColorChanged()
end

function color_picker.GetTransparency(argument)
    if not argument.Params.EnableTransparency then
        print("ColorPicker:GetTransparency - Transparency isn't enabled")
    end

    return argument.Color.Transparency
end

function color_picker.SetTransparency(argument, argument_2)
    if not argument.Params.EnableTransparency then
        print("ColorPicker:SetTransparency - Transparency isn't enabled")

        return
    end

    argument.Color.Transparency = math.clamp(argument_2, 0, 1)
    argument:_updateColorVisuals()
end

function color_picker._setSliderVisible(argument, argument_2, argument_3)
    if argument_3 and argument_2.GetValue then
        argument_2.Value = argument_2.GetValue()
        argument_2:UpdateVisual()
    end

    argument_2:SetVisible(argument_3)
end

function color_picker._updateColorSpace(argument)
    local text_label = argument.Instance
        :WaitForChild("Middle")
        :WaitForChild("Right")
        :WaitForChild("ColorSpace")
        :WaitForChild("TextLabel")
    local condition = argument.ColorSpace == color_picker.COLOR_SPACE.HSV
    text_label.Text = condition and "HSV" or "RGB"
    argument:_setSliderVisible(argument.Sliders.Hue, condition)
    argument:_setSliderVisible(argument.Sliders.Saturation, condition)
    argument:_setSliderVisible(argument.Sliders.Value, condition)
    argument:_setSliderVisible(argument.Sliders.Red, not condition)
    argument:_setSliderVisible(argument.Sliders.Green, not condition)
    argument:_setSliderVisible(argument.Sliders.Blue, not condition)
    argument:_updateSize()
end

function color_picker.SetColorSpace(argument, color_space)
    argument.ColorSpace = color_space
    argument:_updateColorSpace()
end

function color_picker._updatePickerMode(argument)
    for key, item in pairs(argument.PickerModes) do
        item:SetVisible(key == argument.PickerMode)
    end

    local picker_mode = argument.Instance:WaitForChild("Options"):WaitForChild("PickerMode")

    for _, child in pairs(picker_mode:GetChildren()) do
        if child:IsA("Frame") then
            local visible = child.Name == argument.PickerMode
            child.Icon.ImageTransparency = visible and 0 or 0.5
            child.Selected.Visible = visible
        end
    end

    argument:_updateColorVisuals()
end

function color_picker.SetPickerMode(argument, picker_mode)
    argument.PickerMode = picker_mode
    argument:_updatePickerMode()
end

function color_picker._getPickerMode(argument, argument_2)
    if not argument.PickerModes[argument_2] then
        argument.PickerModes[argument_2] = values[argument_2].new(argument)
    end

    return argument.PickerModes[argument_2]
end

function color_picker._fireColorChanged(argument)
    argument._colorChangedEvent:Fire(argument:GetColor(), argument.Color.Transparency or 0)
end

function color_picker.GetMousePos(argument)
    local height = gui_service.TopbarInset.Height

    return user_input_service:GetMouseLocation() - Vector2.new(0, height)
end

function color_picker._updateColorVisuals(argument)
    local get_picker_mode_result = argument:_getPickerMode(argument.PickerMode)
    local hsv, value, value_2 = argument:GetHSV()
    local select = argument.Instance:WaitForChild("Picker"):WaitForChild("Select")
    select.ImageColor3 =
        Color3.fromHSV(0, 0, argument.PickerMode == color_picker.PICKER_MODE.CIRCLE and (0.4 + value_2 * 0.6 or 1) or 1)
    select.Position = get_picker_mode_result:GetPointerPositionFromColor(hsv, value, value_2)

    if get_picker_mode_result.ColorChanged then
        get_picker_mode_result:ColorChanged()
    end

    local middle = argument.Instance:WaitForChild("Middle")
    local color = middle:WaitForChild("Right"):WaitForChild("Color")
    color.BackgroundColor3 = argument:GetColor()
    color.BackgroundTransparency = argument.Color.Transparency or 0
    middle:WaitForChild("Hex"):WaitForChild("Input").Text = string.format("#%s", argument:GetColor():ToHex())

    for _, item in pairs(argument.Sliders) do
        if item.Visible and item.GetValue then
            item:ColorAdjusted()
        end
    end
end

function color_picker._updateSize(argument)
    local number = 0

    for _, item in pairs(argument.Sliders) do
        if item.Visible then
            number += 1
        end
    end

    argument.Instance.Size = UDim2.fromOffset(238, 256 + (number > 0 and number * 26 or 0))
end

function color_picker._updateHistoryVisuals(argument)
    local history2 = argument.Instance:WaitForChild("Options"):WaitForChild("History")
    local button = history2:WaitForChild("Undo"):WaitForChild("Button")
    local button2 = history2:WaitForChild("Redo"):WaitForChild("Button")
    button.ImageTransparency = argument.History._currentIndex <= 1 and 0.5 or 0
    button2.ImageTransparency = argument.History._currentIndex == #argument.History.Records and 0.5 or 0
end

function color_picker.WriteHistory(argument)
    argument.History:WriteHistory(table.clone(argument.Color))
    argument:_updateHistoryVisuals()
end

function color_picker.IncrementHistory(argument: table, argument_2: number)
    local increment_history_result = argument.History:IncrementHistory(argument_2)

    if not increment_history_result then
        return
    end

    argument.Color = table.clone(increment_history_result)
    argument:_updateHistoryVisuals()
    argument:_updateColorVisuals()
    argument:_fireColorChanged()
end

function color_picker._create(argument)
    argument.UI = argument.Params.Parent

    if argument.UI and argument.UI ~= "new" then
        assert(
            argument.UI.ZIndexBehavior == Enum.ZIndexBehavior.Sibling,
            "ColorPicker - ZIndexBehavior needs to be 'Sibling'"
        )
    else
        local screen_gui = Instance.new("ScreenGui")
        screen_gui.Name = "COLOR_PICKER_UI"
        screen_gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screen_gui.Parent = local_player:WaitForChild("PlayerGui")
        argument.UI = screen_gui
        argument._deleteUIOnClose = true
    end

    local instance = samples:WaitForChild("ColorPickerSample"):Clone()
    instance.Position = argument.Params.Position
    instance.ZIndex = argument.Params.ZIndex
    instance.Parent = argument.UI
    argument.Instance = instance
    local picker = argument.Instance:WaitForChild("Picker")
    argument._pickerMouseMovement = mouse_movement.new(function()
        local quotient = (argument:GetMousePos() - picker.AbsolutePosition) / picker.AbsoluteSize
        local color_2 = argument.Color
        local color2 = argument.Color
        local color4 = argument.Color
        local color5, saturation, value = argument:_getPickerMode(argument.PickerMode):GetColor(quotient)
        color_2.Hue = color5
        color2.Saturation = saturation
        color4.Value = value
        argument:_updateColorVisuals()

        if argument.Params.RealTimeEventCalling then
            argument:_fireColorChanged()
        end
    end)

    argument._pickerMouseMovement:OnDisconnect(function()
        argument:_fireColorChanged()
        argument:WriteHistory()
    end)

    picker:WaitForChild("Button").MouseButton1Down:Connect(function()
        argument._pickerMouseMovement:Connect()
    end)

    local middle = argument.Instance:WaitForChild("Middle")
    local input = middle:WaitForChild("Hex"):WaitForChild("Input")

    input.FocusLost:Connect(function()
        local success, result = pcall(function()
            return Color3.fromHex(input.Text)
        end)
        argument:SetColor(success and result and result or Color3.new(1, 1, 1))
    end)

    middle:WaitForChild("Right"):WaitForChild("ColorSpace"):WaitForChild("Button").MouseButton1Down:Connect(function()
        argument:SetColorSpace(
            argument.ColorSpace == color_picker.COLOR_SPACE.HSV and color_picker.COLOR_SPACE.RGB
                or color_picker.COLOR_SPACE.HSV
        )
    end)

    argument._windowAdjust = mouse_movement.new(function(argument_2, argument_3)
        local difference = (argument:GetMousePos() or Vector2.zero) - argument_2
        argument.Instance.Position = argument_3 + UDim2.fromOffset(difference.X, difference.Y)
    end)

    argument.Instance:WaitForChild("Topbar"):WaitForChild("Button").MouseButton1Down:Connect(function()
        argument._windowAdjust:Connect(argument:GetMousePos() or Vector2.zero, argument.Instance.Position)
    end)

    argument.WindowResize = window_resize.new(argument)

    if
        not user_input_service.TouchEnabled and (user_input_service.KeyboardEnabled and user_input_service.MouseEnabled)
    then
        argument.WindowResize:Create()
    end

    argument.WindowResize:SetScale(argument.Params.Scale)
    local picker_mode = argument.Instance:WaitForChild("Options"):WaitForChild("PickerMode")

    for _, child in pairs(picker_mode:GetChildren()) do
        if child:IsA("Frame") then
            child.Button.MouseButton1Down:Connect(function()
                argument:SetPickerMode(child.Name)
            end)
        end
    end

    local history2 = argument.Instance:WaitForChild("Options"):WaitForChild("History")
    local button = history2:WaitForChild("Undo"):WaitForChild("Button")
    local button2 = history2:WaitForChild("Redo"):WaitForChild("Button")

    local function history_action_mouse_down(argument_2)
        argument:IncrementHistory(argument_2)
        local connection = nil
        local sum = os.clock() + 0.5
        connection = run_service.Heartbeat:Connect(function()
            if user_input_service:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                if sum <= os.clock() then
                    argument:IncrementHistory(argument_2)
                    sum = os.clock() + 0.1
                end

                return
            end

            connection:Disconnect()
            connection = nil
        end)
    end

    button.MouseButton1Down:Connect(function()
        argument:IncrementHistory(-1)
        local connection = nil
        local sum = os.clock() + 0.5
        local negated_value = -1
        connection = run_service.Heartbeat:Connect(function()
            if user_input_service:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                if sum <= os.clock() then
                    argument:IncrementHistory(negated_value)
                    sum = os.clock() + 0.1
                end

                return
            end

            connection:Disconnect()
            connection = nil
        end)
    end)

    button2.MouseButton1Down:Connect(function()
        argument:IncrementHistory(1)
        local connection = nil
        local sum = os.clock() + 0.5
        local number = 1
        connection = run_service.Heartbeat:Connect(function()
            if user_input_service:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                if sum <= os.clock() then
                    argument:IncrementHistory(number)
                    sum = os.clock() + 0.1
                end

                return
            end

            connection:Disconnect()
            connection = nil
        end)
    end)

    if not argument.Params.EnableTransparency then
        return
    end

    local color = argument.Instance:WaitForChild("Middle"):WaitForChild("Right"):WaitForChild("Color")
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

function color_picker._init(argument)
    argument:_create()
    argument._colorChangedEvent = Instance.new("BindableEvent")
    argument.ColorChanged = argument._colorChangedEvent.Event
    argument._windowClosedEvent = Instance.new("BindableEvent")
    argument.WindowClosed = argument._windowClosedEvent.Event
    argument.Sliders.Hue = builtin_sliders.Hue(argument)
    argument.Sliders.Saturation = builtin_sliders.Saturation(argument)
    argument.Sliders.Value = builtin_sliders.Value(argument)
    argument.Sliders.Red = builtin_sliders.Red(argument)
    argument.Sliders.Green = builtin_sliders.Green(argument)
    argument.Sliders.Blue = builtin_sliders.Blue(argument)

    if argument.Params.EnableTransparency then
        argument.Sliders.Transparency = builtin_sliders.Transparency(argument)
        argument.Sliders.Transparency:SetVisible(true)
    end

    argument:SetPickerMode(argument.Params.PickerMode)
    argument:SetColorSpace(argument.Params.ColorSpace)
    local color = argument.Color
    local color2 = argument.Color
    argument.Color.Hue = 0
    color.Saturation = 0
    color2.Value = 1
    argument:_updateColorVisuals()
    argument:_updateSize()
    argument.Instance.Visible = true
end

function color_picker.Destroy(argument)
    for _, instance in pairs(argument.Sliders) do
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
            argument[item]:Destroy()
            argument[item] = nil
        end
    end

    if argument.UI and argument._deleteUIOnClose then
        argument.UI:Destroy()
        argument.UI = nil
    end
end

return color_picker
