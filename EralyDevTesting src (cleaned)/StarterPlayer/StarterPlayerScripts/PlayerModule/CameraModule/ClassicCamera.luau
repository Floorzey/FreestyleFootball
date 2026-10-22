Vector2.new(0, 0)
local number = 0
local from_orientation_result = CFrame.fromOrientation(-0.2617993877991494, 0, 0)
local common_utils = script.Parent.Parent:WaitForChild("CommonUtils")
local flag_util = require(common_utils:WaitForChild("FlagUtil"))
local user_flag = flag_util.getUserFlag("UserFixCameraOffsetJitter2")
local user_flag2 = flag_util.getUserFlag("UserCameraInputDt")
local players = game:GetService("Players")
local camera_input = require(script.Parent:WaitForChild("CameraInput"))
local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
local base_camera = require(script.Parent:WaitForChild("BaseCamera"))
local classic_camera = setmetatable({}, base_camera)
classic_camera.__index = classic_camera

function classic_camera.new()
    local base_camera_2 = base_camera.new()
    local instance = setmetatable(base_camera_2, classic_camera)
    instance.isFollowCamera = false
    instance.isCameraToggle = false
    instance.lastUpdate = tick()
    instance.cameraToggleSpring = camera_utils.Spring.new(5, 0)

    return instance
end

function classic_camera.GetCameraToggleOffset(argument: table, argument_2: number)
    if not argument.isCameraToggle then
        return Vector3.new()
    end

    local current_subject_distance = argument.currentSubjectDistance

    if camera_input.getTogglePan() then
        local camera_toggle_spring = argument.cameraToggleSpring
        local map_result =
            camera_utils.map(current_subject_distance, 0.5, argument.FIRST_PERSON_DISTANCE_THRESHOLD, 0, 1)
        camera_toggle_spring.goal = math.clamp(map_result, 0, 1)
    else
        argument.cameraToggleSpring.goal = 0
    end

    local map_result_2 = camera_utils.map(current_subject_distance, 0.5, 64, 0, 1)
    local sum = math.clamp(map_result_2, 0, 1) + 1
    local product = argument.cameraToggleSpring:step(argument_2) * sum

    return Vector3.new(0, product, 0)
end

function classic_camera.SetCameraMovementMode(argument, argument_2)
    base_camera.SetCameraMovementMode(argument, argument_2)
    argument.isFollowCamera = argument_2 == Enum.ComputerCameraMovementMode.Follow
    argument.isCameraToggle = argument_2 == Enum.ComputerCameraMovementMode.CameraToggle
end

