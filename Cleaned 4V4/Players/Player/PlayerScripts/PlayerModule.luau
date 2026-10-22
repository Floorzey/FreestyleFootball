local values = {}
values.__index = values

function values.new()
    local instance = setmetatable({}, values)
    instance.cameras = require(script:WaitForChild("CameraModule"))
    instance.controls = require(script:WaitForChild("ControlModule"))

    return instance
end

function values.GetCameras(argument)
    return argument.cameras
end

function values.GetControls(argument)
    return argument.controls
end

function values.GetClickToMoveController(argument)
    return argument.controls:GetClickToMoveController()
end

return values.new()
