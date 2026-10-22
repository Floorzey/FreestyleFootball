local values = {}
values.__index = values
local players = game:GetService("Players")
local run_service = game:GetService("RunService")
local user_input_service = game:GetService("UserInputService")
local gui_service = game:GetService("GuiService")
local workspace_2 = game:GetService("Workspace")
local user_game_settings = UserSettings():GetService("UserGameSettings")
local vr_service = game:GetService("VRService")
local common_utils = script.Parent:WaitForChild("CommonUtils")
local flag_util = require(common_utils:WaitForChild("FlagUtil"))
local keyboard = require(script:WaitForChild("Keyboard"))
local gamepad = require(script:WaitForChild("Gamepad"))
local dynamic_thumbstick = require(script:WaitForChild("DynamicThumbstick"))
local user_flag = flag_util.getUserFlag("UserUpdateInputConnections")
local success, result = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
end)
local result_2 = success and result
local success2, result2 = pcall(function()
    return UserSettings():IsUserFeatureEnabled("UserFixTouchJumpBug2")
end)
local result2_2 = success2 and result2
local touch_thumbstick = require(script:WaitForChild("TouchThumbstick"))
local click_to_move_controller = require(script:WaitForChild("ClickToMoveController"))
local touch_jump = require(script:WaitForChild("TouchJump"))
local vehicle_controller = require(script:WaitForChild("VehicleController"))
local value = Enum.ContextActionPriority.Medium.Value
local values_2 = {
    [Enum.TouchMovementMode.DPad] = dynamic_thumbstick,
    [Enum.DevTouchMovementMode.DPad] = dynamic_thumbstick,
    [Enum.TouchMovementMode.Thumbpad] = dynamic_thumbstick,
    [Enum.DevTouchMovementMode.Thumbpad] = dynamic_thumbstick,
    [Enum.TouchMovementMode.Thumbstick] = touch_thumbstick,
    [Enum.DevTouchMovementMode.Thumbstick] = touch_thumbstick,
    [Enum.TouchMovementMode.DynamicThumbstick] = dynamic_thumbstick,
    [Enum.DevTouchMovementMode.DynamicThumbstick] = dynamic_thumbstick,
    [Enum.TouchMovementMode.ClickToMove] = click_to_move_controller,
    [Enum.DevTouchMovementMode.ClickToMove] = click_to_move_controller,
    [Enum.TouchMovementMode.Default] = dynamic_thumbstick,
    [Enum.ComputerMovementMode.Default] = keyboard,
    [Enum.ComputerMovementMode.KeyboardMouse] = keyboard,
    [Enum.DevComputerMovementMode.KeyboardMouse] = keyboard,
    [Enum.DevComputerMovementMode.Scriptable] = nil,
    [Enum.ComputerMovementMode.ClickToMove] = click_to_move_controller,
    [Enum.DevComputerMovementMode.ClickToMove] = click_to_move_controller,
}
local values_3 = {
    [Enum.UserInputType.Keyboard] = keyboard,
    [Enum.UserInputType.MouseButton1] = keyboard,
    [Enum.UserInputType.MouseButton2] = keyboard,
    [Enum.UserInputType.MouseButton3] = keyboard,
    [Enum.UserInputType.MouseWheel] = keyboard,
    [Enum.UserInputType.MouseMovement] = keyboard,
    [Enum.UserInputType.Gamepad1] = gamepad,
    [Enum.UserInputType.Gamepad2] = gamepad,
    [Enum.UserInputType.Gamepad3] = gamepad,
    [Enum.UserInputType.Gamepad4] = gamepad,
}
local value_2 = nil

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

    if not user_input_service.TouchEnabled then
        instance:OnLastInputTypeChanged(user_input_service:GetLastInputType())

        return instance
    end

    instance.playerGui = players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if not instance.playerGui then
        instance.playerGuiAddedConn = players.LocalPlayer.ChildAdded:Connect(function(child)
            if not (child:IsA("PlayerGui")) then
                return
            end

            instance.playerGui = child
            instance:CreateTouchGuiContainer()
            instance.playerGuiAddedConn:Disconnect()
            instance.playerGuiAddedConn = nil
            instance:OnLastInputTypeChanged(user_input_service:GetLastInputType())
        end)

        return instance
    end

    instance:CreateTouchGuiContainer()
    instance:OnLastInputTypeChanged(user_input_service:GetLastInputType())

    return instance
