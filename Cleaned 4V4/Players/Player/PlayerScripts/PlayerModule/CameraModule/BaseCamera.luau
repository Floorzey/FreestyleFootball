local flag_util = require(script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil"))
local success, value = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserFixGamepadMaxZoom")
end)
local value_2 = success and value
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

function base_camera.GetModuleName(argument)
    return "BaseCamera"
end

function base_camera.OnCharacterAdded(argument, instance)
    argument.resetCameraAngle = argument.resetCameraAngle or argument:GetEnabled()
    argument.humanoidRootPart = nil

    if not user_input_service.TouchEnabled then
        return
    end

    argument.PlayerGui = local_player:WaitForChild("PlayerGui")

    for _, child in ipairs(instance:GetChildren()) do
        if child:IsA("Tool") then
            argument.isAToolEquipped = true
        end
    end

    instance.ChildAdded:Connect(function(child_2)
        if not child_2:IsA("Tool") then
            return
        end

        argument.isAToolEquipped = true
    end)

    instance.ChildRemoved:Connect(function(child_2)
        if not child_2:IsA("Tool") then
            return
        end

        argument.isAToolEquipped = false
    end)
end

function base_camera.GetHumanoidRootPart(argument)
    if not argument.humanoidRootPart and local_player.Character then
        local humanoid = local_player.Character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            argument.humanoidRootPart = humanoid.RootPart
        end
    end

    return argument.humanoidRootPart
end

function base_camera.GetBodyPartToFollow(argument, argument_2, argument_3)
    if argument_2:GetState() == Enum.HumanoidStateType.Dead then
        local parent = argument_2.Parent

        if parent and parent:IsA("Model") then
            return parent:FindFirstChild("Head") or argument_2.RootPart
        end
    end

    return argument_2.RootPart
end

function base_camera.GetSubjectCFrame(argument)
    local last_subject_c_frame = argument.lastSubjectCFrame
    local current_camera = workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject

    if camera_subject then
        if camera_subject:IsA("Humanoid") then
            current_camera = camera_subject:GetState() == Enum.HumanoidStateType.Dead
            local camera_offset = current_camera.CameraOffset

            if get_user_flag_result and argument:GetIsMouseLocked() then
                local _ = Vector3.new()
            end

            local root_part = current_camera.RootPart

            if current_camera and current_camera.Parent then
                local is_a_result = current_camera.Parent:IsA("Model")
                root_part = is_a_result and (current_camera.Parent:FindFirstChild("Head") or root_part)
            end

            if root_part then
                local is_a_result_2 = root_part:IsA("BasePart")

                if is_a_result_2 then
                    if current_camera.RigType ~= Enum.HumanoidRigType.R15 then
                        is_a_result_2 = Vector3.new(0, 1.5, 0)
                    else
                        local value_3 = nil

                        if current_camera.AutomaticScalingEnabled then
                            is_a_result_2 = Vector3.new(0, 1.5, 0)
                            value_3 = current_camera.RootPart

                            if root_part == value_3 then
                                is_a_result_2 += Vector3.new(0, (value_3.Size.Y - 2) / 2, 0)
                            end
                        else
                            is_a_result_2 = Vector3.new(0, 2, 0)
                        end
                    end

                    last_subject_c_frame = root_part.CFrame
                        * CFrame.new(((current_camera and Vector3.new(0, 0, 0)) or is_a_result_2) + camera_offset)
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
            argument.lastSubjectCFrame = last_subject_c_frame
        end
    end

    return last_subject_c_frame
end

function base_camera.GetSubjectVelocity(argument)
    local current_camera = workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject

    if not camera_subject then
        return Vector3.new(0, 0, 0)
    end

    if camera_subject:IsA("BasePart") then
        return camera_subject.Velocity
    end

    local value_3 = nil

    if camera_subject:IsA("Humanoid") then
        value_3 = camera_subject.RootPart

        if value_3 then
            return value_3.Velocity
        end
    elseif camera_subject:IsA("Model") then
        local primary_part = camera_subject.PrimaryPart

        if primary_part then
            return primary_part.Velocity
        end
    end

    return Vector3.new(0, 0, 0)
end

function base_camera.GetSubjectRotVelocity(argument)
    local current_camera = workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject

    if not camera_subject then
        return Vector3.new(0, 0, 0)
    end

    if camera_subject:IsA("BasePart") then
        return camera_subject.RotVelocity
    end

    local value_3 = nil

    if camera_subject:IsA("Humanoid") then
        value_3 = camera_subject.RootPart

        if value_3 then
            return value_3.RotVelocity
        end
    elseif camera_subject:IsA("Model") then
        local primary_part = camera_subject.PrimaryPart

        if primary_part then
            return primary_part.RotVelocity
        end
    end

    return Vector3.new(0, 0, 0)