function classic_camera.Update(argument, argument_2)
    local last_update = tick()
    local difference = last_update - argument.lastUpdate

    if user_flag2 then
        difference = argument_2
    end

    local workspace_current_camera = workspace.CurrentCamera
    local c_frame2 = workspace_current_camera.CFrame
    local focus = workspace_current_camera.Focus
    local look_vector_2

    if argument.resetCameraAngle then
        local humanoid_root_part = argument:GetHumanoidRootPart()

        if humanoid_root_part then
            look_vector_2 = (humanoid_root_part.CFrame * from_orientation_result).lookVector
        else
            look_vector_2 = from_orientation_result.lookVector
        end

        argument.resetCameraAngle = false
    else
        look_vector_2 = nil
    end

    local local_player = players.LocalPlayer
    local humanoid = argument:GetHumanoid()
    local camera_subject = workspace_current_camera.CameraSubject
    local is_a_result

    if camera_subject then
        is_a_result = camera_subject:IsA("VehicleSeat")
    else
        is_a_result = camera_subject
    end

    local is_a_result_2

    if camera_subject then
        is_a_result_2 = camera_subject:IsA("SkateboardPlatform")
    else
        is_a_result_2 = camera_subject
    end

    local condition

    if humanoid then
        condition = humanoid:GetState() == Enum.HumanoidStateType.Climbing
    else
        condition = humanoid
    end

    if argument.lastUpdate == nil or difference > 1 then
        argument.lastCameraTransform = nil
    end

    local rotation = camera_input.getRotation(difference)
    argument:StepZoom()
    local camera_height = argument:GetCameraHeight()

    if rotation ~= Vector2.new() then
        number = 0
        argument.lastUserPanCamera = tick()
    end

    local condition_2 = last_update - argument.lastUserPanCamera < 2
    local subject_position = argument:GetSubjectPosition()

    if subject_position and (local_player and workspace_current_camera) then
        local camera_to_subject_distance = argument:GetCameraToSubjectDistance()
        local camera_to_subject_distance_2 = camera_to_subject_distance < 0.5 and 0.5 or camera_to_subject_distance

        if argument:GetIsMouseLocked() and not argument:IsInFirstPerson() then
            local new_look_c_frame_from_arg = argument:CalculateNewLookCFrameFromArg(look_vector_2, rotation)
            local mouse_lock_offset = argument:GetMouseLockOffset()

            if user_flag and humanoid then
                mouse_lock_offset += humanoid.CameraOffset
            end

            local sum = mouse_lock_offset.X * new_look_c_frame_from_arg.RightVector
                + mouse_lock_offset.Y * new_look_c_frame_from_arg.UpVector
                + mouse_lock_offset.Z * new_look_c_frame_from_arg.LookVector

            if camera_utils.IsFiniteVector3(sum) then
                subject_position += sum
            end
        elseif rotation == Vector2.new() and argument.lastCameraTransform then
            local is_in_first_person_result = argument:IsInFirstPerson()

            if
                (is_a_result or (is_a_result_2 or argument.isFollowCamera and condition))
                and (argument.lastUpdate and (humanoid and humanoid.Torso))
            then
                if is_in_first_person_result then
                    if
                        argument.lastSubjectCFrame
                        and (is_a_result or is_a_result_2)
                        and camera_subject:IsA("BasePart")
                    then
                        local negated_value = -camera_utils.GetAngleBetweenXZVectors(
                            argument.lastSubjectCFrame.lookVector,
                            camera_subject.CFrame.lookVector
                        )

                        if camera_utils.IsFinite(negated_value) then
                            rotation += Vector2.new(negated_value, 0)
                        end

                        number = 0
                    end
                elseif not condition_2 then
                    local look_vector = humanoid.Torso.CFrame.lookVector
                    number = math.clamp(number + 3.839724354387525 * difference, 0, 4.363323129985824)
                    local clamped_value = math.clamp(number * difference, 0, 1)
                    local clamped_value_2 = argument:IsInFirstPerson()
                            and not (argument.isFollowCamera and argument.isClimbing)
                            and 1
                        or clamped_value
                    local angle_between_xz_vectors =
                        camera_utils.GetAngleBetweenXZVectors(look_vector, argument:GetCameraLookVector())

                    if
                        camera_utils.IsFinite(angle_between_xz_vectors)
                        and math.abs(angle_between_xz_vectors) > 0.0001
                    then
                        rotation += Vector2.new(angle_between_xz_vectors * clamped_value_2, 0)
                    end
                end
            elseif argument.isFollowCamera and not (is_in_first_person_result or condition_2) then
                local angle_between_xz_vectors_2 = camera_utils.GetAngleBetweenXZVectors(
                    -(argument.lastCameraTransform.p - subject_position),
                    argument:GetCameraLookVector()
                )

                if
                    camera_utils.IsFinite(angle_between_xz_vectors_2)
                    and (
                        math.abs(angle_between_xz_vectors_2) > 0.0001
                        and math.abs(angle_between_xz_vectors_2) > 0.4 * difference
                    )
                then
                    rotation += Vector2.new(angle_between_xz_vectors_2, 0)
                end
            end
        end

        local cframe, sum_2

        if argument.isFollowCamera then
            local new_look_vector_from_arg = argument:CalculateNewLookVectorFromArg(look_vector_2, rotation)
            cframe = CFrame.new(subject_position)
            sum_2 = CFrame.new(cframe.p - camera_to_subject_distance_2 * new_look_vector_from_arg, cframe.p)
                + Vector3.new(0, camera_height, 0)
        else
            cframe = CFrame.new(subject_position)
            local p = cframe.p
            local new_look_vector_from_arg_2 = argument:CalculateNewLookVectorFromArg(look_vector_2, rotation)
            sum_2 = CFrame.new(p - camera_to_subject_distance_2 * new_look_vector_from_arg_2, p)
        end

        local camera_toggle_offset = argument:GetCameraToggleOffset(difference)
        focus = cframe + camera_toggle_offset
        c_frame2 = sum_2 + camera_toggle_offset
        argument.lastCameraTransform = c_frame2
        argument.lastCameraFocus = focus

        if (is_a_result or is_a_result_2) and camera_subject:IsA("BasePart") then
            argument.lastSubjectCFrame = camera_subject.CFrame
        else
            argument.lastSubjectCFrame = nil
        end
    end

    argument.lastUpdate = last_update

    return c_frame2, focus
end

return classic_camera
