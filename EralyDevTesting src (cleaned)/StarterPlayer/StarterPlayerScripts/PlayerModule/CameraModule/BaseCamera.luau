local common_utils = script.Parent.Parent:WaitForChild("CommonUtils")
local flag_util = require(common_utils:WaitForChild("FlagUtil"))
local success, result = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserFixGamepadMaxZoom")
end)
local result_2 = success and result
local user_flag = flag_util.getUserFlag("UserFixCameraOffsetJitter2")
Vector2.new(0.2617993877991494, 0)
Vector2.new(0.7853981633974483, 0)
Vector2.new(0, 0)
local camera_utils = require(script.Parent:WaitForChild("CameraUtils"))
local zoom_controller = require(script.Parent:WaitForChild("ZoomController"))
local camera_toggle_state_controller = require(script.Parent:WaitForChild("CameraToggleStateController"))
local camera_input = require(script.Parent:WaitForChild("CameraInput"))
local camera_ui = require(script.Parent:WaitForChild("CameraUI"))
local players = game:GetService("Players")
local user_input_service = game:GetService("UserInputService")
game:GetService("StarterGui")
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
        if child_2:IsA("Tool") then
            argument.isAToolEquipped = true
        end
    end)

    instance.ChildRemoved:Connect(function(child_2)
        if child_2:IsA("Tool") then
            argument.isAToolEquipped = false
        end
    end)
end

function base_camera.GetHumanoidRootPart(argument)
    local humanoid = (not argument.humanoidRootPart and local_player.Character and true or false)
        and local_player.Character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        argument.humanoidRootPart = humanoid.RootPart
    end

    return argument.humanoidRootPart
end

function base_camera.GetBodyPartToFollow(argument: table, argument_2: userdata, argument_3: boolean)
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
    local workspace_current_camera = workspace.CurrentCamera

    if workspace_current_camera then
        workspace_current_camera = workspace_current_camera.CameraSubject
    end

    if not workspace_current_camera then
        return last_subject_c_frame
    end

    if workspace_current_camera:IsA("Humanoid") then
        local condition = workspace_current_camera:GetState() == Enum.HumanoidStateType.Dead
        local camera_offset = workspace_current_camera.CameraOffset

        if user_flag and argument:GetIsMouseLocked() then
            camera_offset = Vector3.new()
        end

        local root_part = workspace_current_camera.RootPart

        if condition and (workspace_current_camera.Parent and workspace_current_camera.Parent:IsA("Model")) then
            root_part = workspace_current_camera.Parent:FindFirstChild("Head") or root_part
        end

        if root_part and root_part:IsA("BasePart") then
            local vector

            if workspace_current_camera.RigType == Enum.HumanoidRigType.R15 then
                if workspace_current_camera.AutomaticScalingEnabled then
                    vector = Vector3.new(0, 1.5, 0)
                    local root_part2 = workspace_current_camera.RootPart

                    if root_part == root_part2 then
                        vector += Vector3.new(0, (root_part2.Size.Y - 2) / 2, 0)
                    end
                else
                    vector = Vector3.new(0, 2, 0)
                end
            else
                vector = Vector3.new(0, 1.5, 0)
            end

            last_subject_c_frame = root_part.CFrame
                * CFrame.new((condition and Vector3.new(0, 0, 0) or vector) + camera_offset)
        end
    elseif workspace_current_camera:IsA("BasePart") then
        last_subject_c_frame = workspace_current_camera.CFrame
    elseif workspace_current_camera:IsA("Model") then
        if workspace_current_camera.PrimaryPart then
            last_subject_c_frame = workspace_current_camera:GetPrimaryPartCFrame()
        else
            last_subject_c_frame = CFrame.new()
        end
    end

    if last_subject_c_frame then
        argument.lastSubjectCFrame = last_subject_c_frame
    end

    return last_subject_c_frame
end

