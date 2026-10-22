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

function vr_camera.Reset(argument)
    argument.needsReset = true
    argument.needsBlackout = true
    argument.motionDetTime = 0
    argument.blackOutTimer = 0
    argument.lastCameraResetPosition = nil
    vr_base_camera.Reset(argument)
end

function vr_camera.Update(argument, argument_2)
    local current_camera = workspace.CurrentCamera
    local cframe = current_camera.CFrame
    local focus = current_camera.Focus
    local local_player = players.LocalPlayer
    local _ = argument:GetHumanoid()

    if argument.lastUpdate == nil or argument_2 > 1 then
        argument.lastCameraTransform = nil
    end

    argument:UpdateFadeFromBlack(argument_2)
    argument:UpdateEdgeBlur(local_player, argument_2)
    local last_subject_position = argument.lastSubjectPosition
    local subject_position = argument:GetSubjectPosition()

    if argument.needsBlackout then
        argument:StartFadeFromBlack()
        argument.blackOutTimer = argument.blackOutTimer + math.clamp(argument_2, 1e-04, 0.1)

        if argument.blackOutTimer > 0.1 and game:IsLoaded() then
            argument.needsBlackout = false
            argument.needsReset = true
        end
    end

    if subject_position and local_player and current_camera then
        focus = argument:GetVRFocus(subject_position, argument_2)

        if argument:IsInFirstPerson() then
            if vr_service.AvatarGestures then
                local update_immersion_camera_result, value =
                    argument:UpdateImmersionCamera(argument_2, cframe, focus, last_subject_position, subject_position)
                cframe, focus = update_immersion_camera_result, value
            else
                local update_first_person_transform_result, value_2 = argument:UpdateFirstPersonTransform(
                    argument_2,
                    cframe,
                    focus,
                    last_subject_position,
                    subject_position
                )
                cframe, focus = update_first_person_transform_result, value_2
            end
        elseif vr_service.ThirdPersonFollowCamEnabled then
            local update_third_person_follow_transform_result, value_3 = argument:UpdateThirdPersonFollowTransform(
                argument_2,
                cframe,
                focus,
                last_subject_position,
                subject_position
            )
            cframe, focus = update_third_person_follow_transform_result, value_3
        else
            local update_third_person_comfort_transform_result, value_4 = argument:UpdateThirdPersonComfortTransform(
                argument_2,
                cframe,
                focus,
                last_subject_position,
                subject_position
            )
            cframe, focus = update_third_person_comfort_transform_result, value_4
        end

        argument.lastCameraTransform = cframe
        argument.lastCameraFocus = focus
    end

    argument.lastUpdate = tick()

    return cframe, focus
end

function vr_camera.GetAvatarFeetWorldYValue(argument)
    local camera_subject = workspace.CurrentCamera.CameraSubject

    if not camera_subject or not camera_subject:IsA("Humanoid") or not camera_subject.RootPart then
        return nil
    end

    local root_part = camera_subject.RootPart

    return (root_part.Position.Y - (root_part.Size.Y / 2)) - camera_subject.HipHeight
end

function vr_camera.UpdateFirstPersonTransform(argument, argument_2, argument_3, argument_4, argument_5, argument_6)
    if argument.needsReset then
        argument:StartFadeFromBlack()
        argument.needsReset = false
    end

    local local_player = players.LocalPlayer

    if (argument_5 - argument_6).magnitude > 0.01 then
        argument:StartVREdgeBlur(local_player)
    end

    local p = argument_4.p
    local camera_look_vector = argument:GetCameraLookVector()

    return CFrame.new(
        p
            - (
                0.5
                * argument:CalculateNewLookVectorFromArg(
                    Vector3.new(camera_look_vector.X, 0, camera_look_vector.Z).Unit,
                    Vector2.new(argument:getRotation(argument_2), 0)
                )
            ),
        p
    ),
        argument_4
end

