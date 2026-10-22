local success, result = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserVRVehicleCamera2")
end)
local result_2 = success and result
local vr_service = game:GetService("VRService")
local local_player = game:GetService("Players").LocalPlayer
local lighting = game:GetService("Lighting")
local run_service = game:GetService("RunService")
local user_game_settings = UserSettings():GetService("UserGameSettings")
local camera_input = require(script.Parent:WaitForChild("CameraInput"))
local zoom_controller = require(script.Parent:WaitForChild("ZoomController"))
local common_utils = script.Parent.Parent:WaitForChild("CommonUtils")
local user_flag = require(common_utils:WaitForChild("FlagUtil")).getUserFlag("UserCameraInputDt")
local base_camera = require(script.Parent:WaitForChild("BaseCamera"))
local vr_base_camera = setmetatable({}, base_camera)
vr_base_camera.__index = vr_base_camera

function vr_base_camera.new()
    local base_camera_2 = base_camera.new()
    local instance = setmetatable(base_camera_2, vr_base_camera)
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
                if result_2 then
                    argument:Reset()

                    return
                end

                if not argument:IsInFirstPerson() then
                    argument:Reset()
                end
            end)
        argument.vrRecentered = vr_service.UserCFrameChanged:Connect(function(argument_2, argument_3)
            if argument_2 == Enum.UserCFrame.Floor then
                argument.recentered = true
            end
        end)

        return
    end

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

function vr_base_camera.OnCurrentCameraChanged(argument)
    base_camera.OnCurrentCameraChanged(argument)

    if argument.cameraHeadScaleChangedConn then
        argument.cameraHeadScaleChangedConn:Disconnect()
        argument.cameraHeadScaleChangedConn = nil
    end

    local workspace_current_camera = workspace.CurrentCamera

    if workspace_current_camera then
        argument.cameraHeadScaleChangedConn = workspace_current_camera
            :GetPropertyChangedSignal("HeadScale")
            :Connect(function()
                argument:OnHeadScaleChanged()
            end)
        argument:OnHeadScaleChanged()
    end
end

function vr_base_camera.OnHeadScaleChanged(argument)
    local head_scale = workspace.CurrentCamera.HeadScale

    for key, item in argument.gamepadZoomLevels do
        argument.gamepadZoomLevels[key] = item * head_scale / argument.headScale
    end

    argument:SetCameraToSubjectDistance(argument:GetCameraToSubjectDistance() * head_scale / argument.headScale)
    argument.headScale = head_scale
end

function vr_base_camera.GetVRFocus(argument, argument_2, argument_3)
    local last_camera_focus = argument.lastCameraFocus or argument_2
    local x = argument.cameraTranslationConstraints.x
    local minimum = math.min(1, argument.cameraTranslationConstraints.y + argument_3)
    argument.cameraTranslationConstraints = Vector3.new(x, minimum, argument.cameraTranslationConstraints.z)
    local camera_height = argument:GetCameraHeight()
    local vector = Vector3.new(0, camera_height, 0)

    return CFrame.new(
        Vector3.new(argument_2.x, last_camera_focus.y, argument_2.z)
            :Lerp(argument_2 + vector, argument.cameraTranslationConstraints.y)
    )
end

function vr_base_camera.StartFadeFromBlack(argument)
    if user_game_settings.VignetteEnabled == false then
        return
    end

    local vr_fade = lighting:FindFirstChild("VRFade")

    if not vr_fade then
        vr_fade = Instance.new("ColorCorrectionEffect")
        vr_fade.Name = "VRFade"
        vr_fade.Parent = lighting
    end

    vr_fade.Brightness = -1
    argument.VRFadeResetTimer = 0.1
end

