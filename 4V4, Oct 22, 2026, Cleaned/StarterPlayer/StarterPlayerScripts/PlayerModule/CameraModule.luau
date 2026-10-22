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
    local signal = nil

    if not user_input_service.TouchEnabled then
        instance.activeMouseLockController = mouse_lock_controller.new()
        signal = instance.activeMouseLockController:GetBindableToggleEvent()

        if signal then
            signal:Connect(function()
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

    for _, value in pairs(values_2) do
        players.LocalPlayer:GetPropertyChangedSignal(value):Connect(function()
            instance:OnLocalPlayerCameraPropertyChanged(value)
        end)
    end

    for _, value_2 in pairs(values_3) do
        user_game_settings:GetPropertyChangedSignal(value_2):Connect(function()
            instance:OnUserGameSettingsPropertyChanged(value_2)
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
        convert_camera_mode_enum_to_standard_result, convert_camera_mode_enum_to_standard_result_2 =
            camera_utils.ConvertCameraModeEnumToStandard(players.LocalPlayer.DevComputerCameraMode),
            camera_utils.ConvertCameraModeEnumToStandard(user_game_settings.ComputerCameraMovementMode)
    end

    if convert_camera_mode_enum_to_standard_result ~= Enum.DevComputerCameraMovementMode.UserChoice then
        return convert_camera_mode_enum_to_standard_result
    end

    return convert_camera_mode_enum_to_standard_result_2
end

function values.ActivateOcclusionModule(argument, occlusion_mode)
    local invisicam_2

    if occlusion_mode ~= Enum.DevCameraOcclusionMode.Zoom then
        if occlusion_mode ~= Enum.DevCameraOcclusionMode.Invisicam then
            warn("CameraScript ActivateOcclusionModule called with unsupported mode")

            return
        end

        invisicam_2 = invisicam
    else
        invisicam_2 = poppercam
    end

    argument.occlusionMode = occlusion_mode

    if argument.activeOcclusionModule and argument.activeOcclusionModule:GetOcclusionMode() == occlusion_mode then
        if not (argument.activeOcclusionModule:GetEnabled()) then
            argument.activeOcclusionModule:Enable(true)
        end

        return
    end

    local active_occlusion_module = argument.activeOcclusionModule
    argument.activeOcclusionModule = values_5[invisicam_2]

    if not argument.activeOcclusionModule then
        argument.activeOcclusionModule = invisicam_2.new()

        if argument.activeOcclusionModule then
            values_5[invisicam_2] = argument.activeOcclusionModule
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

    if occlusion_mode ~= Enum.DevCameraOcclusionMode.Invisicam then
        for _, player in pairs(players:GetPlayers()) do
            if not player then
                continue
            end

            if player.Character then
                argument.activeOcclusionModule:CharacterAdded(player.Character, player)
            end
        end

        argument.activeOcclusionModule:OnCameraSubjectChanged(game.Workspace.CurrentCamera.CameraSubject)
    elseif players.LocalPlayer.Character then
        argument.activeOcclusionModule:CharacterAdded(players.LocalPlayer.Character, players.LocalPlayer)
    end

    argument.activeOcclusionModule:Enable(true)
end

function values.ShouldUseVehicleCamera(argument)
    local current_camera = workspace.CurrentCamera

    if not current_camera then
        return false
    end

    local camera_type = current_camera.CameraType
    local camera_subject = current_camera.CameraSubject
    local enabled = true

    if camera_type == Enum.CameraType.Custom then
        current_camera = enabled
    else
        current_camera = camera_type == Enum.CameraType.Follow
    end

    local result = (camera_subject and camera_subject:IsA("VehicleSeat")) or false
    local condition = argument.occlusionMode ~= Enum.DevCameraOcclusionMode.Invisicam
    local condition_2

    if result then
        if current_camera then
            condition_2 = condition
        else
            condition_2 = current_camera
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
        elseif argument_2 == Enum.CameraType.Custom then
            camera_movement_mode_from_settings = argument:GetCameraMovementModeFromSettings()
        elseif argument_2 == Enum.CameraType.Track then
            camera_movement_mode_from_settings = Enum.ComputerCameraMovementMode.Classic
        elseif argument_2 == Enum.CameraType.Follow then
            camera_movement_mode_from_settings = Enum.ComputerCameraMovementMode.Follow
        elseif argument_2 == Enum.CameraType.Orbital then
            camera_movement_mode_from_settings = Enum.ComputerCameraMovementMode.Orbital
        elseif
            argument_2 ~= Enum.CameraType.Attach
            and argument_2 ~= Enum.CameraType.Watch
            and argument_2 ~= Enum.CameraType.Fixed
        then
            warn("CameraScript encountered an unhandled Camera.CameraType value: ", argument_2)
        else
            value = legacy_camera
        end
    end

    local value_2, active_camera_controller = nil, nil

    if value then
        local should_use_vehicle_camera_result = argument:ShouldUseVehicleCamera()

        if should_use_vehicle_camera_result then
            if vr_service.VREnabled then
                value = vr_vehicle_camera
            else
                value = vehicle_camera
            end
        end
    elseif vr_service.VREnabled then
        value = vr_camera
        local should_use_vehicle_camera_result_2 = argument:ShouldUseVehicleCamera()

        if should_use_vehicle_camera_result_2 then
            if vr_service.VREnabled then
                value = vr_vehicle_camera
            else
                value = vehicle_camera
            end
        end
    else
        if
            camera_movement_mode_from_settings ~= Enum.ComputerCameraMovementMode.Classic
            and camera_movement_mode_from_settings ~= Enum.ComputerCameraMovementMode.Follow
            and camera_movement_mode_from_settings ~= Enum.ComputerCameraMovementMode.Default
            and camera_movement_mode_from_settings ~= Enum.ComputerCameraMovementMode.CameraToggle
        then
            if camera_movement_mode_from_settings ~= Enum.ComputerCameraMovementMode.Orbital then
                warn("ActivateCameraController did not select a module.")
            else
                value = orbital_camera
                local should_use_vehicle_camera_result_3 = argument:ShouldUseVehicleCamera()

                if should_use_vehicle_camera_result_3 then
                    if vr_service.VREnabled then
                        value = vr_vehicle_camera
                    else
                        value = vehicle_camera
                    end
                end

                if values_4[value] then
                    active_camera_controller = values_4[value]

                    if active_camera_controller.Reset then
                        active_camera_controller:Reset()
                    end

                    active_camera_controller = active_camera_controller
                else
                    active_camera_controller = value.new()
                    values_4[value] = active_camera_controller
                end

                if argument.activeCameraController then
                    if argument.activeCameraController == active_camera_controller then
                        if not (argument.activeCameraController:GetEnabled()) then
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

                if argument.activeCameraController then
                    if camera_movement_mode_from_settings == nil then
                        if argument_2 ~= nil then
                            argument.activeCameraController:SetCameraType(argument_2)
                        end
                    else
                        argument.activeCameraController:SetCameraMovementMode(camera_movement_mode_from_settings)

                        return
                    end
                end
            end

            return
        end

        value = classic_camera
        local should_use_vehicle_camera_result_4 = argument:ShouldUseVehicleCamera()

        if should_use_vehicle_camera_result_4 then
            if vr_service.VREnabled then
                value = vr_vehicle_camera
            else
                value = vehicle_camera
            end
        end
    end

    if values_4[value] then
        value_2 = values_4[value]

        if value_2.Reset then
            value_2:Reset()
        end

        active_camera_controller = value_2
    else
        value_2 = value.new()
        values_4[value] = value_2
    end

    if argument.activeCameraController then
        if argument.activeCameraController == active_camera_controller then
            if not (argument.activeCameraController:GetEnabled()) then
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

    if camera_movement_mode_from_settings == nil then
        if argument_2 == nil then
            return
        end

        argument.activeCameraController:SetCameraType(argument_2)
    else
        argument.activeCameraController:SetCameraMovementMode(camera_movement_mode_from_settings)
    end
end

function values.OnCameraSubjectChanged(argument)
    local current_camera = workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject

    if argument.activeTransparencyController then
        argument.activeTransparencyController:SetSubject(camera_subject)
    end

    if argument.activeOcclusionModule then
        argument.activeOcclusionModule:OnCameraSubjectChanged(current_camera)
    end

    argument:ActivateCameraController(nil, current_camera.CameraType)
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

function values.OnLocalPlayerCameraPropertyChanged(argument, argument_2)
    if argument_2 ~= "CameraMode" then
        if argument_2 ~= "DevComputerCameraMode" and argument_2 ~= "DevTouchCameraMode" then
            if argument_2 == "DevCameraOcclusionMode" then
                argument:ActivateOcclusionModule(players.LocalPlayer.DevCameraOcclusionMode)
            elseif argument_2 == "CameraMinZoomDistance" or argument_2 == "CameraMaxZoomDistance" then
                if argument.activeCameraController then
                    argument.activeCameraController:UpdateForDistancePropertyChange()
                end
            end

            return
        end

        argument:ActivateCameraController(
            camera_utils.ConvertCameraModeEnumToStandard(argument:GetCameraMovementModeFromSettings())
        )
    elseif players.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        if
            not argument.activeCameraController
            or argument.activeCameraController:GetModuleName() ~= "ClassicCamera"
        then
            argument:ActivateCameraController(
                camera_utils.ConvertCameraModeEnumToStandard(Enum.DevComputerCameraMovementMode.Classic)
            )
        end

        if not argument.activeCameraController then
            return
        end

        argument.activeCameraController:UpdateForDistancePropertyChange()
    elseif players.LocalPlayer.CameraMode ~= Enum.CameraMode.Classic then
        warn("Unhandled value for property player.CameraMode: ", players.LocalPlayer.CameraMode)
    else
        argument:ActivateCameraController(
            camera_utils.ConvertCameraModeEnumToStandard(argument:GetCameraMovementModeFromSettings())
        )
    end
end

function values.OnUserGameSettingsPropertyChanged(argument, argument_2)
    if argument_2 ~= "ComputerCameraMovementMode" then
        return
    end

    argument:ActivateCameraController(
        camera_utils.ConvertCameraModeEnumToStandard(argument:GetCameraMovementModeFromSettings())
    )
end

function values.Update(argument, argument_2)
    if not argument.activeCameraController then
        return
    end

    argument.activeCameraController:UpdateMouseBehavior()
    local cframe, focus = argument.activeCameraController:Update(argument_2)

    if argument.activeOcclusionModule then
        local update_result, value = argument.activeOcclusionModule:Update(argument_2, cframe, focus)
        cframe, focus = update_result, value
    end

    local current_camera = game.Workspace.CurrentCamera
    current_camera.CFrame = cframe
    current_camera.Focus = focus

    if argument.activeTransparencyController then
        argument.activeTransparencyController:Update(argument_2)
    end

    if not camera_input.getInputEnabled() then
        return
    end

    camera_input.resetInputForFrameEnd()
end

function values.GetCameraControlChoice(argument)
    local local_player = players.LocalPlayer

    if not local_player then
        return
    end

    if user_input_service:GetLastInputType() ~= Enum.UserInputType.Touch and not user_input_service.TouchEnabled then
        if local_player.DevComputerCameraMode ~= Enum.DevComputerCameraMovementMode.UserChoice then
            return camera_utils.ConvertCameraModeEnumToStandard(local_player.DevComputerCameraMode)
        end

        return camera_utils.ConvertCameraModeEnumToStandard(
            camera_utils.ConvertCameraModeEnumToStandard(user_game_settings.ComputerCameraMovementMode)
        )
    elseif local_player.DevTouchCameraMode ~= Enum.DevTouchCameraMovementMode.UserChoice then
        return camera_utils.ConvertCameraModeEnumToStandard(local_player.DevTouchCameraMode)
    else
        return camera_utils.ConvertCameraModeEnumToStandard(user_game_settings.TouchCameraMovementMode)
    end
end

function values.OnCharacterAdded(argument, argument_2, argument_3)
    if not argument.activeOcclusionModule then
        return
    end

    argument.activeOcclusionModule:CharacterAdded(argument_2, argument_3)
end

function values.OnCharacterRemoving(argument, argument_2, argument_3)
    if not argument.activeOcclusionModule then
        return
    end

    argument.activeOcclusionModule:CharacterRemoving(argument_2, argument_3)
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

    if not argument.activeCameraController then
        return
    end

    argument.activeCameraController:SetIsMouseLocked(is_mouse_locked)
    argument.activeCameraController:SetMouseLockOffset(mouse_lock_offset)
end

local _ = values.new()

return {}
