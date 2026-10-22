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

function classic_camera.GetCameraToggleOffset(self, argument)
    if not self.isCameraToggle then
        return (Vector3.new())
    end
    local current_subject_distance = self.currentSubjectDistance
    if camera_input.getTogglePan() then
        self.cameraToggleSpring.goal = math.clamp(
            camera_utils.map(current_subject_distance, 0.5, self.FIRST_PERSON_DISTANCE_THRESHOLD, 0, 1),
            0,
            1
        )
    else
        self.cameraToggleSpring.goal = 0
    end
    local clamped_value_offset = math.clamp(camera_utils.map(current_subject_distance, 0.5, 64, 0, 1), 0, 1) + 1
    return (Vector3.new(0, self.cameraToggleSpring:step(argument) * clamped_value_offset, 0))
end

function classic_camera.SetCameraMovementMode(self, argument)
    base_camera.SetCameraMovementMode(self, argument)
    self.isFollowCamera = argument == Enum.ComputerCameraMovementMode.Follow
    self.isCameraToggle = argument == Enum.ComputerCameraMovementMode.CameraToggle
end

function classic_camera.Update(self, argument)
    local time = tick()
    local time_offset = time - self.lastUpdate
    local current_camera = workspace.CurrentCamera
    local cframe = current_camera.CFrame
    local focus = current_camera.Focus
    local look_vector = nil
    local value = nil
    if self.resetCameraAngle then
        value = self:GetHumanoidRootPart()
        if value then
            look_vector = (value.CFrame * from_orientation_result).lookVector
        else
            look_vector = from_orientation_result.lookVector
        end
        self.resetCameraAngle = false
    end
    local local_player = players.LocalPlayer
    local humanoid = self:GetHumanoid()
    local camera_subject = current_camera.CameraSubject
    local _ = camera_subject and (camera_subject:IsA("VehicleSeat"))
    local camera_subject_2 = camera_subject and (camera_subject:IsA("SkateboardPlatform"))
    local humanoid_2 = humanoid and (humanoid:GetState() == Enum.HumanoidStateType.Climbing)
    if self.lastUpdate == nil or time_offset > 1 then
        self.lastCameraTransform = nil
    end
    local get_rotation_result = camera_input.getRotation(time_offset)
    self:StepZoom()
    local camera_height = self:GetCameraHeight()
    if get_rotation_result ~= Vector2.new() then
        number = 0
        self.lastUserPanCamera = tick()
    end
    local is_time_offset = time - self.lastUserPanCamera < 2
    local subject_position = self:GetSubjectPosition()
    if subject_position and local_player and current_camera then
        local camera_to_subject_distance = self:GetCameraToSubjectDistance()
        local camera_to_subject_distance_2 = ((camera_to_subject_distance < 0.5) and 0.5) or camera_to_subject_distance
        if not (self:GetIsMouseLocked()) or self:IsInFirstPerson() then
            local is_get_rotation_result = get_rotation_result ~= Vector2.new()
            if not is_get_rotation_result and self.lastCameraTransform then
                local is_in_first_person_result = self:IsInFirstPerson()
                if camera_subject then
                    if self.lastUpdate and humanoid and humanoid.Torso then
                        if is_in_first_person_result then
                            if self.lastSubjectCFrame and camera_subject then
                                local is_a_result = camera_subject:IsA("BasePart")
                                if is_a_result then
                                    local angle_between_xz_vectors_offset = -camera_utils.GetAngleBetweenXZVectors(
                                        self.lastSubjectCFrame.lookVector,
                                        camera_subject.CFrame.lookVector
                                    )
                                    get_rotation_result = (
                                        camera_utils.IsFinite(angle_between_xz_vectors_offset)
                                        and (get_rotation_result + Vector2.new(angle_between_xz_vectors_offset, 0))
                                    ) or get_rotation_result
                                    number = 0
                                end
                            end
                        elseif not is_time_offset then
                            local look_vector_2 = humanoid.Torso.CFrame.lookVector
                            number = math.clamp(number + (3.839724354387525 * time_offset), 0, 4.363323129985824)
                            local clamped_value = math.clamp(number * time_offset, 0, 1)
                            local is_in_first_person_result_2 = self:IsInFirstPerson()
                            if is_in_first_person_result_2 and (not self.isFollowCamera or not self.isClimbing) then
                                clamped_value = 1
                            end
                            local angle_between_xz_vectors =
                                camera_utils.GetAngleBetweenXZVectors(look_vector_2, self:GetCameraLookVector())
                            local is_finite_result = camera_utils.IsFinite(angle_between_xz_vectors)
                            if is_finite_result then
                                get_rotation_result = (
                                    (math.abs(angle_between_xz_vectors) > 1e-04)
                                    and (get_rotation_result + Vector2.new(angle_between_xz_vectors * clamped_value, 0))
                                ) or get_rotation_result
                            end
                        end
                    elseif self.isFollowCamera and not is_in_first_person_result and not is_time_offset then
                        local angle_between_xz_vectors_2 = camera_utils.GetAngleBetweenXZVectors(
                            -(self.lastCameraTransform.p - subject_position),
                            self:GetCameraLookVector()
                        )
                        local is_finite_result_2 = camera_utils.IsFinite(angle_between_xz_vectors_2)
                        if is_finite_result_2 and math.abs(angle_between_xz_vectors_2) > 1e-04 then
                            get_rotation_result = (
                                (0.4 * time_offset < math.abs(angle_between_xz_vectors_2))
                                and (get_rotation_result + Vector2.new(angle_between_xz_vectors_2, 0))
                            ) or get_rotation_result
                        end
                    end
                else
                    if
                        (camera_subject or self.isFollowCamera and humanoid_2)
                        and self.lastUpdate
                        and humanoid
                        and humanoid.Torso
                    then
                        if is_in_first_person_result then
                            if self.lastSubjectCFrame and camera_subject then
                                local is_a_result_2 = camera_subject:IsA("BasePart")
                                if is_a_result_2 then
                                    local angle_between_xz_vectors_offset_2 = -camera_utils.GetAngleBetweenXZVectors(
                                        self.lastSubjectCFrame.lookVector,
                                        camera_subject.CFrame.lookVector
                                    )
                                    get_rotation_result = (
                                        camera_utils.IsFinite(angle_between_xz_vectors_offset_2)
                                        and (get_rotation_result + Vector2.new(angle_between_xz_vectors_offset_2, 0))
                                    ) or get_rotation_result
                                    number = 0
                                end
                            end
                        elseif not is_time_offset then
                            local look_vector_3 = humanoid.Torso.CFrame.lookVector
                            number = math.clamp(number + (3.839724354387525 * time_offset), 0, 4.363323129985824)
                            local clamped_value_2 = math.clamp(number * time_offset, 0, 1)
                            local is_in_first_person_result_3 = self:IsInFirstPerson()
                            if is_in_first_person_result_3 and (not self.isFollowCamera or not self.isClimbing) then
                                clamped_value_2 = 1
                            end
                            local angle_between_xz_vectors_3 =
                                camera_utils.GetAngleBetweenXZVectors(look_vector_3, self:GetCameraLookVector())
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
                        if self.isFollowCamera then
                            local new_look_vector_from_arg =
                                self:CalculateNewLookVectorFromArg(look_vector, get_rotation_result)
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
                                        * self:CalculateNewLookVectorFromArg(look_vector, get_rotation_result)
                                    ),
                                p
                            )
                        end
                        local camera_toggle_offset = self:GetCameraToggleOffset(time_offset)
                        focus += camera_toggle_offset
                        cframe += camera_toggle_offset
                        self.lastCameraTransform = cframe
                        self.lastCameraFocus = focus
                        if not camera_subject or not (camera_subject:IsA("BasePart")) then
                            self.lastSubjectCFrame = nil
                            self.lastUpdate = time
                            return cframe, focus
                        end
                        self.lastSubjectCFrame = camera_subject.CFrame
                        self.lastUpdate = time
                        return cframe, focus
                    end
                    if self.isFollowCamera and not is_in_first_person_result and not is_time_offset then
                        local angle_between_xz_vectors_4 = camera_utils.GetAngleBetweenXZVectors(
                            -(self.lastCameraTransform.p - subject_position),
                            self:GetCameraLookVector()
                        )
                        local is_finite_result_4 = camera_utils.IsFinite(angle_between_xz_vectors_4)
                        if is_finite_result_4 and math.abs(angle_between_xz_vectors_4) > 1e-04 then
                            get_rotation_result = (
                                (0.4 * time_offset < math.abs(angle_between_xz_vectors_4))
                                and (get_rotation_result + Vector2.new(angle_between_xz_vectors_4, 0))
                            ) or get_rotation_result
                        end
                    end
                end
            end
        else
            local new_look_c_frame_from_arg = self:CalculateNewLookCFrameFromArg(look_vector, get_rotation_result)
            local mouse_lock_offset = self:GetMouseLockOffset()
            if get_user_flag_result then
                mouse_lock_offset = (humanoid and (mouse_lock_offset + humanoid.CameraOffset)) or mouse_lock_offset
            end
            local x_offset_offset_offset = (mouse_lock_offset.X * new_look_c_frame_from_arg.RightVector)
                + (mouse_lock_offset.Y * new_look_c_frame_from_arg.UpVector)
                + mouse_lock_offset.Z * new_look_c_frame_from_arg.LookVector
            subject_position = (
                camera_utils.IsFiniteVector3(x_offset_offset_offset) and (subject_position + x_offset_offset_offset)
            ) or subject_position
        end
        if self.isFollowCamera then
            local new_look_vector_from_arg_2 = self:CalculateNewLookVectorFromArg(look_vector, get_rotation_result)
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
                        * self:CalculateNewLookVectorFromArg(look_vector, get_rotation_result)
                    ),
                p_2
            )
        end
        local camera_toggle_offset_2 = self:GetCameraToggleOffset(time_offset)
        focus += camera_toggle_offset_2
        cframe += camera_toggle_offset_2
        self.lastCameraTransform = cframe
        self.lastCameraFocus = focus
        if not camera_subject or not (camera_subject:IsA("BasePart")) then
            self.lastSubjectCFrame = nil
            self.lastUpdate = time
            return cframe, focus
        end
        self.lastSubjectCFrame = camera_subject.CFrame
    end
    self.lastUpdate = time
    return cframe, focus
end

return classic_camera
