local flag_util = require(script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil"))
local success, value = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserFixGamepadMaxZoom")
end)
local success_2 = success and value
local get_user_flag_result = flag_util.getUserFlag("UserFixCameraOffsetJitter2")
local _ = Vector2.new(0.2617993877991494, 0)
local vector = Vector2.new(0.7853981633974483, 0)
local vector_2 = Vector2.new(0, 0)
local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
local zoom_controller = require(script.Parent:WaitForChild("ZoomController"))
local camera_toggle_state_controller = require(script.Parent:WaitForChild("CameraToggleStateController"))
local camera_input = require(script.Parent:WaitForChild("CameraInput"))
local camera_ui = require(script.Parent:WaitForChild("CameraUI"))
local players = game:GetService("Players")
local user_input_service = game:GetService("UserInputService")
local starter_gui = game:GetService("StarterGui")
local vr_service = game:GetService("VRService")
local user_game_settings = UserSettings():GetService("UserGameSettings")
local local_player = players.LocalPlayer
local base_camera = {}
base_camera.__index = base_camera

function base_camera.new()
    local instance = setmetatable({}, base_camera)
    instance.gamepadZoomLevels = { 0, 10, 20 }
    instance.FIRST_PERSON_DISTANCE_THRESHOLD = 1
    instance.cameraType = nil
    instance.cameraMovementMode = nil
    instance.lastCameraTransform = nil
    instance.lastUserPanCamera = tick()
    instance.humanoidRootPart = nil
    instance.humanoidCache = {}
    instance.lastSubject = nil
    instance.lastSubjectPosition = Vector3.new(0, 5, 0)
    instance.lastSubjectCFrame = CFrame.new(instance.lastSubjectPosition)
    instance.currentSubjectDistance =
        math.clamp(12.5, local_player.CameraMinZoomDistance, local_player.CameraMaxZoomDistance)
    instance.inFirstPerson = false
    instance.inMouseLockedMode = false
    instance.portraitMode = false
    instance.isSmallTouchScreen = false
    instance.resetCameraAngle = true
    instance.enabled = false
    instance.PlayerGui = nil
    instance.cameraChangedConn = nil
    instance.viewportSizeChangedConn = nil
    instance.shouldUseVRRotation = false
    instance.VRRotationIntensityAvailable = false
    instance.lastVRRotationIntensityCheckTime = 0
    instance.lastVRRotationTime = 0
    instance.vrRotateKeyCooldown = {}
    instance.cameraTranslationConstraints = Vector3.new(1, 1, 1)
    instance.humanoidJumpOrigin = nil
    instance.trackingHumanoid = nil
    instance.cameraFrozen = false
    instance.subjectStateChangedConn = nil
    instance.gamepadZoomPressConnection = nil
    instance.mouseLockOffset = Vector3.new(0, 0, 0)
    if local_player.Character then
        instance:OnCharacterAdded(local_player.Character)
    end
    local_player.CharacterAdded:Connect(function(character)
        instance:OnCharacterAdded(character)
    end)
    if instance.playerCameraModeChangeConn then
        instance.playerCameraModeChangeConn:Disconnect()
    end
    instance.playerCameraModeChangeConn = local_player:GetPropertyChangedSignal("CameraMode"):Connect(function()
        instance:OnPlayerCameraPropertyChange()
    end)
    if instance.minDistanceChangeConn then
        instance.minDistanceChangeConn:Disconnect()
    end
    instance.minDistanceChangeConn = local_player:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function()
        instance:OnPlayerCameraPropertyChange()
    end)
    if instance.maxDistanceChangeConn then
        instance.maxDistanceChangeConn:Disconnect()
    end
    instance.maxDistanceChangeConn = local_player:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
        instance:OnPlayerCameraPropertyChange()
    end)
    if instance.playerDevTouchMoveModeChangeConn then
        instance.playerDevTouchMoveModeChangeConn:Disconnect()
    end
    instance.playerDevTouchMoveModeChangeConn = local_player
        :GetPropertyChangedSignal("DevTouchMovementMode")
        :Connect(function()
            instance:OnDevTouchMovementModeChanged()
        end)
    instance:OnDevTouchMovementModeChanged()
    if instance.gameSettingsTouchMoveMoveChangeConn then
        instance.gameSettingsTouchMoveMoveChangeConn:Disconnect()
    end
    instance.gameSettingsTouchMoveMoveChangeConn = user_game_settings
        :GetPropertyChangedSignal("TouchMovementMode")
        :Connect(function()
            instance:OnGameSettingsTouchMovementModeChanged()
        end)
    instance:OnGameSettingsTouchMovementModeChanged()
    user_game_settings:SetCameraYInvertVisible()
    user_game_settings:SetGamepadCameraSensitivityVisible()
    instance.hasGameLoaded = game:IsLoaded()
    if not instance.hasGameLoaded then
        instance.gameLoadedConn = game.Loaded:Connect(function()
            instance.hasGameLoaded = true
            instance.gameLoadedConn:Disconnect()
            instance.gameLoadedConn = nil
        end)
    end
    instance:OnPlayerCameraPropertyChange()
    return instance
