local values = {}
values.__index = values
local players = game:GetService("Players")
local run_service = game:GetService("RunService")
local user_input_service = game:GetService("UserInputService")
local gui_service = game:GetService("GuiService")
local workspace_2 = game:GetService("Workspace")
local user_game_settings = UserSettings():GetService("UserGameSettings")
local vr_service = game:GetService("VRService")
local flag_util = require(script.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil"))
local keyboard = require(script:WaitForChild("Keyboard"))
local gamepad = require(script:WaitForChild("Gamepad"))
local dynamic_thumbstick = require(script:WaitForChild("DynamicThumbstick"))
local get_user_flag_result = flag_util.getUserFlag("UserUpdateInputConnections")
local success, value_2 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
end)
local success_3 = success and value_2
local success_2, value_3 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserFixTouchJumpBug2")
end)
local success_4 = success_2 and value_3
local touch_thumbstick = require(script:WaitForChild("TouchThumbstick"))
local click_to_move_controller = require(script:WaitForChild("ClickToMoveController"))
local touch_jump = require(script:WaitForChild("TouchJump"))
local vehicle_controller = require(script:WaitForChild("VehicleController"))
local value = Enum.ContextActionPriority.Medium.Value
local values_2 = {}
values_2[Enum.TouchMovementMode.DPad] = dynamic_thumbstick
values_2[Enum.DevTouchMovementMode.DPad] = dynamic_thumbstick
values_2[Enum.TouchMovementMode.Thumbpad] = dynamic_thumbstick
values_2[Enum.DevTouchMovementMode.Thumbpad] = dynamic_thumbstick
values_2[Enum.TouchMovementMode.Thumbstick] = touch_thumbstick
values_2[Enum.DevTouchMovementMode.Thumbstick] = touch_thumbstick
values_2[Enum.TouchMovementMode.DynamicThumbstick] = dynamic_thumbstick
values_2[Enum.DevTouchMovementMode.DynamicThumbstick] = dynamic_thumbstick
values_2[Enum.TouchMovementMode.ClickToMove] = click_to_move_controller
values_2[Enum.DevTouchMovementMode.ClickToMove] = click_to_move_controller
values_2[Enum.TouchMovementMode.Default] = dynamic_thumbstick
values_2[Enum.ComputerMovementMode.Default] = keyboard
values_2[Enum.ComputerMovementMode.KeyboardMouse] = keyboard
values_2[Enum.DevComputerMovementMode.KeyboardMouse] = keyboard
values_2[Enum.DevComputerMovementMode.Scriptable] = nil
values_2[Enum.ComputerMovementMode.ClickToMove] = click_to_move_controller
values_2[Enum.DevComputerMovementMode.ClickToMove] = click_to_move_controller
local values_3 = {}
values_3[Enum.UserInputType.Keyboard] = keyboard
values_3[Enum.UserInputType.MouseButton1] = keyboard
values_3[Enum.UserInputType.MouseButton2] = keyboard
values_3[Enum.UserInputType.MouseButton3] = keyboard
values_3[Enum.UserInputType.MouseWheel] = keyboard
values_3[Enum.UserInputType.MouseMovement] = keyboard
values_3[Enum.UserInputType.Gamepad1] = gamepad
values_3[Enum.UserInputType.Gamepad2] = gamepad
values_3[Enum.UserInputType.Gamepad3] = gamepad
values_3[Enum.UserInputType.Gamepad4] = gamepad
local value_4 = nil

