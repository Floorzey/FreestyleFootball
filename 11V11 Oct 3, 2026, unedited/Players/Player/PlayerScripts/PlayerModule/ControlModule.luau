--[[
    Script Path: Game/Players/Player/PlayerScripts/PlayerModule/ControlModule
    Class: ModuleScript
    Time: 2026-10-03 12:27:02
--]]

local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
local Players_upv_1 = game:GetService("Players")
local RunService_upv_1 = game:GetService("RunService")
local UserInputService_upv_1 = game:GetService("UserInputService")
local GuiService_upv_1 = game:GetService("GuiService")
local Workspace_upv_1 = game:GetService("Workspace")
local UserGameSettings_upv_1 = UserSettings():GetService("UserGameSettings")
local VRService_upv_1 = game:GetService("VRService")
local FlagUtil_1 = require(script.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil"))
local Keyboard_upv_1 = require(script:WaitForChild("Keyboard"))
local Gamepad_upv_1 = require(script:WaitForChild("Gamepad"))
local DynamicThumbstick_upv_1 = require(script:WaitForChild("DynamicThumbstick"))
local u1 = FlagUtil_1.getUserFlag("UserUpdateInputConnections")
local success_1, v1 = pcall(
    function()
        --[[
          line: 37
        ]]
        return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
    end
)
local u2 = success_1 and v1
local success_2, v2 = pcall(
    function()
        --[[
          line: 44
        ]]
        return UserSettings():IsUserFeatureEnabled("UserFixTouchJumpBug2")
    end
)
local u3 = success_2 and v2
local TouchThumbstick_upv_1 = require(script:WaitForChild("TouchThumbstick"))
local ClickToMoveController_upv_1 = require(script:WaitForChild("ClickToMoveController"))
local TouchJump_upv_1 = require(script:WaitForChild("TouchJump"))
local VehicleController_upv_1 = require(script:WaitForChild("VehicleController"))
local Value_upv_1 = Enum.ContextActionPriority.Medium.Value
local tbl_upv_2 = {}
tbl_upv_2[Enum.TouchMovementMode.DPad] = DynamicThumbstick_upv_1
tbl_upv_2[Enum.DevTouchMovementMode.DPad] = DynamicThumbstick_upv_1
tbl_upv_2[Enum.TouchMovementMode.Thumbpad] = DynamicThumbstick_upv_1
tbl_upv_2[Enum.DevTouchMovementMode.Thumbpad] = DynamicThumbstick_upv_1
tbl_upv_2[Enum.TouchMovementMode.Thumbstick] = TouchThumbstick_upv_1
tbl_upv_2[Enum.DevTouchMovementMode.Thumbstick] = TouchThumbstick_upv_1
tbl_upv_2[Enum.TouchMovementMode.DynamicThumbstick] = DynamicThumbstick_upv_1
tbl_upv_2[Enum.DevTouchMovementMode.DynamicThumbstick] = DynamicThumbstick_upv_1
tbl_upv_2[Enum.TouchMovementMode.ClickToMove] = ClickToMoveController_upv_1
tbl_upv_2[Enum.DevTouchMovementMode.ClickToMove] = ClickToMoveController_upv_1
tbl_upv_2[Enum.TouchMovementMode.Default] = DynamicThumbstick_upv_1
tbl_upv_2[Enum.ComputerMovementMode.Default] = Keyboard_upv_1
tbl_upv_2[Enum.ComputerMovementMode.KeyboardMouse] = Keyboard_upv_1
tbl_upv_2[Enum.DevComputerMovementMode.KeyboardMouse] = Keyboard_upv_1
tbl_upv_2[Enum.DevComputerMovementMode.Scriptable] = nil
tbl_upv_2[Enum.ComputerMovementMode.ClickToMove] = ClickToMoveController_upv_1
tbl_upv_2[Enum.DevComputerMovementMode.ClickToMove] = ClickToMoveController_upv_1
local tbl_upv_3 = {}
tbl_upv_3[Enum.UserInputType.Keyboard] = Keyboard_upv_1
tbl_upv_3[Enum.UserInputType.MouseButton1] = Keyboard_upv_1
tbl_upv_3[Enum.UserInputType.MouseButton2] = Keyboard_upv_1
tbl_upv_3[Enum.UserInputType.MouseButton3] = Keyboard_upv_1
tbl_upv_3[Enum.UserInputType.MouseWheel] = Keyboard_upv_1
tbl_upv_3[Enum.UserInputType.MouseMovement] = Keyboard_upv_1
tbl_upv_3[Enum.UserInputType.Gamepad1] = Gamepad_upv_1
tbl_upv_3[Enum.UserInputType.Gamepad2] = Gamepad_upv_1
tbl_upv_3[Enum.UserInputType.Gamepad3] = Gamepad_upv_1
tbl_upv_3[Enum.UserInputType.Gamepad4] = Gamepad_upv_1
local u4 = nil
function tbl_upv_1.new()
    --[[
      name: new
      line: 102
      upvalues:
        tbl_upv_1 (copy, index: 1)
        Players_upv_1 (copy, index: 2)
        VehicleController_upv_1 (copy, index: 3)
        Value_upv_1 (copy, index: 4)
        RunService_upv_1 (copy, index: 5)
        UserInputService_upv_1 (copy, index: 6)
        UserGameSettings_upv_1 (copy, index: 7)
        GuiService_upv_1 (copy, index: 8)
    ]]
    local u5 = setmetatable({}, tbl_upv_1)
    u5.controllers = {}
    u5.activeControlModule = nil
    u5.activeController = nil
    u5.touchJumpController = nil
    u5.moveFunction = Players_upv_1.LocalPlayer.Move
    u5.humanoid = nil
    u5.lastInputType = Enum.UserInputType.None
    u5.controlsEnabled = true
    u5.humanoidSeatedConn = nil
    u5.vehicleController = nil
    u5.touchControlFrame = nil
    u5.currentTorsoAngle = 0
    u5.inputMoveVector = Vector3.new(0, 0, 0)
    u5.vehicleController = VehicleController_upv_1.new(Value_upv_1)
    Players_upv_1.LocalPlayer.CharacterAdded:Connect(
        function(a1)
            --[[
              line: 128
              upvalues:
                u5 (copy, index: 1)
            ]]
            u5:OnCharacterAdded(a1)
        end
    )
    Players_upv_1.LocalPlayer.CharacterRemoving:Connect(
        function(a2)
            --[[
              line: 129
              upvalues:
                u5 (copy, index: 1)
            ]]
            u5:OnCharacterRemoving(a2)
        end
    )
    if Players_upv_1.LocalPlayer.Character then
        u5:OnCharacterAdded(Players_upv_1.LocalPlayer.Character)
    end
    RunService_upv_1:BindToRenderStep(
        "ControlScriptRenderstep",
        Enum.RenderPriority.Input.Value,
        function(a3)
            --[[
              line: 134
              upvalues:
                u5 (copy, index: 1)
            ]]
            u5:OnRenderStepped(a3)
        end
    )
    UserInputService_upv_1.LastInputTypeChanged:Connect(
        function(a4)
            --[[
              line: 138
              upvalues:
                u5 (copy, index: 1)
            ]]
            u5:OnLastInputTypeChanged(a4)
        end
    )
    UserGameSettings_upv_1:GetPropertyChangedSignal("TouchMovementMode"):Connect(
        function()
            --[[
              line: 143
              upvalues:
                u5 (copy, index: 1)
            ]]
            u5:OnTouchMovementModeChange()
        end
    )
    Players_upv_1.LocalPlayer:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(
        function()
            --[[
              line: 146
              upvalues:
                u5 (copy, index: 1)
            ]]
            u5:OnTouchMovementModeChange()
        end
    )
    UserGameSettings_upv_1:GetPropertyChangedSignal("ComputerMovementMode"):Connect(
        function()
            --[[
              line: 150
              upvalues:
                u5 (copy, index: 1)
            ]]
            u5:OnComputerMovementModeChange()
        end
    )
    Players_upv_1.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(
        function()
            --[[
              line: 153
              upvalues:
                u5 (copy, index: 1)
            ]]
            u5:OnComputerMovementModeChange()
        end
    )
    u5.playerGui = nil
    u5.touchGui = nil
    u5.playerGuiAddedConn = nil
    GuiService_upv_1:GetPropertyChangedSignal("TouchControlsEnabled"):Connect(
        function()
            --[[
              line: 162
              upvalues:
                u5 (copy, index: 1)
            ]]
            u5:UpdateTouchGuiVisibility()
            u5:UpdateActiveControlModuleEnabled()
        end
    )
    if UserInputService_upv_1.TouchEnabled then
        u5.playerGui = Players_upv_1.LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if u5.playerGui then
            u5:CreateTouchGuiContainer()
            u5:OnLastInputTypeChanged(UserInputService_upv_1:GetLastInputType())
        else
            u5.playerGuiAddedConn = Players_upv_1.LocalPlayer.ChildAdded:Connect(
                function(a5)
                    --[[
                      line: 173
                      upvalues:
                        u5 (copy, index: 1)
                        UserInputService_upv_1 (copy, index: 2)
                    ]]
                    if not a5:IsA("PlayerGui") then
                        return
                    end
                    u5.playerGui = a5
                    u5:CreateTouchGuiContainer()
                    u5.playerGuiAddedConn:Disconnect()
                    u5.playerGuiAddedConn = nil
                    u5:OnLastInputTypeChanged(UserInputService_upv_1:GetLastInputType())
                end
            )
        end
    else
        u5:OnLastInputTypeChanged(UserInputService_upv_1:GetLastInputType())
    end
    return u5
end
function tbl_upv_1.GetMoveVector(a1)
    --[[
      name: GetMoveVector
      line: 193
    ]]
    if a1.activeController then
        return a1.activeController:GetMoveVector()
    end
    return Vector3.new(0, 0, 0)
end
local function NormalizeAngle(a1)
    --[[
      name: NormalizeAngle
      line: 200
    ]]
    a1 = (a1 + 12.566370614359172) % math.tau
    return ((a1 > math.pi) and (a1 - math.tau)) or a1
end
local function AverageAngle(a1, a2)
    --[[
      name: AverageAngle
      line: 208
    ]]
    local v3 = ((a2 - a1) + 12.566370614359172) % math.tau
    local v4 = ((a1 + ((((v3 > math.pi) and (v3 - math.tau)) or v3) / 2)) + 12.566370614359172) % math.tau
    return ((v4 > math.pi) and (v4 - math.tau)) or v4
end
function tbl_upv_1.GetEstimatedVRTorsoFrame(a1)
    --[[
      name: GetEstimatedVRTorsoFrame
      line: 213
      upvalues:
        VRService_upv_1 (copy, index: 1)
    ]]
    local v5 = VRService_upv_1:GetUserCFrame(Enum.UserCFrame.Head)
    local _, v6 = v5:ToEulerAnglesYXZ()
    local v7 = -v6
    if VRService_upv_1:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) then
        local v8 = nil
        if VRService_upv_1:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
            local v9 = VRService_upv_1:GetUserCFrame(Enum.UserCFrame.LeftHand)
            local v10 = VRService_upv_1:GetUserCFrame(Enum.UserCFrame.RightHand)
            local v11 = v5.Position - v9.Position
            local v12 = v5.Position - v10.Position
            local v13 = -math.atan2(v11.X, v11.Z)
            local v14 = ((-math.atan2(v12.X, v12.Z) - v13) + 12.566370614359172) % math.tau
            local v15 = ((v13 + ((((v14 > math.pi) and (v14 - math.tau)) or v14) / 2)) + 12.566370614359172) % math.tau
            local v16 = ((v15 > math.pi) and (v15 - math.tau)) or v15
            local v17 = ((v7 - a1.currentTorsoAngle) + 12.566370614359172) % math.tau
            v14 = ((v17 > math.pi) and (v17 - math.tau)) or v17
            local v18 = ((v16 - a1.currentTorsoAngle) + 12.566370614359172) % math.tau
            v18 = ((v18 > math.pi) and (v18 - math.tau)) or v18
            local v19 = false
            if v18 > -1.5707963267948966 then
                v19 = v18 < 1.5707963267948966
            end
            if not (v19) then
                v18 = v14
            end
            v8 = math.min(v18, v14)
            local v20 = math.max(v18, v14)
            local v21 = 0
            if v8 > 0 then
                v21 = v8
            elseif v20 < 0 then
                v21 = v20
            end
            a1.currentTorsoAngle = v21 + a1.currentTorsoAngle
        else
            a1.currentTorsoAngle = v7
        end
    else
        a1.currentTorsoAngle = v7
    end
    return CFrame.new(v5.Position) * CFrame.fromEulerAnglesYXZ(0, -a1.currentTorsoAngle, 0)
