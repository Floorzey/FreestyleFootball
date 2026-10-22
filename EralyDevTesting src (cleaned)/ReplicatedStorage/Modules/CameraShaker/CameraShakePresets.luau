local camera_shake_instance = require(script.Parent.CameraShakeInstance)
local values = {
    Bump = function()
        local camera_shake_instance_2 = camera_shake_instance.new(2.5, 4, 0.1, 0.75)
        camera_shake_instance_2.PositionInfluence = Vector3.new(0.15, 0.15, 0.15)
        camera_shake_instance_2.RotationInfluence = Vector3.new(1, 1, 1)

        return camera_shake_instance_2
    end,

    Explosion = function()
        local camera_shake_instance_2 = camera_shake_instance.new(5, 10, 0, 1.5)
        camera_shake_instance_2.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
        camera_shake_instance_2.RotationInfluence = Vector3.new(4, 1, 1)

        return camera_shake_instance_2
    end,

    Timestop = function()
        local camera_shake_instance_2 = camera_shake_instance.new(2.5, 5, 0, 1.5)
        camera_shake_instance_2.PositionInfluence = Vector3.new(1, 1, 1)
        camera_shake_instance_2.RotationInfluence = Vector3.new(1, 1, 1)

        return camera_shake_instance_2
    end,

    Earthquake = function()
        local camera_shake_instance_2 = camera_shake_instance.new(0.6, 3.5, 2, 10)
        camera_shake_instance_2.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
        camera_shake_instance_2.RotationInfluence = Vector3.new(1, 1, 4)

        return camera_shake_instance_2
    end,

    BadTrip = function()
        local camera_shake_instance_2 = camera_shake_instance.new(10, 0.15, 5, 10)
        camera_shake_instance_2.PositionInfluence = Vector3.new(0, 0, 0.15)
        camera_shake_instance_2.RotationInfluence = Vector3.new(2, 1, 4)

        return camera_shake_instance_2
    end,

    HandheldCamera = function()
        local camera_shake_instance_2 = camera_shake_instance.new(1, 0.25, 5, 10)
        camera_shake_instance_2.PositionInfluence = Vector3.new(0, 0, 0)
        camera_shake_instance_2.RotationInfluence = Vector3.new(1, 0.5, 0.5)

        return camera_shake_instance_2
    end,

    Vibration = function()
        local camera_shake_instance_2 = camera_shake_instance.new(10, 20, 0, 0.125)
        camera_shake_instance_2.PositionInfluence = Vector3.new(0, 0.15, 0)
        camera_shake_instance_2.RotationInfluence = Vector3.new(1.25, 0, 4)

        return camera_shake_instance_2
    end,

    RoughDriving = function()
        local camera_shake_instance_2 = camera_shake_instance.new(1, 2, 1, 1)
        camera_shake_instance_2.PositionInfluence = Vector3.new(0, 0, 0)
        camera_shake_instance_2.RotationInfluence = Vector3.new(1, 1, 1)

        return camera_shake_instance_2
    end,
}

return setmetatable({}, {
    __index = function(argument, argument_2)
        local callback = values[argument_2]

        if type(callback) == "function" then
            return callback()
        end

        error('No preset found with index "' .. argument_2 .. '"')
    end,
})
