local players = game:GetService("Players")
local vr_service = game:GetService("VRService")
UserSettings():GetService("UserGameSettings")
require(script.Parent:WaitForChild("CameraInput"))
require(script.Parent:WaitForChild("CameraUtils"))
local vr_base_camera = require(script.Parent:WaitForChild("VRBaseCamera"))
local vr_camera = setmetatable({}, vr_base_camera)
vr_camera.__index = vr_camera

function vr_camera.new()
    local vr_base_camera_2 = vr_base_camera.new()
    local instance = setmetatable(vr_base_camera_2, vr_camera)
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
    local workspace_current_camera = workspace.CurrentCamera
    local c_frame2 = workspace_current_camera.CFrame
    local focus = workspace_current_camera.Focus
    local local_player = players.LocalPlayer
    argument:GetHumanoid()
    local _ = workspace_current_camera.CameraSubject

    if argument.lastUpdate == nil or argument_2 > 1 then
        argument.lastCameraTransform = nil
    end

    argument:UpdateFadeFromBlack(argument_2)
    argument:UpdateEdgeBlur(local_player, argument_2)
    local last_subject_position = argument.lastSubjectPosition
    local subject_position = argument:GetSubjectPosition()

    if argument.needsBlackout then
        argument:StartFadeFromBlack()
        local clamped_value = math.clamp(argument_2, 0.0001, 0.1)
        argument.blackOutTimer = argument.blackOutTimer + clamped_value

        if argument.blackOutTimer > 0.1 and game:IsLoaded() then
            argument.needsBlackout = false
            argument.needsReset = true
        end
    end

    if subject_position and (local_player and workspace_current_camera) then
        local vr_focus = argument:GetVRFocus(subject_position, argument_2)

        if argument:IsInFirstPerson() then
            if vr_service.AvatarGestures then
                c_frame2, focus = argument:UpdateImmersionCamera(
                    argument_2,
                    c_frame2,
                    vr_focus,
                    last_subject_position,
                    subject_position
                )
            else
                c_frame2, focus = argument:UpdateFirstPersonTransform(
                    argument_2,
                    c_frame2,
                    vr_focus,
                    last_subject_position,
                    subject_position
                )
            end
        elseif vr_service.ThirdPersonFollowCamEnabled then
            c_frame2, focus = argument:UpdateThirdPersonFollowTransform(
                argument_2,
                c_frame2,
                vr_focus,
                last_subject_position,
                subject_position
            )
        else
            c_frame2, focus = argument:UpdateThirdPersonComfortTransform(
                argument_2,
                c_frame2,
                vr_focus,
                last_subject_position,
                subject_position
            )
        end

        argument.lastCameraTransform = c_frame2
        argument.lastCameraFocus = focus
    end

    argument.lastUpdate = tick()

    return c_frame2, focus
end

function vr_camera.GetAvatarFeetWorldYValue(argument)
    local camera_subject = workspace.CurrentCamera.CameraSubject

    if not camera_subject then
        return nil
    end

    if not (camera_subject:IsA("Humanoid") and camera_subject.RootPart) then
        return nil
    end

    local root_part = camera_subject.RootPart

    return root_part.Position.Y - root_part.Size.Y / 2 - camera_subject.HipHeight
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
    local unit = Vector3.new(camera_look_vector.X, 0, camera_look_vector.Z).Unit
    local rotation = argument:getRotation(argument_2)
    local new_look_vector_from_arg = argument:CalculateNewLookVectorFromArg(unit, Vector2.new(rotation, 0))

    return CFrame.new(p - 0.5 * new_look_vector_from_arg, p), argument_4
end

