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

function values.GetCameraMovementModeFromSettings(self)
    if players.LocalPlayer.CameraMode ~= Enum.CameraMode.LockFirstPerson then
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
    return camera_utils.ConvertCameraModeEnumToStandard(Enum.ComputerCameraMovementMode.Classic)
end

function values.ActivateOcclusionModule(self, occlusion_mode)
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
    self.occlusionMode = occlusion_mode
    if self.activeOcclusionModule and self.activeOcclusionModule:GetOcclusionMode() == occlusion_mode then
        if not (self.activeOcclusionModule:GetEnabled()) then
            self.activeOcclusionModule:Enable(true)
        end
        return
    end
    local active_occlusion_module = self.activeOcclusionModule
    self.activeOcclusionModule = values_5[invisicam_2]
    if not self.activeOcclusionModule then
        self.activeOcclusionModule = invisicam_2.new()
        if self.activeOcclusionModule then
            values_5[invisicam_2] = self.activeOcclusionModule
        end
    end
    if not self.activeOcclusionModule then
        return
    end
    if self.activeOcclusionModule:GetOcclusionMode() ~= occlusion_mode then
        warn(
            "CameraScript ActivateOcclusionModule mismatch: ",
            self.activeOcclusionModule:GetOcclusionMode(),
            "~=",
            occlusion_mode
        )
    end
    if active_occlusion_module then
        if active_occlusion_module == self.activeOcclusionModule then
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
                self.activeOcclusionModule:CharacterAdded(player.Character, player)
            end
        end
        self.activeOcclusionModule:OnCameraSubjectChanged(game.Workspace.CurrentCamera.CameraSubject)
    elseif players.LocalPlayer.Character then
        self.activeOcclusionModule:CharacterAdded(players.LocalPlayer.Character, players.LocalPlayer)
    end
    self.activeOcclusionModule:Enable(true)
end

function values.ShouldUseVehicleCamera(self)
    local current_camera = workspace.CurrentCamera
    if not current_camera then
        return false
    end
    local camera_type = current_camera.CameraType
    local camera_subject = current_camera.CameraSubject
    local enabled = true
    if camera_type ~= Enum.CameraType.Custom then
        enabled = camera_type == Enum.CameraType.Follow
    end
    local camera_subject_2 = (camera_subject and (camera_subject:IsA("VehicleSeat"))) or false
    local is_occlusion_mode = self.occlusionMode ~= Enum.DevCameraOcclusionMode.Invisicam
    local is_occlusion_mode_2
    if camera_subject_2 then
        if enabled then
            is_occlusion_mode_2 = is_occlusion_mode
        else
            is_occlusion_mode_2 = enabled
        end
    else
        is_occlusion_mode_2 = camera_subject_2
    end
    return is_occlusion_mode_2
end

