local metatable = { __mode = "k" }

local function is_callable(argument)
    if type(argument) == "function" then
        return true
    end

    if type(argument) == "table" then
        local metatable_2 = getmetatable(argument)

        if metatable_2 and type(rawget(metatable_2, "__call")) == "function" then
            return true
        end
    end

    return false
end

local values = {}

local function make_enum(argument, argument_2)
    local values_2 = {}

    for _, item in ipairs(argument_2) do
        values_2[item] = item
    end

    local values_3 = {}

    function values_3.__index(argument_3, argument_4)
        error(string.format("%s is not in %s!", argument_4, argument), 2)
    end

    function values_3.__newindex()
        error(string.format("Creating new members in %s is not allowed!", argument), 2)
    end

    return (setmetatable(values_2, values_3))
end

values.Kind = make_enum("Promise.Error.Kind", { "ExecutionError", "AlreadyCancelled", "NotResolvedInTime", "TimedOut" })
local error_2 = values
error_2.__index = error_2

function error_2.new(values_2, parent)
    values_2 = values_2 or {}

    return (
        setmetatable({
            error = tostring(values_2.error) or "[This error has no error text.]",
            trace = values_2.trace,
            context = values_2.context,
            kind = values_2.kind,
            parent = parent,
            createdTick = os.clock(),
            createdTrace = debug.traceback(),
        }, error_2)
    )
end

function error_2.is(argument)
    if type(argument) == "table" then
        local metatable_2 = getmetatable(argument)

        if type(metatable_2) == "table" then
            return (rawget(argument, "error") ~= nil) and (type(rawget(metatable_2, "extend")) == "function")
        end
    end

    return false
end

function error_2.isKind(argument, argument_2)
    assert(argument_2 ~= nil, "Argument #2 to Promise.Error.isKind must not be nil")

    return error_2.is(argument) and (argument.kind == argument_2)
end

function error_2.extend(argument, argument_2)
    local values_2 = argument_2 or {}
    values_2.kind = values_2.kind or argument.kind

    return error_2.new(values_2, argument)
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
        local values_2 = {}
        values_2[1], values_2[2] = item.trace or item.error, item.context
        table.insert(items, table.concat(values_2, "\n"))
    end

    return table.concat(items, "\n")
end

local function pack_result(argument, ...)
    return argument, select("#", ...), { ... }
end

local function make_error_handler(argument)
    assert(argument ~= nil, "traceback is nil")

    return function() end
end

local function run_executor(argument, argument_2, ...)
    assert(argument ~= nil, "traceback is nil")

    return pack_result(xpcall(argument_2, function(error_3)
        if type(error_3) ~= "table" then
            return error_2.new({
                error = error_3,
                kind = error_2.Kind.ExecutionError,
                trace = debug.traceback(tostring(error_3), 2),
                context = "Promise created at:\n\n" .. argument,
            })
        end

        return error_3
    end, ...))
end

local function create_advancer(argument, argument_2, argument_3, argument_4)
    return function() end
end

local function is_empty(argument)
    return next(argument) == nil
end

local promise = {}
promise.Error = error_2
promise.Status = make_enum("Promise.Status", { "Started", "Resolved", "Rejected", "Cancelled" })
promise._getTime = os.clock
promise._timeEvent = game:GetService("RunService").Heartbeat
promise._unhandledRejectionCallbacks = {}
promise.prototype = {}
promise.__index = promise.prototype

function promise._new(source, argument, parent)
    if parent ~= nil and not (promise.is(parent)) then
        error("Argument #2 to Promise.new must be a promise or nil", 2)
    end

    local values_2 = { _unhandledRejection = true, _valuesLength = -1 }
    values_2._source = source
    values_2._status = promise.Status.Started
    values_2._queuedResolve = {}
    values_2._queuedReject = {}
    values_2._queuedFinally = {}
    values_2._parent = parent
    values_2._consumers = setmetatable({}, metatable)

    if parent and parent._status == promise.Status.Started then
        parent._consumers[values_2] = true
    end

    setmetatable(values_2, promise)

    local function reject(...)
        values_2:_reject(...)
    end

    local function resolve(...)
        values_2:_resolve(...)
    end

    local function on_cancel(cancellation_hook)
        if cancellation_hook then
            if values_2._status ~= promise.Status.Cancelled then
                values_2._cancellationHook = cancellation_hook
            else
                cancellation_hook()
            end
        end

        return values_2._status == promise.Status.Cancelled
    end

    values_2._thread = coroutine.create(function()
        local result, _, value = run_executor(values_2._source, argument, resolve, reject, on_cancel)

        if result then
            return
        end

        reject(value[1])
    end)
    task.spawn(values_2._thread)

    return values_2