end

function base_camera.GetModuleName(self)
    return "BaseCamera"
end

function base_camera.OnCharacterAdded(self, instance)
    self.resetCameraAngle = self.resetCameraAngle or self:GetEnabled()
    self.humanoidRootPart = nil
    if not user_input_service.TouchEnabled then
        return
    end
    self.PlayerGui = local_player:WaitForChild("PlayerGui")
    for _, child in ipairs(instance:GetChildren()) do
        if child:IsA("Tool") then
            self.isAToolEquipped = true
        end
    end
    instance.ChildAdded:Connect(function(child_2)
        if not child_2:IsA("Tool") then
            return
        end
        self.isAToolEquipped = true
    end)
    instance.ChildRemoved:Connect(function(child_2)
        if not child_2:IsA("Tool") then
            return
        end
        self.isAToolEquipped = false
    end)
end

function base_camera.GetHumanoidRootPart(self)
    if not self.humanoidRootPart and local_player.Character then
        local humanoid = local_player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            self.humanoidRootPart = humanoid.RootPart
        end
    end
    return self.humanoidRootPart
end

function base_camera.GetBodyPartToFollow(self, argument, argument_2)
    if argument:GetState() == Enum.HumanoidStateType.Dead then
        local parent = argument.Parent
        if parent and parent:IsA("Model") then
            local head = parent:FindFirstChild("Head") or argument.RootPart
            return head
        end
    end
    return argument.RootPart
end

function base_camera.GetSubjectCFrame(self)
    local last_subject_c_frame = self.lastSubjectCFrame
    local current_camera = workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject
    if camera_subject then
        if camera_subject:IsA("Humanoid") then
            local is_state = camera_subject:GetState() == Enum.HumanoidStateType.Dead
            local camera_offset = current_camera.CameraOffset
            if get_user_flag_result and self:GetIsMouseLocked() then
                local _ = Vector3.new()
            end
            local root_part = current_camera.RootPart
            if is_state and current_camera.Parent then
                local is_a_result = current_camera.Parent:IsA("Model")
                root_part = is_a_result and (current_camera.Parent:FindFirstChild("Head") or root_part)
            end
            if root_part then
                local is_a_result_2 = root_part:IsA("BasePart")
                if is_a_result_2 then
                    if current_camera.RigType ~= Enum.HumanoidRigType.R15 then
                        is_a_result_2 = Vector3.new(0, 1.5, 0)
                    else
                        local value_2 = nil
                        if current_camera.AutomaticScalingEnabled then
                            is_a_result_2 = Vector3.new(0, 1.5, 0)
                            value_2 = current_camera.RootPart
                            if root_part == value_2 then
                                is_a_result_2 += Vector3.new(0, (value_2.Size.Y - 2) / 2, 0)
                            end
                        else
                            is_a_result_2 = Vector3.new(0, 2, 0)
                        end
                    end
                    last_subject_c_frame = root_part.CFrame
                        * CFrame.new(((is_state and Vector3.new(0, 0, 0)) or is_a_result_2) + camera_offset)
                end
            end
        elseif camera_subject:IsA("BasePart") then
            last_subject_c_frame = camera_subject.CFrame
        else
            local is_a_result_3 = camera_subject:IsA("Model")
            if is_a_result_3 then
                if camera_subject.PrimaryPart then
                    last_subject_c_frame = camera_subject:GetPrimaryPartCFrame()
                else
                    last_subject_c_frame = CFrame.new()
                end
            end
        end
        if last_subject_c_frame then
            self.lastSubjectCFrame = last_subject_c_frame
        end
    end
    return last_subject_c_frame
