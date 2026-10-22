local success, result = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserVRVehicleCamera2")
end)
local result_2 = success and result
local values = { 0, 30 }
local user_game_settings = UserSettings():GetService("UserGameSettings")
local vr_base_camera = require(script.Parent:WaitForChild("VRBaseCamera"))
local camera_input = require(script.Parent:WaitForChild("CameraInput"))
local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
require(script.Parent:WaitForChild("VehicleCamera"))
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
    local dot_product = argument_2.XVector:Dot(argument)

    return math.abs(dot_product)
end

local function yaw_velocity(argument, argument_2)
    local dot_product = argument_2.YVector:Dot(argument)

    return math.abs(dot_product)
end

local number = 0.016666666666666666
local vr_vehicle_camera = setmetatable({}, vr_base_camera)
vr_vehicle_camera.__index = vr_vehicle_camera

function vr_vehicle_camera.new()
    local vr_base_camera_2 = vr_base_camera.new()
    local instance = setmetatable(vr_base_camera_2, vr_vehicle_camera)
    instance:Reset()

    run_service.Stepped:Connect(function(elapsed_time, delta_time)
        number = delta_time
    end)

    return instance
end

function vr_vehicle_camera.Reset(argument)
    argument.vehicleCameraCore = vehicle_camera_core.new(argument:GetSubjectCFrame())

    if result_2 then
        argument.pitchSpring = spring.new(0, 0)
    else
        argument.pitchSpring = spring.new(0, -math.rad(vehicle_camera_config.pitchBaseAngle))
    end

    argument.yawSpring = spring.new(0, 0)

    if result_2 then
        argument.lastPanTick = 0
        argument.currentDriftAngle = 0
        argument.needsReset = true
    end

    local workspace_current_camera = workspace.CurrentCamera
    local camera_subject

    if workspace_current_camera then
        camera_subject = workspace_current_camera.CameraSubject
    else
        camera_subject = workspace_current_camera
    end

    assert(workspace_current_camera, "VRVehicleCamera initialization error")
    assert(camera_subject)
    assert(camera_subject:IsA("VehicleSeat"))
    local connected_parts = camera_subject:GetConnectedParts(true)
    local loose_bounding_sphere, value = camera_utils.getLooseBoundingSphere(connected_parts)
    argument.assemblyRadius = math.max(value, 5)
    argument.assemblyOffset = camera_subject.CFrame:Inverse() * loose_bounding_sphere
    argument.gamepadZoomLevels = {}

    for _, item in values do
        table.insert(argument.gamepadZoomLevels, item * argument.headScale * argument.assemblyRadius / 10)
    end

    argument.lastCameraFocus = nil
    argument:SetCameraToSubjectDistance(argument.gamepadZoomLevels[#argument.gamepadZoomLevels])
end

function vr_vehicle_camera._StepRotation(argument, argument_2, argument_3)
    local yaw_spring = argument.yawSpring
    local pitch_spring = argument.pitchSpring
    local negated_value = -argument:getRotation(argument_2)
    yaw_spring.pos = sanitize_angle(yaw_spring.pos + negated_value)
    pitch_spring.pos = sanitize_angle((math.clamp(pitch_spring.pos, -1.3962634015954636, 1.3962634015954636)))

    if camera_input.getRotationActivated() then
        argument.lastPanTick = os.clock()
    end

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

        local result_3 = sanitize_angle(0 - pitch_spring.pos)

        if math.abs(result_3) <= radians then
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

function vr_vehicle_camera._GetFirstPersonLocalOffset(argument: table, argument_2)
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
    if not result_2 then
        return argument:UpdateComfortCamera()
    end

    local number_2 = number
    number = 0
    argument:UpdateFadeFromBlack(number_2)
    argument:UpdateEdgeBlur(local_player, number_2)

    if vr_service.ThirdPersonFollowCamEnabled then
        local update_step_rotation_result, value = argument:UpdateStepRotation(number_2)

        return update_step_rotation_result, value
    end

    local update_comfort_camera_result, value_2 = argument:UpdateComfortCamera(number_2)

    return update_comfort_camera_result, value_2
end

function vr_vehicle_camera.addDrift(argument, interpolated_value, argument_2)
    local function normalize_angle(argument_3)
        local remainder_3 = (argument_3 + 12.566370614359172) % 6.283185307179586

        if remainder_3 > 3.141592653589793 then
            remainder_3 -= 6.283185307179586
        end

        return remainder_3
    end

    local workspace_current_camera = workspace.CurrentCamera
    local camera_to_subject_distance = argument:GetCameraToSubjectDistance()
    local subject_velocity = argument:GetSubjectVelocity()
    local subject_c_frame = argument:GetSubjectCFrame()
    require(local_player:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"))

    if subject_velocity.Magnitude > 0.1 then
        local user_c_frame = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
        local product = workspace_current_camera.CFrame
            * (user_c_frame.Rotation + user_c_frame.Position * workspace_current_camera.HeadScale)
        local _, value, _ = product:ToEulerAnglesYXZ()
        local _, value_2, _ = subject_c_frame:ToEulerAnglesYXZ()
        local remainder = (value - argument.currentDriftAngle + 12.566370614359172) % 6.283185307179586

        if remainder > 3.141592653589793 then
            remainder -= 6.283185307179586
        end

        local remainder_2 = (value_2 - argument.currentDriftAngle + 12.566370614359172) % 6.283185307179586

        if remainder_2 > 3.141592653589793 then
            remainder_2 -= 6.283185307179586
        end

        local minimum = math.min(remainder_2, remainder)
        local maximum = math.max(remainder_2, remainder)
        local number_2 = 0

        if minimum > 0 then
            maximum = minimum
        elseif maximum >= 0 then
            maximum = number_2
        end

        argument.currentDriftAngle = maximum + argument.currentDriftAngle
        local look_vector = CFrame.fromEulerAnglesYXZ(0, argument.currentDriftAngle, 0).LookVector
        local product_2 = Vector3.new(look_vector.X, 0, look_vector.Z).Unit * camera_to_subject_distance
        interpolated_value = interpolated_value:Lerp(
            CFrame.new(workspace_current_camera.CFrame.Position + (argument_2.Position - product_2) - product.Position)
                * workspace_current_camera.CFrame.Rotation,
            0.01
        )
    end

    return interpolated_value, argument_2
end

function vr_vehicle_camera.UpdateRotationCamera(argument, argument_2)
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
    local subject_c_frame = argument:GetSubjectCFrame()
    local subject_velocity = argument:GetSubjectVelocity()
    local subject_rot_velocity = argument:GetSubjectRotVelocity()
    local dot_product = subject_velocity:Dot(subject_c_frame.ZVector)
    local absolute_value = math.abs(dot_product)
    local dot_product_2 = subject_c_frame.YVector:Dot(subject_rot_velocity)
    local absolute_value_2 = math.abs(dot_product_2)
    local dot_product_3 = subject_c_frame.XVector:Dot(subject_rot_velocity)
    local absolute_value_3 = math.abs(dot_product_3)
    local camera_to_subject_distance = argument:GetCameraToSubjectDistance()
    local result_3 = map_clamp(camera_to_subject_distance, 0.5, argument.assemblyRadius, 1, 0)
    local interpolated_value =
        argument:_GetThirdPersonLocalOffset():Lerp(argument:_GetFirstPersonLocalOffset(subject_c_frame), result_3)
    vehicle_camera_core_2:setTransform(subject_c_frame)
    local step_result = vehicle_camera_core_2:step(argument_2, absolute_value_3, absolute_value_2, result_3)
    local step_rotation_result = argument:_StepRotation(argument_2, absolute_value)
    local product = argument:GetVRFocus(subject_c_frame * interpolated_value, argument_2)
        * step_result
        * step_rotation_result
    local product_2 = product * CFrame.new(0, 0, camera_to_subject_distance)

    if subject_velocity.Magnitude > 0.1 then
        argument:StartVREdgeBlur(local_player)
    end

    return product_2, product
end

function vr_vehicle_camera.UpdateStepRotation(argument, argument_2)
    local workspace_current_camera = workspace.CurrentCamera
    local last_subject_c_frame = argument.lastSubjectCFrame
    local subject_c_frame = argument:GetSubjectCFrame()
    local subject_velocity = argument:GetSubjectVelocity()
    local camera_to_subject_distance = argument:GetCameraToSubjectDistance()
    local result_3 = map_clamp(camera_to_subject_distance, 0.5, argument.assemblyRadius, 1, 0)
    local interpolated_value =
        argument:_GetThirdPersonLocalOffset():Lerp(argument:_GetFirstPersonLocalOffset(subject_c_frame), result_3)
    local vr_focus = argument:GetVRFocus(subject_c_frame * interpolated_value, argument_2)
    local add_drift_result, value = argument:addDrift(
        vr_focus:ToWorldSpace(
            argument
                :GetVRFocus(last_subject_c_frame * interpolated_value, argument_2)
                :ToObjectSpace(workspace_current_camera.CFrame)
        ),
        vr_focus
    )
    local rotation = argument:getRotation(argument_2)
    local product

    if math.abs(rotation) > 0 then
        local relative_cframe = value:ToObjectSpace(add_drift_result)
        product = value * CFrame.Angles(0, -rotation, 0) * relative_cframe

        if not user_game_settings.VRSmoothRotationEnabled then
            local user_c_frame = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
            local sum = user_c_frame.Rotation + user_c_frame.Position * workspace_current_camera.HeadScale
            local product_2 = value * subject_c_frame.Rotation
            local relative_cframe_2 = product_2:ToObjectSpace(add_drift_result * sum)
            local dot_product = Vector3.new(relative_cframe_2.X, 0, relative_cframe_2.Z).Unit:Dot(Vector3.new(0, 0, 1))
            local angle = math.acos(dot_product)
            local relative_cframe_3 = product_2:ToObjectSpace(product * sum)
            local dot_product_2 = Vector3.new(relative_cframe_3.X, 0, relative_cframe_3.Z).Unit
                :Dot(Vector3.new(0, 0, 1))

            if math.acos(dot_product_2) < angle then
                if rotation < 0 then
                    angle *= -1
                end

                product = value * CFrame.Angles(0, -angle, 0) * relative_cframe
            end
        end
    else
        product = add_drift_result
    end

    if subject_velocity.Magnitude > 0.1 then
        argument:StartVREdgeBlur(local_player)
    end

    if argument.needsReset then
        argument.needsReset = false
        vr_service:RecenterUserHeadCFrame()
        argument:StartFadeFromBlack()
        argument:ResetZoom()
    end

    if argument.recentered then
        product = value * subject_c_frame.Rotation * CFrame.new(0, 0, camera_to_subject_distance)
        argument.recentered = false
    end

    return product, product * CFrame.new(0, 0, -camera_to_subject_distance)
end

function vr_vehicle_camera.UpdateComfortCamera(argument, number_2)
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

    if not result_2 then
        number_2 = number
        number = 0
    end

    local subject_c_frame = argument:GetSubjectCFrame()
    local subject_velocity = argument:GetSubjectVelocity()
    local subject_rot_velocity = argument:GetSubjectRotVelocity()
    local dot_product = subject_velocity:Dot(subject_c_frame.ZVector)
    math.abs(dot_product)
    local dot_product_2 = subject_c_frame.YVector:Dot(subject_rot_velocity)
    local absolute_value = math.abs(dot_product_2)
    local dot_product_3 = subject_c_frame.XVector:Dot(subject_rot_velocity)
    local absolute_value_2 = math.abs(dot_product_3)
    local step_zoom_result = argument:StepZoom()
    local result_3 = map_clamp(step_zoom_result, 0.5, argument.assemblyRadius, 1, 0)
    local interpolated_value =
        argument:_GetThirdPersonLocalOffset():Lerp(argument:_GetFirstPersonLocalOffset(subject_c_frame), result_3)
    vehicle_camera_core_2:setTransform(subject_c_frame)
    local step_result = vehicle_camera_core_2:step(number_2, absolute_value_2, absolute_value, result_3)

    if not result_2 then
        argument:UpdateFadeFromBlack(number_2)
    end

    local last_camera_focus, product

    if argument:IsInFirstPerson() then
        local unit = Vector3.new(step_result.LookVector.X, 0, step_result.LookVector.Z).Unit
        local cframe = CFrame.new(step_result.Position, unit)
        last_camera_focus = CFrame.new(subject_c_frame * interpolated_value) * cframe
        product = last_camera_focus * CFrame.new(0, 0, step_zoom_result)

        if result_2 then
            if subject_velocity.Magnitude > 0.1 then
                argument:StartVREdgeBlur(local_player)

                return product, last_camera_focus
            end
        else
            argument:StartVREdgeBlur(local_player)
        end
    else
        last_camera_focus = CFrame.new(subject_c_frame * interpolated_value) * step_result
        product = last_camera_focus * CFrame.new(0, 0, step_zoom_result)

        if not argument.lastCameraFocus then
            argument.lastCameraFocus = last_camera_focus
            argument.needsReset = true
        end

        local difference = last_camera_focus.Position - workspace_current_camera.CFrame.Position
        local magnitude = difference.magnitude

        if
            difference.Unit:Dot(workspace_current_camera.CFrame.LookVector) > 0.56
            and (magnitude < 200 and not argument.needsReset)
        then
            last_camera_focus = argument.lastCameraFocus
            local p = last_camera_focus.p
            local camera_look_vector = argument:GetCameraLookVector()
            local new_look_vector_from_arg = argument:CalculateNewLookVectorFromArg(
                Vector3.new(camera_look_vector.X, 0, camera_look_vector.Z).Unit,
                Vector2.new(0, 0)
            )
            product = CFrame.new(p - step_zoom_result * new_look_vector_from_arg, p)
        else
            argument.lastCameraFocus = argument:GetVRFocus(subject_c_frame.Position, number_2)
            argument.needsReset = false
            argument:StartFadeFromBlack()
            argument:ResetZoom()
        end

        if not result_2 then
            argument:UpdateEdgeBlur(local_player, number_2)

            return product, last_camera_focus
        end
    end

    return product, last_camera_focus
end

return vr_vehicle_camera
