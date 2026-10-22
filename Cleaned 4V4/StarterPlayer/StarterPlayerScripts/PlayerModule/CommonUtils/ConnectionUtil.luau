local connection_util = {}
connection_util.__index = connection_util

function connection_util.new()
    local instance = setmetatable({}, connection_util)
    instance._connections = {}

    return instance
end

function connection_util.connect(argument, argument_2, signal, argument_3)
    if argument._connections[argument_2] then
        argument._connections[argument_2]()
    end

    local connection = signal:Connect(argument_3)
    argument._connections[argument_2] = function()
        connection:Disconnect()
    end
end

function connection_util.connectManual(argument, argument_2, argument_3)
    if argument._connections[argument_2] then
        argument._connections[argument_2]()
    end

    argument._connections[argument_2] = argument_3
end

function connection_util.disconnect(argument, argument_2)
    if not argument._connections[argument_2] then
        return
    end

    argument._connections[argument_2]()
    argument._connections[argument_2] = nil
end

function connection_util.disconnectAll(argument)
    for _, callback in pairs(argument._connections) do
        callback()
    end

    argument._connections = {}
end

return connection_util
