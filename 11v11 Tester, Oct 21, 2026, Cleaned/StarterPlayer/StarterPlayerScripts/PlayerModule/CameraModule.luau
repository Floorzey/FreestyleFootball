local values = {}
values.__index = values
local values_2 = {
    "CameraMinZoomDistance",
    "CameraMaxZoomDistance",
    "CameraMode",
    "DevCameraOcclusionMode",
    "DevComputerCameraMode",
    "DevTouchCameraMode",
    "DevComputerMovementMode",
    "DevTouchMovementMode",
    "DevEnableMouseLock",
}
local values_3 = {
    "ComputerCameraMovementMode",
    "ComputerMovementMode",
    "ControlMode",
    "GamepadCameraSensitivity",
    "MouseSensitivity",
    "RotationType",
    "TouchCameraMovementMode",
    "TouchMovementMode",
}
local players = game:GetService("Players")
local run_service = game:GetService("RunService")
local user_input_service = game:GetService("UserInputService")
local vr_service = game:GetService("VRService")
local user_game_settings = UserSettings():GetService("UserGameSettings")
local camera_utils = require(script:WaitForChild("CameraUtils"))
local camera_input = require(script:WaitForChild("CameraInput"))
local classic_camera = require(script:WaitForChild("ClassicCamera"))
local orbital_camera = require(script:WaitForChild("OrbitalCamera"))
local legacy_camera = require(script:WaitForChild("LegacyCamera"))
local vehicle_camera = require(script:WaitForChild("VehicleCamera"))
local vr_camera = require(script:WaitForChild("VRCamera"))
local vr_vehicle_camera = require(script:WaitForChild("VRVehicleCamera"))
local invisicam = require(script:WaitForChild("Invisicam"))
local poppercam = require(script:WaitForChild("Poppercam"))
local transparency_controller = require(script:WaitForChild("TransparencyController"))
local mouse_lock_controller = require(script:WaitForChild("MouseLockController"))
local values_4 = {}
local values_5 = {}
local player_scripts = players.LocalPlayer:WaitForChild("PlayerScripts")
player_scripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Default)
player_scripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Follow)
player_scripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Classic)
player_scripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Default)
player_scripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Follow)
player_scripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Classic)
player_scripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.CameraToggle)

function values.new()
    local instance = setmetatable({}, values)
    instance.activeCameraController = nil
    instance.activeOcclusionModule = nil
    instance.activeTransparencyController = nil
    instance.activeMouseLockController = nil
    instance.currentComputerCameraMovementMode = nil
    instance.cameraSubjectChangedConn = nil
    instance.cameraTypeChangedConn = nil

    for _, player in pairs(players:GetPlayers()) do
        instance:OnPlayerAdded(player)
    end

    players.PlayerAdded:Connect(function(player_2)
        instance:OnPlayerAdded(player_2)
    end)

    instance.activeTransparencyController = transparency_controller.new()
    instance.activeTransparencyController:Enable(true)

    if not user_input_service.TouchEnabled then
        instance.activeMouseLockController = mouse_lock_controller.new()
        local bindable_toggle_event = instance.activeMouseLockController:GetBindableToggleEvent()

        if bindable_toggle_event then
            bindable_toggle_event:Connect(function()
                instance:OnMouseLockToggled()
            end)
        end
    end

    instance:ActivateCameraController(instance:GetCameraControlChoice())
    instance:ActivateOcclusionModule(players.LocalPlayer.DevCameraOcclusionMode)
    instance:OnCurrentCameraChanged()

    run_service:BindToRenderStep("cameraRenderUpdate", Enum.RenderPriority.Camera.Value, function(delta_time)
        instance:Update(delta_time)
    end)

    for _, property_name in pairs(values_2) do
        players.LocalPlayer:GetPropertyChangedSignal(property_name):Connect(function()
            instance:OnLocalPlayerCameraPropertyChanged(property_name)
        end)
    end

    for _, property_name_2 in pairs(values_3) do
        user_game_settings:GetPropertyChangedSignal(property_name_2):Connect(function()
            instance:OnUserGameSettingsPropertyChanged(property_name_2)
        end)
    end

    game.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        instance:OnCurrentCameraChanged()
    end)

    return instance
end