end

function base_camera.GetSubjectVelocity(self)
    local current_camera = workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject
    if camera_subject then
        if camera_subject:IsA("BasePart") then
            return camera_subject.Velocity
        else
            local value_2 = nil
            if camera_subject:IsA("Humanoid") then
                value_2 = camera_subject.RootPart
                if value_2 then
                    return value_2.Velocity
                end
            elseif camera_subject:IsA("Model") then
                local primary_part = camera_subject.PrimaryPart
                if primary_part then
                    return primary_part.Velocity
                end
            end
            return Vector3.new(0, 0, 0)
        end
    else
        return Vector3.new(0, 0, 0)
    end
end

function base_camera.GetSubjectRotVelocity(self)
    local current_camera = workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject
    if camera_subject then
        if camera_subject:IsA("BasePart") then
            return camera_subject.RotVelocity
        else
            local value_2 = nil
            if camera_subject:IsA("Humanoid") then
                value_2 = camera_subject.RootPart
                if value_2 then
                    return value_2.RotVelocity
                end
            elseif camera_subject:IsA("Model") then
                local primary_part = camera_subject.PrimaryPart
                if primary_part then
                    return primary_part.RotVelocity
                end
            end
            return Vector3.new(0, 0, 0)
        end
    else
        return Vector3.new(0, 0, 0)
    end
end

function base_camera.StepZoom(self)
    local current_subject_distance = self.currentSubjectDistance
    local get_zoom_delta_result = camera_input.getZoomDelta()
    if math.abs(get_zoom_delta_result) > 0 then
        local maximum
        if get_zoom_delta_result > 0 then
            maximum = math.max(
                current_subject_distance + (get_zoom_delta_result * ((current_subject_distance * 0.5) + 1)),
                self.FIRST_PERSON_DISTANCE_THRESHOLD
            )
        else
            maximum =
                math.max((current_subject_distance + get_zoom_delta_result) / (1 - (get_zoom_delta_result * 0.5)), 0.5)
        end
        if maximum < self.FIRST_PERSON_DISTANCE_THRESHOLD then
            maximum = 0.5
        end
        self:SetCameraToSubjectDistance(maximum)
    end
    return zoom_controller.GetZoomRadius()
end

function base_camera.GetSubjectPosition(self)
    local last_subject_position = self.lastSubjectPosition
    local current_camera = game.Workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject
    if camera_subject then
        if camera_subject:IsA("Humanoid") then
            local is_state = camera_subject:GetState() == Enum.HumanoidStateType.Dead
            local camera_offset = current_camera.CameraOffset
            if get_user_flag_result and self:GetIsMouseLocked() then
                local _ = Vector3.new()
            end
            local root_part = current_camera.RootPart
            if is_state and current_camera.Parent then
                local is_a_result = current_camera.Parent:IsA("Model")
                root_part = is_a_result and (current_camera.Parent:FindFirstChild("Head") or root_part)
            end
            if root_part then
                local is_a_result_2 = root_part:IsA("BasePart")
                if is_a_result_2 then
                    if current_camera.RigType ~= Enum.HumanoidRigType.R15 then
                        is_a_result_2 = Vector3.new(0, 1.5, 0)
                    elseif current_camera.AutomaticScalingEnabled then
                        is_a_result_2 = Vector3.new(0, 1.5, 0)
                        if root_part == current_camera.RootPart then
                            is_a_result_2 += Vector3.new(0, current_camera.RootPart.Size.Y / 2 - 1, 0)
                        end
                    else
                        is_a_result_2 = Vector3.new(0, 2, 0)
                    end
                    last_subject_position = root_part.CFrame.p
                        + root_part.CFrame:vectorToWorldSpace(
                            ((is_state and Vector3.new(0, 0, 0)) or is_a_result_2) + camera_offset
                        )
                end
            end
        elseif camera_subject:IsA("VehicleSeat") then
            last_subject_position = camera_subject.CFrame.p
                + camera_subject.CFrame:vectorToWorldSpace(Vector3.new(0, 5, 0))
        elseif camera_subject:IsA("SkateboardPlatform") then
            last_subject_position = camera_subject.CFrame.p + Vector3.new(0, 5, 0)
        elseif camera_subject:IsA("BasePart") then
            last_subject_position = camera_subject.CFrame.p
        else
            local is_a_result_3 = camera_subject:IsA("Model")
            if is_a_result_3 then
                if camera_subject.PrimaryPart then
                    last_subject_position = camera_subject:GetPrimaryPartCFrame().p
                else
                    last_subject_position = camera_subject:GetModelCFrame().p
                end
            end
        end
        self.lastSubject = current_camera
        self.lastSubjectPosition = last_subject_position
        return last_subject_position
    end
    return nil
