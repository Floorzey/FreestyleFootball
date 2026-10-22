local players = game:GetService("Players")
local signal = require(script.Parent.Parent.Parent.Signal)
local _ = require(script.Parent.Parent.Types)
local remote_signal = {}
remote_signal.__index = remote_signal

function remote_signal.new(parent, name, enabled, argument, outbound)
    local instance = setmetatable({}, remote_signal)
    local remote_event

    if enabled ~= true then
        remote_event = Instance.new("RemoteEvent")
    else
        remote_event = Instance.new("UnreliableRemoteEvent")
    end

    instance._re = remote_event
    instance._re.Name = name
    instance._re.Parent = parent

    if outbound and (#outbound > 0) then
        instance._hasOutbound = true
        instance._outbound = outbound
    else
        instance._hasOutbound = false
    end

    if argument and #argument > 0 then
        instance._directConnect = false
        instance._signal = signal.new()

        instance._re.OnServerEvent:Connect(function(player, ...)
            local values = table.pack(...)

            for _, callback in argument do
                if table.pack(callback(player, values))[1] then
                    values.n = #values
                    continue
                end

                return
            end

            instance._signal:Fire(player, table.unpack(values, 1, values.n))
        end)
    else
        instance._directConnect = true
    end

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

function remote_signal._processOutboundMiddleware(argument, argument_2, ...)
    if not argument._hasOutbound then
        return ...
    end

    local values = table.pack(...)
    local value = nil

    for _, callback in argument._outbound do
        value = table.pack(callback(argument_2, values))

        if value[1] then
            values.n = #values
            continue
        end

        return table.unpack(value, 2, value.n)
    end

    return table.unpack(values, 1, values.n)
end

function remote_signal.Fire(argument, argument_2, ...)
    argument._re:FireClient(argument_2, argument:_processOutboundMiddleware(argument_2, ...))
end

function remote_signal.FireAll(argument, ...)
    argument._re:FireAllClients(argument:_processOutboundMiddleware(nil, ...))
end

function remote_signal.FireExcept(argument, argument_2, ...)
    argument:FireFilter(function(argument_3)
        return argument_3 ~= argument_2
    end, ...)
end

function remote_signal.FireFilter(argument, callback, ...)
    for _, item in players:GetPlayers() do
        if callback(item, ...) then
            argument._re:FireClient(item, argument:_processOutboundMiddleware(nil, ...))
        end
    end
end

function remote_signal.FireFor(argument, argument_2, ...)
    for _, item in argument_2 do
        argument._re:FireClient(item, argument:_processOutboundMiddleware(nil, ...))
    end
end

function remote_signal.Destroy(argument)
    argument._re:Destroy()

    if not argument._signal then
        return
    end

    argument._signal:Destroy()
end

return remote_signal