function values.GetCameraMovementModeFromSettings(argument)
    if players.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        return camera_utils.ConvertCameraModeEnumToStandard(Enum.ComputerCameraMovementMode.Classic)
    end

    local convert_camera_mode_enum_to_standard_result, convert_camera_mode_enum_to_standard_result_2

    if user_input_service.TouchEnabled then
        convert_camera_mode_enum_to_standard_result =
            camera_utils.ConvertCameraModeEnumToStandard(players.LocalPlayer.DevTouchCameraMode)
        convert_camera_mode_enum_to_standard_result_2 =
            camera_utils.ConvertCameraModeEnumToStandard(user_game_settings.TouchCameraMovementMode)
    else
        convert_camera_mode_enum_to_standard_result =
            camera_utils.ConvertCameraModeEnumToStandard(players.LocalPlayer.DevComputerCameraMode)
        convert_camera_mode_enum_to_standard_result_2 =
            camera_utils.ConvertCameraModeEnumToStandard(user_game_settings.ComputerCameraMovementMode)
    end

    if convert_camera_mode_enum_to_standard_result == Enum.DevComputerCameraMovementMode.UserChoice then
        return convert_camera_mode_enum_to_standard_result_2
    end

    return convert_camera_mode_enum_to_standard_result
end

function values.ActivateOcclusionModule(argument, occlusion_mode)
    local poppercam_2

    if occlusion_mode == Enum.DevCameraOcclusionMode.Zoom then
        poppercam_2 = poppercam
    else
        if occlusion_mode ~= Enum.DevCameraOcclusionMode.Invisicam then
            warn("CameraScript ActivateOcclusionModule called with unsupported mode")

            return
        end

        poppercam_2 = invisicam
    end

    argument.occlusionMode = occlusion_mode

    if argument.activeOcclusionModule and argument.activeOcclusionModule:GetOcclusionMode() == occlusion_mode then
        if not argument.activeOcclusionModule:GetEnabled() then
            argument.activeOcclusionModule:Enable(true)
        end

        return
    end

    local active_occlusion_module = argument.activeOcclusionModule
    argument.activeOcclusionModule = values_5[poppercam_2]

    if not argument.activeOcclusionModule then
        argument.activeOcclusionModule = poppercam_2.new()

        if argument.activeOcclusionModule then
            values_5[poppercam_2] = argument.activeOcclusionModule
        end
    end

    if not argument.activeOcclusionModule then
        return
    end

    if argument.activeOcclusionModule:GetOcclusionMode() ~= occlusion_mode then
        warn(
            "CameraScript ActivateOcclusionModule mismatch: ",
            argument.activeOcclusionModule:GetOcclusionMode(),
            "~=",
            occlusion_mode
        )
    end

    if active_occlusion_module then
        if active_occlusion_module == argument.activeOcclusionModule then
            warn("CameraScript ActivateOcclusionModule failure to detect already running correct module")
        else
            active_occlusion_module:Enable(false)
        end
    end

    if occlusion_mode == Enum.DevCameraOcclusionMode.Invisicam then
        if players.LocalPlayer.Character then
            argument.activeOcclusionModule:CharacterAdded(players.LocalPlayer.Character, players.LocalPlayer)
        end
    else
        for _, player in pairs(players:GetPlayers()) do
            if player and player.Character then
                argument.activeOcclusionModule:CharacterAdded(player.Character, player)
            end
        end

        argument.activeOcclusionModule:OnCameraSubjectChanged(game.Workspace.CurrentCamera.CameraSubject)
    end

    argument.activeOcclusionModule:Enable(true)
end

function values.ShouldUseVehicleCamera(argument)
    local workspace_current_camera = workspace.CurrentCamera

    if not workspace_current_camera then
        return false
    end

    local camera_type = workspace_current_camera.CameraType
    local camera_subject = workspace_current_camera.CameraSubject
    local condition = camera_type == Enum.CameraType.Custom and true or camera_type == Enum.CameraType.Follow
    local result = camera_subject and camera_subject:IsA("VehicleSeat") or false
    local condition_2 = argument.occlusionMode ~= Enum.DevCameraOcclusionMode.Invisicam

    if result then
        if not condition then
            condition_2 = condition
        end
    else
        condition_2 = result
    end

    return condition_2
end

