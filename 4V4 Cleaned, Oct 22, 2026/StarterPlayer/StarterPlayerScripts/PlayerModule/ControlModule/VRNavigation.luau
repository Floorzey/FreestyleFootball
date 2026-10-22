local vr_service = game:GetService("VRService")
local user_input_service = game:GetService("UserInputService")
local run_service = game:GetService("RunService")
local players = game:GetService("Players")
local pathfinding_service = game:GetService("PathfindingService")
local context_action_service = game:GetService("ContextActionService")
local starter_gui = game:GetService("StarterGui")
local value = nil
local local_player = players.LocalPlayer

local function is_finite(argument)
    return (argument == argument) and ((argument ~= math.huge) and (argument ~= -math.huge))
end

local function is_finite_vector3(argument)
    local x = argument.x
    local condition = (x == x) and ((x ~= math.huge) and (x ~= -math.huge))

    if condition then
        local y = argument.y
        condition = (y == y) and ((y ~= math.huge) and (y ~= -math.huge))

        if condition then
            local _ = argument.z
            condition = argument.z == argument.z and argument.z ~= math.huge and argument.z ~= -math.huge
        end
    end

    return condition
end

local movement_update = Instance.new("BindableEvent")
movement_update.Name = "MovementUpdate"
movement_update.Parent = script
coroutine.wrap(function()
    local path_display = script.Parent:WaitForChild("PathDisplay")

    if not path_display then
        return
    end

    value = require(path_display)
end)()
local base_character_controller = require(script.Parent:WaitForChild("BaseCharacterController"))
local vr_navigation = setmetatable({}, base_character_controller)
vr_navigation.__index = vr_navigation

function vr_navigation.new(control_action_priority)
    local instance = setmetatable(base_character_controller.new(), vr_navigation)
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
        if not (child:IsA("Humanoid")) then
            continue
        end

        return child
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
    elseif argument:HasAnyHandControllers() then
        return true
    else
        return not argument:HasGamepad()
    end
end

function vr_navigation.StartFollowingPath(argument, argument_2)
    currentPath = argument_2
    currentPoints = currentPath:GetPointCoordinates()
    currentPointIdx = 1
    moving = true
    timeReachedLastPoint = tick()
    local local_humanoid = argument:GetLocalHumanoid()

    if local_humanoid and local_humanoid.Torso and #currentPoints >= 1 then
        expectedTimeToNextPoint = (currentPoints[1] - local_humanoid.Torso.Position).magnitude
            / local_humanoid.WalkSpeed
    end

    movement_update:Fire("targetPoint", argument.currentDestination)
end

function vr_navigation.GoToPoint(argument, argument_2)
    currentPath = true
    currentPoints = { argument_2 }
    currentPointIdx = 1
    moving = true
    local local_humanoid = argument:GetLocalHumanoid()
    timeReachedLastPoint = tick()
    expectedTimeToNextPoint = (local_humanoid.Torso.Position - argument_2).magnitude / local_humanoid.WalkSpeed
    movement_update:Fire("targetPoint", argument_2)
end

function vr_navigation.StopFollowingPath(argument)
    currentPath = nil
    currentPoints = nil
    currentPointIdx = 0
    moving = false
    argument.moveVector = Vector3.new(0, 0, 0)
end

function vr_navigation.TryComputePath(argument, sum, sum_2)
    local number = 0
    local value_2 = nil

    while not value_2 and (number < 5) do
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

