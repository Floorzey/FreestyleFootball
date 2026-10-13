local values = { 0, 15, 30 }
local players = game:GetService("Players")
local run_service = game:GetService("RunService")
local base_camera = require(script.Parent:WaitForChild("BaseCamera"))
local camera_input = require(script.Parent:WaitForChild("CameraInput"))
local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
local _ = require(script.Parent:WaitForChild("ZoomController"))
local vehicle_camera_core = require(script:WaitForChild("VehicleCameraCore"))
local vehicle_camera_config = require(script:WaitForChild("VehicleCameraConfig"))
local local_player = players.LocalPlayer
local spring = camera_utils.Spring
local map_clamp = camera_utils.mapClamp
local sanitize_angle = camera_utils.sanitizeAngle

local function pitch_velocity(argument, argument_2)
    return (math.abs(argument_2.XVector:Dot(argument)))
end

local function yaw_velocity(argument, argument_2)
    return (math.abs(argument_2.YVector:Dot(argument)))
end

local number = 0.016666666666666666
run_service.Stepped:Connect(function(elapsed_time, delta_time)
    number = delta_time
end)
local vehicle_camera = setmetatable({}, base_camera)
vehicle_camera.__index = vehicle_camera

function vehicle_camera.new()
    local instance = setmetatable(base_camera.new(), vehicle_camera)
    instance:Reset()
    return instance
end

function vehicle_camera.Reset(self)
    self.vehicleCameraCore = vehicle_camera_core.new(self:GetSubjectCFrame())
    self.pitchSpring = spring.new(0, -math.rad(vehicle_camera_config.pitchBaseAngle))
    self.yawSpring = spring.new(0, 0)
    self.lastPanTick = 0
    local current_camera = workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject
    assert(current_camera)
    assert(camera_subject)
    assert(camera_subject:IsA("VehicleSeat"))
    local get_loose_bounding_sphere_result, value =
        camera_utils.getLooseBoundingSphere(camera_subject:GetConnectedParts(true))
    self.assemblyRadius = math.max(value, 5)
    self.assemblyOffset = camera_subject.CFrame:Inverse() * get_loose_bounding_sphere_result
    self.gamepadZoomLevels = {}
    for _, item in values do
        table.insert(self.gamepadZoomLevels, (item * self.assemblyRadius) / 10)
    end
    self:SetCameraToSubjectDistance(self.gamepadZoomLevels[#self.gamepadZoomLevels])
end

function vehicle_camera._StepRotation(self, argument, argument_2)
    local yaw_spring = self.yawSpring
    local pitch_spring = self.pitchSpring
    local get_rotation_result = camera_input.getRotation(argument, true)
    yaw_spring.pos = sanitize_angle(yaw_spring.pos + -get_rotation_result.X)
    pitch_spring.pos =
        sanitize_angle(math.clamp(pitch_spring.pos + -get_rotation_result.Y, -1.3962634015954636, 1.3962634015954636))
    if camera_input.getRotationActivated() then
        self.lastPanTick = os.clock()
    end
    local goal = -math.rad(vehicle_camera_config.pitchBaseAngle)
    local radians = math.rad(vehicle_camera_config.pitchDeadzoneAngle)
    if vehicle_camera_config.autocorrectDelay < os.clock() - self.lastPanTick then
        local freq = map_clamp(
            argument_2,
            vehicle_camera_config.autocorrectMinCarSpeed,
            vehicle_camera_config.autocorrectMaxCarSpeed,
            0,
            vehicle_camera_config.autocorrectResponse
        )
        yaw_spring.freq = freq
        pitch_spring.freq = freq
        if yaw_spring.freq < 0.001 then
            yaw_spring.vel = 0
        end
        if pitch_spring.freq < 0.001 then
            pitch_spring.vel = 0
        end
        if math.abs(sanitize_angle(goal - pitch_spring.pos)) <= radians then
            pitch_spring.goal = pitch_spring.pos
        else
            pitch_spring.goal = goal
        end
    else
        yaw_spring.freq = 0
        yaw_spring.vel = 0
        pitch_spring.freq = 0
        pitch_spring.vel = 0
        pitch_spring.goal = goal
    end
    return CFrame.fromEulerAnglesYXZ(pitch_spring:step(argument), yaw_spring:step(argument), 0)
end

function vehicle_camera._GetThirdPersonLocalOffset(self)
    return self.assemblyOffset + Vector3.new(0, self.assemblyRadius * vehicle_camera_config.verticalCenterOffset, 0)
end

function vehicle_camera._GetFirstPersonLocalOffset(self, argument)
    local character = local_player.Character
    if character and character.Parent then
        local head = character:FindFirstChild("Head")
        if head and head:IsA("BasePart") then
            return argument:Inverse() * head.Position
        end
    end
    return self:_GetThirdPersonLocalOffset()
end

function vehicle_camera.Update(self)
    local current_camera = workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject
    local vehicle_camera_core_2 = self.vehicleCameraCore
    assert(current_camera)
    assert(camera_subject)
    assert(camera_subject:IsA("VehicleSeat"))
    local number_2 = number
    number = 0
    local subject_c_frame = self:GetSubjectCFrame()
    local subject_velocity = self:GetSubjectVelocity()
    local subject_rot_velocity = self:GetSubjectRotVelocity()
    local absolute_value = math.abs(subject_velocity:Dot(subject_c_frame.ZVector))
    local absolute_value_2 = math.abs(subject_c_frame.YVector:Dot(subject_rot_velocity))
    local absolute_value_3 = math.abs(subject_c_frame.XVector:Dot(subject_rot_velocity))
    local step_zoom_result = self:StepZoom()
    local step_rotation_result = self:_StepRotation(number_2, absolute_value)
    local result = map_clamp(step_zoom_result, 0.5, self.assemblyRadius, 1, 0)
    local interpolated_value = self:_GetThirdPersonLocalOffset()
        :Lerp(self:_GetFirstPersonLocalOffset(subject_c_frame), result)
    vehicle_camera_core_2:setTransform(subject_c_frame)
    local step_result = vehicle_camera_core_2:step(number_2, absolute_value_3, absolute_value_2, result)
    local cframe_offset_offset = CFrame.new(subject_c_frame * interpolated_value) * step_result * step_rotation_result
    return cframe_offset_offset * CFrame.new(0, 0, step_zoom_result), cframe_offset_offset
end

function vehicle_camera.ApplyVRTransform(self) end

return vehicle_camera
