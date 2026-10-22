local signal = require(script.Parent.Parent.Parent.Signal)
require(script.Parent.Parent.Types)
local client_remote_signal = {}
client_remote_signal.__index = client_remote_signal

function client_remote_signal.new(re: userdata, argument: any, outbound: any)
    local instance = setmetatable({}, client_remote_signal)
    instance._re = re

    if outbound and #outbound > 0 then
        instance._hasOutbound = true
        instance._outbound = outbound
    else
        instance._hasOutbound = false
    end

    if not argument or #argument <= 0 then
        instance._directConnect = true

        return instance
    end

    instance._directConnect = false
    instance._signal = signal.new()
    instance._reConn = instance._re.OnClientEvent:Connect(function(...)
        local values = table.pack(...)

        for _, callback in argument do
            if not table.pack(callback(values))[1] then
                return
            end

            values.n = #values
        end

        instance._signal:Fire(table.unpack(values, 1, values.n))
    end)

    return instance
end

function client_remote_signal._processOutboundMiddleware(argument, ...)
    local values = table.pack(...)

    for _, callback in argument._outbound do
        local values_2 = table.pack(callback(values))

        if not values_2[1] then
            return table.unpack(values_2, 2, values_2.n)
        end

        values.n = #values
    end

    return table.unpack(values, 1, values.n)
end

function client_remote_signal.Connect(argument: table, argument_2: (...any) -> ...any)
    if argument._directConnect then
        return argument._re.OnClientEvent:Connect(argument_2)
    end

    return argument._signal:Connect(argument_2)
end

function client_remote_signal.Fire(argument, ...)
    if argument._hasOutbound then
        argument._re:FireServer(argument:_processOutboundMiddleware(...))

        return
    end

    argument._re:FireServer(...)
end

function client_remote_signal.Destroy(argument)
    if argument._signal then
        argument._signal:Destroy()
    end
end

return client_remote_signal
