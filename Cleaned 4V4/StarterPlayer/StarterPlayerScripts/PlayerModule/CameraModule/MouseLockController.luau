local flag_util = require(script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil"))
local value = Enum.ContextActionPriority.Medium.Value
local players = game:GetService("Players")
local context_action_service = game:GetService("ContextActionService")
local game_settings = UserSettings().GameSettings
local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
local get_user_flag_result = flag_util.getUserFlag("UserFixCameraOffsetJitter2")
local mouse_lock_controller = {}
mouse_lock_controller.__index = mouse_lock_controller

function mouse_lock_controller.new()
    local instance = setmetatable({}, mouse_lock_controller)
    instance.isMouseLocked = false
    instance.savedMouseCursor = nil
    instance.boundKeys = { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift }
    instance.mouseLockToggledEvent = Instance.new("BindableEvent")
    local bound_keys = script:FindFirstChild("BoundKeys")

    if not bound_keys or not (bound_keys:IsA("StringValue")) then
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
        if argument ~= "ControlMode" and argument ~= "ComputerMovementMode" then
            return
        end

        instance:UpdateMouseLockAvailability()
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
    if get_user_flag_result then
        return Vector3.new(1.75, 0, 0)
    end

    local camera_offset = script:FindFirstChild("CameraOffset")

    if camera_offset and camera_offset:IsA("Vector3Value") then
        return camera_offset.Value
    end

    if camera_offset then
        camera_offset:Destroy()
    end

    local camera_offset_2 = Instance.new("Vector3Value")
    assert(camera_offset_2, "")
    camera_offset_2.Name = "CameraOffset"
    camera_offset_2.Value = Vector3.new(1.75, 0, 0)
    camera_offset_2.Parent = script

    if camera_offset_2 and camera_offset_2.Value then
        return camera_offset_2.Value
    end

    return Vector3.new(1.75, 0, 0)
end

function mouse_lock_controller.UpdateMouseLockAvailability(argument)
    local dev_enable_mouse_lock = players.LocalPlayer.DevEnableMouseLock
    local condition = players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
    local condition_2 = game_settings.ControlMode == Enum.ControlMode.MouseLockSwitch
    local condition_3 = dev_enable_mouse_lock
        and (
            condition_2
            and (game_settings.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove and not condition)
        )

    if condition_3 == argument.enabled then
        return
    end

    argument:EnableMouseLock(condition_3)
end

function mouse_lock_controller.OnBoundKeysObjectChanged(argument, argument_2)
    argument.boundKeys = {}

    for key in string.gmatch(argument_2, "[^%s,]+") do
        for _, item in pairs(Enum.KeyCode:GetEnumItems()) do
            if key == item.Name then
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
    local instance = nil

    if argument.isMouseLocked then
        instance = script:FindFirstChild("CursorImage")

        if instance and instance:IsA("StringValue") and instance.Value then
            camera_utils.setMouseIconOverride(instance.Value)
        else
            if instance then
                instance:Destroy()
            end

            local cursor_image = Instance.new("StringValue")
            assert(cursor_image, "")
            cursor_image.Name = "CursorImage"
            cursor_image.Value = "rbxasset://textures/MouseLockedCursor.png"
            cursor_image.Parent = script
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

function mouse_lock_controller.EnableMouseLock(argument, enabled)
    if enabled == argument.enabled then
        return
    end

    argument.enabled = enabled

    if argument.enabled then
        argument:BindContextActions()
    else
        camera_utils.restoreMouseIcon()
        argument:UnbindContextActions()

        if argument.isMouseLocked then
            argument.mouseLockToggledEvent:Fire()
        end

        argument.isMouseLocked = false
    end
end

return mouse_lock_controller