function base_camera.GetSubjectVelocity(argument)
    local workspace_current_camera = workspace.CurrentCamera

    if workspace_current_camera then
        workspace_current_camera = workspace_current_camera.CameraSubject
    end

    if not workspace_current_camera then
        return Vector3.new(0, 0, 0)
    end

    if workspace_current_camera:IsA("BasePart") then
        return workspace_current_camera.Velocity
    end

    if workspace_current_camera:IsA("Humanoid") then
        local root_part = workspace_current_camera.RootPart

        if root_part then
            return root_part.Velocity
        end
    else
        local primary_part = workspace_current_camera:IsA("Model") and workspace_current_camera.PrimaryPart

        if primary_part then
            return primary_part.Velocity
        end
    end

    return Vector3.new(0, 0, 0)
end

function base_camera.GetSubjectRotVelocity(argument)
    local workspace_current_camera = workspace.CurrentCamera

    if workspace_current_camera then
        workspace_current_camera = workspace_current_camera.CameraSubject
    end

    if not workspace_current_camera then
        return Vector3.new(0, 0, 0)
    end

    if workspace_current_camera:IsA("BasePart") then
        return workspace_current_camera.RotVelocity
    end

    if workspace_current_camera:IsA("Humanoid") then
        local root_part = workspace_current_camera.RootPart

        if root_part then
            return root_part.RotVelocity
        end
    else
        local primary_part = workspace_current_camera:IsA("Model") and workspace_current_camera.PrimaryPart

        if primary_part then
            return primary_part.RotVelocity
        end
    end

    return Vector3.new(0, 0, 0)
end

function base_camera.StepZoom(argument)
    local current_subject_distance = argument.currentSubjectDistance
    local zoom_delta = camera_input.getZoomDelta()

    if math.abs(zoom_delta) > 0 then
        local maximum

        if zoom_delta > 0 then
            maximum = math.max(
                current_subject_distance + zoom_delta * (current_subject_distance * 0.5 + 1),
                argument.FIRST_PERSON_DISTANCE_THRESHOLD
            )
        else
            maximum = math.max((current_subject_distance + zoom_delta) / (1 - zoom_delta * 0.5), 0.5)
        end

        argument:SetCameraToSubjectDistance(maximum < argument.FIRST_PERSON_DISTANCE_THRESHOLD and 0.5 or maximum)
    end

    return zoom_controller.GetZoomRadius()
end

function base_camera.GetSubjectPosition(argument)
    local last_subject_position = argument.lastSubjectPosition
    local current_camera = game.Workspace.CurrentCamera

    if current_camera then
        current_camera = current_camera.CameraSubject
    end

    if not current_camera then
        return nil
    end

    if current_camera:IsA("Humanoid") then
        local condition = current_camera:GetState() == Enum.HumanoidStateType.Dead
        local camera_offset = current_camera.CameraOffset

        if user_flag and argument:GetIsMouseLocked() then
            camera_offset = Vector3.new()
        end

        local root_part = current_camera.RootPart

        if condition and (current_camera.Parent and current_camera.Parent:IsA("Model")) then
            root_part = current_camera.Parent:FindFirstChild("Head") or root_part
        end

        if root_part and root_part:IsA("BasePart") then
            local vector

            if current_camera.RigType == Enum.HumanoidRigType.R15 then
                if current_camera.AutomaticScalingEnabled then
                    vector = Vector3.new(0, 1.5, 0)

                    if root_part == current_camera.RootPart then
                        vector += Vector3.new(0, current_camera.RootPart.Size.Y / 2 - 1, 0)
                    end
                else
                    vector = Vector3.new(0, 2, 0)
                end
            else
                vector = Vector3.new(0, 1.5, 0)
            end

            last_subject_position = root_part.CFrame.p
                + root_part.CFrame:vectorToWorldSpace((condition and Vector3.new(0, 0, 0) or vector) + camera_offset)
        end
    elseif current_camera:IsA("VehicleSeat") then
        last_subject_position = current_camera.CFrame.p + current_camera.CFrame:vectorToWorldSpace(Vector3.new(0, 5, 0))
    elseif current_camera:IsA("SkateboardPlatform") then
        last_subject_position = current_camera.CFrame.p + Vector3.new(0, 5, 0)
    elseif current_camera:IsA("BasePart") then
        last_subject_position = current_camera.CFrame.p
    elseif current_camera:IsA("Model") then
        if current_camera.PrimaryPart then
            last_subject_position = current_camera:GetPrimaryPartCFrame().p
        else
            last_subject_position = current_camera:GetModelCFrame().p
        end
    end

    argument.lastSubject = current_camera
    argument.lastSubjectPosition = last_subject_position

    return last_subject_position