end
function tbl_upv_1.GetActiveController(a1)
    --[[
      name: GetActiveController
      line: 257
    ]]
    return a1.activeController
end
function tbl_upv_1.UpdateActiveControlModuleEnabled(a1)
    --[[
      name: UpdateActiveControlModuleEnabled
      line: 262
      upvalues:
        u3 (ref,  index: 1)
        Players_upv_1 (copy, index: 2)
        ClickToMoveController_upv_1 (copy, index: 3)
        TouchThumbstick_upv_1 (copy, index: 4)
        DynamicThumbstick_upv_1 (copy, index: 5)
        TouchJump_upv_1 (copy, index: 6)
        GuiService_upv_1 (copy, index: 7)
        UserInputService_upv_1 (copy, index: 8)
    ]]
    local v22 = function()
        --[[
          line: 275
          upvalues:
            u3 (ref,  index: 1)
            a1 (copy, index: 2)
            ClickToMoveController_upv_1 (copy, index: 3)
            TouchThumbstick_upv_1 (copy, index: 4)
            DynamicThumbstick_upv_1 (copy, index: 5)
            TouchJump_upv_1 (copy, index: 6)
            Players_upv_1 (copy, index: 7)
        ]]
        if u3 then
            if a1.touchControlFrame and (a1.activeControlModule == ClickToMoveController_upv_1 or a1.activeControlModule == TouchThumbstick_upv_1 or a1.activeControlModule == DynamicThumbstick_upv_1) then
                if not (a1.controllers[TouchJump_upv_1]) then
                    a1.controllers[TouchJump_upv_1] = TouchJump_upv_1.new()
                end
                a1.touchJumpController = a1.controllers[TouchJump_upv_1]
                a1.touchJumpController:Enable(true, a1.touchControlFrame)
            elseif a1.touchJumpController then
                a1.touchJumpController:Enable(false)
            end
        end
        if a1.activeControlModule == ClickToMoveController_upv_1 then
            a1.activeController:Enable(true, Players_upv_1.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice, a1.touchJumpController)
        elseif a1.touchControlFrame then
            a1.activeController:Enable(true, a1.touchControlFrame)
        else
            a1.activeController:Enable(true)
        end
    end
    if not a1.activeController then
        return
    end
    if a1.controlsEnabled then
        if not (GuiService_upv_1.TouchControlsEnabled) and UserInputService_upv_1.TouchEnabled then
            if a1.activeControlModule ~= ClickToMoveController_upv_1 and a1.activeControlModule ~= TouchThumbstick_upv_1 and a1.activeControlModule ~= DynamicThumbstick_upv_1 then
                v22()
                return
            end
            a1.activeController:Enable(false)
            if u3 and a1.touchJumpController then
                a1.touchJumpController:Enable(false)
            end
            if a1.moveFunction then
                a1.moveFunction(Players_upv_1.LocalPlayer, Vector3.new(0, 0, 0), true)
            end
            return
        end
        v22()
    else
        a1.activeController:Enable(false)
        if u3 and a1.touchJumpController then
            a1.touchJumpController:Enable(false)
        end
        if a1.moveFunction then
            a1.moveFunction(Players_upv_1.LocalPlayer, Vector3.new(0, 0, 0), true)
        end
    end
