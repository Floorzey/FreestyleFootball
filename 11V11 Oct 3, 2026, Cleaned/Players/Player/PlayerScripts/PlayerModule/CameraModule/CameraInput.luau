local context_action_service = game:GetService("ContextActionService")
local user_input_service = game:GetService("UserInputService")
local players = game:GetService("Players")
local run_service = game:GetService("RunService")
local user_game_settings = UserSettings():GetService("UserGameSettings")
local vr_service = game:GetService("VRService")
local get_user_flag_result =
    require(script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")).getUserFlag("UserCameraInputDt")
local local_player = players.LocalPlayer
local value = Enum.ContextActionPriority.Medium.Value
local vector = Vector2.new(1, 0.77)
local vector_offset = vector * 0.06981317007977318
local vector_offset_2 = Vector2.new(1, 0.77) * 0.008726646259971648
local vector_offset_3 = Vector2.new(1, 0.77) * 0.12217304763960307
local vector_offset_4 = Vector2.new(1, 0.66) * 0.017453292519943295
if get_user_flag_result then
    vector_offset *= 60
end
local success, value_2 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserResetTouchStateOnMenuOpen")
end)
local success_4 = success and value_2
local success_2, value_3 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserClearPanOnCameraDisable")
end)
local success_5 = success_2 and value_3
local success_3, value_4 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserFixGamepadSensitivity")
end)
local success_6 = success_3 and value_4
local bindable_event = Instance.new("BindableEvent")
local bindable_event_2 = Instance.new("BindableEvent")
local event = bindable_event.Event
local event_2 = bindable_event_2.Event
user_input_service.InputBegan:Connect(function(input, game_processed)
    if game_processed or input.UserInputType ~= Enum.UserInputType.MouseButton2 then
        return
    end
    bindable_event:Fire()
end)
user_input_service.InputEnded:Connect(function(input, game_processed)
    if input.UserInputType ~= Enum.UserInputType.MouseButton2 then
        return
    end
    bindable_event_2:Fire()
end)

local function adjust_touch_pitch_sensitivity(argument)
    local current_camera = workspace.CurrentCamera
    if not current_camera then
        return argument
    end
    local to_euler_angles_yxz_result = current_camera.CFrame:ToEulerAnglesYXZ()
    if argument.Y * to_euler_angles_yxz_result >= 0 then
        return argument
    end
    return Vector2.new(1, ((1 - (((math.abs(to_euler_angles_yxz_result) * 2) / math.pi) ^ 0.75)) * 0.75) + 0.25)
        * argument
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

local values = {}
values.Thumbstick2 = Vector2.new()
local values_2 = { I = 0, Right = 0, Left = 0, O = 0 }
local values_3 = { Pinch = 0, Wheel = 0 }
values_3.Movement = Vector2.new()
values_3.Pan = Vector2.new()
local values_4 = { Pinch = 0 }
values_4.Move = Vector2.new()
local bindable_event_3 = Instance.new("BindableEvent")
camera_input.gamepadZoomPress = bindable_event_3.Event
local bindable_event_4 = (vr_service.VREnabled and (Instance.new("BindableEvent"))) or nil
if vr_service.VREnabled then
    camera_input.gamepadReset = bindable_event_4.Event
end

function camera_input.getRotationActivated()
    local enabled_5 = true
    if not (number_2 > 0) then
        enabled_5 = values.Thumbstick2.Magnitude > 0
    end
    return enabled_5
end

function camera_input.getRotation(self, argument)
    local vector_2 = Vector2.new(1, user_game_settings:GetCameraYInvertValue())
    local get_user_flag_result_2 = (get_user_flag_result and (Vector2.new(values_2.Right - values_2.Left, 0) * self))
        or (Vector2.new(values_2.Right - values_2.Left, 0) * number)
    local thumbstick2 = (success_6 and (values.Thumbstick2 * user_game_settings.GamepadCameraSensitivity))
        or values.Thumbstick2
    thumbstick2 = (get_user_flag_result and (thumbstick2 * self)) or thumbstick2
    local movement = values_3.Movement
    local pan = values_3.Pan
    local result = adjust_touch_pitch_sensitivity(values_4.Move)
    if argument then
        get_user_flag_result_2 = Vector2.new()
    end
    return (
        (
            (
                ((get_user_flag_result_2 * 2.0943951023931953) + (thumbstick2 * vector_offset))
                + (movement * vector_offset_2)
            ) + (pan * vector_offset_3)
        ) + (result * vector_offset_4)
    ) * vector_2
end

function camera_input.getZoomDelta()
    return (((values_2.O - values_2.I) * 0.1) + ((-values_3.Wheel + values_3.Pinch) * 1)) + (-values_4.Pinch * 0.04)
end

local function thumbstick_curve(argument)
    local exp_result_offset_offset = (math.exp(((math.abs(argument) - 0.1) / 0.9) * 2) - 1) / 6.38905609893065
    return math.sign(argument) * math.clamp(exp_result_offset_offset, 0, 1)
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

