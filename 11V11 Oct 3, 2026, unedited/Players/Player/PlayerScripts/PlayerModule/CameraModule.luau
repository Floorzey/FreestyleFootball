--[[
    Script Path: Game/Players/Player/PlayerScripts/PlayerModule/CameraModule
    Class: ModuleScript
    Time: 2026-10-03 12:27:02
--]]

local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
local tbl_upv_2 = {"CameraMinZoomDistance", "CameraMaxZoomDistance", "CameraMode", "DevCameraOcclusionMode", "DevComputerCameraMode", "DevTouchCameraMode", "DevComputerMovementMode", "DevTouchMovementMode", "DevEnableMouseLock"}
local tbl_upv_3 = {"ComputerCameraMovementMode", "ComputerMovementMode", "ControlMode", "GamepadCameraSensitivity", "MouseSensitivity", "RotationType", "TouchCameraMovementMode", "TouchMovementMode"}
local Players_upv_1 = game:GetService("Players")
local RunService_upv_1 = game:GetService("RunService")
local UserInputService_upv_1 = game:GetService("UserInputService")
local VRService_upv_1 = game:GetService("VRService")
local UserGameSettings_upv_1 = UserSettings():GetService("UserGameSettings")
local CameraUtils_upv_1 = require(script:WaitForChild("CameraUtils"))
local CameraInput_upv_1 = require(script:WaitForChild("CameraInput"))
local ClassicCamera_upv_1 = require(script:WaitForChild("ClassicCamera"))
local OrbitalCamera_upv_1 = require(script:WaitForChild("OrbitalCamera"))
local LegacyCamera_upv_1 = require(script:WaitForChild("LegacyCamera"))
local VehicleCamera_upv_1 = require(script:WaitForChild("VehicleCamera"))
local VRCamera_upv_1 = require(script:WaitForChild("VRCamera"))
local VRVehicleCamera_upv_1 = require(script:WaitForChild("VRVehicleCamera"))
local Invisicam_upv_1 = require(script:WaitForChild("Invisicam"))
local Poppercam_upv_1 = require(script:WaitForChild("Poppercam"))
local TransparencyController_upv_1 = require(script:WaitForChild("TransparencyController"))
local MouseLockController_upv_1 = require(script:WaitForChild("MouseLockController"))
local tbl_upv_4 = {}
local tbl_upv_5 = {}
local PlayerScripts_1 = Players_upv_1.LocalPlayer:WaitForChild("PlayerScripts")
PlayerScripts_1:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Default)
PlayerScripts_1:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Follow)
PlayerScripts_1:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Classic)
PlayerScripts_1:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Default)
PlayerScripts_1:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Follow)
PlayerScripts_1:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Classic)
PlayerScripts_1:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.CameraToggle)
function tbl_upv_1.new()
    --[[
      name: new
      line: 95
      upvalues:
        tbl_upv_1 (copy, index: 1)
        Players_upv_1 (copy, index: 2)
        TransparencyController_upv_1 (copy, index: 3)
        UserInputService_upv_1 (copy, index: 4)
        MouseLockController_upv_1 (copy, index: 5)
        RunService_upv_1 (copy, index: 6)
        tbl_upv_2 (copy, index: 7)
        tbl_upv_3 (copy, index: 8)
        UserGameSettings_upv_1 (copy, index: 9)
    ]]
    local u1 = setmetatable({}, tbl_upv_1)
    u1.activeCameraController = nil
    u1.activeOcclusionModule = nil
    u1.activeTransparencyController = nil
    u1.activeMouseLockController = nil
    u1.currentComputerCameraMovementMode = nil
    u1.cameraSubjectChangedConn = nil
    u1.cameraTypeChangedConn = nil
    for _, value_1 in pairs(Players_upv_1:GetPlayers()) do
        u1:OnPlayerAdded(value_1)
    end
    Players_upv_1.PlayerAdded:Connect(
        function(a1)
            --[[
              line: 116
              upvalues:
                u1 (copy, index: 1)
            ]]
            u1:OnPlayerAdded(a1)
        end
    )
    u1.activeTransparencyController = TransparencyController_upv_1.new()
    u1.activeTransparencyController:Enable(true)
    local v1 = nil
    if not (UserInputService_upv_1.TouchEnabled) then
        u1.activeMouseLockController = MouseLockController_upv_1.new()
        v1 = u1.activeMouseLockController:GetBindableToggleEvent()
        if v1 then
            v1:Connect(
                function()
                    --[[
                      line: 127
                      upvalues:
                        u1 (copy, index: 1)
                    ]]
                    u1:OnMouseLockToggled()
                end
            )
        end
    end
    u1:ActivateCameraController(u1:GetCameraControlChoice())
    u1:ActivateOcclusionModule(Players_upv_1.LocalPlayer.DevCameraOcclusionMode)
    u1:OnCurrentCameraChanged()
    RunService_upv_1:BindToRenderStep(
        "cameraRenderUpdate",
        Enum.RenderPriority.Camera.Value,
        function(a2)
            --[[
              line: 136
              upvalues:
                u1 (copy, index: 1)
            ]]
            u1:Update(a2)
        end
    )
    for _, value_upv_2 in pairs(tbl_upv_2) do
        Players_upv_1.LocalPlayer:GetPropertyChangedSignal(value_upv_2):Connect(
            function()
                --[[
                  line: 140
                  upvalues:
                    u1 (copy, index: 1)
                    value_upv_2 (copy, index: 2)
                ]]
                u1:OnLocalPlayerCameraPropertyChanged(value_upv_2)
            end
        )
    end
    for _, value_upv_3 in pairs(tbl_upv_3) do
        UserGameSettings_upv_1:GetPropertyChangedSignal(value_upv_3):Connect(
            function()
                --[[
                  line: 146
                  upvalues:
                    u1 (copy, index: 1)
                    value_upv_3 (copy, index: 2)
                ]]
                u1:OnUserGameSettingsPropertyChanged(value_upv_3)
            end
        )
    end
    game.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(
        function()
            --[[
              line: 150
              upvalues:
                u1 (copy, index: 1)
            ]]
            u1:OnCurrentCameraChanged()
        end
    )
    return u1
