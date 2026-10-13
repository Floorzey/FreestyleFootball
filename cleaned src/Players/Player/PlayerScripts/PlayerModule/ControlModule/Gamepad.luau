local user_input_service = game:GetService("UserInputService")
local context_action_service = game:GetService("ContextActionService")
local get_user_flag_result =
    require(script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")).getUserFlag(
        "UserUpdateInputConnections"
    )
local none = Enum.UserInputType.None
local base_character_controller = require(script.Parent:WaitForChild("BaseCharacterController"))
local gamepad = setmetatable({}, base_character_controller)
gamepad.__index = gamepad

function gamepad.new(control_action_priority)
    local instance = setmetatable(base_character_controller.new(), gamepad)
    instance.CONTROL_ACTION_PRIORITY = control_action_priority
    instance.forwardValue = 0
    instance.backwardValue = 0
    instance.leftValue = 0
    instance.rightValue = 0
    instance.activeGamepad = none
    instance.gamepadConnectedConn = nil
    instance.gamepadDisconnectedConn = nil
    return instance
end

function gamepad.Enable(self, enabled)
    if not get_user_flag_result and not user_input_service.GamepadEnabled then
        return false
    end
    if enabled ~= self.enabled then
        self.forwardValue = 0
        self.backwardValue = 0
        self.leftValue = 0
        self.rightValue = 0
        self.moveVector = Vector3.new(0, 0, 0)
        self.isJumping = false
        if enabled then
            self.activeGamepad = self:GetHighestPriorityGamepad()
            if self.activeGamepad == none then
                return false
            end
            self:BindContextActions()
            self:ConnectGamepadConnectionListeners()
        else
            self:UnbindContextActions()
            self:DisconnectGamepadConnectionListeners()
            self.activeGamepad = none
        end
        self.enabled = enabled
    end
    return true
end

function gamepad.GetHighestPriorityGamepad(self)
    for _, item in pairs(user_input_service:GetConnectedGamepads()) do
        if not (item.Value < none.Value) then
            continue
        end
    end
    return none
end

function gamepad.BindContextActions(self)
    if self.activeGamepad ~= none then
        context_action_service:BindActivate(self.activeGamepad, Enum.KeyCode.ButtonR2)
        context_action_service:BindActionAtPriority("jumpAction", function(argument, argument_2, argument_3)
            self.isJumping = argument_2 == Enum.UserInputState.Begin
            return Enum.ContextActionResult.Sink
        end, false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonA)
        context_action_service:BindActionAtPriority("moveThumbstick", function(argument, argument_2, input)
            if argument_2 == Enum.UserInputState.Cancel then
                self.moveVector = Vector3.new(0, 0, 0)
                return Enum.ContextActionResult.Sink
            elseif self.activeGamepad == input.UserInputType then
                if input.KeyCode == Enum.KeyCode.Thumbstick1 then
                    if input.Position.magnitude > 0.2 then
                        self.moveVector = Vector3.new(input.Position.X, 0, -input.Position.Y)
                    else
                        self.moveVector = Vector3.new(0, 0, 0)
                    end
                    return Enum.ContextActionResult.Sink
                end
            else
                return Enum.ContextActionResult.Pass
            end
        end, false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Thumbstick1)
        return true
    end
    return false
end

function gamepad.UnbindContextActions(self)
    if self.activeGamepad ~= none then
        context_action_service:UnbindActivate(self.activeGamepad, Enum.KeyCode.ButtonR2)
    end
    context_action_service:UnbindAction("moveThumbstick")
    context_action_service:UnbindAction("jumpAction")
end

function gamepad.OnNewGamepadConnected(self)
    local active_gamepad = self:GetHighestPriorityGamepad()
    if active_gamepad == self.activeGamepad then
        return
    end
    if active_gamepad ~= none then
        if self.activeGamepad ~= none then
            self:UnbindContextActions()
        end
        self.activeGamepad = active_gamepad
        self:BindContextActions()
    else
        warn("Gamepad:OnNewGamepadConnected found no connected gamepads")
        self:UnbindContextActions()
    end
end

function gamepad.OnCurrentGamepadDisconnected(self)
    if self.activeGamepad ~= none then
        context_action_service:UnbindActivate(self.activeGamepad, Enum.KeyCode.ButtonR2)
    end
    local active_gamepad = self:GetHighestPriorityGamepad()
    if self.activeGamepad == none or active_gamepad ~= self.activeGamepad then
        if active_gamepad ~= none then
            self.activeGamepad = active_gamepad
            context_action_service:BindActivate(self.activeGamepad, Enum.KeyCode.ButtonR2)
        else
            self:UnbindContextActions()
            self.activeGamepad = none
        end
    end
    warn("Gamepad:OnCurrentGamepadDisconnected found the supposedly disconnected gamepad in connectedGamepads.")
    self:UnbindContextActions()
    self.activeGamepad = none
end

function gamepad.ConnectGamepadConnectionListeners(self)
    self.gamepadConnectedConn = user_input_service.GamepadConnected:Connect(function(argument)
        self:OnNewGamepadConnected()
    end)
    self.gamepadDisconnectedConn = user_input_service.GamepadDisconnected:Connect(function(argument)
        if self.activeGamepad ~= argument then
            return
        end
        self:OnCurrentGamepadDisconnected()
    end)
end

function gamepad.DisconnectGamepadConnectionListeners(self)
    if self.gamepadConnectedConn then
        self.gamepadConnectedConn:Disconnect()
        self.gamepadConnectedConn = nil
    end
    if not self.gamepadDisconnectedConn then
        return
    end
    self.gamepadDisconnectedConn:Disconnect()
    self.gamepadDisconnectedConn = nil
end

return gamepad