end
function tbl_upv_1.Enable(a1, a2)
    --[[
      name: Enable
      line: 336
    ]]
    if a2 == nil then
        a2 = true
    end
    a1.controlsEnabled = a2
    if not a1.activeController then
        return
    end
    a1:UpdateActiveControlModuleEnabled()
end
function tbl_upv_1.Disable(a1)
    --[[
      name: Disable
      line: 350
    ]]
    a1.controlsEnabled = false
    a1:UpdateActiveControlModuleEnabled()
end
function tbl_upv_1.SelectComputerMovementModule(a1)
    --[[
      name: SelectComputerMovementModule
      line: 358
      upvalues:
        UserInputService_upv_1 (copy, index: 1)
        Players_upv_1 (copy, index: 2)
        tbl_upv_3 (copy, index: 3)
        u4 (ref,  index: 4)
        UserGameSettings_upv_1 (copy, index: 5)
        Keyboard_upv_1 (copy, index: 6)
        ClickToMoveController_upv_1 (copy, index: 7)
        tbl_upv_2 (copy, index: 8)
    ]]
    if not (UserInputService_upv_1.KeyboardEnabled) and not (UserInputService_upv_1.GamepadEnabled) then
        return nil, false
    end
    local DevComputerMovementMode_1 = Players_upv_1.LocalPlayer.DevComputerMovementMode
    local v23, v24 = nil, nil
    if DevComputerMovementMode_1 ~= Enum.DevComputerMovementMode.UserChoice then
        v23 = tbl_upv_2[DevComputerMovementMode_1]
        if not v23 and DevComputerMovementMode_1 ~= Enum.DevComputerMovementMode.Scriptable then
            warn("No character control module is associated with DevComputerMovementMode ", DevComputerMovementMode_1)
        end
        v24 = v23
    else
        v24 = tbl_upv_3[u4]
        if UserGameSettings_upv_1.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove and v24 == Keyboard_upv_1 then
            v24 = ClickToMoveController_upv_1
        end
    end
    if v24 then
        return v24, true
    elseif DevComputerMovementMode_1 ~= Enum.DevComputerMovementMode.Scriptable then
        return nil, false
    else
        return nil, true
    end