end

function base_camera.OnViewportSizeChanged(argument)
    local viewport_size = game.Workspace.CurrentCamera.ViewportSize
    argument.portraitMode = viewport_size.X < viewport_size.Y
    argument.isSmallTouchScreen = user_input_service.TouchEnabled
        and (viewport_size.Y < 500 and true or viewport_size.X < 700)
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

    if current_camera_2 then
        argument.cameraSubjectChangedConn = current_camera_2
            :GetPropertyChangedSignal("CameraSubject")
            :Connect(function()
                argument:OnNewCameraSubject()
            end)
        argument:OnNewCameraSubject()
    end
end

function base_camera.OnDynamicThumbstickEnabled(argument)
    if user_input_service.TouchEnabled then
        argument.isDynamicThumbstickEnabled = true
    end
end

function base_camera.OnDynamicThumbstickDisabled(argument)
    argument.isDynamicThumbstickEnabled = false
end

function base_camera.OnGameSettingsTouchMovementModeChanged(argument)
    if local_player.DevTouchMovementMode ~= Enum.DevTouchMovementMode.UserChoice then
        return
    end

    if
        user_game_settings.TouchMovementMode == Enum.TouchMovementMode.DynamicThumbstick
        or user_game_settings.TouchMovementMode == Enum.TouchMovementMode.Default
    then
        argument:OnDynamicThumbstickEnabled()

        return
    end

    argument:OnDynamicThumbstickDisabled()
end

function base_camera.OnDevTouchMovementModeChanged(argument)
    if local_player.DevTouchMovementMode == Enum.DevTouchMovementMode.DynamicThumbstick then
        argument:OnDynamicThumbstickEnabled()

        return
    end

    argument:OnGameSettingsTouchMovementModeChanged()
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

    for index = #argument.gamepadZoomLevels, 1, -1 do
        local gamepad_zoom_level_entry = argument.gamepadZoomLevels[index]
        local index_2

        if camera_max_zoom_distance < gamepad_zoom_level_entry then
            index_2 = index
        else
            if gamepad_zoom_level_entry < local_player.CameraMinZoomDistance then
                gamepad_zoom_level_entry = local_player.CameraMinZoomDistance

                if result_2 and camera_max_zoom_distance == gamepad_zoom_level_entry then
                    break
                end
            end

            if not result_2 and camera_max_zoom_distance == gamepad_zoom_level_entry then
                break
            end

            if
                gamepad_zoom_level_entry + (camera_max_zoom_distance - gamepad_zoom_level_entry) / 2
                < camera_to_subject_distance
            then
                argument:SetCameraToSubjectDistance(gamepad_zoom_level_entry)

                return
            end

            camera_max_zoom_distance = gamepad_zoom_level_entry
            index_2 = index
        end
    end

    argument:SetCameraToSubjectDistance(argument.gamepadZoomLevels[#argument.gamepadZoomLevels])
end

function base_camera.Enable(argument: table, enabled: boolean)
    if argument.enabled ~= enabled then
        argument.enabled = enabled
        argument:OnEnabledChanged()
    end
end

function base_camera.OnEnabledChanged(argument)
    if not argument.enabled then
        camera_input.setInputEnabled(false)

        if argument.gamepadZoomPressConnection then
            argument.gamepadZoomPressConnection:Disconnect()
            argument.gamepadZoomPressConnection = nil
        end

        argument:Cleanup()

        return
    end

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
    if
        argument.isCameraToggle
        and user_game_settings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove == false
    then
        camera_ui.setCameraModeToastEnabled(true)
        camera_input.enableCameraToggleInput()
        camera_toggle_state_controller(argument.inFirstPerson)

        return
    end

    camera_ui.setCameraModeToastEnabled(false)
    camera_input.disableCameraToggleInput()

    if argument.inFirstPerson or argument.inMouseLockedMode then
        camera_utils.setRotationTypeOverride(Enum.RotationType.CameraRelative)
        camera_utils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter)

        return
    end

    camera_utils.restoreRotationType()

    if camera_input.getRotationActivated() then
        camera_utils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCurrentPosition)

        return
    end

    camera_utils.restoreMouseBehavior()
