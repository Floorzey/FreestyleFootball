local context_action_service = game:GetService("ContextActionService")
local vehicle_controller = {}
vehicle_controller.__index = vehicle_controller

function vehicle_controller.new(control_action_priority)
    local instance = setmetatable({}, vehicle_controller)
    instance.CONTROL_ACTION_PRIORITY = control_action_priority
    instance.enabled = false
    instance.vehicleSeat = nil
    instance.throttle = 0
    instance.steer = 0
    instance.acceleration = 0
    instance.decceleration = 0
    instance.turningRight = 0
    instance.turningLeft = 0
    instance.vehicleMoveVector = Vector3.new(0, 0, 0)
    instance.autoPilot = {}
    instance.autoPilot.MaxSpeed = 0
    instance.autoPilot.MaxSteeringAngle = 0

    return instance
end

function vehicle_controller.BindContextActions(argument)
    context_action_service:BindActionAtPriority("throttleAccel", function(argument_2, argument_3, argument_4)
        argument:OnThrottleAccel(argument_2, argument_3, argument_4)

        return Enum.ContextActionResult.Pass
    end, false, argument.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonR2)

    context_action_service:BindActionAtPriority("throttleDeccel", function(argument_2, argument_3, argument_4)
        argument:OnThrottleDeccel(argument_2, argument_3, argument_4)

        return Enum.ContextActionResult.Pass
    end, false, argument.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonL2)

    context_action_service:BindActionAtPriority("arrowSteerRight", function(argument_2, argument_3, argument_4)
        argument:OnSteerRight(argument_2, argument_3, argument_4)

        return Enum.ContextActionResult.Pass
    end, false, argument.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Right)

    context_action_service:BindActionAtPriority("arrowSteerLeft", function(argument_2, argument_3, argument_4)
        argument:OnSteerLeft(argument_2, argument_3, argument_4)

        return Enum.ContextActionResult.Pass
    end, false, argument.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Left)
end

function vehicle_controller.Enable(argument, enabled, vehicle_seat)
    if not (enabled ~= argument.enabled or vehicle_seat ~= argument.vehicleSeat) then
        return
    end

    argument.enabled = enabled
    argument.vehicleMoveVector = Vector3.new(0, 0, 0)

    if enabled then
        if not vehicle_seat then
            return
        end

        argument.vehicleSeat = vehicle_seat
        argument:SetupAutoPilot()
        argument:BindContextActions()
    else
        context_action_service:UnbindAction("throttleAccel")
        context_action_service:UnbindAction("throttleDeccel")
        context_action_service:UnbindAction("arrowSteerRight")
        context_action_service:UnbindAction("arrowSteerLeft")
        argument.vehicleSeat = nil
    end
end

function vehicle_controller.OnThrottleAccel(argument, argument_2, argument_3, argument_4)
    if argument_3 == Enum.UserInputState.End or argument_3 == Enum.UserInputState.Cancel then
        argument.acceleration = 0
    else
        argument.acceleration = -1
    end

    argument.throttle = argument.acceleration + argument.decceleration
end

function vehicle_controller.OnThrottleDeccel(argument, argument_2, argument_3, argument_4)
    if argument_3 == Enum.UserInputState.End or argument_3 == Enum.UserInputState.Cancel then
        argument.decceleration = 0
    else
        argument.decceleration = 1
    end

    argument.throttle = argument.acceleration + argument.decceleration
end

function vehicle_controller.OnSteerRight(argument, argument_2, argument_3, argument_4)
    if argument_3 == Enum.UserInputState.End or argument_3 == Enum.UserInputState.Cancel then
        argument.turningRight = 0
    else
        argument.turningRight = 1
    end

    argument.steer = argument.turningRight + argument.turningLeft
end

function vehicle_controller.OnSteerLeft(argument, argument_2, argument_3, argument_4)
    if argument_3 == Enum.UserInputState.End or argument_3 == Enum.UserInputState.Cancel then
        argument.turningLeft = 0
    else
        argument.turningLeft = -1
    end

    argument.steer = argument.turningRight + argument.turningLeft
end

function vehicle_controller.Update(argument, sum, argument_2, argument_3)
    if not argument.vehicleSeat then
        return sum, false
    end

    if argument_2 then
        sum += Vector3.new(argument.steer, 0, argument.throttle)
        argument.vehicleSeat.ThrottleFloat = -sum.Z
        argument.vehicleSeat.SteerFloat = sum.X

        return sum, true
    end

    local relative_vector = argument.vehicleSeat.Occupant.RootPart.CFrame:VectorToObjectSpace(sum)
    argument.vehicleSeat.ThrottleFloat = argument:ComputeThrottle(relative_vector)
    argument.vehicleSeat.SteerFloat = argument:ComputeSteer(relative_vector)

    return Vector3.new(0, 0, 0), true
end

function vehicle_controller.ComputeThrottle(argument, argument_2)
    if argument_2 == Vector3.new(0, 0, 0) then
        return 0
    end

    return -argument_2.Z
end

function vehicle_controller.ComputeSteer(argument, argument_2)
    if argument_2 == Vector3.new(0, 0, 0) then
        return 0
    end

    return -math.atan2(-argument_2.x, -argument_2.z) * 57.29577951308232 / argument.autoPilot.MaxSteeringAngle
end

function vehicle_controller.SetupAutoPilot(argument)
    argument.autoPilot.MaxSpeed = argument.vehicleSeat.MaxSpeed
    argument.autoPilot.MaxSteeringAngle = 35
end

return vehicle_controller
