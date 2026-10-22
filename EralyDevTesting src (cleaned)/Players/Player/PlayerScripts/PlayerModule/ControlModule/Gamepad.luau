local user_input_service = game:GetService("UserInputService")
local context_action_service = game:GetService("ContextActionService")
local common_utils = script.Parent.Parent:WaitForChild("CommonUtils")
local user_flag = require(common_utils:WaitForChild("FlagUtil")).getUserFlag("UserUpdateInputConnections")
local none = Enum.UserInputType.None
local base_character_controller = require(script.Parent:WaitForChild("BaseCharacterController"))
local gamepad = setmetatable({}, base_character_controller)
gamepad.__index = gamepad

function gamepad.new(control_action_priority)
    local base_character_controller_2 = base_character_controller.new()
    local instance = setmetatable(base_character_controller_2, gamepad)
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

function gamepad.Enable(argument: table, enabled: boolean)
    if not (user_flag or user_input_service.GamepadEnabled) then
        return false
    end

    if enabled == argument.enabled then
        return true
    end

    argument.forwardValue = 0
    argument.backwardValue = 0
    argument.leftValue = 0
    argument.rightValue = 0
    argument.moveVector = Vector3.new(0, 0, 0)
    argument.isJumping = false

    if enabled then
        argument.activeGamepad = argument:GetHighestPriorityGamepad()

        if argument.activeGamepad == none then
            return false
        end

        argument:BindContextActions()
        argument:ConnectGamepadConnectionListeners()
    else
        argument:UnbindContextActions()
        argument:DisconnectGamepadConnectionListeners()
        argument.activeGamepad = none
    end

    argument.enabled = enabled

    return true
end

function gamepad.GetHighestPriorityGamepad(argument)
    local connected_gamepads = user_input_service:GetConnectedGamepads()
    local none_2 = none

    for _, item in pairs(connected_gamepads) do
        if item.Value < none_2.Value then
            none_2 = item
        end
    end

    return none_2
end

function gamepad.BindContextActions(argument)
    if argument.activeGamepad == none then
        return false
    end

    context_action_service:BindActivate(argument.activeGamepad, Enum.KeyCode.ButtonR2)

    context_action_service:BindActionAtPriority("jumpAction", function(argument_2, argument_3, argument_4)
        argument.isJumping = argument_3 == Enum.UserInputState.Begin

        return Enum.ContextActionResult.Sink
    end, false, argument.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonA)

    context_action_service:BindActionAtPriority("moveThumbstick", function(argument_2, argument_3, input)
        if argument_3 == Enum.UserInputState.Cancel then
            argument.moveVector = Vector3.new(0, 0, 0)

            return Enum.ContextActionResult.Sink
        end

        if argument.activeGamepad ~= input.UserInputType then
            return Enum.ContextActionResult.Pass
        end

        if input.KeyCode ~= Enum.KeyCode.Thumbstick1 then
            return
        end

        if input.Position.magnitude > 0.2 then
            argument.moveVector = Vector3.new(input.Position.X, 0, -input.Position.Y)
        else
            argument.moveVector = Vector3.new(0, 0, 0)
        end

        return Enum.ContextActionResult.Sink
    end, false, argument.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Thumbstick1)

    return true
end

function gamepad.UnbindContextActions(argument)
    if argument.activeGamepad ~= none then
        context_action_service:UnbindActivate(argument.activeGamepad, Enum.KeyCode.ButtonR2)
    end

    context_action_service:UnbindAction("moveThumbstick")
    context_action_service:UnbindAction("jumpAction")
end

function gamepad.OnNewGamepadConnected(argument)
    local highest_priority_gamepad = argument:GetHighestPriorityGamepad()

    if highest_priority_gamepad == argument.activeGamepad then
        return
    end

    if highest_priority_gamepad == none then
        warn("Gamepad:OnNewGamepadConnected found no connected gamepads")
        argument:UnbindContextActions()

        return
    end

    if argument.activeGamepad ~= none then
        argument:UnbindContextActions()
    end

    argument.activeGamepad = highest_priority_gamepad
    argument:BindContextActions()
end

function gamepad.OnCurrentGamepadDisconnected(argument)
    if argument.activeGamepad ~= none then
        context_action_service:UnbindActivate(argument.activeGamepad, Enum.KeyCode.ButtonR2)
    end

    local highest_priority_gamepad = argument:GetHighestPriorityGamepad()

    if argument.activeGamepad == none or highest_priority_gamepad ~= argument.activeGamepad then
        if highest_priority_gamepad == none then
            argument:UnbindContextActions()
            argument.activeGamepad = none

            return
        end

        argument.activeGamepad = highest_priority_gamepad
        context_action_service:BindActivate(argument.activeGamepad, Enum.KeyCode.ButtonR2)

        return
    end

    warn("Gamepad:OnCurrentGamepadDisconnected found the supposedly disconnected gamepad in connectedGamepads.")
    argument:UnbindContextActions()
    argument.activeGamepad = none
end

function gamepad.ConnectGamepadConnectionListeners(argument)
    argument.gamepadConnectedConn = user_input_service.GamepadConnected:Connect(function(argument_2)
        argument:OnNewGamepadConnected()
    end)
    argument.gamepadDisconnectedConn = user_input_service.GamepadDisconnected:Connect(function(argument_2)
        if argument.activeGamepad == argument_2 then
            argument:OnCurrentGamepadDisconnected()
        end
    end)
end

function gamepad.DisconnectGamepadConnectionListeners(argument)
    if argument.gamepadConnectedConn then
        argument.gamepadConnectedConn:Disconnect()
        argument.gamepadConnectedConn = nil
    end

    if argument.gamepadDisconnectedConn then
        argument.gamepadDisconnectedConn:Disconnect()
        argument.gamepadDisconnectedConn = nil
    end
end

return gamepad
