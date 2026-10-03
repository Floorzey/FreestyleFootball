--[[
    Script Path: Game/StarterPlayer/StarterPlayerScripts/PlayerModule/CameraModule/BaseCamera
    Class: ModuleScript
    Time: 2026-10-03 12:27:04
--]]

local FlagUtil_1 = require(script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil"))
local success_1, v1 = pcall(
    function()
        --[[
          line: 15
        ]]
        return UserSettings():IsUserFeatureEnabled("UserFixGamepadMaxZoom")
    end
)
local u1 = success_1 and v1
local u2 = FlagUtil_1.getUserFlag("UserFixCameraOffsetJitter2")
local _ = Vector2.new(0.2617993877991494, 0)
local v2 = Vector2.new(0.7853981633974483, 0)
local v3 = Vector2.new(0, 0)
local CameraUtils_upv_1 = require(script.Parent:WaitForChild("CameraUtils"))
local ZoomController_upv_1 = require(script.Parent:WaitForChild("ZoomController"))
local CameraToggleStateController_upv_1 = require(script.Parent:WaitForChild("CameraToggleStateController"))
local CameraInput_upv_1 = require(script.Parent:WaitForChild("CameraInput"))
local CameraUI_upv_1 = require(script.Parent:WaitForChild("CameraUI"))
local Players_1 = game:GetService("Players")
local UserInputService_upv_1 = game:GetService("UserInputService")
local v4 = game:GetService("StarterGui")
local VRService_upv_1 = game:GetService("VRService")
local UserGameSettings_upv_1 = UserSettings():GetService("UserGameSettings")
local LocalPlayer_upv_1 = Players_1.LocalPlayer
local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.new()
    --[[
      name: new
      line: 72
      upvalues:
        tbl_upv_1 (copy, index: 1)
        LocalPlayer_upv_1 (copy, index: 2)
        UserGameSettings_upv_1 (copy, index: 3)
    ]]
    local u3 = setmetatable({}, tbl_upv_1)
    u3.gamepadZoomLevels = {0, 10, 20}
    u3.FIRST_PERSON_DISTANCE_THRESHOLD = 1
    u3.cameraType = nil
    u3.cameraMovementMode = nil
    u3.lastCameraTransform = nil
    u3.lastUserPanCamera = tick()
    u3.humanoidRootPart = nil
    u3.humanoidCache = {}
    u3.lastSubject = nil
    u3.lastSubjectPosition = Vector3.new(0, 5, 0)
    u3.lastSubjectCFrame = CFrame.new(u3.lastSubjectPosition)
    u3.currentSubjectDistance = math.clamp(12.5, LocalPlayer_upv_1.CameraMinZoomDistance, LocalPlayer_upv_1.CameraMaxZoomDistance)
    u3.inFirstPerson = false
    u3.inMouseLockedMode = false
    u3.portraitMode = false
    u3.isSmallTouchScreen = false
    u3.resetCameraAngle = true
    u3.enabled = false
    u3.PlayerGui = nil
    u3.cameraChangedConn = nil
    u3.viewportSizeChangedConn = nil
    u3.shouldUseVRRotation = false
    u3.VRRotationIntensityAvailable = false
    u3.lastVRRotationIntensityCheckTime = 0
    u3.lastVRRotationTime = 0
    u3.vrRotateKeyCooldown = {}
    u3.cameraTranslationConstraints = Vector3.new(1, 1, 1)
    u3.humanoidJumpOrigin = nil
    u3.trackingHumanoid = nil
    u3.cameraFrozen = false
    u3.subjectStateChangedConn = nil
    u3.gamepadZoomPressConnection = nil
    u3.mouseLockOffset = Vector3.new(0, 0, 0)
    if LocalPlayer_upv_1.Character then
        u3:OnCharacterAdded(LocalPlayer_upv_1.Character)
    end
    LocalPlayer_upv_1.CharacterAdded:Connect(
        function(a1)
            --[[
              line: 137
              upvalues:
                u3 (copy, index: 1)
            ]]
            u3:OnCharacterAdded(a1)
        end
    )
    if u3.playerCameraModeChangeConn then
        u3.playerCameraModeChangeConn:Disconnect()
    end
    u3.playerCameraModeChangeConn = LocalPlayer_upv_1:GetPropertyChangedSignal("CameraMode"):Connect(
        function()
            --[[
              line: 142
              upvalues:
                u3 (copy, index: 1)
            ]]
            u3:OnPlayerCameraPropertyChange()
        end
    )
    if u3.minDistanceChangeConn then
        u3.minDistanceChangeConn:Disconnect()
    end
    u3.minDistanceChangeConn = LocalPlayer_upv_1:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(
        function()
            --[[
              line: 147
              upvalues:
                u3 (copy, index: 1)
            ]]
            u3:OnPlayerCameraPropertyChange()
        end
    )
    if u3.maxDistanceChangeConn then
        u3.maxDistanceChangeConn:Disconnect()
    end
    u3.maxDistanceChangeConn = LocalPlayer_upv_1:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(
        function()
            --[[
              line: 152
              upvalues:
                u3 (copy, index: 1)
            ]]
            u3:OnPlayerCameraPropertyChange()
        end
    )
    if u3.playerDevTouchMoveModeChangeConn then
        u3.playerDevTouchMoveModeChangeConn:Disconnect()
    end
    u3.playerDevTouchMoveModeChangeConn = LocalPlayer_upv_1:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(
        function()
            --[[
              line: 157
              upvalues:
                u3 (copy, index: 1)
            ]]
            u3:OnDevTouchMovementModeChanged()
        end
    )
    u3:OnDevTouchMovementModeChanged()
    if u3.gameSettingsTouchMoveMoveChangeConn then
        u3.gameSettingsTouchMoveMoveChangeConn:Disconnect()
    end
    u3.gameSettingsTouchMoveMoveChangeConn = UserGameSettings_upv_1:GetPropertyChangedSignal("TouchMovementMode"):Connect(
        function()
            --[[
              line: 163
              upvalues:
                u3 (copy, index: 1)
            ]]
            u3:OnGameSettingsTouchMovementModeChanged()
        end
    )
    u3:OnGameSettingsTouchMovementModeChanged()
    UserGameSettings_upv_1:SetCameraYInvertVisible()
    UserGameSettings_upv_1:SetGamepadCameraSensitivityVisible()
    u3.hasGameLoaded = game:IsLoaded()
    if not (u3.hasGameLoaded) then
        u3.gameLoadedConn = game.Loaded:Connect(
            function()
                --[[
                  line: 173
                  upvalues:
                    u3 (copy, index: 1)
                ]]
                u3.hasGameLoaded = true
                u3.gameLoadedConn:Disconnect()
                u3.gameLoadedConn = nil
            end
        )
    end
    u3:OnPlayerCameraPropertyChange()
    return u3
end
function tbl_upv_1.GetModuleName(a1)
    --[[
      name: GetModuleName
      line: 185
    ]]
    return "BaseCamera"
end
function tbl_upv_1.OnCharacterAdded(a1, a2)
    --[[
      name: OnCharacterAdded
      line: 189
      upvalues:
        UserInputService_upv_1 (copy, index: 1)
        LocalPlayer_upv_1 (copy, index: 2)
    ]]
    a1.resetCameraAngle = a1.resetCameraAngle or a1:GetEnabled()
    a1.humanoidRootPart = nil
    if not UserInputService_upv_1.TouchEnabled then
        return
    end
    a1.PlayerGui = LocalPlayer_upv_1:WaitForChild("PlayerGui")
    for _, value_1 in ipairs(a2:GetChildren()) do
        if value_1:IsA("Tool") then
            a1.isAToolEquipped = true
        end
    end
    a2.ChildAdded:Connect(
        function(a3)
            --[[
              line: 199
              upvalues:
                a1 (copy, index: 1)
            ]]
            if not a3:IsA("Tool") then
                return
            end
            a1.isAToolEquipped = true
        end
    )
    a2.ChildRemoved:Connect(
        function(a4)
            --[[
              line: 204
              upvalues:
                a1 (copy, index: 1)
            ]]
            if not a4:IsA("Tool") then
                return
            end
            a1.isAToolEquipped = false
        end
    )
end
function tbl_upv_1.GetHumanoidRootPart(a1)
    --[[
      name: GetHumanoidRootPart
      line: 212
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
    ]]
    if not (a1.humanoidRootPart) and LocalPlayer_upv_1.Character then
        local v3 = LocalPlayer_upv_1.Character:FindFirstChildOfClass("Humanoid")
        if v3 then
            a1.humanoidRootPart = v3.RootPart
        end
    end
    return a1.humanoidRootPart
end
function tbl_upv_1.GetBodyPartToFollow(a1, a2, a3)
    --[[
      name: GetBodyPartToFollow
      line: 224
    ]]
    if a2:GetState() == Enum.HumanoidStateType.Dead then
        local Parent_1 = a2.Parent
        if Parent_1 and Parent_1:IsA("Model") then
            local v4 = Parent_1:FindFirstChild("Head") or (a2.RootPart)
            return v4
        end
    end
    return a2.RootPart
end
function tbl_upv_1.GetSubjectCFrame(a1)
    --[[
      name: GetSubjectCFrame
      line: 236
      upvalues:
        u2 (copy, index: 1)
    ]]
    local v5 = a1.lastSubjectCFrame
    local CurrentCamera_1 = workspace.CurrentCamera
    local v6 = CurrentCamera_1 and (CurrentCamera_1.CameraSubject)
    if v6 then
        if v6:IsA("Humanoid") then
            local v7 = v6:GetState() == Enum.HumanoidStateType.Dead
            local CameraOffset_1 = CurrentCamera_1.CameraOffset
            if u2 and a1:GetIsMouseLocked() then
                local _ = Vector3.new()
            end
            local RootPart_1 = CurrentCamera_1.RootPart
            if v7 and CurrentCamera_1.Parent then
                local v8 = CurrentCamera_1.Parent:IsA("Model")
                RootPart_1 = v8 and (CurrentCamera_1.Parent:FindFirstChild("Head") or RootPart_1)
            end
            if RootPart_1 then
                local v9 = RootPart_1:IsA("BasePart")
                if v9 then
                    if CurrentCamera_1.RigType ~= Enum.HumanoidRigType.R15 then
                        v9 = Vector3.new(0, 1.5, 0)
                    else
                        local v10 = nil
                        if CurrentCamera_1.AutomaticScalingEnabled then
                            v9 = Vector3.new(0, 1.5, 0)
                            v10 = CurrentCamera_1.RootPart
                            if RootPart_1 == v10 then
                                v9 = v9 + Vector3.new(0, (v10.Size.Y - 2) / 2, 0)
                            end
                        else
                            v9 = Vector3.new(0, 2, 0)
                        end
                    end
                    v5 = RootPart_1.CFrame * CFrame.new(((v7 and Vector3.new(0, 0, 0)) or v9) + CameraOffset_1)
                end
            end
        elseif v6:IsA("BasePart") then
            v5 = v6.CFrame
        else
            local v11 = v6:IsA("Model")
            if v11 then
                if v6.PrimaryPart then
                    v5 = v6:GetPrimaryPartCFrame()
                else
                    v5 = CFrame.new()
                end
            end
        end
        if v5 then
            a1.lastSubjectCFrame = v5
        end
    end
    return v5
end
function tbl_upv_1.GetSubjectVelocity(a1)
    --[[
      name: GetSubjectVelocity
      line: 310
    ]]
    local CurrentCamera_2 = workspace.CurrentCamera
    local v12 = CurrentCamera_2 and (CurrentCamera_2.CameraSubject)
    if v12 then
        if v12:IsA("BasePart") then
            return v12.Velocity
        else
            local v13 = nil
            if v12:IsA("Humanoid") then
                v13 = v12.RootPart
                if v13 then
                    return v13.Velocity
                end
            elseif v12:IsA("Model") then
                local PrimaryPart_1 = v12.PrimaryPart
                if PrimaryPart_1 then
                    return PrimaryPart_1.Velocity
                end
            end
            return Vector3.new(0, 0, 0)
        end
    else
        return Vector3.new(0, 0, 0)
    end
end
function tbl_upv_1.GetSubjectRotVelocity(a1)
    --[[
      name: GetSubjectRotVelocity
      line: 339
    ]]
    local CurrentCamera_3 = workspace.CurrentCamera
    local v14 = CurrentCamera_3 and (CurrentCamera_3.CameraSubject)
    if v14 then
        if v14:IsA("BasePart") then
            return v14.RotVelocity
        else
            local v15 = nil
            if v14:IsA("Humanoid") then
                v15 = v14.RootPart
                if v15 then
                    return v15.RotVelocity
                end
            elseif v14:IsA("Model") then
                local PrimaryPart_2 = v14.PrimaryPart
                if PrimaryPart_2 then
                    return PrimaryPart_2.RotVelocity
                end
            end
            return Vector3.new(0, 0, 0)
        end
    else
        return Vector3.new(0, 0, 0)
    end
end
function tbl_upv_1.StepZoom(a1)
    --[[
      name: StepZoom
      line: 368
      upvalues:
        CameraInput_upv_1 (copy, index: 1)
        ZoomController_upv_1 (copy, index: 2)
    ]]
    local currentSubjectDistance_1 = a1.currentSubjectDistance
    local v16 = CameraInput_upv_1.getZoomDelta()
    if math.abs(v16) > 0 then
        local v17
        if v16 > 0 then
            v17 = math.max(currentSubjectDistance_1 + (v16 * ((currentSubjectDistance_1 * 0.5) + 1)), a1.FIRST_PERSON_DISTANCE_THRESHOLD)
        else
            v17 = math.max((currentSubjectDistance_1 + v16) / (1 - (v16 * 0.5)), 0.5)
        end
        if v17 < a1.FIRST_PERSON_DISTANCE_THRESHOLD then
            v17 = 0.5
        end
        a1:SetCameraToSubjectDistance(v17)
    end
    return ZoomController_upv_1.GetZoomRadius()
end
function tbl_upv_1.GetSubjectPosition(a1)
    --[[
      name: GetSubjectPosition
      line: 393
      upvalues:
        u2 (copy, index: 1)
    ]]
    local v18 = a1.lastSubjectPosition
    local CurrentCamera_4 = game.Workspace.CurrentCamera
    local v19 = CurrentCamera_4 and (CurrentCamera_4.CameraSubject)
    if v19 then
        if v19:IsA("Humanoid") then
            local v20 = v19:GetState() == Enum.HumanoidStateType.Dead
            local CameraOffset_2 = CurrentCamera_4.CameraOffset
            if u2 and a1:GetIsMouseLocked() then
                local _ = Vector3.new()
            end
            local RootPart_2 = CurrentCamera_4.RootPart
            if v20 and CurrentCamera_4.Parent then
                local v21 = CurrentCamera_4.Parent:IsA("Model")
                RootPart_2 = v21 and (CurrentCamera_4.Parent:FindFirstChild("Head") or RootPart_2)
            end
            if RootPart_2 then
                local v22 = RootPart_2:IsA("BasePart")
                if v22 then
                    if CurrentCamera_4.RigType ~= Enum.HumanoidRigType.R15 then
                        v22 = Vector3.new(0, 1.5, 0)
                    elseif CurrentCamera_4.AutomaticScalingEnabled then
                        v22 = Vector3.new(0, 1.5, 0)
                        if RootPart_2 == CurrentCamera_4.RootPart then
                            v22 = v22 + Vector3.new(0, CurrentCamera_4.RootPart.Size.Y / 2 - 1, 0)
                        end
                    else
                        v22 = Vector3.new(0, 2, 0)
                    end
                    v18 = RootPart_2.CFrame.p + RootPart_2.CFrame:vectorToWorldSpace(((v20 and Vector3.new(0, 0, 0)) or v22) + CameraOffset_2)
                end
            end
        elseif v19:IsA("VehicleSeat") then
            v18 = v19.CFrame.p + v19.CFrame:vectorToWorldSpace(Vector3.new(0, 5, 0))
        elseif v19:IsA("SkateboardPlatform") then
            v18 = v19.CFrame.p + Vector3.new(0, 5, 0)
        elseif v19:IsA("BasePart") then
            v18 = v19.CFrame.p
        else
            local v23 = v19:IsA("Model")
            if v23 then
                if v19.PrimaryPart then
                    v18 = v19:GetPrimaryPartCFrame().p
                else
                    v18 = v19:GetModelCFrame().p
                end
            end
        end
        a1.lastSubject = CurrentCamera_4
        a1.lastSubjectPosition = v18
        return v18
    end
    return nil
end
function tbl_upv_1.OnViewportSizeChanged(a1)
    --[[
      name: OnViewportSizeChanged
      line: 470
      upvalues:
        UserInputService_upv_1 (copy, index: 1)
    ]]
    local ViewportSize_1 = game.Workspace.CurrentCamera.ViewportSize
    a1.portraitMode = ViewportSize_1.X < ViewportSize_1.Y
    local TouchEnabled_1 = UserInputService_upv_1.TouchEnabled
    local v24
    if TouchEnabled_1 then
        v24 = true
        if not (ViewportSize_1.Y < 500) then
            v24 = ViewportSize_1.X < 700
        end
    else
        v24 = TouchEnabled_1
    end
    a1.isSmallTouchScreen = v24
end
function tbl_upv_1.OnCurrentCameraChanged(a1)
    --[[
      name: OnCurrentCameraChanged
      line: 478
      upvalues:
        UserInputService_upv_1 (copy, index: 1)
    ]]
    if UserInputService_upv_1.TouchEnabled then
        if a1.viewportSizeChangedConn then
            a1.viewportSizeChangedConn:Disconnect()
            a1.viewportSizeChangedConn = nil
        end
        local CurrentCamera_5 = game.Workspace.CurrentCamera
        if CurrentCamera_5 then
            a1:OnViewportSizeChanged()
            a1.viewportSizeChangedConn = CurrentCamera_5:GetPropertyChangedSignal("ViewportSize"):Connect(
                function()
                    --[[
                      line: 489
                      upvalues:
                        a1 (copy, index: 1)
                    ]]
                    a1:OnViewportSizeChanged()
                end
            )
        end
    end
    if a1.cameraSubjectChangedConn then
        a1.cameraSubjectChangedConn:Disconnect()
        a1.cameraSubjectChangedConn = nil
    end
    local CurrentCamera_6 = game.Workspace.CurrentCamera
    if not CurrentCamera_6 then
        return
    end
    a1.cameraSubjectChangedConn = CurrentCamera_6:GetPropertyChangedSignal("CameraSubject"):Connect(
        function()
            --[[
              line: 503
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1:OnNewCameraSubject()
        end
    )
    a1:OnNewCameraSubject()
end
function tbl_upv_1.OnDynamicThumbstickEnabled(a1)
    --[[
      name: OnDynamicThumbstickEnabled
      line: 510
      upvalues:
        UserInputService_upv_1 (copy, index: 1)
    ]]
    if not UserInputService_upv_1.TouchEnabled then
        return
    end
    a1.isDynamicThumbstickEnabled = true
end
function tbl_upv_1.OnDynamicThumbstickDisabled(a1)
    --[[
      name: OnDynamicThumbstickDisabled
      line: 516
    ]]
    a1.isDynamicThumbstickEnabled = false
end
function tbl_upv_1.OnGameSettingsTouchMovementModeChanged(a1)
    --[[
      name: OnGameSettingsTouchMovementModeChanged
      line: 520
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        UserGameSettings_upv_1 (copy, index: 2)
    ]]
    if LocalPlayer_upv_1.DevTouchMovementMode ~= Enum.DevTouchMovementMode.UserChoice then
        return
    end
    if UserGameSettings_upv_1.TouchMovementMode ~= Enum.TouchMovementMode.DynamicThumbstick and UserGameSettings_upv_1.TouchMovementMode ~= Enum.TouchMovementMode.Default then
        a1:OnDynamicThumbstickDisabled()
        return
    end
    a1:OnDynamicThumbstickEnabled()
end
function tbl_upv_1.OnDevTouchMovementModeChanged(a1)
    --[[
      name: OnDevTouchMovementModeChanged
      line: 531
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
    ]]
    if LocalPlayer_upv_1.DevTouchMovementMode ~= Enum.DevTouchMovementMode.DynamicThumbstick then
        a1:OnGameSettingsTouchMovementModeChanged()
    else
        a1:OnDynamicThumbstickEnabled()
    end
end
function tbl_upv_1.OnPlayerCameraPropertyChange(a1)
    --[[
      name: OnPlayerCameraPropertyChange
      line: 539
    ]]
    a1:SetCameraToSubjectDistance(a1.currentSubjectDistance)
end
function tbl_upv_1.InputTranslationToCameraAngleChange(a1, a2, a3)
    --[[
      name: InputTranslationToCameraAngleChange
      line: 544
    ]]
    return a2 * a3
end
function tbl_upv_1.GamepadZoomPress(a1)
    --[[
      name: GamepadZoomPress
      line: 550
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        u1 (ref,  index: 2)
    ]]
    local v25 = a1:GetCameraToSubjectDistance()
    local v26 = LocalPlayer_upv_1.CameraMaxZoomDistance
    local v27 = nil
    for n_1 = #a1.gamepadZoomLevels, 1, -1 do
        v27 = a1.gamepadZoomLevels[n_1]
        if v26 < v27 then
            continue
        end
        if v27 < LocalPlayer_upv_1.CameraMinZoomDistance then
            local CameraMinZoomDistance_1 = LocalPlayer_upv_1.CameraMinZoomDistance
            if u1 and v26 == CameraMinZoomDistance_1 then
                break
            end
            v27 = CameraMinZoomDistance_1
        end
        if u1 or v26 ~= v27 then
            if not (v27 + ((v26 - v27) / 2) < v25) then
                v26 = v27
                continue
            end
            a1:SetCameraToSubjectDistance(v27)
            return
        end
        break
    end
    a1:SetCameraToSubjectDistance(a1.gamepadZoomLevels[#a1.gamepadZoomLevels])
end
function tbl_upv_1.Enable(a1, a2)
    --[[
      name: Enable
      line: 595
    ]]
    if a1.enabled == a2 then
        return
    end
    a1.enabled = a2
    a1:OnEnabledChanged()
end
function tbl_upv_1.OnEnabledChanged(a1)
    --[[
      name: OnEnabledChanged
      line: 603
      upvalues:
        CameraInput_upv_1 (copy, index: 1)
        LocalPlayer_upv_1 (copy, index: 2)
    ]]
    if a1.enabled then
        CameraInput_upv_1.setInputEnabled(true)
        a1.gamepadZoomPressConnection = CameraInput_upv_1.gamepadZoomPress:Connect(
            function()
                --[[
                  line: 607
                  upvalues:
                    a1 (copy, index: 1)
                ]]
                a1:GamepadZoomPress()
            end
        )
        if LocalPlayer_upv_1.CameraMode == Enum.CameraMode.LockFirstPerson then
            a1.currentSubjectDistance = 0.5
            if not (a1.inFirstPerson) then
                a1:EnterFirstPerson()
            end
        end
        if a1.cameraChangedConn then
            a1.cameraChangedConn:Disconnect()
            a1.cameraChangedConn = nil
        end
        a1.cameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(
            function()
                --[[
                  line: 619
                  upvalues:
                    a1 (copy, index: 1)
                ]]
                a1:OnCurrentCameraChanged()
            end
        )
        a1:OnCurrentCameraChanged()
    else
        CameraInput_upv_1.setInputEnabled(false)
        if a1.gamepadZoomPressConnection then
            a1.gamepadZoomPressConnection:Disconnect()
            a1.gamepadZoomPressConnection = nil
        end
        a1:Cleanup()
    end
end
function tbl_upv_1.GetEnabled(a1)
    --[[
      name: GetEnabled
      line: 635
    ]]
    return a1.enabled
end
function tbl_upv_1.Cleanup(a1)
    --[[
      name: Cleanup
      line: 639
      upvalues:
        CameraUtils_upv_1 (copy, index: 1)
    ]]
    if a1.subjectStateChangedConn then
        a1.subjectStateChangedConn:Disconnect()
        a1.subjectStateChangedConn = nil
    end
    if a1.viewportSizeChangedConn then
        a1.viewportSizeChangedConn:Disconnect()
        a1.viewportSizeChangedConn = nil
    end
    if a1.cameraChangedConn then
        a1.cameraChangedConn:Disconnect()
        a1.cameraChangedConn = nil
    end
    a1.lastCameraTransform = nil
    a1.lastSubjectCFrame = nil
    CameraUtils_upv_1.restoreMouseBehavior()
end
function tbl_upv_1.UpdateMouseBehavior(a1)
    --[[
      name: UpdateMouseBehavior
      line: 660
      upvalues:
        UserGameSettings_upv_1 (copy, index: 1)
        CameraUI_upv_1 (copy, index: 2)
        CameraInput_upv_1 (copy, index: 3)
        CameraToggleStateController_upv_1 (copy, index: 4)
        CameraUtils_upv_1 (copy, index: 5)
    ]]
    local v28 = UserGameSettings_upv_1.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove
    if not a1.isCameraToggle or v28 ~= false then
        CameraUI_upv_1.setCameraModeToastEnabled(false)
        CameraInput_upv_1.disableCameraToggleInput()
        if not (a1.inFirstPerson) and not (a1.inMouseLockedMode) then
            CameraUtils_upv_1.restoreRotationType()
            if CameraInput_upv_1.getRotationActivated() then
                CameraUtils_upv_1.setMouseBehaviorOverride(Enum.MouseBehavior.LockCurrentPosition)
            else
                CameraUtils_upv_1.restoreMouseBehavior()
            end
            return
        end
        CameraUtils_upv_1.setRotationTypeOverride(Enum.RotationType.CameraRelative)
        CameraUtils_upv_1.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter)
    end
    CameraUI_upv_1.setCameraModeToastEnabled(true)
    CameraInput_upv_1.enableCameraToggleInput()
    CameraToggleStateController_upv_1(a1.inFirstPerson)
end
function tbl_upv_1.UpdateForDistancePropertyChange(a1)
    --[[
      name: UpdateForDistancePropertyChange
      line: 688
    ]]
    a1:SetCameraToSubjectDistance(a1.currentSubjectDistance)
end
function tbl_upv_1.SetCameraToSubjectDistance(a1, a2)
    --[[
      name: SetCameraToSubjectDistance
      line: 694
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        ZoomController_upv_1 (copy, index: 2)
    ]]
    local currentSubjectDistance_2 = a1.currentSubjectDistance
    local v29 = nil
    if LocalPlayer_upv_1.CameraMode ~= Enum.CameraMode.LockFirstPerson then
        v29 = math.clamp(a2, LocalPlayer_upv_1.CameraMinZoomDistance, LocalPlayer_upv_1.CameraMaxZoomDistance)
        if v29 < 1 then
            a1.currentSubjectDistance = 0.5
            if not (a1.inFirstPerson) then
                a1:EnterFirstPerson()
            end
        else
            a1.currentSubjectDistance = v29
            if a1.inFirstPerson then
                a1:LeaveFirstPerson()
            end
        end
    else
        a1.currentSubjectDistance = 0.5
        if not (a1.inFirstPerson) then
            a1:EnterFirstPerson()
        end
    end
    ZoomController_upv_1.SetZoomParameters(a1.currentSubjectDistance, (math.sign(a2 - currentSubjectDistance_2)))
    return a1.currentSubjectDistance
end
function tbl_upv_1.SetCameraType(a1, a2)
    --[[
      name: SetCameraType
      line: 728
    ]]
    a1.cameraType = a2
end
function tbl_upv_1.GetCameraType(a1)
    --[[
      name: GetCameraType
      line: 733
    ]]
    return a1.cameraType
end
function tbl_upv_1.SetCameraMovementMode(a1, a2)
    --[[
      name: SetCameraMovementMode
      line: 738
    ]]
    a1.cameraMovementMode = a2
end
function tbl_upv_1.GetCameraMovementMode(a1)
    --[[
      name: GetCameraMovementMode
      line: 742
    ]]
    return a1.cameraMovementMode
end
function tbl_upv_1.SetIsMouseLocked(a1, a2)
    --[[
      name: SetIsMouseLocked
      line: 746
    ]]
    a1.inMouseLockedMode = a2
end
function tbl_upv_1.GetIsMouseLocked(a1)
    --[[
      name: GetIsMouseLocked
      line: 750
    ]]
    return a1.inMouseLockedMode
end
function tbl_upv_1.SetMouseLockOffset(a1, a2)
    --[[
      name: SetMouseLockOffset
      line: 754
    ]]
    a1.mouseLockOffset = a2
end
function tbl_upv_1.GetMouseLockOffset(a1)
    --[[
      name: GetMouseLockOffset
      line: 758
    ]]
    return a1.mouseLockOffset
end
function tbl_upv_1.InFirstPerson(a1)
    --[[
      name: InFirstPerson
      line: 762
    ]]
    return a1.inFirstPerson
end
function tbl_upv_1.EnterFirstPerson(a1)
    --[[
      name: EnterFirstPerson
      line: 766
    ]]
    a1.inFirstPerson = true
    a1:UpdateMouseBehavior()
end
function tbl_upv_1.LeaveFirstPerson(a1)
    --[[
      name: LeaveFirstPerson
      line: 771
    ]]
    a1.inFirstPerson = false
    a1:UpdateMouseBehavior()
end
function tbl_upv_1.GetCameraToSubjectDistance(a1)
    --[[
      name: GetCameraToSubjectDistance
      line: 777
    ]]
    return a1.currentSubjectDistance
end
function tbl_upv_1.GetMeasuredDistanceToFocus(a1)
    --[[
      name: GetMeasuredDistanceToFocus
      line: 784
    ]]
    local CurrentCamera_7 = game.Workspace.CurrentCamera
    if CurrentCamera_7 then
        return (CurrentCamera_7.CoordinateFrame.p - CurrentCamera_7.Focus.p).magnitude
    end
    return nil
end
function tbl_upv_1.GetCameraLookVector(a1)
    --[[
      name: GetCameraLookVector
      line: 792
    ]]
    return ((game.Workspace.CurrentCamera) and (game.Workspace.CurrentCamera.CFrame.LookVector)) or Vector3.new(0, 0, 1)
end
function tbl_upv_1.CalculateNewLookCFrameFromArg(a1, a2, a3)
    --[[
      name: CalculateNewLookCFrameFromArg
      line: 796
    ]]
    local v30 = a2 or (a1:GetCameraLookVector())
    local v31 = math.asin(v30.Y)
    local v32 = Vector2.new(a3.X, math.clamp(a3.Y, v31 + -1.3962634015954636, v31 + 1.3962634015954636))
    local v33 = CFrame.new(Vector3.new(0, 0, 0), v30)
    return CFrame.Angles(0, -v32.X, 0) * v33 * CFrame.Angles(-v32.Y, 0, 0)
end
function tbl_upv_1.CalculateNewLookVectorFromArg(a1, a2, a3)
    --[[
      name: CalculateNewLookVectorFromArg
      line: 806
    ]]
    return a1:CalculateNewLookCFrameFromArg(a2, a3).LookVector
end
function tbl_upv_1.CalculateNewLookVectorVRFromArg(a1, a2)
    --[[
      name: CalculateNewLookVectorVRFromArg
      line: 811
    ]]
    local v34 = a1:GetSubjectPosition()
    local v35 = Vector2.new(a2.X, 0)
    local v36 = CFrame.new(Vector3.new(0, 0, 0), ((v34 - game.Workspace.CurrentCamera.CFrame.p) * Vector3.new(1, 0, 1)).unit)
    return ((CFrame.Angles(0, -v35.X, 0) * v36 * CFrame.Angles(-v35.Y, 0, 0)).LookVector * Vector3.new(1, 0, 1)).unit
end
function tbl_upv_1.GetHumanoid(a1)
    --[[
      name: GetHumanoid
      line: 821
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
    ]]
    local v37
    if LocalPlayer_upv_1 then
        v37 = LocalPlayer_upv_1.Character
    else
        v37 = LocalPlayer_upv_1
    end
    if not v37 then
        return nil
    end
    local v38 = a1.humanoidCache[LocalPlayer_upv_1]
    if v38 and v38.Parent == v37 then
        return v38
    end
    a1.humanoidCache[LocalPlayer_upv_1] = nil
    local v39 = v37:FindFirstChildOfClass("Humanoid")
    if v39 then
        a1.humanoidCache[LocalPlayer_upv_1] = v39
    end
    return v39
end
function tbl_upv_1.GetHumanoidPartToFollow(a1, a2, a3)
    --[[
      name: GetHumanoidPartToFollow
      line: 839
    ]]
    if a3 ~= Enum.HumanoidStateType.Dead then
        return a2.Torso
    end
    local Parent_2 = a2.Parent
    if not Parent_2 then
        return a2.Torso
    end
    local v40 = Parent_2:FindFirstChild("Head") or (a2.Torso)
    return v40
end
function tbl_upv_1.OnNewCameraSubject(a1)
    --[[
      name: OnNewCameraSubject
      line: 853
    ]]
    if not a1.subjectStateChangedConn then
        return
    end
    a1.subjectStateChangedConn:Disconnect()
    a1.subjectStateChangedConn = nil
end
function tbl_upv_1.IsInFirstPerson(a1)
    --[[
      name: IsInFirstPerson
      line: 860
    ]]
    return a1.inFirstPerson
end
function tbl_upv_1.Update(a1, a2)
    --[[
      name: Update
      line: 864
    ]]
    error("BaseCamera:Update() This is a virtual function that should never be getting called.", 2)
end
function tbl_upv_1.GetCameraHeight(a1)
    --[[
      name: GetCameraHeight
      line: 868
      upvalues:
        VRService_upv_1 (copy, index: 1)
    ]]
    if VRService_upv_1.VREnabled and not (a1.inFirstPerson) then
        return 0.25881904510252074 * a1.currentSubjectDistance
    end
    return 0
end
return tbl_upv_1