end

function values.GetMoveVector(argument)
    return not argument.activeController and Vector3.new(0, 0, 0) or argument.activeController:GetMoveVector()
end

local function normalize_angle(argument)
    local remainder = (argument + 12.566370614359172) % 6.283185307179586

    if remainder > 3.141592653589793 then
        remainder -= 6.283185307179586
    end

    return remainder
end

local function average_angle(argument, argument_2)
    local remainder = (argument_2 - argument + 12.566370614359172) % 6.283185307179586

    if remainder > 3.141592653589793 then
        remainder -= 6.283185307179586
    end

    local remainder_2 = (argument + remainder / 2 + 12.566370614359172) % 6.283185307179586

    if remainder_2 > 3.141592653589793 then
        remainder_2 -= 6.283185307179586
    end

    return remainder_2
end

function values.GetEstimatedVRTorsoFrame(argument)
    local user_c_frame = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
    local _, value_3, _ = user_c_frame:ToEulerAnglesYXZ()
    local current_torso_angle = -value_3

    if
        vr_service:GetUserCFrameEnabled(Enum.UserCFrame.RightHand)
        and vr_service:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)
    then
        local user_c_frame2 = vr_service:GetUserCFrame(Enum.UserCFrame.LeftHand)
        local user_c_frame3 = vr_service:GetUserCFrame(Enum.UserCFrame.RightHand)
        local difference = user_c_frame.Position - user_c_frame2.Position
        local difference_2 = user_c_frame.Position - user_c_frame3.Position
        local negated_value = -math.atan2(difference.X, difference.Z)
        local remainder = (-math.atan2(difference_2.X, difference_2.Z) - negated_value + 12.566370614359172)
            % 6.283185307179586

        if remainder > 3.141592653589793 then
            remainder -= 6.283185307179586
        end

        local remainder_2 = (negated_value + remainder / 2 + 12.566370614359172) % 6.283185307179586

        if remainder_2 > 3.141592653589793 then
            remainder_2 -= 6.283185307179586
        end

        local remainder_3 = (current_torso_angle - argument.currentTorsoAngle + 12.566370614359172) % 6.283185307179586

        if remainder_3 > 3.141592653589793 then
            remainder_3 -= 6.283185307179586
        end

        local remainder_4 = (remainder_2 - argument.currentTorsoAngle + 12.566370614359172) % 6.283185307179586

        if remainder_4 > 3.141592653589793 then
            remainder_4 -= 6.283185307179586
        end

        local condition

        if remainder_4 > -1.5707963267948966 then
            condition = remainder_4 < 1.5707963267948966
        else
            condition = false
        end

        if not condition then
            remainder_4 = remainder_3
        end

        local minimum = math.min(remainder_4, remainder_3)
        local maximum = math.max(remainder_4, remainder_3)
        local number_4 = 0

        if minimum > 0 then
            maximum = minimum
        elseif maximum >= 0 then
            maximum = number_4
        end

        argument.currentTorsoAngle = maximum + argument.currentTorsoAngle
    else
        argument.currentTorsoAngle = current_torso_angle
    end

    return CFrame.new(user_c_frame.Position) * CFrame.fromEulerAnglesYXZ(0, -argument.currentTorsoAngle, 0)
end

function values.GetActiveController(argument)
    return argument.activeController
end

