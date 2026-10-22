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
local value_3 = success and value_2
local success_2, value_4 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserFixTouchJumpBug2")
end)
local value_5 = success_2 and value_4
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
local value_6 = nil

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

function values.GetMoveVector(argument)
    if argument.activeController then
        return argument.activeController:GetMoveVector()
    end

    return Vector3.new(0, 0, 0)
end

local function normalize_angle(remainder)
    remainder = (remainder + 12.566370614359172) % math.tau

    return ((remainder > math.pi) and (remainder - math.tau)) or remainder
end

local function average_angle(argument, argument_2)
    local remainder = ((argument_2 - argument) + 12.566370614359172) % math.tau
    local remainder_2 = (
        (argument + ((((remainder > math.pi) and (remainder - math.tau)) or remainder) / 2)) + 12.566370614359172
    ) % math.tau

    return ((remainder_2 > math.pi) and (remainder_2 - math.tau)) or remainder_2
end

function values.GetEstimatedVRTorsoFrame(argument)
    local user_c_frame = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
    local _, value_7 = user_c_frame:ToEulerAnglesYXZ()
    local current_torso_angle = -value_7

    if vr_service:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) then
        local value_8 = nil

        if vr_service:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
            local user_c_frame_2 = vr_service:GetUserCFrame(Enum.UserCFrame.LeftHand)
            local user_c_frame_3 = vr_service:GetUserCFrame(Enum.UserCFrame.RightHand)
            local difference = user_c_frame.Position - user_c_frame_2.Position
            local difference_2 = user_c_frame.Position - user_c_frame_3.Position
            local negated_value = -math.atan2(difference.X, difference.Z)
            local remainder = ((-math.atan2(difference_2.X, difference_2.Z) - negated_value) + 12.566370614359172)
                % math.tau
            local remainder_2 = (
                (negated_value + ((((remainder > math.pi) and (remainder - math.tau)) or remainder) / 2))
                + 12.566370614359172
            ) % math.tau
            local difference_3 = ((remainder_2 > math.pi) and (remainder_2 - math.tau)) or remainder_2
            local remainder_3 = ((current_torso_angle - argument.currentTorsoAngle) + 12.566370614359172) % math.tau
            local difference_4 = ((remainder_3 > math.pi) and (remainder_3 - math.tau)) or remainder_3
            _ = ((difference_3 - argument.currentTorsoAngle) + 12.566370614359172) % math.tau
            local __2 = ((_ > math.pi) and (_ - math.tau)) or _
            local enabled = false

            if __2 > -1.5707963267948966 then
                enabled = __2 < 1.5707963267948966
            end

            if enabled then
                _ = __2
            else
                _ = difference_4
            end

            value_8 = math.min(v19, difference_4)
            local maximum = math.max(v19, difference_4)
            local number_4 = 0

            if value_8 > 0 then
                number_4 = value_8
            elseif maximum < 0 then
                number_4 = maximum
            end

            argument.currentTorsoAngle = number_4 + argument.currentTorsoAngle
        else
            argument.currentTorsoAngle = current_torso_angle
        end
    else
        argument.currentTorsoAngle = current_torso_angle
    end

    return CFrame.new(user_c_frame.Position) * CFrame.fromEulerAnglesYXZ(0, -argument.currentTorsoAngle, 0)
end

function values.GetActiveController(argument)
    return argument.activeController
end

function values.UpdateActiveControlModuleEnabled(argument)
    local callback = function()
        if value_5 then
            if
                argument.touchControlFrame
                and (
                    argument.activeControlModule == click_to_move_controller
                    or argument.activeControlModule == touch_thumbstick
                    or argument.activeControlModule == dynamic_thumbstick
                )
            then
                if not argument.controllers[touch_jump] then
                    argument.controllers[touch_jump] = touch_jump.new()
                end

                argument.touchJumpController = argument.controllers[touch_jump]
                argument.touchJumpController:Enable(true, argument.touchControlFrame)
            elseif argument.touchJumpController then
                argument.touchJumpController:Enable(false)
            end
        end

        if argument.activeControlModule == click_to_move_controller then
            argument.activeController:Enable(
                true,
                players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice,
                argument.touchJumpController
            )
        elseif argument.touchControlFrame then
            argument.activeController:Enable(true, argument.touchControlFrame)
        else
            argument.activeController:Enable(true)
        end
    end

    if not argument.activeController then
        return
    end

    if argument.controlsEnabled then
        if not gui_service.TouchControlsEnabled and user_input_service.TouchEnabled then
            if
                argument.activeControlModule ~= click_to_move_controller
                and argument.activeControlModule ~= touch_thumbstick
                and argument.activeControlModule ~= dynamic_thumbstick
            then
                callback()

                return
            end

            argument.activeController:Enable(false)

            if value_5 and argument.touchJumpController then
                argument.touchJumpController:Enable(false)
            end

            if argument.moveFunction then
                argument.moveFunction(players.LocalPlayer, Vector3.new(0, 0, 0), true)
            end

            return
        end

        callback()
    else
        argument.activeController:Enable(false)

        if value_5 and argument.touchJumpController then
            argument.touchJumpController:Enable(false)
        end

        if argument.moveFunction then
            argument.moveFunction(players.LocalPlayer, Vector3.new(0, 0, 0), true)
        end
    end
