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

function values.step(argument, argument_2)
    local f_rising = argument.fRising
    local f_falling = argument.fFalling
    local g = argument.g
    local p = argument.p
    local v = argument.v
    local tau = math.tau
    local f_rising_2

    if v > 0 then
        f_rising_2 = f_rising or f_falling
    else
        f_rising_2 = f_falling
    end

    local product = tau * f_rising_2
    local difference = p - g
    local exp_result = math.exp(-product * argument_2)
    local p_2 = ((difference * (1 + (product * argument_2))) + (v * argument_2)) * exp_result + g
    argument.p = p_2
    argument.v = ((v * (1 - (product * argument_2))) - (difference * ((product * product) * argument_2))) * exp_result

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

function values_2.setGoal(argument, argument_2)
    local is_cframe = typeof(argument_2) == "CFrame"
    assert(is_cframe)
    local _, value = argument_2:toEulerAnglesYXZ()
    argument.yawG = sanitize_angle(value)
    argument.pitchG = sanitize_angle(argument_2:toEulerAnglesYXZ())
end

function values_2.getCFrame(argument)
    return CFrame.fromEulerAnglesYXZ(argument.pitchP, argument.yawP, 0)
end

function values_2.step(argument, argument_2, argument_3, argument_4, argument_5)
    local is_number = typeof(argument_2) == "number"
    assert(is_number)
    local is_number_2 = typeof(argument_4) == "number"
    assert(is_number_2)
    local is_number_3 = typeof(argument_3) == "number"
    assert(is_number_3)
    local is_number_4 = typeof(argument_5) == "number"
    assert(is_number_4)
    local f_spring_yaw = argument.fSpringYaw
    local f_spring_pitch = argument.fSpringPitch
    f_spring_yaw.g = map_clamp(
        map(argument_5, 0, 1, argument_4, 0),
        math.rad(vehicle_camera_config.cutoffMinAngularVelYaw),
        math.rad(vehicle_camera_config.cutoffMaxAngularVelYaw),
        1,
        0
    )
    f_spring_pitch.g = map_clamp(
        map(argument_5, 0, 1, argument_3, 0),
        math.rad(vehicle_camera_config.cutoffMinAngularVelPitch),
        math.rad(vehicle_camera_config.cutoffMaxAngularVelPitch),
        1,
        0
    )
    local product = math.tau * vehicle_camera_config.yawStiffness * f_spring_yaw:step(argument_2)
    local product_2 = (math.tau * vehicle_camera_config.pitchStiffness)
        * f_spring_pitch:step(argument_2)
        * map(argument_5, 0, 1, 1, vehicle_camera_config.firstPersonResponseMul)
    local product_3 = product * map(argument_5, 0, 1, 1, vehicle_camera_config.firstPersonResponseMul)
    local yaw_g = argument.yawG
    local yaw_v = argument.yawV
    local result = sanitize_angle(argument.yawP - yaw_g)
    local exp_result = math.exp(-product_3 * argument_2)
    argument.yawP =
        sanitize_angle((((result * (1 + (product_3 * argument_2))) + (yaw_v * argument_2)) * exp_result) + yaw_g)
    argument.yawV = ((yaw_v * (1 - (product_3 * argument_2))) - (result * ((product_3 * product_3) * argument_2)))
        * exp_result
    local pitch_g = argument.pitchG
    local pitch_v = argument.pitchV
    local result_2 = sanitize_angle(argument.pitchP - pitch_g)
    local exp_result_2 = math.exp(-product_2 * argument_2)
    argument.pitchP = sanitize_angle(
        (((result_2 * (1 + (product_2 * argument_2))) + (pitch_v * argument_2)) * exp_result_2) + pitch_g
    )
    argument.pitchV = ((pitch_v * (1 - (product_2 * argument_2))) - (result_2 * ((product_2 * product_2) * argument_2)))
        * exp_result_2

    return argument:getCFrame()
end

local vehicle_camera_core = {}
vehicle_camera_core.__index = vehicle_camera_core

function vehicle_camera_core.new(argument)
    return (setmetatable({ vrs = values_2.new(argument) }, vehicle_camera_core))
end

function vehicle_camera_core.step(argument, argument_2, argument_3, argument_4, argument_5)
    return argument.vrs:step(argument_2, argument_3, argument_4, argument_5)
end

function vehicle_camera_core.setTransform(argument, argument_2)
    argument.vrs:setGoal(argument_2)
end

return vehicle_camera_core
