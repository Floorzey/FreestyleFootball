local base_occlusion = {}
base_occlusion.__index = base_occlusion
setmetatable(base_occlusion, {
    __call = function(argument, ...)
        return base_occlusion.new(...)
    end,
})

function base_occlusion.new()
    return setmetatable({}, base_occlusion)
end

function base_occlusion.CharacterAdded(argument: table, argument_2: userdata, argument_3: userdata) end

function base_occlusion.CharacterRemoving(argument: table, argument_2: userdata, argument_3: userdata) end

function base_occlusion.OnCameraSubjectChanged(argument, argument_2) end

function base_occlusion.GetOcclusionMode(argument)
    warn("BaseOcclusion GetOcclusionMode must be overridden by derived classes")

    return nil
end

function base_occlusion.Enable(argument: table, argument_2: boolean)
    warn("BaseOcclusion Enable must be overridden by derived classes")
end

function base_occlusion.Update(argument: table, argument_2: number, argument_3, argument_4)
    warn("BaseOcclusion Update must be overridden by derived classes")

    return argument_3, argument_4
end

return base_occlusion