function vr_camera.UpdateImmersionCamera(argument, argument_2, argument_3, argument_4, argument_5, argument_6)
    local subject_c_frame = argument:GetSubjectCFrame()
    local workspace_current_camera = workspace.CurrentCamera
    local character = players.LocalPlayer.Character
    local humanoid = argument:GetHumanoid()

    if not humanoid then
        return workspace_current_camera.CFrame, workspace_current_camera.Focus
    end

    local humanoid_root_part = character:FindFirstChild("HumanoidRootPart")

    if not humanoid_root_part then
        return workspace_current_camera.CFrame, workspace_current_camera.Focus
    end

    argument.characterOrientation = humanoid_root_part:FindFirstChild("CharacterAlignOrientation")

    if not argument.characterOrientation then
        local root_attachment = humanoid_root_part:FindFirstChild("RootAttachment")

        if not root_attachment then
            return
        end

        argument.characterOrientation = Instance.new("AlignOrientation")
        argument.characterOrientation.Name = "CharacterAlignOrientation"
        argument.characterOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
        argument.characterOrientation.Attachment0 = root_attachment
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
    elseif humanoid.Sit then
        if (subject_c_frame.Position - workspace_current_camera.CFrame.Position).Magnitude > 0.01 then
            argument:StartVREdgeBlur(players.LocalPlayer)
        end
    else
        local estimated_vr_torso_frame = argument.controlModule:GetEstimatedVRTorsoFrame()
        argument.characterOrientation.CFrame = workspace_current_camera.CFrame * estimated_vr_torso_frame

        if argument.controlModule.inputMoveVector.Magnitude > 0 then
            argument.motionDetTime = 0.1
        end

        if argument.controlModule.inputMoveVector.Magnitude > 0 or argument.motionDetTime > 0 then
            argument.motionDetTime = argument.motionDetTime - argument_2
            argument:StartVREdgeBlur(players.LocalPlayer)
            local user_c_frame = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
            local humanoid_root_part2 = character.HumanoidRootPart
            local product = workspace_current_camera.CFrame
                * (user_c_frame.Rotation + user_c_frame.Position * workspace_current_camera.HeadScale)
                * CFrame.new(0, -0.7 * humanoid_root_part2.Size.Y / 2, 0)
            local look_vector = humanoid_root_part2.CFrame.LookVector
            local sum = argument_6
                - (product - Vector3.new(look_vector.X, 0, look_vector.Z).Unit * humanoid_root_part2.Size.Y * 0.125).Position
                + workspace_current_camera.CFrame.Position
            local vector = Vector3.new(sum.X, argument_6.Y, sum.Z)
            subject_c_frame = workspace_current_camera.CFrame.Rotation + vector
        else
            subject_c_frame = workspace_current_camera.CFrame.Rotation
                + Vector3.new(
                    workspace_current_camera.CFrame.Position.X,
                    argument_6.Y,
                    workspace_current_camera.CFrame.Position.Z
                )
        end

        local rotation = argument:getRotation(argument_2)

        if math.abs(rotation) > 0 then
            local user_c_frame_2 = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
            local sum_2 = user_c_frame_2.Rotation + user_c_frame_2.Position * workspace_current_camera.HeadScale
            local product_2 = subject_c_frame * sum_2
            subject_c_frame = CFrame.new(product_2.Position)
                * CFrame.Angles(0, -math.rad(rotation * 90), 0)
                * product_2.Rotation
                * sum_2:Inverse()
        end
    end

    return subject_c_frame, subject_c_frame * CFrame.new(0, 0, -0.5)
end

