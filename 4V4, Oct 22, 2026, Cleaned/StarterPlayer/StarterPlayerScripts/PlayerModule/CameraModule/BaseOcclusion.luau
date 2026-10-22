local base_occlusion = {}
base_occlusion.__index = base_occlusion
local values = {}

function values.__call(argument, ...)
    return base_occlusion.new(...)
end

setmetatable(base_occlusion, values)

function base_occlusion.new()
    return (setmetatable({}, base_occlusion))
end

function base_occlusion.CharacterAdded(argument, argument_2, argument_3) end

function base_occlusion.CharacterRemoving(argument, argument_2, argument_3) end

function base_occlusion.OnCameraSubjectChanged(argument, argument_2) end

function base_occlusion.GetOcclusionMode(argument)
    warn("BaseOcclusion GetOcclusionMode must be overridden by derived classes")

    return nil
end

function base_occlusion.Enable(argument, argument_2)
    warn("BaseOcclusion Enable must be overridden by derived classes")
end

function base_occlusion.Update(argument, argument_2, argument_3, argument_4)
    warn("BaseOcclusion Update must be overridden by derived classes")

    return argument_3, argument_4
end

return base_occlusion
