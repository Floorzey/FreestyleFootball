local signal = require(script.Parent.Parent.Parent.Signal)
local _ = require(script.Parent.Parent.Types)
local client_remote_signal = {}
client_remote_signal.__index = client_remote_signal

function client_remote_signal.new(re, argument, outbound)
    local instance = setmetatable({}, client_remote_signal)
    instance._re = re
    if outbound and (#outbound > 0) then
        instance._hasOutbound = true
        instance._outbound = outbound
    else
        instance._hasOutbound = false
    end
    if argument and #argument > 0 then
        instance._directConnect = false
        instance._signal = signal.new()
        instance._reConn = instance._re.OnClientEvent:Connect(function(...)
            local values = table.pack(...)
            for _, callback in argument do
                if table.pack(callback(values))[1] then
                    values.n = #values
                    continue
                end
                return
            end
            instance._signal:Fire(table.unpack(values, 1, values.n))
        end)
    else
        instance._directConnect = true
    end
    return instance
end

function client_remote_signal._processOutboundMiddleware(self, ...)
    local values = table.pack(...)
    local value = nil
    for _, callback in self._outbound do
        value = table.pack(callback(values))
        if value[1] then
            values.n = #values
            continue
        end
        return table.unpack(value, 2, value.n)
    end
    return table.unpack(values, 1, values.n)
end

function client_remote_signal.Connect(self, argument)
    if self._directConnect then
        return self._re.OnClientEvent:Connect(argument)
    end
    return self._signal:Connect(argument)
end

function client_remote_signal.Fire(self, ...)
    if self._hasOutbound then
        self._re:FireServer(self:_processOutboundMiddleware(...))
    else
        self._re:FireServer(...)
    end
end

function client_remote_signal.Destroy(self)
    if not self._signal then
        return
    end
    self._signal:Destroy()
end

return client_remote_signal
