local signal = {}
signal.__index = signal

function signal.Create(argument)
    return setmetatable({}, signal)
end

function signal.Connect(argument, argument_2)
    argument[1] = argument_2
end

function signal.Fire(argument, ...)
    if not argument[1] then
        return
    end

    local create_result = coroutine.create(argument[1])
    coroutine.resume(create_result, ...)
end

function signal.Delete(argument)
    argument[1] = nil
end

return signal