function values.new()
    local instance = setmetatable({}, values)
    instance.controllers = {}
    instance.activeControlModule = nil
    instance.activeController = nil
    instance.touchJumpController = nil
    instance.moveFunction = players.LocalPlayer.Move
    instance.humanoid = nil
    instance.lastInputType = Enum.UserInputType.None
    instance.controlsEnabled = true
    instance.humanoidSeatedConn = nil
    instance.vehicleController = nil
    instance.touchControlFrame = nil
    instance.currentTorsoAngle = 0
    instance.inputMoveVector = Vector3.new(0, 0, 0)
    instance.vehicleController = vehicle_controller.new(value)
    players.LocalPlayer.CharacterAdded:Connect(function(character)
        instance:OnCharacterAdded(character)
    end)
    players.LocalPlayer.CharacterRemoving:Connect(function(argument)
        instance:OnCharacterRemoving(argument)
    end)
    if players.LocalPlayer.Character then
        instance:OnCharacterAdded(players.LocalPlayer.Character)
    end
    run_service:BindToRenderStep("ControlScriptRenderstep", Enum.RenderPriority.Input.Value, function(delta_time)
        instance:OnRenderStepped(delta_time)
    end)
    user_input_service.LastInputTypeChanged:Connect(function(input_type)
        instance:OnLastInputTypeChanged(input_type)
    end)
    user_game_settings:GetPropertyChangedSignal("TouchMovementMode"):Connect(function()
        instance:OnTouchMovementModeChange()
    end)
    players.LocalPlayer:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function()
        instance:OnTouchMovementModeChange()
    end)
    user_game_settings:GetPropertyChangedSignal("ComputerMovementMode"):Connect(function()
        instance:OnComputerMovementModeChange()
    end)
    players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function()
        instance:OnComputerMovementModeChange()
    end)
    instance.playerGui = nil
    instance.touchGui = nil
    instance.playerGuiAddedConn = nil
    gui_service:GetPropertyChangedSignal("TouchControlsEnabled"):Connect(function()
        instance:UpdateTouchGuiVisibility()
        instance:UpdateActiveControlModuleEnabled()
    end)
    if user_input_service.TouchEnabled then
        instance.playerGui = players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if instance.playerGui then
            instance:CreateTouchGuiContainer()
            instance:OnLastInputTypeChanged(user_input_service:GetLastInputType())
        else
            instance.playerGuiAddedConn = players.LocalPlayer.ChildAdded:Connect(function(child)
                if not child:IsA("PlayerGui") then
                    return
                end
                instance.playerGui = child
                instance:CreateTouchGuiContainer()
                instance.playerGuiAddedConn:Disconnect()
                instance.playerGuiAddedConn = nil
                instance:OnLastInputTypeChanged(user_input_service:GetLastInputType())
            end)
        end
    else
        instance:OnLastInputTypeChanged(user_input_service:GetLastInputType())
    end
    return instance
end

function values.GetMoveVector(self)
    if self.activeController then
        return self.activeController:GetMoveVector()
    end
    return Vector3.new(0, 0, 0)
end

local function normalize_angle(computed_value_offset_offset_offset)
    computed_value_offset_offset_offset = (computed_value_offset_offset_offset + 12.566370614359172) % math.tau
    return ((computed_value_offset_offset_offset > math.pi) and (computed_value_offset_offset_offset - math.tau))
        or computed_value_offset_offset_offset
end

local function average_angle(argument, argument_2)
    local argument_offset_offset_offset = ((argument_2 - argument) + 12.566370614359172) % math.tau
    local argument_offset_offset_offset_2 = (
        (
            argument
            + (
                (
                    ((argument_offset_offset_offset > math.pi) and (argument_offset_offset_offset - math.tau))
                    or argument_offset_offset_offset
                ) / 2
            )
        ) + 12.566370614359172
    ) % math.tau
    return ((argument_offset_offset_offset_2 > math.pi) and (argument_offset_offset_offset_2 - math.tau))
        or argument_offset_offset_offset_2
end

