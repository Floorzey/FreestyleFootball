--[[
    Script Path: Game/StarterPlayer/StarterPlayerScripts/PlayerModule/CameraModule/CameraInput
    Class: ModuleScript
    Time: 2026-10-03 12:27:04
--]]

local ContextActionService_upv_1 = game:GetService("ContextActionService")
local UserInputService_upv_1 = game:GetService("UserInputService")
local Players_1 = game:GetService("Players")
local RunService_1 = game:GetService("RunService")
local UserGameSettings_upv_1 = UserSettings():GetService("UserGameSettings")
local VRService_upv_1 = game:GetService("VRService")
local u1 = require(script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")).getUserFlag("UserCameraInputDt")
local LocalPlayer_upv_1 = Players_1.LocalPlayer
local Value_upv_1 = Enum.ContextActionPriority.Medium.Value
local v1 = Vector2.new(1, 0.77)
local u2 = v1 * 0.06981317007977318
local u3 = Vector2.new(1, 0.77) * 0.008726646259971648
local u4 = Vector2.new(1, 0.77) * 0.12217304763960307
local u5 = Vector2.new(1, 0.66) * 0.017453292519943295
if u1 then
    u2 = u2 * 60
end
local success_1, v2 = pcall(
    function()
        --[[
          line: 41
        ]]
        return UserSettings():IsUserFeatureEnabled("UserResetTouchStateOnMenuOpen")
    end
)
local u6 = success_1 and v2
local success_2, v3 = pcall(
    function()
        --[[
          line: 49
        ]]
        return UserSettings():IsUserFeatureEnabled("UserClearPanOnCameraDisable")
    end
)
local u7 = success_2 and v3
local success_3, v4 = pcall(
    function()
        --[[
          line: 57
        ]]
        return UserSettings():IsUserFeatureEnabled("UserFixGamepadSensitivity")
    end
)
local u8 = success_3 and v4
local u9 = Instance.new("BindableEvent")
local u10 = Instance.new("BindableEvent")
local Event_upv_1 = u9.Event
local Event_upv_2 = u10.Event
UserInputService_upv_1.InputBegan:Connect(
    function(a1, a2)
        --[[
          line: 71
          upvalues:
            u9 (copy, index: 1)
        ]]
        if (a2) or a1.UserInputType ~= Enum.UserInputType.MouseButton2 then
            return
        end
        u9:Fire()
    end
)
UserInputService_upv_1.InputEnded:Connect(
    function(a1, a2)
        --[[
          line: 77
          upvalues:
            u10 (copy, index: 1)
        ]]
        if a1.UserInputType ~= Enum.UserInputType.MouseButton2 then
            return
        end
        u10:Fire()
    end
)
local function adjustTouchPitchSensitivity(a1)
    --[[
      name: adjustTouchPitchSensitivity
      line: 102
    ]]
    local CurrentCamera_1 = workspace.CurrentCamera
    if not CurrentCamera_1 then
        return a1
    end
    local v5 = CurrentCamera_1.CFrame:ToEulerAnglesYXZ()
    if a1.Y * v5 >= 0 then
        return a1
    end
    return Vector2.new(1, ((1 - (((math.abs(v5) * 2) / math.pi) ^ 0.75)) * 0.75) + 0.25) * a1
end
local u11 = 0.016666666666666666
RunService_1.Stepped:Connect(
    function(a1, a2)
        --[[
          line: 153
          upvalues:
            u11 (ref, index: 1)
        ]]
        u11 = a2
    end
)
local tbl_1 = {}
local tbl_upv_2 = {}
local u12 = 0
local function incPanInputCount()
    --[[
      name: incPanInputCount
      line: 163
      upvalues:
        u12 (ref, index: 1)
    ]]
    u12 = math.max(0, u12 + 1)
end
local function decPanInputCount()
    --[[
      name: decPanInputCount
      line: 167
      upvalues:
        u12 (ref, index: 1)
    ]]
    u12 = math.max(0, u12 - 1)
end
local function resetPanInputCount()
    --[[
      name: resetPanInputCount
      line: 171
      upvalues:
        u12 (ref, index: 1)
    ]]
    u12 = 0
end
local tbl_upv_3 = {}
tbl_upv_3.Thumbstick2 = Vector2.new()
local tbl_upv_4 = {I = 0, Right = 0, Left = 0, O = 0}
local tbl_upv_5 = {Pinch = 0, Wheel = 0}
tbl_upv_5.Movement = Vector2.new()
tbl_upv_5.Pan = Vector2.new()
local tbl_upv_6 = {Pinch = 0}
tbl_upv_6.Move = Vector2.new()
local u13 = Instance.new("BindableEvent")
tbl_1.gamepadZoomPress = u13.Event
local u14 = ((VRService_upv_1.VREnabled) and (Instance.new("BindableEvent"))) or nil
if VRService_upv_1.VREnabled then
    tbl_1.gamepadReset = u14.Event
end
function tbl_1.getRotationActivated()
    --[[
      name: getRotationActivated
      line: 204
      upvalues:
        u12 (ref,  index: 1)
        tbl_upv_3 (copy, index: 2)
    ]]
    local v6 = true
    if not (u12 > 0) then
        v6 = tbl_upv_3.Thumbstick2.Magnitude > 0
    end
    return v6
end
function tbl_1.getRotation(a1, a2)
    --[[
      name: getRotation
      line: 208
      upvalues:
        UserGameSettings_upv_1 (copy, index: 1)
        u1 (copy, index: 2)
        tbl_upv_4 (copy, index: 3)
        u11 (ref,  index: 4)
        u8 (ref,  index: 5)
        tbl_upv_3 (copy, index: 6)
        tbl_upv_5 (copy, index: 7)
        adjustTouchPitchSensitivity (copy, index: 8)
        tbl_upv_6 (copy, index: 9)
        u2 (ref,  index: 10)
        u3 (copy, index: 11)
        u4 (copy, index: 12)
        u5 (copy, index: 13)
    ]]
    local v7 = Vector2.new(1, UserGameSettings_upv_1:GetCameraYInvertValue())
    local v8 = (u1 and (Vector2.new(tbl_upv_4.Right - tbl_upv_4.Left, 0) * a1)) or (Vector2.new(tbl_upv_4.Right - tbl_upv_4.Left, 0) * u11)
    local v9 = (u8 and (tbl_upv_3.Thumbstick2 * UserGameSettings_upv_1.GamepadCameraSensitivity)) or (tbl_upv_3.Thumbstick2)
    v9 = (u1 and (v9 * a1)) or v9
    local Movement_1 = tbl_upv_5.Movement
    local Pan_1 = tbl_upv_5.Pan
    local v10 = adjustTouchPitchSensitivity(tbl_upv_6.Move)
    if a2 then
        v8 = Vector2.new()
    end
    return (((((v8 * 2.0943951023931953) + (v9 * u2)) + (Movement_1 * u3)) + (Pan_1 * u4)) + (v10 * u5)) * v7
end
function tbl_1.getZoomDelta()
    --[[
      name: getZoomDelta
      line: 248
      upvalues:
        tbl_upv_4 (copy, index: 1)
        tbl_upv_5 (copy, index: 2)
        tbl_upv_6 (copy, index: 3)
    ]]
    return (((tbl_upv_4.O - tbl_upv_4.I) * 0.1) + ((-tbl_upv_5.Wheel + tbl_upv_5.Pinch) * 1)) + (-tbl_upv_6.Pinch * 0.04)
end
local function thumbstickCurve(a1)
    --[[
      name: thumbstickCurve
      line: 88
    ]]
    local v11 = (math.exp(((math.abs(a1) - 0.1) / 0.9) * 2) - 1) / 6.38905609893065
    return math.sign(a1) * math.clamp(v11, 0, 1)
end
local function thumbstick(a1, a2, a3)
    --[[
      name: thumbstick
      line: 256
      upvalues:
        tbl_upv_3 (copy, index: 1)
        thumbstickCurve (ref,  index: 2)
    ]]
    local Position_1 = a3.Position
    tbl_upv_3[a3.KeyCode.Name] = Vector2.new(thumbstickCurve(Position_1.X), -thumbstickCurve(Position_1.Y))
    return Enum.ContextActionResult.Pass
end
local function mouseMovement(a1)
    --[[
      name: mouseMovement
      line: 262
      upvalues:
        tbl_upv_5 (copy, index: 1)
    ]]
    local Delta_1 = a1.Delta
    tbl_upv_5.Movement = Vector2.new(Delta_1.X, Delta_1.Y)
end
local function mouseWheel(a1, a2, a3)
    --[[
      name: mouseWheel
      line: 267
      upvalues:
        tbl_upv_5 (copy, index: 1)
    ]]
    tbl_upv_5.Wheel = a3.Position.Z
    return Enum.ContextActionResult.Pass
end
local function gamepadZoomPress(a1, a2, a3)
    --[[
      name: gamepadZoomPress
      line: 276
      upvalues:
        u13 (copy, index: 1)
    ]]
    if a2 ~= Enum.UserInputState.Begin then
        return
    end
    u13:Fire()
end
local function resetInputDevices()
    --[[
      name: resetInputDevices
      line: 288
      upvalues:
        tbl_upv_3 (copy, index: 1)
        tbl_upv_4 (copy, index: 2)
        tbl_upv_5 (copy, index: 3)
        tbl_upv_6 (copy, index: 4)
        u7 (ref,  index: 5)
        u12 (ref,  index: 6)
    ]]
    for _, value_1 in pairs({tbl_upv_3, tbl_upv_4, tbl_upv_5, tbl_upv_6}) do
        for key_1, value_2 in pairs(value_1) do
            if type(value_2) ~= "boolean" then
                value_1[key_1] = value_1[key_1] * 0
            else
                value_1[key_1] = false
            end
        end
    end
    if not u7 then
        return
    end
    u12 = 0
end
local tbl_upv_7 = {}
local u15 = nil
local u16 = nil
local function isInDynamicThumbstickArea(a1)
    --[[
      name: isInDynamicThumbstickArea
      line: 128
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
    ]]
    local v12 = LocalPlayer_upv_1:FindFirstChildOfClass("PlayerGui")
    local v13 = v12 and (v12:FindFirstChild("TouchGui"))
    local v14 = v13 and (v13:FindFirstChild("TouchControlFrame"))
    local v15 = v14 and (v14:FindFirstChild("DynamicThumbstickFrame"))
    if not v15 or not v12.Enabled then
        return false
    end
    local AbsolutePosition_1 = v15.AbsolutePosition
    local v16 = AbsolutePosition_1 + v15.AbsoluteSize
    return (AbsolutePosition_1.X <= a1.X) and ((AbsolutePosition_1.Y <= a1.Y) and ((a1.X <= v16.X) and (a1.Y <= v16.Y)))
end
local function touchBegan(a1, a2)
    --[[
      name: touchBegan
      line: 316
      upvalues:
        u15 (ref,  index: 1)
        isInDynamicThumbstickArea (copy, index: 2)
        u12 (ref,  index: 3)
        tbl_upv_7 (ref,  index: 4)
    ]]
    assert(a1.UserInputType == Enum.UserInputType.Touch)
    assert(a1.UserInputState == Enum.UserInputState.Begin)
    if u15 == nil and isInDynamicThumbstickArea(a1.Position) then
        if a2 then
            if not (a2) then
                u12 = math.max(0, u12 + 1)
            end
        else
            u15 = a1
            return
        end
    elseif not (a2) then
        u12 = math.max(0, u12 + 1)
    end
    tbl_upv_7[a1] = a2
end
local function touchEnded(a1, a2)
    --[[
      name: touchEnded
      line: 336
      upvalues:
        u15 (ref, index: 1)
        tbl_upv_7 (ref, index: 2)
        u16 (ref, index: 3)
        u12 (ref, index: 4)
    ]]
    assert(a1.UserInputType == Enum.UserInputType.Touch)
    assert(a1.UserInputState == Enum.UserInputState.End)
    if a1 == u15 then
        u15 = nil
    end
    if tbl_upv_7[a1] == false then
        u16 = nil
        u12 = math.max(0, u12 - 1)
    end
    tbl_upv_7[a1] = nil
end
local function touchChanged(a1, a2)
    --[[
      name: touchChanged
      line: 355
      upvalues:
        u15 (ref,  index: 1)
        tbl_upv_7 (ref,  index: 2)
        tbl_upv_6 (copy, index: 3)
        u16 (ref,  index: 4)
    ]]
    assert(a1.UserInputType == Enum.UserInputType.Touch)
    assert(a1.UserInputState == Enum.UserInputState.Change)
    if a1 == u15 then
        return
    end
    if tbl_upv_7[a1] == nil then
        tbl_upv_7[a1] = a2
    end
    local tbl_8 = {}
    for key_2, value_3 in pairs(tbl_upv_7) do
        if not (value_3) then
            table.insert(tbl_8, key_2)
        end
    end
    if #tbl_8 == 1 and tbl_upv_7[a1] == false then
        local Delta_2 = a1.Delta
        local v17 = tbl_upv_6
        v17.Move = v17.Move + Vector2.new(Delta_2.X, Delta_2.Y)
    end
    if #tbl_8 ~= 2 then
        u16 = nil
    else
        local Magnitude_1 = (tbl_8[1].Position - tbl_8[2].Position).Magnitude
        if u16 then
            tbl_upv_6.Pinch = tbl_upv_6.Pinch + (Magnitude_1 - u16)
        end
        u16 = Magnitude_1
    end
end
local function resetTouchState()
    --[[
      name: resetTouchState
      line: 399
      upvalues:
        tbl_upv_7 (ref, index: 1)
        u15 (ref, index: 2)
        u16 (ref, index: 3)
        u6 (ref, index: 4)
        u12 (ref, index: 5)
    ]]
    tbl_upv_7 = {}
    u15 = nil
    u16 = nil
    if not u6 then
        return
    end
    u12 = 0
end
local function inputBegan(a1, a2)
    --[[
      name: inputBegan
      line: 417
      upvalues:
        touchBegan (ref, index: 1)
        u12 (ref, index: 2)
    ]]
    if a1.UserInputType == Enum.UserInputType.Touch then
        touchBegan(a1, a2)
    elseif a1.UserInputType == Enum.UserInputType.MouseButton2 and not (a2) then
        u12 = math.max(0, u12 + 1)
    end
end
local function inputChanged(a1, a2)
    --[[
      name: inputChanged
      line: 426
      upvalues:
        touchChanged (ref,  index: 1)
        tbl_upv_5 (copy, index: 2)
    ]]
    if a1.UserInputType == Enum.UserInputType.Touch then
        touchChanged(a1, a2)
    elseif a1.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta_3 = a1.Delta
        tbl_upv_5.Movement = Vector2.new(Delta_3.X, Delta_3.Y)
    end
end
local function inputEnded(a1, a2)
    --[[
      name: inputEnded
      line: 435
      upvalues:
        touchEnded (ref, index: 1)
        u12 (ref, index: 2)
    ]]
    if a1.UserInputType == Enum.UserInputType.Touch then
        touchEnded(a1, a2)
    elseif a1.UserInputType == Enum.UserInputType.MouseButton2 then
        u12 = math.max(0, u12 - 1)
    end
end
local u17 = false
local function gamepadReset(a1, a2, a3)
    --[[
      name: gamepadReset
      line: 282
      upvalues:
        u14 (copy, index: 1)
    ]]
    if a2 ~= Enum.UserInputState.Begin then
        return
    end
    u14:Fire()
end
local function keypress(a1, a2, a3)
    --[[
      name: keypress
      line: 272
      upvalues:
        tbl_upv_4 (copy, index: 1)
    ]]
    tbl_upv_4[a3.KeyCode.Name] = ((a2 ~= Enum.UserInputState.Begin) and 0) or 1
end
local function pointerAction(a1, a2, a3, a4)
    --[[
      name: pointerAction
      line: 409
      upvalues:
        tbl_upv_5 (copy, index: 1)
    ]]
    if (a4) then
        return
    end
    tbl_upv_5.Wheel = a1
    tbl_upv_5.Pan = a2
    tbl_upv_5.Pinch = -a3
end
function tbl_1.setInputEnabled(a1)
    --[[
      name: setInputEnabled
      line: 446
      upvalues:
        u17 (ref,  index: 1)
        resetInputDevices (copy, index: 2)
        resetTouchState (ref,  index: 3)
        ContextActionService_upv_1 (copy, index: 4)
        thumbstick (copy, index: 5)
        Value_upv_1 (copy, index: 6)
        keypress (copy, index: 7)
        VRService_upv_1 (copy, index: 8)
        gamepadReset (copy, index: 9)
        gamepadZoomPress (copy, index: 10)
        tbl_upv_2 (ref,  index: 11)
        UserInputService_upv_1 (copy, index: 12)
        inputBegan (copy, index: 13)
        inputChanged (copy, index: 14)
        inputEnded (copy, index: 15)
        pointerAction (copy, index: 16)
        u6 (ref,  index: 17)
    ]]
    if u17 == a1 then
        return
    end
    u17 = a1
    resetInputDevices()
    resetTouchState()
    if u17 then
        ContextActionService_upv_1:BindActionAtPriority("RbxCameraThumbstick", thumbstick, false, Value_upv_1, Enum.KeyCode.Thumbstick2)
        ContextActionService_upv_1:BindActionAtPriority("RbxCameraKeypress", keypress, false, Value_upv_1, Enum.KeyCode.Left, Enum.KeyCode.Right, Enum.KeyCode.I, Enum.KeyCode.O)
        if VRService_upv_1.VREnabled then
            ContextActionService_upv_1:BindAction("RbxCameraGamepadReset", gamepadReset, false, Enum.KeyCode.ButtonL3)
        end
        ContextActionService_upv_1:BindAction("RbxCameraGamepadZoom", gamepadZoomPress, false, Enum.KeyCode.ButtonR3)
        table.insert(tbl_upv_2, UserInputService_upv_1.InputBegan:Connect(inputBegan))
        table.insert(tbl_upv_2, UserInputService_upv_1.InputChanged:Connect(inputChanged))
        table.insert(tbl_upv_2, UserInputService_upv_1.InputEnded:Connect(inputEnded))
        table.insert(tbl_upv_2, UserInputService_upv_1.PointerAction:Connect(pointerAction))
        if not u6 then
            return
        end
        local GuiService_1 = game:GetService("GuiService")
        table.insert(tbl_upv_2, GuiService_1.MenuOpened:connect(resetTouchState))
    else
        ContextActionService_upv_1:UnbindAction("RbxCameraThumbstick")
        ContextActionService_upv_1:UnbindAction("RbxCameraMouseMove")
        ContextActionService_upv_1:UnbindAction("RbxCameraMouseWheel")
        ContextActionService_upv_1:UnbindAction("RbxCameraKeypress")
        ContextActionService_upv_1:UnbindAction("RbxCameraGamepadZoom")
        if VRService_upv_1.VREnabled then
            ContextActionService_upv_1:UnbindAction("RbxCameraGamepadReset")
        end
        for _, value_4 in pairs(tbl_upv_2) do
            value_4:Disconnect()
        end
        tbl_upv_2 = {}
    end
end
function tbl_1.getInputEnabled()
    --[[
      name: getInputEnabled
      line: 518
      upvalues:
        u17 (ref, index: 1)
    ]]
    return u17
end
function tbl_1.resetInputForFrameEnd()
    --[[
      name: resetInputForFrameEnd
      line: 522
      upvalues:
        tbl_upv_5 (copy, index: 1)
        tbl_upv_6 (copy, index: 2)
    ]]
    tbl_upv_5.Movement = Vector2.new()
    tbl_upv_6.Move = Vector2.new()
    tbl_upv_6.Pinch = 0
    tbl_upv_5.Wheel = 0
    tbl_upv_5.Pan = Vector2.new()
    tbl_upv_5.Pinch = 0
end
UserInputService_upv_1.WindowFocused:Connect(resetInputDevices)
UserInputService_upv_1.WindowFocusReleased:Connect(resetInputDevices)
local u18 = false
local u19 = false
local u20 = 0
function tbl_1.getHoldPan()
    --[[
      name: getHoldPan
      line: 543
      upvalues:
        u18 (ref, index: 1)
    ]]
    return u18
end
function tbl_1.getTogglePan()
    --[[
      name: getTogglePan
      line: 547
      upvalues:
        u19 (ref, index: 1)
    ]]
    return u19
end
function tbl_1.getPanning()
    --[[
      name: getPanning
      line: 551
      upvalues:
        u19 (ref, index: 1)
        u18 (ref, index: 2)
    ]]
    local v18 = u19 or u18
    return v18
end
function tbl_1.setTogglePan(a1)
    --[[
      name: setTogglePan
      line: 555
      upvalues:
        u19 (ref, index: 1)
    ]]
    u19 = a1
end
local u21 = false
local u22 = nil
local u23 = nil
function tbl_1.enableCameraToggleInput()
    --[[
      name: enableCameraToggleInput
      line: 563
      upvalues:
        u21 (ref,  index: 1)
        u18 (ref,  index: 2)
        u19 (ref,  index: 3)
        u22 (ref,  index: 4)
        u23 (ref,  index: 5)
        Event_upv_1 (ref,  index: 6)
        u20 (ref,  index: 7)
        Event_upv_2 (ref,  index: 8)
        UserInputService_upv_1 (copy, index: 9)
    ]]
    if u21 then
        return
    end
    u21 = true
    u18 = false
    u19 = false
    if u22 then
        u22:Disconnect()
    end
    if u23 then
        u23:Disconnect()
    end
    local v19 = Event_upv_1:Connect(
        function()
            --[[
              line: 580
              upvalues:
                u18 (ref, index: 1)
                u20 (ref, index: 2)
            ]]
            u18 = true
            u20 = tick()
        end
    )
    u22 = v19
    local v20 = Event_upv_2:Connect(
        function()
            --[[
              line: 585
              upvalues:
                u18 (ref,  index: 1)
                u20 (ref,  index: 2)
                u19 (ref,  index: 3)
                UserInputService_upv_1 (copy, index: 4)
            ]]
            u18 = false
            if not (tick() - u20 < 0.3) or not u19 and not (UserInputService_upv_1:GetMouseDelta().Magnitude < 2) then
                return
            end
            u19 = not u19
        end
    )
    u23 = v20
end
function tbl_1.disableCameraToggleInput()
    --[[
      name: disableCameraToggleInput
      line: 593
      upvalues:
        u21 (ref, index: 1)
        u22 (ref, index: 2)
        u23 (ref, index: 3)
    ]]
    if not u21 then
        return
    end
    u21 = false
    if u22 then
        u22:Disconnect()
        u22 = nil
    end
    if u23 then
        u23:Disconnect()
        u23 = nil
    end
end
return tbl_1