end

function base_camera.OnViewportSizeChanged(self)
    local viewport_size = game.Workspace.CurrentCamera.ViewportSize
    self.portraitMode = viewport_size.X < viewport_size.Y
    local touch_enabled = user_input_service.TouchEnabled
    local is_small_touch_screen
    if touch_enabled then
        is_small_touch_screen = true
        if not (viewport_size.Y < 500) then
            is_small_touch_screen = viewport_size.X < 700
        end
    else
        is_small_touch_screen = touch_enabled
    end
    self.isSmallTouchScreen = is_small_touch_screen
end

function base_camera.OnCurrentCameraChanged(self)
    if user_input_service.TouchEnabled then
        if self.viewportSizeChangedConn then
            self.viewportSizeChangedConn:Disconnect()
            self.viewportSizeChangedConn = nil
        end
        local current_camera = game.Workspace.CurrentCamera
        if current_camera then
            self:OnViewportSizeChanged()
            self.viewportSizeChangedConn = current_camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                self:OnViewportSizeChanged()
            end)
        end
    end
    if self.cameraSubjectChangedConn then
        self.cameraSubjectChangedConn:Disconnect()
        self.cameraSubjectChangedConn = nil
    end
    local current_camera_2 = game.Workspace.CurrentCamera
    if not current_camera_2 then
        return
    end
    self.cameraSubjectChangedConn = current_camera_2:GetPropertyChangedSignal("CameraSubject"):Connect(function()
        self:OnNewCameraSubject()
    end)
    self:OnNewCameraSubject()
end

function base_camera.OnDynamicThumbstickEnabled(self)
    if not user_input_service.TouchEnabled then
        return
    end
    self.isDynamicThumbstickEnabled = true
end

function base_camera.OnDynamicThumbstickDisabled(self)
    self.isDynamicThumbstickEnabled = false
end

function base_camera.OnGameSettingsTouchMovementModeChanged(self)
    if local_player.DevTouchMovementMode ~= Enum.DevTouchMovementMode.UserChoice then
        return
    end
    if
        user_game_settings.TouchMovementMode ~= Enum.TouchMovementMode.DynamicThumbstick
        and user_game_settings.TouchMovementMode ~= Enum.TouchMovementMode.Default
    then
        self:OnDynamicThumbstickDisabled()
        return
    end
    self:OnDynamicThumbstickEnabled()
end

function base_camera.OnDevTouchMovementModeChanged(self)
    if local_player.DevTouchMovementMode ~= Enum.DevTouchMovementMode.DynamicThumbstick then
        self:OnGameSettingsTouchMovementModeChanged()
    else
        self:OnDynamicThumbstickEnabled()
    end
end

function base_camera.OnPlayerCameraPropertyChange(self)
    self:SetCameraToSubjectDistance(self.currentSubjectDistance)
end

function base_camera.InputTranslationToCameraAngleChange(self, argument, argument_2)
    return argument * argument_2
end

