local history = {}
history.__index = history

function history.new()
    local instance = setmetatable({}, history)
    instance._currentIndex = 0
    instance.Records = {}

    return instance
end

function history.WriteHistory(argument, argument_2)
    argument._currentIndex = argument._currentIndex + 1

    if argument._currentIndex < #argument.Records then
        for index = argument._currentIndex + 1, #argument.Records do
            argument.Records[index] = nil
            local _ = index
        end
    end

    argument.Records[argument._currentIndex] = argument_2
end

function history.GetRecord(argument, argument_2)
    return argument.Records[argument_2 or argument._currentIndex]
end

function history.IncrementHistory(argument, argument_2)
    if argument._currentIndex > 1 or argument_2 >= 0 then
        argument._currentIndex = math.clamp(argument._currentIndex + argument_2, 1, #argument.Records)

        return argument.Records[argument._currentIndex]
    end
end

function history.ClearHistory(argument)
    argument.Records = {}
    argument._currentIndex = 0
end

function history.Destroy(argument)
    argument:ClearHistory()
end

return history
