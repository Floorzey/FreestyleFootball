local run_service = game:GetService("RunService")
local values = {}
values.__index = values
values.ClassName = "MasterClock"

function values.new(remote_event, remote_function)
    local instance = setmetatable({}, values)
    instance._remoteEvent = remote_event or error("No remoteEvent")
    instance._remoteFunction = remote_function or error("No remoteFunction")
    instance._remoteFunction.OnServerInvoke = function(argument, argument_2)
        return instance:_handleDelayRequest(argument_2)
    end

    instance._remoteEvent.OnServerEvent:Connect(function(player)
        instance._remoteEvent:FireClient(player, instance:GetTime())
    end)

    spawn(function()
        while true do
            wait(5)
            instance:Sync()
        end
    end)

    return instance
end

function values.IsSynced(argument)
    return true
end

function values.GetTime(argument)
    return tick()
end

function values.Sync(argument)
    argument._remoteEvent:FireAllClients((argument:GetTime()))
end

function values._handleDelayRequest(argument, argument_2)
    return argument:GetTime() - argument_2
end

local values_2 = {}
values_2.__index = values_2
values_2.ClassName = "SlaveClock"
values_2._offset = -1

function values_2.new(remote_event, remote_function)
    local instance = setmetatable({}, values_2)
    instance._remoteEvent = remote_event or error("No remoteEvent")
    instance._remoteFunction = remote_function or error("No remoteFunction")

    instance._remoteEvent.OnClientEvent:Connect(function(argument)
        instance:_handleSyncEvent(argument)
    end)

    instance._remoteEvent:FireServer()

    return instance
end

function values_2.GetTime(argument)
    if argument:IsSynced() then
        return argument:_getLocalTime() - argument._offset
    end

    warn("[SlaveClock][GetTime] - Slave clock is not yet synced")

    return argument:_getLocalTime()
end

function values_2.IsSynced(argument)
    return argument._offset ~= -1
end

function values_2._getLocalTime(argument)
    return tick()
end

function values_2._handleSyncEvent(argument, argument_2)
    local difference = argument:_getLocalTime() - argument_2
    local send_delay_request_result = argument:_sendDelayRequest(argument:_getLocalTime())
    argument._offset = (difference - send_delay_request_result) / 2
    argument._pneWayDelay = (difference + send_delay_request_result) / 2
end

function values_2._sendDelayRequest(argument, argument_2)
    return argument._remoteFunction:InvokeServer(argument_2)
end

local function build_clock()
    local clock_remote = game.ReplicatedStorage.Remotes.clockRemote
    local clock_function = game.ReplicatedStorage.Remotes.clockFunction

    if run_service:IsClient() and run_service:IsServer() then
        local values_3 = values.new(clock_remote, clock_function)

        clock_remote.OnClientEvent:Connect(function() end)

        return values_3
    elseif run_service:IsClient() then
        return values_2.new(clock_remote, clock_function)
    else
        return values.new(clock_remote, clock_function)
    end
end

return build_clock()