end
function tbl_upv_1.GetCameraMovementModeFromSettings(a1)
    --[[
      name: GetCameraMovementModeFromSettings
      line: 157
      upvalues:
        Players_upv_1 (copy, index: 1)
        CameraUtils_upv_1 (copy, index: 2)
        UserInputService_upv_1 (copy, index: 3)
        UserGameSettings_upv_1 (copy, index: 4)
    ]]
    if Players_upv_1.LocalPlayer.CameraMode ~= Enum.CameraMode.LockFirstPerson then
        local v2, v3
        if UserInputService_upv_1.TouchEnabled then
            v2 = CameraUtils_upv_1.ConvertCameraModeEnumToStandard(Players_upv_1.LocalPlayer.DevTouchCameraMode)
            v3 = CameraUtils_upv_1.ConvertCameraModeEnumToStandard(UserGameSettings_upv_1.TouchCameraMovementMode)
        else
            v2, v3 = CameraUtils_upv_1.ConvertCameraModeEnumToStandard(Players_upv_1.LocalPlayer.DevComputerCameraMode), CameraUtils_upv_1.ConvertCameraModeEnumToStandard(UserGameSettings_upv_1.ComputerCameraMovementMode)
        end
        if v2 ~= Enum.DevComputerCameraMovementMode.UserChoice then
            return v2
        end
        return v3
    end
    return CameraUtils_upv_1.ConvertCameraModeEnumToStandard(Enum.ComputerCameraMovementMode.Classic)
