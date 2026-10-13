local values = {}
values.__index = values

function values.new()
    local instance = setmetatable({}, values)
    instance.cameras = require(script:WaitForChild("CameraModule"))
    instance.controls = require(script:WaitForChild("ControlModule"))
    return instance
end

function values.GetCameras(self)
    return self.cameras
end

function values.GetControls(self)
    return self.controls
end

function values.GetClickToMoveController(self)
    return self.controls:GetClickToMoveController()
end

return values.new()