function values.ActivateCameraController(self, camera_movement_mode_from_settings, argument)
    local value = nil
    if argument ~= nil then
        if argument == Enum.CameraType.Scriptable then
            if self.activeCameraController then
                self.activeCameraController:Enable(false)
                self.activeCameraController = nil
            end
            return
        elseif argument == Enum.CameraType.Custom then
            camera_movement_mode_from_settings = self:GetCameraMovementModeFromSettings()
        elseif argument == Enum.CameraType.Track then
            camera_movement_mode_from_settings = Enum.ComputerCameraMovementMode.Classic
        elseif argument == Enum.CameraType.Follow then
            camera_movement_mode_from_settings = Enum.ComputerCameraMovementMode.Follow
        elseif argument == Enum.CameraType.Orbital then
            camera_movement_mode_from_settings = Enum.ComputerCameraMovementMode.Orbital
        elseif
            argument ~= Enum.CameraType.Attach
            and argument ~= Enum.CameraType.Watch
            and argument ~= Enum.CameraType.Fixed
        then
            warn("CameraScript encountered an unhandled Camera.CameraType value: ", argument)
        else
            value = legacy_camera
        end
    end
    local value_2, active_camera_controller = nil, nil
    if value then
        local should_use_vehicle_camera_result = self:ShouldUseVehicleCamera()
        if should_use_vehicle_camera_result then
            if vr_service.VREnabled then
                value = vr_vehicle_camera
            else
                value = vehicle_camera
            end
        end
    elseif vr_service.VREnabled then
        value = vr_camera
        local should_use_vehicle_camera_result_2 = self:ShouldUseVehicleCamera()
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
                local should_use_vehicle_camera_result_3 = self:ShouldUseVehicleCamera()
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
                if self.activeCameraController then
                    if self.activeCameraController == active_camera_controller then
                        if not (self.activeCameraController:GetEnabled()) then
                            self.activeCameraController:Enable(true)
                        end
                    else
                        self.activeCameraController:Enable(false)
                        self.activeCameraController = active_camera_controller
                        self.activeCameraController:Enable(true)
                    end
                elseif active_camera_controller ~= nil then
                    self.activeCameraController = active_camera_controller
                    self.activeCameraController:Enable(true)
                end
                if self.activeCameraController then
                    if camera_movement_mode_from_settings == nil then
                        if argument ~= nil then
                            self.activeCameraController:SetCameraType(argument)
                        end
                    else
                        self.activeCameraController:SetCameraMovementMode(camera_movement_mode_from_settings)
                        return
                    end
                end
            end
            return
        end
        value = classic_camera
        local should_use_vehicle_camera_result_4 = self:ShouldUseVehicleCamera()
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
    if self.activeCameraController then
        if self.activeCameraController == active_camera_controller then
            if not (self.activeCameraController:GetEnabled()) then
                self.activeCameraController:Enable(true)
            end
        else
            self.activeCameraController:Enable(false)
            self.activeCameraController = active_camera_controller
            self.activeCameraController:Enable(true)
        end
    elseif active_camera_controller ~= nil then
        self.activeCameraController = active_camera_controller
        self.activeCameraController:Enable(true)
    end
    if not self.activeCameraController then
        return
    end
    if camera_movement_mode_from_settings == nil then
        if argument == nil then
            return
        end
        self.activeCameraController:SetCameraType(argument)
    else
        self.activeCameraController:SetCameraMovementMode(camera_movement_mode_from_settings)
    end
end

function values.OnCameraSubjectChanged(self)
    local current_camera = workspace.CurrentCamera
    local camera_subject = current_camera and current_camera.CameraSubject
    if self.activeTransparencyController then
        self.activeTransparencyController:SetSubject(camera_subject)
    end
    if self.activeOcclusionModule then
        self.activeOcclusionModule:OnCameraSubjectChanged(current_camera)
    end
    self:ActivateCameraController(nil, current_camera.CameraType)
end

function values.OnCameraTypeChanged(self, argument)
    if argument == Enum.CameraType.Scriptable and user_input_service.MouseBehavior == Enum.MouseBehavior.LockCenter then
        camera_utils.restoreMouseBehavior()
    end
    self:ActivateCameraController(nil, argument)
end

function values.OnCurrentCameraChanged(self)
    local current_camera = game.Workspace.CurrentCamera
    if not current_camera then
        return
    end
    if self.cameraSubjectChangedConn then
        self.cameraSubjectChangedConn:Disconnect()
    end
    if self.cameraTypeChangedConn then
        self.cameraTypeChangedConn:Disconnect()
    end
    self.cameraSubjectChangedConn = current_camera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
        self:OnCameraSubjectChanged(current_camera.CameraSubject)
    end)
    self.cameraTypeChangedConn = current_camera:GetPropertyChangedSignal("CameraType"):Connect(function()
        self:OnCameraTypeChanged(current_camera.CameraType)
    end)
    self:OnCameraSubjectChanged(current_camera.CameraSubject)
    self:OnCameraTypeChanged(current_camera.CameraType)
end

