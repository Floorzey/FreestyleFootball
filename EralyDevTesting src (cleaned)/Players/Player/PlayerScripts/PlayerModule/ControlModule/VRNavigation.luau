local vr_service = game:GetService("VRService")
local user_input_service = game:GetService("UserInputService")
local run_service = game:GetService("RunService")
local players = game:GetService("Players")
local pathfinding_service = game:GetService("PathfindingService")
local context_action_service = game:GetService("ContextActionService")
local starter_gui = game:GetService("StarterGui")
local value = nil
local local_player = players.LocalPlayer

local function is_finite(argument: number)
    local condition

    if argument == argument and argument ~= (1 / 0) then
        condition = argument ~= (-1 / 0)
    else
        condition = false
    end

    return condition
end

local function is_finite_vector3(argument)
    local x = argument.x
    local condition

    if x == x and x ~= (1 / 0) then
        condition = x ~= (-1 / 0)
    else
        condition = false
    end

    if condition then
        local y = argument.y

        if y == y and y ~= (1 / 0) then
            condition = y ~= (-1 / 0)
        else
            condition = false
        end

        if condition then
            local z = argument.z

            if z == z and z ~= (1 / 0) then
                condition = z ~= (-1 / 0)
            else
                condition = false
            end
        end
    end

    return condition
end

local bindable_event = Instance.new("BindableEvent")
bindable_event.Name = "MovementUpdate"
bindable_event.Parent = script
coroutine.wrap(function()
    local path_display = script.Parent:WaitForChild("PathDisplay")

    if path_display then
        value = require(path_display)
    end
end)()
local base_character_controller = require(script.Parent:WaitForChild("BaseCharacterController"))
local vr_navigation = setmetatable({}, base_character_controller)
vr_navigation.__index = vr_navigation

function vr_navigation.new(control_action_priority)
    local base_character_controller_2 = base_character_controller.new()
    local instance = setmetatable(base_character_controller_2, vr_navigation)
    instance.CONTROL_ACTION_PRIORITY = control_action_priority
    instance.navigationRequestedConn = nil
    instance.heartbeatConn = nil
    instance.currentDestination = nil
    instance.currentPath = nil
    instance.currentPoints = nil
    instance.currentPointIdx = 0
    instance.expectedTimeToNextPoint = 0
    instance.timeReachedLastPoint = tick()
    instance.moving = false
    instance.isJumpBound = false
    instance.moveLatch = false
    instance.userCFrameEnabledConn = nil

    return instance
end

function vr_navigation.SetLaserPointerMode(argument, argument_2)
    pcall(function()
        starter_gui:SetCore("VRLaserPointerMode", argument_2)
    end)
end

function vr_navigation.GetLocalHumanoid(argument)
    local character = local_player.Character

    if not character then
        return
    end

    for _, child in pairs(character:GetChildren()) do
        if child:IsA("Humanoid") then
            return child
        end
    end

    return nil
end

function vr_navigation.HasBothHandControllers(argument)
    return vr_service:GetUserCFrameEnabled(Enum.UserCFrame.RightHand)
        and vr_service:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)
end

function vr_navigation.HasAnyHandControllers(argument)
    return vr_service:GetUserCFrameEnabled(Enum.UserCFrame.RightHand)
        or vr_service:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)
end

function vr_navigation.IsMobileVR(argument)
    return user_input_service.TouchEnabled
end

function vr_navigation.HasGamepad(argument)
    return user_input_service.GamepadEnabled
end

function vr_navigation.ShouldUseNavigationLaser(argument)
    if argument:IsMobileVR() then
        return true
    end

    if argument:HasBothHandControllers() then
        return false
    end

    return argument:HasAnyHandControllers() and true or not argument:HasGamepad()
end

