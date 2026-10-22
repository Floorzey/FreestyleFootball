--[[
    Script Path: Game/StarterPlayer/StarterPlayerScripts/PlayerModule/CameraModule/ClassicCamera
    Class: ModuleScript
    Time: 2026-10-03 12:27:04
--]]

local _ = Vector2.new(0, 0)
local u1 = 0
local u2 = CFrame.fromOrientation(-0.2617993877991494, 0, 0)
local FlagUtil_1 = require(script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil"))
local u3 = FlagUtil_1.getUserFlag("UserFixCameraOffsetJitter2")
local v1 = FlagUtil_1.getUserFlag("UserCameraInputDt")
local Players_upv_1 = game:GetService("Players")
local CameraInput_upv_1 = require(script.Parent:WaitForChild("CameraInput"))
local CameraUtils_upv_1 = require(script.Parent:WaitForChild("CameraUtils"))
local BaseCamera_upv_1 = require(script.Parent:WaitForChild("BaseCamera"))
local u4 = setmetatable({}, BaseCamera_upv_1)
u4.__index = u4
function u4.new()
    --[[
      name: new
      line: 41
      upvalues:
        BaseCamera_upv_1 (copy, index: 1)
        u4 (copy, index: 2)
        CameraUtils_upv_1 (copy, index: 3)
    ]]
    local v1 = setmetatable(BaseCamera_upv_1.new(), u4)
    v1.isFollowCamera = false
    v1.isCameraToggle = false
    v1.lastUpdate = tick()
    v1.cameraToggleSpring = CameraUtils_upv_1.Spring.new(5, 0)
    return v1
end
function u4.GetCameraToggleOffset(a1, a2)
    --[[
      name: GetCameraToggleOffset
      line: 52
      upvalues:
        CameraInput_upv_1 (copy, index: 1)
        CameraUtils_upv_1 (copy, index: 2)
    ]]
    if not a1.isCameraToggle then
        return (Vector3.new())
    end
    local currentSubjectDistance_1 = a1.currentSubjectDistance
    if CameraInput_upv_1.getTogglePan() then
        a1.cameraToggleSpring.goal = math.clamp(CameraUtils_upv_1.map(currentSubjectDistance_1, 0.5, a1.FIRST_PERSON_DISTANCE_THRESHOLD, 0, 1), 0, 1)
    else
        a1.cameraToggleSpring.goal = 0
    end
    local v2 = math.clamp(CameraUtils_upv_1.map(currentSubjectDistance_1, 0.5, 64, 0, 1), 0, 1) + 1
    return (Vector3.new(0, a1.cameraToggleSpring:step(a2) * v2, 0))
end
function u4.SetCameraMovementMode(a1, a2)
    --[[
      name: SetCameraMovementMode
      line: 70
      upvalues:
        BaseCamera_upv_1 (copy, index: 1)
    ]]
    BaseCamera_upv_1.SetCameraMovementMode(a1, a2)
    a1.isFollowCamera = a2 == Enum.ComputerCameraMovementMode.Follow
    a1.isCameraToggle = a2 == Enum.ComputerCameraMovementMode.CameraToggle
end
function u4.Update(a1, a2)
    --[[
      name: Update
      line: 77
      upvalues:
        u2 (copy, index: 2)
        Players_upv_1 (copy, index: 3)
        CameraInput_upv_1 (copy, index: 4)
        u1 (ref,  index: 5)
        u3 (copy, index: 6)
        CameraUtils_upv_1 (copy, index: 7)
    ]]
    local time_1 = tick()
    local v3 = time_1 - a1.lastUpdate
    local CurrentCamera_1 = workspace.CurrentCamera
    local v4 = CurrentCamera_1.CFrame
    local v5 = CurrentCamera_1.Focus
    local lookVector_1 = nil
    local v6 = nil
    if a1.resetCameraAngle then
        v6 = a1:GetHumanoidRootPart()
        if v6 then
            lookVector_1 = (v6.CFrame * u2).lookVector
        else
            lookVector_1 = u2.lookVector
        end
        a1.resetCameraAngle = false
    end
    local LocalPlayer_1 = Players_upv_1.LocalPlayer
    local v7 = a1:GetHumanoid()
    local CameraSubject_1 = CurrentCamera_1.CameraSubject
    local _ = CameraSubject_1 and (CameraSubject_1:IsA("VehicleSeat"))
    local v30 = CameraSubject_1 and (CameraSubject_1:IsA("SkateboardPlatform"))
    local v8 = v7 and (v7:GetState() == Enum.HumanoidStateType.Climbing)
    if a1.lastUpdate == nil or v3 > 1 then
        a1.lastCameraTransform = nil
    end
    local v9 = CameraInput_upv_1.getRotation(v3)
    a1:StepZoom()
    local v10 = a1:GetCameraHeight()
    if v9 ~= Vector2.new() then
        u1 = 0
        a1.lastUserPanCamera = tick()
    end
    local v11 = time_1 - a1.lastUserPanCamera < 2
    local v12 = a1:GetSubjectPosition()
    if v12 and LocalPlayer_1 and CurrentCamera_1 then
        local v13 = a1:GetCameraToSubjectDistance()
        local v14 = ((v13 < 0.5) and 0.5) or v13
        if not (a1:GetIsMouseLocked()) or a1:IsInFirstPerson() then
            local v15 = v9 ~= Vector2.new()
            if not v15 and a1.lastCameraTransform then
                local v16 = a1:IsInFirstPerson()
                if CameraSubject_1 then
                    if a1.lastUpdate and v7 and v7.Torso then
                        if v16 then
                            if a1.lastSubjectCFrame and CameraSubject_1 then
                                local v17 = CameraSubject_1:IsA("BasePart")
                                if v17 then
                                    local v18 = -CameraUtils_upv_1.GetAngleBetweenXZVectors(a1.lastSubjectCFrame.lookVector, CameraSubject_1.CFrame.lookVector)
                                    v9 = (CameraUtils_upv_1.IsFinite(v18) and (v9 + Vector2.new(v18, 0))) or v9
                                    u1 = 0
                                end
                            end
                        elseif not v11 then
                            local lookVector_2 = v7.Torso.CFrame.lookVector
                            u1 = math.clamp(u1 + (3.839724354387525 * v3), 0, 4.363323129985824)
                            local v19 = math.clamp(u1 * v3, 0, 1)
                            local v20 = a1:IsInFirstPerson()
                            if v20 and (not (a1.isFollowCamera) or not (a1.isClimbing)) then
                                v19 = 1
                            end
                            local v21 = CameraUtils_upv_1.GetAngleBetweenXZVectors(lookVector_2, a1:GetCameraLookVector())
                            local v22 = CameraUtils_upv_1.IsFinite(v21)
                            if v22 then
                                v9 = ((math.abs(v21) > 1e-04) and (v9 + Vector2.new(v21 * v19, 0))) or v9
                            end
                        end
                    elseif a1.isFollowCamera and not v16 and not v11 then
                        local v23 = CameraUtils_upv_1.GetAngleBetweenXZVectors(-(a1.lastCameraTransform.p - v12), a1:GetCameraLookVector())
                        local v24 = CameraUtils_upv_1.IsFinite(v23)
                        if v24 and math.abs(v23) > 1e-04 then
                            v9 = ((0.4 * v3 < math.abs(v23)) and (v9 + Vector2.new(v23, 0))) or v9
                        end
                    end
                else
                    if (CameraSubject_1 or a1.isFollowCamera and v8) and a1.lastUpdate and v7 and v7.Torso then
                        if v16 then
                            if a1.lastSubjectCFrame and CameraSubject_1 then
                                local v17 = CameraSubject_1:IsA("BasePart")
                                if v17 then
                                    local v18 = -CameraUtils_upv_1.GetAngleBetweenXZVectors(a1.lastSubjectCFrame.lookVector, CameraSubject_1.CFrame.lookVector)
                                    v9 = (CameraUtils_upv_1.IsFinite(v18) and (v9 + Vector2.new(v18, 0))) or v9
                                    u1 = 0
                                end
                            end
                        elseif not v11 then
                            local lookVector_2 = v7.Torso.CFrame.lookVector
                            u1 = math.clamp(u1 + (3.839724354387525 * v3), 0, 4.363323129985824)
                            local v19 = math.clamp(u1 * v3, 0, 1)
                            local v20 = a1:IsInFirstPerson()
                            if v20 and (not (a1.isFollowCamera) or not (a1.isClimbing)) then
                                v19 = 1
                            end
                            local v21 = CameraUtils_upv_1.GetAngleBetweenXZVectors(lookVector_2, a1:GetCameraLookVector())
                            local v22 = CameraUtils_upv_1.IsFinite(v21)
                            if v22 then
                                v9 = ((math.abs(v21) > 1e-04) and (v9 + Vector2.new(v21 * v19, 0))) or v9
                            end
                        end
                        if a1.isFollowCamera then
                            local v25 = a1:CalculateNewLookVectorFromArg(lookVector_1, v9)
                            v5 = CFrame.new(v12)
                            v4 = CFrame.new(v5.p - (v14 * v25), v5.p) + Vector3.new(0, v10, 0)
                        else
                            v5 = CFrame.new(v12)
                            local p_1 = v5.p
                            v4 = CFrame.new(p_1 - (v14 * a1:CalculateNewLookVectorFromArg(lookVector_1, v9)), p_1)
                        end
                        local v26 = a1:GetCameraToggleOffset(v3)
                        v5 = v5 + v26
                        v4 = v4 + v26
                        a1.lastCameraTransform = v4
                        a1.lastCameraFocus = v5
                        if not (CameraSubject_1) or not (CameraSubject_1:IsA("BasePart")) then
                            a1.lastSubjectCFrame = nil
                            a1.lastUpdate = time_1
                            return v4, v5
                        end
                        a1.lastSubjectCFrame = CameraSubject_1.CFrame
                        a1.lastUpdate = time_1
                        return v4, v5
                    end
                    if a1.isFollowCamera and not v16 and not v11 then
                        local v23 = CameraUtils_upv_1.GetAngleBetweenXZVectors(-(a1.lastCameraTransform.p - v12), a1:GetCameraLookVector())
                        local v24 = CameraUtils_upv_1.IsFinite(v23)
                        if v24 and math.abs(v23) > 1e-04 then
                            v9 = ((0.4 * v3 < math.abs(v23)) and (v9 + Vector2.new(v23, 0))) or v9
                        end
                    end
                end
            end
        else
            local v27 = a1:CalculateNewLookCFrameFromArg(lookVector_1, v9)
            local v28 = a1:GetMouseLockOffset()
            if u3 then
                v28 = (v7 and (v28 + v7.CameraOffset)) or v28
            end
            local v29 = (v28.X * v27.RightVector) + (v28.Y * v27.UpVector) + v28.Z * v27.LookVector
            v12 = (CameraUtils_upv_1.IsFiniteVector3(v29) and (v12 + v29)) or v12
        end
        if a1.isFollowCamera then
            local v25 = a1:CalculateNewLookVectorFromArg(lookVector_1, v9)
            v5 = CFrame.new(v12)
            v4 = CFrame.new(v5.p - (v14 * v25), v5.p) + Vector3.new(0, v10, 0)
        else
            v5 = CFrame.new(v12)
            local p_1 = v5.p
            v4 = CFrame.new(p_1 - (v14 * a1:CalculateNewLookVectorFromArg(lookVector_1, v9)), p_1)
        end
        local v26 = a1:GetCameraToggleOffset(v3)
        v5 = v5 + v26
        v4 = v4 + v26
        a1.lastCameraTransform = v4
        a1.lastCameraFocus = v5
        if not (CameraSubject_1) or not (CameraSubject_1:IsA("BasePart")) then
            a1.lastSubjectCFrame = nil
            a1.lastUpdate = time_1
            return v4, v5
        end
        a1.lastSubjectCFrame = CameraSubject_1.CFrame
    end
    a1.lastUpdate = time_1
    return v4, v5
end
return u4