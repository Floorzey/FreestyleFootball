local value = nil

local function callback(callback_2, ...)
    local value_2 = value
    value = nil
    callback_2(...)
    value = value_2
end

local connection = {}
connection.__index = connection

function connection.Disconnect(self)
    if not self.Connected then
        return
    end
    self.Connected = false
    if self._signal._handlerListHead ~= self then
        local handler_list_head = self._signal._handlerListHead
        while handler_list_head and handler_list_head._next ~= self do
            handler_list_head = handler_list_head._next
        end
        if handler_list_head then
            handler_list_head._next = self._next
        end
    else
        self._signal._handlerListHead = self._next
    end
end

connection.Destroy = connection.Disconnect
local metatable = { __index = 0, __newindex = 0 }

function metatable.__index(self, argument)
    error(("Attempt to get Connection::%s (not a valid member)"):format(tostring(argument)), 2)
end

function metatable.__newindex(self, argument, argument_2)
    error(("Attempt to set Connection::%s (not a valid member)"):format(tostring(argument)), 2)
end

setmetatable(connection, metatable)
local instance = {}
instance.__index = instance

function instance.new()
    return (setmetatable({ _handlerListHead = false }, instance))
end

function instance.Wrap(signal)
    local is_rbx_script_signal = typeof(signal) == "RBXScriptSignal"
    assert(is_rbx_script_signal, "Argument #1 to Signal.Wrap must be a RBXScriptSignal; got " .. typeof(signal))
    local instance_2 = instance.new()
    instance_2._proxyHandler = signal:Connect(function(...)
        instance_2:Fire(...)
    end)
    return instance_2
end

function instance.Is(self)
    local is_table = (type(self) == "table") and (getmetatable(self) == instance)
    return is_table
end

function instance.Connect(signal, fn)
    local handler_list_head = setmetatable({ Connected = true, _next = false, _signal = signal, _fn = fn }, connection)
    if signal._handlerListHead then
        handler_list_head._next = signal._handlerListHead
    end
    signal._handlerListHead = handler_list_head
    return handler_list_head
end

function instance.ConnectOnce(signal, argument)
    return signal:Once(argument)
end

function instance.Once(signal, callback_2)
    local connection_3 = nil
    local enabled = false
    local connection_2 = signal:Connect(function(...)
        if enabled then
            return
        end
        enabled = true
        connection_3:Disconnect()
        callback_2(...)
    end)
    connection_3 = connection_2
    return connection_3
end

function instance.GetConnections(self)
    local items = {}
    local handler_list_head = self._handlerListHead
    while handler_list_head do
        table.insert(items, handler_list_head)
        handler_list_head = handler_list_head._next
    end
    return items
end

function instance.DisconnectAll(self)
    local handler_list_head = self._handlerListHead
    while handler_list_head do
        handler_list_head.Connected = false
        handler_list_head = handler_list_head._next
    end
    self._handlerListHead = false
    if not self._yieldedThreads then
        return
    end
    for key in self._yieldedThreads do
        if coroutine.status(key) == "suspended" then
            warn(debug.traceback(key, "signal disconnected; yielded thread cancelled", 2))
            task.cancel(key)
        end
    end
    table.clear(self._yieldedThreads)
end

local function run_event_handler_in_free_thread(...)
    callback(...)
    while true do
        callback(coroutine.yield())
    end
end

function instance.Fire(self, ...)
    local handler_list_head = self._handlerListHead
    while handler_list_head do
        if not handler_list_head.Connected then
            handler_list_head = handler_list_head._next
            continue
        end
        if not value then
            value = coroutine.create(run_event_handler_in_free_thread)
        end
        task.spawn(value, handler_list_head._fn, ...)
        handler_list_head = handler_list_head._next
    end
end

function instance.FireDeferred(self, ...)
    local handler_list_head = self._handlerListHead
    while handler_list_head do
        task.defer(function(...)
            if not handler_list_head.Connected then
                return
            end
            handler_list_head._fn(...)
        end, ...)
        handler_list_head = handler_list_head._next
    end
end

function instance.Wait(signal)
    local rawget_result = rawget(signal, "_yieldedThreads")
    if not rawget_result then
        rawget_result = {}
        rawset(signal, "_yieldedThreads", rawget_result)
    end
    local running_result = coroutine.running()
    rawget_result[running_result] = true
    signal:Once(function(...)
        rawget_result[running_result] = nil
        task.spawn(running_result, ...)
    end)
    return coroutine.yield()
end

function instance.Destroy(self)
    self:DisconnectAll()
    local connection_2 = rawget(self, "_proxyHandler")
    if not connection_2 then
        return
    end
    connection_2:Disconnect()
end

local metatable_2 = { __index = 0, __newindex = 0 }

function metatable_2.__index(self, argument)
    error(("Attempt to get Signal::%s (not a valid member)"):format(tostring(argument)), 2)
end

function metatable_2.__newindex(self, argument, argument_2)
    error(("Attempt to set Signal::%s (not a valid member)"):format(tostring(argument)), 2)
end

setmetatable(instance, metatable_2)
local values = {}
values.new = instance.new
values.Wrap = instance.Wrap
values.Is = instance.Is

return table.freeze(values)