function values.ActivateCameraController(argument, camera_movement_mode_from_settings, argument_2)
    local value = nil

    if argument_2 ~= nil then
        if argument_2 == Enum.CameraType.Scriptable then
            if argument.activeCameraController then
                argument.activeCameraController:Enable(false)
                argument.activeCameraController = nil
            end

            return
        end

        if argument_2 == Enum.CameraType.Custom then
            camera_movement_mode_from_settings = argument:GetCameraMovementModeFromSettings()
        elseif argument_2 == Enum.CameraType.Track then
            camera_movement_mode_from_settings = Enum.ComputerCameraMovementMode.Classic
        elseif argument_2 == Enum.CameraType.Follow then
            camera_movement_mode_from_settings = Enum.ComputerCameraMovementMode.Follow
        elseif argument_2 == Enum.CameraType.Orbital then
            camera_movement_mode_from_settings = Enum.ComputerCameraMovementMode.Orbital
        elseif
            argument_2 == Enum.CameraType.Attach
            or (argument_2 == Enum.CameraType.Watch or argument_2 == Enum.CameraType.Fixed)
        then
            value = legacy_camera
        else
            warn("CameraScript encountered an unhandled Camera.CameraType value: ", argument_2)
        end
    end

    if not value then
        if vr_service.VREnabled then
            value = vr_camera
        elseif
            camera_movement_mode_from_settings == Enum.ComputerCameraMovementMode.Classic
            or (
                camera_movement_mode_from_settings == Enum.ComputerCameraMovementMode.Follow
                or (
                    camera_movement_mode_from_settings == Enum.ComputerCameraMovementMode.Default
                    or camera_movement_mode_from_settings == Enum.ComputerCameraMovementMode.CameraToggle
                )
            )
        then
            value = classic_camera
        else
            if camera_movement_mode_from_settings ~= Enum.ComputerCameraMovementMode.Orbital then
                warn("ActivateCameraController did not select a module.")

                return
            end

            value = orbital_camera
        end
    end

    if argument:ShouldUseVehicleCamera() then
        if vr_service.VREnabled then
            value = vr_vehicle_camera
        else
            value = vehicle_camera
        end
    end

    local active_camera_controller

    if values_4[value] then
        active_camera_controller = values_4[value]

        if active_camera_controller.Reset then
            active_camera_controller:Reset()
        end
    else
        active_camera_controller = value.new()
        values_4[value] = active_camera_controller
    end

    if argument.activeCameraController then
        if argument.activeCameraController == active_camera_controller then
            if not argument.activeCameraController:GetEnabled() then
                argument.activeCameraController:Enable(true)
            end
        else
            argument.activeCameraController:Enable(false)
            argument.activeCameraController = active_camera_controller
            argument.activeCameraController:Enable(true)
        end
    elseif active_camera_controller ~= nil then
        argument.activeCameraController = active_camera_controller
        argument.activeCameraController:Enable(true)
    end

    if not argument.activeCameraController then
        return
    end

    if camera_movement_mode_from_settings ~= nil then
        argument.activeCameraController:SetCameraMovementMode(camera_movement_mode_from_settings)

        return
    end

    if argument_2 ~= nil then
        argument.activeCameraController:SetCameraType(argument_2)
    end
end

function values.OnCameraSubjectChanged(argument)
    local workspace_current_camera = workspace.CurrentCamera
    local camera_subject

    if workspace_current_camera then
        camera_subject = workspace_current_camera.CameraSubject
    else
        camera_subject = workspace_current_camera
    end

    if argument.activeTransparencyController then
        argument.activeTransparencyController:SetSubject(camera_subject)
    end

    if argument.activeOcclusionModule then
        argument.activeOcclusionModule:OnCameraSubjectChanged(camera_subject)
    end

    argument:ActivateCameraController(nil, workspace_current_camera.CameraType)
end

function values.OnCameraTypeChanged(argument, argument_2)
    if
        argument_2 == Enum.CameraType.Scriptable
        and user_input_service.MouseBehavior == Enum.MouseBehavior.LockCenter
    then
        camera_utils.restoreMouseBehavior()
    end

    argument:ActivateCameraController(nil, argument_2)
end

function values.OnCurrentCameraChanged(argument)
    local current_camera = game.Workspace.CurrentCamera

    if not current_camera then
        return
    end

    if argument.cameraSubjectChangedConn then
        argument.cameraSubjectChangedConn:Disconnect()
    end

    if argument.cameraTypeChangedConn then
        argument.cameraTypeChangedConn:Disconnect()
    end

    argument.cameraSubjectChangedConn = current_camera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
        argument:OnCameraSubjectChanged(current_camera.CameraSubject)
    end)
    argument.cameraTypeChangedConn = current_camera:GetPropertyChangedSignal("CameraType"):Connect(function()
        argument:OnCameraTypeChanged(current_camera.CameraType)
    end)
    argument:OnCameraSubjectChanged(current_camera.CameraSubject)
    argument:OnCameraTypeChanged(current_camera.CameraType)
end

