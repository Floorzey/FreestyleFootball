local cframe = CFrame.new(0, 0, 1e+06)
local object_pool = {}

function object_pool.new(argument, argument_2)
    local values = {}
    values.Object = argument:Clone()
    values.Available = {}
    for n = 1, argument_2 or 1 do
        values.Available[n] = values.Object:Clone()
    end
    function values.Get(self)
        local available_count = #values.Available
        local available_entry = values.Available[available_count]
        if available_entry then
            table.remove(values.Available, available_count)
            return available_entry
        end
        return values.Object:Clone()
    end
    function values.Return(self, argument_3)
        argument_3.CFrame = cframe
        table.insert(values.Available, argument_3)
    end
    return values
end

return object_pool
