local success, value = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserVRVehicleCamera2")
end)
local value_2 = success and value
local vr_service = game:GetService("VRService")
local local_player = game:GetService("Players").LocalPlayer
local lighting = game:GetService("Lighting")
local run_service = game:GetService("RunService")
local user_game_settings = UserSettings():GetService("UserGameSettings")
local camera_input = require(script.Parent:WaitForChild("CameraInput"))
local zoom_controller = require(script.Parent:WaitForChild("ZoomController"))
local get_user_flag_result =
    require(script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")).getUserFlag("UserCameraInputDt")
local base_camera = require(script.Parent:WaitForChild("BaseCamera"))
local vr_base_camera = setmetatable({}, base_camera)
vr_base_camera.__index = vr_base_camera

function vr_base_camera.new()
    local instance = setmetatable(base_camera.new(), vr_base_camera)
    instance.gamepadZoomLevels = { 0, 7 }
    instance.headScale = 1
    instance:SetCameraToSubjectDistance(7)
    instance.VRFadeResetTimer = 0
    instance.VREdgeBlurTimer = 0
    instance.gamepadResetConnection = nil
    instance.needsReset = true
    instance.recentered = false
    instance:Reset()

    return instance
end

function vr_base_camera.Reset(argument)
    argument.stepRotateTimeout = 0
end

function vr_base_camera.GetModuleName(argument)
    return "VRBaseCamera"
end

function vr_base_camera.GamepadZoomPress(argument)
    base_camera.GamepadZoomPress(argument)
    argument:GamepadReset()
    argument:ResetZoom()
end

function vr_base_camera.GamepadReset(argument)
    argument.stepRotateTimeout = 0
    argument.needsReset = true
end

function vr_base_camera.ResetZoom(argument)
    zoom_controller.SetZoomParameters(argument.currentSubjectDistance, 0)
    zoom_controller.ReleaseSpring()
end

function vr_base_camera.OnEnabledChanged(argument)
    base_camera.OnEnabledChanged(argument)

    if argument.enabled then
        argument.gamepadResetConnection = camera_input.gamepadReset:Connect(function()
            argument:GamepadReset()
        end)
        argument.thirdPersonOptionChanged = vr_service
            :GetPropertyChangedSignal("ThirdPersonFollowCamEnabled")
            :Connect(function()
                if value_2 or not (argument:IsInFirstPerson()) then
                    argument:Reset()
                end
            end)
        argument.vrRecentered = vr_service.UserCFrameChanged:Connect(function(argument_2, argument_3)
            if argument_2 ~= Enum.UserCFrame.Floor then
                return
            end

            argument.recentered = true
        end)
    else
        if argument.inFirstPerson then
            argument:GamepadZoomPress()
        end

        if argument.thirdPersonOptionChanged then
            argument.thirdPersonOptionChanged:Disconnect()
            argument.thirdPersonOptionChanged = nil
        end

        if argument.vrRecentered then
            argument.vrRecentered:Disconnect()
            argument.vrRecentered = nil
        end

        if argument.cameraHeadScaleChangedConn then
            argument.cameraHeadScaleChangedConn:Disconnect()
            argument.cameraHeadScaleChangedConn = nil
        end

        if argument.gamepadResetConnection then
            argument.gamepadResetConnection:Disconnect()
            argument.gamepadResetConnection = nil
        end

        argument.VREdgeBlurTimer = 0
        argument:UpdateEdgeBlur(local_player, 1)
        local vr_fade = lighting:FindFirstChild("VRFade")

        if vr_fade then
            vr_fade.Brightness = 0
        end
    end
end

function vr_base_camera.OnCurrentCameraChanged(argument)
    base_camera.OnCurrentCameraChanged(argument)

    if argument.cameraHeadScaleChangedConn then
        argument.cameraHeadScaleChangedConn:Disconnect()
        argument.cameraHeadScaleChangedConn = nil
    end

    local current_camera = workspace.CurrentCamera

    if not current_camera then
        return
    end

    argument.cameraHeadScaleChangedConn = current_camera:GetPropertyChangedSignal("HeadScale"):Connect(function()
        argument:OnHeadScaleChanged()
    end)
    argument:OnHeadScaleChanged()
end

function vr_base_camera.OnHeadScaleChanged(argument)
    local head_scale = workspace.CurrentCamera.HeadScale

    for key, item in argument.gamepadZoomLevels do
        argument.gamepadZoomLevels[key] = (item * head_scale) / argument.headScale
    end

    argument:SetCameraToSubjectDistance(argument:GetCameraToSubjectDistance() * head_scale / argument.headScale)
    argument.headScale = head_scale
end

function vr_base_camera.GetVRFocus(argument, argument_2, argument_3)
    argument.cameraTranslationConstraints = Vector3.new(
        argument.cameraTranslationConstraints.x,
        math.min(1, argument.cameraTranslationConstraints.y + argument_3),
        argument.cameraTranslationConstraints.z
    )
    local vector = Vector3.new(0, argument:GetCameraHeight(), 0)

    return (
        CFrame.new(
            Vector3.new(argument_2.x, (argument.lastCameraFocus or argument_2).y, argument_2.z)
                :Lerp(argument_2 + vector, argument.cameraTranslationConstraints.y)
        )
    )
end

function vr_base_camera.StartFadeFromBlack(argument)
    if user_game_settings.VignetteEnabled == false then
        return
    end

    local vr_fade_2 = lighting:FindFirstChild("VRFade")

    if not vr_fade_2 then
        local vr_fade = Instance.new("ColorCorrectionEffect")
        vr_fade.Name = "VRFade"
        vr_fade.Parent = lighting
        vr_fade_2 = vr_fade
    end

    vr_fade_2.Brightness = -1
    argument.VRFadeResetTimer = 0.1
end

function vr_base_camera.UpdateFadeFromBlack(argument, argument_2)
    local vr_fade = lighting:FindFirstChild("VRFade")
    local value_3 = nil

    if argument.VRFadeResetTimer > 0 then
        argument.VRFadeResetTimer = math.max(argument.VRFadeResetTimer - argument_2, 0)
        value_3 = lighting:FindFirstChild("VRFade")

        if not value_3 or not (value_3.Brightness < 0) then
            return
        end

        value_3.Brightness = math.min(value_3.Brightness + (argument_2 * 10), 0)
    elseif vr_fade then
        vr_fade.Brightness = 0
    end
end

function vr_base_camera.StartVREdgeBlur(argument, argument_2)
    if user_game_settings.VignetteEnabled == false then
        return
    end

    local vr_blur_part = workspace.CurrentCamera:FindFirstChild("VRBlurPart")

    if not vr_blur_part then
        local vr_blur_part_2 = Instance.new("Part")
        vr_blur_part_2.Name = "VRBlurPart"
        vr_blur_part_2.Parent = workspace.CurrentCamera
        vr_blur_part_2.CanTouch = false
        vr_blur_part_2.CanCollide = false
        vr_blur_part_2.CanQuery = false
        vr_blur_part_2.Anchored = true
        vr_blur_part_2.Size = Vector3.new(0.4399999976158142, 0.4699999988079071, 1)
        vr_blur_part_2.Transparency = 1
        vr_blur_part_2.CastShadow = false

        run_service.RenderStepped:Connect(function(delta_time)
            local user_c_frame = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
            local product = workspace.CurrentCamera.CFrame
                * (CFrame.new(user_c_frame.p * workspace.CurrentCamera.HeadScale) * (user_c_frame - user_c_frame.p))
            vr_blur_part_2.CFrame = product * CFrame.Angles(0, math.pi, 0)
                + (product.LookVector * (1.05 * workspace.CurrentCamera.HeadScale))
            vr_blur_part_2.Size = Vector3.new(0.4399999976158142, 0.4699999988079071, 1)
                * workspace.CurrentCamera.HeadScale
        end)
    end

    local vr_blur_screen = argument_2.PlayerGui:FindFirstChild("VRBlurScreen")
    local vr_blur = nil
    vr_blur = (not vr_blur_screen) or vr_blur_screen:FindFirstChild("VRBlur")

    if not vr_blur then
        if not vr_blur_screen then
            vr_blur_screen = Instance.new("SurfaceGui") or Instance.new("ScreenGui")
        end

        vr_blur_screen.Name = "VRBlurScreen"
        vr_blur_screen.Parent = argument_2.PlayerGui
        vr_blur_screen.Adornee = vr_blur_part
        vr_blur = Instance.new("ImageLabel")
        vr_blur.Name = "VRBlur"
        vr_blur.Parent = vr_blur_screen
        vr_blur.Image = "rbxasset://textures/ui/VR/edgeBlur.png"
        vr_blur.AnchorPoint = Vector2.new(0.5, 0.5)
        vr_blur.Position = UDim2.new(0.5, 0, 0.5, 0)
        vr_blur.Size = UDim2.fromScale(
            (workspace.CurrentCamera.ViewportSize.X * 2.3) / 512,
            (workspace.CurrentCamera.ViewportSize.Y * 2.3) / 512
        )
        vr_blur.BackgroundTransparency = 1
        vr_blur.Active = true
        vr_blur.ScaleType = Enum.ScaleType.Stretch
    end

    vr_blur.Visible = true
    vr_blur.ImageTransparency = 0
    argument.VREdgeBlurTimer = 0.14
end

function vr_base_camera.UpdateEdgeBlur(argument, argument_2, argument_3)
    local vr_blur_screen = argument_2.PlayerGui:FindFirstChild("VRBlurScreen")
    local result = (not vr_blur_screen) or vr_blur_screen:FindFirstChild("VRBlur")

    if not result then
        return
    end

    local instance = nil

    if argument.VREdgeBlurTimer > 0 then
        argument.VREdgeBlurTimer = argument.VREdgeBlurTimer - argument_3
        instance = argument_2.PlayerGui:FindFirstChild("VRBlurScreen")

        if instance then
            local vr_blur = instance:FindFirstChild("VRBlur")

            if not vr_blur then
                return
            end

            vr_blur.ImageTransparency = 1 - (math.clamp(argument.VREdgeBlurTimer, 0.01, 0.14) * 7.142857142857142)
        end
    else
        result.Visible = false
    end
end

function vr_base_camera.GetCameraHeight(argument)
    if argument.inFirstPerson then
        return 0
    end

    return 0.25881904510252074 * argument.currentSubjectDistance
end

function vr_base_camera.GetSubjectCFrame(argument)
    local last_subject_c_frame = base_camera.GetSubjectCFrame(argument)
    local current_camera = workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject

    if not camera_subject then
        return last_subject_c_frame
    end

    local is_a_result = camera_subject:IsA("Humanoid")

    if is_a_result then
        current_camera = camera_subject:GetState() == Enum.HumanoidStateType.Dead

        if current_camera and current_camera == argument.lastSubject then
            last_subject_c_frame = argument.lastSubjectCFrame
        end
    end

    if last_subject_c_frame then
        argument.lastSubjectCFrame = last_subject_c_frame
    end

    return last_subject_c_frame
end

function vr_base_camera.GetSubjectPosition(argument)
    local last_subject_position = base_camera.GetSubjectPosition(argument)
    local current_camera = game.Workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject

    if not camera_subject then
        return nil
    end

    if camera_subject:IsA("Humanoid") then
        current_camera = camera_subject:GetState() == Enum.HumanoidStateType.Dead

        if current_camera and current_camera == argument.lastSubject then
            last_subject_position = argument.lastSubjectPosition
        end
    else
        last_subject_position = (
            camera_subject:IsA("VehicleSeat")
            and (camera_subject.CFrame.p + camera_subject.CFrame:vectorToWorldSpace(Vector3.new(0, 4, 0)))
        ) or last_subject_position
    end

    argument.lastSubjectPosition = last_subject_position

    return last_subject_position
end

function vr_base_camera.getRotation(argument, argument_2)
    local get_rotation_result = camera_input.getRotation(argument_2)

    if user_game_settings.VRSmoothRotationEnabled then
        if get_user_flag_result then
            return get_rotation_result.X
        end

        return (get_rotation_result.X * 40) * argument_2
    end

    if math.abs(get_rotation_result.X) > 0.03 then
        if argument.stepRotateTimeout > 0 then
            argument.stepRotateTimeout = argument.stepRotateTimeout - argument_2
        end

        if argument.stepRotateTimeout <= 0 then
            local negated_value = ((get_rotation_result.X < 0) and -1) or 1
            argument:StartFadeFromBlack()
            argument.stepRotateTimeout = 0.25

            return negated_value * 0.5235987755982988
        end
    elseif math.abs(get_rotation_result.X) < 0.02 then
        argument.stepRotateTimeout = 0
    end

    return 0
end

return vr_base_camera