function base_camera.GamepadZoomPress(self)
    local camera_to_subject_distance = self:GetCameraToSubjectDistance()
    local camera_max_zoom_distance = local_player.CameraMaxZoomDistance
    local value_2 = nil
    for n = #self.gamepadZoomLevels, 1, -1 do
        value_2 = self.gamepadZoomLevels[n]
        if camera_max_zoom_distance < value_2 then
            continue
        end
        if value_2 < local_player.CameraMinZoomDistance then
            local camera_min_zoom_distance = local_player.CameraMinZoomDistance
            if success_2 and camera_max_zoom_distance == camera_min_zoom_distance then
                break
            end
            value_2 = camera_min_zoom_distance
        end
        if success_2 or camera_max_zoom_distance ~= value_2 then
            if not (value_2 + ((camera_max_zoom_distance - value_2) / 2) < camera_to_subject_distance) then
                camera_max_zoom_distance = value_2
                continue
            end
            self:SetCameraToSubjectDistance(value_2)
            return
        end
        break
    end
    self:SetCameraToSubjectDistance(self.gamepadZoomLevels[#self.gamepadZoomLevels])
end

function base_camera.Enable(self, enabled)
    if self.enabled == enabled then
        return
    end
    self.enabled = enabled
    self:OnEnabledChanged()
end

function base_camera.OnEnabledChanged(self)
    if self.enabled then
        camera_input.setInputEnabled(true)
        self.gamepadZoomPressConnection = camera_input.gamepadZoomPress:Connect(function()
            self:GamepadZoomPress()
        end)
        if local_player.CameraMode == Enum.CameraMode.LockFirstPerson then
            self.currentSubjectDistance = 0.5
            if not self.inFirstPerson then
                self:EnterFirstPerson()
            end
        end
        if self.cameraChangedConn then
            self.cameraChangedConn:Disconnect()
            self.cameraChangedConn = nil
        end
        self.cameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            self:OnCurrentCameraChanged()
        end)
        self:OnCurrentCameraChanged()
    else
        camera_input.setInputEnabled(false)
        if self.gamepadZoomPressConnection then
            self.gamepadZoomPressConnection:Disconnect()
            self.gamepadZoomPressConnection = nil
        end
        self:Cleanup()
    end
end

function base_camera.GetEnabled(self)
    return self.enabled
end

function base_camera.Cleanup(self)
    if self.subjectStateChangedConn then
        self.subjectStateChangedConn:Disconnect()
        self.subjectStateChangedConn = nil
    end
    if self.viewportSizeChangedConn then
        self.viewportSizeChangedConn:Disconnect()
        self.viewportSizeChangedConn = nil
    end
    if self.cameraChangedConn then
        self.cameraChangedConn:Disconnect()
        self.cameraChangedConn = nil
    end
    self.lastCameraTransform = nil
    self.lastSubjectCFrame = nil
    camera_utils.restoreMouseBehavior()
end

function base_camera.UpdateMouseBehavior(self)
    local enabled = user_game_settings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove
    if not self.isCameraToggle or enabled ~= false then
        camera_ui.setCameraModeToastEnabled(false)
        camera_input.disableCameraToggleInput()
        if not self.inFirstPerson and not self.inMouseLockedMode then
            camera_utils.restoreRotationType()
            if camera_input.getRotationActivated() then
                camera_utils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCurrentPosition)
            else
                camera_utils.restoreMouseBehavior()
            end
            return
        end
        camera_utils.setRotationTypeOverride(Enum.RotationType.CameraRelative)
        camera_utils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter)
    end
    camera_ui.setCameraModeToastEnabled(true)
    camera_input.enableCameraToggleInput()
    camera_toggle_state_controller(self.inFirstPerson)
end

function base_camera.UpdateForDistancePropertyChange(self)
    self:SetCameraToSubjectDistance(self.currentSubjectDistance)
end

function base_camera.SetCameraToSubjectDistance(self, argument)
    local current_subject_distance = self.currentSubjectDistance
    local current_subject_distance_2 = nil
    if local_player.CameraMode ~= Enum.CameraMode.LockFirstPerson then
        current_subject_distance_2 =
            math.clamp(argument, local_player.CameraMinZoomDistance, local_player.CameraMaxZoomDistance)
        if current_subject_distance_2 < 1 then
            self.currentSubjectDistance = 0.5
            if not self.inFirstPerson then
                self:EnterFirstPerson()
            end
        else
            self.currentSubjectDistance = current_subject_distance_2
            if self.inFirstPerson then
                self:LeaveFirstPerson()
            end
        end
    else
        self.currentSubjectDistance = 0.5
        if not self.inFirstPerson then
            self:EnterFirstPerson()
        end
    end
    zoom_controller.SetZoomParameters(self.currentSubjectDistance, (math.sign(argument - current_subject_distance)))
    return self.currentSubjectDistance
end

function base_camera.SetCameraType(self, camera_type)
    self.cameraType = camera_type
end

function base_camera.GetCameraType(self)
    return self.cameraType
end

function base_camera.SetCameraMovementMode(self, camera_movement_mode)
    self.cameraMovementMode = camera_movement_mode