end

function values.Enable(argument, controls_enabled)
    if controls_enabled == nil then
        controls_enabled = true
    end

    argument.controlsEnabled = controls_enabled

    if not argument.activeController then
        return
    end

    argument:UpdateActiveControlModuleEnabled()
end

function values.Disable(argument)
    argument.controlsEnabled = false
    argument:UpdateActiveControlModuleEnabled()
end

function values.SelectComputerMovementModule(argument)
    if not user_input_service.KeyboardEnabled and not user_input_service.GamepadEnabled then
        return nil, false
    end

    local dev_computer_movement_mode = players.LocalPlayer.DevComputerMovementMode
    local value_7, value_8 = nil, nil

    if dev_computer_movement_mode ~= Enum.DevComputerMovementMode.UserChoice then
        value_7 = values_2[dev_computer_movement_mode]

        if not value_7 and dev_computer_movement_mode ~= Enum.DevComputerMovementMode.Scriptable then
            warn("No character control module is associated with DevComputerMovementMode ", dev_computer_movement_mode)
        end

        value_8 = value_7
    else
        value_8 = values_3[value_6]

        if user_game_settings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove and value_8 == keyboard then
            value_8 = click_to_move_controller
        end
    end

    if value_8 then
        return value_8, true
    elseif dev_computer_movement_mode ~= Enum.DevComputerMovementMode.Scriptable then
        return nil, false
    else
        return nil, true
    end
end

function values.SelectTouchModule(argument)
    if not user_input_service.TouchEnabled then
        return nil, false
    end

    local dev_touch_movement_mode = players.LocalPlayer.DevTouchMovementMode
    local value_7 = nil

    if dev_touch_movement_mode == Enum.DevTouchMovementMode.UserChoice then
        value_7 = values_2[user_game_settings.TouchMovementMode]
    elseif dev_touch_movement_mode ~= Enum.DevTouchMovementMode.Scriptable then
        value_7 = values_2[dev_touch_movement_mode]
    else
        return nil, true
    end

    return value_7, true
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

function values.calculateRawMoveVector(argument, argument_2, argument_3)
    local current_camera = workspace_2.CurrentCamera

    if not current_camera then
        return argument_3
    end

    local cframe = current_camera.CFrame

    if vr_service.VREnabled and argument_2.RootPart then
        local _ = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
        local estimated_vr_torso_frame = argument:GetEstimatedVRTorsoFrame()
        cframe = (
            ((current_camera.Focus.Position - cframe.Position).Magnitude < 3) and (cframe * estimated_vr_torso_frame)
        )
            or (
                current_camera.CFrame
                * (estimated_vr_torso_frame.Rotation + (estimated_vr_torso_frame.Position * current_camera.HeadScale))
            )
    end

    local value_7 = nil

    if argument_2:GetState() ~= Enum.HumanoidStateType.Swimming then
        local _, value_8, value_9, value_10, value_11, value_12, value_13, value_14, value_15, value_16, value_17, value_18 =
            cframe:GetComponents()
        local value_19, value_20

        if (value_15 < 1) and (value_15 > -1) then
            value_19, value_20 = value_18, value_12
        else
            value_19, value_20 = value_10, -value_11 * math.sign(value_15)
        end

        local sqrt_result = math.sqrt((value_19 * value_19) + (value_20 * value_20))

        return (
            Vector3.new(
                ((value_19 * argument_3.X) + (value_20 * argument_3.Z)) / sqrt_result,
                0,
                ((value_19 * argument_3.Z) - (value_20 * argument_3.X)) / sqrt_result
            )
        )
    end

    if not vr_service.VREnabled then
        return cframe:VectorToWorldSpace(argument_3)
    end

    local vector_2 = Vector3.new(argument_3.X, 0, argument_3.Z)

    if vector_2.Magnitude < 0.01 then
        return Vector3.new(0, 0, 0)
    end

    local product = -get_gamepad_right_thumbstick_position().Y * 1.3962634015954636
    local angle = math.atan2(-vector_2.X, -vector_2.Z)
    local _, value_21 = cframe:ToEulerAnglesYXZ()

    return CFrame.fromEulerAnglesYXZ(product, angle + value_21, 0).LookVector
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

    local _, value_7, value_8, value_9, value_10, value_11, value_12, value_13, value_14, value_15, value_16, value_17 =
        cframe:GetComponents()
    local value_18, value_19

    if (value_14 < 1) and (value_14 > -1) then
        value_18, value_19 = value_17, value_11
    else
        value_18, value_19 = value_9, -value_10 * math.sign(value_14)
    end

    local sqrt_result = math.sqrt((value_18 * value_18) + (value_19 * value_19))

    return (
        Vector3.new(
            ((value_18 * argument_2.X) + (value_19 * argument_2.Z)) / sqrt_result,
            0,
            ((value_18 * argument_2.Z) - (value_19 * argument_2.X)) / sqrt_result
        )
    )
