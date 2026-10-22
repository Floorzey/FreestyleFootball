local metatable = {
    __mode = "k",
}

local function is_callable(argument)
    if type(argument) == "function" then
        return true
    end

    local metatable_2 = type(argument) == "table" and getmetatable(argument)

    if metatable_2 then
        local rawget_result = rawget(metatable_2, "__call")

        if type(rawget_result) == "function" then
            return true
        end
    end

    return false
end

local function make_enum(argument, argument_2)
    local values = {}

    for _, item in ipairs(argument_2) do
        values[item] = item
    end

    return setmetatable(values, {
        __index = function(argument_3, argument_4)
            error(string.format("%s is not in %s!", argument_4, argument), 2)
        end,

        __newindex = function()
            error(string.format("Creating new members in %s is not allowed!", argument), 2)
        end,
    })
end

local error_2 = {
    Kind = make_enum("Promise.Error.Kind", { "ExecutionError", "AlreadyCancelled", "NotResolvedInTime", "TimedOut" }),
}
error_2.__index = error_2

function error_2.new(argument, parent)
    local values = argument or {}
    local values_2 = {
        error = tostring(values.error) or "[This error has no error text.]",
        trace = values.trace,
        context = values.context,
        kind = values.kind,
        parent = parent,
        createdTick = os.clock(),
        createdTrace = debug.traceback(),
    }

    return setmetatable(values_2, error_2)
end

function error_2.is(argument)
    if type(argument) ~= "table" then
        return false
    end

    local metatable_2 = getmetatable(argument)

    if type(metatable_2) ~= "table" then
        return false
    end

    local enabled

    if rawget(argument, "error") == nil then
        enabled = false
    else
        local rawget_result = rawget(metatable_2, "extend")
        enabled = type(rawget_result) == "function"
    end

    return enabled
end

function error_2.isKind(argument, argument_2)
    assert(argument_2 ~= nil, "Argument #2 to Promise.Error.isKind must not be nil")

    return error_2.is(argument) and argument.kind == argument_2
end

function error_2.extend(argument, argument_2)
    local values = argument_2 or {}
    values.kind = values.kind or argument.kind

    return error_2.new(values, argument)
end

