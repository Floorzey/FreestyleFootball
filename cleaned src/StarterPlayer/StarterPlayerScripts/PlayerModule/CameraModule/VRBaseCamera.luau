local success, value = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserVRVehicleCamera2")
end)
local success_2 = success and value
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

function vr_base_camera.Reset(self)
    self.stepRotateTimeout = 0
end

function vr_base_camera.GetModuleName(self)
    return "VRBaseCamera"
end

function vr_base_camera.GamepadZoomPress(self)
    base_camera.GamepadZoomPress(self)
    self:GamepadReset()
    self:ResetZoom()
end

function vr_base_camera.GamepadReset(self)
    self.stepRotateTimeout = 0
    self.needsReset = true
end

function vr_base_camera.ResetZoom(self)
    zoom_controller.SetZoomParameters(self.currentSubjectDistance, 0)
    zoom_controller.ReleaseSpring()
end

function vr_base_camera.OnEnabledChanged(self)
    base_camera.OnEnabledChanged(self)
    if self.enabled then
        self.gamepadResetConnection = camera_input.gamepadReset:Connect(function()
            self:GamepadReset()
        end)
        self.thirdPersonOptionChanged = vr_service
            :GetPropertyChangedSignal("ThirdPersonFollowCamEnabled")
            :Connect(function()
                if success_2 or not (self:IsInFirstPerson()) then
                    self:Reset()
                end
            end)
        self.vrRecentered = vr_service.UserCFrameChanged:Connect(function(argument, argument_2)
            if argument ~= Enum.UserCFrame.Floor then
                return
            end
            self.recentered = true
        end)
    else
        if self.inFirstPerson then
            self:GamepadZoomPress()
        end
        if self.thirdPersonOptionChanged then
            self.thirdPersonOptionChanged:Disconnect()
            self.thirdPersonOptionChanged = nil
        end
        if self.vrRecentered then
            self.vrRecentered:Disconnect()
            self.vrRecentered = nil
        end
        if self.cameraHeadScaleChangedConn then
            self.cameraHeadScaleChangedConn:Disconnect()
            self.cameraHeadScaleChangedConn = nil
        end
        if self.gamepadResetConnection then
            self.gamepadResetConnection:Disconnect()
            self.gamepadResetConnection = nil
        end
        self.VREdgeBlurTimer = 0
        self:UpdateEdgeBlur(local_player, 1)
        local vr_fade = lighting:FindFirstChild("VRFade")
        if vr_fade then
            vr_fade.Brightness = 0
        end
    end
end

function vr_base_camera.OnCurrentCameraChanged(self)
    base_camera.OnCurrentCameraChanged(self)
    if self.cameraHeadScaleChangedConn then
        self.cameraHeadScaleChangedConn:Disconnect()
        self.cameraHeadScaleChangedConn = nil
    end
    local current_camera = workspace.CurrentCamera
    if not current_camera then
        return
    end
    self.cameraHeadScaleChangedConn = current_camera:GetPropertyChangedSignal("HeadScale"):Connect(function()
        self:OnHeadScaleChanged()
    end)
    self:OnHeadScaleChanged()
end

function vr_base_camera.OnHeadScaleChanged(self)
    local head_scale = workspace.CurrentCamera.HeadScale
    for key, item in self.gamepadZoomLevels do
        self.gamepadZoomLevels[key] = (item * head_scale) / self.headScale
    end
    self:SetCameraToSubjectDistance(self:GetCameraToSubjectDistance() * head_scale / self.headScale)
    self.headScale = head_scale
end

function vr_base_camera.GetVRFocus(self, argument, argument_2)
    self.cameraTranslationConstraints = Vector3.new(
        self.cameraTranslationConstraints.x,
        math.min(1, self.cameraTranslationConstraints.y + argument_2),
        self.cameraTranslationConstraints.z
    )
    local vector = Vector3.new(0, self:GetCameraHeight(), 0)
    return (
        CFrame.new(
            Vector3.new(argument.x, (self.lastCameraFocus or argument).y, argument.z)
                :Lerp(argument + vector, self.cameraTranslationConstraints.y)
        )
    )
end

function vr_base_camera.StartFadeFromBlack(self)
    if user_game_settings.VignetteEnabled == false then
        return
    end
    local vr_fade = lighting:FindFirstChild("VRFade")
    if not vr_fade then
        local color_correction_effect = Instance.new("ColorCorrectionEffect")
        color_correction_effect.Name = "VRFade"
        color_correction_effect.Parent = lighting
        vr_fade = color_correction_effect
    end
    vr_fade.Brightness = -1
    self.VRFadeResetTimer = 0.1
end

function vr_base_camera.UpdateFadeFromBlack(self, argument)
    local vr_fade = lighting:FindFirstChild("VRFade")
    local value_2 = nil
    if self.VRFadeResetTimer > 0 then
        self.VRFadeResetTimer = math.max(self.VRFadeResetTimer - argument, 0)
        value_2 = lighting:FindFirstChild("VRFade")
        if not value_2 or not (value_2.Brightness < 0) then
            return
        end
        value_2.Brightness = math.min(value_2.Brightness + (argument * 10), 0)
    elseif vr_fade then
        vr_fade.Brightness = 0
    end
end

