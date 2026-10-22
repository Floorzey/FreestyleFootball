local success, value = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserVRVehicleCamera2")
end)
local value_2 = success and value
local values = { 0, 30 }
local user_game_settings = UserSettings():GetService("UserGameSettings")
local vr_base_camera = require(script.Parent:WaitForChild("VRBaseCamera"))
local camera_input = require(script.Parent:WaitForChild("CameraInput"))
local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
local _ = require(script.Parent:WaitForChild("VehicleCamera"))
local vehicle_camera_core = require(script.Parent.VehicleCamera:FindFirstChild("VehicleCameraCore"))
local vehicle_camera_config = require(script.Parent.VehicleCamera:FindFirstChild("VehicleCameraConfig"))
local players = game:GetService("Players")
local run_service = game:GetService("RunService")
local vr_service = game:GetService("VRService")
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
local vr_vehicle_camera = setmetatable({}, vr_base_camera)
vr_vehicle_camera.__index = vr_vehicle_camera

function vr_vehicle_camera.new()
    local instance = setmetatable(vr_base_camera.new(), vr_vehicle_camera)
    instance:Reset()

    run_service.Stepped:Connect(function(elapsed_time, delta_time)
        number = delta_time
    end)

    return instance
end

function vr_vehicle_camera.Reset(argument)
    argument.vehicleCameraCore = vehicle_camera_core.new(argument:GetSubjectCFrame())

    if value_2 then
        argument.pitchSpring = spring.new(0, 0)
    else
        argument.pitchSpring = spring.new(0, -math.rad(vehicle_camera_config.pitchBaseAngle))
    end

    argument.yawSpring = spring.new(0, 0)

    if value_2 then
        argument.lastPanTick = 0
        argument.currentDriftAngle = 0
        argument.needsReset = true
    end

    local current_camera = workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject
    assert(current_camera, "VRVehicleCamera initialization error")
    assert(camera_subject)
    assert(camera_subject:IsA("VehicleSeat"))
    local get_loose_bounding_sphere_result, value_3 =
        camera_utils.getLooseBoundingSphere(camera_subject:GetConnectedParts(true))
    argument.assemblyRadius = math.max(value_3, 5)
    argument.assemblyOffset = camera_subject.CFrame:Inverse() * get_loose_bounding_sphere_result
    argument.gamepadZoomLevels = {}

    for _, item in values do
        table.insert(argument.gamepadZoomLevels, ((item * argument.headScale) * argument.assemblyRadius) / 10)
    end

    argument.lastCameraFocus = nil
    argument:SetCameraToSubjectDistance(argument.gamepadZoomLevels[#argument.gamepadZoomLevels])
end

function vr_vehicle_camera._StepRotation(argument, argument_2, argument_3)
    local yaw_spring = argument.yawSpring
    local pitch_spring = argument.pitchSpring
    yaw_spring.pos = sanitize_angle(yaw_spring.pos + -argument:getRotation(argument_2))
    pitch_spring.pos = sanitize_angle(math.clamp(pitch_spring.pos, -1.3962634015954636, 1.3962634015954636))

    if camera_input.getRotationActivated() then
        argument.lastPanTick = os.clock()
    end

    local radians = math.rad(vehicle_camera_config.pitchDeadzoneAngle)

    if vehicle_camera_config.autocorrectDelay < os.clock() - argument.lastPanTick then
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

        if math.abs(sanitize_angle(0 - pitch_spring.pos)) <= radians then
            pitch_spring.goal = pitch_spring.pos
        else
            pitch_spring.goal = 0
        end
    else
        yaw_spring.freq = 0
        yaw_spring.vel = 0
        pitch_spring.freq = 0
        pitch_spring.vel = 0
        pitch_spring.goal = 0
    end

    return CFrame.fromEulerAnglesYXZ(pitch_spring:step(argument_2), yaw_spring:step(argument_2), 0)
end

function vr_vehicle_camera._GetThirdPersonLocalOffset(argument)
    return argument.assemblyOffset
        + Vector3.new(0, argument.assemblyRadius * vehicle_camera_config.verticalCenterOffset, 0)
end

function vr_vehicle_camera._GetFirstPersonLocalOffset(argument, argument_2)
    local character = local_player.Character

    if character and character.Parent then
        local head = character:FindFirstChild("Head")

        if head and head:IsA("BasePart") then
            return argument_2:Inverse() * head.Position
        end
    end

    return argument:_GetThirdPersonLocalOffset()
end

function vr_vehicle_camera.Update(argument)
    if not value_2 then
        return argument:UpdateComfortCamera()
    end

    local number_2 = number
    number = 0
    argument:UpdateFadeFromBlack(number_2)
    argument:UpdateEdgeBlur(local_player, number_2)

    if vr_service.ThirdPersonFollowCamEnabled then
        local update_step_rotation_result, value_3 = argument:UpdateStepRotation(number_2)

        return update_step_rotation_result, value_3
    end

    local update_comfort_camera_result, value_4 = argument:UpdateComfortCamera(number_2)

    return update_comfort_camera_result, value_4
end

function vr_vehicle_camera.addDrift(argument, interpolated_value, argument_2)
    local function normalize_angle(remainder_3)
        remainder_3 = (remainder_3 + 12.566370614359172) % math.tau

        return ((remainder_3 > math.pi) and (remainder_3 - math.tau)) or remainder_3
    end

    local current_camera = workspace.CurrentCamera
    local camera_to_subject_distance = argument:GetCameraToSubjectDistance()
    local vector = argument:GetSubjectVelocity()
    local subject_c_frame = argument:GetSubjectCFrame()
    local _ = require(local_player:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"))
    local value_3 = nil

    if vector.Magnitude > 0.1 then
        local user_c_frame = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
        local product = current_camera.CFrame
            * (user_c_frame.Rotation + (user_c_frame.Position * current_camera.HeadScale))
        local to_euler_angles_yxz_result, value_4 = product:ToEulerAnglesYXZ()
        local to_euler_angles_yxz_result_2, value_5 = subject_c_frame:ToEulerAnglesYXZ()
        local remainder = ((value_4 - argument.currentDriftAngle) + 12.566370614359172) % math.tau
        local difference = ((remainder > math.pi) and (remainder - math.tau)) or remainder
        local remainder_2 = ((value_5 - argument.currentDriftAngle) + 12.566370614359172) % math.tau
        local difference_2 = ((remainder_2 > math.pi) and (remainder_2 - math.tau)) or remainder_2
        value_3 = math.min(difference_2, difference)
        local maximum = math.max(difference_2, difference)
        local number_2 = 0

        if value_3 > 0 then
            number_2 = value_3
        elseif maximum < 0 then
            number_2 = maximum
        end

        argument.currentDriftAngle = number_2 + argument.currentDriftAngle
        local look_vector = CFrame.fromEulerAnglesYXZ(0, argument.currentDriftAngle, 0).LookVector
        interpolated_value = interpolated_value:Lerp(
            CFrame.new(
                (
                    current_camera.CFrame.Position
                    + (
                        argument_2.Position
                        - Vector3.new(look_vector.X, 0, look_vector.Z).Unit * camera_to_subject_distance
                    )
                ) - product.Position
            ) * current_camera.CFrame.Rotation,
            0.01
        )
    end

    return interpolated_value, argument_2
end

function vr_vehicle_camera.UpdateRotationCamera(argument, argument_2)
    local current_camera = workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject
    local vehicle_camera_core_2 = argument.vehicleCameraCore
    assert(current_camera)
    assert(camera_subject)
    assert(camera_subject:IsA("VehicleSeat"))
    local subject_c_frame = argument:GetSubjectCFrame()
    local vector = argument:GetSubjectVelocity()
    local subject_rot_velocity = argument:GetSubjectRotVelocity()
    local absolute_value = math.abs(vector:Dot(subject_c_frame.ZVector))
    local absolute_value_2 = math.abs(subject_c_frame.YVector:Dot(subject_rot_velocity))
    local absolute_value_3 = math.abs(subject_c_frame.XVector:Dot(subject_rot_velocity))
    local camera_to_subject_distance = argument:GetCameraToSubjectDistance()
    local result = map_clamp(camera_to_subject_distance, 0.5, argument.assemblyRadius, 1, 0)
    local interpolated_value =
        argument:_GetThirdPersonLocalOffset():Lerp(argument:_GetFirstPersonLocalOffset(subject_c_frame), result)
    vehicle_camera_core_2:setTransform(subject_c_frame)
    local step_result = vehicle_camera_core_2:step(argument_2, absolute_value_3, absolute_value_2, result)
    local step_rotation_result = argument:_StepRotation(argument_2, absolute_value)
    local product = argument:GetVRFocus(subject_c_frame * interpolated_value, argument_2)
        * step_result
        * step_rotation_result
    local product_2 = product * CFrame.new(0, 0, camera_to_subject_distance)

    if vector.Magnitude > 0.1 then
        argument:StartVREdgeBlur(local_player)
    end

    return product_2, product
end

function vr_vehicle_camera.UpdateStepRotation(argument, argument_2)
    local current_camera = workspace.CurrentCamera
    local last_subject_c_frame = argument.lastSubjectCFrame
    local subject_c_frame = argument:GetSubjectCFrame()
    local vector = argument:GetSubjectVelocity()
    local camera_to_subject_distance = argument:GetCameraToSubjectDistance()
    local result = map_clamp(camera_to_subject_distance, 0.5, argument.assemblyRadius, 1, 0)
    local interpolated_value =
        argument:_GetThirdPersonLocalOffset():Lerp(argument:_GetFirstPersonLocalOffset(subject_c_frame), result)
    local vr_focus = argument:GetVRFocus(subject_c_frame * interpolated_value, argument_2)
    local add_drift_result, relative_cframe = argument:addDrift(
        vr_focus:ToWorldSpace(
            argument
                :GetVRFocus(last_subject_c_frame * interpolated_value, argument_2)
                :ToObjectSpace(current_camera.CFrame)
        ),
        vr_focus
    )
    interpolated_value = argument:getRotation(argument_2)
    local product

    if math.abs(interpolated_value) > 0 then
        local value_3 = nil
        local relative_cframe_2 = value_3:ToObjectSpace(add_drift_result)
        local product_2 = value_3 * CFrame.Angles(0, -interpolated_value, 0) * relative_cframe_2
        local value_4 = nil

        if not user_game_settings.VRSmoothRotationEnabled then
            local user_c_frame = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
            local sum = user_c_frame.Rotation + user_c_frame.Position * current_camera.HeadScale
            local product_3 = value_3 * subject_c_frame.Rotation
            add_drift_result = product_3:ToObjectSpace(add_drift_result * sum)
            value_4 = math.acos(Vector3.new(add_drift_result.X, 0, add_drift_result.Z).Unit:Dot(Vector3.new(0, 0, 1)))
            relative_cframe = product_3:ToObjectSpace(product_2 * sum)

            if
                math.acos(Vector3.new(relative_cframe.X, 0, relative_cframe.Z).Unit:Dot(Vector3.new(0, 0, 1))) < value_4
            then
                product_2 = relative_cframe
                    * CFrame.Angles(0, -(((interpolated_value < 0) and (value_4 * -1)) or value_4), 0)
                    * relative_cframe_2
            end
        end

        product = product_2
    else
        product = add_drift_result
    end

    if vector.Magnitude > 0.1 then
        argument:StartVREdgeBlur(local_player)
    end

    if argument.needsReset then
        argument.needsReset = false
        vr_service:RecenterUserHeadCFrame()
        argument:StartFadeFromBlack()
        argument:ResetZoom()
    end

    if argument.recentered then
        product = relative_cframe * subject_c_frame.Rotation * CFrame.new(0, 0, camera_to_subject_distance)
        argument.recentered = false
    end

    return product, product * CFrame.new(0, 0, -camera_to_subject_distance)
end

function vr_vehicle_camera.UpdateComfortCamera(argument, number_2)
    local current_camera = workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject
    local vehicle_camera_core_2 = argument.vehicleCameraCore
    assert(current_camera)
    assert(camera_subject)
    assert(camera_subject:IsA("VehicleSeat"))

    if not value_2 then
        number_2 = number
        number = 0
    end

    local subject_c_frame = argument:GetSubjectCFrame()
    local vector = argument:GetSubjectVelocity()
    local subject_rot_velocity = argument:GetSubjectRotVelocity()
    local _ = math.abs(vector:Dot(subject_c_frame.ZVector))
    local magnitude = math.abs(subject_c_frame.YVector:Dot(subject_rot_velocity))
    local absolute_value = math.abs(subject_c_frame.XVector:Dot(subject_rot_velocity))
    local step_zoom_result = argument:StepZoom()
    local result = map_clamp(step_zoom_result, 0.5, argument.assemblyRadius, 1, 0)
    local interpolated_value =
        argument:_GetThirdPersonLocalOffset():Lerp(argument:_GetFirstPersonLocalOffset(subject_c_frame), result)
    vehicle_camera_core_2:setTransform(subject_c_frame)
    local step_result = vehicle_camera_core_2:step(number_2, absolute_value, magnitude, result)

    if not value_2 then
        argument:UpdateFadeFromBlack(number_2)
    end

    local last_camera_focus

    if argument:IsInFirstPerson() then
        local cframe =
            CFrame.new(step_result.Position, Vector3.new(step_result.LookVector.X, 0, step_result.LookVector.Z).Unit)
        last_camera_focus = CFrame.new(subject_c_frame * interpolated_value) * cframe
        local product = last_camera_focus * CFrame.new(0, 0, step_zoom_result)

        if value_2 then
            if vector.Magnitude > 0.1 then
                argument:StartVREdgeBlur(local_player)

                return product, last_camera_focus
            end
        else
            argument:StartVREdgeBlur(local_player)
        end

        result = product
    else
        last_camera_focus = CFrame.new(subject_c_frame * interpolated_value) * step_result
        local product_2 = last_camera_focus * CFrame.new(0, 0, step_zoom_result)

        if not argument.lastCameraFocus then
            argument.lastCameraFocus = last_camera_focus
            argument.needsReset = true
        end

        absolute_value = last_camera_focus.Position - current_camera.CFrame.Position
        magnitude = absolute_value.magnitude

        if absolute_value.Unit:Dot(current_camera.CFrame.LookVector) > 0.56 and magnitude < 200 then
            if argument.needsReset then
                argument.lastCameraFocus = argument:GetVRFocus(subject_c_frame.Position, number_2)
                argument.needsReset = false
                argument:StartFadeFromBlack()
                argument:ResetZoom()
                result = product_2
            else
                last_camera_focus = argument.lastCameraFocus
                local p = argument.lastCameraFocus.p
                local camera_look_vector = argument:GetCameraLookVector()
                result = CFrame.new(
                    p
                        - (
                            step_zoom_result
                            * argument:CalculateNewLookVectorFromArg(
                                Vector3.new(camera_look_vector.X, 0, camera_look_vector.Z).Unit,
                                Vector2.new(0, 0)
                            )
                        ),
                    p
                )
            end
        else
            argument.lastCameraFocus = argument:GetVRFocus(subject_c_frame.Position, number_2)
            argument.needsReset = false
            argument:StartFadeFromBlack()
            argument:ResetZoom()
            result = product_2
        end

        if not value_2 then
            argument:UpdateEdgeBlur(local_player, number_2)

            return result, last_camera_focus
        end
    end

    return result, last_camera_focus
end

return vr_vehicle_camera