local function gamepad_zoom_press(argument, argument_2, argument_3)
    if argument_2 ~= Enum.UserInputState.Begin then
        return
    end
    bindable_event_3:Fire()
end

local function reset_input_devices()
    for _, item in pairs({ values, values_2, values_3, values_4 }) do
        for key, item_2 in pairs(item) do
            if type(item_2) ~= "boolean" then
                item[key] = item[key] * 0
            else
                item[key] = false
            end
        end
    end
    if not success_5 then
        return
    end
    number_2 = 0
end

local values_5 = {}
local value_5 = nil
local value_6 = nil

local function is_in_dynamic_thumbstick_area(argument)
    local player_gui = local_player:FindFirstChildOfClass("PlayerGui")
    local touch_gui = player_gui and (player_gui:FindFirstChild("TouchGui"))
    local touch_control_frame = touch_gui and (touch_gui:FindFirstChild("TouchControlFrame"))
    local dynamic_thumbstick_frame = touch_control_frame
        and (touch_control_frame:FindFirstChild("DynamicThumbstickFrame"))
    if not dynamic_thumbstick_frame or not player_gui.Enabled then
        return false
    end
    local absolute_position = dynamic_thumbstick_frame.AbsolutePosition
    local absolute_position_offset = absolute_position + dynamic_thumbstick_frame.AbsoluteSize
    return (absolute_position.X <= argument.X)
        and (
            (absolute_position.Y <= argument.Y)
            and ((argument.X <= absolute_position_offset.X) and (argument.Y <= absolute_position_offset.Y))
        )
end

local function touch_began(input, argument)
    assert(input.UserInputType == Enum.UserInputType.Touch)
    assert(input.UserInputState == Enum.UserInputState.Begin)
    if value_5 == nil and is_in_dynamic_thumbstick_area(input.Position) then
        if argument then
            if not argument then
                number_2 = math.max(0, number_2 + 1)
            end
        else
            value_5 = input
            return
        end
    elseif not argument then
        number_2 = math.max(0, number_2 + 1)
    end
    values_5[input] = argument
end

local function touch_ended(input, argument)
    assert(input.UserInputType == Enum.UserInputType.Touch)
    assert(input.UserInputState == Enum.UserInputState.End)
    if input == value_5 then
        value_5 = nil
    end
    if values_5[input] == false then
        value_6 = nil
        number_2 = math.max(0, number_2 - 1)
    end
    values_5[input] = nil
end

local function touch_changed(input, argument)
    assert(input.UserInputType == Enum.UserInputType.Touch)
    assert(input.UserInputState == Enum.UserInputState.Change)
    if input == value_5 then
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
        value_6 = nil
    else
        local magnitude = (items_2[1].Position - items_2[2].Position).Magnitude
        if value_6 then
            values_4.Pinch = values_4.Pinch + (magnitude - value_6)
        end
        value_6 = magnitude
    end
end

local function reset_touch_state()
    values_5 = {}
    value_5 = nil
    value_6 = nil
    if not success_4 then
        return
    end
    number_2 = 0
end

local function input_began(input, argument)
    if input.UserInputType == Enum.UserInputType.Touch then
        touch_began(input, argument)
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 and not argument then
        number_2 = math.max(0, number_2 + 1)
    end
end

local function input_changed(input, argument)
    if input.UserInputType == Enum.UserInputType.Touch then
        touch_changed(input, argument)
    elseif input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Delta
        values_3.Movement = Vector2.new(delta.X, delta.Y)
    end
end

local function input_ended(input, argument)
    if input.UserInputType == Enum.UserInputType.Touch then
        touch_ended(input, argument)
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        number_2 = math.max(0, number_2 - 1)
    end
end

local enabled = false

local function gamepad_reset(argument, argument_2, argument_3)
    if argument_2 ~= Enum.UserInputState.Begin then
        return
    end
    bindable_event_4:Fire()
end

local function keypress(argument, argument_2, input)
    values_2[input.KeyCode.Name] = ((argument_2 ~= Enum.UserInputState.Begin) and 0) or 1
end

local function pointer_action(wheel, pan, argument, argument_2)
    if argument_2 then
        return
    end
    values_3.Wheel = wheel
    values_3.Pan = pan
    values_3.Pinch = -argument
end

function camera_input.setInputEnabled(self)
    if enabled == self then
        return
    end
    enabled = self
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
        if not success_4 then
            return
        end
        local gui_service = game:GetService("GuiService")
        table.insert(items, gui_service.MenuOpened:connect(reset_touch_state))
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
    local enabled_5 = enabled_3 or enabled_2
    return enabled_5
end

function camera_input.setTogglePan(self)
    enabled_3 = self
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
    local connection_3 = event:Connect(function()
        enabled_2 = true
        number_3 = tick()
    end)
    connection = connection_3
    local connection_4 = event_2:Connect(function()
        enabled_2 = false
        if
            not (tick() - number_3 < 0.3)
            or not enabled_3 and not (user_input_service:GetMouseDelta().Magnitude < 2)
        then
            return
        end
        enabled_3 = not enabled_3
    end)
    connection_2 = connection_4
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
