local camera_shake_instance = require(script.Parent.CameraShakeInstance)
local values = {}

function values.Bump()
    local camera_shake_instance_2 = camera_shake_instance.new(2.5, 4, 0.1, 0.75)
    camera_shake_instance_2.PositionInfluence =
        Vector3.new(0.15000000596046448, 0.15000000596046448, 0.15000000596046448)
    camera_shake_instance_2.RotationInfluence = Vector3.new(1, 1, 1)
    return camera_shake_instance_2
end

function values.Explosion()
    local camera_shake_instance_2 = camera_shake_instance.new(5, 10, 0, 1.5)
    camera_shake_instance_2.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
    camera_shake_instance_2.RotationInfluence = Vector3.new(4, 1, 1)
    return camera_shake_instance_2
end

function values.Timestop()
    local camera_shake_instance_2 = camera_shake_instance.new(2.5, 5, 0, 1.5)
    camera_shake_instance_2.PositionInfluence = Vector3.new(1, 1, 1)
    camera_shake_instance_2.RotationInfluence = Vector3.new(1, 1, 1)
    return camera_shake_instance_2
end

function values.Earthquake()
    local camera_shake_instance_2 = camera_shake_instance.new(0.6, 3.5, 2, 10)
    camera_shake_instance_2.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
    camera_shake_instance_2.RotationInfluence = Vector3.new(1, 1, 4)
    return camera_shake_instance_2
end

function values.BadTrip()
    local camera_shake_instance_2 = camera_shake_instance.new(10, 0.15, 5, 10)
    camera_shake_instance_2.PositionInfluence = Vector3.new(0, 0, 0.15000000596046448)
    camera_shake_instance_2.RotationInfluence = Vector3.new(2, 1, 4)
    return camera_shake_instance_2
end

function values.HandheldCamera()
    local camera_shake_instance_2 = camera_shake_instance.new(1, 0.25, 5, 10)
    camera_shake_instance_2.PositionInfluence = Vector3.new(0, 0, 0)
    camera_shake_instance_2.RotationInfluence = Vector3.new(1, 0.5, 0.5)
    return camera_shake_instance_2
end

function values.Vibration()
    local camera_shake_instance_2 = camera_shake_instance.new(10, 20, 0, 0.125)
    camera_shake_instance_2.PositionInfluence = Vector3.new(0, 0.15000000596046448, 0)
    camera_shake_instance_2.RotationInfluence = Vector3.new(1.25, 0, 4)
    return camera_shake_instance_2
end

function values.RoughDriving()
    local camera_shake_instance_2 = camera_shake_instance.new(1, 2, 1, 1)
    camera_shake_instance_2.PositionInfluence = Vector3.new(0, 0, 0)
    camera_shake_instance_2.RotationInfluence = Vector3.new(1, 1, 1)
    return camera_shake_instance_2
end

local values_2 = {}
local values_3 = {}

function values_3.__index(self, argument)
    local callback = values[argument]
    if type(callback) ~= "function" then
        error("No preset found with index \"" .. argument .. "\"")
    else
        return callback()
    end
end

return (setmetatable(values_2, values_3))
