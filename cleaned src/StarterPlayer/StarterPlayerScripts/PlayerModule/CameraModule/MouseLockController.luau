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

function mouse_lock_controller.GetIsMouseLocked(self)
    return self.isMouseLocked
end

function mouse_lock_controller.GetBindableToggleEvent(self)
    return self.mouseLockToggledEvent.Event
end

function mouse_lock_controller.GetMouseLockOffset(self)
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
    local vector3_value = Instance.new("Vector3Value")
    assert(vector3_value, "")
    vector3_value.Name = "CameraOffset"
    vector3_value.Value = Vector3.new(1.75, 0, 0)
    vector3_value.Parent = script
    if vector3_value and vector3_value.Value then
        return vector3_value.Value
    end
    return Vector3.new(1.75, 0, 0)
end

function mouse_lock_controller.UpdateMouseLockAvailability(self)
    local dev_enable_mouse_lock = players.LocalPlayer.DevEnableMouseLock
    local is_dev_computer_movement_mode = players.LocalPlayer.DevComputerMovementMode
        == Enum.DevComputerMovementMode.Scriptable
    local is_control_mode = game_settings.ControlMode == Enum.ControlMode.MouseLockSwitch
    local dev_enable_mouse_lock_2 = dev_enable_mouse_lock
        and (
            is_control_mode
            and (
                game_settings.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove
                and not is_dev_computer_movement_mode
            )
        )
    if dev_enable_mouse_lock_2 == self.enabled then
        return
    end
    self:EnableMouseLock(dev_enable_mouse_lock_2)
end

function mouse_lock_controller.OnBoundKeysObjectChanged(self, argument)
    self.boundKeys = {}
    for key in string.gmatch(argument, "[^%s,]+") do
        for _, item in pairs(Enum.KeyCode:GetEnumItems()) do
            if key == item.Name then
                self.boundKeys[#self.boundKeys + 1] = item
                break
            end
        end
    end
    self:UnbindContextActions()
    self:BindContextActions()
end

function mouse_lock_controller.OnMouseLockToggled(self)
    self.isMouseLocked = not self.isMouseLocked
    local instance = nil
    if self.isMouseLocked then
        instance = script:FindFirstChild("CursorImage")
        if instance and instance:IsA("StringValue") and instance.Value then
            camera_utils.setMouseIconOverride(instance.Value)
        else
            if instance then
                instance:Destroy()
            end
            local string_value = Instance.new("StringValue")
            assert(string_value, "")
            string_value.Name = "CursorImage"
            string_value.Value = "rbxasset://textures/MouseLockedCursor.png"
            string_value.Parent = script
            camera_utils.setMouseIconOverride("rbxasset://textures/MouseLockedCursor.png")
        end
    else
        camera_utils.restoreMouseIcon()
    end
    self.mouseLockToggledEvent:Fire()
end

function mouse_lock_controller.DoMouseLockSwitch(self, argument, argument_2, argument_3)
    if argument_2 ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Pass
    end
    self:OnMouseLockToggled()
    return Enum.ContextActionResult.Sink
end

function mouse_lock_controller.BindContextActions(self)
    context_action_service:BindActionAtPriority("MouseLockSwitchAction", function(argument, argument_2, argument_3)
        return self:DoMouseLockSwitch(argument, argument_2, argument_3)
    end, false, value, unpack(self.boundKeys))
end

function mouse_lock_controller.UnbindContextActions(self)
    context_action_service:UnbindAction("MouseLockSwitchAction")
end

function mouse_lock_controller.IsMouseLocked(self)
    return self.enabled and self.isMouseLocked
end

function mouse_lock_controller.EnableMouseLock(self, enabled)
    if enabled == self.enabled then
        return
    end
    self.enabled = enabled
    if self.enabled then
        self:BindContextActions()
    else
        camera_utils.restoreMouseIcon()
        self:UnbindContextActions()
        if self.isMouseLocked then
            self.mouseLockToggledEvent:Fire()
        end
        self.isMouseLocked = false
    end
end

return mouse_lock_controller