function vr_base_camera.UpdateFadeFromBlack(argument: table, argument_2: number)
    local vr_fade = lighting:FindFirstChild("VRFade")

    if argument.VRFadeResetTimer > 0 then
        argument.VRFadeResetTimer = math.max(argument.VRFadeResetTimer - argument_2, 0)
        local vr_fade2 = lighting:FindFirstChild("VRFade")

        if vr_fade2 and vr_fade2.Brightness < 0 then
            vr_fade2.Brightness = math.min(vr_fade2.Brightness + argument_2 * 10, 0)
        end
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
        vr_blur_part = Instance.new("Part")
        vr_blur_part.Name = "VRBlurPart"
        vr_blur_part.Parent = workspace.CurrentCamera
        vr_blur_part.CanTouch = false
        vr_blur_part.CanCollide = false
        vr_blur_part.CanQuery = false
        vr_blur_part.Anchored = true
        vr_blur_part.Size = Vector3.new(0.44, 0.47, 1)
        vr_blur_part.Transparency = 1
        vr_blur_part.CastShadow = false

        run_service.RenderStepped:Connect(function(delta_time)
            local user_c_frame = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
            local product = workspace.CurrentCamera.CFrame
                * (CFrame.new(user_c_frame.p * workspace.CurrentCamera.HeadScale) * (user_c_frame - user_c_frame.p))
            vr_blur_part.CFrame = product * CFrame.Angles(0, 3.141592653589793, 0)
                + product.LookVector * (1.05 * workspace.CurrentCamera.HeadScale)
            vr_blur_part.Size = Vector3.new(0.44, 0.47, 1) * workspace.CurrentCamera.HeadScale
        end)
    end

    local vr_blur_screen = argument_2.PlayerGui:FindFirstChild("VRBlurScreen")
    local vr_blur

    if vr_blur_screen then
        vr_blur = vr_blur_screen:FindFirstChild("VRBlur")
    else
        vr_blur = nil
    end

    if not vr_blur then
        local vr_blur_screen_2 = vr_blur_screen or (Instance.new("SurfaceGui") or Instance.new("ScreenGui"))
        vr_blur_screen_2.Name = "VRBlurScreen"
        vr_blur_screen_2.Parent = argument_2.PlayerGui
        vr_blur_screen_2.Adornee = vr_blur_part
        vr_blur = Instance.new("ImageLabel")
        vr_blur.Name = "VRBlur"
        vr_blur.Parent = vr_blur_screen_2
        vr_blur.Image = "rbxasset://textures/ui/VR/edgeBlur.png"
        vr_blur.AnchorPoint = Vector2.new(0.5, 0.5)
        vr_blur.Position = UDim2.new(0.5, 0, 0.5, 0)
        vr_blur.Size = UDim2.fromScale(
            workspace.CurrentCamera.ViewportSize.X * 2.3 / 512,
            workspace.CurrentCamera.ViewportSize.Y * 2.3 / 512
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
    local vr_blur

    if vr_blur_screen then
        vr_blur = vr_blur_screen:FindFirstChild("VRBlur")
    else
        vr_blur = nil
    end

    if not vr_blur then
        return
    end

    if argument.VREdgeBlurTimer > 0 then
        argument.VREdgeBlurTimer = argument.VREdgeBlurTimer - argument_3
        local vr_blur_screen2 = argument_2.PlayerGui:FindFirstChild("VRBlurScreen")
        local vr_blur_2 = vr_blur_screen2 and vr_blur_screen2:FindFirstChild("VRBlur")

        if vr_blur_2 then
            vr_blur_2.ImageTransparency = 1 - math.clamp(argument.VREdgeBlurTimer, 0.01, 0.14) * 7.142857142857142
        end
    else
        vr_blur.Visible = false
    end
end

function vr_base_camera.GetCameraHeight(argument)
    return argument.inFirstPerson and 0 or 0.25881904510252074 * argument.currentSubjectDistance
end

function vr_base_camera.GetSubjectCFrame(argument)
    local subject_c_frame = base_camera.GetSubjectCFrame(argument)
    local workspace_current_camera = workspace.CurrentCamera

    if workspace_current_camera then
        workspace_current_camera = workspace_current_camera.CameraSubject
    end

    if not workspace_current_camera then
        return subject_c_frame
    end

    if
        workspace_current_camera:IsA("Humanoid")
        and (
            workspace_current_camera:GetState() == Enum.HumanoidStateType.Dead
            and workspace_current_camera == argument.lastSubject
        )
    then
        subject_c_frame = argument.lastSubjectCFrame
    end

    if subject_c_frame then
        argument.lastSubjectCFrame = subject_c_frame
    end

    return subject_c_frame
end

function vr_base_camera.GetSubjectPosition(argument)
    local subject_position = base_camera.GetSubjectPosition(argument)
    local current_camera = game.Workspace.CurrentCamera

    if current_camera then
        current_camera = current_camera.CameraSubject
    end

    if not current_camera then
        return nil
    end

    if current_camera:IsA("Humanoid") then
        if current_camera:GetState() == Enum.HumanoidStateType.Dead and current_camera == argument.lastSubject then
            subject_position = argument.lastSubjectPosition
        end
    elseif current_camera:IsA("VehicleSeat") then
        subject_position = current_camera.CFrame.p + current_camera.CFrame:vectorToWorldSpace(Vector3.new(0, 4, 0))
    end

    argument.lastSubjectPosition = subject_position

    return subject_position
end

function vr_base_camera.getRotation(argument, argument_2)
    local rotation = camera_input.getRotation(argument_2)

    if user_game_settings.VRSmoothRotationEnabled then
        if user_flag then
            return rotation.X
        end

        return rotation.X * 40 * argument_2
    end

    if math.abs(rotation.X) > 0.03 then
        if argument.stepRotateTimeout > 0 then
            argument.stepRotateTimeout = argument.stepRotateTimeout - argument_2
        end

        if argument.stepRotateTimeout <= 0 then
            local product = (rotation.X < 0 and -1 or 1) * 0.5235987755982988
            argument:StartFadeFromBlack()
            argument.stepRotateTimeout = 0.25

            return product
        end
    elseif math.abs(rotation.X) < 0.02 then
        argument.stepRotateTimeout = 0
    end

    return 0
end

return vr_base_camera
