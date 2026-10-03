--[[
    Script Path: Game/Players/Player/PlayerScripts/PlayerModule/ControlModule/Gamepad
    Class: ModuleScript
    Time: 2026-10-03 12:27:02
--]]

local UserInputService_upv_1 = game:GetService("UserInputService")
local ContextActionService_upv_1 = game:GetService("ContextActionService")
local u1 = require(script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")).getUserFlag("UserUpdateInputConnections")
local None_upv_1 = Enum.UserInputType.None
local BaseCharacterController_upv_1 = require(script.Parent:WaitForChild("BaseCharacterController"))
local u2 = setmetatable({}, BaseCharacterController_upv_1)
u2.__index = u2
function u2.new(a1)
    --[[
      name: new
      line: 25
      upvalues:
        BaseCharacterController_upv_1 (copy, index: 1)
        u2 (copy, index: 2)
        None_upv_1 (copy, index: 3)
    ]]
    local v1 = setmetatable(BaseCharacterController_upv_1.new(), u2)
    v1.CONTROL_ACTION_PRIORITY = a1
    v1.forwardValue = 0
    v1.backwardValue = 0
    v1.leftValue = 0
    v1.rightValue = 0
    v1.activeGamepad = None_upv_1
    v1.gamepadConnectedConn = nil
    v1.gamepadDisconnectedConn = nil
    return v1
end
function u2.Enable(a1, a2)
    --[[
      name: Enable
      line: 41
      upvalues:
        u1 (copy, index: 1)
        UserInputService_upv_1 (copy, index: 2)
        None_upv_1 (copy, index: 3)
    ]]
    if not (u1) and not (UserInputService_upv_1.GamepadEnabled) then
        return false
    end
    if a2 ~= a1.enabled then
        a1.forwardValue = 0
        a1.backwardValue = 0
        a1.leftValue = 0
        a1.rightValue = 0
        a1.moveVector = Vector3.new(0, 0, 0)
        a1.isJumping = false
        if a2 then
            a1.activeGamepad = a1:GetHighestPriorityGamepad()
            if a1.activeGamepad == None_upv_1 then
                return false
            end
            a1:BindContextActions()
            a1:ConnectGamepadConnectionListeners()
        else
            a1:UnbindContextActions()
            a1:DisconnectGamepadConnectionListeners()
            a1.activeGamepad = None_upv_1
        end
        a1.enabled = a2
    end
    return true
end
function u2.GetHighestPriorityGamepad(a1)
    --[[
      name: GetHighestPriorityGamepad
      line: 83
      upvalues:
        UserInputService_upv_1 (copy, index: 1)
        None_upv_1 (copy, index: 2)
    ]]
    for _, value_1 in pairs(UserInputService_upv_1:GetConnectedGamepads()) do
        if not (value_1.Value < None_upv_1.Value) then
            continue
        end
    end
    return None_upv_1
end
function u2.BindContextActions(a1)
    --[[
      name: BindContextActions
      line: 94
      upvalues:
        None_upv_1 (copy, index: 1)
        ContextActionService_upv_1 (copy, index: 2)
    ]]
    if a1.activeGamepad ~= None_upv_1 then
        ContextActionService_upv_1:BindActivate(a1.activeGamepad, Enum.KeyCode.ButtonR2)
        ContextActionService_upv_1:BindActionAtPriority(
            "jumpAction",
            function(a2, a3, a4)
                --[[
                  line: 101
                  upvalues:
                    a1 (copy, index: 1)
                ]]
                a1.isJumping = a3 == Enum.UserInputState.Begin
                return Enum.ContextActionResult.Sink
            end,
            false,
            a1.CONTROL_ACTION_PRIORITY,
            Enum.KeyCode.ButtonA
        )
        ContextActionService_upv_1:BindActionAtPriority(
            "moveThumbstick",
            function(a5, a6, a7)
                --[[
                  line: 106
                  upvalues:
                    a1 (copy, index: 1)
                ]]
                if a6 == Enum.UserInputState.Cancel then
                    a1.moveVector = Vector3.new(0, 0, 0)
                    return Enum.ContextActionResult.Sink
                elseif a1.activeGamepad == a7.UserInputType then
                    if a7.KeyCode == Enum.KeyCode.Thumbstick1 then
                        if a7.Position.magnitude > 0.2 then
                            a1.moveVector = Vector3.new(a7.Position.X, 0, -a7.Position.Y)
                        else
                            a1.moveVector = Vector3.new(0, 0, 0)
                        end
                        return Enum.ContextActionResult.Sink
                    end
                else
                    return Enum.ContextActionResult.Pass
                end
            end,
            false,
            a1.CONTROL_ACTION_PRIORITY,
            Enum.KeyCode.Thumbstick1
        )
        return true
    end
    return false
end
function u2.UnbindContextActions(a1)
    --[[
      name: UnbindContextActions
      line: 135
      upvalues:
        None_upv_1 (copy, index: 1)
        ContextActionService_upv_1 (copy, index: 2)
    ]]
    if a1.activeGamepad ~= None_upv_1 then
        ContextActionService_upv_1:UnbindActivate(a1.activeGamepad, Enum.KeyCode.ButtonR2)
    end
    ContextActionService_upv_1:UnbindAction("moveThumbstick")
    ContextActionService_upv_1:UnbindAction("jumpAction")
end
function u2.OnNewGamepadConnected(a1)
    --[[
      name: OnNewGamepadConnected
      line: 143
      upvalues:
        None_upv_1 (copy, index: 1)
    ]]
    local v2 = a1:GetHighestPriorityGamepad()
    if v2 == a1.activeGamepad then
        return
    end
    if v2 ~= None_upv_1 then
        if a1.activeGamepad ~= None_upv_1 then
            a1:UnbindContextActions()
        end
        a1.activeGamepad = v2
        a1:BindContextActions()
    else
        warn("Gamepad:OnNewGamepadConnected found no connected gamepads")
        a1:UnbindContextActions()
    end
end
function u2.OnCurrentGamepadDisconnected(a1)
    --[[
      name: OnCurrentGamepadDisconnected
      line: 170
      upvalues:
        None_upv_1 (copy, index: 1)
        ContextActionService_upv_1 (copy, index: 2)
    ]]
    if a1.activeGamepad ~= None_upv_1 then
        ContextActionService_upv_1:UnbindActivate(a1.activeGamepad, Enum.KeyCode.ButtonR2)
    end
    local v3 = a1:GetHighestPriorityGamepad()
    if a1.activeGamepad == None_upv_1 or v3 ~= a1.activeGamepad then
        if v3 ~= None_upv_1 then
            a1.activeGamepad = v3
            ContextActionService_upv_1:BindActivate(a1.activeGamepad, Enum.KeyCode.ButtonR2)
        else
            a1:UnbindContextActions()
            a1.activeGamepad = None_upv_1
        end
    end
    warn("Gamepad:OnCurrentGamepadDisconnected found the supposedly disconnected gamepad in connectedGamepads.")
    a1:UnbindContextActions()
    a1.activeGamepad = None_upv_1
end
function u2.ConnectGamepadConnectionListeners(a1)
    --[[
      name: ConnectGamepadConnectionListeners
      line: 195
      upvalues:
        UserInputService_upv_1 (copy, index: 1)
    ]]
    a1.gamepadConnectedConn = UserInputService_upv_1.GamepadConnected:Connect(
        function(a2)
            --[[
              line: 196
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1:OnNewGamepadConnected()
        end
    )
    a1.gamepadDisconnectedConn = UserInputService_upv_1.GamepadDisconnected:Connect(
        function(a3)
            --[[
              line: 200
              upvalues:
                a1 (copy, index: 1)
            ]]
            if a1.activeGamepad ~= a3 then
                return
            end
            a1:OnCurrentGamepadDisconnected()
        end
    )
end
function u2.DisconnectGamepadConnectionListeners(a1)
    --[[
      name: DisconnectGamepadConnectionListeners
      line: 208
    ]]
    if a1.gamepadConnectedConn then
        a1.gamepadConnectedConn:Disconnect()
        a1.gamepadConnectedConn = nil
    end
    if not a1.gamepadDisconnectedConn then
        return
    end
    a1.gamepadDisconnectedConn:Disconnect()
    a1.gamepadDisconnectedConn = nil
end
return u2