end

function base_camera.UpdateForDistancePropertyChange(argument)
    argument:SetCameraToSubjectDistance(argument.currentSubjectDistance)
end

function base_camera.SetCameraToSubjectDistance(argument: table, argument_2: number)
    local current_subject_distance = argument.currentSubjectDistance

    if local_player.CameraMode == Enum.CameraMode.LockFirstPerson then
        argument.currentSubjectDistance = 0.5

        if not argument.inFirstPerson then
            argument:EnterFirstPerson()
        end
    else
        local current_subject_distance_2 =
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

function base_camera.SetIsMouseLocked(argument: table, in_mouse_locked_mode: boolean)
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
    return game.Workspace.CurrentCamera and game.Workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, 1)
end

function base_camera.CalculateNewLookCFrameFromArg(argument: table, argument_2: vector?, argument_3)
    local camera_look_vector = argument_2 or argument:GetCameraLookVector()
    local angle = math.asin(camera_look_vector.Y)
    local clamped_value = math.clamp(argument_3.Y, angle + -1.3962634015954636, angle + 1.3962634015954636)
    local vector = Vector2.new(argument_3.X, clamped_value)
    local cframe = CFrame.new(Vector3.new(0, 0, 0), camera_look_vector)

    return CFrame.Angles(0, -vector.X, 0) * cframe * CFrame.Angles(-vector.Y, 0, 0)
end

function base_camera.CalculateNewLookVectorFromArg(argument: table, argument_2: vector?, argument_3)
    return argument:CalculateNewLookCFrameFromArg(argument_2, argument_3).LookVector
end

function base_camera.CalculateNewLookVectorVRFromArg(argument: table, argument_2)
    local unit = ((argument:GetSubjectPosition() - game.Workspace.CurrentCamera.CFrame.p) * Vector3.new(1, 0, 1)).unit
    local vector = Vector2.new(argument_2.X, 0)
    local cframe = CFrame.new(Vector3.new(0, 0, 0), unit)

    return (
        (CFrame.Angles(0, -vector.X, 0) * cframe * CFrame.Angles(-vector.Y, 0, 0)).LookVector * Vector3.new(1, 0, 1)
    ).unit
end

function base_camera.GetHumanoid(argument)
    local character = local_player and local_player.Character

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

function base_camera.GetHumanoidPartToFollow(argument: table, argument_2: userdata, argument_3: any)
    if argument_3 ~= Enum.HumanoidStateType.Dead then
        return argument_2.Torso
    end

    local parent = argument_2.Parent

    if parent then
        return parent:FindFirstChild("Head") or argument_2.Torso
    end

    return argument_2.Torso
end

function base_camera.OnNewCameraSubject(argument)
    if argument.subjectStateChangedConn then
        argument.subjectStateChangedConn:Disconnect()
        argument.subjectStateChangedConn = nil
    end
end

function base_camera.IsInFirstPerson(argument)
    return argument.inFirstPerson
end

function base_camera.Update(argument, argument_2)
    error("BaseCamera:Update() This is a virtual function that should never be getting called.", 2)
end

function base_camera.GetCameraHeight(argument)
    return (not vr_service.VREnabled or argument.inFirstPerson) and 0
        or 0.25881904510252074 * argument.currentSubjectDistance
end

return base_camera
