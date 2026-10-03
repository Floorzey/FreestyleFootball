--[[
    Script Path: Game/Players/Player/PlayerScripts/PlayerModule/CameraModule/VRVehicleCamera
    Class: ModuleScript
    Time: 2026-10-03 12:27:02
--]]

local success_1, v1 = pcall(
    function()
        --[[
          line: 9
        ]]
        return UserSettings():IsUserFeatureEnabled("UserVRVehicleCamera2")
    end
)
local u1 = success_1 and v1
local tbl_upv_1 = {0, 30}
local UserGameSettings_upv_1 = UserSettings():GetService("UserGameSettings")
local VRBaseCamera_upv_1 = require(script.Parent:WaitForChild("VRBaseCamera"))
local CameraInput_upv_1 = require(script.Parent:WaitForChild("CameraInput"))
local CameraUtils_upv_1 = require(script.Parent:WaitForChild("CameraUtils"))
local _ = require(script.Parent:WaitForChild("VehicleCamera"))
local VehicleCameraCore_upv_1 = require(script.Parent.VehicleCamera:FindFirstChild("VehicleCameraCore"))
local VehicleCameraConfig_upv_1 = require(script.Parent.VehicleCamera:FindFirstChild("VehicleCameraConfig"))
local Players_1 = game:GetService("Players")
local RunService_upv_1 = game:GetService("RunService")
local VRService_upv_1 = game:GetService("VRService")
local LocalPlayer_upv_1 = Players_1.LocalPlayer
local Spring_upv_1 = CameraUtils_upv_1.Spring
local mapClamp_upv_1 = CameraUtils_upv_1.mapClamp
local sanitizeAngle_upv_1 = CameraUtils_upv_1.sanitizeAngle
local function pitchVelocity(a1, a2)
    --[[
      name: pitchVelocity
      line: 46
    ]]
    return (math.abs(a2.XVector:Dot(a1)))
end
local function yawVelocity(a1, a2)
    --[[
      name: yawVelocity
      line: 51
    ]]
    return (math.abs(a2.YVector:Dot(a1)))
end
local u2 = 0.016666666666666666
local u3 = setmetatable({}, VRBaseCamera_upv_1)
u3.__index = u3
function u3.new()
    --[[
      name: new
      line: 59
      upvalues:
        VRBaseCamera_upv_1 (copy, index: 1)
        u3 (copy, index: 2)
        RunService_upv_1 (copy, index: 3)
        u2 (ref,  index: 4)
    ]]
    local v2 = setmetatable(VRBaseCamera_upv_1.new(), u3)
    v2:Reset()
    RunService_upv_1.Stepped:Connect(
        function(a1, a2)
            --[[
              line: 64
              upvalues:
                u2 (ref, index: 1)
            ]]
            u2 = a2
        end
    )
    return v2