end
function tbl_upv_1.ActivateOcclusionModule(a1, a2)
    --[[
      name: ActivateOcclusionModule
      line: 182
      upvalues:
        Poppercam_upv_1 (copy, index: 1)
        Invisicam_upv_1 (copy, index: 2)
        tbl_upv_5 (copy, index: 3)
        Players_upv_1 (copy, index: 4)
    ]]
    local v4
    if a2 ~= Enum.DevCameraOcclusionMode.Zoom then
        if a2 ~= Enum.DevCameraOcclusionMode.Invisicam then
            warn("CameraScript ActivateOcclusionModule called with unsupported mode")
            return
        end
        v4 = Invisicam_upv_1
    else
        v4 = Poppercam_upv_1
    end
    a1.occlusionMode = a2
    if a1.activeOcclusionModule and a1.activeOcclusionModule:GetOcclusionMode() == a2 then
        if not (a1.activeOcclusionModule:GetEnabled()) then
            a1.activeOcclusionModule:Enable(true)
        end
        return
    end
    local activeOcclusionModule_1 = a1.activeOcclusionModule
    a1.activeOcclusionModule = tbl_upv_5[v4]
    if not (a1.activeOcclusionModule) then
        a1.activeOcclusionModule = v4.new()
        if a1.activeOcclusionModule then
            tbl_upv_5[v4] = a1.activeOcclusionModule
        end
    end
    if not a1.activeOcclusionModule then
        return
    end
    if a1.activeOcclusionModule:GetOcclusionMode() ~= a2 then
        warn("CameraScript ActivateOcclusionModule mismatch: ", a1.activeOcclusionModule:GetOcclusionMode(), "~=", a2)
    end
    if activeOcclusionModule_1 then
        if activeOcclusionModule_1 == a1.activeOcclusionModule then
            warn("CameraScript ActivateOcclusionModule failure to detect already running correct module")
        else
            activeOcclusionModule_1:Enable(false)
        end
    end
    if a2 ~= Enum.DevCameraOcclusionMode.Invisicam then
        for _, value_4 in pairs(Players_upv_1:GetPlayers()) do
            if not (value_4) then
                continue
            end
            if value_4.Character then
                a1.activeOcclusionModule:CharacterAdded(value_4.Character, value_4)
            end
        end
        a1.activeOcclusionModule:OnCameraSubjectChanged(game.Workspace.CurrentCamera.CameraSubject)
    elseif Players_upv_1.LocalPlayer.Character then
        a1.activeOcclusionModule:CharacterAdded(Players_upv_1.LocalPlayer.Character, Players_upv_1.LocalPlayer)
    end
    a1.activeOcclusionModule:Enable(true)
end
function tbl_upv_1.ShouldUseVehicleCamera(a1)
    --[[
      name: ShouldUseVehicleCamera
      line: 261
    ]]
    local CurrentCamera_1 = workspace.CurrentCamera
    if not CurrentCamera_1 then
        return false
    end
    local CameraType_1 = CurrentCamera_1.CameraType
    local CameraSubject_1 = CurrentCamera_1.CameraSubject
    local v5 = true
    if CameraType_1 ~= Enum.CameraType.Custom then
        v5 = CameraType_1 == Enum.CameraType.Follow
    end
    local v6 = (CameraSubject_1 and (CameraSubject_1:IsA("VehicleSeat"))) or false
    local v7 = a1.occlusionMode ~= Enum.DevCameraOcclusionMode.Invisicam
    local v8
    if v6 then
        if v5 then
            v8 = v7
        else
            v8 = v5
        end
    else
        v8 = v6
    end
    return v8