function vr_camera.UpdateImmersionCamera(argument, argument_2, subject_c_frame, argument_3, argument_4, argument_5)
    local subject_c_frame_2 = argument:GetSubjectCFrame()
    local current_camera = workspace.CurrentCamera
    local character = players.LocalPlayer.Character
    local humanoid = argument:GetHumanoid()

    if not humanoid then
        return current_camera.CFrame, current_camera.Focus
    end

    local humanoid_root_part = character:FindFirstChild("HumanoidRootPart")

    if not humanoid_root_part then
        return current_camera.CFrame, current_camera.Focus
    end

    argument.characterOrientation = humanoid_root_part:FindFirstChild("CharacterAlignOrientation")
    local attachment0 = nil

    if not argument.characterOrientation then
        attachment0 = humanoid_root_part:FindFirstChild("RootAttachment")

        if not attachment0 then
            return
        end

        argument.characterOrientation = Instance.new("AlignOrientation")
        argument.characterOrientation.Name = "CharacterAlignOrientation"
        argument.characterOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
        argument.characterOrientation.Attachment0 = attachment0
        argument.characterOrientation.RigidityEnabled = true
        argument.characterOrientation.Parent = humanoid_root_part
    end

    if argument.characterOrientation.Enabled == false then
        argument.characterOrientation.Enabled = true
    end

    if argument.needsReset then
        argument.needsReset = false
        argument.savedAutoRotate = humanoid.AutoRotate
        humanoid.AutoRotate = false

        if argument.NoRecenter then
            argument.NoRecenter = false
            vr_service:RecenterUserHeadCFrame()
        end

        argument:StartFadeFromBlack()
        subject_c_frame = subject_c_frame_2
    else
        local value = nil

        if humanoid.Sit then
            if (subject_c_frame_2.Position - current_camera.CFrame.Position).Magnitude > 0.01 then
                argument:StartVREdgeBlur(players.LocalPlayer)
            end

            subject_c_frame = subject_c_frame_2
        else
            argument.characterOrientation.CFrame = current_camera.CFrame
                * argument.controlModule:GetEstimatedVRTorsoFrame()

            if argument.controlModule.inputMoveVector.Magnitude > 0 then
                argument.motionDetTime = 0.1
            end

            if argument.controlModule.inputMoveVector.Magnitude > 0 or argument.motionDetTime > 0 then
                argument.motionDetTime = argument.motionDetTime - argument_2
                argument:StartVREdgeBlur(players.LocalPlayer)
                local user_c_frame = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
                local humanoid_root_part_2 = character.HumanoidRootPart
                local product = current_camera.CFrame
                    * (user_c_frame.Rotation + (user_c_frame.Position * current_camera.HeadScale))
                    * CFrame.new(0, (-0.7 * humanoid_root_part_2.Size.Y) / 2, 0)
                local look_vector = humanoid_root_part_2.CFrame.LookVector
                local sum = argument_5
                    - (
                        product
                        - ((Vector3.new(look_vector.X, 0, look_vector.Z).Unit * humanoid_root_part_2.Size.Y) * 0.125)
                    ).Position
                    + current_camera.CFrame.Position
                subject_c_frame = current_camera.CFrame.Rotation + Vector3.new(sum.X, argument_5.Y, sum.Z)
            else
                subject_c_frame = current_camera.CFrame.Rotation
                    + Vector3.new(current_camera.CFrame.Position.X, argument_5.Y, current_camera.CFrame.Position.Z)
            end

            value = argument:getRotation(argument_2)

            if math.abs(value) > 0 then
                local user_c_frame_2 = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
                local sum_2 = user_c_frame_2.Rotation + user_c_frame_2.Position * current_camera.HeadScale
                local product_2 = subject_c_frame * sum_2
                subject_c_frame = CFrame.new(product_2.Position)
                    * CFrame.Angles(0, -math.rad(value * 90), 0)
                    * product_2.Rotation
                    * sum_2:Inverse()
            end
        end
    end

    return subject_c_frame, subject_c_frame * CFrame.new(0, 0, -0.5)
end