end
function tbl_upv_1.SelectTouchModule(a1)
    --[[
      name: SelectTouchModule
      line: 396
      upvalues:
        UserInputService_upv_1 (copy, index: 1)
        Players_upv_1 (copy, index: 2)
        tbl_upv_2 (copy, index: 3)
        UserGameSettings_upv_1 (copy, index: 4)
    ]]
    if not UserInputService_upv_1.TouchEnabled then
        return nil, false
    end
    local DevTouchMovementMode_1 = Players_upv_1.LocalPlayer.DevTouchMovementMode
    local v25 = nil
    if DevTouchMovementMode_1 == Enum.DevTouchMovementMode.UserChoice then
        v25 = tbl_upv_2[UserGameSettings_upv_1.TouchMovementMode]
    elseif DevTouchMovementMode_1 ~= Enum.DevTouchMovementMode.Scriptable then
        v25 = tbl_upv_2[DevTouchMovementMode_1]
    else
        return nil, true
    end
    return v25, true
end
local function getGamepadRightThumbstickPosition()
    --[[
      name: getGamepadRightThumbstickPosition
      line: 412
      upvalues:
        UserInputService_upv_1 (copy, index: 1)
    ]]
    for _, value_1 in pairs(UserInputService_upv_1:GetGamepadState(Enum.UserInputType.Gamepad1)) do
        if value_1.KeyCode ~= Enum.KeyCode.Thumbstick2 then
            continue
        end
        return value_1.Position
    end
    return Vector3.new(0, 0, 0)
