local value = nil

local function acquire_runner_thread_and_call_event_handler(callback, ...)
    local value_2 = value
    value = nil
    callback(...)
    value = value_2
end

local function run_event_handler_in_free_thread(...)
    acquire_runner_thread_and_call_event_handler(...)

    while true do
        acquire_runner_thread_and_call_event_handler(coroutine.yield())
    end
end

local connection = {}
connection.__index = connection

function connection.Disconnect(argument)
    if not argument.Connected then
        return
    end

    argument.Connected = false

    if argument._signal._handlerListHead == argument then
        argument._signal._handlerListHead = argument._next

        return
    end

    local handler_list_head = argument._signal._handlerListHead

    while handler_list_head and handler_list_head._next ~= argument do
        handler_list_head = handler_list_head._next
    end

    if handler_list_head then
        handler_list_head._next = argument._next
    end
end

connection.Destroy = connection.Disconnect
setmetatable(connection, {
    __index = function(argument, argument_2)
        error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(argument_2))), 2)
    end,

    __newindex = function(argument, argument_2, argument_3)
        error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(argument_2))), 2)
    end,
})
local instance = {}
instance.__index = instance

function instance.new()
    return setmetatable({
        _handlerListHead = false,
        _proxyHandler = nil,
        _yieldedThreads = nil,
    }, instance)
end

function instance.Wrap(signal: userdata)
    local is_rbx_script_signal = typeof(signal) == "RBXScriptSignal"
    local text = "Argument #1 to Signal.Wrap must be a RBXScriptSignal; got " .. typeof(signal)
    assert(is_rbx_script_signal, text)
    local instance_2 = instance.new()
    instance_2._proxyHandler = signal:Connect(function(...)
        instance_2:Fire(...)
    end)

    return instance_2
end

function instance.Is(argument)
    local condition

    if type(argument) == "table" then
        condition = getmetatable(argument) == instance
    else
        condition = false
    end

    return condition
end

function instance.Connect(signal, fn)
    local handler_list_head = setmetatable({
        Connected = true,
        _next = false,
        _signal = signal,
        _fn = fn,
    }, connection)

    if not signal._handlerListHead then
        signal._handlerListHead = handler_list_head

        return handler_list_head
    end

    handler_list_head._next = signal._handlerListHead
    signal._handlerListHead = handler_list_head

    return handler_list_head
end

function instance.ConnectOnce(signal, argument)
    return signal:Once(argument)
end

function instance.Once(signal, callback)
    local connection_2 = nil
    local enabled = false
    connection_2 = signal:Connect(function(...)
        if enabled then
            return
        end

        enabled = true
        connection_2:Disconnect()
        callback(...)
    end)

    return connection_2
end

function instance.GetConnections(argument)
    local handler_list_head = argument._handlerListHead
    local items = {}

    while handler_list_head do
        table.insert(items, handler_list_head)
        handler_list_head = handler_list_head._next
    end

    return items
end

function instance.DisconnectAll(argument)
    local handler_list_head = argument._handlerListHead

    while handler_list_head do
        handler_list_head.Connected = false
        handler_list_head = handler_list_head._next
    end

    argument._handlerListHead = false

    if not argument._yieldedThreads then
        return
    end

    for key in argument._yieldedThreads do
        if coroutine.status(key) == "suspended" then
            warn(debug.traceback(key, "signal disconnected; yielded thread cancelled", 2))
            task.cancel(key)
        end
    end

    table.clear(argument._yieldedThreads)
end

function instance.Fire(argument, ...)
    local handler_list_head = argument._handlerListHead

    while handler_list_head do
        if handler_list_head.Connected then
            if not value then
                value = coroutine.create(run_event_handler_in_free_thread)
            end

            task.spawn(value, handler_list_head._fn, ...)
        end

        handler_list_head = handler_list_head._next
    end
end

function instance.FireDeferred(argument, ...)
    local handler_list_head = argument._handlerListHead

    while handler_list_head do
        task.defer(function(...)
            if handler_list_head.Connected then
                handler_list_head._fn(...)
            end
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

function instance.Destroy(argument)
    argument:DisconnectAll()
    local connection_2 = rawget(argument, "_proxyHandler")

    if connection_2 then
        connection_2:Disconnect()
    end
end

setmetatable(instance, {
    __index = function(argument, argument_2)
        error(("Attempt to get Signal::%s (not a valid member)"):format((tostring(argument_2))), 2)
    end,

    __newindex = function(argument, argument_2, argument_3)
        error(("Attempt to set Signal::%s (not a valid member)"):format((tostring(argument_2))), 2)
    end,
})

return table.freeze({
    new = instance.new,
    Wrap = instance.Wrap,
    Is = instance.Is,
})
