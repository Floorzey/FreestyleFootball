local base_occlusion = {}
base_occlusion.__index = base_occlusion
local values = {}

function values.__call(self, ...)
    return base_occlusion.new(...)
end

setmetatable(base_occlusion, values)

function base_occlusion.new()
    return (setmetatable({}, base_occlusion))
end

function base_occlusion.CharacterAdded(self, argument, argument_2) end

function base_occlusion.CharacterRemoving(self, argument, argument_2) end

function base_occlusion.OnCameraSubjectChanged(self, argument) end

function base_occlusion.GetOcclusionMode(self)
    warn("BaseOcclusion GetOcclusionMode must be overridden by derived classes")
    return nil
end

function base_occlusion.Enable(self, argument)
    warn("BaseOcclusion Enable must be overridden by derived classes")
end

function base_occlusion.Update(self, argument, argument_2, argument_3)
    warn("BaseOcclusion Update must be overridden by derived classes")
    return argument_2, argument_3
end

return base_occlusion
