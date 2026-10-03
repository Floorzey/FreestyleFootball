--[[
    Script Path: Game/StarterPlayer/StarterPlayerScripts/PlayerModule/CameraModule/VRCamera
    Class: ModuleScript
    Time: 2026-10-03 12:27:04
--]]

local Players_upv_1 = game:GetService("Players")
local VRService_upv_1 = game:GetService("VRService")
local _ = UserSettings():GetService("UserGameSettings")
local v1 = require(script.Parent:WaitForChild("CameraInput"))
local v2 = require(script.Parent:WaitForChild("CameraUtils"))
local VRBaseCamera_upv_1 = require(script.Parent:WaitForChild("VRBaseCamera"))
local u1 = setmetatable({}, VRBaseCamera_upv_1)
u1.__index = u1
function u1.new()
    --[[
      name: new
      line: 28
      upvalues:
        VRBaseCamera_upv_1 (copy, index: 1)
        u1 (copy, index: 2)
        Players_upv_1 (copy, index: 3)
    ]]
    local v1 = setmetatable(VRBaseCamera_upv_1.new(), u1)
    v1.lastUpdate = tick()
    v1.focusOffset = CFrame.new()
    v1:Reset()
    v1.controlModule = require(Players_upv_1.LocalPlayer:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"))
    v1.savedAutoRotate = true
    return v1
end
function u1.Reset(a1)
    --[[
      name: Reset
      line: 41
      upvalues:
        VRBaseCamera_upv_1 (copy, index: 1)
    ]]
    a1.needsReset = true
    a1.needsBlackout = true
    a1.motionDetTime = 0
    a1.blackOutTimer = 0
    a1.lastCameraResetPosition = nil
    VRBaseCamera_upv_1.Reset(a1)
end
function u1.Update(a1, a2)
    --[[
      name: Update
      line: 50
      upvalues:
        Players_upv_1 (copy, index: 1)
        VRService_upv_1 (copy, index: 2)
    ]]
    local CurrentCamera_1 = workspace.CurrentCamera
    local v2 = CurrentCamera_1.CFrame
    local v3 = CurrentCamera_1.Focus
    local LocalPlayer_1 = Players_upv_1.LocalPlayer
    local _ = a1:GetHumanoid()
    if a1.lastUpdate == nil or a2 > 1 then
        a1.lastCameraTransform = nil
    end
    a1:UpdateFadeFromBlack(a2)
    a1:UpdateEdgeBlur(LocalPlayer_1, a2)
    local lastSubjectPosition_1 = a1.lastSubjectPosition
    local v4 = a1:GetSubjectPosition()
    if a1.needsBlackout then
        a1:StartFadeFromBlack()
        a1.blackOutTimer = a1.blackOutTimer + math.clamp(a2, 1e-04, 0.1)
        if a1.blackOutTimer > 0.1 and game:IsLoaded() then
            a1.needsBlackout = false
            a1.needsReset = true
        end
    end
    if v4 and LocalPlayer_1 and CurrentCamera_1 then
        v3 = a1:GetVRFocus(v4, a2)
        if a1:IsInFirstPerson() then
            if VRService_upv_1.AvatarGestures then
                local v5, v6 = a1:UpdateImmersionCamera(a2, v2, v3, lastSubjectPosition_1, v4)
                v2, v3 = v5, v6
            else
                local v7, v8 = a1:UpdateFirstPersonTransform(a2, v2, v3, lastSubjectPosition_1, v4)
                v2, v3 = v7, v8
            end
        elseif VRService_upv_1.ThirdPersonFollowCamEnabled then
            local v9, v10 = a1:UpdateThirdPersonFollowTransform(a2, v2, v3, lastSubjectPosition_1, v4)
            v2, v3 = v9, v10
        else
            local v11, v12 = a1:UpdateThirdPersonComfortTransform(a2, v2, v3, lastSubjectPosition_1, v4)
            v2, v3 = v11, v12
        end
        a1.lastCameraTransform = v2
        a1.lastCameraFocus = v3
    end
    a1.lastUpdate = tick()
    return v2, v3
end
function u1.GetAvatarFeetWorldYValue(a1)
    --[[
      name: GetAvatarFeetWorldYValue
      line: 112
    ]]
    local CameraSubject_1 = workspace.CurrentCamera.CameraSubject
    if not CameraSubject_1 or not CameraSubject_1:IsA("Humanoid") or not CameraSubject_1.RootPart then
        return nil
    end
    local RootPart_1 = CameraSubject_1.RootPart
    return (RootPart_1.Position.Y - (RootPart_1.Size.Y / 2)) - CameraSubject_1.HipHeight
end
function u1.UpdateFirstPersonTransform(a1, a2, a3, a4, a5, a6)
    --[[
      name: UpdateFirstPersonTransform
      line: 127
      upvalues:
        Players_upv_1 (copy, index: 1)
    ]]
    if a1.needsReset then
        a1:StartFadeFromBlack()
        a1.needsReset = false
    end
    local LocalPlayer_2 = Players_upv_1.LocalPlayer
    if (a5 - a6).magnitude > 0.01 then
        a1:StartVREdgeBlur(LocalPlayer_2)
    end
    local p_1 = a4.p
    local v13 = a1:GetCameraLookVector()
    return CFrame.new(p_1 - (0.5 * a1:CalculateNewLookVectorFromArg(Vector3.new(v13.X, 0, v13.Z).Unit, Vector2.new(a1:getRotation(a2), 0))), p_1), a4
end
function u1.UpdateImmersionCamera(a1, a2, a3, a4, a5, a6)
    --[[
      name: UpdateImmersionCamera
      line: 153
      upvalues:
        Players_upv_1 (copy, index: 1)
        VRService_upv_1 (copy, index: 2)
    ]]
    local v14 = a1:GetSubjectCFrame()
    local CurrentCamera_2 = workspace.CurrentCamera
    local Character_1 = Players_upv_1.LocalPlayer.Character
    local v15 = a1:GetHumanoid()
    if not v15 then
        return CurrentCamera_2.CFrame, CurrentCamera_2.Focus
    end
    local HumanoidRootPart_1 = Character_1:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart_1 then
        a1.characterOrientation = HumanoidRootPart_1:FindFirstChild("CharacterAlignOrientation")
        local v16 = nil
        if not (a1.characterOrientation) then
            v16 = HumanoidRootPart_1:FindFirstChild("RootAttachment")
            if not v16 then
                return
            end
            a1.characterOrientation = Instance.new("AlignOrientation")
            a1.characterOrientation.Name = "CharacterAlignOrientation"
            a1.characterOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
            a1.characterOrientation.Attachment0 = v16
            a1.characterOrientation.RigidityEnabled = true
            a1.characterOrientation.Parent = HumanoidRootPart_1
        end
        if a1.characterOrientation.Enabled == false then
            a1.characterOrientation.Enabled = true
        end
        if a1.needsReset then
            a1.needsReset = false
            a1.savedAutoRotate = v15.AutoRotate
            v15.AutoRotate = false
            if a1.NoRecenter then
                a1.NoRecenter = false
                VRService_upv_1:RecenterUserHeadCFrame()
            end
            a1:StartFadeFromBlack()
            a3 = v14
        else
            local v17 = nil
            if v15.Sit then
                if (v14.Position - CurrentCamera_2.CFrame.Position).Magnitude > 0.01 then
                    a1:StartVREdgeBlur(Players_upv_1.LocalPlayer)
                end
                a3 = v14
            else
                a1.characterOrientation.CFrame = CurrentCamera_2.CFrame * a1.controlModule:GetEstimatedVRTorsoFrame()
                if a1.controlModule.inputMoveVector.Magnitude > 0 then
                    a1.motionDetTime = 0.1
                end
                if a1.controlModule.inputMoveVector.Magnitude > 0 or a1.motionDetTime > 0 then
                    a1.motionDetTime = a1.motionDetTime - a2
                    a1:StartVREdgeBlur(Players_upv_1.LocalPlayer)
                    local v18 = VRService_upv_1:GetUserCFrame(Enum.UserCFrame.Head)
                    local HumanoidRootPart_2 = Character_1.HumanoidRootPart
                    local v19 = CurrentCamera_2.CFrame * (v18.Rotation + (v18.Position * CurrentCamera_2.HeadScale)) * CFrame.new(0, (-0.7 * HumanoidRootPart_2.Size.Y) / 2, 0)
                    local LookVector_1 = HumanoidRootPart_2.CFrame.LookVector
                    local v20 = a6 - (v19 - ((Vector3.new(LookVector_1.X, 0, LookVector_1.Z).Unit * HumanoidRootPart_2.Size.Y) * 0.125)).Position + CurrentCamera_2.CFrame.Position
                    a3 = CurrentCamera_2.CFrame.Rotation + Vector3.new(v20.X, a6.Y, v20.Z)
                else
                    a3 = CurrentCamera_2.CFrame.Rotation + Vector3.new(CurrentCamera_2.CFrame.Position.X, a6.Y, CurrentCamera_2.CFrame.Position.Z)
                end
                v17 = a1:getRotation(a2)
                if math.abs(v17) > 0 then
                    local v21 = VRService_upv_1:GetUserCFrame(Enum.UserCFrame.Head)
                    local v22 = v21.Rotation + v21.Position * CurrentCamera_2.HeadScale
                    local v23 = a3 * v22
                    a3 = CFrame.new(v23.Position) * CFrame.Angles(0, -math.rad(v17 * 90), 0) * v23.Rotation * v22:Inverse()
                end
            end
        end
        return a3, a3 * CFrame.new(0, 0, -0.5)
    end
    return CurrentCamera_2.CFrame, CurrentCamera_2.Focus
end
function u1.UpdateThirdPersonComfortTransform(a1, a2, a3, a4, a5, a6)
    --[[
      name: UpdateThirdPersonComfortTransform
      line: 265
      upvalues:
        VRService_upv_1 (copy, index: 2)
    ]]
    local v24 = a1:GetCameraToSubjectDistance()
    local v25 = ((v24 < 0.5) and 0.5) or v24
    if a5 ~= nil then
        local v26 = nil
        if a1.lastCameraFocus ~= nil then
            local v27 = a1.controlModule:GetMoveVector()
            local v28 = true
            if not ((a5 - a6).magnitude > 0.01) then
                v28 = v27.magnitude > 0.01
            end
            if v28 then
                a1.motionDetTime = 0.1
            end
            a1.motionDetTime = a1.motionDetTime - a2
            if (((a1.motionDetTime > 0) and true) or v28) and not (a1.needsReset) then
                a4 = a1.lastCameraFocus
                a1.VRCameraFocusFrozen = true
                return a3, a4
            end
            local v29 = true
            if a1.lastCameraResetPosition ~= nil then
                v29 = (a6 - a1.lastCameraResetPosition).Magnitude > 1
            end
            v26 = a1:getRotation(a2)
            if math.abs(v26) > 0 then
                local v30 = a4:ToObjectSpace(a3)
                a3 = a4 * CFrame.Angles(0, -v26, 0) * v30
            end
            if a1.VRCameraFocusFrozen and v29 or a1.needsReset then
                VRService_upv_1:RecenterUserHeadCFrame()
                a1.VRCameraFocusFrozen = false
                a1.needsReset = false
                a1.lastCameraResetPosition = a6
                a1:ResetZoom()
                a1:StartFadeFromBlack()
                local v31 = a1:GetHumanoid()
                local v32 = ((v31.Torso) and (v31.Torso.CFrame.lookVector)) or Vector3.new(1, 0, 0)
                local v33 = a4.Position - Vector3.new(v32.X, 0, v32.Z) * v25
                a3 = CFrame.new(v33, Vector3.new(a4.Position.X, v33.Y, a4.Position.Z))
            end
        end
    end
    return a3, a4
end
function u1.UpdateThirdPersonFollowTransform(a1, a2, a3, a4, a5, a6)
    --[[
      name: UpdateThirdPersonFollowTransform
      line: 332
      upvalues:
        VRService_upv_1 (copy, index: 1)
        Players_upv_1 (copy, index: 2)
    ]]
    local CurrentCamera_3 = workspace.CurrentCamera
    local v34 = a1:GetCameraToSubjectDistance()
    local v35 = a1:GetVRFocus(a6, a2)
    if a1.needsReset then
        a1.needsReset = false
        VRService_upv_1:RecenterUserHeadCFrame()
        a1:ResetZoom()
        a1:StartFadeFromBlack()
    end
    local v36, v37, v38 = nil, nil, nil
    if a1.recentered then
        v36 = a1:GetSubjectCFrame()
        if not v36 then
            return CurrentCamera_3.CFrame, CurrentCamera_3.Focus
        end
        local v39 = v35 * v36.Rotation * CFrame.new(0, 0, v34)
        a1.focusOffset = v35:ToObjectSpace(v39)
        a1.recentered = false
        return v39, v35
    else
        local v40 = v35:ToWorldSpace(a1.focusOffset)
        local controlModule_1 = a1.controlModule
        local v41 = controlModule_1:GetMoveVector()
        if (a5 - a6).magnitude > 0.01 or v41.magnitude > 0 then
            v37 = controlModule_1:GetEstimatedVRTorsoFrame()
            local v42 = CurrentCamera_3.CFrame * (v37.Rotation + (v37.Position * CurrentCamera_3.HeadScale))
            local LookVector_2 = v42.LookVector
            a3 = v40:Lerp(CFrame.new((CurrentCamera_3.CFrame.Position + (v35.Position - Vector3.new(LookVector_2.X, 0, LookVector_2.Z).Unit * v34)) - v42.Position) * v40.Rotation, 0.01)
        else
            a3 = v40
        end
        v37 = a1:getRotation(a2)
        if math.abs(v37) > 0 then
            local v43 = v35:ToObjectSpace(a3)
            a3 = v35 * CFrame.Angles(0, -v37, 0) * v43
        end
        a1.focusOffset = v35:ToObjectSpace(a3)
        v38 = a3 * CFrame.new(0, 0, -v34)
        if (v38.Position - CurrentCamera_3.Focus.Position).Magnitude > 0.01 then
            a1:StartVREdgeBlur(Players_upv_1.LocalPlayer)
        end
        return a3, v38
    end
end
function u1.LeaveFirstPerson(a1)
    --[[
      name: LeaveFirstPerson
      line: 410
      upvalues:
        VRBaseCamera_upv_1 (copy, index: 1)
    ]]
    VRBaseCamera_upv_1.LeaveFirstPerson(a1)
    a1.needsReset = true
    if a1.VRBlur then
        a1.VRBlur.Visible = false
    end
    if a1.characterOrientation then
        a1.characterOrientation.Enabled = false
    end
    local v44 = a1:GetHumanoid()
    if not v44 then
        return
    end
    v44.AutoRotate = a1.savedAutoRotate
end
return u1