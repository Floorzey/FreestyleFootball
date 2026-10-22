local players = game:GetService("Players")
local signal = require(script.Parent.Parent.Parent.Signal)
require(script.Parent.Parent.Types)
local remote_signal = {}
remote_signal.__index = remote_signal

function remote_signal.new(parent: userdata, name: string, enabled: boolean?, argument: any, outbound: any)
    local instance = setmetatable({}, remote_signal)
    local unreliable_remote_event

    if enabled == true then
        unreliable_remote_event = Instance.new("UnreliableRemoteEvent")
    else
        unreliable_remote_event = Instance.new("RemoteEvent")
    end

    instance._re = unreliable_remote_event
    instance._re.Name = name
    instance._re.Parent = parent

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

    instance._re.OnServerEvent:Connect(function(player, ...)
        local values = table.pack(...)

        for _, callback in argument do
            if not table.pack(callback(player, values))[1] then
                return
            end

            values.n = #values
        end

        instance._signal:Fire(player, table.unpack(values, 1, values.n))
    end)

    return instance
end

function remote_signal.IsUnreliable(argument)
    return argument._re:IsA("UnreliableRemoteEvent")
end

function remote_signal.Connect(argument, argument_2)
    if argument._directConnect then
        return argument._re.OnServerEvent:Connect(argument_2)
    end

    return argument._signal:Connect(argument_2)
end

function remote_signal._processOutboundMiddleware(argument: table, argument_2: userdata?, ...)
    if not argument._hasOutbound then
        return ...
    end

    local values = table.pack(...)

    for _, callback in argument._outbound do
        local values_2 = table.pack(callback(argument_2, values))

        if not values_2[1] then
            return table.unpack(values_2, 2, values_2.n)
        end

        values.n = #values
    end

    return table.unpack(values, 1, values.n)
end

function remote_signal.Fire(argument: table, argument_2: userdata, ...)
    argument._re:FireClient(argument_2, argument:_processOutboundMiddleware(argument_2, ...))
end

function remote_signal.FireAll(argument, ...)
    argument._re:FireAllClients(argument:_processOutboundMiddleware(nil, ...))
end

function remote_signal.FireExcept(argument: table, argument_2: userdata, ...)
    argument:FireFilter(function(argument_3)
        return argument_3 ~= argument_2
    end, ...)
end

function remote_signal.FireFilter(argument: table, callback: (...any) -> ...any, ...)
    for _, item in players:GetPlayers() do
        if callback(item, ...) then
            argument._re:FireClient(item, argument:_processOutboundMiddleware(nil, ...))
        end
    end
end

function remote_signal.FireFor(argument: table, argument_2: table, ...)
    for _, item in argument_2 do
        argument._re:FireClient(item, argument:_processOutboundMiddleware(nil, ...))
    end
end

function remote_signal.Destroy(argument)
    argument._re:Destroy()

    if argument._signal then
        argument._signal:Destroy()
    end
end

return remote_signal