end

function base_camera.StepZoom(argument)
    local current_subject_distance = argument.currentSubjectDistance
    local get_zoom_delta_result = camera_input.getZoomDelta()

    if math.abs(get_zoom_delta_result) > 0 then
        local maximum

        if get_zoom_delta_result > 0 then
            maximum = math.max(
                current_subject_distance + (get_zoom_delta_result * ((current_subject_distance * 0.5) + 1)),
                argument.FIRST_PERSON_DISTANCE_THRESHOLD
            )
        else
            maximum =
                math.max((current_subject_distance + get_zoom_delta_result) / (1 - (get_zoom_delta_result * 0.5)), 0.5)
        end

        if maximum < argument.FIRST_PERSON_DISTANCE_THRESHOLD then
            maximum = 0.5
        end

        argument:SetCameraToSubjectDistance(maximum)
    end

    return zoom_controller.GetZoomRadius()
end

function base_camera.GetSubjectPosition(argument)
    local last_subject_position = argument.lastSubjectPosition
    local current_camera = game.Workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject

    if not camera_subject then
        return nil
    end

    if camera_subject:IsA("Humanoid") then
        current_camera = camera_subject:GetState() == Enum.HumanoidStateType.Dead
        local camera_offset = current_camera.CameraOffset

        if get_user_flag_result and argument:GetIsMouseLocked() then
            local _ = Vector3.new()
        end

        local root_part = current_camera.RootPart

        if current_camera and current_camera.Parent then
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
                        ((current_camera and Vector3.new(0, 0, 0)) or is_a_result_2) + camera_offset
                    )
            end
        end
    elseif camera_subject:IsA("VehicleSeat") then
        last_subject_position = camera_subject.CFrame.p + camera_subject.CFrame:vectorToWorldSpace(Vector3.new(0, 5, 0))
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

    argument.lastSubject = current_camera
    argument.lastSubjectPosition = last_subject_position

    return last_subject_position
end

function base_camera.OnViewportSizeChanged(argument)
    local viewport_size = game.Workspace.CurrentCamera.ViewportSize
    argument.portraitMode = viewport_size.X < viewport_size.Y
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

    argument.isSmallTouchScreen = is_small_touch_screen
end

function base_camera.OnCurrentCameraChanged(argument)
    if user_input_service.TouchEnabled then
        if argument.viewportSizeChangedConn then
            argument.viewportSizeChangedConn:Disconnect()
            argument.viewportSizeChangedConn = nil
        end

        local current_camera = game.Workspace.CurrentCamera

        if current_camera then
            argument:OnViewportSizeChanged()
            argument.viewportSizeChangedConn = current_camera
                :GetPropertyChangedSignal("ViewportSize")
                :Connect(function()
                    argument:OnViewportSizeChanged()
                end)
        end
    end

    if argument.cameraSubjectChangedConn then
        argument.cameraSubjectChangedConn:Disconnect()
        argument.cameraSubjectChangedConn = nil
    end

    local current_camera_2 = game.Workspace.CurrentCamera

    if not current_camera_2 then
        return
    end

    argument.cameraSubjectChangedConn = current_camera_2:GetPropertyChangedSignal("CameraSubject"):Connect(function()
        argument:OnNewCameraSubject()
    end)
    argument:OnNewCameraSubject()
end

function base_camera.OnDynamicThumbstickEnabled(argument)
    if not user_input_service.TouchEnabled then
        return
    end

    argument.isDynamicThumbstickEnabled = true
end

function base_camera.OnDynamicThumbstickDisabled(argument)
    argument.isDynamicThumbstickEnabled = false
end

function base_camera.OnGameSettingsTouchMovementModeChanged(argument)
    if local_player.DevTouchMovementMode ~= Enum.DevTouchMovementMode.UserChoice then
        return
    end

    if
        user_game_settings.TouchMovementMode ~= Enum.TouchMovementMode.DynamicThumbstick
        and user_game_settings.TouchMovementMode ~= Enum.TouchMovementMode.Default
    then
        argument:OnDynamicThumbstickDisabled()

        return
    end

    argument:OnDynamicThumbstickEnabled()
end

function base_camera.OnDevTouchMovementModeChanged(argument)
    if local_player.DevTouchMovementMode ~= Enum.DevTouchMovementMode.DynamicThumbstick then
        argument:OnGameSettingsTouchMovementModeChanged()
    else
        argument:OnDynamicThumbstickEnabled()
    end
