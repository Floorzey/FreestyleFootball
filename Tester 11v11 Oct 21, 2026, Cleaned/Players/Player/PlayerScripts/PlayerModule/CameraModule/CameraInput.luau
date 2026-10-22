local context_action_service = game:GetService("ContextActionService")
local user_input_service = game:GetService("UserInputService")
local players = game:GetService("Players")
local run_service = game:GetService("RunService")
local user_game_settings = UserSettings():GetService("UserGameSettings")
local vr_service = game:GetService("VRService")
local common_utils = script.Parent.Parent:WaitForChild("CommonUtils")
local user_flag = require(common_utils:WaitForChild("FlagUtil")).getUserFlag("UserCameraInputDt")
local local_player = players.LocalPlayer
local value = Enum.ContextActionPriority.Medium.Value
local product = Vector2.new(1, 0.77) * 0.06981317007977318
local product_2 = Vector2.new(1, 0.77) * 0.008726646259971648
local product_3 = Vector2.new(1, 0.77) * 0.12217304763960307
local product_4 = Vector2.new(1, 0.66) * 0.017453292519943295

if user_flag then
    product *= 60
end

local success, result = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserResetTouchStateOnMenuOpen")
end)
local result_2 = success and result
local success2, result2 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserClearPanOnCameraDisable")
end)
local result2_2 = success2 and result2
local success3, result3 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserFixGamepadSensitivity")
end)
local result3_2 = success3 and result3
local bindable_event = Instance.new("BindableEvent")
local bindable_event2 = Instance.new("BindableEvent")
local event = bindable_event.Event
local event2 = bindable_event2.Event

user_input_service.InputBegan:Connect(function(input, game_processed)
    if not game_processed and input.UserInputType == Enum.UserInputType.MouseButton2 then
        bindable_event:Fire()
    end
end)