function error_2.getErrorChain(argument)
    local items = { argument }

    while items[#items].parent do
        table.insert(items, items[#items].parent)
    end

    return items
end

function error_2.__tostring(argument)
    local items = { string.format("-- Promise.Error(%s) --", argument.kind or "?") }

    for _, item in ipairs(argument:getErrorChain()) do
        table.insert(items, table.concat({ item.trace or item.error, item.context }, "\n"))
    end

    return table.concat(items, "\n")
end

local function pack(...)
    return select("#", ...), { ... }
end

local function pack_result(argument, ...)
    return argument, select("#", ...), { ... }
end

local function make_error_handler(argument)
    assert(argument ~= nil, "traceback is nil")

    return function(error_3)
        if type(error_3) == "table" then
            return error_3
        end

        return error_2.new({
            error = error_3,
            kind = error_2.Kind.ExecutionError,
            trace = debug.traceback(tostring(error_3), 2),
            context = "Promise created at:\n\n" .. argument,
        })
    end
end

local function run_executor(argument, argument_2, ...)
    assert(argument ~= nil, "traceback is nil")

    return pack_result(xpcall(argument_2, function(error_3)
        if type(error_3) == "table" then
            return error_3
        end

        return error_2.new({
            error = error_3,
            kind = error_2.Kind.ExecutionError,
            trace = debug.traceback(tostring(error_3), 2),
            context = "Promise created at:\n\n" .. argument,
        })
    end, ...))
end

local function create_advancer(argument, argument_2, callback, callback_2)
    return function(...)
        local result, value, value_2 = run_executor(argument, argument_2, ...)

        if result then
            callback(unpack(value_2, 1, value))

            return
        end

        callback_2(value_2[1])
    end
end

local function is_empty(argument)
    return next(argument) == nil
end

local promise = {
    Error = error_2,
    Status = make_enum("Promise.Status", { "Started", "Resolved", "Rejected", "Cancelled" }),
    _getTime = os.clock,
    _timeEvent = game:GetService("RunService").Heartbeat,
    _unhandledRejectionCallbacks = {},
    prototype = {},
}
promise.__index = promise.prototype

function promise._new(source, argument, parent)
    if parent ~= nil and not promise.is(parent) then
        error("Argument #2 to Promise.new must be a promise or nil", 2)
    end

    local values = {
        _thread = nil,
        _values = nil,
        _valuesLength = -1,
        _unhandledRejection = true,
        _cancellationHook = nil,
        _source = source,
        _status = promise.Status.Started,
        _queuedResolve = {},
        _queuedReject = {},
        _queuedFinally = {},
        _parent = parent,
        _consumers = setmetatable({}, metatable),
    }

    if parent and parent._status == promise.Status.Started then
        parent._consumers[values] = true
    end

    setmetatable(values, promise)

    local function resolve(...)
        values:_resolve(...)
    end

    local function reject(...)
        values:_reject(...)
    end

    local function on_cancel(cancellation_hook)
        if cancellation_hook then
            if values._status == promise.Status.Cancelled then
                cancellation_hook()
            else
                values._cancellationHook = cancellation_hook
            end
        end

        return values._status == promise.Status.Cancelled
    end

    values._thread = coroutine.create(function()
        local result, _, value = run_executor(values._source, argument, resolve, reject, on_cancel)

        if not result then
            reject(value[1])
        end
    end)
    task.spawn(values._thread)

    return values
end

function promise.new(argument)
    return promise._new(debug.traceback(nil, 2), argument)
end

function promise.__tostring(argument)
    return string.format("Promise(%s)", argument._status)
end

function promise.defer(argument)
    local source = debug.traceback(nil, 2)

    return promise._new(source, function(argument_2, callback, argument_3)
        task.defer(function()
            local result, _, value = run_executor(source, argument, argument_2, callback, argument_3)

            if not result then
                callback(value[1])
            end
        end)
    end)
end

promise.async = promise.defer

function promise.resolve(...)
    local result, value = pack(...)

    return promise._new(debug.traceback(nil, 2), function(callback)
        callback(unpack(value, 1, result))
    end)
end

function promise.reject(...)
    local result, value = pack(...)

    return promise._new(debug.traceback(nil, 2), function(argument, callback)
        callback(unpack(value, 1, result))
    end)
end

function promise._try(source, callback, ...)
    local result, value = pack(...)

    return promise._new(source, function(callback_2)
        callback_2(callback(unpack(value, 1, result)))
    end)
end

function promise.try(callback, ...)
    return promise._try(debug.traceback(nil, 2), callback, ...)
end

function promise._all(source, argument, argument_2)
    if type(argument) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.all"), 3)
    end

    for key, item in pairs(argument) do
        if not promise.is(item) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.all", (tostring(key))), 3)
        end
    end

    if #argument == 0 or argument_2 == 0 then
        return promise.resolve({})
    end

    return promise._new(source, function(callback, callback_2, callback_3)
        local values = {}
        local values_2 = {}
        local number = 0
        local number_2 = 0
        local enabled = false

        local function resolve_one(argument_3, ...)
            if enabled then
                return
            end

            number = number + 1

            if argument_2 == nil then
                values[argument_3] = ...
            else
                values[number] = ...
            end

            if not (number >= (argument_2 or #argument)) then
                return
            end

            enabled = true
            callback(values)

            for _, item_4 in ipairs(values_2) do
                item_4:cancel()
            end
        end

        callback_3(function()
            for _, item_4 in ipairs(values_2) do
                item_4:cancel()
            end
        end)

        for index, item_2 in ipairs(argument) do
            values_2[index] = item_2:andThen(function(...)
                resolve_one(index, ...)
            end, function(...)
                number_2 = number_2 + 1

                if not (argument_2 == nil or #argument - number_2 < argument_2) then
                    return
                end

                for _, item_4 in ipairs(values_2) do
                    item_4:cancel()
                end

                enabled = true
                callback_2(...)
            end)
        end

        if enabled then
            for _, item_3 in ipairs(values_2) do
                item_3:cancel()
            end
        end
    end)
end

function promise.all(argument)
    return promise._all(debug.traceback(nil, 2), argument)
end

function promise.fold(argument, callback, argument_2)
    local is_table = type(argument) == "table"
    assert(is_table, "Bad argument #1 to Promise.fold: must be a table")
    local enabled

    if type(callback) == "function" then
        enabled = true
    elseif type(callback) == "table" then
        local metatable_2 = getmetatable(callback)

        if metatable_2 then
            local rawget_result = rawget(metatable_2, "__call")
            enabled = type(rawget_result) == "function"
        else
            enabled = false
        end
    else
        enabled = false
    end

    assert(enabled, "Bad argument #2 to Promise.fold: must be a function")
    local resolve_result = promise.resolve(argument_2)

    return promise
        .each(argument, function(argument_3, argument_4)
            resolve_result = resolve_result:andThen(function(argument_5)
                return callback(argument_5, argument_3, argument_4)
            end)
        end)
        :andThen(function()
            return resolve_result
        end)
end

function promise.some(argument, argument_2)
    local is_number = type(argument_2) == "number"
    assert(is_number, "Bad argument #2 to Promise.some: must be a number")

    return promise._all(debug.traceback(nil, 2), argument, argument_2)
end

function promise.any(argument)
    return promise._all(debug.traceback(nil, 2), argument, 1):andThen(function(argument_2)
        return argument_2[1]
    end)
end

function promise.allSettled(argument)
    if type(argument) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.allSettled"), 2)
    end

    for key, item in pairs(argument) do
        if not promise.is(item) then
            error(
                string.format("Non-promise value passed into %s at index %s", "Promise.allSettled", (tostring(key))),
                2
            )
        end
    end

    if #argument == 0 then
        return promise.resolve({})
    end

    return promise._new(debug.traceback(nil, 2), function(callback, argument_2, callback_2)
        local values = {}
        local values_2 = {}
        local number = 0

        local function callback_3(argument_3, ...)
            number = number + 1
            values[argument_3] = ...

            if number >= #argument then
                callback(values)
            end
        end

        callback_2(function()
            for _, item_3 in ipairs(values_2) do
                item_3:cancel()
            end
        end)

        for index, item_2 in ipairs(argument) do
            values_2[index] = item_2:finally(function(...)
                callback_3(index, ...)
            end)
        end
    end)
end

function promise.race(argument)
    local is_table = type(argument) == "table"
    assert(is_table, string.format("Please pass a list of promises to %s", "Promise.race"))

    for key, item in pairs(argument) do
        local is_result = promise.is(item)
        local string_format = string.format
        local tostring_result = tostring(key)
        assert(
            is_result,
            string_format("Non-promise value passed into %s at index %s", "Promise.race", tostring_result)
        )
    end

    return promise._new(debug.traceback(nil, 2), function(callback, callback_2, callback_3)
        local values = {}
        local enabled = false

        local function cancel()
            for _, item_4 in ipairs(values) do
                item_4:cancel()
            end
        end

        local function finalize(callback_4)
            return function(...)
                for _, item_4 in ipairs(values) do
                    item_4:cancel()
                end

                enabled = true

                return callback_4(...)
            end
        end

        if
            callback_3(function(...)
                for _, item_4 in ipairs(values) do
                    item_4:cancel()
                end

                enabled = true

                return callback_2(...)
            end)
        then
            return
        end

        for index, item_2 in ipairs(argument) do
            values[index] = item_2:andThen(function(...)
                for _, item_4 in ipairs(values) do
                    item_4:cancel()
                end

                enabled = true

                return callback(...)
            end, function(...)
                for _, item_4 in ipairs(values) do
                    item_4:cancel()
                end

                enabled = true

                return callback_2(...)
            end)
        end

        if enabled then
            for _, item_3 in ipairs(values) do
                item_3:cancel()
            end
        end
    end)
end

function promise.each(argument, callback)
    local is_table = type(argument) == "table"
    assert(is_table, string.format("Please pass a list of promises to %s", "Promise.each"))
    local enabled

    if type(callback) == "function" then
        enabled = true
    elseif type(callback) == "table" then
        local metatable_2 = getmetatable(callback)

        if metatable_2 then
            local rawget_result = rawget(metatable_2, "__call")
            enabled = type(rawget_result) == "function"
        else
            enabled = false
        end
    else
        enabled = false
    end

    assert(enabled, string.format("Please pass a handler function to %s!", "Promise.each"))

    return promise._new(debug.traceback(nil, 2), function(callback_2, callback_3, callback_4)
        local values = {}
        local items = {}
        local enabled_2 = false

        local function _()
            for _, item_8 in ipairs(items) do
                item_8:cancel()
            end
        end

        callback_4(function()
            enabled_2 = true

            for _, item_8 in ipairs(items) do
                item_8:cancel()
            end
        end)

        local values_2 = {}

        for index, item in ipairs(argument) do
            if promise.is(item) then
                if item:getStatus() == promise.Status.Cancelled then
                    for _, item_2 in ipairs(items) do
                        item_2:cancel()
                    end

                    return callback_3(error_2.new({
                        error = "Promise is cancelled",
                        kind = error_2.Kind.AlreadyCancelled,
                        context = string.format(
                            "The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s",
                            index,
                            item._source
                        ),
                    }))
                end

                if item:getStatus() == promise.Status.Rejected then
                    for _, item_3 in ipairs(items) do
                        item_3:cancel()
                    end

                    return callback_3(select(2, item:await()))
                end

                local and_then_result = item:andThen(function(...)
                    return ...
                end)
                table.insert(items, and_then_result)
                values_2[index] = and_then_result
            else
                values_2[index] = item
            end
        end

        for index_2, item_4 in ipairs(values_2) do
            local item_5

            if promise.is(item_4) then
                local await_result
                await_result, item_5 = item_4:await()

                if not await_result then
                    for _, item_6 in ipairs(items) do
                        item_6:cancel()
                    end

                    return callback_3(item_5)
                end
            else
                item_5 = item_4
            end

            if enabled_2 then
                return
            end

            local resolve_result = promise.resolve(callback(item_5, index_2))
            table.insert(items, resolve_result)
            local await_result_2, value = resolve_result:await()

            if not await_result_2 then
                for _, item_7 in ipairs(items) do
                    item_7:cancel()
                end

                return callback_3(value)
            end

            values[index_2] = value
        end

        callback_2(values)
    end)
end

function promise.is(argument)
    if type(argument) ~= "table" then
        return false
    end

    local metatable_2 = getmetatable(argument)

    if metatable_2 == promise then
        return true
    end

    if metatable_2 ~= nil then
        if type(metatable_2) == "table" then
            local rawget_result = rawget(metatable_2, "__index")

            if type(rawget_result) == "table" then
                local rawget_result_2 = rawget(metatable_2, "__index")
                local rawget_result_3 = rawget(rawget_result_2, "andThen")
                local enabled

                if type(rawget_result_3) == "function" then
                    enabled = true
                else
                    local metatable_3 = type(rawget_result_3) == "table" and getmetatable(rawget_result_3)

                    if metatable_3 then
                        local rawget_result_4 = rawget(metatable_3, "__call")
                        enabled = type(rawget_result_4) == "function"
                    else
                        enabled = false
                    end
                end

                if enabled then
                    return true
                end
            end
        end

        return false
    end

    local and_then = argument.andThen

    if type(and_then) == "function" then
        return true
    end

    local metatable_4 = type(and_then) == "table" and getmetatable(and_then)

    if metatable_4 then
        local rawget_result_5 = rawget(metatable_4, "__call")

        if type(rawget_result_5) == "function" then
            return true
        end
    end

    return false
end

function promise.promisify(callback)
    return function(...)
        return promise._try(debug.traceback(nil, 2), callback, ...)
    end
end

function promise.delay(argument)
    local is_number = type(argument) == "number"
    assert(is_number, "Bad argument #1 to Promise.delay, must be a number.")
    local get_time_result = promise._getTime()

    return promise._new(debug.traceback(nil, 2), function(callback)
        task.delay(argument, function()
            callback(promise._getTime() - get_time_result)
        end)
    end)
end

function promise.prototype.timeout(argument, argument_2, argument_3)
    local traceback_result = debug.traceback(nil, 2)

    return promise.race({
        promise.delay(argument_2):andThen(function()
            return promise.reject(argument_3 == nil and error_2.new({
                error = "Timed out",
                kind = error_2.Kind.TimedOut,
                context = string.format(
                    "Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s",
                    argument_2,
                    traceback_result
                ),
            }) or argument_3)
        end),
        argument,
    })
end

function promise.prototype.getStatus(argument)
    return argument._status
end

function promise.prototype._andThen(parent, source, argument, argument_2)
    parent._unhandledRejection = false

    if parent._status ~= promise.Status.Cancelled then
        return promise._new(source, function(callback, callback_2, callback_3)
            local callback_4

            if argument then
                local source_2 = source
                local argument_3 = argument

                callback_4 = function(...)
                    local result, value, value_2 = run_executor(source_2, argument_3, ...)

                    if result then
                        callback(unpack(value_2, 1, value))

                        return
                    end

                    callback_2(value_2[1])
                end
            else
                callback_4 = callback
            end

            if argument_2 then
                local source_3 = source
                local argument_4 = argument_2

                callback_2 = function(...)
                    local result, value, value_2 = run_executor(source_3, argument_4, ...)

                    if result then
                        callback(unpack(value_2, 1, value))

                        return
                    end

                    callback_2(value_2[1])
                end
            end

            if parent._status == promise.Status.Started then
                table.insert(parent._queuedResolve, callback_4)
                table.insert(parent._queuedReject, callback_2)

                callback_3(function()
                    if parent._status == promise.Status.Started then
                        table.remove(parent._queuedResolve, table.find(parent._queuedResolve, callback_4))
                        table.remove(parent._queuedReject, table.find(parent._queuedReject, callback_2))
                    end
                end)
            elseif parent._status == promise.Status.Resolved then
                callback_4(unpack(parent._values, 1, parent._valuesLength))
            elseif parent._status == promise.Status.Rejected then
                callback_2(unpack(parent._values, 1, parent._valuesLength))
            end
        end, parent)
    end

    local promise_2 = promise.new(function() end)
    promise_2:cancel()

    return promise_2
end

function promise.prototype.andThen(argument, argument_2, argument_3)
    local enabled

    if argument_2 == nil or type(argument_2) == "function" then
        enabled = true
    elseif type(argument_2) == "table" then
        local metatable_2 = getmetatable(argument_2)

        if metatable_2 then
            local rawget_result = rawget(metatable_2, "__call")
            enabled = type(rawget_result) == "function"
        else
            enabled = false
        end
    else
        enabled = false
    end

    assert(enabled, string.format("Please pass a handler function to %s!", "Promise:andThen"))
    local enabled_2

    if argument_3 == nil or type(argument_3) == "function" then
        enabled_2 = true
    elseif type(argument_3) == "table" then
        local metatable_3 = getmetatable(argument_3)

        if metatable_3 then
            local rawget_result_2 = rawget(metatable_3, "__call")
            enabled_2 = type(rawget_result_2) == "function"
        else
            enabled_2 = false
        end
    else
        enabled_2 = false
    end

    assert(enabled_2, string.format("Please pass a handler function to %s!", "Promise:andThen"))

    return argument:_andThen(debug.traceback(nil, 2), argument_2, argument_3)
end

function promise.prototype.catch(argument, argument_2)
    local enabled

    if argument_2 == nil or type(argument_2) == "function" then
        enabled = true
    elseif type(argument_2) == "table" then
        local metatable_2 = getmetatable(argument_2)

        if metatable_2 then
            local rawget_result = rawget(metatable_2, "__call")
            enabled = type(rawget_result) == "function"
        else
            enabled = false
        end
    else
        enabled = false
    end

    assert(enabled, string.format("Please pass a handler function to %s!", "Promise:catch"))

    return argument:_andThen(debug.traceback(nil, 2), nil, argument_2)
end

function promise.prototype.tap(argument, callback)
    local enabled

    if type(callback) == "function" then
        enabled = true
    elseif type(callback) == "table" then
        local metatable_2 = getmetatable(callback)

        if metatable_2 then
            local rawget_result = rawget(metatable_2, "__call")
            enabled = type(rawget_result) == "function"
        else
            enabled = false
        end
    else
        enabled = false
    end

    assert(enabled, string.format("Please pass a handler function to %s!", "Promise:tap"))

    return argument:_andThen(debug.traceback(nil, 2), function(...)
        local result = callback(...)

        if not promise.is(result) then
            return ...
        end

        local result_2, value = pack(...)

        return result:andThen(function()
            return unpack(value, 1, result_2)
        end)
    end)
end

function promise.prototype.andThenCall(argument, callback, ...)
    local enabled

    if type(callback) == "function" then
        enabled = true
    elseif type(callback) == "table" then
        local metatable_2 = getmetatable(callback)

        if metatable_2 then
            local rawget_result = rawget(metatable_2, "__call")
            enabled = type(rawget_result) == "function"
        else
            enabled = false
        end
    else
        enabled = false
    end

    assert(enabled, string.format("Please pass a handler function to %s!", "Promise:andThenCall"))
    local result, value = pack(...)

    return argument:_andThen(debug.traceback(nil, 2), function()
        return callback(unpack(value, 1, result))
    end)
end

function promise.prototype.andThenReturn(argument, ...)
    local result, value = pack(...)

    return argument:_andThen(debug.traceback(nil, 2), function()
        return unpack(value, 1, result)
    end)
end

function promise.prototype.cancel(argument)
    if argument._status ~= promise.Status.Started then
        return
    end

    argument._status = promise.Status.Cancelled

    if argument._cancellationHook then
        argument._cancellationHook()
    end

    coroutine.close(argument._thread)

    if argument._parent then
        argument._parent:_consumerCancelled(argument)
    end

    for key in pairs(argument._consumers) do
        key:cancel()
    end

    argument:_finalize()
end

function promise.prototype._consumerCancelled(argument, argument_2)
    if argument._status ~= promise.Status.Started then
        return
    end

    argument._consumers[argument_2] = nil

    if next(argument._consumers) == nil then
        argument:cancel()
    end
end

function promise.prototype._finally(argument, source, argument_2)
    argument._unhandledRejection = false

    return promise._new(source, function(callback, callback_2, callback_3)
        local value = nil

        callback_3(function()
            argument:_consumerCancelled(argument)

            if value then
                value:cancel()
            end
        end)

        local callback_4 = argument_2
                and function(...)
                    local result, _, value_2 = run_executor(source, argument_2, ...)
                    local entry = value_2[1]

                    if not result then
                        return callback_2(entry)
                    end

                    if not promise.is(entry) then
                        callback(argument)

                        return
                    end

                    value = entry

                    entry
                        :finally(function(argument_3)
                            if argument_3 ~= promise.Status.Rejected then
                                callback(argument)
                            end
                        end)
                        :catch(function(...)
                            callback_2(...)
                        end)
                end
            or callback

        if argument._status == promise.Status.Started then
            table.insert(argument._queuedFinally, callback_4)
        else
            callback_4(argument._status)
        end
    end)
end

function promise.prototype.finally(argument, argument_2)
    local enabled

    if argument_2 == nil or type(argument_2) == "function" then
        enabled = true
    elseif type(argument_2) == "table" then
        local metatable_2 = getmetatable(argument_2)

        if metatable_2 then
            local rawget_result = rawget(metatable_2, "__call")
            enabled = type(rawget_result) == "function"
        else
            enabled = false
        end
    else
        enabled = false
    end

    assert(enabled, string.format("Please pass a handler function to %s!", "Promise:finally"))

    return argument:_finally(debug.traceback(nil, 2), argument_2)
end

function promise.prototype.finallyCall(argument, callback, ...)
    local enabled

    if type(callback) == "function" then
        enabled = true
    elseif type(callback) == "table" then
        local metatable_2 = getmetatable(callback)

        if metatable_2 then
            local rawget_result = rawget(metatable_2, "__call")
            enabled = type(rawget_result) == "function"
        else
            enabled = false
        end
    else
        enabled = false
    end

    assert(enabled, string.format("Please pass a handler function to %s!", "Promise:finallyCall"))
    local result, value = pack(...)

    return argument:_finally(debug.traceback(nil, 2), function()
        return callback(unpack(value, 1, result))
    end)
end

function promise.prototype.finallyReturn(argument, ...)
    local result, value = pack(...)

    return argument:_finally(debug.traceback(nil, 2), function()
        return unpack(value, 1, result)
    end)
end

function promise.prototype.awaitStatus(argument)
    argument._unhandledRejection = false

    if argument._status == promise.Status.Started then
        local running_result = coroutine.running()

        argument
            :finally(function()
                task.spawn(running_result)
            end)
            :catch(function() end)

        coroutine.yield()
    end

    if argument._status == promise.Status.Resolved then
        return argument._status, unpack(argument._values, 1, argument._valuesLength)
    end

    if argument._status == promise.Status.Rejected then
        return argument._status, unpack(argument._values, 1, argument._valuesLength)
    end

    return argument._status
end

local function await_helper(argument, ...)
    return argument == promise.Status.Resolved, ...
end

function promise.prototype.await(argument)
    return await_helper(argument:awaitStatus())
end

local function expect_helper(argument, ...)
    if argument ~= promise.Status.Resolved then
        error(... == nil and "Expected Promise rejected with no value." or ..., 3)
    end

    return ...
end

function promise.prototype.expect(argument)
    return expect_helper(argument:awaitStatus())
end

promise.prototype.awaitValue = promise.prototype.expect

function promise.prototype._unwrap(argument)
    if argument._status == promise.Status.Started then
        error("Promise has not resolved or rejected.", 2)
    end

    return argument._status == promise.Status.Resolved, unpack(argument._values, 1, argument._valuesLength)
end

function promise.prototype._resolve(argument, ...)
    if argument._status ~= promise.Status.Started then
        if promise.is((...)) then
            (...):_consumerCancelled(argument)
        end

        return
    end

    if promise.is((...)) then
        if select("#", ...) > 1 then
            local formatted_text = string.format(
                "When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s",
                argument._source
            )
            warn(formatted_text)
        end

        local value = ...
        local parent = value:andThen(function(...)
            argument:_resolve(...)
        end, function(...)
            local value_entry = value._values[1]

            if value._error then
                value_entry = error_2.new({
                    context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]",
                    error = value._error,
                    kind = error_2.Kind.ExecutionError,
                })
            end

            if error_2.isKind(value_entry, error_2.Kind.ExecutionError) then
                return argument:_reject(value_entry:extend({
                    error = "This Promise was chained to a Promise that errored.",
                    trace = "",
                    context = string.format(
                        "The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n",
                        argument._source
                    ),
                }))
            end

            argument:_reject(...)
        end)

        if parent._status == promise.Status.Cancelled then
            argument:cancel()

            return
        end

        if parent._status == promise.Status.Started then
            argument._parent = parent
            parent._consumers[argument] = true
        end

        return
    end

    argument._status = promise.Status.Resolved
    local values_length, values = pack(...)
    argument._valuesLength = values_length
    argument._values = values

    for _, item in ipairs(argument._queuedResolve) do
        coroutine.wrap(item)(...)
    end

    argument:_finalize()
end

function promise.prototype._reject(argument, ...)
    if argument._status ~= promise.Status.Started then
        return
    end

    argument._status = promise.Status.Rejected
    local values_length, values = pack(...)
    argument._valuesLength = values_length
    argument._values = values

    if next(argument._queuedReject) == nil then
        local tostring_result = tostring((...))
        coroutine.wrap(function()
            promise._timeEvent:Wait()

            if not argument._unhandledRejection then
                return
            end

            local formatted_text =
                string.format("Unhandled Promise rejection:\n\n%s\n\n%s", tostring_result, argument._source)

            for _, item_2 in ipairs(promise._unhandledRejectionCallbacks) do
                task.spawn(item_2, argument, unpack(argument._values, 1, argument._valuesLength))
            end

            if promise.TEST then
                return
            end

            warn(formatted_text)
        end)()
    else
        for _, item in ipairs(argument._queuedReject) do
            coroutine.wrap(item)(...)
        end
    end

    argument:_finalize()
end

function promise.prototype._finalize(argument)
    for _, item in ipairs(argument._queuedFinally) do
        coroutine.wrap(item)(argument._status)
    end

    argument._queuedFinally = nil
    argument._queuedReject = nil
    argument._queuedResolve = nil

    if not promise.TEST then
        argument._parent = nil
        argument._consumers = nil
    end

    task.defer(coroutine.close, argument._thread)
end

function promise.prototype.now(argument, error_3)
    local traceback_result = debug.traceback(nil, 2)

    if argument._status == promise.Status.Resolved then
        return argument:_andThen(traceback_result, function(...)
            return ...
        end)
    end

    local reject = promise.reject

    if error_3 == nil then
        error_3 = error_2.new({
            error = "This Promise was not resolved in time for :now()",
            kind = error_2.Kind.NotResolvedInTime,
            context = ":now() was called at:\n\n" .. traceback_result,
        }) or error_3
    end

    return reject(error_3)
end

function promise.retry(callback, argument, ...)
    local enabled

    if type(callback) == "function" then
        enabled = true
    elseif type(callback) == "table" then
        local metatable_2 = getmetatable(callback)

        if metatable_2 then
            local rawget_result = rawget(metatable_2, "__call")
            enabled = type(rawget_result) == "function"
        else
            enabled = false
        end
    else
        enabled = false
    end

    assert(enabled, "Parameter #1 to Promise.retry must be a function")
    local is_number = type(argument) == "number"
    assert(is_number, "Parameter #2 to Promise.retry must be a number")
    local values = { ... }
    local select_result = select("#", ...)

    return promise.resolve(callback(...)):catch(function(...)
        if argument > 0 then
            return promise.retry(callback, argument - 1, unpack(values, 1, select_result))
        end

        return promise.reject(...)
    end)
end

function promise.retryWithDelay(callback, argument, argument_2, ...)
    local enabled

    if type(callback) == "function" then
        enabled = true
    elseif type(callback) == "table" then
        local metatable_2 = getmetatable(callback)

        if metatable_2 then
            local rawget_result = rawget(metatable_2, "__call")
            enabled = type(rawget_result) == "function"
        else
            enabled = false
        end
    else
        enabled = false
    end

    assert(enabled, "Parameter #1 to Promise.retry must be a function")
    local is_number = type(argument) == "number"
    assert(is_number, "Parameter #2 (times) to Promise.retry must be a number")
    local is_number_2 = type(argument_2) == "number"
    assert(is_number_2, "Parameter #3 (seconds) to Promise.retry must be a number")
    local values = { ... }
    local select_result = select("#", ...)

    return promise.resolve(callback(...)):catch(function(...)
        if argument <= 0 then
            return promise.reject(...)
        end

        promise.delay(argument_2):await()

        return promise.retryWithDelay(callback, argument - 1, argument_2, unpack(values, 1, select_result))
    end)
end

function promise.fromEvent(signal, argument)
    local callback = argument or function()
        return true
    end

    return promise._new(debug.traceback(nil, 2), function(callback_2, argument_2, callback_3)
        local connection = nil
        local enabled = false

        local function disconnect()
            connection:Disconnect()
            connection = nil
        end

        connection = signal:Connect(function(...)
            local enabled_2 = callback(...)

            if enabled_2 ~= true then
                if type(enabled_2) ~= "boolean" then
                    error("Promise.fromEvent predicate should always return a boolean")
                end

                return
            end

            callback_2(...)

            if not connection then
                enabled = true

                return
            end

            connection:Disconnect()
            connection = nil
        end)

        if enabled and connection then
            return disconnect()
        end

        callback_3(disconnect)
    end)
end

function promise.onUnhandledRejection(argument)
    table.insert(promise._unhandledRejectionCallbacks, argument)

    return function()
        local match_index = table.find(promise._unhandledRejectionCallbacks, argument)

        if match_index then
            table.remove(promise._unhandledRejectionCallbacks, match_index)
        end
    end
end

return promise