end

function base_camera.OnPlayerCameraPropertyChange(argument)
    argument:SetCameraToSubjectDistance(argument.currentSubjectDistance)
end

function base_camera.InputTranslationToCameraAngleChange(argument, argument_2, argument_3)
    return argument_2 * argument_3
end

function base_camera.GamepadZoomPress(argument)
    local camera_to_subject_distance = argument:GetCameraToSubjectDistance()
    local camera_max_zoom_distance = local_player.CameraMaxZoomDistance
    local value_3 = nil

    for n = #argument.gamepadZoomLevels, 1, -1 do
        value_3 = argument.gamepadZoomLevels[n]

        if camera_max_zoom_distance < value_3 then
            continue
        end

        if value_3 < local_player.CameraMinZoomDistance then
            local camera_min_zoom_distance = local_player.CameraMinZoomDistance

            if value_2 and camera_max_zoom_distance == camera_min_zoom_distance then
                break
            end

            value_3 = camera_min_zoom_distance
        end

        if value_2 or camera_max_zoom_distance ~= value_3 then
            if not (value_3 + ((camera_max_zoom_distance - value_3) / 2) < camera_to_subject_distance) then
                camera_max_zoom_distance = value_3
                continue
            end

            argument:SetCameraToSubjectDistance(value_3)

            return
        end

        break
    end

    argument:SetCameraToSubjectDistance(argument.gamepadZoomLevels[#argument.gamepadZoomLevels])
end

function base_camera.Enable(argument, enabled)
    if argument.enabled == enabled then
        return
    end

    argument.enabled = enabled
    argument:OnEnabledChanged()
end

function base_camera.OnEnabledChanged(argument)
    if argument.enabled then
        camera_input.setInputEnabled(true)
        argument.gamepadZoomPressConnection = camera_input.gamepadZoomPress:Connect(function()
            argument:GamepadZoomPress()
        end)

        if local_player.CameraMode == Enum.CameraMode.LockFirstPerson then
            argument.currentSubjectDistance = 0.5

            if not argument.inFirstPerson then
                argument:EnterFirstPerson()
            end
        end

        if argument.cameraChangedConn then
            argument.cameraChangedConn:Disconnect()
            argument.cameraChangedConn = nil
        end

        argument.cameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            argument:OnCurrentCameraChanged()
        end)
        argument:OnCurrentCameraChanged()
    else
        camera_input.setInputEnabled(false)

        if argument.gamepadZoomPressConnection then
            argument.gamepadZoomPressConnection:Disconnect()
            argument.gamepadZoomPressConnection = nil
        end

        argument:Cleanup()
    end
end

function base_camera.GetEnabled(argument)
    return argument.enabled
end

function base_camera.Cleanup(argument)
    if argument.subjectStateChangedConn then
        argument.subjectStateChangedConn:Disconnect()
        argument.subjectStateChangedConn = nil
    end

    if argument.viewportSizeChangedConn then
        argument.viewportSizeChangedConn:Disconnect()
        argument.viewportSizeChangedConn = nil
    end

    if argument.cameraChangedConn then
        argument.cameraChangedConn:Disconnect()
        argument.cameraChangedConn = nil
    end

    argument.lastCameraTransform = nil
    argument.lastSubjectCFrame = nil
    camera_utils.restoreMouseBehavior()
end

function base_camera.UpdateMouseBehavior(argument)
    local enabled = user_game_settings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove

    if not argument.isCameraToggle or enabled ~= false then
        camera_ui.setCameraModeToastEnabled(false)
        camera_input.disableCameraToggleInput()

        if not argument.inFirstPerson and not argument.inMouseLockedMode then
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
    camera_toggle_state_controller(argument.inFirstPerson)
end

function base_camera.UpdateForDistancePropertyChange(argument)
    argument:SetCameraToSubjectDistance(argument.currentSubjectDistance)
end

function base_camera.SetCameraToSubjectDistance(argument, argument_2)
    local current_subject_distance = argument.currentSubjectDistance
    local current_subject_distance_2 = nil

    if local_player.CameraMode ~= Enum.CameraMode.LockFirstPerson then
        current_subject_distance_2 =
            math.clamp(argument_2, local_player.CameraMinZoomDistance, local_player.CameraMaxZoomDistance)

        if current_subject_distance_2 < 1 then
            argument.currentSubjectDistance = 0.5

            if not argument.inFirstPerson then
                argument:EnterFirstPerson()
            end
        else
            argument.currentSubjectDistance = current_subject_distance_2

            if argument.inFirstPerson then
                argument:LeaveFirstPerson()
            end
        end
    else
        argument.currentSubjectDistance = 0.5

        if not argument.inFirstPerson then
            argument:EnterFirstPerson()
        end
    end

    zoom_controller.SetZoomParameters(
        argument.currentSubjectDistance,
        (math.sign(argument_2 - current_subject_distance))
    )

    return argument.currentSubjectDistance
end

function base_camera.SetCameraType(argument, camera_type)
    argument.cameraType = camera_type
end

function base_camera.GetCameraType(argument)
    return argument.cameraType
end

function base_camera.SetCameraMovementMode(argument, camera_movement_mode)
    argument.cameraMovementMode = camera_movement_mode
end

function base_camera.GetCameraMovementMode(argument)
    return argument.cameraMovementMode
end

function base_camera.SetIsMouseLocked(argument, in_mouse_locked_mode)
    argument.inMouseLockedMode = in_mouse_locked_mode
end

function base_camera.GetIsMouseLocked(argument)
    return argument.inMouseLockedMode
end

function base_camera.SetMouseLockOffset(argument, mouse_lock_offset)
    argument.mouseLockOffset = mouse_lock_offset
end

function base_camera.GetMouseLockOffset(argument)
    return argument.mouseLockOffset
end

function base_camera.InFirstPerson(argument)
    return argument.inFirstPerson
end

function base_camera.EnterFirstPerson(argument)
    argument.inFirstPerson = true
    argument:UpdateMouseBehavior()
end

function base_camera.LeaveFirstPerson(argument)
    argument.inFirstPerson = false
    argument:UpdateMouseBehavior()
end

function base_camera.GetCameraToSubjectDistance(argument)
    return argument.currentSubjectDistance
end

function base_camera.GetMeasuredDistanceToFocus(argument)
    local current_camera = game.Workspace.CurrentCamera

    if current_camera then
        return (current_camera.CoordinateFrame.p - current_camera.Focus.p).magnitude
    end

    return nil
end

function base_camera.GetCameraLookVector(argument)
    return (game.Workspace.CurrentCamera and game.Workspace.CurrentCamera.CFrame.LookVector) or Vector3.new(0, 0, 1)
end

function base_camera.CalculateNewLookCFrameFromArg(argument, argument_2, argument_3)
    local camera_look_vector = argument_2 or argument:GetCameraLookVector()
    local angle = math.asin(camera_look_vector.Y)
    angle = Vector2.new(argument_3.X, math.clamp(argument_3.Y, angle + -1.3962634015954636, angle + 1.3962634015954636))
    local cframe = CFrame.new(Vector3.new(0, 0, 0), camera_look_vector)

    return CFrame.Angles(0, -angle.X, 0) * cframe * CFrame.Angles(-angle.Y, 0, 0)
end

function base_camera.CalculateNewLookVectorFromArg(argument, argument_2, argument_3)
    return argument:CalculateNewLookCFrameFromArg(argument_2, argument_3).LookVector
end

function base_camera.CalculateNewLookVectorVRFromArg(argument, argument_2)
    local subject_position = argument:GetSubjectPosition()
    local vector_3 = Vector2.new(argument_2.X, 0)
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

function base_camera.GetHumanoid(argument)
    local character

    if local_player then
        character = local_player.Character
    else
        character = local_player
    end

    if not character then
        return nil
    end

    local humanoid_cache_entry = argument.humanoidCache[local_player]

    if humanoid_cache_entry and humanoid_cache_entry.Parent == character then
        return humanoid_cache_entry
    end

    argument.humanoidCache[local_player] = nil
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        argument.humanoidCache[local_player] = humanoid
    end

    return humanoid
end

function base_camera.GetHumanoidPartToFollow(argument, argument_2, argument_3)
    if argument_3 ~= Enum.HumanoidStateType.Dead then
        return argument_2.Torso
    end

    local parent = argument_2.Parent

    if not parent then
        return argument_2.Torso
    end

    return parent:FindFirstChild("Head") or argument_2.Torso
end

function base_camera.OnNewCameraSubject(argument)
    if not argument.subjectStateChangedConn then
        return
    end

    argument.subjectStateChangedConn:Disconnect()
    argument.subjectStateChangedConn = nil
end

function base_camera.IsInFirstPerson(argument)
    return argument.inFirstPerson
end

function base_camera.Update(argument, argument_2)
    error("BaseCamera:Update() This is a virtual function that should never be getting called.", 2)
end

function base_camera.GetCameraHeight(argument)
    if vr_service.VREnabled and not argument.inFirstPerson then
        return 0.25881904510252074 * argument.currentSubjectDistance
    end

    return 0
end

return base_camera
