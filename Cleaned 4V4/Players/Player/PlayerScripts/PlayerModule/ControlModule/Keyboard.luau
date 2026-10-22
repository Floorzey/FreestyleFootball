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

function keyboard.Enable(argument, enabled)
    if not get_user_flag_result and not user_input_service.KeyboardEnabled then
        return false
    end

    if enabled == argument.enabled then
        return true
    end

    argument.forwardValue = 0
    argument.backwardValue = 0
    argument.leftValue = 0
    argument.rightValue = 0
    argument.moveVector = vector
    argument.jumpRequested = false
    argument:UpdateJump()

    if enabled then
        argument:BindContextActions()
        argument:ConnectFocusEventListeners()
    elseif get_user_flag_result then
        argument._connections:disconnectAll()
    else
        argument:UnbindContextActions()
        argument:DisconnectFocusEventListeners()
    end

    argument.enabled = enabled

    return true
end

function keyboard.UpdateMovement(argument, argument_2)
    if argument_2 ~= Enum.UserInputState.Cancel then
        argument.moveVector =
            Vector3.new(argument.leftValue + argument.rightValue, 0, argument.forwardValue + argument.backwardValue)
    else
        argument.moveVector = vector
    end
end

function keyboard.UpdateJump(argument)
    argument.isJumping = argument.jumpRequested
end

function keyboard.BindContextActions(argument)
    context_action_service:BindActionAtPriority("moveForwardAction", function(argument_2, argument_3, argument_4)
        argument.forwardValue = ((argument_3 ~= Enum.UserInputState.Begin) and 0) or -1
        argument:UpdateMovement(argument_3)

        return Enum.ContextActionResult.Pass
    end, false, argument.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterForward)

    context_action_service:BindActionAtPriority("moveBackwardAction", function(argument_2, argument_3, argument_4)
        argument.backwardValue = ((argument_3 ~= Enum.UserInputState.Begin) and 0) or 1
        argument:UpdateMovement(argument_3)

        return Enum.ContextActionResult.Pass
    end, false, argument.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterBackward)

    context_action_service:BindActionAtPriority("moveLeftAction", function(argument_2, argument_3, argument_4)
        argument.leftValue = ((argument_3 ~= Enum.UserInputState.Begin) and 0) or -1
        argument:UpdateMovement(argument_3)

        return Enum.ContextActionResult.Pass
    end, false, argument.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterLeft)

    context_action_service:BindActionAtPriority("moveRightAction", function(argument_2, argument_3, argument_4)
        argument.rightValue = ((argument_3 ~= Enum.UserInputState.Begin) and 0) or 1
        argument:UpdateMovement(argument_3)

        return Enum.ContextActionResult.Pass
    end, false, argument.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterRight)

    context_action_service:BindActionAtPriority("jumpAction", function(argument_2, argument_3, argument_4)
        argument.jumpRequested = argument.jumpEnabled and (argument_3 == Enum.UserInputState.Begin)
        argument:UpdateJump()

        return Enum.ContextActionResult.Pass
    end, false, argument.CONTROL_ACTION_PRIORITY, Enum.PlayerActions.CharacterJump)

    if not get_user_flag_result then
        return
    end

    argument._connections:connectManual("moveForwardAction", function()
        context_action_service:UnbindAction("moveForwardAction")
    end)

    argument._connections:connectManual("moveBackwardAction", function()
        context_action_service:UnbindAction("moveBackwardAction")
    end)

    argument._connections:connectManual("moveLeftAction", function()
        context_action_service:UnbindAction("moveLeftAction")
    end)

    argument._connections:connectManual("moveRightAction", function()
        context_action_service:UnbindAction("moveRightAction")
    end)

    argument._connections:connectManual("jumpAction", function()
        context_action_service:UnbindAction("jumpAction")
    end)
end

function keyboard.UnbindContextActions(argument)
    context_action_service:UnbindAction("moveForwardAction")
    context_action_service:UnbindAction("moveBackwardAction")
    context_action_service:UnbindAction("moveLeftAction")
    context_action_service:UnbindAction("moveRightAction")
    context_action_service:UnbindAction("jumpAction")
end

function keyboard.ConnectFocusEventListeners(argument)
    local function on_text_focus_gained(argument_2)
        argument.jumpRequested = false
        argument:UpdateJump()
    end

    local function on_focus_released()
        argument.moveVector = vector
        argument.forwardValue = 0
        argument.backwardValue = 0
        argument.leftValue = 0
        argument.rightValue = 0
        argument.jumpRequested = false
        argument:UpdateJump()
    end

    if get_user_flag_result then
        argument._connections:connect(
            "textBoxFocusReleased",
            user_input_service.TextBoxFocusReleased,
            on_focus_released
        )
        argument._connections:connect("textBoxFocused", user_input_service.TextBoxFocused, on_text_focus_gained)
        argument._connections:connect("windowFocusReleased", user_input_service.WindowFocused, on_focus_released)
    else
        argument.textFocusReleasedConn = user_input_service.TextBoxFocusReleased:Connect(on_focus_released)
        argument.textFocusGainedConn = user_input_service.TextBoxFocused:Connect(on_text_focus_gained)
        argument.windowFocusReleasedConn = user_input_service.WindowFocused:Connect(on_focus_released)
    end
end

function keyboard.DisconnectFocusEventListeners(argument)
    if argument.textFocusReleasedConn then
        argument.textFocusReleasedConn:Disconnect()
        argument.textFocusReleasedConn = nil
    end

    if argument.textFocusGainedConn then
        argument.textFocusGainedConn:Disconnect()
        argument.textFocusGainedConn = nil
    end

    if not argument.windowFocusReleasedConn then
        return
    end

    argument.windowFocusReleasedConn:Disconnect()
    argument.windowFocusReleasedConn = nil
end

return keyboard