end
function tbl_upv_1.ActivateCameraController(a1, a2, a3)
    --[[
      name: ActivateCameraController
      line: 279
      upvalues:
        LegacyCamera_upv_1 (copy, index: 1)
        VRService_upv_1 (copy, index: 2)
        VRCamera_upv_1 (copy, index: 3)
        ClassicCamera_upv_1 (copy, index: 4)
        OrbitalCamera_upv_1 (copy, index: 5)
        VRVehicleCamera_upv_1 (copy, index: 6)
        VehicleCamera_upv_1 (copy, index: 7)
        tbl_upv_4 (copy, index: 8)
    ]]
    local v9 = nil
    if a3 ~= nil then
        if a3 == Enum.CameraType.Scriptable then
            if a1.activeCameraController then
                a1.activeCameraController:Enable(false)
                a1.activeCameraController = nil
            end
            return
        elseif a3 == Enum.CameraType.Custom then
            a2 = a1:GetCameraMovementModeFromSettings()
        elseif a3 == Enum.CameraType.Track then
            a2 = Enum.ComputerCameraMovementMode.Classic
        elseif a3 == Enum.CameraType.Follow then
            a2 = Enum.ComputerCameraMovementMode.Follow
        elseif a3 == Enum.CameraType.Orbital then
            a2 = Enum.ComputerCameraMovementMode.Orbital
        elseif a3 ~= Enum.CameraType.Attach and a3 ~= Enum.CameraType.Watch and a3 ~= Enum.CameraType.Fixed then
            warn("CameraScript encountered an unhandled Camera.CameraType value: ", a3)
        else
            v9 = LegacyCamera_upv_1
        end
    end
    local v11, v12 = nil, nil
    if v9 then
        local v10 = a1:ShouldUseVehicleCamera()
        if v10 then
            if VRService_upv_1.VREnabled then
                v9 = VRVehicleCamera_upv_1
            else
                v9 = VehicleCamera_upv_1
            end
        end
    elseif VRService_upv_1.VREnabled then
        v9 = VRCamera_upv_1
        local v10 = a1:ShouldUseVehicleCamera()
        if v10 then
            if VRService_upv_1.VREnabled then
                v9 = VRVehicleCamera_upv_1
            else
                v9 = VehicleCamera_upv_1
            end
        end
    else
        if a2 ~= Enum.ComputerCameraMovementMode.Classic and a2 ~= Enum.ComputerCameraMovementMode.Follow and a2 ~= Enum.ComputerCameraMovementMode.Default and a2 ~= Enum.ComputerCameraMovementMode.CameraToggle then
            if a2 ~= Enum.ComputerCameraMovementMode.Orbital then
                warn("ActivateCameraController did not select a module.")
            else
                v9 = OrbitalCamera_upv_1
                local v10 = a1:ShouldUseVehicleCamera()
                if v10 then
                    if VRService_upv_1.VREnabled then
                        v9 = VRVehicleCamera_upv_1
                    else
                        v9 = VehicleCamera_upv_1
                    end
                end
                if tbl_upv_4[v9] then
                    v12 = tbl_upv_4[v9]
                    if v12.Reset then
                        v12:Reset()
                    end
                    v12 = v12
                else
                    v12 = v9.new()
                    tbl_upv_4[v9] = v12
                end
                if a1.activeCameraController then
                    if a1.activeCameraController == v12 then
                        if not (a1.activeCameraController:GetEnabled()) then
                            a1.activeCameraController:Enable(true)
                        end
                    else
                        a1.activeCameraController:Enable(false)
                        a1.activeCameraController = v12
                        a1.activeCameraController:Enable(true)
                    end
                elseif v12 ~= nil then
                    a1.activeCameraController = v12
                    a1.activeCameraController:Enable(true)
                end
                if a1.activeCameraController then
                    if a2 == nil then
                        if a3 ~= nil then
                            a1.activeCameraController:SetCameraType(a3)
                        end
                    else
                        a1.activeCameraController:SetCameraMovementMode(a2)
                        return
                    end
                end
            end
            return
        end
        v9 = ClassicCamera_upv_1
        local v10 = a1:ShouldUseVehicleCamera()
        if v10 then
            if VRService_upv_1.VREnabled then
                v9 = VRVehicleCamera_upv_1
            else
                v9 = VehicleCamera_upv_1
            end
        end
    end
    if tbl_upv_4[v9] then
        v11 = tbl_upv_4[v9]
        if v11.Reset then
            v11:Reset()
        end
        v12 = v11
    else
        v11 = v9.new()
        tbl_upv_4[v9] = v11
    end
    if a1.activeCameraController then
        if a1.activeCameraController == v12 then
            if not (a1.activeCameraController:GetEnabled()) then
                a1.activeCameraController:Enable(true)
            end
        else
            a1.activeCameraController:Enable(false)
            a1.activeCameraController = v12
            a1.activeCameraController:Enable(true)
        end
    elseif v12 ~= nil then
        a1.activeCameraController = v12
        a1.activeCameraController:Enable(true)
    end
    if not a1.activeCameraController then
        return
    end
    if a2 == nil then
        if a3 == nil then
            return
        end
        a1.activeCameraController:SetCameraType(a3)
    else
        a1.activeCameraController:SetCameraMovementMode(a2)
    end
end
function tbl_upv_1.OnCameraSubjectChanged(a1)
    --[[
      name: OnCameraSubjectChanged
      line: 384
    ]]
    local CurrentCamera_2 = workspace.CurrentCamera
    local v13 = CurrentCamera_2 and (CurrentCamera_2.CameraSubject)
    if a1.activeTransparencyController then
        a1.activeTransparencyController:SetSubject(v13)
    end
    if a1.activeOcclusionModule then
        a1.activeOcclusionModule:OnCameraSubjectChanged(CurrentCamera_2)
    end
    a1:ActivateCameraController(nil, CurrentCamera_2.CameraType)