end
function tbl_upv_1.calculateRawMoveVector(a1, a2, a3)
    --[[
      name: calculateRawMoveVector
      line: 422
      upvalues:
        Workspace_upv_1 (copy, index: 1)
        VRService_upv_1 (copy, index: 2)
        getGamepadRightThumbstickPosition (copy, index: 3)
    ]]
    local CurrentCamera_1 = Workspace_upv_1.CurrentCamera
    if not CurrentCamera_1 then
        return a3
    end
    local CFrame_1 = CurrentCamera_1.CFrame
    if VRService_upv_1.VREnabled and a2.RootPart then
        local _ = VRService_upv_1:GetUserCFrame(Enum.UserCFrame.Head)
        local v26 = a1:GetEstimatedVRTorsoFrame()
        CFrame_1 = (((CurrentCamera_1.Focus.Position - CFrame_1.Position).Magnitude < 3) and (CFrame_1 * v26)) or (CurrentCamera_1.CFrame * (v26.Rotation + (v26.Position * CurrentCamera_1.HeadScale)))
    end
    local v27 = nil
    if a2:GetState() ~= Enum.HumanoidStateType.Swimming then
        local _, v39, v40, v28, v29, v30, v41, v42, v27, v43, v44, v31 = CFrame_1:GetComponents()
        local v32, v33
        if (v27 < 1) and (v27 > -1) then
            v32, v33 = v31, v30
        else
            v32, v33 = v28, -v29 * math.sign(v27)
        end
        local v34 = math.sqrt((v32 * v32) + (v33 * v33))
        return (Vector3.new(((v32 * a3.X) + (v33 * a3.Z)) / v34, 0, ((v32 * a3.Z) - (v33 * a3.X)) / v34))
    else
        if not VRService_upv_1.VREnabled then
            return CFrame_1:VectorToWorldSpace(a3)
        end
        local v35 = Vector3.new(a3.X, 0, a3.Z)
        if v35.Magnitude < 0.01 then
            return Vector3.new(0, 0, 0)
        end
        local v36 = -getGamepadRightThumbstickPosition().Y * 1.3962634015954636
        local v37 = math.atan2(-v35.X, -v35.Z)
        local _, v38 = CFrame_1:ToEulerAnglesYXZ()
        return CFrame.fromEulerAnglesYXZ(v36, v37 + v38, 0).LookVector
    end