function values.GetEstimatedVRTorsoFrame(self)
    local user_c_frame = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
    local _, value_5 = user_c_frame:ToEulerAnglesYXZ()
    local current_torso_angle = -value_5
    if vr_service:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) then
        local value_6 = nil
        if vr_service:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
            local user_c_frame_2 = vr_service:GetUserCFrame(Enum.UserCFrame.LeftHand)
            local user_c_frame_3 = vr_service:GetUserCFrame(Enum.UserCFrame.RightHand)
            local position_offset = user_c_frame.Position - user_c_frame_2.Position
            local position_offset_2 = user_c_frame.Position - user_c_frame_3.Position
            local angle_offset = -math.atan2(position_offset.X, position_offset.Z)
            local result_offset_offset_offset_offset = (
                (-math.atan2(position_offset_2.X, position_offset_2.Z) - angle_offset) + 12.566370614359172
            ) % math.tau
            local offset_offset_offset_offset = (
                (
                    angle_offset
                    + (
                        (
                            (
                                (result_offset_offset_offset_offset > math.pi)
                                and (result_offset_offset_offset_offset - math.tau)
                            ) or result_offset_offset_offset_offset
                        ) / 2
                    )
                ) + 12.566370614359172
            ) % math.tau
            local is_computed_value = (
                (offset_offset_offset_offset > math.pi) and (offset_offset_offset_offset - math.tau)
            ) or offset_offset_offset_offset
            local current_torso_angle_offset_offset_offset = (
                (current_torso_angle - self.currentTorsoAngle) + 12.566370614359172
            ) % math.tau
            result_offset_offset_offset_offset = (
                (current_torso_angle_offset_offset_offset > math.pi)
                and (current_torso_angle_offset_offset_offset - math.tau)
            ) or current_torso_angle_offset_offset_offset
            local is_computed_value_offset_offset_offset = (
                (is_computed_value - self.currentTorsoAngle) + 12.566370614359172
            ) % math.tau
            is_computed_value_offset_offset_offset = (
                (is_computed_value_offset_offset_offset > math.pi)
                and (is_computed_value_offset_offset_offset - math.tau)
            ) or is_computed_value_offset_offset_offset
            local enabled = false
            if is_computed_value_offset_offset_offset > -1.5707963267948966 then
                enabled = is_computed_value_offset_offset_offset < 1.5707963267948966
            end
            if not enabled then
                is_computed_value_offset_offset_offset = result_offset_offset_offset_offset
            end
            value_6 = math.min(is_computed_value_offset_offset_offset, result_offset_offset_offset_offset)
            local maximum = math.max(is_computed_value_offset_offset_offset, result_offset_offset_offset_offset)
            local number_4 = 0
            if value_6 > 0 then
                number_4 = value_6
            elseif maximum < 0 then
                number_4 = maximum
            end
            self.currentTorsoAngle = number_4 + self.currentTorsoAngle
        else
            self.currentTorsoAngle = current_torso_angle
        end
    else
        self.currentTorsoAngle = current_torso_angle
    end
    return CFrame.new(user_c_frame.Position) * CFrame.fromEulerAnglesYXZ(0, -self.currentTorsoAngle, 0)
end

function values.GetActiveController(self)
    return self.activeController
end

function values.UpdateActiveControlModuleEnabled(self)
    local callback = function()
        if success_4 then
            if
                self.touchControlFrame
                and (
                    self.activeControlModule == click_to_move_controller
                    or self.activeControlModule == touch_thumbstick
                    or self.activeControlModule == dynamic_thumbstick
                )
            then
                if not self.controllers[touch_jump] then
                    self.controllers[touch_jump] = touch_jump.new()
                end
                self.touchJumpController = self.controllers[touch_jump]
                self.touchJumpController:Enable(true, self.touchControlFrame)
            elseif self.touchJumpController then
                self.touchJumpController:Enable(false)
            end
        end
        if self.activeControlModule == click_to_move_controller then
            self.activeController:Enable(
                true,
                players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice,
                self.touchJumpController
            )
        elseif self.touchControlFrame then
            self.activeController:Enable(true, self.touchControlFrame)
        else
            self.activeController:Enable(true)
        end
    end
    if not self.activeController then
        return
    end
    if self.controlsEnabled then
        if not gui_service.TouchControlsEnabled and user_input_service.TouchEnabled then
            if
                self.activeControlModule ~= click_to_move_controller
                and self.activeControlModule ~= touch_thumbstick
                and self.activeControlModule ~= dynamic_thumbstick
            then
                callback()
                return
            end
            self.activeController:Enable(false)
            if success_4 and self.touchJumpController then
                self.touchJumpController:Enable(false)
            end
            if self.moveFunction then
                self.moveFunction(players.LocalPlayer, Vector3.new(0, 0, 0), true)
            end
            return
        end
        callback()
    else
        self.activeController:Enable(false)
        if success_4 and self.touchJumpController then
            self.touchJumpController:Enable(false)
        end
        if self.moveFunction then
            self.moveFunction(players.LocalPlayer, Vector3.new(0, 0, 0), true)
        end
    end
end

function values.Enable(self, controls_enabled)
    if controls_enabled == nil then
        controls_enabled = true
    end
    self.controlsEnabled = controls_enabled
    if not self.activeController then
        return
    end
    self:UpdateActiveControlModuleEnabled()
end

function values.Disable(self)
    self.controlsEnabled = false
    self:UpdateActiveControlModuleEnabled()
end

