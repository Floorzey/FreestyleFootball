local common_utils = script.Parent.Parent:WaitForChild("CommonUtils")
local flag_util = require(common_utils:WaitForChild("FlagUtil"))
local value = Enum.ContextActionPriority.Medium.Value
local players = game:GetService("Players")
local context_action_service = game:GetService("ContextActionService")
local game_settings = UserSettings().GameSettings
local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
local user_flag = flag_util.getUserFlag("UserFixCameraOffsetJitter2")
local mouse_lock_controller = {}
mouse_lock_controller.__index = mouse_lock_controller

function mouse_lock_controller.new()
    local instance = setmetatable({}, mouse_lock_controller)
    instance.isMouseLocked = false
    instance.savedMouseCursor = nil
    instance.boundKeys = { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift }
    instance.mouseLockToggledEvent = Instance.new("BindableEvent")
    local bound_keys = script:FindFirstChild("BoundKeys")

    if not (bound_keys and bound_keys:IsA("StringValue")) then
        if bound_keys then
            bound_keys:Destroy()
        end

        bound_keys = Instance.new("StringValue")
        assert(bound_keys, "")
        bound_keys.Name = "BoundKeys"
        bound_keys.Value = "LeftShift,RightShift"
        bound_keys.Parent = script
    end

    if bound_keys then
        bound_keys.Changed:Connect(function(argument)
            instance:OnBoundKeysObjectChanged(argument)
        end)

        instance:OnBoundKeysObjectChanged(bound_keys.Value)
    end

    game_settings.Changed:Connect(function(argument)
        if argument == "ControlMode" or argument == "ComputerMovementMode" then
            instance:UpdateMouseLockAvailability()
        end
    end)

    players.LocalPlayer:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function()
        instance:UpdateMouseLockAvailability()
    end)

    players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function()
        instance:UpdateMouseLockAvailability()
    end)

    instance:UpdateMouseLockAvailability()

    return instance
end

function mouse_lock_controller.GetIsMouseLocked(argument)
    return argument.isMouseLocked
end

function mouse_lock_controller.GetBindableToggleEvent(argument)
    return argument.mouseLockToggledEvent.Event
end

function mouse_lock_controller.GetMouseLockOffset(argument)
    if user_flag then
        return Vector3.new(1.75, 0, 0)
    end

    local camera_offset = script:FindFirstChild("CameraOffset")

    if camera_offset and camera_offset:IsA("Vector3Value") then
        return camera_offset.Value
    end

    if camera_offset then
        camera_offset:Destroy()
    end

    local vector3_value = Instance.new("Vector3Value")
    assert(vector3_value, "")
    vector3_value.Name = "CameraOffset"
    vector3_value.Value = Vector3.new(1.75, 0, 0)
    vector3_value.Parent = script

    return not (vector3_value and vector3_value.Value) and Vector3.new(1.75, 0, 0) or vector3_value.Value
end

function mouse_lock_controller.UpdateMouseLockAvailability(argument)
    local condition = players.LocalPlayer.DevEnableMouseLock
        and (game_settings.ControlMode == Enum.ControlMode.MouseLockSwitch and game_settings.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove)
        and not (players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable)

    if condition ~= argument.enabled then
        argument:EnableMouseLock(condition)
    end
end

function mouse_lock_controller.OnBoundKeysObjectChanged(argument: table, argument_2: string)
    argument.boundKeys = {}

    for key in string.gmatch(argument_2, "[^%s,]+") do
        local key_2 = key

        for _, item in pairs(Enum.KeyCode:GetEnumItems()) do
            if key_2 == item.Name then
                argument.boundKeys[#argument.boundKeys + 1] = item
                break
            end
        end
    end

    argument:UnbindContextActions()
    argument:BindContextActions()
end

function mouse_lock_controller.OnMouseLockToggled(argument)
    argument.isMouseLocked = not argument.isMouseLocked

    if argument.isMouseLocked then
        local cursor_image = script:FindFirstChild("CursorImage")

        if cursor_image and (cursor_image:IsA("StringValue") and cursor_image.Value) then
            camera_utils.setMouseIconOverride(cursor_image.Value)
        else
            if cursor_image then
                cursor_image:Destroy()
            end

            local cursor_image_2 = Instance.new("StringValue")
            assert(cursor_image_2, "")
            cursor_image_2.Name = "CursorImage"
            cursor_image_2.Value = "rbxasset://textures/MouseLockedCursor.png"
            cursor_image_2.Parent = script
            camera_utils.setMouseIconOverride("rbxasset://textures/MouseLockedCursor.png")
        end
    else
        camera_utils.restoreMouseIcon()
    end

    argument.mouseLockToggledEvent:Fire()
end

function mouse_lock_controller.DoMouseLockSwitch(argument, argument_2, argument_3, argument_4)
    if argument_3 ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Pass
    end

    argument:OnMouseLockToggled()

    return Enum.ContextActionResult.Sink
end

function mouse_lock_controller.BindContextActions(argument)
    context_action_service:BindActionAtPriority("MouseLockSwitchAction", function(argument_2, argument_3, argument_4)
        return argument:DoMouseLockSwitch(argument_2, argument_3, argument_4)
    end, false, value, unpack(argument.boundKeys))
end

function mouse_lock_controller.UnbindContextActions(argument)
    context_action_service:UnbindAction("MouseLockSwitchAction")
end

function mouse_lock_controller.IsMouseLocked(argument)
    return argument.enabled and argument.isMouseLocked
end

function mouse_lock_controller.EnableMouseLock(argument: table, enabled: boolean)
    if enabled == argument.enabled then
        return
    end

    argument.enabled = enabled

    if argument.enabled then
        argument:BindContextActions()

        return
    end

    camera_utils.restoreMouseIcon()
    argument:UnbindContextActions()

    if argument.isMouseLocked then
        argument.mouseLockToggledEvent:Fire()
    end

    argument.isMouseLocked = false
end

return mouse_lock_controller