function vr_navigation.StartFollowingPath(argument, argument_2)
    currentPath = argument_2
    currentPoints = currentPath:GetPointCoordinates()
    currentPointIdx = 1
    moving = true
    timeReachedLastPoint = tick()
    local local_humanoid = argument:GetLocalHumanoid()

    if local_humanoid and (local_humanoid.Torso and #currentPoints >= 1) then
        expectedTimeToNextPoint = (currentPoints[1] - local_humanoid.Torso.Position).magnitude
            / local_humanoid.WalkSpeed
    end

    bindable_event:Fire("targetPoint", argument.currentDestination)
end

function vr_navigation.GoToPoint(argument, argument_2)
    currentPath = true
    currentPoints = { argument_2 }
    currentPointIdx = 1
    moving = true
    local local_humanoid = argument:GetLocalHumanoid()
    local quotient = (local_humanoid.Torso.Position - argument_2).magnitude / local_humanoid.WalkSpeed
    timeReachedLastPoint = tick()
    expectedTimeToNextPoint = quotient
    bindable_event:Fire("targetPoint", argument_2)
end

function vr_navigation.StopFollowingPath(argument)
    currentPath = nil
    currentPoints = nil
    currentPointIdx = 0
    moving = false
    argument.moveVector = Vector3.new(0, 0, 0)
end

function vr_navigation.TryComputePath(argument: table, sum: vector, sum_2: vector)
    local value_2 = nil
    local number = 0

    while not value_2 and number < 5 do
        value_2 = pathfinding_service:ComputeSmoothPathAsync(sum, sum_2, 200)
        number += 1

        if value_2.Status == Enum.PathStatus.ClosestNoPath or value_2.Status == Enum.PathStatus.ClosestOutOfRange then
            return nil
        end

        if value_2 and value_2.Status == Enum.PathStatus.FailStartNotEmpty then
            sum += (sum_2 - sum).Unit
            value_2 = nil
        end

        if value_2 and value_2.Status == Enum.PathStatus.FailFinishNotEmpty then
            sum_2 += Vector3.new(0, 1, 0)
            value_2 = nil
        end
    end

    return value_2
end

function vr_navigation.OnNavigationRequest(argument: table, argument_2, argument_3)
    local position = argument_2.Position
    local current_destination = argument.currentDestination
    local x = position.x
    local condition

    if x == x and x ~= (1 / 0) then
        condition = x ~= (-1 / 0)
    else
        condition = false
    end

    if condition then
        local y = position.y

        if y == y and y ~= (1 / 0) then
            condition = y ~= (-1 / 0)
        else
            condition = false
        end

        if condition then
            local z = position.z

            if z == z and z ~= (1 / 0) then
                condition = z ~= (-1 / 0)
            else
                condition = false
            end
        end
    end

    if not condition then
        return
    end

    argument.currentDestination = position
    local local_humanoid = argument:GetLocalHumanoid()

    if not (local_humanoid and local_humanoid.Torso) then
        return
    end

    local position2 = local_humanoid.Torso.Position

    if (argument.currentDestination - position2).magnitude < 12 then
        argument:GoToPoint(argument.currentDestination)

        return
    end

    if current_destination and (argument.currentDestination - current_destination).magnitude <= 4 then
        if moving then
            argument.currentPoints[#currentPoints] = argument.currentDestination

            return
        end

        argument:GoToPoint(argument.currentDestination)
    else
        local try_compute_path_result = argument:TryComputePath(position2, argument.currentDestination)

        if try_compute_path_result then
            argument:StartFollowingPath(try_compute_path_result)

            if value then
                value.setCurrentPoints(argument.currentPoints)
                value.renderPath()
            end
        else
            argument:StopFollowingPath()

            if value then
                value.clearRenderedPath()
            end
        end
    end
end

function vr_navigation.OnJumpAction(argument, argument_2, argument_3, argument_4)
    if argument_3 == Enum.UserInputState.Begin then
        argument.isJumping = true
    end

    return Enum.ContextActionResult.Sink
end

function vr_navigation.BindJumpAction(argument, argument_2)
    if argument_2 then
        if not argument.isJumpBound then
            argument.isJumpBound = true

            context_action_service:BindActionAtPriority("VRJumpAction", function()
                return argument:OnJumpAction()
            end, false, argument.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonA)
        end
    elseif argument.isJumpBound then
        argument.isJumpBound = false
        context_action_service:UnbindAction("VRJumpAction")
    end
end

function vr_navigation.ControlCharacterGamepad(argument, argument_2, argument_3, input)
    if input.KeyCode ~= Enum.KeyCode.Thumbstick1 then
        return
    end

    if argument_3 ~= Enum.UserInputState.Cancel then
        if argument_3 == Enum.UserInputState.End then
            argument.moveVector = Vector3.new(0, 0, 0)

            if argument:ShouldUseNavigationLaser() then
                argument:BindJumpAction(false)
                argument:SetLaserPointerMode("Navigation")
            end

            if argument.moveLatch then
                argument.moveLatch = false
                bindable_event:Fire("offtrack")
            end
        else
            argument:StopFollowingPath()

            if value then
                value.clearRenderedPath()
            end

            if argument:ShouldUseNavigationLaser() then
                argument:BindJumpAction(true)
                argument:SetLaserPointerMode("Hidden")
            end

            if input.Position.magnitude > 0.22 then
                argument.moveVector = Vector3.new(input.Position.X, 0, -input.Position.Y)

                if argument.moveVector.magnitude > 0 then
                    argument.moveVector = argument.moveVector.unit * math.min(1, input.Position.magnitude)
                end

                argument.moveLatch = true
            end
        end

        return Enum.ContextActionResult.Sink
    end

    argument.moveVector = Vector3.new(0, 0, 0)
end

function vr_navigation.OnHeartbeat(argument, argument_2)
    local move_vector = argument.moveVector
    local local_humanoid = argument:GetLocalHumanoid()

    if not (local_humanoid and local_humanoid.Torso) then
        return
    end

    if argument.moving and argument.currentPoints then
        local position = local_humanoid.Torso.Position
        local product = (currentPoints[1] - position) * Vector3.new(1, 0, 1)
        local magnitude = product.magnitude
        local quotient = product / magnitude

        if magnitude < 1 then
            local current_point_entry = currentPoints[1]
            local number = 0

            for key, item in pairs(currentPoints) do
                if key ~= 1 then
                    number += (item - current_point_entry).magnitude / local_humanoid.WalkSpeed
                    current_point_entry = item
                end
            end

            table.remove(currentPoints, 1)
            currentPointIdx = currentPointIdx + 1

            if #currentPoints == 0 then
                argument:StopFollowingPath()

                if value then
                    value.clearRenderedPath()
                end

                return
            end

            if value then
                value.setCurrentPoints(currentPoints)
                value.renderPath()
            end

            expectedTimeToNextPoint = (currentPoints[1] - position).magnitude / local_humanoid.WalkSpeed
            timeReachedLastPoint = tick()
        else
            local values = { game.Players.LocalPlayer.Character, workspace.CurrentCamera }
            local ray = Ray.new(position - Vector3.new(0, 1, 0), quotient * 3)
            local hit_part, value_2, _ = workspace:FindPartOnRayWithIgnoreList(ray, values)

            if hit_part then
                local ray_2 = Ray.new(value_2 + quotient * 0.5 + Vector3.new(0, 100, 0), Vector3.new(-0, -100, -0))
                local _, value_3, _ = workspace:FindPartOnRayWithIgnoreList(ray_2, values)
                local difference = value_3.Y - position.Y

                if difference < 6 and difference > -2 then
                    local_humanoid.Jump = true
                end
            end

            if tick() - timeReachedLastPoint > expectedTimeToNextPoint + 2 then
                argument:StopFollowingPath()

                if value then
                    value.clearRenderedPath()
                end

                bindable_event:Fire("offtrack")
            end

            move_vector = argument.moveVector:Lerp(quotient, argument_2 * 10)
        end
    end

    local x = move_vector.x
    local condition

    if x == x and x ~= (1 / 0) then
        condition = x ~= (-1 / 0)
    else
        condition = false
    end

    if condition then
        local y = move_vector.y

        if y == y and y ~= (1 / 0) then
            condition = y ~= (-1 / 0)
        else
            condition = false
        end

        if condition then
            local z = move_vector.z

            if z == z and z ~= (1 / 0) then
                condition = z ~= (-1 / 0)
            else
                condition = false
            end
        end
    end

    if condition then
        argument.moveVector = move_vector
    end
end

function vr_navigation.OnUserCFrameEnabled(argument)
    if argument:ShouldUseNavigationLaser() then
        argument:BindJumpAction(false)
        argument:SetLaserPointerMode("Navigation")

        return
    end

    argument:BindJumpAction(true)
    argument:SetLaserPointerMode("Hidden")
end

function vr_navigation.Enable(argument, argument_2)
    argument.moveVector = Vector3.new(0, 0, 0)
    argument.isJumping = false

    if argument_2 then
        argument.navigationRequestedConn = vr_service.NavigationRequested:Connect(function(argument_3, argument_4)
            argument:OnNavigationRequest(argument_3, argument_4)
        end)
        argument.heartbeatConn = run_service.Heartbeat:Connect(function(delta_time)
            argument:OnHeartbeat(delta_time)
        end)

        context_action_service:BindAction("MoveThumbstick", function(argument_3, argument_4, argument_5)
            return argument:ControlCharacterGamepad(argument_3, argument_4, argument_5)
        end, false, argument.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Thumbstick1)

        context_action_service:BindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
        argument.userCFrameEnabledConn = vr_service.UserCFrameEnabled:Connect(function()
            argument:OnUserCFrameEnabled()
        end)
        argument:OnUserCFrameEnabled()
        vr_service:SetTouchpadMode(Enum.VRTouchpad.Left, Enum.VRTouchpadMode.VirtualThumbstick)
        vr_service:SetTouchpadMode(Enum.VRTouchpad.Right, Enum.VRTouchpadMode.ABXY)
        argument.enabled = true

        return
    end

    argument:StopFollowingPath()
    context_action_service:UnbindAction("MoveThumbstick")
    context_action_service:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
    argument:BindJumpAction(false)
    argument:SetLaserPointerMode("Disabled")

    if argument.navigationRequestedConn then
        argument.navigationRequestedConn:Disconnect()
        argument.navigationRequestedConn = nil
    end

    if argument.heartbeatConn then
        argument.heartbeatConn:Disconnect()
        argument.heartbeatConn = nil
    end

    if argument.userCFrameEnabledConn then
        argument.userCFrameEnabledConn:Disconnect()
        argument.userCFrameEnabledConn = nil
    end

    argument.enabled = false
end

return vr_navigation
