local players = game:GetService("Players")
local vr_service = game:GetService("VRService")
local _ = UserSettings():GetService("UserGameSettings")
local camera_input = require(script.Parent:WaitForChild("CameraInput"))
local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
local vr_base_camera = require(script.Parent:WaitForChild("VRBaseCamera"))
local vr_camera = setmetatable({}, vr_base_camera)
vr_camera.__index = vr_camera

function vr_camera.new()
    local instance = setmetatable(vr_base_camera.new(), vr_camera)
    instance.lastUpdate = tick()
    instance.focusOffset = CFrame.new()
    instance:Reset()
    instance.controlModule =
        require(players.LocalPlayer:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"))
    instance.savedAutoRotate = true
    return instance
end

function vr_camera.Reset(self)
    self.needsReset = true
    self.needsBlackout = true
    self.motionDetTime = 0
    self.blackOutTimer = 0
    self.lastCameraResetPosition = nil
    vr_base_camera.Reset(self)
end

function vr_camera.Update(self, argument)
    local current_camera = workspace.CurrentCamera
    local cframe = current_camera.CFrame
    local focus = current_camera.Focus
    local local_player = players.LocalPlayer
    local _ = self:GetHumanoid()
    if self.lastUpdate == nil or argument > 1 then
        self.lastCameraTransform = nil
    end
    self:UpdateFadeFromBlack(argument)
    self:UpdateEdgeBlur(local_player, argument)
    local last_subject_position = self.lastSubjectPosition
    local subject_position = self:GetSubjectPosition()
    if self.needsBlackout then
        self:StartFadeFromBlack()
        self.blackOutTimer = self.blackOutTimer + math.clamp(argument, 1e-04, 0.1)
        if self.blackOutTimer > 0.1 and game:IsLoaded() then
            self.needsBlackout = false
            self.needsReset = true
        end
    end
    if subject_position and local_player and current_camera then
        focus = self:GetVRFocus(subject_position, argument)
        if self:IsInFirstPerson() then
            if vr_service.AvatarGestures then
                local update_immersion_camera_result, value =
                    self:UpdateImmersionCamera(argument, cframe, focus, last_subject_position, subject_position)
                cframe, focus = update_immersion_camera_result, value
            else
                local update_first_person_transform_result, value_2 =
                    self:UpdateFirstPersonTransform(argument, cframe, focus, last_subject_position, subject_position)
                cframe, focus = update_first_person_transform_result, value_2
            end
        elseif vr_service.ThirdPersonFollowCamEnabled then
            local update_third_person_follow_transform_result, value_3 =
                self:UpdateThirdPersonFollowTransform(argument, cframe, focus, last_subject_position, subject_position)
            cframe, focus = update_third_person_follow_transform_result, value_3
        else
            local update_third_person_comfort_transform_result, value_4 =
                self:UpdateThirdPersonComfortTransform(argument, cframe, focus, last_subject_position, subject_position)
            cframe, focus = update_third_person_comfort_transform_result, value_4
        end
        self.lastCameraTransform = cframe
        self.lastCameraFocus = focus
    end
    self.lastUpdate = tick()
    return cframe, focus
end

function vr_camera.GetAvatarFeetWorldYValue(self)
    local camera_subject = workspace.CurrentCamera.CameraSubject
    if not camera_subject or not camera_subject:IsA("Humanoid") or not camera_subject.RootPart then
        return nil
    end
    local root_part = camera_subject.RootPart
    return (root_part.Position.Y - (root_part.Size.Y / 2)) - camera_subject.HipHeight
end

function vr_camera.UpdateFirstPersonTransform(self, argument, argument_2, argument_3, argument_4, argument_5)
    if self.needsReset then
        self:StartFadeFromBlack()
        self.needsReset = false
    end
    local local_player = players.LocalPlayer
    if (argument_4 - argument_5).magnitude > 0.01 then
        self:StartVREdgeBlur(local_player)
    end
    local p = argument_3.p
    local camera_look_vector = self:GetCameraLookVector()
    return CFrame.new(
        p
            - (
                0.5
                * self:CalculateNewLookVectorFromArg(
                    Vector3.new(camera_look_vector.X, 0, camera_look_vector.Z).Unit,
                    Vector2.new(self:getRotation(argument), 0)
                )
            ),
        p
    ),
        argument_3
end

function vr_camera.UpdateImmersionCamera(self, argument, subject_c_frame, argument_2, argument_3, argument_4)
    local subject_c_frame_2 = self:GetSubjectCFrame()
    local current_camera = workspace.CurrentCamera
    local character = players.LocalPlayer.Character
    local humanoid = self:GetHumanoid()
    if not humanoid then
        return current_camera.CFrame, current_camera.Focus
    end
    local humanoid_root_part = character:FindFirstChild("HumanoidRootPart")
    if humanoid_root_part then
        self.characterOrientation = humanoid_root_part:FindFirstChild("CharacterAlignOrientation")
        local attachment0 = nil
        if not self.characterOrientation then
            attachment0 = humanoid_root_part:FindFirstChild("RootAttachment")
            if not attachment0 then
                return
            end
            self.characterOrientation = Instance.new("AlignOrientation")
            self.characterOrientation.Name = "CharacterAlignOrientation"
            self.characterOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
            self.characterOrientation.Attachment0 = attachment0
            self.characterOrientation.RigidityEnabled = true
            self.characterOrientation.Parent = humanoid_root_part
        end
        if self.characterOrientation.Enabled == false then
            self.characterOrientation.Enabled = true
        end
        if self.needsReset then
            self.needsReset = false
            self.savedAutoRotate = humanoid.AutoRotate
            humanoid.AutoRotate = false
            if self.NoRecenter then
                self.NoRecenter = false
                vr_service:RecenterUserHeadCFrame()
            end
            self:StartFadeFromBlack()
            subject_c_frame = subject_c_frame_2
        else
            local value = nil
            if humanoid.Sit then
                if (subject_c_frame_2.Position - current_camera.CFrame.Position).Magnitude > 0.01 then
                    self:StartVREdgeBlur(players.LocalPlayer)
                end
                subject_c_frame = subject_c_frame_2
            else
                self.characterOrientation.CFrame = current_camera.CFrame * self.controlModule:GetEstimatedVRTorsoFrame()
                if self.controlModule.inputMoveVector.Magnitude > 0 then
                    self.motionDetTime = 0.1
                end
                if self.controlModule.inputMoveVector.Magnitude > 0 or self.motionDetTime > 0 then
                    self.motionDetTime = self.motionDetTime - argument
                    self:StartVREdgeBlur(players.LocalPlayer)
                    local user_c_frame = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
                    local humanoid_root_part_2 = character.HumanoidRootPart
                    local cframe_offset_offset = current_camera.CFrame
                        * (user_c_frame.Rotation + (user_c_frame.Position * current_camera.HeadScale))
                        * CFrame.new(0, (-0.7 * humanoid_root_part_2.Size.Y) / 2, 0)
                    local look_vector = humanoid_root_part_2.CFrame.LookVector
                    local argument_offset_offset = argument_4
                        - (
                            cframe_offset_offset
                            - (
                                (Vector3.new(look_vector.X, 0, look_vector.Z).Unit * humanoid_root_part_2.Size.Y)
                                * 0.125
                            )
                        ).Position
                        + current_camera.CFrame.Position
                    subject_c_frame = current_camera.CFrame.Rotation
                        + Vector3.new(argument_offset_offset.X, argument_4.Y, argument_offset_offset.Z)
                else
                    subject_c_frame = current_camera.CFrame.Rotation
                        + Vector3.new(current_camera.CFrame.Position.X, argument_4.Y, current_camera.CFrame.Position.Z)
                end
                value = self:getRotation(argument)
                if math.abs(value) > 0 then
                    local user_c_frame_2 = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
                    local rotation_offset = user_c_frame_2.Rotation + user_c_frame_2.Position * current_camera.HeadScale
                    local subject_c_frame_offset = subject_c_frame * rotation_offset
                    subject_c_frame = CFrame.new(subject_c_frame_offset.Position)
                        * CFrame.Angles(0, -math.rad(value * 90), 0)
                        * subject_c_frame_offset.Rotation
                        * rotation_offset:Inverse()
                end
            end
        end
        return subject_c_frame, subject_c_frame * CFrame.new(0, 0, -0.5)
    end
    return current_camera.CFrame, current_camera.Focus
end

function vr_camera.UpdateThirdPersonComfortTransform(
    self,
    argument,
    last_camera_focus_offset_offset,
    last_camera_focus,
    argument_2,
    last_camera_reset_position
)
    local camera_to_subject_distance = self:GetCameraToSubjectDistance()
    local camera_to_subject_distance_2 = ((camera_to_subject_distance < 0.5) and 0.5) or camera_to_subject_distance
    if argument_2 ~= nil then
        local value = nil
        if self.lastCameraFocus ~= nil then
            local move_vector = self.controlModule:GetMoveVector()
            local enabled = true
            if not ((argument_2 - last_camera_reset_position).magnitude > 0.01) then
                enabled = move_vector.magnitude > 0.01
            end
            if enabled then
                self.motionDetTime = 0.1
            end
            self.motionDetTime = self.motionDetTime - argument
            if (((self.motionDetTime > 0) and true) or enabled) and not self.needsReset then
                last_camera_focus = self.lastCameraFocus
                self.VRCameraFocusFrozen = true
                return last_camera_focus_offset_offset, last_camera_focus
            end
            local enabled_2 = true
            if self.lastCameraResetPosition ~= nil then
                enabled_2 = (last_camera_reset_position - self.lastCameraResetPosition).Magnitude > 1
            end
            value = self:getRotation(argument)
            if math.abs(value) > 0 then
                local relative_cframe = last_camera_focus:ToObjectSpace(last_camera_focus_offset_offset)
                last_camera_focus_offset_offset = last_camera_focus * CFrame.Angles(0, -value, 0) * relative_cframe
            end
            if self.VRCameraFocusFrozen and enabled_2 or self.needsReset then
                vr_service:RecenterUserHeadCFrame()
                self.VRCameraFocusFrozen = false
                self.needsReset = false
                self.lastCameraResetPosition = last_camera_reset_position
                self:ResetZoom()
                self:StartFadeFromBlack()
                local humanoid = self:GetHumanoid()
                local torso = (humanoid.Torso and humanoid.Torso.CFrame.lookVector) or Vector3.new(1, 0, 0)
                local position_offset = last_camera_focus.Position
                    - Vector3.new(torso.X, 0, torso.Z) * camera_to_subject_distance_2
                last_camera_focus_offset_offset = CFrame.new(
                    position_offset,
                    Vector3.new(last_camera_focus.Position.X, position_offset.Y, last_camera_focus.Position.Z)
                )
            end
        end
    end
    return last_camera_focus_offset_offset, last_camera_focus
end

function vr_camera.UpdateThirdPersonFollowTransform(
    self,
    argument,
    interpolated_value,
    argument_2,
    argument_3,
    argument_4
)
    local current_camera = workspace.CurrentCamera
    local camera_to_subject_distance = self:GetCameraToSubjectDistance()
    local vr_focus = self:GetVRFocus(argument_4, argument)
    if self.needsReset then
        self.needsReset = false
        vr_service:RecenterUserHeadCFrame()
        self:ResetZoom()
        self:StartFadeFromBlack()
    end
    local value, value_2, value_3 = nil, nil, nil
    if self.recentered then
        value = self:GetSubjectCFrame()
        if not value then
            return current_camera.CFrame, current_camera.Focus
        end
        local vr_focus_offset_offset = vr_focus * value.Rotation * CFrame.new(0, 0, camera_to_subject_distance)
        self.focusOffset = vr_focus:ToObjectSpace(vr_focus_offset_offset)
        self.recentered = false
        return vr_focus_offset_offset, vr_focus
    else
        local world_cframe = vr_focus:ToWorldSpace(self.focusOffset)
        local control_module = self.controlModule
        local move_vector = control_module:GetMoveVector()
        if (argument_3 - argument_4).magnitude > 0.01 or move_vector.magnitude > 0 then
            value_2 = control_module:GetEstimatedVRTorsoFrame()
            local cframe_offset = current_camera.CFrame
                * (value_2.Rotation + (value_2.Position * current_camera.HeadScale))
            local look_vector = cframe_offset.LookVector
            interpolated_value = world_cframe:Lerp(
                CFrame.new(
                    (
                        current_camera.CFrame.Position
                        + (
                            vr_focus.Position
                            - Vector3.new(look_vector.X, 0, look_vector.Z).Unit * camera_to_subject_distance
                        )
                    ) - cframe_offset.Position
                ) * world_cframe.Rotation,
                0.01
            )
        else
            interpolated_value = world_cframe
        end
        value_2 = self:getRotation(argument)
        if math.abs(value_2) > 0 then
            local relative_cframe = vr_focus:ToObjectSpace(interpolated_value)
            interpolated_value = vr_focus * CFrame.Angles(0, -value_2, 0) * relative_cframe
        end
        self.focusOffset = vr_focus:ToObjectSpace(interpolated_value)
        value_3 = interpolated_value * CFrame.new(0, 0, -camera_to_subject_distance)
        if (value_3.Position - current_camera.Focus.Position).Magnitude > 0.01 then
            self:StartVREdgeBlur(players.LocalPlayer)
        end
        return interpolated_value, value_3
    end
end

function vr_camera.LeaveFirstPerson(self)
    vr_base_camera.LeaveFirstPerson(self)
    self.needsReset = true
    if self.VRBlur then
        self.VRBlur.Visible = false
    end
    if self.characterOrientation then
        self.characterOrientation.Enabled = false
    end
    local humanoid = self:GetHumanoid()
    if not humanoid then
        return
    end
    humanoid.AutoRotate = self.savedAutoRotate
end

return vr_camera