end
local u6 = Vector3.new()
local _ = Vector3.new()
local u7 = 0
local u8 = 0
local u9 = 0
local function calculateRawMoveVector(a1, a2)
    --[[
      name: calculateRawMoveVector
      line: 481
      upvalues:
        Workspace_upv_1 (copy, index: 1)
        VRService_upv_1 (copy, index: 2)
    ]]
    local CurrentCamera_2 = Workspace_upv_1.CurrentCamera
    if not CurrentCamera_2 then
        return a2
    end
    if a1:GetState() == Enum.HumanoidStateType.Swimming then
        return CurrentCamera_2.CFrame:VectorToWorldSpace(a2)
    end
    local CFrame_2 = CurrentCamera_2.CFrame
    if VRService_upv_1.VREnabled and a1.RootPart then
        CFrame_2 = (((a1.RootPart.CFrame.Position - CFrame_2.Position).Magnitude < 3) and (CFrame_2 * VRService_upv_1:GetUserCFrame(Enum.UserCFrame.Head))) or CFrame_2
    end
    local _, v47, v48, v39, v40, v41, v49, v50, v42, v51, v52, v43 = CFrame_2:GetComponents()
    local v44, v45
    if (v42 < 1) and (v42 > -1) then
        v44, v45 = v43, v41
    else
        v44, v45 = v39, -v40 * math.sign(v42)
    end
    local v46 = math.sqrt((v44 * v44) + (v45 * v45))
    return (Vector3.new(((v44 * a2.X) + (v45 * a2.Z)) / v46, 0, ((v44 * a2.Z) - (v45 * a2.X)) / v46))
end
function tbl_upv_1.OnRenderStepped(a1, a2)
    --[[
      name: OnRenderStepped
      line: 534
      upvalues:
        u1 (copy, index: 1)
        Gamepad_upv_1 (copy, index: 2)
        calculateRawMoveVector (copy, index: 3)
        u6 (ref,  index: 4)
        u7 (ref,  index: 6)
        u8 (ref,  index: 7)
        u9 (ref,  index: 8)
        Players_upv_1 (copy, index: 9)
    ]]
    if not a1.activeController or not a1.activeController.enabled then
        return
    end
    if a1.humanoid then
        if not (u1) then
            a1.activeController:OnRenderStepped(a2)
        end
        local v47 = a1.activeController:GetMoveVector()
        local v48 = a1.activeController:IsMoveVectorCameraRelative()
        local v49 = a1:GetClickToMoveController()
        if a1.activeController ~= v49 then
            if v47.magnitude > 0 then
                v49:CleanupPath()
            else
                v49:OnRenderStepped(a2)
                v47, v48 = v49:GetMoveVector(), v49:IsMoveVectorCameraRelative()
            end
        end
        if a1.vehicleController then
            v47 = a1.vehicleController:Update(v47, v48, a1.activeControlModule == Gamepad_upv_1)
        end
        v47 = v48 and calculateRawMoveVector(a1.humanoid, v47)
        local v50 = a1.activeController:GetIsJumping() or (a1.touchJumpController and (a1.touchJumpController:GetIsJumping()))
        u6 = v47
        v51 = v51:Lerp(u6, math.clamp(a2 * 10, 0, 1))
        local X_1 = v51.X
        local Y_1 = v51.Y
        local v52 = v51.Z
        if X_1 < u7 and X_1 > 0 and X_1 < 0.1 or u7 < X_1 and X_1 < 0 and X_1 > -0.1 then
            X_1 = 0
        end
        if Y_1 < u8 and Y_1 > 0 and Y_1 < 0.1 or u8 < Y_1 and Y_1 < 0 and Y_1 > -0.1 then
            Y_1 = 0
        end
        if v52 < u9 and v52 > 0 and v52 < 0.1 or u9 < v52 and v52 < 0 and v52 > -0.1 then
            v52 = 0
        end
        v51 = Vector3.new(X_1, Y_1, v52)
        u7 = X_1
        u8 = Y_1
        u9 = v52
        a1.moveFunction(Players_upv_1.LocalPlayer, v51, false)
        a1.humanoid.Jump = v50
    end