function values.OnLocalPlayerCameraPropertyChanged(argument: table, argument_2: string)
    if argument_2 == "CameraMode" then
        if players.LocalPlayer.CameraMode ~= Enum.CameraMode.LockFirstPerson then
            if players.LocalPlayer.CameraMode ~= Enum.CameraMode.Classic then
                warn("Unhandled value for property player.CameraMode: ", players.LocalPlayer.CameraMode)

                return
            end

            local camera_movement_mode_from_settings = argument:GetCameraMovementModeFromSettings()
            argument:ActivateCameraController(
                camera_utils.ConvertCameraModeEnumToStandard(camera_movement_mode_from_settings)
            )

            return
        end

        if
            not argument.activeCameraController
            or argument.activeCameraController:GetModuleName() ~= "ClassicCamera"
        then
            argument:ActivateCameraController(
                camera_utils.ConvertCameraModeEnumToStandard(Enum.DevComputerCameraMovementMode.Classic)
            )
        end

        if argument.activeCameraController then
            argument.activeCameraController:UpdateForDistancePropertyChange()
        end
    else
        if argument_2 == "DevComputerCameraMode" or argument_2 == "DevTouchCameraMode" then
            local camera_movement_mode_from_settings_2 = argument:GetCameraMovementModeFromSettings()
            argument:ActivateCameraController(
                camera_utils.ConvertCameraModeEnumToStandard(camera_movement_mode_from_settings_2)
            )

            return
        end

        if argument_2 == "DevCameraOcclusionMode" then
            argument:ActivateOcclusionModule(players.LocalPlayer.DevCameraOcclusionMode)

            return
        end

        if argument_2 == "CameraMinZoomDistance" or argument_2 == "CameraMaxZoomDistance" then
            if argument.activeCameraController then
                argument.activeCameraController:UpdateForDistancePropertyChange()
            end
        else
            if argument_2 == "DevTouchMovementMode" then
                return
            end

            if argument_2 == "DevComputerMovementMode" then
                return
            end

            local _ = argument_2 == "DevEnableMouseLock"
        end
    end
end

function values.OnUserGameSettingsPropertyChanged(argument: table, argument_2: string)
    if argument_2 == "ComputerCameraMovementMode" then
        local camera_movement_mode_from_settings = argument:GetCameraMovementModeFromSettings()
        argument:ActivateCameraController(
            camera_utils.ConvertCameraModeEnumToStandard(camera_movement_mode_from_settings)
        )
    end
end

function values.Update(argument, argument_2)
    if not argument.activeCameraController then
        return
    end

    argument.activeCameraController:UpdateMouseBehavior()
    local cframe, focus = argument.activeCameraController:Update(argument_2)

    if argument.activeOcclusionModule then
        cframe, focus = argument.activeOcclusionModule:Update(argument_2, cframe, focus)
    end

    local current_camera = game.Workspace.CurrentCamera
    current_camera.CFrame = cframe
    current_camera.Focus = focus

    if argument.activeTransparencyController then
        argument.activeTransparencyController:Update(argument_2)
    end

    if camera_input.getInputEnabled() then
        camera_input.resetInputForFrameEnd()
    end
end

function values.GetCameraControlChoice(argument)
    local local_player = players.LocalPlayer

    if not local_player then
        return
    end

    if user_input_service:GetLastInputType() == Enum.UserInputType.Touch or user_input_service.TouchEnabled then
        if local_player.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice then
            return camera_utils.ConvertCameraModeEnumToStandard(user_game_settings.TouchCameraMovementMode)
        end

        return camera_utils.ConvertCameraModeEnumToStandard(local_player.DevTouchCameraMode)
    end

    if local_player.DevComputerCameraMode ~= Enum.DevComputerCameraMovementMode.UserChoice then
        return camera_utils.ConvertCameraModeEnumToStandard(local_player.DevComputerCameraMode)
    end

    local convert_camera_mode_enum_to_standard_result =
        camera_utils.ConvertCameraModeEnumToStandard(user_game_settings.ComputerCameraMovementMode)

    return camera_utils.ConvertCameraModeEnumToStandard(convert_camera_mode_enum_to_standard_result)
end

function values.OnCharacterAdded(argument, argument_2, argument_3)
    if argument.activeOcclusionModule then
        argument.activeOcclusionModule:CharacterAdded(argument_2, argument_3)
    end
end

function values.OnCharacterRemoving(argument, argument_2, argument_3)
    if argument.activeOcclusionModule then
        argument.activeOcclusionModule:CharacterRemoving(argument_2, argument_3)
    end
end

function values.OnPlayerAdded(argument, argument_2)
    argument_2.CharacterAdded:Connect(function(character)
        argument:OnCharacterAdded(character, argument_2)
    end)

    argument_2.CharacterRemoving:Connect(function(argument_3)
        argument:OnCharacterRemoving(argument_3, argument_2)
    end)
end

function values.OnMouseLockToggled(argument)
    if not argument.activeMouseLockController then
        return
    end

    local is_mouse_locked = argument.activeMouseLockController:GetIsMouseLocked()
    local mouse_lock_offset = argument.activeMouseLockController:GetMouseLockOffset()

    if argument.activeCameraController then
        argument.activeCameraController:SetIsMouseLocked(is_mouse_locked)
        argument.activeCameraController:SetMouseLockOffset(mouse_lock_offset)
    end
end

values.new()

return {}
