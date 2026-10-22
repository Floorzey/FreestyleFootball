local signal = {}
signal.__index = signal

function signal.Create(self)
    return (setmetatable({}, signal))
end

function signal.Connect(self, argument)
    self[1] = argument
end

function signal.Fire(self, ...)
    if not self[1] then
        return
    end
    coroutine.resume(coroutine.create(self[1]), ...)
end

function signal.Delete(self)
    self[1] = nil
end

return signal