function vr_base_camera.StartVREdgeBlur(self, argument)
    if user_game_settings.VignetteEnabled == false then
        return
    end
    local vr_blur_part = workspace.CurrentCamera:FindFirstChild("VRBlurPart")
    if not vr_blur_part then
        local part = Instance.new("Part")
        part.Name = "VRBlurPart"
        part.Parent = workspace.CurrentCamera
        part.CanTouch = false
        part.CanCollide = false
        part.CanQuery = false
        part.Anchored = true
        part.Size = Vector3.new(0.4399999976158142, 0.4699999988079071, 1)
        part.Transparency = 1
        part.CastShadow = false
        run_service.RenderStepped:Connect(function(delta_time)
            local user_c_frame = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
            local cframe_offset = workspace.CurrentCamera.CFrame
                * (CFrame.new(user_c_frame.p * workspace.CurrentCamera.HeadScale) * (user_c_frame - user_c_frame.p))
            part.CFrame = cframe_offset * CFrame.Angles(0, math.pi, 0)
                + (cframe_offset.LookVector * (1.05 * workspace.CurrentCamera.HeadScale))
            part.Size = Vector3.new(0.4399999976158142, 0.4699999988079071, 1) * workspace.CurrentCamera.HeadScale
        end)
    end
    local vr_blur_screen = argument.PlayerGui:FindFirstChild("VRBlurScreen")
    local value_2 = nil
    value_2 = (not vr_blur_screen) or (vr_blur_screen:FindFirstChild("VRBlur"))
    if not value_2 then
        if not vr_blur_screen then
            vr_blur_screen = Instance.new("SurfaceGui") or Instance.new("ScreenGui")
        end
        vr_blur_screen.Name = "VRBlurScreen"
        vr_blur_screen.Parent = argument.PlayerGui
        vr_blur_screen.Adornee = vr_blur_part
        value_2 = Instance.new("ImageLabel")
        value_2.Name = "VRBlur"
        value_2.Parent = vr_blur_screen
        value_2.Image = "rbxasset://textures/ui/VR/edgeBlur.png"
        value_2.AnchorPoint = Vector2.new(0.5, 0.5)
        value_2.Position = UDim2.new(0.5, 0, 0.5, 0)
        value_2.Size = UDim2.fromScale(
            (workspace.CurrentCamera.ViewportSize.X * 2.3) / 512,
            (workspace.CurrentCamera.ViewportSize.Y * 2.3) / 512
        )
        value_2.BackgroundTransparency = 1
        value_2.Active = true
        value_2.ScaleType = Enum.ScaleType.Stretch
    end
    value_2.Visible = true
    value_2.ImageTransparency = 0
    self.VREdgeBlurTimer = 0.14
end

function vr_base_camera.UpdateEdgeBlur(self, argument, argument_2)
    local vr_blur_screen = argument.PlayerGui:FindFirstChild("VRBlurScreen")
    local vr_blur_2 = (not vr_blur_screen) or (vr_blur_screen:FindFirstChild("VRBlur"))
    if vr_blur_2 then
        local instance = nil
        if self.VREdgeBlurTimer > 0 then
            self.VREdgeBlurTimer = self.VREdgeBlurTimer - argument_2
            instance = argument.PlayerGui:FindFirstChild("VRBlurScreen")
            if instance then
                local vr_blur = instance:FindFirstChild("VRBlur")
                if not vr_blur then
                    return
                end
                vr_blur.ImageTransparency = 1 - (math.clamp(self.VREdgeBlurTimer, 0.01, 0.14) * 7.142857142857142)
            end
        else
            vr_blur_2.Visible = false
        end
    end
end

function vr_base_camera.GetCameraHeight(self)
    if self.inFirstPerson then
        return 0
    end
    return 0.25881904510252074 * self.currentSubjectDistance
end

function vr_base_camera.GetSubjectCFrame(self)
    local last_subject_c_frame = base_camera.GetSubjectCFrame(self)
    local current_camera = workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject
    if not camera_subject then
        return last_subject_c_frame
    end
    local is_a_result = camera_subject:IsA("Humanoid")
    if is_a_result then
        local is_state = camera_subject:GetState() == Enum.HumanoidStateType.Dead
        if is_state and current_camera == self.lastSubject then
            last_subject_c_frame = self.lastSubjectCFrame
        end
    end
    if last_subject_c_frame then
        self.lastSubjectCFrame = last_subject_c_frame
    end
    return last_subject_c_frame
end

function vr_base_camera.GetSubjectPosition(self)
    local last_subject_position = base_camera.GetSubjectPosition(self)
    local current_camera = game.Workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject
    if camera_subject then
        if camera_subject:IsA("Humanoid") then
            local is_state = camera_subject:GetState() == Enum.HumanoidStateType.Dead
            if is_state and current_camera == self.lastSubject then
                last_subject_position = self.lastSubjectPosition
            end
        else
            last_subject_position = (
                camera_subject:IsA("VehicleSeat")
                and (camera_subject.CFrame.p + camera_subject.CFrame:vectorToWorldSpace(Vector3.new(0, 4, 0)))
            ) or last_subject_position
        end
        self.lastSubjectPosition = last_subject_position
        return last_subject_position
    end
    return nil
end

function vr_base_camera.getRotation(self, argument)
    local get_rotation_result = camera_input.getRotation(argument)
    if user_game_settings.VRSmoothRotationEnabled then
        if get_user_flag_result then
            return get_rotation_result.X
        end
        return (get_rotation_result.X * 40) * argument
    end
    if math.abs(get_rotation_result.X) > 0.03 then
        if self.stepRotateTimeout > 0 then
            self.stepRotateTimeout = self.stepRotateTimeout - argument
        end
        if self.stepRotateTimeout <= 0 then
            local is_x = ((get_rotation_result.X < 0) and -1) or 1
            self:StartFadeFromBlack()
            self.stepRotateTimeout = 0.25
            return is_x * 0.5235987755982988
        end
    elseif math.abs(get_rotation_result.X) < 0.02 then
        self.stepRotateTimeout = 0
    end
    return 0
end

return vr_base_camera