function vr_camera.UpdateThirdPersonComfortTransform(
    argument,
    argument_2,
    product,
    argument_3,
    argument_4,
    last_camera_reset_position
)
    local camera_to_subject_distance = argument:GetCameraToSubjectDistance()
    local camera_to_subject_distance_2 = camera_to_subject_distance < 0.5 and 0.5 or camera_to_subject_distance

    if argument_4 ~= nil and argument.lastCameraFocus ~= nil then
        local _ = players.LocalPlayer
        local move_vector = argument.controlModule:GetMoveVector()
        local condition = (argument_4 - last_camera_reset_position).magnitude > 0.01 and true
            or move_vector.magnitude > 0.01

        if condition then
            argument.motionDetTime = 0.1
        end

        argument.motionDetTime = argument.motionDetTime - argument_2

        if (argument.motionDetTime > 0 and true or condition) and not argument.needsReset then
            local last_camera_focus = argument.lastCameraFocus
            argument.VRCameraFocusFrozen = true

            return product, last_camera_focus
        end

        local condition_2 = argument.lastCameraResetPosition == nil and true
            or (last_camera_reset_position - argument.lastCameraResetPosition).Magnitude > 1
        local rotation = argument:getRotation(argument_2)

        if math.abs(rotation) > 0 then
            local relative_cframe = argument_3:ToObjectSpace(product)
            product = argument_3 * CFrame.Angles(0, -rotation, 0) * relative_cframe
        end

        if argument.VRCameraFocusFrozen and condition_2 or argument.needsReset then
            vr_service:RecenterUserHeadCFrame()
            argument.VRCameraFocusFrozen = false
            argument.needsReset = false
            argument.lastCameraResetPosition = last_camera_reset_position
            argument:ResetZoom()
            argument:StartFadeFromBlack()
            local humanoid = argument:GetHumanoid()
            local look_vector = humanoid.Torso and humanoid.Torso.CFrame.lookVector or Vector3.new(1, 0, 0)
            local vector = Vector3.new(look_vector.X, 0, look_vector.Z)
            local difference = argument_3.Position - vector * camera_to_subject_distance_2
            local vector_2 = Vector3.new(argument_3.Position.X, difference.Y, argument_3.Position.Z)
            product = CFrame.new(difference, vector_2)
        end
    end

    return product, argument_3
end

function vr_camera.UpdateThirdPersonFollowTransform(
    argument,
    argument_2,
    argument_3,
    argument_4,
    argument_5,
    argument_6
)
    local workspace_current_camera = workspace.CurrentCamera
    local camera_to_subject_distance = argument:GetCameraToSubjectDistance()
    local vr_focus = argument:GetVRFocus(argument_6, argument_2)

    if argument.needsReset then
        argument.needsReset = false
        vr_service:RecenterUserHeadCFrame()
        argument:ResetZoom()
        argument:StartFadeFromBlack()
    end

    if argument.recentered then
        local subject_c_frame = argument:GetSubjectCFrame()

        if not subject_c_frame then
            return workspace_current_camera.CFrame, workspace_current_camera.Focus
        end

        local product = vr_focus * subject_c_frame.Rotation * CFrame.new(0, 0, camera_to_subject_distance)
        argument.focusOffset = vr_focus:ToObjectSpace(product)
        argument.recentered = false

        return product, vr_focus
    end

    local world_cframe = vr_focus:ToWorldSpace(argument.focusOffset)
    local _ = players.LocalPlayer
    local control_module = argument.controlModule
    local move_vector = control_module:GetMoveVector()

    if (argument_5 - argument_6).magnitude > 0.01 or move_vector.magnitude > 0 then
        local estimated_vr_torso_frame = control_module:GetEstimatedVRTorsoFrame()
        local product_2 = workspace_current_camera.CFrame
            * (
                estimated_vr_torso_frame.Rotation
                + estimated_vr_torso_frame.Position * workspace_current_camera.HeadScale
            )
        local look_vector = product_2.LookVector
        local product_3 = Vector3.new(look_vector.X, 0, look_vector.Z).Unit * camera_to_subject_distance
        world_cframe = world_cframe:Lerp(
            CFrame.new(workspace_current_camera.CFrame.Position + (vr_focus.Position - product_3) - product_2.Position)
                * world_cframe.Rotation,
            0.01
        )
    end

    local rotation = argument:getRotation(argument_2)

    if math.abs(rotation) > 0 then
        local relative_cframe = vr_focus:ToObjectSpace(world_cframe)
        world_cframe = vr_focus * CFrame.Angles(0, -rotation, 0) * relative_cframe
    end

    argument.focusOffset = vr_focus:ToObjectSpace(world_cframe)
    local product_4 = world_cframe * CFrame.new(0, 0, -camera_to_subject_distance)

    if (product_4.Position - workspace_current_camera.Focus.Position).Magnitude > 0.01 then
        argument:StartVREdgeBlur(players.LocalPlayer)
    end

    return world_cframe, product_4
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

    if humanoid then
        humanoid.AutoRotate = argument.savedAutoRotate
    end
end

return vr_camera