user_input_service.InputEnded:Connect(function(input, game_processed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        bindable_event2:Fire()
    end
end)

local function thumbstick_curve(argument)
    local product_5 = (math.abs(argument) - 0.1) / 0.9 * 2
    local quotient = (math.exp(product_5) - 1) / 6.38905609893065

    return math.sign(argument) * math.clamp(quotient, 0, 1)
end

local function adjust_touch_pitch_sensitivity(argument)
    local workspace_current_camera = workspace.CurrentCamera

    if not workspace_current_camera then
        return argument
    end

    local to_euler_angles_yxz_result = workspace_current_camera.CFrame:ToEulerAnglesYXZ()

    if argument.Y * to_euler_angles_yxz_result >= 0 then
        return argument
    end

    local sum = (1 - (math.abs(to_euler_angles_yxz_result) * 2 / 3.141592653589793) ^ 0.75) * 0.75 + 0.25

    return Vector2.new(1, sum) * argument
end

local function is_in_dynamic_thumbstick_area(argument: vector)
    local player_gui = local_player:FindFirstChildOfClass("PlayerGui")

    if player_gui then
        player_gui = player_gui:FindFirstChild("TouchGui")
    end

    local touch_control_frame

    if player_gui then
        touch_control_frame = player_gui:FindFirstChild("TouchControlFrame")
    else
        touch_control_frame = player_gui
    end

    if touch_control_frame then
        touch_control_frame = touch_control_frame:FindFirstChild("DynamicThumbstickFrame")
    end

    if not touch_control_frame then
        return false
    end

    if not player_gui.Enabled then
        return false
    end

    local absolute_position = touch_control_frame.AbsolutePosition
    local sum = absolute_position + touch_control_frame.AbsoluteSize
    local condition

    if argument.X >= absolute_position.X and (argument.Y >= absolute_position.Y and argument.X <= sum.X) then
        condition = argument.Y <= sum.Y
    else
        condition = false
    end

    return condition
end

local number = 0.016666666666666666

run_service.Stepped:Connect(function(elapsed_time, delta_time)
    number = delta_time
end)

local camera_input = {}
local items = {}
local number_2 = 0

local function inc_pan_input_count()
    number_2 = math.max(0, number_2 + 1)
end

local function dec_pan_input_count()
    number_2 = math.max(0, number_2 - 1)
end

local function reset_pan_input_count()
    number_2 = 0
end

local values = {
    Thumbstick2 = Vector2.new(),
}
local values_2 = {
    Left = 0,
    Right = 0,
    I = 0,
    O = 0,
}
local values_3 = {
    Wheel = 0,
    Pinch = 0,
    Movement = Vector2.new(),
    Pan = Vector2.new(),
}
local values_4 = {
    Pinch = 0,
    Move = Vector2.new(),
}
local bindable_event3 = Instance.new("BindableEvent")
camera_input.gamepadZoomPress = bindable_event3.Event
local bindable_event_2 = vr_service.VREnabled and Instance.new("BindableEvent") or nil

if vr_service.VREnabled then
    camera_input.gamepadReset = bindable_event_2.Event
end

function camera_input.getRotationActivated()
    return number_2 > 0 and true or values.Thumbstick2.Magnitude > 0
end

function camera_input.getRotation(argument: any, argument_2: boolean?)
    local vector = Vector2.new(1, user_game_settings:GetCameraYInvertValue())
    local product_5

    if user_flag then
        product_5 = Vector2.new(values_2.Right - values_2.Left, 0) * argument
    else
        product_5 = Vector2.new(values_2.Right - values_2.Left, 0) * number
    end

    local product_6

    if result3_2 then
        product_6 = values.Thumbstick2 * user_game_settings.GamepadCameraSensitivity
    else
        product_6 = values.Thumbstick2
    end

    if user_flag then
        product_6 *= argument
    end

    local movement = values_3.Movement
    local pan = values_3.Pan
    local result_3 = adjust_touch_pitch_sensitivity(values_4.Move)

    if argument_2 then
        product_5 = Vector2.new()
    end

    return (
        product_5 * 2.0943951023931953
        + product_6 * product
        + movement * product_2
        + pan * product_3
        + result_3 * product_4
    ) * vector
end

function camera_input.getZoomDelta()
    return (values_2.O - values_2.I) * 0.1 + (-values_3.Wheel + values_3.Pinch) * 1 + -values_4.Pinch * 0.04
end

local function thumbstick(argument, argument_2, input)
    local position = input.Position
    values[input.KeyCode.Name] = Vector2.new(thumbstick_curve(position.X), -thumbstick_curve(position.Y))

    return Enum.ContextActionResult.Pass
end

local function mouse_movement(input)
    local delta = input.Delta
    values_3.Movement = Vector2.new(delta.X, delta.Y)
end

local function mouse_wheel(argument, argument_2, argument_3)
    values_3.Wheel = argument_3.Position.Z

    return Enum.ContextActionResult.Pass
end

local function keypress(argument, argument_2, input)
    values_2[input.KeyCode.Name] = argument_2 == Enum.UserInputState.Begin and 1 or 0
end

local function gamepad_zoom_press(argument, argument_2, argument_3)
    if argument_2 == Enum.UserInputState.Begin then
        bindable_event3:Fire()
    end
end

local function gamepad_reset(argument, argument_2, argument_3)
    if argument_2 == Enum.UserInputState.Begin then
        bindable_event_2:Fire()
    end
end

local function reset_input_devices()
    for _, item in pairs({
        values,
        values_2,
        values_3,
        values_4,
    }) do
        local item_2 = item

        for key, item_3 in pairs(item) do
            if type(item_3) == "boolean" then
                item_2[key] = false
            else
                item_2[key] = item_2[key] * 0
            end
        end
    end

    if result2_2 then
        number_2 = 0
    end
end

local values_5 = {}
local value_2 = nil
local value_3 = nil

local function touch_began(input: userdata, argument: boolean)
    assert(input.UserInputType == Enum.UserInputType.Touch)
    assert(input.UserInputState == Enum.UserInputState.Begin)

    if value_2 == nil and (is_in_dynamic_thumbstick_area(input.Position) and not argument) then
        value_2 = input

        return
    end

    if not argument then
        number_2 = math.max(0, number_2 + 1)
    end

    values_5[input] = argument
end

local function touch_ended(input: userdata, argument: boolean)
    assert(input.UserInputType == Enum.UserInputType.Touch)
    assert(input.UserInputState == Enum.UserInputState.End)

    if input == value_2 then
        value_2 = nil
    end

    if values_5[input] == false then
        value_3 = nil
        number_2 = math.max(0, number_2 - 1)
    end

    values_5[input] = nil
end

local function touch_changed(input, argument)
    assert(input.UserInputType == Enum.UserInputType.Touch)
    assert(input.UserInputState == Enum.UserInputState.Change)

    if input == value_2 then
        return
    end

    if values_5[input] == nil then
        values_5[input] = argument
    end

    local items_2 = {}

    for key, item in pairs(values_5) do
        if not item then
            table.insert(items_2, key)
        end
    end

    if #items_2 == 1 and values_5[input] == false then
        local delta = input.Delta
        local values_6 = values_4
        values_6.Move = values_6.Move + Vector2.new(delta.X, delta.Y)
    end

    if #items_2 ~= 2 then
        value_3 = nil

        return
    end

    local magnitude = (items_2[1].Position - items_2[2].Position).Magnitude

    if value_3 then
        local values_7 = values_4
        values_7.Pinch = values_7.Pinch + (magnitude - value_3)
    end

    value_3 = magnitude
end

local function reset_touch_state()
    values_5 = {}
    value_2 = nil
    value_3 = nil

    if result_2 then
        number_2 = 0
    end
end

local function pointer_action(wheel, pan, argument, argument_2)
    if argument_2 then
        return
    end

    values_3.Wheel = wheel
    values_3.Pan = pan
    values_3.Pinch = -argument
end

local function input_began(input, argument)
    if input.UserInputType == Enum.UserInputType.Touch then
        touch_began(input, argument)

        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton2 and not argument then
        number_2 = math.max(0, number_2 + 1)
    end
end

local function input_changed(input, argument)
    if input.UserInputType == Enum.UserInputType.Touch then
        touch_changed(input, argument)

        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Delta
        values_3.Movement = Vector2.new(delta.X, delta.Y)
    end
end

local function input_ended(input, argument)
    if input.UserInputType == Enum.UserInputType.Touch then
        touch_ended(input, argument)

        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        number_2 = math.max(0, number_2 - 1)
    end
end

local enabled = false

function camera_input.setInputEnabled(argument)
    if enabled == argument then
        return
    end

    enabled = argument
    reset_input_devices()
    reset_touch_state()

    if enabled then
        context_action_service:BindActionAtPriority(
            "RbxCameraThumbstick",
            thumbstick,
            false,
            value,
            Enum.KeyCode.Thumbstick2
        )
        context_action_service:BindActionAtPriority(
            "RbxCameraKeypress",
            keypress,
            false,
            value,
            Enum.KeyCode.Left,
            Enum.KeyCode.Right,
            Enum.KeyCode.I,
            Enum.KeyCode.O
        )

        if vr_service.VREnabled then
            context_action_service:BindAction("RbxCameraGamepadReset", gamepad_reset, false, Enum.KeyCode.ButtonL3)
        end

        context_action_service:BindAction("RbxCameraGamepadZoom", gamepad_zoom_press, false, Enum.KeyCode.ButtonR3)
        table.insert(items, user_input_service.InputBegan:Connect(input_began))
        table.insert(items, user_input_service.InputChanged:Connect(input_changed))
        table.insert(items, user_input_service.InputEnded:Connect(input_ended))
        table.insert(items, user_input_service.PointerAction:Connect(pointer_action))

        if result_2 then
            local menu_opened = game:GetService("GuiService").MenuOpened
            table.insert(items, menu_opened:connect(reset_touch_state))
        end
    else
        context_action_service:UnbindAction("RbxCameraThumbstick")
        context_action_service:UnbindAction("RbxCameraMouseMove")
        context_action_service:UnbindAction("RbxCameraMouseWheel")
        context_action_service:UnbindAction("RbxCameraKeypress")
        context_action_service:UnbindAction("RbxCameraGamepadZoom")

        if vr_service.VREnabled then
            context_action_service:UnbindAction("RbxCameraGamepadReset")
        end

        for _, connection_3 in pairs(items) do
            connection_3:Disconnect()
        end

        items = {}
    end
end

function camera_input.getInputEnabled()
    return enabled
end

function camera_input.resetInputForFrameEnd()
    values_3.Movement = Vector2.new()
    values_4.Move = Vector2.new()
    values_4.Pinch = 0
    values_3.Wheel = 0
    values_3.Pan = Vector2.new()
    values_3.Pinch = 0
end

user_input_service.WindowFocused:Connect(reset_input_devices)
user_input_service.WindowFocusReleased:Connect(reset_input_devices)
local enabled_2 = false
local enabled_3 = false
local number_3 = 0

function camera_input.getHoldPan()
    return enabled_2
end

function camera_input.getTogglePan()
    return enabled_3
end

function camera_input.getPanning()
    return enabled_3 or enabled_2
end

function camera_input.setTogglePan(argument: boolean)
    enabled_3 = argument
end

local enabled_4 = false
local connection = nil
local connection_2 = nil

function camera_input.enableCameraToggleInput()
    if enabled_4 then
        return
    end

    enabled_4 = true
    enabled_2 = false
    enabled_3 = false

    if connection then
        connection:Disconnect()
    end

    if connection_2 then
        connection_2:Disconnect()
    end

    connection = event:Connect(function()
        enabled_2 = true
        number_3 = tick()
    end)
    connection_2 = event2:Connect(function()
        enabled_2 = false

        if tick() - number_3 < 0.3 and (enabled_3 or user_input_service:GetMouseDelta().Magnitude < 2) then
            enabled_3 = not enabled_3
        end
    end)
end

function camera_input.disableCameraToggleInput()
    if not enabled_4 then
        return
    end

    enabled_4 = false

    if connection then
        connection:Disconnect()
        connection = nil
    end

    if connection_2 then
        connection_2:Disconnect()
        connection_2 = nil
    end
end

return camera_input