end
function tbl_upv_1.OnCameraTypeChanged(a1, a2)
    --[[
      name: OnCameraTypeChanged
      line: 399
      upvalues:
        UserInputService_upv_1 (copy, index: 1)
        CameraUtils_upv_1 (copy, index: 2)
    ]]
    if a2 == Enum.CameraType.Scriptable and UserInputService_upv_1.MouseBehavior == Enum.MouseBehavior.LockCenter then
        CameraUtils_upv_1.restoreMouseBehavior()
    end
    a1:ActivateCameraController(nil, a2)
end
function tbl_upv_1.OnCurrentCameraChanged(a1)
    --[[
      name: OnCurrentCameraChanged
      line: 411
    ]]
    local CurrentCamera_upv_3 = game.Workspace.CurrentCamera
    if not CurrentCamera_upv_3 then
        return
    end
    if a1.cameraSubjectChangedConn then
        a1.cameraSubjectChangedConn:Disconnect()
    end
    if a1.cameraTypeChangedConn then
        a1.cameraTypeChangedConn:Disconnect()
    end
    a1.cameraSubjectChangedConn = CurrentCamera_upv_3:GetPropertyChangedSignal("CameraSubject"):Connect(
        function()
            --[[
              line: 423
              upvalues:
                a1 (copy, index: 1)
                CurrentCamera_upv_3 (copy, index: 2)
            ]]
            a1:OnCameraSubjectChanged(CurrentCamera_upv_3.CameraSubject)
        end
    )
    a1.cameraTypeChangedConn = CurrentCamera_upv_3:GetPropertyChangedSignal("CameraType"):Connect(
        function()
            --[[
              line: 427
              upvalues:
                a1 (copy, index: 1)
                CurrentCamera_upv_3 (copy, index: 2)
            ]]
            a1:OnCameraTypeChanged(CurrentCamera_upv_3.CameraType)
        end
    )
    a1:OnCameraSubjectChanged(CurrentCamera_upv_3.CameraSubject)
    a1:OnCameraTypeChanged(CurrentCamera_upv_3.CameraType)
end
function tbl_upv_1.OnLocalPlayerCameraPropertyChanged(a1, a2)
    --[[
      name: OnLocalPlayerCameraPropertyChanged
      line: 435
      upvalues:
        Players_upv_1 (copy, index: 1)
        CameraUtils_upv_1 (copy, index: 2)
    ]]
    if a2 ~= "CameraMode" then
        if a2 ~= "DevComputerCameraMode" and a2 ~= "DevTouchCameraMode" then
            if a2 == "DevCameraOcclusionMode" then
                a1:ActivateOcclusionModule(Players_upv_1.LocalPlayer.DevCameraOcclusionMode)
            elseif a2 == "CameraMinZoomDistance" or a2 == "CameraMaxZoomDistance" then
                if a1.activeCameraController then
                    a1.activeCameraController:UpdateForDistancePropertyChange()
                end
            end
            return
        end
        a1:ActivateCameraController(CameraUtils_upv_1.ConvertCameraModeEnumToStandard(a1:GetCameraMovementModeFromSettings()))
    elseif Players_upv_1.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        if not (a1.activeCameraController) or a1.activeCameraController:GetModuleName() ~= "ClassicCamera" then
            a1:ActivateCameraController(CameraUtils_upv_1.ConvertCameraModeEnumToStandard(Enum.DevComputerCameraMovementMode.Classic))
        end
        if not a1.activeCameraController then
            return
        end
        a1.activeCameraController:UpdateForDistancePropertyChange()
    elseif Players_upv_1.LocalPlayer.CameraMode ~= Enum.CameraMode.Classic then
        warn("Unhandled value for property player.CameraMode: ", Players_upv_1.LocalPlayer.CameraMode)
    else
        a1:ActivateCameraController(CameraUtils_upv_1.ConvertCameraModeEnumToStandard(a1:GetCameraMovementModeFromSettings()))
    end
end
function tbl_upv_1.OnUserGameSettingsPropertyChanged(a1, a2)
    --[[
      name: OnUserGameSettingsPropertyChanged
      line: 479
      upvalues:
        CameraUtils_upv_1 (copy, index: 1)
    ]]
    if a2 ~= "ComputerCameraMovementMode" then
        return
    end
    a1:ActivateCameraController(CameraUtils_upv_1.ConvertCameraModeEnumToStandard(a1:GetCameraMovementModeFromSettings()))