function values.UpdateActiveControlModuleEnabled(argument)
    local function _()
        argument.activeController:Enable(false)

        if result2_2 and argument.touchJumpController then
            argument.touchJumpController:Enable(false)
        end

        if argument.moveFunction then
            argument.moveFunction(players.LocalPlayer, Vector3.new(0, 0, 0), true)
        end
    end

    local function callback()
        if result2_2 then
            if
                argument.touchControlFrame
                and (
                    argument.activeControlModule == click_to_move_controller
                    or (
                        argument.activeControlModule == touch_thumbstick
                        or argument.activeControlModule == dynamic_thumbstick
                    )
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

            return
        end

        if argument.touchControlFrame then
            argument.activeController:Enable(true, argument.touchControlFrame)

            return
        end

        argument.activeController:Enable(true)
    end

    if not argument.activeController then
        return
    end

    if not argument.controlsEnabled then
        argument.activeController:Enable(false)

        if result2_2 and argument.touchJumpController then
            argument.touchJumpController:Enable(false)
        end

        if argument.moveFunction then
            argument.moveFunction(players.LocalPlayer, Vector3.new(0, 0, 0), true)
        end

        return
    end

    if
        gui_service.TouchControlsEnabled
        or not (
            user_input_service.TouchEnabled
            and (
                argument.activeControlModule == click_to_move_controller
                or (
                    argument.activeControlModule == touch_thumbstick
                    or argument.activeControlModule == dynamic_thumbstick
                )
            )
        )
    then
        callback()

        return
    end

    argument.activeController:Enable(false)

    if result2_2 and argument.touchJumpController then
        argument.touchJumpController:Enable(false)
    end

    if argument.moveFunction then
        argument.moveFunction(players.LocalPlayer, Vector3.new(0, 0, 0), true)
    end
end

function values.Enable(argument: table, controls_enabled: boolean?)
    argument.controlsEnabled = controls_enabled == nil and true or controls_enabled

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
    if not (user_input_service.KeyboardEnabled or user_input_service.GamepadEnabled) then
        return nil, false
    end

    local dev_computer_movement_mode = players.LocalPlayer.DevComputerMovementMode
    local value_entry

    if dev_computer_movement_mode == Enum.DevComputerMovementMode.UserChoice then
        value_entry = values_3[value_2]

        if
            user_game_settings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove
            and value_entry == keyboard
        then
            value_entry = click_to_move_controller
        end
    else
        value_entry = values_2[dev_computer_movement_mode]

        if not value_entry and dev_computer_movement_mode ~= Enum.DevComputerMovementMode.Scriptable then
            warn("No character control module is associated with DevComputerMovementMode ", dev_computer_movement_mode)
        end
    end

    if value_entry then
        return value_entry, true
    end

    if dev_computer_movement_mode == Enum.DevComputerMovementMode.Scriptable then
        return nil, true
    end

    return nil, false
end

function values.SelectTouchModule(argument)
    if not user_input_service.TouchEnabled then
        return nil, false
    end

    local dev_touch_movement_mode = players.LocalPlayer.DevTouchMovementMode
    local value_entry

    if dev_touch_movement_mode == Enum.DevTouchMovementMode.UserChoice then
        value_entry = values_2[user_game_settings.TouchMovementMode]
    else
        if dev_touch_movement_mode == Enum.DevTouchMovementMode.Scriptable then
            return nil, true
        end

        value_entry = values_2[dev_touch_movement_mode]
    end

    return value_entry, true
end

local function get_gamepad_right_thumbstick_position()
    local gamepad_state = user_input_service:GetGamepadState(Enum.UserInputType.Gamepad1)

    for _, input in pairs(gamepad_state) do
        if input.KeyCode == Enum.KeyCode.Thumbstick2 then
            return input.Position
        end
    end

    return Vector3.new(0, 0, 0)
end

function values.calculateRawMoveVector(argument: table, argument_2: userdata, argument_3: vector)
    local current_camera = workspace_2.CurrentCamera

    if not current_camera then
        return argument_3
    end

    local c_frame2 = current_camera.CFrame

    if vr_service.VREnabled and argument_2.RootPart then
        vr_service:GetUserCFrame(Enum.UserCFrame.Head)
        local estimated_vr_torso_frame = argument:GetEstimatedVRTorsoFrame()

        if (current_camera.Focus.Position - c_frame2.Position).Magnitude < 3 then
            c_frame2 *= estimated_vr_torso_frame
        else
            c_frame2 = current_camera.CFrame
                * (estimated_vr_torso_frame.Rotation + estimated_vr_torso_frame.Position * current_camera.HeadScale)
        end
    end

    if argument_2:GetState() ~= Enum.HumanoidStateType.Swimming then
        local _, _, _, value_3, value_4, product, _, _, value_5, _, _, value_6 = c_frame2:GetComponents()

        if value_5 >= 1 or value_5 <= -1 then
            product = -value_4 * math.sign(value_5)
        end

        local sqrt_result = math.sqrt(value_6 * value_6 + product * product)

        return Vector3.new(
            (value_6 * argument_3.X + product * argument_3.Z) / sqrt_result,
            0,
            (value_6 * argument_3.Z - product * argument_3.X) / sqrt_result
        )
    end

    if not vr_service.VREnabled then
        return c_frame2:VectorToWorldSpace(argument_3)
    end

    local vector_3 = Vector3.new(argument_3.X, 0, argument_3.Z)

    if vector_3.Magnitude < 0.01 then
        return Vector3.new(0, 0, 0)
    end

    local product_2 = -get_gamepad_right_thumbstick_position().Y * 1.3962634015954636
    local angle = math.atan2(-vector_3.X, -vector_3.Z)
    local _, value_7, _ = c_frame2:ToEulerAnglesYXZ()

    return CFrame.fromEulerAnglesYXZ(product_2, angle + value_7, 0).LookVector
end

local function calculate_raw_move_vector(argument: userdata, argument_2: vector)
    local current_camera = workspace_2.CurrentCamera

    if not current_camera then
        return argument_2
    end

    if argument:GetState() == Enum.HumanoidStateType.Swimming then
        return current_camera.CFrame:VectorToWorldSpace(argument_2)
    end

    local c_frame2 = current_camera.CFrame

    if
        vr_service.VREnabled
        and (argument.RootPart and (argument.RootPart.CFrame.Position - c_frame2.Position).Magnitude < 3)
    then
        c_frame2 *= vr_service:GetUserCFrame(Enum.UserCFrame.Head)
    end

    local _, _, _, value_3, value_4, product, _, _, value_5, _, _, value_6 = c_frame2:GetComponents()

    if value_5 >= 1 or value_5 <= -1 then
        product = -value_4 * math.sign(value_5)
    end

    local sqrt_result = math.sqrt(value_6 * value_6 + product * product)

    return Vector3.new(
        (value_6 * argument_2.X + product * argument_2.Z) / sqrt_result,
        0,
        (value_6 * argument_2.Z - product * argument_2.X) / sqrt_result
    )
end

local vector = Vector3.new()
local vector_2 = Vector3.new()
local number = 0
local number_2 = 0
local number_3 = 0

function values.OnRenderStepped(argument, argument_2)
    if not (argument.activeController and (argument.activeController.enabled and argument.humanoid)) then
        return
    end

    if not user_flag then
        argument.activeController:OnRenderStepped(argument_2)
    end

    local move_vector = argument.activeController:GetMoveVector()
    local is_move_vector_camera_relative_result = argument.activeController:IsMoveVectorCameraRelative()
    local click_to_move_controller2 = argument:GetClickToMoveController()

    if argument.activeController ~= click_to_move_controller2 then
        if move_vector.magnitude > 0 then
            click_to_move_controller2:CleanupPath()
        else
            click_to_move_controller2:OnRenderStepped(argument_2)
            move_vector = click_to_move_controller2:GetMoveVector()
            is_move_vector_camera_relative_result = click_to_move_controller2:IsMoveVectorCameraRelative()
        end
    end

    if argument.vehicleController then
        local value_3
        move_vector, value_3 = argument.vehicleController:Update(
            move_vector,
            is_move_vector_camera_relative_result,
            argument.activeControlModule == gamepad
        )
    end

    if is_move_vector_camera_relative_result then
        move_vector = calculate_raw_move_vector(argument.humanoid, move_vector)
    end

    local jump = argument.activeController:GetIsJumping()
        or argument.touchJumpController and argument.touchJumpController:GetIsJumping()
    vector = move_vector
    vector_2 = vector_2:Lerp(vector, (math.clamp(argument_2 * 10, 0, 1)))
    local x = vector_2.X
    local y = vector_2.Y
    local z = vector_2.Z
    local x_2 = x < number and (x > 0 and x < 0.1) and 0 or (number < x and (x < 0 and x > -0.1) and 0 or x)
    local y_2 = y < number_2 and (y > 0 and y < 0.1) and 0 or (number_2 < y and (y < 0 and y > -0.1) and 0 or y)
    local z_2 = z < number_3 and (z > 0 and z < 0.1) and 0 or (number_3 < z and (z < 0 and z > -0.1) and 0 or z)
    vector_2 = Vector3.new(x_2, y_2, z_2)
    number = x_2
    number_2 = y_2
    number_3 = z_2
    argument.moveFunction(players.LocalPlayer, vector_2, false)
    argument.humanoid.Jump = jump
end

function values.updateVRMoveVector(argument, vector_3)
    local workspace_current_camera = workspace.CurrentCamera

    if
        vector_3.Magnitude ~= 0
        or (
            (workspace_current_camera.Focus.Position - workspace_current_camera.CFrame.Position).Magnitude >= 5
            or not (vr_service.AvatarGestures and (argument.humanoid and not argument.humanoid.Sit))
        )
    then
        return vector_3
    end

    local user_c_frame = vr_service:GetUserCFrame(Enum.UserCFrame.Head)
    local difference = (
        workspace_current_camera.CFrame
        * (user_c_frame.Rotation + user_c_frame.Position * workspace_current_camera.HeadScale)
        * CFrame.new(0, -0.7 * argument.humanoid.RootPart.Size.Y / 2, 0)
    ).Position - argument.humanoid.RootPart.CFrame.Position

    return Vector3.new(difference.x, 0, difference.z)
end

function values.OnHumanoidSeated(argument: table, argument_2: boolean, argument_3: userdata)
    if argument_2 then
        if argument_3 and argument_3:IsA("VehicleSeat") then
            if not argument.vehicleController then
                argument.vehicleController = argument.vehicleController.new(value)
            end

            argument.vehicleController:Enable(true, argument_3)
        end
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
    if argument.touchGui then
        argument.touchGui.Enabled = argument.humanoid and gui_service.TouchControlsEnabled and true or false
    end
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

            if not result2_2 then
                if
                    argument.touchControlFrame
                    and (
                        argument.activeControlModule == click_to_move_controller
                        or (
                            argument.activeControlModule == touch_thumbstick
                            or argument.activeControlModule == dynamic_thumbstick
                        )
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

        return
    end

    if argument.activeController then
        argument.activeController:Enable(false)
    end

    argument.activeController = nil
    argument.activeControlModule = nil
end

function values.OnLastInputTypeChanged(argument, argument_2)
    if value_2 == argument_2 then
        warn("LastInputType Change listener called with current type.")
    end

    value_2 = argument_2

    if value_2 == Enum.UserInputType.Touch then
        local select_touch_module_result, value_3 = argument:SelectTouchModule()

        if value_3 then
            while not argument.touchControlFrame do
                wait()
            end

            argument:SwitchToController(select_touch_module_result)
        end
    elseif values_3[value_2] ~= nil then
        local select_computer_movement_module_result = argument:SelectComputerMovementModule()

        if select_computer_movement_module_result then
            argument:SwitchToController(select_computer_movement_module_result)
        end
    end

    argument:UpdateTouchGuiVisibility()
end

function values.OnComputerMovementModeChange(argument)
    local select_computer_movement_module_result, value_3 = argument:SelectComputerMovementModule()

    if value_3 then
        argument:SwitchToController(select_computer_movement_module_result)
    end
end

function values.OnTouchMovementModeChange(argument)
    local select_touch_module_result, value_3 = argument:SelectTouchModule()

    if value_3 then
        while not argument.touchControlFrame do
            wait()
        end

        argument:SwitchToController(select_touch_module_result)
    end
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

    if result_2 then
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
