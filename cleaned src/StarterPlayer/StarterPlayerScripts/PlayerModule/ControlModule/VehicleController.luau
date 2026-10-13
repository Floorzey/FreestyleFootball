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

function vehicle_controller.BindContextActions(self)
    context_action_service:BindActionAtPriority("throttleAccel", function(argument, argument_2, argument_3)
        self:OnThrottleAccel(argument, argument_2, argument_3)
        return Enum.ContextActionResult.Pass
    end, false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonR2)
    context_action_service:BindActionAtPriority("throttleDeccel", function(argument, argument_2, argument_3)
        self:OnThrottleDeccel(argument, argument_2, argument_3)
        return Enum.ContextActionResult.Pass
    end, false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonL2)
    context_action_service:BindActionAtPriority("arrowSteerRight", function(argument, argument_2, argument_3)
        self:OnSteerRight(argument, argument_2, argument_3)
        return Enum.ContextActionResult.Pass
    end, false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Right)
    context_action_service:BindActionAtPriority("arrowSteerLeft", function(argument, argument_2, argument_3)
        self:OnSteerLeft(argument, argument_2, argument_3)
        return Enum.ContextActionResult.Pass
    end, false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Left)
end

function vehicle_controller.Enable(self, enabled, vehicle_seat)
    if enabled ~= self.enabled or vehicle_seat ~= self.vehicleSeat then
        self.enabled = enabled
        self.vehicleMoveVector = Vector3.new(0, 0, 0)
        if enabled then
            if not vehicle_seat then
                return
            end
            self.vehicleSeat = vehicle_seat
            self:SetupAutoPilot()
            self:BindContextActions()
        else
            context_action_service:UnbindAction("throttleAccel")
            context_action_service:UnbindAction("throttleDeccel")
            context_action_service:UnbindAction("arrowSteerRight")
            context_action_service:UnbindAction("arrowSteerLeft")
            self.vehicleSeat = nil
        end
    end
end

function vehicle_controller.OnThrottleAccel(self, argument, argument_2, argument_3)
    if argument_2 == Enum.UserInputState.End or argument_2 == Enum.UserInputState.Cancel then
        self.acceleration = 0
    else
        self.acceleration = -1
    end
    self.throttle = self.acceleration + self.decceleration
end

function vehicle_controller.OnThrottleDeccel(self, argument, argument_2, argument_3)
    if argument_2 == Enum.UserInputState.End or argument_2 == Enum.UserInputState.Cancel then
        self.decceleration = 0
    else
        self.decceleration = 1
    end
    self.throttle = self.acceleration + self.decceleration
end

function vehicle_controller.OnSteerRight(self, argument, argument_2, argument_3)
    if argument_2 == Enum.UserInputState.End or argument_2 == Enum.UserInputState.Cancel then
        self.turningRight = 0
    else
        self.turningRight = 1
    end
    self.steer = self.turningRight + self.turningLeft
end

function vehicle_controller.OnSteerLeft(self, argument, argument_2, argument_3)
    if argument_2 == Enum.UserInputState.End or argument_2 == Enum.UserInputState.Cancel then
        self.turningLeft = 0
    else
        self.turningLeft = -1
    end
    self.steer = self.turningRight + self.turningLeft
end

function vehicle_controller.Update(self, computed_value_offset, argument, argument_2)
    if self.vehicleSeat then
        if argument then
            computed_value_offset += Vector3.new(self.steer, 0, self.throttle)
            self.vehicleSeat.ThrottleFloat = -computed_value_offset.Z
            self.vehicleSeat.SteerFloat = computed_value_offset.X
            return computed_value_offset, true
        else
            local relative_vector = self.vehicleSeat.Occupant.RootPart.CFrame:VectorToObjectSpace(computed_value_offset)
            self.vehicleSeat.ThrottleFloat = self:ComputeThrottle(relative_vector)
            self.vehicleSeat.SteerFloat = self:ComputeSteer(relative_vector)
            return Vector3.new(0, 0, 0), true
        end
    else
        return computed_value_offset, false
    end
end

function vehicle_controller.ComputeThrottle(self, argument)
    if argument == Vector3.new(0, 0, 0) then
        return 0
    end
    return -argument.Z
end

function vehicle_controller.ComputeSteer(self, argument)
    if argument == Vector3.new(0, 0, 0) then
        return 0
    end
    return -math.atan2(-argument.x, -argument.z) * 57.29577951308232 / self.autoPilot.MaxSteeringAngle
end

function vehicle_controller.SetupAutoPilot(self)
    self.autoPilot.MaxSpeed = self.vehicleSeat.MaxSpeed
    self.autoPilot.MaxSteeringAngle = 35
end

return vehicle_controller