end

function promise.new(argument)
    return promise._new(debug.traceback(nil, 2), argument)
end

function promise.__tostring(argument)
    return string.format("Promise(%s)", argument._status)
end

function promise.defer(argument)
    local source = debug.traceback(nil, 2)

    return (
        promise._new(source, function(argument_2, callback, argument_3)
            local connection_3 = nil
            local connection_2 = promise._timeEvent:Connect(function()
                connection_3:Disconnect()
                local result, _, value = run_executor(source, argument, argument_2, callback, argument_3)

                if result then
                    return
                end

                callback(value[1])
            end)
            connection_3 = connection_2
        end)
    )
end

promise.async = promise.defer

local function pack(...)
    return select("#", ...), { ... }
end

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
        if not (promise.is(item)) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.all", tostring(key)), 3)
        end
    end

    if not (#argument ~= 0 and argument_2 ~= 0) then
        return promise.resolve({})
    end

    return promise._new(source, function(callback, callback_2, callback_3)
        local values_2 = {}
        local values_3 = {}
        local number = 0
        local number_2 = 0
        local enabled = false

        local function resolve_one(argument_3, ...)
            if enabled then
                return
            end

            number = number + 1

            if argument_2 ~= nil then
                local number_3 = number
                local value = ...
                values_2[number_3] = value
            else
                local value_2 = ...
                values_2[argument_3] = value_2
            end

            local number_4 = number

            if not ((argument_2 or #argument) <= number_4) then
                return
            end

            enabled = true
            callback(values_2)

            for _, item_4 in ipairs(values_3) do
                item_4:cancel()
            end
        end

        local function cancel()
            for _, item_4 in ipairs(values_3) do
                item_4:cancel()
            end
        end

        callback_3(cancel)

        for key_2, item_2 in ipairs(argument) do
            values_3[key_2] = item_2:andThen(function(...)
                resolve_one(key_2, ...)
            end, function(...)
                number_2 = number_2 + 1

                if not (argument_2 == nil or (#argument - number_2 < argument_2)) then
                    return
                end

                for _, item_4 in ipairs(values_3) do
                    item_4:cancel()
                end

                enabled = true
                callback_2(...)
            end)
        end

        if not enabled then
            return
        end

        for _, item_3 in ipairs(values_3) do
            item_3:cancel()
        end
    end)
end

function promise.all(argument)
    return promise._all(debug.traceback(nil, 2), argument)
end

function promise.fold(argument, callback, argument_2)
    local is_table = type(argument) == "table"
    assert(is_table, "Bad argument #1 to Promise.fold: must be a table")

    if type(callback) ~= "function" then
        local value = nil

        if type(callback) ~= "table" then
            is_table = false
        else
            value = getmetatable(callback)

            if value then
                if type(rawget(value, "__call")) ~= "function" then
                    is_table = false
                else
                    is_table = true
                end
            else
                is_table = false
            end
        end
    else
        is_table = true
    end

    assert(is_table, "Bad argument #2 to Promise.fold: must be a function")
    local resolve_result = promise.resolve(argument_2)
    is_table = promise.each(argument, function(argument_3, argument_4)
        local and_then_result = resolve_result:andThen(function(argument_5)
            return callback(argument_5, argument_3, argument_4)
        end)
        resolve_result = and_then_result
    end)
    local callback_2 = function()
        return resolve_result
    end

    return is_table:andThen(callback_2)
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
        if not (promise.is(item)) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.allSettled", tostring(key)), 2)
        end
    end

    if #argument == 0 then
        return promise.resolve({})
    end

    return promise._new(debug.traceback(nil, 2), function(callback, argument_2, callback_2)
        local values_2 = {}
        local values_3 = {}
        local number = 0

        local function resolve_one(argument_3, ...)
            number = number + 1
            local value = ...
            values_2[argument_3] = value

            if not (#argument <= number) then
                return
            end

            callback(values_2)
        end

        callback_2(function()
            for _, item_3 in ipairs(values_3) do
                item_3:cancel()
            end
        end)

        for key_2, item_2 in ipairs(argument) do
            values_3[key_2] = item_2:finally(function(...)
                resolve_one(key_2, ...)
            end)
        end
    end)
end

function promise.race(argument)
    local is_table = type(argument) == "table"
    assert(is_table, string.format("Please pass a list of promises to %s", "Promise.race"))

    for key, item in pairs(argument) do
        assert(
            promise.is(item),
            string.format("Non-promise value passed into %s at index %s", "Promise.race", tostring(key))
        )
    end

    return promise._new(debug.traceback(nil, 2), function(argument_2, callback, callback_2)
        local values_2 = {}
        local enabled = false

        local function cancel()
            for _, item_4 in ipairs(values_2) do
                item_4:cancel()
            end
        end

        local function finalize(argument_3)
            return function() end
        end

        if callback_2(function() end) then
            return
        end

        for index, item_2 in ipairs(argument) do
            values_2[index] = item_2:andThen(function() end, function(...)
                for _, item_4 in ipairs(values_2) do
                    item_4:cancel()
                end

                enabled = true

                return callback(...)
            end)
        end

        if enabled then
            for _, item_3 in ipairs(values_2) do
                item_3:cancel()
            end
        end
    end)
end

function promise.each(argument, callback)
    local is_table = type(argument) == "table"
    assert(is_table, string.format("Please pass a list of promises to %s", "Promise.each"))

    if type(callback) ~= "function" then
        local value = nil

        if type(callback) ~= "table" then
            is_table = false
        else
            value = getmetatable(callback)

            if value then
                if type(rawget(value, "__call")) ~= "function" then
                    is_table = false
                else
                    is_table = true
                end
            else
                is_table = false
            end
        end
    else
        is_table = true
    end

    assert(is_table, string.format("Please pass a handler function to %s!", "Promise.each"))

    return promise._new(debug.traceback(nil, 2), function(callback_2, callback_3, callback_4)
        local values_2 = {}
        local items = {}
        local enabled = false

        local function cancel()
            for _, item_8 in ipairs(items) do
                item_8:cancel()
            end
        end

        callback_4(function()
            enabled = true

            for _, item_8 in ipairs(items) do
                item_8:cancel()
            end
        end)

        local values_3 = {}

        for index, item in ipairs(argument) do
            if not (promise.is(item)) then
                values_3[index] = item
                continue
            end

            if item:getStatus() ~= promise.Status.Cancelled then
                if item:getStatus() ~= promise.Status.Rejected then
                    local and_then_result = item:andThen(function(...)
                        return ...
                    end)
                    table.insert(items, and_then_result)
                    values_3[index] = and_then_result
                    continue
                end

                for _, item_2 in ipairs(items) do
                    item_2:cancel()
                end

                return callback_3(select(2, item:await()))
            else
                for _, item_3 in ipairs(items) do
                    item_3:cancel()
                end

                local new = error_2.new
                local values_4 = { error = "Promise is cancelled" }
                values_4.kind = error_2.Kind.AlreadyCancelled
                values_4.context = string.format(
                    "The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s",
                    index,
                    item._source
                )

                return callback_3(new(values_4))
            end
        end

        local value_2, value_3 = nil, nil

        for index_2, item_4 in ipairs(values_3) do
            local is_result = promise.is(item_4)

            if is_result then
                local await_result, value_4 = item_4:await()

                if await_result then
                    item_4 = value_4

                    if enabled then
                        return
                    end

                    local resolve_result = promise.resolve(callback(item_4, index_2))
                    table.insert(items, resolve_result)
                    local await_result_2, value_5 = resolve_result:await()

                    if await_result_2 then
                        values_2[index_2] = value_5
                        continue
                    end

                    for _, item_5 in ipairs(items) do
                        item_5:cancel()
                    end

                    return callback_3(value_5)
                end

                for _, item_6 in ipairs(items) do
                    item_6:cancel()
                end

                return callback_3(value_4)
            else
                if enabled then
                    return
                end

                local resolve_result_2 = promise.resolve(callback(item_4, index_2))
                table.insert(items, resolve_result_2)
                local await_result_3, value_6 = resolve_result_2:await()

                if await_result_3 then
                    values_2[index_2] = value_6
                    continue
                end

                for _, item_7 in ipairs(items) do
                    item_7:cancel()
                end

                return callback_3(value_6)
            end
        end

        callback_2(values_2)
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

    local and_then

    if metatable_2 ~= nil then
        if type(metatable_2) == "table" and type(rawget(metatable_2, "__index")) == "table" then
            local rawget_result = rawget(rawget(metatable_2, "__index"), "andThen")
            local enabled

            if type(rawget_result) ~= "function" then
                local value = nil

                if type(rawget_result) ~= "table" then
                    enabled = false
                else
                    value = getmetatable(rawget_result)

                    if value then
                        if type(rawget(value, "__call")) ~= "function" then
                            enabled = false
                        else
                            enabled = true
                        end
                    else
                        enabled = false
                    end
                end
            else
                enabled = true
            end

            if enabled then
                return true
            end
        end

        return false
    end

    and_then = argument.andThen

    if type(and_then) == "function" then
        return true
    end

    if type(and_then) == "table" then
        local metatable_3 = getmetatable(and_then)

        if metatable_3 and type(rawget(metatable_3, "__call")) == "function" then
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

local next_2 = nil
local connection = nil

function promise.delay(number)
    local is_number = type(number) == "number"
    assert(is_number, "Bad argument #1 to Promise.delay, must be a number.")

    if not (number >= 0.016666666666666666) or number == math.huge then
        number = 0.016666666666666666
    end

    local source = debug.traceback(nil, 2)
    local callback = function(resolve, argument, callback_2)
        local start_time = promise._getTime()
        local end_time = start_time + number
        local next_4 = {}
        next_4.resolve = resolve
        next_4.startTime = start_time
        next_4.endTime = end_time

        if connection == nil then
            next_2 = next_4
            local connection_2 = promise._timeEvent:Connect(function()
                local get_time_result = promise._getTime()

                while v41 ~= nil and (v41.endTime < get_time_result) do
                    v41 = v41.next

                    if v41 ~= nil then
                        v41.previous = nil
                    else
                        connection:Disconnect()
                        connection = nil
                    end

                    v41.resolve(promise._getTime() - v41.startTime)
                end
            end)
            connection = connection_2
        elseif next_2.endTime < end_time then
            local next_5 = next_2
            local next_3 = next_5.next
            local previous = next_5

            while next_3 ~= nil do
                if next_3.endTime < end_time then
                    next_3 = next_3.next
                    continue
                else
                    break
                end
            end

            previous.next = next_4
            next_4.previous = previous

            if next_3 ~= nil then
                next_4.next = next_3
                next_3.previous = next_4
            end
        else
            next_4.next = next_2
            next_2.previous = next_4
            next_2 = next_4
        end

        callback_2(function()
            local next_6 = next_4.next

            if next_2 ~= next_4 then
                local previous_2 = next_4.previous
                previous_2.next = next_6

                if next_6 ~= nil then
                    next_6.previous = previous_2
                end
            else
                if next_6 ~= nil then
                    next_6.previous = nil
                else
                    connection:Disconnect()
                    connection = nil
                end

                next_2 = next_6
            end
        end)
    end

    return promise._new(source, callback)
end

function promise.prototype.timeout(argument, argument_2, argument_3)
    local traceback_result = debug.traceback(nil, 2)

    return promise.race({
        promise.delay(argument_2):andThen(function()
            local reject = promise.reject

            if argument_3 == nil then
                local _ = error_2.new({
                    error = "Timed out",
                    kind = error_2.Kind.TimedOut,
                    context = string.format(
                        "Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s",
                        argument_2,
                        traceback_result
                    ),
                })
            end

            return reject(argument_3)
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
        return promise._new(source, function(argument_3, argument_4, callback)
            local callback_2 = argument_3

            if argument then
                local _ = source
            end

            local callback_3 = argument_4

            if argument_2 then
            end

            if parent._status == promise.Status.Started then
                table.insert(parent._queuedResolve, callback_2)
                table.insert(parent._queuedReject, callback_3)

                callback(function()
                    if parent._status ~= promise.Status.Started then
                        return
                    end

                    table.remove(parent._queuedResolve, table.find(parent._queuedResolve, callback_2))
                    table.remove(parent._queuedReject, table.find(parent._queuedReject, callback_3))
                end)
            elseif parent._status == promise.Status.Resolved then
                callback_2(unpack(parent._values, 1, parent._valuesLength))
            elseif parent._status == promise.Status.Rejected then
                callback_3(unpack(parent._values, 1, parent._valuesLength))
            end
        end, parent)
    end

    local promise_2 = promise.new(function() end)
    promise_2:cancel()

    return promise_2
end

function promise.prototype.andThen(argument, argument_2, argument_3)
    local enabled = true

    if argument_2 ~= nil then
        if type(argument_2) ~= "function" then
            local value = nil

            if type(argument_2) ~= "table" then
                enabled = false
            else
                value = getmetatable(argument_2)

                if value then
                    if type(rawget(value, "__call")) ~= "function" then
                        enabled = false
                    else
                        enabled = true
                    end
                else
                    enabled = false
                end
            end
        else
            enabled = true
        end
    end

    assert(enabled, string.format("Please pass a handler function to %s!", "Promise:andThen"))
    enabled = true

    if argument_3 ~= nil then
        if type(argument_3) ~= "function" then
            local value_2 = nil

            if type(argument_3) ~= "table" then
                enabled = false
            else
                value_2 = getmetatable(argument_3)

                if value_2 then
                    if type(rawget(value_2, "__call")) ~= "function" then
                        enabled = false
                    else
                        enabled = true
                    end
                else
                    enabled = false
                end
            end
        else
            enabled = true
        end
    end

    assert(enabled, string.format("Please pass a handler function to %s!", "Promise:andThen"))

    return argument:_andThen(debug.traceback(nil, 2), argument_2, argument_3)
end

function promise.prototype.catch(argument, argument_2)
    local enabled = true

    if argument_2 ~= nil then
        if type(argument_2) ~= "function" then
            local value = nil

            if type(argument_2) ~= "table" then
                enabled = false
            else
                value = getmetatable(argument_2)

                if value then
                    if type(rawget(value, "__call")) ~= "function" then
                        enabled = false
                    else
                        enabled = true
                    end
                else
                    enabled = false
                end
            end
        else
            enabled = true
        end
    end

    assert(enabled, string.format("Please pass a handler function to %s!", "Promise:catch"))

    return argument:_andThen(debug.traceback(nil, 2), nil, argument_2)
end

function promise.prototype.tap(argument, callback)
    local enabled

    if type(callback) ~= "function" then
        local value = nil

        if type(callback) ~= "table" then
            enabled = false
        else
            value = getmetatable(callback)

            if value then
                if type(rawget(value, "__call")) ~= "function" then
                    enabled = false
                else
                    enabled = true
                end
            else
                enabled = false
            end
        end
    else
        enabled = true
    end

    assert(enabled, string.format("Please pass a handler function to %s!", "Promise:tap"))

    return argument:_andThen(debug.traceback(nil, 2), function(...)
        local result = callback(...)

        if not promise.is(result) then
            return ...
        end

        local result_2, value_2 = pack(...)

        return result:andThen(function()
            return unpack(value_2, 1, result_2)
        end)
    end)
end

function promise.prototype.andThenCall(argument, callback, ...)
    local enabled

    if type(callback) ~= "function" then
        local value = nil

        if type(callback) ~= "table" then
            enabled = false
        else
            value = getmetatable(callback)

            if value then
                if type(rawget(value, "__call")) ~= "function" then
                    enabled = false
                else
                    enabled = true
                end
            else
                enabled = false
            end
        end
    else
        enabled = true
    end

    assert(enabled, string.format("Please pass a handler function to %s!", "Promise:andThenCall"))
    local result, value_2 = pack(...)

    return argument:_andThen(debug.traceback(nil, 2), function()
        return callback(unpack(value_2, 1, result))
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

function promise.prototype._finally(argument, source, callback)
    argument._unhandledRejection = false

    return (
        promise._new(source, function(callback_2, callback_3, callback_4)
            local value = nil

            callback_4(function()
                argument:_consumerCancelled(argument)

                if not value then
                    return
                end

                value:cancel()
            end)

            local callback_5 = callback_2

            if callback then
                local callback_6 = function(...)
                    local result = callback(...)

                    if promise.is(result) then
                        value = result

                        result
                            :finally(function(argument_2)
                                if argument_2 == promise.Status.Rejected then
                                    return
                                end

                                callback_2(argument)
                            end)
                            :catch(function(...)
                                callback_3(...)
                            end)
                    else
                        callback_2(argument)
                    end
                end
                callback_5 = callback_6
            end

            if argument._status ~= promise.Status.Started then
                callback_5(argument._status)
            else
                table.insert(argument._queuedFinally, callback_5)
            end
        end)
    )
end

function promise.prototype.finally(argument, argument_2)
    local enabled = true

    if argument_2 ~= nil then
        if type(argument_2) ~= "function" then
            local value = nil

            if type(argument_2) ~= "table" then
                enabled = false
            else
                value = getmetatable(argument_2)

                if value then
                    if type(rawget(value, "__call")) ~= "function" then
                        enabled = false
                    else
                        enabled = true
                    end
                else
                    enabled = false
                end
            end
        else
            enabled = true
        end
    end

    assert(enabled, string.format("Please pass a handler function to %s!", "Promise:finally"))

    return argument:_finally(debug.traceback(nil, 2), argument_2)
end

function promise.prototype.finallyCall(argument, callback, ...)
    local enabled

    if type(callback) ~= "function" then
        local value = nil

        if type(callback) ~= "table" then
            enabled = false
        else
            value = getmetatable(callback)

            if value then
                if type(rawget(value, "__call")) ~= "function" then
                    enabled = false
                else
                    enabled = true
                end
            else
                enabled = false
            end
        end
    else
        enabled = true
    end

    assert(enabled, string.format("Please pass a handler function to %s!", "Promise:finallyCall"))
    local result, value_2 = pack(...)

    return argument:_finally(debug.traceback(nil, 2), function()
        return callback(unpack(value_2, 1, result))
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

    if argument._status ~= promise.Status.Resolved and argument._status ~= promise.Status.Rejected then
        return argument._status
    end

    return argument._status, unpack(argument._values, 1, argument._valuesLength)
end

local function await_helper(argument, ...)
    return argument == promise.Status.Resolved, ...
end

function promise.prototype.await(argument)
    return await_helper(argument:awaitStatus())
end

local function expect_helper(argument, ...)
    if argument ~= promise.Status.Resolved then
        local value = ...
        local text = ((value == nil) and "Expected Promise rejected with no value.") or (...)
        error(text, 3)
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
    if argument._status == promise.Status.Started then
        local value = ...
        local parent = nil

        if promise.is(value) then
            if select("#", ...) > 1 then
                warn(
                    (
                        string.format(
                            "When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s",
                            argument._source
                        )
                    )
                )
            end

            local value_2 = ...
            parent = value_2:andThen(function(...)
                argument:_resolve(...)
            end, function(...)
                local value_entry = value_2._values[1]

                if value_2._error then
                    value_entry = error_2.new({
                        context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]",
                        error = value_2._error,
                        kind = error_2.Kind.ExecutionError,
                    })
                end

                if error_2.isKind(value_entry, error_2.Kind.ExecutionError) then
                    return argument:_reject(value_entry:extend({
                        trace = "",
                        error = "This Promise was chained to a Promise that errored.",
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
            elseif parent._status == promise.Status.Started then
                argument._parent = parent
                parent._consumers[argument] = true
            end
        else
            argument._status = promise.Status.Resolved
            local values_length, values_2 = pack(...)
            argument._valuesLength = values_length
            argument._values = values_2

            for _, item in ipairs(argument._queuedResolve) do
                coroutine.wrap(item)(...)
            end

            argument:_finalize()
        end
    else
        local value_3 = ...

        if promise.is(value_3) then
            local value_4 = ...
            value_4:_consumerCancelled(argument)
        end
    end
end

function promise.prototype._reject(argument, ...)
    if argument._status ~= promise.Status.Started then
        return
    end

    argument._status = promise.Status.Rejected
    local values_length, values_2 = pack(...)
    argument._valuesLength = values_length
    argument._values = values_2

    if next(argument._queuedReject) == nil then
        local value = ...
        local str = tostring(value)
        coroutine.wrap(function()
            promise._timeEvent:Wait()

            if not argument._unhandledRejection then
                return
            end

            local formatted_text = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", str, argument._source)

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

function promise.prototype.now(argument, argument_2)
    local traceback_result = debug.traceback(nil, 2)

    if argument._status == promise.Status.Resolved then
        return argument:_andThen(traceback_result, function(...)
            return ...
        end)
    end

    local reject = promise.reject
    local argument_3

    if argument_2 ~= nil then
        argument_3 = argument_2
    else
        argument_3 = error_2.new({
            error = "This Promise was not resolved in time for :now()",
            kind = error_2.Kind.NotResolvedInTime,
            context = ":now() was called at:\n\n" .. traceback_result,
        }) or argument_2
    end

    return reject(argument_3)
end

function promise.retry(callback, argument, ...)
    local enabled

    if type(callback) ~= "function" then
        local value = nil

        if type(callback) ~= "table" then
            enabled = false
        else
            value = getmetatable(callback)

            if value then
                if type(rawget(value, "__call")) ~= "function" then
                    enabled = false
                else
                    enabled = true
                end
            else
                enabled = false
            end
        end
    else
        enabled = true
    end

    assert(enabled, "Parameter #1 to Promise.retry must be a function")
    enabled = type(argument) == "number"
    assert(enabled, "Parameter #2 to Promise.retry must be a number")
    local values_2 = { ... }
    local select_result = select("#", ...)

    return promise.resolve(callback(...)):catch(function(...)
        if argument > 0 then
            return promise.retry(callback, argument - 1, unpack(values_2, 1, select_result))
        end

        return promise.reject(...)
    end)
end

function promise.retryWithDelay(callback, argument, argument_2, ...)
    local enabled

    if type(callback) ~= "function" then
        local value = nil

        if type(callback) ~= "table" then
            enabled = false
        else
            value = getmetatable(callback)

            if value then
                if type(rawget(value, "__call")) ~= "function" then
                    enabled = false
                else
                    enabled = true
                end
            else
                enabled = false
            end
        end
    else
        enabled = true
    end

    assert(enabled, "Parameter #1 to Promise.retry must be a function")
    enabled = type(argument) == "number"
    assert(enabled, "Parameter #2 (times) to Promise.retry must be a number")
    enabled = type(argument_2) == "number"
    assert(enabled, "Parameter #3 (seconds) to Promise.retry must be a number")
    local values_2 = { ... }
    local select_result = select("#", ...)

    return promise.resolve(callback(...)):catch(function(...)
        if argument > 0 then
            promise.delay(argument_2):await()

            return promise.retryWithDelay(callback, argument - 1, argument_2, unpack(values_2, 1, select_result))
        end

        return promise.reject(...)
    end)
end

function promise.fromEvent(signal, callback)
    local callback_2 = callback or function()
        return true
    end
    callback = callback_2
    local source = debug.traceback(nil, 2)
    local callback_3 = function(callback_4, argument, callback_5)
        local connection_3 = nil
        local enabled = false

        local function disconnect()
            connection_3:Disconnect()
            connection_3 = nil
        end

        local connection_2 = signal:Connect(function(...)
            local enabled_2 = callback(...)

            if enabled_2 == true then
                callback_4(...)

                if connection_3 then
                    connection_3:Disconnect()
                    connection_3 = nil
                else
                    enabled = true
                end
            elseif type(enabled_2) ~= "boolean" then
                error("Promise.fromEvent predicate should always return a boolean")
            end
        end)
        connection_3 = connection_2

        if enabled and connection_3 then
            return disconnect()
        end

        callback_5(disconnect)
    end

    return promise._new(source, callback_3)
end

function promise.onUnhandledRejection(argument)
    table.insert(promise._unhandledRejectionCallbacks, argument)

    return function()
        local match_index = table.find(promise._unhandledRejectionCallbacks, argument)

        if not match_index then
            return
        end

        table.remove(promise._unhandledRejectionCallbacks, match_index)
    end
end

return promise