end

function values.OnRenderStepped(argument, argument_2)
    if not argument.activeController or not argument.activeController.enabled then
        return
    end

    if not argument.humanoid then
        return
    end

    if not get_user_flag_result then
        argument.activeController:OnRenderStepped(argument_2)
    end

    local move_vector = argument.activeController:GetMoveVector()
    local is_move_vector_camera_relative_result = argument.activeController:IsMoveVectorCameraRelative()
    local click_to_move_controller_2 = argument:GetClickToMoveController()

    if argument.activeController ~= click_to_move_controller_2 then
        if move_vector.magnitude > 0 then
            click_to_move_controller_2:CleanupPath()
        else
            click_to_move_controller_2:OnRenderStepped(argument_2)
            move_vector, is_move_vector_camera_relative_result =
                click_to_move_controller_2:GetMoveVector(), click_to_move_controller_2:IsMoveVectorCameraRelative()
        end
    end

    if argument.vehicleController then
        move_vector = argument.vehicleController:Update(
            move_vector,
            is_move_vector_camera_relative_result,
            argument.activeControlModule == gamepad
        )
    end

    move_vector = is_move_vector_camera_relative_result and calculate_raw_move_vector(argument.humanoid, move_vector)
    local jump = argument.activeController:GetIsJumping()
        or (argument.touchJumpController and argument.touchJumpController:GetIsJumping())
    vector = move_vector
    v53 = v53:Lerp(vector, math.clamp(argument_2 * 14, 0, 1))
    local x = v53.X
    local y = v53.Y
    local z = v53.Z

    if x < number and x > 0 and x < 0.2 or number < x and x < 0 and x > -0.2 then
        x = 0
    end

    if y < number_2 and y > 0 and y < 0.2 or number_2 < y and y < 0 and y > -0.2 then
        y = 0
    end

    if z < number_3 and z > 0 and z < 0.2 or number_3 < z and z < 0 and z > -0.2 then
        z = 0
    end

    v53 = Vector3.new(x, y, z)
    number = x
    number_2 = y
    number_3 = z
    argument.moveFunction(players.LocalPlayer, v53, false)
    argument.humanoid.Jump = jump
end

function values.updateVRMoveVector(argument, vector_2)
    local current_camera = workspace.CurrentCamera
    local enabled = ((current_camera.Focus.Position - current_camera.CFrame.Position).Magnitude < 5) and true

    if
        not (
            vector_2.Magnitude == 0
            and enabled
            and vr_service.AvatarGestures
            and argument.humanoid
            and not argument.humanoid.Sit
        )
    then
        return vector_2
    end

    local user_c_frame = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
    local difference = (
        (current_camera.CFrame * (user_c_frame.Rotation + (user_c_frame.Position * current_camera.HeadScale)))
        * CFrame.new(0, (-0.7 * argument.humanoid.RootPart.Size.Y) / 2, 0)
    ).Position - argument.humanoid.RootPart.CFrame.Position

    return (Vector3.new(difference.x, 0, difference.z))
end

function values.OnHumanoidSeated(argument, argument_2, argument_3)
    if argument_2 then
        if not argument_3 or not argument_3:IsA("VehicleSeat") then
            return
        end

        if not argument.vehicleController then
            argument.vehicleController = argument.vehicleController.new(value)
        end

        argument.vehicleController:Enable(true, argument_3)
    elseif argument.vehicleController then
        argument.vehicleController:Enable(false, argument_3)
    end
end

