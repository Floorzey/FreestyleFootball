local user_input_service = game:GetService("UserInputService")
local context_action_service = game:GetService("ContextActionService")
local get_user_flag_result =
    require(script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")).getUserFlag(
        "UserUpdateInputConnections"
    )
local vector = Vector3.new()
local base_character_controller = require(script.Parent:WaitForChild("BaseCharacterController"))
local keyboard = setmetatable({}, base_character_controller)
keyboard.__index = keyboard

function keyboard.new(control_action_priority)
    local instance = setmetatable(base_character_controller.new(), keyboard)
    instance.CONTROL_ACTION_PRIORITY = control_action_priority
    if not get_user_flag_result then
        instance.textFocusReleasedConn = nil
        instance.textFocusGainedConn = nil
        instance.windowFocusReleasedConn = nil
    end
    instance.forwardValue = 0
    instance.backwardValue = 0
    instance.leftValue = 0
    instance.rightValue = 0
    instance.jumpEnabled = true
    return instance
end

function keyboard.Enable(self, enabled)
    if not get_user_flag_result and not user_input_service.KeyboardEnabled then
        return false
    end
    if enabled ~= self.enabled then
        self.forwardValue = 0
        self.backwardValue = 0
        self.leftValue = 0
        self.rightValue = 0
        self.moveVector = vector
        self.jumpRequested = false
        self:UpdateJump()
        if enabled then
            self:BindContextActions()
            self:ConnectFocusEventListeners()
        elseif get_user_flag_result then
            self._connections:disconnectAll()
        else
            self:UnbindContextActions()
            self:DisconnectFocusEventListeners()
        end
        self.enabled = enabled
    end
    return true
end

function keyboard.UpdateMovement(self, argument)
    if argument ~= Enum.UserInputState.Cancel then
        self.moveVector = Vector3.new(self.leftValue + self.rightValue, 0, self.forwardValue + self.backwardValue)
    else
        self.moveVector = vector
    end
end

function keyboard.UpdateJump(self)
    self.isJumping = self.jumpRequested
end

function keyboard.BindContextActions(self)
    context_action_service:BindActionAtPriority("moveForwardAction", function(argument, argument_2, argument_3)
        self.forwardValue = ((argument_2 ~= Enum.UserInputState.Begin) and 0) or -1
        self:UpdateMovement(argument_2)
        return Enum.ContextActionResult.Pass
    end, false, self.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterForward)
    context_action_service:BindActionAtPriority("moveBackwardAction", function(argument, argument_2, argument_3)
        self.backwardValue = ((argument_2 ~= Enum.UserInputState.Begin) and 0) or 1
        self:UpdateMovement(argument_2)
        return Enum.ContextActionResult.Pass
    end, false, self.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterBackward)
    context_action_service:BindActionAtPriority("moveLeftAction", function(argument, argument_2, argument_3)
        self.leftValue = ((argument_2 ~= Enum.UserInputState.Begin) and 0) or -1
        self:UpdateMovement(argument_2)
        return Enum.ContextActionResult.Pass
    end, false, self.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterLeft)
    context_action_service:BindActionAtPriority("moveRightAction", function(argument, argument_2, argument_3)
        self.rightValue = ((argument_2 ~= Enum.UserInputState.Begin) and 0) or 1
        self:UpdateMovement(argument_2)
        return Enum.ContextActionResult.Pass
    end, false, self.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterRight)
    context_action_service:BindActionAtPriority("jumpAction", function(argument, argument_2, argument_3)
        self.jumpRequested = self.jumpEnabled and (argument_2 == Enum.UserInputState.Begin)
        self:UpdateJump()
        return Enum.ContextActionResult.Pass
    end, false, self.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterJump)
    if not get_user_flag_result then
        return
    end
    self._connections:connectManual("moveForwardAction", function()
        context_action_service:UnbindAction("moveForwardAction")
    end)
    self._connections:connectManual("moveBackwardAction", function()
        context_action_service:UnbindAction("moveBackwardAction")
    end)
    self._connections:connectManual("moveLeftAction", function()
        context_action_service:UnbindAction("moveLeftAction")
    end)
    self._connections:connectManual("moveRightAction", function()
        context_action_service:UnbindAction("moveRightAction")
    end)
    self._connections:connectManual("jumpAction", function()
        context_action_service:UnbindAction("jumpAction")
    end)
end

function keyboard.UnbindContextActions(self)
    context_action_service:UnbindAction("moveForwardAction")
    context_action_service:UnbindAction("moveBackwardAction")
    context_action_service:UnbindAction("moveLeftAction")
    context_action_service:UnbindAction("moveRightAction")
    context_action_service:UnbindAction("jumpAction")
end

function keyboard.ConnectFocusEventListeners(self)
    local function on_text_focus_gained(argument)
        self.jumpRequested = false
        self:UpdateJump()
    end
    local function on_focus_released()
        self.moveVector = vector
        self.forwardValue = 0
        self.backwardValue = 0
        self.leftValue = 0
        self.rightValue = 0
        self.jumpRequested = false
        self:UpdateJump()
    end
    if get_user_flag_result then
        self._connections:connect("textBoxFocusReleased", user_input_service.TextBoxFocusReleased, on_focus_released)
        self._connections:connect("textBoxFocused", user_input_service.TextBoxFocused, on_text_focus_gained)
        self._connections:connect("windowFocusReleased", user_input_service.WindowFocused, on_focus_released)
    else
        self.textFocusReleasedConn = user_input_service.TextBoxFocusReleased:Connect(on_focus_released)
        self.textFocusGainedConn = user_input_service.TextBoxFocused:Connect(on_text_focus_gained)
        self.windowFocusReleasedConn = user_input_service.WindowFocused:Connect(on_focus_released)
    end
end

function keyboard.DisconnectFocusEventListeners(self)
    if self.textFocusReleasedConn then
        self.textFocusReleasedConn:Disconnect()
        self.textFocusReleasedConn = nil
    end
    if self.textFocusGainedConn then
        self.textFocusGainedConn:Disconnect()
        self.textFocusGainedConn = nil
    end
    if not self.windowFocusReleasedConn then
        return
    end
    self.windowFocusReleasedConn:Disconnect()
    self.windowFocusReleasedConn = nil
end

return keyboard
