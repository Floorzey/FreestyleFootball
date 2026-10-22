local cframe = CFrame.new(0, 0, 1000000)

return {
    new = function(argument: userdata, argument_2: number?)
        local values = {
            Object = argument:Clone(),
            Available = {},
        }

        for index = 1, argument_2 or 1 do
            values.Available[index] = values.Object:Clone()
            local _ = index
        end

        function values.Get(argument_3)
            local available_count = #values.Available
            local available_entry = values.Available[available_count]

            if not available_entry then
                return values.Object:Clone()
            end

            table.remove(values.Available, available_count)

            return available_entry
        end

        function values.Return(argument_3: table, argument_4: userdata)
            argument_4.CFrame = cframe
            table.insert(values.Available, argument_4)
        end

        return values
    end,
}