end
function u3.Reset(a1)
    --[[
      name: Reset
      line: 72
      upvalues:
        VehicleCameraCore_upv_1 (copy, index: 1)
        u1 (ref,  index: 2)
        Spring_upv_1 (copy, index: 3)
        VehicleCameraConfig_upv_1 (copy, index: 4)
        CameraUtils_upv_1 (copy, index: 5)
        tbl_upv_1 (copy, index: 6)
    ]]
    a1.vehicleCameraCore = VehicleCameraCore_upv_1.new(a1:GetSubjectCFrame())
    if u1 then
        a1.pitchSpring = Spring_upv_1.new(0, 0)
    else
        a1.pitchSpring = Spring_upv_1.new(0, -math.rad(VehicleCameraConfig_upv_1.pitchBaseAngle))
    end
    a1.yawSpring = Spring_upv_1.new(0, 0)
    if u1 then
        a1.lastPanTick = 0
        a1.currentDriftAngle = 0
        a1.needsReset = true
    end
    local CurrentCamera_1 = workspace.CurrentCamera
    local v3 = CurrentCamera_1 and (CurrentCamera_1.CameraSubject)
    assert(CurrentCamera_1, "VRVehicleCamera initialization error")
    assert(v3)
    assert(v3:IsA("VehicleSeat"))
    local v4, v5 = CameraUtils_upv_1.getLooseBoundingSphere(v3:GetConnectedParts(true))
    a1.assemblyRadius = math.max(v5, 5)
    a1.assemblyOffset = v3.CFrame:Inverse() * v4
    a1.gamepadZoomLevels = {}
    for _, value_1 in tbl_upv_1 do
        table.insert(a1.gamepadZoomLevels, ((value_1 * a1.headScale) * a1.assemblyRadius) / 10)
    end
    a1.lastCameraFocus = nil
    a1:SetCameraToSubjectDistance(a1.gamepadZoomLevels[#a1.gamepadZoomLevels])
end
function u3._StepRotation(a1, a2, a3)
    --[[
      name: _StepRotation
      line: 112
      upvalues:
        sanitizeAngle_upv_1 (copy, index: 1)
        CameraInput_upv_1 (copy, index: 2)
        VehicleCameraConfig_upv_1 (copy, index: 3)
        mapClamp_upv_1 (copy, index: 4)
    ]]
    local yawSpring_1 = a1.yawSpring
    local pitchSpring_1 = a1.pitchSpring
    yawSpring_1.pos = sanitizeAngle_upv_1(yawSpring_1.pos + -a1:getRotation(a2))
    pitchSpring_1.pos = sanitizeAngle_upv_1(math.clamp(pitchSpring_1.pos, -1.3962634015954636, 1.3962634015954636))
    if CameraInput_upv_1.getRotationActivated() then
        a1.lastPanTick = os.clock()
    end
    local v6 = math.rad(VehicleCameraConfig_upv_1.pitchDeadzoneAngle)
    if VehicleCameraConfig_upv_1.autocorrectDelay < os.clock() - a1.lastPanTick then
        local v7 = mapClamp_upv_1(a3, VehicleCameraConfig_upv_1.autocorrectMinCarSpeed, VehicleCameraConfig_upv_1.autocorrectMaxCarSpeed, 0, VehicleCameraConfig_upv_1.autocorrectResponse)
        yawSpring_1.freq = v7
        pitchSpring_1.freq = v7
        if yawSpring_1.freq < 0.001 then
            yawSpring_1.vel = 0
        end
        if pitchSpring_1.freq < 0.001 then
            pitchSpring_1.vel = 0
        end
        if math.abs(sanitizeAngle_upv_1(0 - pitchSpring_1.pos)) <= v6 then
            pitchSpring_1.goal = pitchSpring_1.pos
        else
            pitchSpring_1.goal = 0
        end
    else
        yawSpring_1.freq = 0
        yawSpring_1.vel = 0
        pitchSpring_1.freq = 0
        pitchSpring_1.vel = 0
        pitchSpring_1.goal = 0
    end
    return CFrame.fromEulerAnglesYXZ(pitchSpring_1:step(a2), yawSpring_1:step(a2), 0)
end
function u3._GetThirdPersonLocalOffset(a1)
    --[[
      name: _GetThirdPersonLocalOffset
      line: 176
      upvalues:
        VehicleCameraConfig_upv_1 (copy, index: 1)
    ]]
    return a1.assemblyOffset + Vector3.new(0, a1.assemblyRadius * VehicleCameraConfig_upv_1.verticalCenterOffset, 0)
end
function u3._GetFirstPersonLocalOffset(a1, a2)
    --[[
      name: _GetFirstPersonLocalOffset
      line: 180
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
    ]]
    local Character_1 = LocalPlayer_upv_1.Character
    if Character_1 and Character_1.Parent then
        local Head_1 = Character_1:FindFirstChild("Head")
        if Head_1 and Head_1:IsA("BasePart") then
            return a2:Inverse() * Head_1.Position
        end
    end
    return a1:_GetThirdPersonLocalOffset()
end
function u3.Update(a1)
    --[[
      name: Update
      line: 194
      upvalues:
        u1 (ref,  index: 1)
        u2 (ref,  index: 2)
        LocalPlayer_upv_1 (copy, index: 3)
        VRService_upv_1 (copy, index: 4)
    ]]
    if not u1 then
        return a1:UpdateComfortCamera()
    end
    local v8 = u2
    u2 = 0
    a1:UpdateFadeFromBlack(v8)
    a1:UpdateEdgeBlur(LocalPlayer_upv_1, v8)
    if VRService_upv_1.ThirdPersonFollowCamEnabled then
        local v9, v10 = a1:UpdateStepRotation(v8)
        return v9, v10
    else
        local v11, v12 = a1:UpdateComfortCamera(v8)
        return v11, v12
    end
end
function u3.addDrift(a1, a2, a3)
    --[[
      name: addDrift
      line: 217
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        VRService_upv_1 (copy, index: 2)
    ]]
    local function NormalizeAngle(a4)
        --[[
          name: NormalizeAngle
          line: 218
        ]]
        a4 = (a4 + 12.566370614359172) % math.tau
        return ((a4 > math.pi) and (a4 - math.tau)) or a4
    end
    local CurrentCamera_2 = workspace.CurrentCamera
    local v13 = a1:GetCameraToSubjectDistance()
    local v14 = a1:GetSubjectVelocity()
    local v15 = a1:GetSubjectCFrame()
    local _ = require(LocalPlayer_upv_1:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"))
    local v16 = nil
    if v14.Magnitude > 0.1 then
        local v17 = VRService_upv_1:GetUserCFrame(Enum.UserCFrame.Head)
        local v18 = CurrentCamera_2.CFrame * (v17.Rotation + (v17.Position * CurrentCamera_2.HeadScale))
        local v27, v19 = v18:ToEulerAnglesYXZ()
        local v28, v20 = v15:ToEulerAnglesYXZ()
        local v21 = ((v19 - a1.currentDriftAngle) + 12.566370614359172) % math.tau
        local v22 = ((v21 > math.pi) and (v21 - math.tau)) or v21
        local v23 = ((v20 - a1.currentDriftAngle) + 12.566370614359172) % math.tau
        local v24 = ((v23 > math.pi) and (v23 - math.tau)) or v23
        v16 = math.min(v24, v22)
        local v25 = math.max(v24, v22)
        local v26 = 0
        if v16 > 0 then
            v26 = v16
        elseif v25 < 0 then
            v26 = v25
        end
        a1.currentDriftAngle = v26 + a1.currentDriftAngle
        local LookVector_1 = CFrame.fromEulerAnglesYXZ(0, a1.currentDriftAngle, 0).LookVector
        a2 = a2:Lerp(CFrame.new((CurrentCamera_2.CFrame.Position + (a3.Position - Vector3.new(LookVector_1.X, 0, LookVector_1.Z).Unit * v13)) - v18.Position) * CurrentCamera_2.CFrame.Rotation, 0.01)
    end
    return a2, a3
end
function u3.UpdateRotationCamera(a1, a2)
    --[[
      name: UpdateRotationCamera
      line: 275
      upvalues:
        mapClamp_upv_1 (copy, index: 1)
        LocalPlayer_upv_1 (copy, index: 2)
    ]]
    local CurrentCamera_3 = workspace.CurrentCamera
    local v27 = CurrentCamera_3 and (CurrentCamera_3.CameraSubject)
    local vehicleCameraCore_1 = a1.vehicleCameraCore
    assert(CurrentCamera_3)
    assert(v27)
    assert(v27:IsA("VehicleSeat"))
    local v28 = a1:GetSubjectCFrame()
    local v29 = a1:GetSubjectVelocity()
    local v30 = a1:GetSubjectRotVelocity()
    local v31 = math.abs(v29:Dot(v28.ZVector))
    local v32 = math.abs(v28.YVector:Dot(v30))
    local v33 = math.abs(v28.XVector:Dot(v30))
    local v34 = a1:GetCameraToSubjectDistance()
    local v35 = mapClamp_upv_1(v34, 0.5, a1.assemblyRadius, 1, 0)
    local v36 = a1:_GetThirdPersonLocalOffset():Lerp(a1:_GetFirstPersonLocalOffset(v28), v35)
    vehicleCameraCore_1:setTransform(v28)
    local v37 = vehicleCameraCore_1:step(a2, v33, v32, v35)
    local v38 = a1:_StepRotation(a2, v31)
    local v39 = a1:GetVRFocus(v28 * v36, a2) * v37 * v38
    local v40 = v39 * CFrame.new(0, 0, v34)
    if v29.Magnitude > 0.1 then
        a1:StartVREdgeBlur(LocalPlayer_upv_1)
    end
    return v40, v39
end
function u3.UpdateStepRotation(a1, a2)
    --[[
      name: UpdateStepRotation
      line: 322
      upvalues:
        mapClamp_upv_1 (copy, index: 1)
        UserGameSettings_upv_1 (copy, index: 2)
        VRService_upv_1 (copy, index: 3)
        LocalPlayer_upv_1 (copy, index: 4)
    ]]
    local CurrentCamera_4 = workspace.CurrentCamera
    local lastSubjectCFrame_1 = a1.lastSubjectCFrame
    local v41 = a1:GetSubjectCFrame()
    local v42 = a1:GetSubjectVelocity()
    local v43 = a1:GetCameraToSubjectDistance()
    local v44 = mapClamp_upv_1(v43, 0.5, a1.assemblyRadius, 1, 0)
    local v45 = a1:_GetThirdPersonLocalOffset():Lerp(a1:_GetFirstPersonLocalOffset(v41), v44)
    local v46 = a1:GetVRFocus(v41 * v45, a2)
    local _, v47 = a1:addDrift(v46:ToWorldSpace(a1:GetVRFocus(lastSubjectCFrame_1 * v45, a2):ToObjectSpace(CurrentCamera_4.CFrame)), v46)
    local v48 = a1:getRotation(a2)
    local v49
    if math.abs(v48) > 0 then
        local v50 = nil
        local v51 = v50:ToObjectSpace(v48)
        local v52 = v50 * CFrame.Angles(0, -v48, 0) * v51
        local v53 = nil
        if not (UserGameSettings_upv_1.VRSmoothRotationEnabled) then
            local v54 = VRService_upv_1:GetUserCFrame(Enum.UserCFrame.Head)
            local v55 = v54.Rotation + v54.Position * CurrentCamera_4.HeadScale
            local v56 = v50 * v41.Rotation
            local v57 = v56:ToObjectSpace(v48 * v55)
            v53 = math.acos(Vector3.new(v57.X, 0, v57.Z).Unit:Dot(Vector3.new(0, 0, 1)))
            local v58 = v56:ToObjectSpace(v52 * v55)
            if math.acos(Vector3.new(v58.X, 0, v58.Z).Unit:Dot(Vector3.new(0, 0, 1))) < v53 then
                v52 = v47 * CFrame.Angles(0, -(((v48 < 0) and (v53 * -1)) or v53), 0) * v51
            end
        end
        v49 = v52
    else
        v49 = v48
    end
    if v42.Magnitude > 0.1 then
        a1:StartVREdgeBlur(LocalPlayer_upv_1)
    end
    if a1.needsReset then
        a1.needsReset = false
        VRService_upv_1:RecenterUserHeadCFrame()
        a1:StartFadeFromBlack()
        a1:ResetZoom()
    end
    if a1.recentered then
        v49 = v47 * v41.Rotation * CFrame.new(0, 0, v43)
        a1.recentered = false
    end
    return v49, v49 * CFrame.new(0, 0, -v43)
end
function u3.UpdateComfortCamera(a1, a2)
    --[[
      name: UpdateComfortCamera
      line: 408
      upvalues:
        u1 (ref,  index: 1)
        u2 (ref,  index: 2)
        mapClamp_upv_1 (copy, index: 3)
        LocalPlayer_upv_1 (copy, index: 4)
    ]]
    local CurrentCamera_5 = workspace.CurrentCamera
    local v59 = CurrentCamera_5 and (CurrentCamera_5.CameraSubject)
    local vehicleCameraCore_2 = a1.vehicleCameraCore
    assert(CurrentCamera_5)
    assert(v59)
    assert(v59:IsA("VehicleSeat"))
    if not (u1) then
        a2 = u2
        u2 = 0
    end
    local v60 = a1:GetSubjectCFrame()
    local v61 = a1:GetSubjectVelocity()
    local v62 = a1:GetSubjectRotVelocity()
    local _ = math.abs(v61:Dot(v60.ZVector))
    local v63 = math.abs(v60.YVector:Dot(v62))
    local v64 = math.abs(v60.XVector:Dot(v62))
    local v65 = a1:StepZoom()
    local v66 = mapClamp_upv_1(v65, 0.5, a1.assemblyRadius, 1, 0)
    local v67 = a1:_GetThirdPersonLocalOffset():Lerp(a1:_GetFirstPersonLocalOffset(v60), v66)
    vehicleCameraCore_2:setTransform(v60)
    local v68 = vehicleCameraCore_2:step(a2, v64, v63, v66)
    if not (u1) then
        a1:UpdateFadeFromBlack(a2)
    end
    local v69, v70
    if a1:IsInFirstPerson() then
        local v71 = CFrame.new(v68.Position, Vector3.new(v68.LookVector.X, 0, v68.LookVector.Z).Unit)
        v70 = CFrame.new(v60 * v67) * v71
        v69 = v70 * CFrame.new(0, 0, v65)
        if not u1 or v61.Magnitude > 0.1 then
            a1:StartVREdgeBlur(LocalPlayer_upv_1)
        end
    else
        v70 = CFrame.new(v60 * v67) * v68
        v69 = v70 * CFrame.new(0, 0, v65)
        if not (a1.lastCameraFocus) then
            a1.lastCameraFocus = v70
            a1.needsReset = true
        end
        local v72 = v70.Position - CurrentCamera_5.CFrame.Position
        local magnitude_1 = v72.magnitude
        if v72.Unit:Dot(CurrentCamera_5.CFrame.LookVector) > 0.56 and magnitude_1 < 200 then
            if a1.needsReset then
                a1.lastCameraFocus = a1:GetVRFocus(v60.Position, a2)
                a1.needsReset = false
                a1:StartFadeFromBlack()
                a1:ResetZoom()
            else
                v70 = a1.lastCameraFocus
                local p_1 = a1.lastCameraFocus.p
                local v73 = a1:GetCameraLookVector()
                v69 = CFrame.new(p_1 - (v65 * a1:CalculateNewLookVectorFromArg(Vector3.new(v73.X, 0, v73.Z).Unit, Vector2.new(0, 0))), p_1)
            end
        else
            a1.lastCameraFocus = a1:GetVRFocus(v60.Position, a2)
            a1.needsReset = false
            a1:StartFadeFromBlack()
            a1:ResetZoom()
        end
        if not u1 then
            a1:UpdateEdgeBlur(LocalPlayer_upv_1, a2)
        end
    end
    return v69, v70
end
return u3