end

function base_camera.GetCameraMovementMode(self)
    return self.cameraMovementMode
end

function base_camera.SetIsMouseLocked(self, in_mouse_locked_mode)
    self.inMouseLockedMode = in_mouse_locked_mode
end

function base_camera.GetIsMouseLocked(self)
    return self.inMouseLockedMode
end

function base_camera.SetMouseLockOffset(self, mouse_lock_offset)
    self.mouseLockOffset = mouse_lock_offset
end

function base_camera.GetMouseLockOffset(self)
    return self.mouseLockOffset
end

function base_camera.InFirstPerson(self)
    return self.inFirstPerson
end

function base_camera.EnterFirstPerson(self)
    self.inFirstPerson = true
    self:UpdateMouseBehavior()
end

function base_camera.LeaveFirstPerson(self)
    self.inFirstPerson = false
    self:UpdateMouseBehavior()
end

function base_camera.GetCameraToSubjectDistance(self)
    return self.currentSubjectDistance
end

function base_camera.GetMeasuredDistanceToFocus(self)
    local current_camera = game.Workspace.CurrentCamera
    if current_camera then
        return (current_camera.CoordinateFrame.p - current_camera.Focus.p).magnitude
    end
    return nil
end

function base_camera.GetCameraLookVector(self)
    return (game.Workspace.CurrentCamera and game.Workspace.CurrentCamera.CFrame.LookVector) or Vector3.new(0, 0, 1)
end

function base_camera.CalculateNewLookCFrameFromArg(self, argument, argument_2)
    local camera_look_vector = argument or (self:GetCameraLookVector())
    local angle = math.asin(camera_look_vector.Y)
    local vector_3 =
        Vector2.new(argument_2.X, math.clamp(argument_2.Y, angle + -1.3962634015954636, angle + 1.3962634015954636))
    local cframe = CFrame.new(Vector3.new(0, 0, 0), camera_look_vector)
    return CFrame.Angles(0, -vector_3.X, 0) * cframe * CFrame.Angles(-vector_3.Y, 0, 0)
end

function base_camera.CalculateNewLookVectorFromArg(self, argument, argument_2)
    return self:CalculateNewLookCFrameFromArg(argument, argument_2).LookVector
end

function base_camera.CalculateNewLookVectorVRFromArg(self, argument)
    local subject_position = self:GetSubjectPosition()
    local vector_3 = Vector2.new(argument.X, 0)
    local cframe = CFrame.new(
        Vector3.new(0, 0, 0),
        ((subject_position - game.Workspace.CurrentCamera.CFrame.p) * Vector3.new(1, 0, 1)).unit
    )
    return ((CFrame.Angles(0, -vector_3.X, 0) * cframe * CFrame.Angles(-vector_3.Y, 0, 0)).LookVector * Vector3.new(
        1,
        0,
        1
    )).unit
end

function base_camera.GetHumanoid(self)
    local character
    if local_player then
        character = local_player.Character
    else
        character = local_player
    end
    if not character then
        return nil
    end
    local humanoid_cache_entry = self.humanoidCache[local_player]
    if humanoid_cache_entry and humanoid_cache_entry.Parent == character then
        return humanoid_cache_entry
    end
    self.humanoidCache[local_player] = nil
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        self.humanoidCache[local_player] = humanoid
    end
    return humanoid
end

function base_camera.GetHumanoidPartToFollow(self, argument, argument_2)
    if argument_2 ~= Enum.HumanoidStateType.Dead then
        return argument.Torso
    end
    local parent = argument.Parent
    if not parent then
        return argument.Torso
    end
    local head = parent:FindFirstChild("Head") or argument.Torso
    return head
end

function base_camera.OnNewCameraSubject(self)
    if not self.subjectStateChangedConn then
        return
    end
    self.subjectStateChangedConn:Disconnect()
    self.subjectStateChangedConn = nil
end

function base_camera.IsInFirstPerson(self)
    return self.inFirstPerson
end

function base_camera.Update(self, argument)
    error("BaseCamera:Update() This is a virtual function that should never be getting called.", 2)
end

function base_camera.GetCameraHeight(self)
    if vr_service.VREnabled and not self.inFirstPerson then
        return 0.25881904510252074 * self.currentSubjectDistance
    end
    return 0
end

return base_camera