end
function tbl_upv_1.Update(a1, a2)
    --[[
      name: Update
      line: 492
      upvalues:
        CameraInput_upv_1 (copy, index: 1)
    ]]
    if a1.activeCameraController then
        a1.activeCameraController:UpdateMouseBehavior()
        local v14, v15 = a1.activeCameraController:Update(a2)
        if a1.activeOcclusionModule then
            local v16, v17 = a1.activeOcclusionModule:Update(a2, v14, v15)
            v14, v15 = v16, v17
        end
        local CurrentCamera_4 = game.Workspace.CurrentCamera
        CurrentCamera_4.CFrame = v14
        CurrentCamera_4.Focus = v15
        if a1.activeTransparencyController then
            a1.activeTransparencyController:Update(a2)
        end
        if not CameraInput_upv_1.getInputEnabled() then
            return
        end
        CameraInput_upv_1.resetInputForFrameEnd()
    end
end
function tbl_upv_1.GetCameraControlChoice(a1)
    --[[
      name: GetCameraControlChoice
      line: 520
      upvalues:
        Players_upv_1 (copy, index: 1)
        UserInputService_upv_1 (copy, index: 2)
        CameraUtils_upv_1 (copy, index: 3)
        UserGameSettings_upv_1 (copy, index: 4)
    ]]
    local LocalPlayer_1 = Players_upv_1.LocalPlayer
    if LocalPlayer_1 then
        if UserInputService_upv_1:GetLastInputType() ~= Enum.UserInputType.Touch and not (UserInputService_upv_1.TouchEnabled) then
            if LocalPlayer_1.DevComputerCameraMode ~= Enum.DevComputerCameraMovementMode.UserChoice then
                return CameraUtils_upv_1.ConvertCameraModeEnumToStandard(LocalPlayer_1.DevComputerCameraMode)
            end
            return CameraUtils_upv_1.ConvertCameraModeEnumToStandard(CameraUtils_upv_1.ConvertCameraModeEnumToStandard(UserGameSettings_upv_1.ComputerCameraMovementMode))
        elseif LocalPlayer_1.DevTouchCameraMode ~= Enum.DevTouchCameraMovementMode.UserChoice then
            return CameraUtils_upv_1.ConvertCameraModeEnumToStandard(LocalPlayer_1.DevTouchCameraMode)
        else
            return CameraUtils_upv_1.ConvertCameraModeEnumToStandard(UserGameSettings_upv_1.TouchCameraMovementMode)
        end
    end
end
function tbl_upv_1.OnCharacterAdded(a1, a2, a3)
    --[[
      name: OnCharacterAdded
      line: 543
    ]]
    if not a1.activeOcclusionModule then
        return
    end
    a1.activeOcclusionModule:CharacterAdded(a2, a3)
end
function tbl_upv_1.OnCharacterRemoving(a1, a2, a3)
    --[[
      name: OnCharacterRemoving
      line: 549
    ]]
    if not a1.activeOcclusionModule then
        return
    end
    a1.activeOcclusionModule:CharacterRemoving(a2, a3)
end
function tbl_upv_1.OnPlayerAdded(a1, a2)
    --[[
      name: OnPlayerAdded
      line: 555
    ]]
    a2.CharacterAdded:Connect(
        function(a3)
            --[[
              line: 556
              upvalues:
                a1 (copy, index: 1)
                a2 (copy, index: 2)
            ]]
            a1:OnCharacterAdded(a3, a2)
        end
    )
    a2.CharacterRemoving:Connect(
        function(a4)
            --[[
              line: 559
              upvalues:
                a1 (copy, index: 1)
                a2 (copy, index: 2)
            ]]
            a1:OnCharacterRemoving(a4, a2)
        end
    )
end
function tbl_upv_1.OnMouseLockToggled(a1)
    --[[
      name: OnMouseLockToggled
      line: 564
    ]]
    if a1.activeMouseLockController then
        local v18 = a1.activeMouseLockController:GetIsMouseLocked()
        local v19 = a1.activeMouseLockController:GetMouseLockOffset()
        if not a1.activeCameraController then
            return
        end
        a1.activeCameraController:SetIsMouseLocked(v18)
        a1.activeCameraController:SetMouseLockOffset(v19)
    end
end
local _ = tbl_upv_1.new()
return {}