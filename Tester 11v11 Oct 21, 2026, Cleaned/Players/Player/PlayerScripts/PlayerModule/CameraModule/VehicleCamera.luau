local values = { 0, 15, 30 }
local players = game:GetService("Players")
local run_service = game:GetService("RunService")
local base_camera = require(script.Parent:WaitForChild("BaseCamera"))
local camera_input = require(script.Parent:WaitForChild("CameraInput"))
local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
require(script.Parent:WaitForChild("ZoomController"))
local vehicle_camera_core = require(script:WaitForChild("VehicleCameraCore"))
local vehicle_camera_config = require(script:WaitForChild("VehicleCameraConfig"))
local local_player = players.LocalPlayer
local _ = camera_utils.map
local spring = camera_utils.Spring
local map_clamp = camera_utils.mapClamp
local sanitize_angle = camera_utils.sanitizeAngle

local function pitch_velocity(argument, argument_2)
    local dot_product = argument_2.XVector:Dot(argument)

    return math.abs(dot_product)
end

local function yaw_velocity(argument, argument_2)
    local dot_product = argument_2.YVector:Dot(argument)

    return math.abs(dot_product)
end

local number = 0.016666666666666666

run_service.Stepped:Connect(function(elapsed_time, delta_time)
    number = delta_time
end)

local vehicle_camera = setmetatable({}, base_camera)
vehicle_camera.__index = vehicle_camera

function vehicle_camera.new()
    local base_camera_2 = base_camera.new()
    local instance = setmetatable(base_camera_2, vehicle_camera)
    instance:Reset()

    return instance
end

function vehicle_camera.Reset(argument)
    argument.vehicleCameraCore = vehicle_camera_core.new(argument:GetSubjectCFrame())
    argument.pitchSpring = spring.new(0, -math.rad(vehicle_camera_config.pitchBaseAngle))
    argument.yawSpring = spring.new(0, 0)
    argument.lastPanTick = 0
    local workspace_current_camera = workspace.CurrentCamera
    local camera_subject

    if workspace_current_camera then
        camera_subject = workspace_current_camera.CameraSubject
    else
        camera_subject = workspace_current_camera
    end

    assert(workspace_current_camera)
    assert(camera_subject)
    assert(camera_subject:IsA("VehicleSeat"))
    local connected_parts = camera_subject:GetConnectedParts(true)
    local loose_bounding_sphere, value = camera_utils.getLooseBoundingSphere(connected_parts)
    argument.assemblyRadius = math.max(value, 5)
    argument.assemblyOffset = camera_subject.CFrame:Inverse() * loose_bounding_sphere
    argument.gamepadZoomLevels = {}

    for _, item in values do
        table.insert(argument.gamepadZoomLevels, item * argument.assemblyRadius / 10)
    end

    argument:SetCameraToSubjectDistance(argument.gamepadZoomLevels[#argument.gamepadZoomLevels])
end

function vehicle_camera._StepRotation(argument, argument_2, argument_3)
    local yaw_spring = argument.yawSpring
    local pitch_spring = argument.pitchSpring
    local rotation = camera_input.getRotation(argument_2, true)
    local negated_value = -rotation.Y
    yaw_spring.pos = sanitize_angle(yaw_spring.pos + -rotation.X)
    pitch_spring.pos =
        sanitize_angle((math.clamp(pitch_spring.pos + negated_value, -1.3962634015954636, 1.3962634015954636)))

    if camera_input.getRotationActivated() then
        argument.lastPanTick = os.clock()
    end

    local goal = -math.rad(vehicle_camera_config.pitchBaseAngle)
    local radians = math.rad(vehicle_camera_config.pitchDeadzoneAngle)

    if os.clock() - argument.lastPanTick > vehicle_camera_config.autocorrectDelay then
        local freq = map_clamp(
            argument_3,
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

        local result = sanitize_angle(goal - pitch_spring.pos)

        if math.abs(result) <= radians then
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

    return CFrame.fromEulerAnglesYXZ(pitch_spring:step(argument_2), yaw_spring:step(argument_2), 0)
end

function vehicle_camera._GetThirdPersonLocalOffset(argument)
    return argument.assemblyOffset
        + Vector3.new(0, argument.assemblyRadius * vehicle_camera_config.verticalCenterOffset, 0)
end

function vehicle_camera._GetFirstPersonLocalOffset(argument: table, argument_2)
    local character = local_player.Character

    if character and character.Parent then
        local head = character:FindFirstChild("Head")

        if head and head:IsA("BasePart") then
            return argument_2:Inverse() * head.Position
        end
    end

    return argument:_GetThirdPersonLocalOffset()
end

function vehicle_camera.Update(argument)
    local workspace_current_camera = workspace.CurrentCamera
    local camera_subject

    if workspace_current_camera then
        camera_subject = workspace_current_camera.CameraSubject
    else
        camera_subject = workspace_current_camera
    end

    local vehicle_camera_core_2 = argument.vehicleCameraCore
    assert(workspace_current_camera)
    assert(camera_subject)
    assert(camera_subject:IsA("VehicleSeat"))
    local number_2 = number
    number = 0
    local subject_c_frame = argument:GetSubjectCFrame()
    local subject_velocity = argument:GetSubjectVelocity()
    local subject_rot_velocity = argument:GetSubjectRotVelocity()
    local dot_product = subject_velocity:Dot(subject_c_frame.ZVector)
    local absolute_value = math.abs(dot_product)
    local dot_product_2 = subject_c_frame.YVector:Dot(subject_rot_velocity)
    local absolute_value_2 = math.abs(dot_product_2)
    local dot_product_3 = subject_c_frame.XVector:Dot(subject_rot_velocity)
    local absolute_value_3 = math.abs(dot_product_3)
    local step_zoom_result = argument:StepZoom()
    local step_rotation_result = argument:_StepRotation(number_2, absolute_value)
    local result = map_clamp(step_zoom_result, 0.5, argument.assemblyRadius, 1, 0)
    local interpolated_value =
        argument:_GetThirdPersonLocalOffset():Lerp(argument:_GetFirstPersonLocalOffset(subject_c_frame), result)
    vehicle_camera_core_2:setTransform(subject_c_frame)
    local step_result = vehicle_camera_core_2:step(number_2, absolute_value_3, absolute_value_2, result)
    local product = CFrame.new(subject_c_frame * interpolated_value) * step_result * step_rotation_result

    return product * CFrame.new(0, 0, step_zoom_result), product
end

function vehicle_camera.ApplyVRTransform(argument) end

return vehicle_camera