function values.SelectComputerMovementModule(self)
    if not user_input_service.KeyboardEnabled and not user_input_service.GamepadEnabled then
        return nil, false
    end
    local dev_computer_movement_mode = players.LocalPlayer.DevComputerMovementMode
    local value_5, value_6 = nil, nil
    if dev_computer_movement_mode ~= Enum.DevComputerMovementMode.UserChoice then
        value_5 = values_2[dev_computer_movement_mode]
        if not value_5 and dev_computer_movement_mode ~= Enum.DevComputerMovementMode.Scriptable then
            warn("No character control module is associated with DevComputerMovementMode ", dev_computer_movement_mode)
        end
        value_6 = value_5
    else
        value_6 = values_3[value_4]
        if user_game_settings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove and value_6 == keyboard then
            value_6 = click_to_move_controller
        end
    end
    if value_6 then
        return value_6, true
    elseif dev_computer_movement_mode ~= Enum.DevComputerMovementMode.Scriptable then
        return nil, false
    else
        return nil, true
    end
end

function values.SelectTouchModule(self)
    if not user_input_service.TouchEnabled then
        return nil, false
    end
    local dev_touch_movement_mode = players.LocalPlayer.DevTouchMovementMode
    local value_5 = nil
    if dev_touch_movement_mode == Enum.DevTouchMovementMode.UserChoice then
        value_5 = values_2[user_game_settings.TouchMovementMode]
    elseif dev_touch_movement_mode ~= Enum.DevTouchMovementMode.Scriptable then
        value_5 = values_2[dev_touch_movement_mode]
    else
        return nil, true
    end
    return value_5, true
end

local function get_gamepad_right_thumbstick_position()
    for _, input in pairs(user_input_service:GetGamepadState(Enum.UserInputType.Gamepad1)) do
        if input.KeyCode ~= Enum.KeyCode.Thumbstick2 then
            continue
        end
        return input.Position
    end
    return Vector3.new(0, 0, 0)
end

function values.calculateRawMoveVector(self, argument, argument_2)
    local current_camera = workspace_2.CurrentCamera
    if not current_camera then
        return argument_2
    end
    local cframe = current_camera.CFrame
    if vr_service.VREnabled and argument.RootPart then
        local _ = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
        local estimated_vr_torso_frame = self:GetEstimatedVRTorsoFrame()
        cframe = (
            ((current_camera.Focus.Position - cframe.Position).Magnitude < 3) and (cframe * estimated_vr_torso_frame)
        )
            or (
                current_camera.CFrame
                * (estimated_vr_torso_frame.Rotation + (estimated_vr_torso_frame.Position * current_camera.HeadScale))
            )
    end
    local value_5 = nil
    if argument:GetState() ~= Enum.HumanoidStateType.Swimming then
        local _, value_6, value_7, value_8, value_9, value_10, value_11, value_12, value_13, value_14, value_15, value_16 =
            cframe:GetComponents()
        local value_17, value_18
        if (value_13 < 1) and (value_13 > -1) then
            value_17, value_18 = value_16, value_10
        else
            value_17, value_18 = value_8, -value_9 * math.sign(value_13)
        end
        local sqrt_result = math.sqrt((value_17 * value_17) + (value_18 * value_18))
        return (
            Vector3.new(
                ((value_17 * argument_2.X) + (value_18 * argument_2.Z)) / sqrt_result,
                0,
                ((value_17 * argument_2.Z) - (value_18 * argument_2.X)) / sqrt_result
            )
        )
    else
        if not vr_service.VREnabled then
            return cframe:VectorToWorldSpace(argument_2)
        end
        local vector_2 = Vector3.new(argument_2.X, 0, argument_2.Z)
        if vector_2.Magnitude < 0.01 then
            return Vector3.new(0, 0, 0)
        end
        local y_offset_offset = -get_gamepad_right_thumbstick_position().Y * 1.3962634015954636
        local angle = math.atan2(-vector_2.X, -vector_2.Z)
        local _, value_19 = cframe:ToEulerAnglesYXZ()
        return CFrame.fromEulerAnglesYXZ(y_offset_offset, angle + value_19, 0).LookVector
    end
end

local vector = Vector3.new()
local _ = Vector3.new()
local number = 0
local number_2 = 0
local number_3 = 0

