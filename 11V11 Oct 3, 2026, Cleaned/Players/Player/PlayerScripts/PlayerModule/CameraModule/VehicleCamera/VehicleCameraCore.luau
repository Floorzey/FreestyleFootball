local camera_utils = require(script.Parent.Parent.CameraUtils)
local vehicle_camera_config = require(script.Parent.VehicleCameraConfig)
local map = camera_utils.map
local map_clamp = camera_utils.mapClamp
local sanitize_angle = camera_utils.sanitizeAngle

local function get_yaw(argument)
    local _, value = argument:toEulerAnglesYXZ()
    return sanitize_angle(value)
end

local function get_pitch(argument)
    return sanitize_angle(argument:toEulerAnglesYXZ())
end

local function step_spring_axis(argument, argument_2, argument_3, argument_4, argument_5)
    local result = sanitize_angle(argument_4 - argument_3)
    local exp_result = math.exp(-argument_2 * argument)
    return sanitize_angle(
        (((result * (1 + (argument_2 * argument))) + (argument_5 * argument)) * exp_result) + argument_3
    ),
        ((argument_5 * (1 - (argument_2 * argument))) - (result * ((argument_2 * argument_2) * argument))) * exp_result
end

local values = {}
values.__index = values

function values.new(f_rising, f_falling, g)
    return (setmetatable({ fRising = f_rising, fFalling = f_falling, g = g, p = g, v = g * 0 }, values))
end

function values.step(self, argument)
    local f_rising = self.fRising
    local f_falling = self.fFalling
    local g = self.g
    local p = self.p
    local v = self.v
    local tau = math.tau
    local f_rising_2
    if v > 0 then
        f_rising_2 = f_rising or f_falling
    else
        f_rising_2 = f_falling
    end
    local tau_offset = tau * f_rising_2
    local p_offset = p - g
    local exp_result = math.exp(-tau_offset * argument)
    local p_2 = ((p_offset * (1 + (tau_offset * argument))) + (v * argument)) * exp_result + g
    self.p = p_2
    self.v = ((v * (1 - (tau_offset * argument))) - (p_offset * ((tau_offset * tau_offset) * argument))) * exp_result
    return p_2
end

local values_2 = {}
values_2.__index = values_2

function values_2.new(argument)
    local is_cframe = typeof(argument) == "CFrame"
    assert(is_cframe)
    local values_3 = { pitchV = 0, yawV = 0 }
    local _, value = argument:toEulerAnglesYXZ()
    values_3.yawG = sanitize_angle(value)
    local to_euler_angles_yxz_result, value_2 = argument:toEulerAnglesYXZ()
    values_3.yawP = sanitize_angle(value_2)
    values_3.pitchG = sanitize_angle(argument:toEulerAnglesYXZ())
    values_3.pitchP = sanitize_angle(argument:toEulerAnglesYXZ())
    values_3.fSpringYaw =
        values.new(vehicle_camera_config.yawReponseDampingRising, vehicle_camera_config.yawResponseDampingFalling, 0)
    values_3.fSpringPitch = values.new(
        vehicle_camera_config.pitchReponseDampingRising,
        vehicle_camera_config.pitchResponseDampingFalling,
        0
    )
    return (setmetatable(values_3, values_2))
end

function values_2.setGoal(self, argument)
    local is_cframe = typeof(argument) == "CFrame"
    assert(is_cframe)
    local _, value = argument:toEulerAnglesYXZ()
    self.yawG = sanitize_angle(value)
    self.pitchG = sanitize_angle(argument:toEulerAnglesYXZ())
end

function values_2.getCFrame(self)
    return CFrame.fromEulerAnglesYXZ(self.pitchP, self.yawP, 0)
end

function values_2.step(self, argument, argument_2, argument_3, argument_4)
    local is_number = typeof(argument) == "number"
    assert(is_number)
    local is_number_2 = typeof(argument_3) == "number"
    assert(is_number_2)
    local is_number_3 = typeof(argument_2) == "number"
    assert(is_number_3)
    local is_number_4 = typeof(argument_4) == "number"
    assert(is_number_4)
    local f_spring_yaw = self.fSpringYaw
    local f_spring_pitch = self.fSpringPitch
    f_spring_yaw.g = map_clamp(
        map(argument_4, 0, 1, argument_3, 0),
        math.rad(vehicle_camera_config.cutoffMinAngularVelYaw),
        math.rad(vehicle_camera_config.cutoffMaxAngularVelYaw),
        1,
        0
    )
    f_spring_pitch.g = map_clamp(
        map(argument_4, 0, 1, argument_2, 0),
        math.rad(vehicle_camera_config.cutoffMinAngularVelPitch),
        math.rad(vehicle_camera_config.cutoffMaxAngularVelPitch),
        1,
        0
    )
    local tau_offset_offset = math.tau * vehicle_camera_config.yawStiffness * f_spring_yaw:step(argument)
    local tau_offset_offset_offset = (math.tau * vehicle_camera_config.pitchStiffness)
        * f_spring_pitch:step(argument)
        * map(argument_4, 0, 1, 1, vehicle_camera_config.firstPersonResponseMul)
    local tau_offset_offset_offset_2 = tau_offset_offset
        * map(argument_4, 0, 1, 1, vehicle_camera_config.firstPersonResponseMul)
    local yaw_g = self.yawG
    local yaw_v = self.yawV
    local result = sanitize_angle(self.yawP - yaw_g)
    local exp_result = math.exp(-tau_offset_offset_offset_2 * argument)
    self.yawP = sanitize_angle(
        (((result * (1 + (tau_offset_offset_offset_2 * argument))) + (yaw_v * argument)) * exp_result) + yaw_g
    )
    self.yawV = (
        (yaw_v * (1 - (tau_offset_offset_offset_2 * argument)))
        - (result * ((tau_offset_offset_offset_2 * tau_offset_offset_offset_2) * argument))
    ) * exp_result
    local pitch_g = self.pitchG
    local pitch_v = self.pitchV
    local result_2 = sanitize_angle(self.pitchP - pitch_g)
    local exp_result_2 = math.exp(-tau_offset_offset_offset * argument)
    self.pitchP = sanitize_angle(
        (((result_2 * (1 + (tau_offset_offset_offset * argument))) + (pitch_v * argument)) * exp_result_2) + pitch_g
    )
    self.pitchV = (
        (pitch_v * (1 - (tau_offset_offset_offset * argument)))
        - (result_2 * ((tau_offset_offset_offset * tau_offset_offset_offset) * argument))
    ) * exp_result_2
    return self:getCFrame()
end

local vehicle_camera_core = {}
vehicle_camera_core.__index = vehicle_camera_core

function vehicle_camera_core.new(argument)
    return (setmetatable({ vrs = values_2.new(argument) }, vehicle_camera_core))
end

function vehicle_camera_core.step(self, argument, argument_2, argument_3, argument_4)
    return self.vrs:step(argument, argument_2, argument_3, argument_4)
end

function vehicle_camera_core.setTransform(self, argument)
    self.vrs:setGoal(argument)
end

return vehicle_camera_core
