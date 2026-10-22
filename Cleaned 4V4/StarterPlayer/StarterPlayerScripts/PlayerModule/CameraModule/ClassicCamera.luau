local _ = Vector2.new(0, 0)
local number = 0
local from_orientation_result = CFrame.fromOrientation(-0.2617993877991494, 0, 0)
local flag_util = require(script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil"))
local get_user_flag_result = flag_util.getUserFlag("UserFixCameraOffsetJitter2")
local get_user_flag_result_2 = flag_util.getUserFlag("UserCameraInputDt")
local players = game:GetService("Players")
local camera_input = require(script.Parent:WaitForChild("CameraInput"))
local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
local base_camera = require(script.Parent:WaitForChild("BaseCamera"))
local classic_camera = setmetatable({}, base_camera)
classic_camera.__index = classic_camera

function classic_camera.new()
    local instance = setmetatable(base_camera.new(), classic_camera)
    instance.isFollowCamera = false
    instance.isCameraToggle = false
    instance.lastUpdate = tick()
    instance.cameraToggleSpring = camera_utils.Spring.new(5, 0)

    return instance
end

function classic_camera.GetCameraToggleOffset(argument, argument_2)
    if not argument.isCameraToggle then
        return (Vector3.new())
    end

    local current_subject_distance = argument.currentSubjectDistance

    if camera_input.getTogglePan() then
        argument.cameraToggleSpring.goal = math.clamp(
            camera_utils.map(current_subject_distance, 0.5, argument.FIRST_PERSON_DISTANCE_THRESHOLD, 0, 1),
            0,
            1
        )
    else
        argument.cameraToggleSpring.goal = 0
    end

    local sum = math.clamp(camera_utils.map(current_subject_distance, 0.5, 64, 0, 1), 0, 1) + 1

    return (Vector3.new(0, argument.cameraToggleSpring:step(argument_2) * sum, 0))
end

function classic_camera.SetCameraMovementMode(argument, argument_2)
    base_camera.SetCameraMovementMode(argument, argument_2)
    argument.isFollowCamera = argument_2 == Enum.ComputerCameraMovementMode.Follow
    argument.isCameraToggle = argument_2 == Enum.ComputerCameraMovementMode.CameraToggle
end

function classic_camera.Update(argument, argument_2)
    local time = tick()
    local difference = time - argument.lastUpdate
    local current_camera = workspace.CurrentCamera
    local cframe = current_camera.CFrame
    local focus = current_camera.Focus
    local look_vector = nil
    local value = nil

    if argument.resetCameraAngle then
        value = argument:GetHumanoidRootPart()

        if value then
            look_vector = (value.CFrame * from_orientation_result).lookVector
        else
            look_vector = from_orientation_result.lookVector
        end

        argument.resetCameraAngle = false
    end

    local local_player = players.LocalPlayer
    local humanoid = argument:GetHumanoid()
    local camera_subject = current_camera.CameraSubject
    local _ = camera_subject and camera_subject:IsA("VehicleSeat")
    local is_a_result = camera_subject and camera_subject:IsA("SkateboardPlatform")
    local condition = humanoid and (humanoid:GetState() == Enum.HumanoidStateType.Climbing)

    if argument.lastUpdate == nil or difference > 1 then
        argument.lastCameraTransform = nil
    end

    local get_rotation_result = camera_input.getRotation(difference)
    argument:StepZoom()
    local camera_height = argument:GetCameraHeight()

    if get_rotation_result ~= Vector2.new() then
        number = 0
        argument.lastUserPanCamera = tick()
    end

    local condition_2 = time - argument.lastUserPanCamera < 2
    local subject_position = argument:GetSubjectPosition()

    if subject_position and local_player and current_camera then
        local camera_to_subject_distance = argument:GetCameraToSubjectDistance()
        local camera_to_subject_distance_2 = ((camera_to_subject_distance < 0.5) and 0.5) or camera_to_subject_distance

        if not (argument:GetIsMouseLocked()) or argument:IsInFirstPerson() then
            local condition_3 = get_rotation_result ~= Vector2.new()

            if not condition_3 and argument.lastCameraTransform then
                local is_in_first_person_result = argument:IsInFirstPerson()

                if camera_subject then
                    if argument.lastUpdate and humanoid and humanoid.Torso then
                        if is_in_first_person_result then
                            if argument.lastSubjectCFrame and camera_subject then
                                local is_a_result_2 = camera_subject:IsA("BasePart")

                                if is_a_result_2 then
                                    local negated_value = -camera_utils.GetAngleBetweenXZVectors(
                                        argument.lastSubjectCFrame.lookVector,
                                        camera_subject.CFrame.lookVector
                                    )
                                    get_rotation_result = (
                                        camera_utils.IsFinite(negated_value)
                                        and (get_rotation_result + Vector2.new(negated_value, 0))
                                    ) or get_rotation_result
                                    number = 0
                                end
                            end
                        elseif not condition_2 then
                            local look_vector_2 = humanoid.Torso.CFrame.lookVector
                            number = math.clamp(number + (3.839724354387525 * difference), 0, 4.363323129985824)
                            local clamped_value = math.clamp(number * difference, 0, 1)
                            local is_in_first_person_result_2 = argument:IsInFirstPerson()

                            if
                                is_in_first_person_result_2
                                and (not argument.isFollowCamera or not argument.isClimbing)
                            then
                                clamped_value = 1
                            end

                            local angle_between_xz_vectors =
                                camera_utils.GetAngleBetweenXZVectors(look_vector_2, argument:GetCameraLookVector())
                            local is_finite_result = camera_utils.IsFinite(angle_between_xz_vectors)

                            if is_finite_result then
                                get_rotation_result = (
                                    (math.abs(angle_between_xz_vectors) > 1e-04)
                                    and (get_rotation_result + Vector2.new(angle_between_xz_vectors * clamped_value, 0))
                                ) or get_rotation_result
                            end
                        end
                    elseif argument.isFollowCamera and not is_in_first_person_result and not condition_2 then
                        local angle_between_xz_vectors_2 = camera_utils.GetAngleBetweenXZVectors(
                            -(argument.lastCameraTransform.p - subject_position),
                            argument:GetCameraLookVector()
                        )
                        local is_finite_result_2 = camera_utils.IsFinite(angle_between_xz_vectors_2)

                        if is_finite_result_2 and math.abs(angle_between_xz_vectors_2) > 1e-04 then
                            get_rotation_result = (
                                (0.4 * difference < math.abs(angle_between_xz_vectors_2))
                                and (get_rotation_result + Vector2.new(angle_between_xz_vectors_2, 0))
                            ) or get_rotation_result
                        end
                    end
                else
                    if
                        (camera_subject or argument.isFollowCamera and condition)
                        and argument.lastUpdate
                        and humanoid
                        and humanoid.Torso
                    then
                        if is_in_first_person_result then
                            if argument.lastSubjectCFrame and camera_subject then
                                local is_a_result_3 = camera_subject:IsA("BasePart")

                                if is_a_result_3 then
                                    local negated_value_2 = -camera_utils.GetAngleBetweenXZVectors(
                                        argument.lastSubjectCFrame.lookVector,
                                        camera_subject.CFrame.lookVector
                                    )
                                    get_rotation_result = (
                                        camera_utils.IsFinite(negated_value_2)
                                        and (get_rotation_result + Vector2.new(negated_value_2, 0))
                                    ) or get_rotation_result
                                    number = 0
                                end
                            end
                        elseif not condition_2 then
                            local look_vector_3 = humanoid.Torso.CFrame.lookVector
                            number = math.clamp(number + (3.839724354387525 * difference), 0, 4.363323129985824)
                            local clamped_value_2 = math.clamp(number * difference, 0, 1)
                            local is_in_first_person_result_3 = argument:IsInFirstPerson()

                            if
                                is_in_first_person_result_3
                                and (not argument.isFollowCamera or not argument.isClimbing)
                            then
                                clamped_value_2 = 1
                            end

                            local angle_between_xz_vectors_3 =
                                camera_utils.GetAngleBetweenXZVectors(look_vector_3, argument:GetCameraLookVector())
                            local is_finite_result_3 = camera_utils.IsFinite(angle_between_xz_vectors_3)

                            if is_finite_result_3 then
                                get_rotation_result = (
                                    (math.abs(angle_between_xz_vectors_3) > 1e-04)
                                    and (
                                        get_rotation_result
                                        + Vector2.new(angle_between_xz_vectors_3 * clamped_value_2, 0)
                                    )
                                ) or get_rotation_result
                            end
                        end

                        if argument.isFollowCamera then
                            local new_look_vector_from_arg =
                                argument:CalculateNewLookVectorFromArg(look_vector, get_rotation_result)
                            focus = CFrame.new(subject_position)
                            cframe = CFrame.new(
                                focus.p - (camera_to_subject_distance_2 * new_look_vector_from_arg),
                                focus.p
                            ) + Vector3.new(0, camera_height, 0)
                        else
                            focus = CFrame.new(subject_position)
                            local p = focus.p
                            cframe = CFrame.new(
                                p
                                    - (
                                        camera_to_subject_distance_2
                                        * argument:CalculateNewLookVectorFromArg(look_vector, get_rotation_result)
                                    ),
                                p
                            )
                        end

                        local camera_toggle_offset = argument:GetCameraToggleOffset(difference)
                        focus += camera_toggle_offset
                        cframe += camera_toggle_offset
                        argument.lastCameraTransform = cframe
                        argument.lastCameraFocus = focus

                        if not camera_subject or not (camera_subject:IsA("BasePart")) then
                            argument.lastSubjectCFrame = nil
                            argument.lastUpdate = time

                            return cframe, focus
                        end

                        argument.lastSubjectCFrame = camera_subject.CFrame
                        argument.lastUpdate = time

                        return cframe, focus
                    end

                    if argument.isFollowCamera and not is_in_first_person_result and not condition_2 then
                        local angle_between_xz_vectors_4 = camera_utils.GetAngleBetweenXZVectors(
                            -(argument.lastCameraTransform.p - subject_position),
                            argument:GetCameraLookVector()
                        )
                        local is_finite_result_4 = camera_utils.IsFinite(angle_between_xz_vectors_4)

                        if is_finite_result_4 and math.abs(angle_between_xz_vectors_4) > 1e-04 then
                            get_rotation_result = (
                                (0.4 * difference < math.abs(angle_between_xz_vectors_4))
                                and (get_rotation_result + Vector2.new(angle_between_xz_vectors_4, 0))
                            ) or get_rotation_result
                        end
                    end
                end
            end
        else
            local new_look_c_frame_from_arg = argument:CalculateNewLookCFrameFromArg(look_vector, get_rotation_result)
            local mouse_lock_offset = argument:GetMouseLockOffset()

            if get_user_flag_result then
                mouse_lock_offset = (humanoid and (mouse_lock_offset + humanoid.CameraOffset)) or mouse_lock_offset
            end

            local sum = (mouse_lock_offset.X * new_look_c_frame_from_arg.RightVector)
                + (mouse_lock_offset.Y * new_look_c_frame_from_arg.UpVector)
                + mouse_lock_offset.Z * new_look_c_frame_from_arg.LookVector
            subject_position = (camera_utils.IsFiniteVector3(sum) and (subject_position + sum)) or subject_position
        end

        if argument.isFollowCamera then
            local new_look_vector_from_arg_2 = argument:CalculateNewLookVectorFromArg(look_vector, get_rotation_result)
            focus = CFrame.new(subject_position)
            cframe = CFrame.new(focus.p - (camera_to_subject_distance_2 * new_look_vector_from_arg_2), focus.p)
                + Vector3.new(0, camera_height, 0)
        else
            focus = CFrame.new(subject_position)
            local p_2 = focus.p
            cframe = CFrame.new(
                p_2
                    - (
                        camera_to_subject_distance_2
                        * argument:CalculateNewLookVectorFromArg(look_vector, get_rotation_result)
                    ),
                p_2
            )
        end

        local camera_toggle_offset_2 = argument:GetCameraToggleOffset(difference)
        focus += camera_toggle_offset_2
        cframe += camera_toggle_offset_2
        argument.lastCameraTransform = cframe
        argument.lastCameraFocus = focus

        if not camera_subject or not (camera_subject:IsA("BasePart")) then
            argument.lastSubjectCFrame = nil
            argument.lastUpdate = time

            return cframe, focus
        end

        argument.lastSubjectCFrame = camera_subject.CFrame
    end

    argument.lastUpdate = time

    return cframe, focus
end

return classic_camera