local function calculate_raw_move_vector(argument, argument_2)
    local current_camera = workspace_2.CurrentCamera
    if not current_camera then
        return argument_2
    end
    if argument:GetState() == Enum.HumanoidStateType.Swimming then
        return current_camera.CFrame:VectorToWorldSpace(argument_2)
    end
    local cframe = current_camera.CFrame
    if vr_service.VREnabled and argument.RootPart then
        cframe = (
            ((argument.RootPart.CFrame.Position - cframe.Position).Magnitude < 3)
            and (cframe * vr_service:GetUserCFrame(Enum.UserCFrame.Head))
        ) or cframe
    end
    local _, value_5, value_6, value_7, value_8, value_9, value_10, value_11, value_12, value_13, value_14, value_15 =
        cframe:GetComponents()
    local value_16, value_17
    if (value_12 < 1) and (value_12 > -1) then
        value_16, value_17 = value_15, value_9
    else
        value_16, value_17 = value_7, -value_8 * math.sign(value_12)
    end
    local sqrt_result = math.sqrt((value_16 * value_16) + (value_17 * value_17))
    return (
        Vector3.new(
            ((value_16 * argument_2.X) + (value_17 * argument_2.Z)) / sqrt_result,
            0,
            ((value_16 * argument_2.Z) - (value_17 * argument_2.X)) / sqrt_result
        )
    )
end

function values.OnRenderStepped(self, argument)
    if not self.activeController or not self.activeController.enabled then
        return
    end
    if self.humanoid then
        if not get_user_flag_result then
            self.activeController:OnRenderStepped(argument)
        end
        local move_vector = self.activeController:GetMoveVector()
        local is_move_vector_camera_relative_result = self.activeController:IsMoveVectorCameraRelative()
        local click_to_move_controller_2 = self:GetClickToMoveController()
        if self.activeController ~= click_to_move_controller_2 then
            if move_vector.magnitude > 0 then
                click_to_move_controller_2:CleanupPath()
            else
                click_to_move_controller_2:OnRenderStepped(argument)
                move_vector, is_move_vector_camera_relative_result =
                    click_to_move_controller_2:GetMoveVector(), click_to_move_controller_2:IsMoveVectorCameraRelative()
            end
        end
        if self.vehicleController then
            move_vector = self.vehicleController:Update(
                move_vector,
                is_move_vector_camera_relative_result,
                self.activeControlModule == gamepad
            )
        end
        move_vector = is_move_vector_camera_relative_result and calculate_raw_move_vector(self.humanoid, move_vector)
        local touch_jump_controller = self.activeController:GetIsJumping()
            or (self.touchJumpController and (self.touchJumpController:GetIsJumping()))
        vector = move_vector
        v51 = v51:Lerp(vector, math.clamp(argument * 10, 0, 1))
        local x = v51.X
        local y = v51.Y
        local z = v51.Z
        if x < number and x > 0 and x < 0.1 or number < x and x < 0 and x > -0.1 then
            x = 0
        end
        if y < number_2 and y > 0 and y < 0.1 or number_2 < y and y < 0 and y > -0.1 then
            y = 0
        end
        if z < number_3 and z > 0 and z < 0.1 or number_3 < z and z < 0 and z > -0.1 then
            z = 0
        end
        v51 = Vector3.new(x, y, z)
        number = x
        number_2 = y
        number_3 = z
        self.moveFunction(players.LocalPlayer, v51, false)
        self.humanoid.Jump = touch_jump_controller
    end
end

function values.updateVRMoveVector(self, vector_2)
    local current_camera = workspace.CurrentCamera
    local is_magnitude = ((current_camera.Focus.Position - current_camera.CFrame.Position).Magnitude < 5) and true
    if
        vector_2.Magnitude == 0
        and is_magnitude
        and vr_service.AvatarGestures
        and self.humanoid
        and not self.humanoid.Sit
    then
        local user_c_frame = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
        local position_offset = (
            (current_camera.CFrame * (user_c_frame.Rotation + (user_c_frame.Position * current_camera.HeadScale)))
            * CFrame.new(0, (-0.7 * self.humanoid.RootPart.Size.Y) / 2, 0)
        ).Position - self.humanoid.RootPart.CFrame.Position
        return (Vector3.new(position_offset.x, 0, position_offset.z))
    end
    return vector_2
end

function values.OnHumanoidSeated(self, argument, argument_2)
    if argument then
        if not argument_2 or not argument_2:IsA("VehicleSeat") then
            return
        end
        if not self.vehicleController then
            self.vehicleController = self.vehicleController.new(value)
        end
        self.vehicleController:Enable(true, argument_2)
    elseif self.vehicleController then
        self.vehicleController:Enable(false, argument_2)
    end