function vr_camera.UpdateThirdPersonComfortTransform(
    argument,
    argument_2,
    product,
    last_camera_focus,
    argument_3,
    last_camera_reset_position
)
    local camera_to_subject_distance = argument:GetCameraToSubjectDistance()
    local camera_to_subject_distance_2 = ((camera_to_subject_distance < 0.5) and 0.5) or camera_to_subject_distance

    if argument_3 ~= nil then
        local value, value_2 = nil, nil

        if argument.lastCameraFocus ~= nil then
            local move_vector = argument.controlModule:GetMoveVector()
            local enabled = true

            if not ((argument_3 - last_camera_reset_position).magnitude > 0.01) then
                enabled = move_vector.magnitude > 0.01
            end

            if enabled then
                argument.motionDetTime = 0.1
            end

            argument.motionDetTime = argument.motionDetTime - argument_2

            if (((argument.motionDetTime > 0) and true) or enabled) and not argument.needsReset then
                last_camera_focus = argument.lastCameraFocus
                argument.VRCameraFocusFrozen = true

                return product, last_camera_focus
            end

            move_vector = true

            if argument.lastCameraResetPosition ~= nil then
                move_vector = (last_camera_reset_position - argument.lastCameraResetPosition).Magnitude > 1
            end

            value = argument:getRotation(argument_2)

            if math.abs(value) > 0 then
                local relative_cframe = last_camera_focus:ToObjectSpace(product)
                product = last_camera_focus * CFrame.Angles(0, -value, 0) * relative_cframe
            end

            if argument.VRCameraFocusFrozen and move_vector or argument.needsReset then
                vr_service:RecenterUserHeadCFrame()
                argument.VRCameraFocusFrozen = false
                argument.needsReset = false
                argument.lastCameraResetPosition = last_camera_reset_position
                argument:ResetZoom()
                argument:StartFadeFromBlack()
                value_2 = argument:GetHumanoid()
                local look_vector = value_2.Torso and value_2.Torso.CFrame.lookVector or Vector3.new(1, 0, 0)
                local difference = last_camera_focus.Position
                    - Vector3.new(look_vector.X, 0, look_vector.Z) * camera_to_subject_distance_2
                product = CFrame.new(
                    difference,
                    Vector3.new(last_camera_focus.Position.X, difference.Y, last_camera_focus.Position.Z)
                )
            end
        end
    end

    return product, last_camera_focus
end

function vr_camera.UpdateThirdPersonFollowTransform(
    argument,
    argument_2,
    interpolated_value,
    argument_3,
    argument_4,
    argument_5
)
    local current_camera = workspace.CurrentCamera
    local camera_to_subject_distance = argument:GetCameraToSubjectDistance()
    local vr_focus = argument:GetVRFocus(argument_5, argument_2)

    if argument.needsReset then
        argument.needsReset = false
        vr_service:RecenterUserHeadCFrame()
        argument:ResetZoom()
        argument:StartFadeFromBlack()
    end

    local value, value_2, value_3 = nil, nil, nil

    if argument.recentered then
        value = argument:GetSubjectCFrame()

        if not value then
            return current_camera.CFrame, current_camera.Focus
        end

        local product = vr_focus * value.Rotation * CFrame.new(0, 0, camera_to_subject_distance)
        argument.focusOffset = vr_focus:ToObjectSpace(product)
        argument.recentered = false

        return product, vr_focus
    end

    local world_cframe = vr_focus:ToWorldSpace(argument.focusOffset)
    local control_module = argument.controlModule
    local move_vector = control_module:GetMoveVector()

    if (argument_4 - argument_5).magnitude > 0.01 or move_vector.magnitude > 0 then
        local estimated_vr_torso_frame = control_module:GetEstimatedVRTorsoFrame()
        local product_2 = current_camera.CFrame
            * (estimated_vr_torso_frame.Rotation + (estimated_vr_torso_frame.Position * current_camera.HeadScale))
        local look_vector = product_2.LookVector
        interpolated_value = world_cframe:Lerp(
            CFrame.new(
                (
                    current_camera.CFrame.Position
                    + (
                        vr_focus.Position
                        - Vector3.new(look_vector.X, 0, look_vector.Z).Unit * camera_to_subject_distance
                    )
                ) - product_2.Position
            ) * world_cframe.Rotation,
            0.01
        )
    else
        interpolated_value = world_cframe
    end

    value_2 = argument:getRotation(argument_2)

    if math.abs(value_2) > 0 then
        control_module = vr_focus:ToObjectSpace(interpolated_value)
        interpolated_value = vr_focus * CFrame.Angles(0, -value_2, 0) * control_module
    end

    argument.focusOffset = vr_focus:ToObjectSpace(interpolated_value)
    value_3 = interpolated_value * CFrame.new(0, 0, -camera_to_subject_distance)

    if (value_3.Position - current_camera.Focus.Position).Magnitude > 0.01 then
        argument:StartVREdgeBlur(players.LocalPlayer)
    end

    return interpolated_value, value_3
end

function vr_camera.LeaveFirstPerson(argument)
    vr_base_camera.LeaveFirstPerson(argument)
    argument.needsReset = true

    if argument.VRBlur then
        argument.VRBlur.Visible = false
    end

    if argument.characterOrientation then
        argument.characterOrientation.Enabled = false
    end

    local humanoid = argument:GetHumanoid()

    if not humanoid then
        return
    end

    humanoid.AutoRotate = argument.savedAutoRotate
end

return vr_camera