end
function tbl_upv_1.updateVRMoveVector(a1, a2)
    --[[
      name: updateVRMoveVector
      line: 610
      upvalues:
        VRService_upv_1 (copy, index: 1)
    ]]
    local CurrentCamera_3 = workspace.CurrentCamera
    local v53 = ((CurrentCamera_3.Focus.Position - CurrentCamera_3.CFrame.Position).Magnitude < 5) and true
    if a2.Magnitude == 0 and v53 and VRService_upv_1.AvatarGestures and a1.humanoid and not (a1.humanoid.Sit) then
        local v54 = VRService_upv_1:GetUserCFrame(Enum.UserCFrame.Head)
        local v55 = ((CurrentCamera_3.CFrame * (v54.Rotation + (v54.Position * CurrentCamera_3.HeadScale))) * CFrame.new(0, (-0.7 * a1.humanoid.RootPart.Size.Y) / 2, 0)).Position - a1.humanoid.RootPart.CFrame.Position
        return (Vector3.new(v55.x, 0, v55.z))
    end
    return a2
end
function tbl_upv_1.OnHumanoidSeated(a1, a2, a3)
    --[[
      name: OnHumanoidSeated
      line: 635
      upvalues:
        Value_upv_1 (copy, index: 1)
    ]]
    if a2 then
        if not a3 or not a3:IsA("VehicleSeat") then
            return
        end
        if not (a1.vehicleController) then
            a1.vehicleController = a1.vehicleController.new(Value_upv_1)
        end
        a1.vehicleController:Enable(true, a3)
    elseif a1.vehicleController then
        a1.vehicleController:Enable(false, a3)
    end
