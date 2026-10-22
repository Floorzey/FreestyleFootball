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

function remote_signal.IsUnreliable(self)
    return self._re:IsA("UnreliableRemoteEvent")
end

function remote_signal.Connect(self, argument)
    if self._directConnect then
        return self._re.OnServerEvent:Connect(argument)
    end
    return self._signal:Connect(argument)
end

function remote_signal._processOutboundMiddleware(self, argument, ...)
    if not self._hasOutbound then
        return ...
    end
    local values = table.pack(...)
    local value = nil
    for _, callback in self._outbound do
        value = table.pack(callback(argument, values))
        if value[1] then
            values.n = #values
            continue
        end
        return table.unpack(value, 2, value.n)
    end
    return table.unpack(values, 1, values.n)
end

function remote_signal.Fire(self, argument, ...)
    self._re:FireClient(argument, self:_processOutboundMiddleware(argument, ...))
end

function remote_signal.FireAll(self, ...)
    self._re:FireAllClients(self:_processOutboundMiddleware(nil, ...))
end

function remote_signal.FireExcept(self, argument, ...)
    self:FireFilter(function(argument_2)
        return argument_2 ~= argument
    end, ...)
end

function remote_signal.FireFilter(self, callback, ...)
    for _, item in players:GetPlayers() do
        if callback(item, ...) then
            self._re:FireClient(item, self:_processOutboundMiddleware(nil, ...))
        end
    end
end

function remote_signal.FireFor(self, argument, ...)
    for _, item in argument do
        self._re:FireClient(item, self:_processOutboundMiddleware(nil, ...))
    end
end

function remote_signal.Destroy(self)
    self._re:Destroy()
    if not self._signal then
        return
    end
    self._signal:Destroy()
end

return remote_signal
