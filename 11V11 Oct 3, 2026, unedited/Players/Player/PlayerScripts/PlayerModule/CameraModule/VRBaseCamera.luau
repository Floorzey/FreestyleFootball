--[[
    Script Path: Game/Players/Player/PlayerScripts/PlayerModule/CameraModule/VRBaseCamera
    Class: ModuleScript
    Time: 2026-10-03 12:27:02
--]]

local success_1, v1 = pcall(
    function()
        --[[
          line: 17
        ]]
        return UserSettings():IsUserFeatureEnabled("UserVRVehicleCamera2")
    end
)
local u1 = success_1 and v1
local VRService_upv_1 = game:GetService("VRService")
local LocalPlayer_upv_1 = game:GetService("Players").LocalPlayer
local Lighting_upv_1 = game:GetService("Lighting")
local RunService_upv_1 = game:GetService("RunService")
local UserGameSettings_upv_1 = UserSettings():GetService("UserGameSettings")
local CameraInput_upv_1 = require(script.Parent:WaitForChild("CameraInput"))
local ZoomController_upv_1 = require(script.Parent:WaitForChild("ZoomController"))
local u2 = require(script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")).getUserFlag("UserCameraInputDt")
local BaseCamera_upv_1 = require(script.Parent:WaitForChild("BaseCamera"))
local u3 = setmetatable({}, BaseCamera_upv_1)
u3.__index = u3
function u3.new()
    --[[
      name: new
      line: 41
      upvalues:
        BaseCamera_upv_1 (copy, index: 1)
        u3 (copy, index: 2)
    ]]
    local v2 = setmetatable(BaseCamera_upv_1.new(), u3)
    v2.gamepadZoomLevels = {0, 7}
    v2.headScale = 1
    v2:SetCameraToSubjectDistance(7)
    v2.VRFadeResetTimer = 0
    v2.VREdgeBlurTimer = 0
    v2.gamepadResetConnection = nil
    v2.needsReset = true
    v2.recentered = false
    v2:Reset()
    return v2
end
function u3.Reset(a1)
    --[[
      name: Reset
      line: 67
    ]]
    a1.stepRotateTimeout = 0
end
function u3.GetModuleName(a1)
    --[[
      name: GetModuleName
      line: 71
    ]]
    return "VRBaseCamera"
end
function u3.GamepadZoomPress(a1)
    --[[
      name: GamepadZoomPress
      line: 75
      upvalues:
        BaseCamera_upv_1 (copy, index: 1)
    ]]
    BaseCamera_upv_1.GamepadZoomPress(a1)
    a1:GamepadReset()
    a1:ResetZoom()
end
function u3.GamepadReset(a1)
    --[[
      name: GamepadReset
      line: 83
    ]]
    a1.stepRotateTimeout = 0
    a1.needsReset = true
end
function u3.ResetZoom(a1)
    --[[
      name: ResetZoom
      line: 88
      upvalues:
        ZoomController_upv_1 (copy, index: 1)
    ]]
    ZoomController_upv_1.SetZoomParameters(a1.currentSubjectDistance, 0)
    ZoomController_upv_1.ReleaseSpring()
end
function u3.OnEnabledChanged(a1)
    --[[
      name: OnEnabledChanged
      line: 93
      upvalues:
        BaseCamera_upv_1 (copy, index: 1)
        CameraInput_upv_1 (copy, index: 2)
        VRService_upv_1 (copy, index: 3)
        u1 (ref,  index: 4)
        LocalPlayer_upv_1 (copy, index: 5)
        Lighting_upv_1 (copy, index: 6)
    ]]
    BaseCamera_upv_1.OnEnabledChanged(a1)
    if a1.enabled then
        a1.gamepadResetConnection = CameraInput_upv_1.gamepadReset:Connect(
            function()
                --[[
                  line: 97
                  upvalues:
                    a1 (copy, index: 1)
                ]]
                a1:GamepadReset()
            end
        )
        a1.thirdPersonOptionChanged = VRService_upv_1:GetPropertyChangedSignal("ThirdPersonFollowCamEnabled"):Connect(
            function()
                --[[
                  line: 102
                  upvalues:
                    u1 (ref,  index: 1)
                    a1 (copy, index: 2)
                ]]
                if u1 or not (a1:IsInFirstPerson()) then
                    a1:Reset()
                end
            end
        )
        a1.vrRecentered = VRService_upv_1.UserCFrameChanged:Connect(
            function(a2, a3)
                --[[
                  line: 113
                  upvalues:
                    a1 (copy, index: 1)
                ]]
                if a2 ~= Enum.UserCFrame.Floor then
                    return
                end
                a1.recentered = true
            end
        )
    else
        if a1.inFirstPerson then
            a1:GamepadZoomPress()
        end
        if a1.thirdPersonOptionChanged then
            a1.thirdPersonOptionChanged:Disconnect()
            a1.thirdPersonOptionChanged = nil
        end
        if a1.vrRecentered then
            a1.vrRecentered:Disconnect()
            a1.vrRecentered = nil
        end
        if a1.cameraHeadScaleChangedConn then
            a1.cameraHeadScaleChangedConn:Disconnect()
            a1.cameraHeadScaleChangedConn = nil
        end
        if a1.gamepadResetConnection then
            a1.gamepadResetConnection:Disconnect()
            a1.gamepadResetConnection = nil
        end
        a1.VREdgeBlurTimer = 0
        a1:UpdateEdgeBlur(LocalPlayer_upv_1, 1)
        local VRFade_1 = Lighting_upv_1:FindFirstChild("VRFade")
        if VRFade_1 then
            VRFade_1.Brightness = 0
        end
    end
end
function u3.OnCurrentCameraChanged(a1)
    --[[
      name: OnCurrentCameraChanged
      line: 155
      upvalues:
        BaseCamera_upv_1 (copy, index: 1)
    ]]
    BaseCamera_upv_1.OnCurrentCameraChanged(a1)
    if a1.cameraHeadScaleChangedConn then
        a1.cameraHeadScaleChangedConn:Disconnect()
        a1.cameraHeadScaleChangedConn = nil
    end
    local CurrentCamera_1 = workspace.CurrentCamera
    if not CurrentCamera_1 then
        return
    end
    a1.cameraHeadScaleChangedConn = CurrentCamera_1:GetPropertyChangedSignal("HeadScale"):Connect(
        function()
            --[[
              line: 167
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1:OnHeadScaleChanged()
        end
    )
    a1:OnHeadScaleChanged()
end
function u3.OnHeadScaleChanged(a1)
    --[[
      name: OnHeadScaleChanged
      line: 172
    ]]
    local HeadScale_1 = workspace.CurrentCamera.HeadScale
    for key_1, value_1 in a1.gamepadZoomLevels do
        a1.gamepadZoomLevels[key_1] = (value_1 * HeadScale_1) / a1.headScale
    end
    a1:SetCameraToSubjectDistance(a1:GetCameraToSubjectDistance() * HeadScale_1 / a1.headScale)
    a1.headScale = HeadScale_1
end
function u3.GetVRFocus(a1, a2, a3)
    --[[
      name: GetVRFocus
      line: 188
    ]]
    a1.cameraTranslationConstraints = Vector3.new(a1.cameraTranslationConstraints.x, math.min(1, a1.cameraTranslationConstraints.y + a3), a1.cameraTranslationConstraints.z)
    local v3 = Vector3.new(0, a1:GetCameraHeight(), 0)
    return (CFrame.new(Vector3.new(a2.x, (a1.lastCameraFocus or a2).y, a2.z):Lerp(a2 + v3, a1.cameraTranslationConstraints.y)))
end
function u3.StartFadeFromBlack(a1)
    --[[
      name: StartFadeFromBlack
      line: 204
      upvalues:
        UserGameSettings_upv_1 (copy, index: 1)
        Lighting_upv_1 (copy, index: 2)
    ]]
    if UserGameSettings_upv_1.VignetteEnabled == false then
        return
    end
    local v4 = Lighting_upv_1:FindFirstChild("VRFade")
    if not (v4) then
        local v5 = Instance.new("ColorCorrectionEffect")
        v5.Name = "VRFade"
        v5.Parent = Lighting_upv_1
        v4 = v5
    end
    v4.Brightness = -1
    a1.VRFadeResetTimer = 0.1
end
function u3.UpdateFadeFromBlack(a1, a2)
    --[[
      name: UpdateFadeFromBlack
      line: 219
      upvalues:
        Lighting_upv_1 (copy, index: 1)
    ]]
    local VRFade_2 = Lighting_upv_1:FindFirstChild("VRFade")
    local v6 = nil
    if a1.VRFadeResetTimer > 0 then
        a1.VRFadeResetTimer = math.max(a1.VRFadeResetTimer - a2, 0)
        v6 = Lighting_upv_1:FindFirstChild("VRFade")
        if not v6 or not (v6.Brightness < 0) then
            return
        end
        v6.Brightness = math.min(v6.Brightness + (a2 * 10), 0)
    elseif VRFade_2 then
        VRFade_2.Brightness = 0
    end
end
function u3.StartVREdgeBlur(a1, a2)
    --[[
      name: StartVREdgeBlur
      line: 235
      upvalues:
        UserGameSettings_upv_1 (copy, index: 1)
        RunService_upv_1 (copy, index: 2)
        VRService_upv_1 (copy, index: 3)
    ]]
    if UserGameSettings_upv_1.VignetteEnabled == false then
        return
    end
    local VRBlurPart_1 = workspace.CurrentCamera:FindFirstChild("VRBlurPart")
    if not (VRBlurPart_1) then
        local u4 = Instance.new("Part")
        u4.Name = "VRBlurPart"
        u4.Parent = workspace.CurrentCamera
        u4.CanTouch = false
        u4.CanCollide = false
        u4.CanQuery = false
        u4.Anchored = true
        u4.Size = Vector3.new(0.4399999976158142, 0.4699999988079071, 1)
        u4.Transparency = 1
        u4.CastShadow = false
        RunService_upv_1.RenderStepped:Connect(
            function(a3)
                --[[
                  line: 255
                  upvalues:
                    VRService_upv_1 (copy, index: 1)
                    u4 (ref,  index: 2)
                ]]
                local v7 = VRService_upv_1:GetUserCFrame(Enum.UserCFrame.Head)
                local v8 = workspace.CurrentCamera.CFrame * (CFrame.new(v7.p * workspace.CurrentCamera.HeadScale) * (v7 - v7.p))
                u4.CFrame = v8 * CFrame.Angles(0, math.pi, 0) + (v8.LookVector * (1.05 * workspace.CurrentCamera.HeadScale))
                u4.Size = Vector3.new(0.4399999976158142, 0.4699999988079071, 1) * workspace.CurrentCamera.HeadScale
            end
        )
    end
    local v9 = a2.PlayerGui:FindFirstChild("VRBlurScreen")
    local v10 = nil
    v10 = (not v9) or (v9:FindFirstChild("VRBlur"))
    if not (v10) then
        if not (v9) then
            v9 = Instance.new("SurfaceGui") or Instance.new("ScreenGui")
        end
        v9.Name = "VRBlurScreen"
        v9.Parent = a2.PlayerGui
        v9.Adornee = VRBlurPart_1
        v10 = Instance.new("ImageLabel")
        v10.Name = "VRBlur"
        v10.Parent = v9
        v10.Image = "rbxasset://textures/ui/VR/edgeBlur.png"
        v10.AnchorPoint = Vector2.new(0.5, 0.5)
        v10.Position = UDim2.new(0.5, 0, 0.5, 0)
        v10.Size = UDim2.fromScale((workspace.CurrentCamera.ViewportSize.X * 2.3) / 512, (workspace.CurrentCamera.ViewportSize.Y * 2.3) / 512)
        v10.BackgroundTransparency = 1
        v10.Active = true
        v10.ScaleType = Enum.ScaleType.Stretch
    end
    v10.Visible = true
    v10.ImageTransparency = 0
    a1.VREdgeBlurTimer = 0.14
end
function u3.UpdateEdgeBlur(a1, a2, a3)
    --[[
      name: UpdateEdgeBlur
      line: 304
    ]]
    local VRBlurScreen_1 = a2.PlayerGui:FindFirstChild("VRBlurScreen")
    local v12 = (not VRBlurScreen_1) or (VRBlurScreen_1:FindFirstChild("VRBlur"))
    if v12 then
        local v13 = nil
        if a1.VREdgeBlurTimer > 0 then
            a1.VREdgeBlurTimer = a1.VREdgeBlurTimer - a3
            v13 = a2.PlayerGui:FindFirstChild("VRBlurScreen")
            if v13 then
                local VRBlur_1 = v13:FindFirstChild("VRBlur")
                if not VRBlur_1 then
                    return
                end
                VRBlur_1.ImageTransparency = 1 - (math.clamp(a1.VREdgeBlurTimer, 0.01, 0.14) * 7.142857142857142)
            end
        else
            v12.Visible = false
        end
    end
end
function u3.GetCameraHeight(a1)
    --[[
      name: GetCameraHeight
      line: 329
    ]]
    if a1.inFirstPerson then
        return 0
    end
    return 0.25881904510252074 * a1.currentSubjectDistance
end
function u3.GetSubjectCFrame(a1)
    --[[
      name: GetSubjectCFrame
      line: 336
      upvalues:
        BaseCamera_upv_1 (copy, index: 1)
    ]]
    local v14 = BaseCamera_upv_1.GetSubjectCFrame(a1)
    local CurrentCamera_2 = workspace.CurrentCamera
    local v15 = CurrentCamera_2 and (CurrentCamera_2.CameraSubject)
    if not v15 then
        return v14
    end
    local v16 = v15:IsA("Humanoid")
    if v16 then
        local v17 = v15:GetState() == Enum.HumanoidStateType.Dead
        if v17 and CurrentCamera_2 == a1.lastSubject then
            v14 = a1.lastSubjectCFrame
        end
    end
    if v14 then
        a1.lastSubjectCFrame = v14
    end
    return v14
end
function u3.GetSubjectPosition(a1)
    --[[
      name: GetSubjectPosition
      line: 362
      upvalues:
        BaseCamera_upv_1 (copy, index: 1)
    ]]
    local v18 = BaseCamera_upv_1.GetSubjectPosition(a1)
    local CurrentCamera_3 = game.Workspace.CurrentCamera
    local v19 = CurrentCamera_3 and (CurrentCamera_3.CameraSubject)
    if v19 then
        if v19:IsA("Humanoid") then
            local v20 = v19:GetState() == Enum.HumanoidStateType.Dead
            if v20 and CurrentCamera_3 == a1.lastSubject then
                v18 = a1.lastSubjectPosition
            end
        else
            v18 = (v19:IsA("VehicleSeat") and (v19.CFrame.p + v19.CFrame:vectorToWorldSpace(Vector3.new(0, 4, 0)))) or v18
        end
        a1.lastSubjectPosition = v18
        return v18
    end
    return nil
end
function u3.getRotation(a1, a2)
    --[[
      name: getRotation
      line: 391
      upvalues:
        CameraInput_upv_1 (copy, index: 1)
        UserGameSettings_upv_1 (copy, index: 2)
        u2 (copy, index: 3)
    ]]
    local v21 = CameraInput_upv_1.getRotation(a2)
    if UserGameSettings_upv_1.VRSmoothRotationEnabled then
        if u2 then
            return v21.X
        end
        return (v21.X * 40) * a2
    end
    if math.abs(v21.X) > 0.03 then
        if a1.stepRotateTimeout > 0 then
            a1.stepRotateTimeout = a1.stepRotateTimeout - a2
        end
        if a1.stepRotateTimeout <= 0 then
            local v22 = ((v21.X < 0) and -1) or 1
            a1:StartFadeFromBlack()
            a1.stepRotateTimeout = 0.25
            return v22 * 0.5235987755982988
        end
    elseif math.abs(v21.X) < 0.02 then
        a1.stepRotateTimeout = 0
    end
    return 0
end
return u3