function values.OnCharacterAdded(argument, argument_2)
    argument.humanoid = argument_2:FindFirstChildOfClass("Humanoid")

    while not argument.humanoid do
        argument_2.ChildAdded:wait()
        argument.humanoid = argument_2:FindFirstChildOfClass("Humanoid")
    end

    argument:UpdateTouchGuiVisibility()

    if argument.humanoidSeatedConn then
        argument.humanoidSeatedConn:Disconnect()
        argument.humanoidSeatedConn = nil
    end

    argument.humanoidSeatedConn = argument.humanoid.Seated:Connect(function(argument_3, argument_4)
        argument:OnHumanoidSeated(argument_3, argument_4)
    end)
end

function values.OnCharacterRemoving(argument, argument_2)
    argument.humanoid = nil
    argument:UpdateTouchGuiVisibility()
end

function values.UpdateTouchGuiVisibility(argument)
    if not argument.touchGui then
        return
    end

    argument.touchGui.Enabled = not not argument.humanoid and not not gui_service.TouchControlsEnabled
end

function values.SwitchToController(argument, active_control_module)
    if active_control_module then
        if not argument.controllers[active_control_module] then
            argument.controllers[active_control_module] = active_control_module.new(value)
        end

        if argument.activeController ~= argument.controllers[active_control_module] then
            if argument.activeController then
                argument.activeController:Enable(false)
            end

            argument.activeController = argument.controllers[active_control_module]
            argument.activeControlModule = active_control_module

            if not value_5 then
                if
                    argument.touchControlFrame
                    and (
                        argument.activeControlModule == click_to_move_controller
                        or argument.activeControlModule == touch_thumbstick
                        or argument.activeControlModule == dynamic_thumbstick
                    )
                then
                    if not argument.controllers[touch_jump] then
                        argument.controllers[touch_jump] = touch_jump.new()
                    end

                    argument.touchJumpController = argument.controllers[touch_jump]
                    argument.touchJumpController:Enable(true, argument.touchControlFrame)
                elseif argument.touchJumpController then
                    argument.touchJumpController:Enable(false)
                end
            end

            argument:UpdateActiveControlModuleEnabled()
        end
    else
        if argument.activeController then
            argument.activeController:Enable(false)
        end

        argument.activeController = nil
        argument.activeControlModule = nil
    end
end

function values.OnLastInputTypeChanged(argument, argument_2)
    if value_6 == argument_2 then
        warn("LastInputType Change listener called with current type.")
    end

    value_6 = argument_2
    local value_7 = nil

    if value_6 == Enum.UserInputType.Touch then
        local select_touch_module_result, value_8 = argument:SelectTouchModule()

        if value_8 then
            while not argument.touchControlFrame do
                wait()
            end

            argument:SwitchToController(select_touch_module_result)
        end
    elseif values_3[value_6] ~= nil then
        value_7 = argument:SelectComputerMovementModule()

        if value_7 then
            argument:SwitchToController(value_7)
        end
    end

    argument:UpdateTouchGuiVisibility()
end

function values.OnComputerMovementModeChange(argument)
    local select_computer_movement_module_result, value_7 = argument:SelectComputerMovementModule()

    if not value_7 then
        return
    end

    argument:SwitchToController(select_computer_movement_module_result)
end

function values.OnTouchMovementModeChange(argument)
    local select_touch_module_result, value_7 = argument:SelectTouchModule()

    if not value_7 then
        return
    end

    while not argument.touchControlFrame do
        wait()
    end

    argument:SwitchToController(select_touch_module_result)
end

function values.CreateTouchGuiContainer(argument)
    if argument.touchGui then
        argument.touchGui:Destroy()
    end

    argument.touchGui = Instance.new("ScreenGui")
    argument.touchGui.Name = "TouchGui"
    argument.touchGui.ResetOnSpawn = false
    argument.touchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    argument:UpdateTouchGuiVisibility()

    if value_3 then
        argument.touchGui.ClipToDeviceSafeArea = false
    end

    argument.touchControlFrame = Instance.new("Frame")
    argument.touchControlFrame.Name = "TouchControlFrame"
    argument.touchControlFrame.Size = UDim2.new(1, 0, 1, 0)
    argument.touchControlFrame.BackgroundTransparency = 1
    argument.touchControlFrame.Parent = argument.touchGui
    argument.touchGui.Parent = argument.playerGui
end

function values.GetClickToMoveController(argument)
    if not argument.controllers[click_to_move_controller] then
        argument.controllers[click_to_move_controller] = click_to_move_controller.new(value)
    end

    return argument.controllers[click_to_move_controller]
end

return values.new()
