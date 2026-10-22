local connection_util = {}
connection_util.__index = connection_util

function connection_util.new()
    local instance = setmetatable({}, connection_util)
    instance._connections = {}
    return instance
end

function connection_util.connect(self, argument, signal, argument_2)
    if self._connections[argument] then
        self._connections[argument]()
    end
    local connection = signal:Connect(argument_2)
    self._connections[argument] = function()
        connection:Disconnect()
    end
end

function connection_util.connectManual(self, argument, argument_2)
    if self._connections[argument] then
        self._connections[argument]()
    end
    self._connections[argument] = argument_2
end

function connection_util.disconnect(self, argument)
    if not self._connections[argument] then
        return
    end
    self._connections[argument]()
    self._connections[argument] = nil
end

function connection_util.disconnectAll(self)
    for _, callback in pairs(self._connections) do
        callback()
    end
    self._connections = {}
end

return connection_util