end
function tbl_upv_1.OnCharacterAdded(a1, a2)
    --[[
      name: OnCharacterAdded
      line: 650
    ]]
    a1.humanoid = a2:FindFirstChildOfClass("Humanoid")
    while not (a1.humanoid) do
        a2.ChildAdded:wait()
        a1.humanoid = a2:FindFirstChildOfClass("Humanoid")
    end
    a1:UpdateTouchGuiVisibility()
    if a1.humanoidSeatedConn then
        a1.humanoidSeatedConn:Disconnect()
        a1.humanoidSeatedConn = nil
    end
    a1.humanoidSeatedConn = a1.humanoid.Seated:Connect(
        function(a3, a4)
            --[[
              line: 663
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1:OnHumanoidSeated(a3, a4)
        end
    )
end
function tbl_upv_1.OnCharacterRemoving(a1, a2)
    --[[
      name: OnCharacterRemoving
      line: 668
    ]]
    a1.humanoid = nil
    a1:UpdateTouchGuiVisibility()
end
function tbl_upv_1.UpdateTouchGuiVisibility(a1)
    --[[
      name: UpdateTouchGuiVisibility
      line: 674
      upvalues:
        GuiService_upv_1 (copy, index: 1)
    ]]
    if not a1.touchGui then
        return
    end
    a1.touchGui.Enabled = a1.humanoid and GuiService_upv_1.TouchControlsEnabled
end
function tbl_upv_1.SwitchToController(a1, a2)
    --[[
      name: SwitchToController
      line: 688
      upvalues:
        Value_upv_1 (copy, index: 1)
        u3 (ref,  index: 2)
        ClickToMoveController_upv_1 (copy, index: 3)
        TouchThumbstick_upv_1 (copy, index: 4)
        DynamicThumbstick_upv_1 (copy, index: 5)
        TouchJump_upv_1 (copy, index: 6)
    ]]
    if a2 then
        if not (a1.controllers[a2]) then
            a1.controllers[a2] = a2.new(Value_upv_1)
        end
        if a1.activeController ~= a1.controllers[a2] then
            if a1.activeController then
                a1.activeController:Enable(false)
            end
            a1.activeController = a1.controllers[a2]
            a1.activeControlModule = a2
            if not (u3) then
                if a1.touchControlFrame and (a1.activeControlModule == ClickToMoveController_upv_1 or a1.activeControlModule == TouchThumbstick_upv_1 or a1.activeControlModule == DynamicThumbstick_upv_1) then
                    if not (a1.controllers[TouchJump_upv_1]) then
                        a1.controllers[TouchJump_upv_1] = TouchJump_upv_1.new()
                    end
                    a1.touchJumpController = a1.controllers[TouchJump_upv_1]
                    a1.touchJumpController:Enable(true, a1.touchControlFrame)
                elseif a1.touchJumpController then
                    a1.touchJumpController:Enable(false)
                end
            end
            a1:UpdateActiveControlModuleEnabled()
        end
    else
        if a1.activeController then
            a1.activeController:Enable(false)
        end
        a1.activeController = nil
        a1.activeControlModule = nil
    end
end
function tbl_upv_1.OnLastInputTypeChanged(a1, a2)
    --[[
      name: OnLastInputTypeChanged
      line: 732
      upvalues:
        u4 (ref,  index: 1)
        tbl_upv_3 (copy, index: 2)
    ]]
    if u4 == a2 then
        warn("LastInputType Change listener called with current type.")
    end
    u4 = a2
    local v56 = nil
    if u4 == Enum.UserInputType.Touch then
        local v57, v58 = a1:SelectTouchModule()
        if v58 then
            while not (a1.touchControlFrame) do
                wait()
            end
            a1:SwitchToController(v57)
        end
    elseif tbl_upv_3[u4] ~= nil then
        v56 = a1:SelectComputerMovementModule()
        if v56 then
            a1:SwitchToController(v56)
        end
    end
    a1:UpdateTouchGuiVisibility()
end
function tbl_upv_1.OnComputerMovementModeChange(a1)
    --[[
      name: OnComputerMovementModeChange
      line: 759
    ]]
    local v59, v60 = a1:SelectComputerMovementModule()
    if not v60 then
        return
    end
    a1:SwitchToController(v59)
end
function tbl_upv_1.OnTouchMovementModeChange(a1)
    --[[
      name: OnTouchMovementModeChange
      line: 766
    ]]
    local v61, v62 = a1:SelectTouchModule()
    if not v62 then
        return
    end
    while not (a1.touchControlFrame) do
        wait()
    end
    a1:SwitchToController(v61)
end
function tbl_upv_1.CreateTouchGuiContainer(a1)
    --[[
      name: CreateTouchGuiContainer
      line: 776
      upvalues:
        u2 (ref, index: 1)
    ]]
    if a1.touchGui then
        a1.touchGui:Destroy()
    end
    a1.touchGui = Instance.new("ScreenGui")
    a1.touchGui.Name = "TouchGui"
    a1.touchGui.ResetOnSpawn = false
    a1.touchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    a1:UpdateTouchGuiVisibility()
    if u2 then
        a1.touchGui.ClipToDeviceSafeArea = false
    end
    a1.touchControlFrame = Instance.new("Frame")
    a1.touchControlFrame.Name = "TouchControlFrame"
    a1.touchControlFrame.Size = UDim2.new(1, 0, 1, 0)
    a1.touchControlFrame.BackgroundTransparency = 1
    a1.touchControlFrame.Parent = a1.touchGui
    a1.touchGui.Parent = a1.playerGui
end
function tbl_upv_1.GetClickToMoveController(a1)
    --[[
      name: GetClickToMoveController
      line: 799
      upvalues:
        ClickToMoveController_upv_1 (copy, index: 1)
        Value_upv_1 (copy, index: 2)
    ]]
    if not (a1.controllers[ClickToMoveController_upv_1]) then
        a1.controllers[ClickToMoveController_upv_1] = ClickToMoveController_upv_1.new(Value_upv_1)
    end
    return a1.controllers[ClickToMoveController_upv_1]
end
return tbl_upv_1.new()