function values.OnLocalPlayerCameraPropertyChanged(self, argument)
    if argument ~= "CameraMode" then
        if argument ~= "DevComputerCameraMode" and argument ~= "DevTouchCameraMode" then
            if argument == "DevCameraOcclusionMode" then
                self:ActivateOcclusionModule(players.LocalPlayer.DevCameraOcclusionMode)
            elseif argument == "CameraMinZoomDistance" or argument == "CameraMaxZoomDistance" then
                if self.activeCameraController then
                    self.activeCameraController:UpdateForDistancePropertyChange()
                end
            end
            return
        end
        self:ActivateCameraController(
            camera_utils.ConvertCameraModeEnumToStandard(self:GetCameraMovementModeFromSettings())
        )
    elseif players.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        if not self.activeCameraController or self.activeCameraController:GetModuleName() ~= "ClassicCamera" then
            self:ActivateCameraController(
                camera_utils.ConvertCameraModeEnumToStandard(Enum.DevComputerCameraMovementMode.Classic)
            )
        end
        if not self.activeCameraController then
            return
        end
        self.activeCameraController:UpdateForDistancePropertyChange()
    elseif players.LocalPlayer.CameraMode ~= Enum.CameraMode.Classic then
        warn("Unhandled value for property player.CameraMode: ", players.LocalPlayer.CameraMode)
    else
        self:ActivateCameraController(
            camera_utils.ConvertCameraModeEnumToStandard(self:GetCameraMovementModeFromSettings())
        )
    end
end

function values.OnUserGameSettingsPropertyChanged(self, argument)
    if argument ~= "ComputerCameraMovementMode" then
        return
    end
    self:ActivateCameraController(
        camera_utils.ConvertCameraModeEnumToStandard(self:GetCameraMovementModeFromSettings())
    )
end

function values.Update(self, argument)
    if self.activeCameraController then
        self.activeCameraController:UpdateMouseBehavior()
        local cframe, focus = self.activeCameraController:Update(argument)
        if self.activeOcclusionModule then
            local update_result, value = self.activeOcclusionModule:Update(argument, cframe, focus)
            cframe, focus = update_result, value
        end
        local current_camera = game.Workspace.CurrentCamera
        current_camera.CFrame = cframe
        current_camera.Focus = focus
        if self.activeTransparencyController then
            self.activeTransparencyController:Update(argument)
        end
        if not camera_input.getInputEnabled() then
            return
        end
        camera_input.resetInputForFrameEnd()
    end
end

function values.GetCameraControlChoice(self)
    local local_player = players.LocalPlayer
    if local_player then
        if
            user_input_service:GetLastInputType() ~= Enum.UserInputType.Touch
            and not user_input_service.TouchEnabled
        then
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
end

function values.OnCharacterAdded(self, argument, argument_2)
    if not self.activeOcclusionModule then
        return
    end
    self.activeOcclusionModule:CharacterAdded(argument, argument_2)
end

function values.OnCharacterRemoving(self, argument, argument_2)
    if not self.activeOcclusionModule then
        return
    end
    self.activeOcclusionModule:CharacterRemoving(argument, argument_2)
end

function values.OnPlayerAdded(self, argument)
    argument.CharacterAdded:Connect(function(character)
        self:OnCharacterAdded(character, argument)
    end)
    argument.CharacterRemoving:Connect(function(argument_2)
        self:OnCharacterRemoving(argument_2, argument)
    end)
end

function values.OnMouseLockToggled(self)
    if self.activeMouseLockController then
        local is_mouse_locked = self.activeMouseLockController:GetIsMouseLocked()
        local mouse_lock_offset = self.activeMouseLockController:GetMouseLockOffset()
        if not self.activeCameraController then
            return
        end
        self.activeCameraController:SetIsMouseLocked(is_mouse_locked)
        self.activeCameraController:SetMouseLockOffset(mouse_lock_offset)
    end
end

local _ = values.new()

return {}