function vr_navigation.OnNavigationRequest(argument, argument_2, argument_3)
    local position = argument_2.Position
    local current_destination = argument.currentDestination
    local x = position.x
    local condition = (x == x) and ((x ~= math.huge) and (x ~= -math.huge))

    if condition then
        local y = position.y
        condition = (y == y) and ((y ~= math.huge) and (y ~= -math.huge))

        if condition then
            local _ = position.z
            condition = position.z == position.z and position.z ~= math.huge and position.z ~= -math.huge
        end
    end

    if not condition then
        return
    end

    argument.currentDestination = position
    local local_humanoid = argument:GetLocalHumanoid()

    if not local_humanoid then
        return
    end

    if not local_humanoid.Torso then
        return
    end

    condition = local_humanoid.Torso.Position

    if (argument.currentDestination - condition).magnitude < 12 then
        argument:GoToPoint(argument.currentDestination)
    else
        if current_destination and not ((argument.currentDestination - current_destination).magnitude > 4) then
            if moving then
                argument.currentPoints[#currentPoints] = argument.currentDestination
            else
                argument:GoToPoint(argument.currentDestination)
            end

            return
        end

        local try_compute_path_result = argument:TryComputePath(condition, argument.currentDestination)

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
        if argument.isJumpBound then
            return
        end

        argument.isJumpBound = true

        context_action_service:BindActionAtPriority("VRJumpAction", function()
            return argument:OnJumpAction()
        end, false, argument.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonA)
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
                movement_update:Fire("offtrack")
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

    if not local_humanoid or not local_humanoid.Torso then
        return
    end

    if argument.moving and argument.currentPoints then
        local position = local_humanoid.Torso.Position
        local product = (currentPoints[1] - position) * Vector3.new(1, 0, 1)
        local magnitude = product.magnitude
        local quotient = product / magnitude

        if magnitude < 1 then
            product = 0
            local current_point_entry = currentPoints[1]

            for key, item in pairs(currentPoints) do
                if key ~= 1 then
                    product += (item - current_point_entry).magnitude / local_humanoid.WalkSpeed
                    current_point_entry = item
                end
            end

            table.remove(currentPoints, 1)
            currentPointIdx = currentPointIdx + 1

            if #currentPoints ~= 0 then
                if value then
                    value.setCurrentPoints(currentPoints)
                    value.renderPath()
                end

                expectedTimeToNextPoint = (currentPoints[1] - position).magnitude / local_humanoid.WalkSpeed
                timeReachedLastPoint = tick()
                local x = move_vector.x
                local condition = (x == x) and ((x ~= math.huge) and (x ~= -math.huge))

                if condition then
                    x = move_vector.y
                    condition = (x == x) and ((x ~= math.huge) and (x ~= -math.huge))

                    if condition then
                        x = move_vector.z
                        condition = move_vector.z == move_vector.z
                            and move_vector.z ~= math.huge
                            and move_vector.z ~= -math.huge
                    end
                end

                if condition then
                    argument.moveVector = move_vector
                end
            else
                argument:StopFollowingPath()

                if value then
                    value.clearRenderedPath()
                end
            end
        else
            local values = { game.Players.LocalPlayer.Character, workspace.CurrentCamera }
            local hit_part, value_2 =
                workspace:FindPartOnRayWithIgnoreList(Ray.new(position - Vector3.new(0, 1, 0), quotient * 3), values)
            local value_3 = nil

            if hit_part then
                local _, value_4 = workspace:FindPartOnRayWithIgnoreList(
                    Ray.new((value_2 + (quotient * 0.5)) + Vector3.new(0, 100, 0), Vector3.new(-0, -100, -0)),
                    values
                )
                value_3 = value_4.Y - position.Y

                if value_3 < 6 and value_3 > -2 then
                    local_humanoid.Jump = true
                end
            end

            if expectedTimeToNextPoint + 2 < tick() - timeReachedLastPoint then
                argument:StopFollowingPath()

                if value then
                    value.clearRenderedPath()
                end

                movement_update:Fire("offtrack")
            end

            move_vector = argument.moveVector:Lerp(quotient, argument_2 * 10)
            local x_2 = move_vector.x
            local condition_2 = (x_2 == x_2) and ((x_2 ~= math.huge) and (x_2 ~= -math.huge))

            if condition_2 then
                local y = move_vector.y
                condition_2 = (y == y) and ((y ~= math.huge) and (y ~= -math.huge))

                if condition_2 then
                    local _ = move_vector.z
                    condition_2 = move_vector.z == move_vector.z
                        and move_vector.z ~= math.huge
                        and move_vector.z ~= -math.huge
                end
            end

            if condition_2 then
                argument.moveVector = move_vector
            end
        end
    else
        local x_3 = move_vector.x
        local condition_3 = (x_3 == x_3) and ((x_3 ~= math.huge) and (x_3 ~= -math.huge))

        if condition_3 then
            local y_2 = move_vector.y
            condition_3 = (y_2 == y_2) and ((y_2 ~= math.huge) and (y_2 ~= -math.huge))

            if condition_3 then
                local _ = move_vector.z
                condition_3 = move_vector.z == move_vector.z
                    and move_vector.z ~= math.huge
                    and move_vector.z ~= -math.huge
            end
        end

        if condition_3 then
            argument.moveVector = move_vector
        end
    end
end

function vr_navigation.OnUserCFrameEnabled(argument)
    if argument:ShouldUseNavigationLaser() then
        argument:BindJumpAction(false)
        argument:SetLaserPointerMode("Navigation")
    else
        argument:BindJumpAction(true)
        argument:SetLaserPointerMode("Hidden")
    end
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
    else
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
end

return vr_navigation
