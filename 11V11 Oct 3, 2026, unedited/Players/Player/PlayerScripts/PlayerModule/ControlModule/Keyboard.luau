--[[
    Script Path: Game/Players/Player/PlayerScripts/PlayerModule/ControlModule/Keyboard
    Class: ModuleScript
    Time: 2026-10-03 12:27:02
--]]

local UserInputService_upv_1 = game:GetService("UserInputService")
local ContextActionService_upv_1 = game:GetService("ContextActionService")
local u1 = require(script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")).getUserFlag("UserUpdateInputConnections")
local u2 = Vector3.new()
local BaseCharacterController_upv_1 = require(script.Parent:WaitForChild("BaseCharacterController"))
local u3 = setmetatable({}, BaseCharacterController_upv_1)
u3.__index = u3
function u3.new(a1)
    --[[
      name: new
      line: 24
      upvalues:
        BaseCharacterController_upv_1 (copy, index: 1)
        u3 (copy, index: 2)
        u1 (copy, index: 3)
    ]]
    local v1 = setmetatable(BaseCharacterController_upv_1.new(), u3)
    v1.CONTROL_ACTION_PRIORITY = a1
    if not (u1) then
        v1.textFocusReleasedConn = nil
        v1.textFocusGainedConn = nil
        v1.windowFocusReleasedConn = nil
    end
    v1.forwardValue = 0
    v1.backwardValue = 0
    v1.leftValue = 0
    v1.rightValue = 0
    v1.jumpEnabled = true
    return v1
end
function u3.Enable(a1, a2)
    --[[
      name: Enable
      line: 45
      upvalues:
        u1 (copy, index: 1)
        UserInputService_upv_1 (copy, index: 2)
        u2 (copy, index: 3)
    ]]
    if not (u1) and not (UserInputService_upv_1.KeyboardEnabled) then
        return false
    end
    if a2 ~= a1.enabled then
        a1.forwardValue = 0
        a1.backwardValue = 0
        a1.leftValue = 0
        a1.rightValue = 0
        a1.moveVector = u2
        a1.jumpRequested = false
        a1:UpdateJump()
        if a2 then
            a1:BindContextActions()
            a1:ConnectFocusEventListeners()
        elseif u1 then
            a1._connections:disconnectAll()
        else
            a1:UnbindContextActions()
            a1:DisconnectFocusEventListeners()
        end
        a1.enabled = a2
    end
    return true
end
function u3.UpdateMovement(a1, a2)
    --[[
      name: UpdateMovement
      line: 83
      upvalues:
        u2 (copy, index: 1)
    ]]
    if a2 ~= Enum.UserInputState.Cancel then
        a1.moveVector = Vector3.new(a1.leftValue + a1.rightValue, 0, a1.forwardValue + a1.backwardValue)
    else
        a1.moveVector = u2
    end
end
function u3.UpdateJump(a1)
    --[[
      name: UpdateJump
      line: 91
    ]]
    a1.isJumping = a1.jumpRequested
end
function u3.BindContextActions(a1)
    --[[
      name: BindContextActions
      line: 95
      upvalues:
        ContextActionService_upv_1 (copy, index: 1)
        u1 (copy, index: 2)
    ]]
    ContextActionService_upv_1:BindActionAtPriority(
        "moveForwardAction",
        function(a2, a3, a4)
            --[[
              line: 101
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1.forwardValue = ((a3 ~= Enum.UserInputState.Begin) and 0) or -1
            a1:UpdateMovement(a3)
            return Enum.ContextActionResult.Pass
        end,
        false,
        a1.CONTROL_ACTION_PRIORITY,
        Enum.PlayerActions.CharacterForward
    )
    ContextActionService_upv_1:BindActionAtPriority(
        "moveBackwardAction",
        function(a5, a6, a7)
            --[[
              line: 107
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1.backwardValue = ((a6 ~= Enum.UserInputState.Begin) and 0) or 1
            a1:UpdateMovement(a6)
            return Enum.ContextActionResult.Pass
        end,
        false,
        a1.CONTROL_ACTION_PRIORITY,
        Enum.PlayerActions.CharacterBackward
    )
    ContextActionService_upv_1:BindActionAtPriority(
        "moveLeftAction",
        function(a8, a9, a10)
            --[[
              line: 113
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1.leftValue = ((a9 ~= Enum.UserInputState.Begin) and 0) or -1
            a1:UpdateMovement(a9)
            return Enum.ContextActionResult.Pass
        end,
        false,
        a1.CONTROL_ACTION_PRIORITY,
        Enum.PlayerActions.CharacterLeft
    )
    ContextActionService_upv_1:BindActionAtPriority(
        "moveRightAction",
        function(a11, a12, a13)
            --[[
              line: 119
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1.rightValue = ((a12 ~= Enum.UserInputState.Begin) and 0) or 1
            a1:UpdateMovement(a12)
            return Enum.ContextActionResult.Pass
        end,
        false,
        a1.CONTROL_ACTION_PRIORITY,
        Enum.PlayerActions.CharacterRight
    )
    ContextActionService_upv_1:BindActionAtPriority(
        "jumpAction",
        function(a14, a15, a16)
            --[[
              line: 125
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1.jumpRequested = a1.jumpEnabled and (a15 == Enum.UserInputState.Begin)
            a1:UpdateJump()
            return Enum.ContextActionResult.Pass
        end,
        false,
        a1.CONTROL_ACTION_PRIORITY,
        Enum.PlayerActions.CharacterJump
    )
    if not u1 then
        return
    end
    a1._connections:connectManual(
        "moveForwardAction",
        function()
            --[[
              line: 145
              upvalues:
                ContextActionService_upv_1 (copy, index: 1)
            ]]
            ContextActionService_upv_1:UnbindAction("moveForwardAction")
        end
    )
    a1._connections:connectManual(
        "moveBackwardAction",
        function()
            --[[
              line: 146
              upvalues:
                ContextActionService_upv_1 (copy, index: 1)
            ]]
            ContextActionService_upv_1:UnbindAction("moveBackwardAction")
        end
    )
    a1._connections:connectManual(
        "moveLeftAction",
        function()
            --[[
              line: 147
              upvalues:
                ContextActionService_upv_1 (copy, index: 1)
            ]]
            ContextActionService_upv_1:UnbindAction("moveLeftAction")
        end
    )
    a1._connections:connectManual(
        "moveRightAction",
        function()
            --[[
              line: 148
              upvalues:
                ContextActionService_upv_1 (copy, index: 1)
            ]]
            ContextActionService_upv_1:UnbindAction("moveRightAction")
        end
    )
    a1._connections:connectManual(
        "jumpAction",
        function()
            --[[
              line: 149
              upvalues:
                ContextActionService_upv_1 (copy, index: 1)
            ]]
            ContextActionService_upv_1:UnbindAction("jumpAction")
        end
    )
end
function u3.UnbindContextActions(a1)
    --[[
      name: UnbindContextActions
      line: 153
      upvalues:
        ContextActionService_upv_1 (copy, index: 1)
    ]]
    ContextActionService_upv_1:UnbindAction("moveForwardAction")
    ContextActionService_upv_1:UnbindAction("moveBackwardAction")
    ContextActionService_upv_1:UnbindAction("moveLeftAction")
    ContextActionService_upv_1:UnbindAction("moveRightAction")
    ContextActionService_upv_1:UnbindAction("jumpAction")
end
function u3.ConnectFocusEventListeners(a1)
    --[[
      name: ConnectFocusEventListeners
      line: 161
      upvalues:
        u2 (copy, index: 1)
        u1 (copy, index: 2)
        UserInputService_upv_1 (copy, index: 3)
    ]]
    local function onTextFocusGained(a2)
        --[[
          name: onTextFocusGained
          line: 172
          upvalues:
            a1 (copy, index: 1)
        ]]
        a1.jumpRequested = false
        a1:UpdateJump()
    end
    local function onFocusReleased()
        --[[
          name: onFocusReleased
          line: 162
          upvalues:
            a1 (copy, index: 1)
            u2 (copy, index: 2)
        ]]
        a1.moveVector = u2
        a1.forwardValue = 0
        a1.backwardValue = 0
        a1.leftValue = 0
        a1.rightValue = 0
        a1.jumpRequested = false
        a1:UpdateJump()
    end
    if u1 then
        a1._connections:connect("textBoxFocusReleased", UserInputService_upv_1.TextBoxFocusReleased, onFocusReleased)
        a1._connections:connect("textBoxFocused", UserInputService_upv_1.TextBoxFocused, onTextFocusGained)
        a1._connections:connect("windowFocusReleased", UserInputService_upv_1.WindowFocused, onFocusReleased)
    else
        a1.textFocusReleasedConn = UserInputService_upv_1.TextBoxFocusReleased:Connect(onFocusReleased)
        a1.textFocusGainedConn = UserInputService_upv_1.TextBoxFocused:Connect(onTextFocusGained)
        a1.windowFocusReleasedConn = UserInputService_upv_1.WindowFocused:Connect(onFocusReleased)
    end
end
function u3.DisconnectFocusEventListeners(a1)
    --[[
      name: DisconnectFocusEventListeners
      line: 188
    ]]
    if a1.textFocusReleasedConn then
        a1.textFocusReleasedConn:Disconnect()
        a1.textFocusReleasedConn = nil
    end
    if a1.textFocusGainedConn then
        a1.textFocusGainedConn:Disconnect()
        a1.textFocusGainedConn = nil
    end
    if not a1.windowFocusReleasedConn then
        return
    end
    a1.windowFocusReleasedConn:Disconnect()
    a1.windowFocusReleasedConn = nil
end
return u3