end

function values.OnCharacterAdded(self, argument)
    self.humanoid = argument:FindFirstChildOfClass("Humanoid")
    while not self.humanoid do
        argument.ChildAdded:wait()
        self.humanoid = argument:FindFirstChildOfClass("Humanoid")
    end
    self:UpdateTouchGuiVisibility()
    if self.humanoidSeatedConn then
        self.humanoidSeatedConn:Disconnect()
        self.humanoidSeatedConn = nil
    end
    self.humanoidSeatedConn = self.humanoid.Seated:Connect(function(argument_2, argument_3)
        self:OnHumanoidSeated(argument_2, argument_3)
    end)
end

function values.OnCharacterRemoving(self, argument)
    self.humanoid = nil
    self:UpdateTouchGuiVisibility()
end

function values.UpdateTouchGuiVisibility(self)
    if not self.touchGui then
        return
    end
    self.touchGui.Enabled = self.humanoid and gui_service.TouchControlsEnabled
end

function values.SwitchToController(self, active_control_module)
    if active_control_module then
        if not self.controllers[active_control_module] then
            self.controllers[active_control_module] = active_control_module.new(value)
        end
        if self.activeController ~= self.controllers[active_control_module] then
            if self.activeController then
                self.activeController:Enable(false)
            end
            self.activeController = self.controllers[active_control_module]
            self.activeControlModule = active_control_module
            if not success_4 then
                if
                    self.touchControlFrame
                    and (
                        self.activeControlModule == click_to_move_controller
                        or self.activeControlModule == touch_thumbstick
                        or self.activeControlModule == dynamic_thumbstick
                    )
                then
                    if not self.controllers[touch_jump] then
                        self.controllers[touch_jump] = touch_jump.new()
                    end
                    self.touchJumpController = self.controllers[touch_jump]
                    self.touchJumpController:Enable(true, self.touchControlFrame)
                elseif self.touchJumpController then
                    self.touchJumpController:Enable(false)
                end
            end
            self:UpdateActiveControlModuleEnabled()
        end
    else
        if self.activeController then
            self.activeController:Enable(false)
        end
        self.activeController = nil
        self.activeControlModule = nil
    end
end

function values.OnLastInputTypeChanged(self, argument)
    if value_4 == argument then
        warn("LastInputType Change listener called with current type.")
    end
    value_4 = argument
    local value_5 = nil
    if value_4 == Enum.UserInputType.Touch then
        local select_touch_module_result, value_6 = self:SelectTouchModule()
        if value_6 then
            while not self.touchControlFrame do
                wait()
            end
            self:SwitchToController(select_touch_module_result)
        end
    elseif values_3[value_4] ~= nil then
        value_5 = self:SelectComputerMovementModule()
        if value_5 then
            self:SwitchToController(value_5)
        end
    end
    self:UpdateTouchGuiVisibility()
end

function values.OnComputerMovementModeChange(self)
    local select_computer_movement_module_result, value_5 = self:SelectComputerMovementModule()
    if not value_5 then
        return
    end
    self:SwitchToController(select_computer_movement_module_result)
end

function values.OnTouchMovementModeChange(self)
    local select_touch_module_result, value_5 = self:SelectTouchModule()
    if not value_5 then
        return
    end
    while not self.touchControlFrame do
        wait()
    end
    self:SwitchToController(select_touch_module_result)
end

function values.CreateTouchGuiContainer(self)
    if self.touchGui then
        self.touchGui:Destroy()
    end
    self.touchGui = Instance.new("ScreenGui")
    self.touchGui.Name = "TouchGui"
    self.touchGui.ResetOnSpawn = false
    self.touchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self:UpdateTouchGuiVisibility()
    if success_3 then
        self.touchGui.ClipToDeviceSafeArea = false
    end
    self.touchControlFrame = Instance.new("Frame")
    self.touchControlFrame.Name = "TouchControlFrame"
    self.touchControlFrame.Size = UDim2.new(1, 0, 1, 0)
    self.touchControlFrame.BackgroundTransparency = 1
    self.touchControlFrame.Parent = self.touchGui
    self.touchGui.Parent = self.playerGui
end

function values.GetClickToMoveController(self)
    if not self.controllers[click_to_move_controller] then
        self.controllers[click_to_move_controller] = click_to_move_controller.new(value)
    end
    return self.controllers[click_to_move_controller]
end

return values.new()
