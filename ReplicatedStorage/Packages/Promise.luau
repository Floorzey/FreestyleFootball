--[[
    Script Path: Game/ReplicatedStorage/Packages/Promise
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local tbl_upv_1 = {__mode = "k"}
local function isCallable(a1)
    --[[
      name: isCallable
      line: 10
    ]]
    if type(a1) ~= "function" then
        if type(a1) == "table" then
            local metatable_1 = getmetatable(a1)
            if metatable_1 and type(rawget(metatable_1, "__call")) == "function" then
                return true
            end
        end
        return false
    end
    return true
end
local tbl_2 = {}
local function makeEnum(a1, a2)
    --[[
      name: makeEnum
      line: 28
    ]]
    local tbl_3 = {}
    for _, value_1 in ipairs(a2) do
        tbl_3[value_1] = value_1
    end
    local tbl_4 = {}
    function tbl_4.__index(a3, a4)
        --[[
          name: __index
          line: 36
          upvalues:
            a1 (copy, index: 1)
        ]]
        error(string.format("%s is not in %s!", a4, a1), 2)
    end
    function tbl_4.__newindex()
        --[[
          name: __newindex
          line: 39
          upvalues:
            a1 (copy, index: 1)
        ]]
        error(string.format("Creating new members in %s is not allowed!", a1), 2)
    end
    return (setmetatable(tbl_3, tbl_4))
end
tbl_2.Kind = makeEnum("Promise.Error.Kind", {"ExecutionError", "AlreadyCancelled", "NotResolvedInTime", "TimedOut"})
local u1 = tbl_2
u1.__index = u1
function u1.new(a1, a2)
    --[[
      name: new
      line: 64
      upvalues:
        u1 (ref, index: 1)
    ]]
    a1 = a1 or {}
    return (setmetatable({error = tostring(a1.error) or "[This error has no error text.]", trace = a1.trace, context = a1.context, kind = a1.kind, parent = a2, createdTick = os.clock(), createdTrace = debug.traceback()}, u1))
end
function u1.is(a1)
    --[[
      name: is
      line: 77
    ]]
    if type(a1) == "table" then
        local metatable_2 = getmetatable(a1)
        if type(metatable_2) == "table" then
            local v1 = (rawget(a1, "error") ~= nil) and (type(rawget(metatable_2, "extend")) == "function")
            return v1
        end
    end
    return false
end
function u1.isKind(a1, a2)
    --[[
      name: isKind
      line: 89
      upvalues:
        u1 (ref, index: 1)
    ]]
    assert(a2 ~= nil, "Argument #2 to Promise.Error.isKind must not be nil")
    local v2 = u1.is(a1) and (a1.kind == a2)
    return v2
end
function u1.extend(a1, a2)
    --[[
      name: extend
      line: 95
      upvalues:
        u1 (ref, index: 1)
    ]]
    local v3 = a2 or {}
    v3.kind = v3.kind or (a1.kind)
    return u1.new(v3, a1)
end
function u1.getErrorChain(a1)
    --[[
      name: getErrorChain
      line: 103
    ]]
    local tbl_5 = {a1}
    while tbl_5[#tbl_5].parent do
        table.insert(tbl_5, tbl_5[#tbl_5].parent)
    end
    return tbl_5
end
function u1.__tostring(a1)
    --[[
      name: __tostring
      line: 113
    ]]
    local tbl_6 = {string.format("-- Promise.Error(%s) --", a1.kind or "?")}
    for _, value_2 in ipairs(a1:getErrorChain()) do
        local tbl_7 = {}
        tbl_7[1], tbl_7[2] = value_2.trace or (value_2.error), value_2.context
        table.insert(tbl_6, table.concat(tbl_7, "\n"))
    end
    return table.concat(tbl_6, "\n")
end
local function packResult(a1, ...)
    --[[
      name: packResult
      line: 144
    ]]
    return a1, select("#", ...), {...}
end
local function makeErrorHandler(a1)
    --[[
      name: makeErrorHandler
      line: 148
    ]]
    assert(a1 ~= nil, "traceback is nil")
    return function() end
end
local function runExecutor(a1, a2, ...)
    --[[
      name: runExecutor
      line: 171
      upvalues:
        packResult (copy, index: 1)
        u1 (ref,  index: 2)
    ]]
    assert(a1 ~= nil, "traceback is nil")
    return packResult(
        xpcall(
            a2,
            function(a3)
                --[[
                  line: 151
                  upvalues:
                    u1 (ref,  index: 1)
                    a1 (copy, index: 2)
                ]]
                if type(a3) ~= "table" then
                    return u1.new({error = a3, kind = u1.Kind.ExecutionError, trace = debug.traceback(tostring(a3), 2), context = "Promise created at:\n\n" .. a1})
                end
                return a3
            end,
            ...
        )
    )
end
local function createAdvancer(a1, a2, a3, a4)
    --[[
      name: createAdvancer
      line: 179
    ]]
    return function() end
end
local function isEmpty(a1)
    --[[
      name: isEmpty
      line: 191
    ]]
    local v4 = next(a1) == nil
    return v4
end
local tbl_upv_8 = {}
tbl_upv_8.Error = u1
tbl_upv_8.Status = makeEnum("Promise.Status", {"Started", "Resolved", "Rejected", "Cancelled"})
tbl_upv_8._getTime = os.clock
tbl_upv_8._timeEvent = game:GetService("RunService").Heartbeat
tbl_upv_8._unhandledRejectionCallbacks = {}
tbl_upv_8.prototype = {}
tbl_upv_8.__index = tbl_upv_8.prototype
function tbl_upv_8._new(a1, a2, a3)
    --[[
      name: _new
      line: 230
      upvalues:
        tbl_upv_8 (copy, index: 1)
        tbl_upv_1 (copy, index: 2)
        runExecutor (copy, index: 3)
    ]]
    if a3 ~= nil and not (tbl_upv_8.is(a3)) then
        error("Argument #2 to Promise.new must be a promise or nil", 2)
    end
    local tbl_upv_9 = {_unhandledRejection = true, _valuesLength = -1}
    tbl_upv_9._source = a1
    tbl_upv_9._status = tbl_upv_8.Status.Started
    tbl_upv_9._queuedResolve = {}
    tbl_upv_9._queuedReject = {}
    tbl_upv_9._queuedFinally = {}
    tbl_upv_9._parent = a3
    tbl_upv_9._consumers = setmetatable({}, tbl_upv_1)
    if a3 and a3._status == tbl_upv_8.Status.Started then
        a3._consumers[tbl_upv_9] = true
    end
    setmetatable(tbl_upv_9, tbl_upv_8)
    local function reject(...)
        --[[
          name: reject
          line: 282
          upvalues:
            tbl_upv_9 (copy, index: 1)
        ]]
        tbl_upv_9:_reject(...)
    end
    local function resolve(...)
        --[[
          name: resolve
          line: 278
          upvalues:
            tbl_upv_9 (copy, index: 1)
        ]]
        tbl_upv_9:_resolve(...)
    end
    local function onCancel(a4)
        --[[
          name: onCancel
          line: 286
          upvalues:
            tbl_upv_9 (copy, index: 1)
            tbl_upv_8 (copy, index: 2)
        ]]
        if a4 then
            if tbl_upv_9._status ~= tbl_upv_8.Status.Cancelled then
                tbl_upv_9._cancellationHook = a4
            else
                a4()
            end
        end
        return tbl_upv_9._status == tbl_upv_8.Status.Cancelled
    end
    tbl_upv_9._thread = coroutine.create(
        function()
            --[[
              line: 298
              upvalues:
                runExecutor (copy, index: 1)
                tbl_upv_9 (copy, index: 2)
                a2 (copy, index: 3)
                resolve (copy, index: 4)
                reject (copy, index: 5)
                onCancel (copy, index: 6)
            ]]
            local v5, _, v6 = runExecutor(tbl_upv_9._source, a2, resolve, reject, onCancel)
            if (v5) then
                return
            end
            reject(v6[1])
        end
    )
    task.spawn(tbl_upv_9._thread)
    return tbl_upv_9
end
function tbl_upv_8.new(a1)
    --[[
      name: new
      line: 349
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    return tbl_upv_8._new(debug.traceback(nil, 2), a1)
end
function tbl_upv_8.__tostring(a1)
    --[[
      name: __tostring
      line: 353
    ]]
    return string.format("Promise(%s)", a1._status)
end
function tbl_upv_8.defer(a1)
    --[[
      name: defer
      line: 375
      upvalues:
        tbl_upv_8 (copy, index: 1)
        runExecutor (copy, index: 2)
    ]]
    local u2 = debug.traceback(nil, 2)
    return (tbl_upv_8._new(
        u2,
        function(a2, a3, a4)
            --[[
              line: 378
              upvalues:
                tbl_upv_8 (copy, index: 1)
                runExecutor (copy, index: 2)
                u2 (copy, index: 3)
                a1 (copy, index: 4)
            ]]
            local u3 = nil
            local v7 = tbl_upv_8._timeEvent:Connect(
                function()
                    --[[
                      line: 380
                      upvalues:
                        u3 (ref,  index: 1)
                        runExecutor (copy, index: 2)
                        u2 (copy, index: 3)
                        a1 (copy, index: 4)
                        a2 (copy, index: 5)
                        a3 (copy, index: 6)
                        a4 (copy, index: 7)
                    ]]
                    u3:Disconnect()
                    local v8, _, v9 = runExecutor(u2, a1, a2, a3, a4)
                    if (v8) then
                        return
                    end
                    a3(v9[1])
                end
            )
            u3 = v7
        end
    ))
end
tbl_upv_8.async = tbl_upv_8.defer
local function pack(...)
    --[[
      name: pack
      line: 137
    ]]
    return select("#", ...), {...}
end
function tbl_upv_8.resolve(...)
    --[[
      name: resolve
      line: 418
      upvalues:
        pack (copy, index: 1)
        tbl_upv_8 (copy, index: 2)
    ]]
    local u4, u5 = pack(...)
    return tbl_upv_8._new(
        debug.traceback(nil, 2),
        function(a1)
            --[[
              line: 420
              upvalues:
                u5 (copy, index: 1)
                u4 (copy, index: 2)
            ]]
            a1(unpack(u5, 1, u4))
        end
    )
end
function tbl_upv_8.reject(...)
    --[[
      name: reject
      line: 435
      upvalues:
        pack (copy, index: 1)
        tbl_upv_8 (copy, index: 2)
    ]]
    local u6, u7 = pack(...)
    return tbl_upv_8._new(
        debug.traceback(nil, 2),
        function(a1, a2)
            --[[
              line: 437
              upvalues:
                u7 (copy, index: 1)
                u6 (copy, index: 2)
            ]]
            a2(unpack(u7, 1, u6))
        end
    )
end
function tbl_upv_8._try(a1, a2, ...)
    --[[
      name: _try
      line: 446
      upvalues:
        pack (copy, index: 1)
        tbl_upv_8 (copy, index: 2)
    ]]
    local u8, u9 = pack(...)
    return tbl_upv_8._new(
        a1,
        function(a3)
            --[[
              line: 449
              upvalues:
                a2 (copy, index: 1)
                u9 (copy, index: 2)
                u8 (copy, index: 3)
            ]]
            a3(a2(unpack(u9, 1, u8)))
        end
    )
end
function tbl_upv_8.try(a1, ...)
    --[[
      name: try
      line: 477
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    return tbl_upv_8._try(debug.traceback(nil, 2), a1, ...)
end
function tbl_upv_8._all(a1, a2, a3)
    --[[
      name: _all
      line: 486
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    if type(a2) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.all"), 3)
    end
    for key_1, value_3 in pairs(a2) do
        if not (tbl_upv_8.is(value_3)) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.all", tostring(key_1)), 3)
        end
    end
    if #a2 ~= 0 and a3 ~= 0 then
        return tbl_upv_8._new(
            a1,
            function(a4, a5, a6)
                --[[
                  line: 504
                  upvalues:
                    a3 (copy, index: 1)
                    a2 (copy, index: 2)
                ]]
                local tbl_upv_10 = {}
                local tbl_upv_11 = {}
                local u10 = 0
                local u11 = 0
                local u12 = false
                local function resolveOne(a7, ...)
                    --[[
                      name: resolveOne
                      line: 522
                      upvalues:
                        u12 (ref,  index: 1)
                        u10 (ref,  index: 2)
                        a3 (copy, index: 3)
                        tbl_upv_10 (copy, index: 4)
                        a2 (copy, index: 5)
                        a4 (copy, index: 6)
                        tbl_upv_11 (copy, index: 7)
                    ]]
                    if u12 then
                        return
                    end
                    u10 = u10 + 1
                    if a3 ~= nil then
                        local v10 = u10
                        local v11 = ...
                        tbl_upv_10[v10] = v11
                    else
                        local v12 = ...
                        tbl_upv_10[a7] = v12
                    end
                    local v13 = u10
                    if not ((a3 or (#a2)) <= v13) then
                        return
                    end
                    u12 = true
                    a4(tbl_upv_10)
                    for _, value_4 in ipairs(tbl_upv_11) do
                        value_4:cancel()
                    end
                end
                local function cancel()
                    --[[
                      name: cancel
                      line: 515
                      upvalues:
                        tbl_upv_11 (copy, index: 1)
                    ]]
                    for _, value_5 in ipairs(tbl_upv_11) do
                        value_5:cancel()
                    end
                end
                a6(cancel)
                for key_upv_2, value_6 in ipairs(a2) do
                    tbl_upv_11[key_upv_2] = value_6:andThen(
                        function(...)
                            --[[
                              line: 547
                              upvalues:
                                resolveOne (copy, index: 1)
                                key_upv_2 (copy, index: 2)
                            ]]
                            resolveOne(key_upv_2, ...)
                        end,
                        function(...)
                            --[[
                              line: 549
                              upvalues:
                                u11 (ref,  index: 1)
                                a3 (copy, index: 2)
                                a2 (copy, index: 3)
                                tbl_upv_11 (copy, index: 4)
                                u12 (ref,  index: 5)
                                a5 (copy, index: 6)
                            ]]
                            u11 = u11 + 1
                            if a3 == nil or (#a2 - u11 < a3) then
                                for _, value_7 in ipairs(tbl_upv_11) do
                                    value_7:cancel()
                                end
                                u12 = true
                                a5(...)
                            end
                        end
                    )
                end
                if not u12 then
                    return
                end
                for _, value_8 in ipairs(tbl_upv_11) do
                    value_8:cancel()
                end
            end
        )
    end
    return tbl_upv_8.resolve({})
end
function tbl_upv_8.all(a1)
    --[[
      name: all
      line: 591
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    return tbl_upv_8._all(debug.traceback(nil, 2), a1)
end
function tbl_upv_8.fold(a1, a2, a3)
    --[[
      name: fold
      line: 620
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    local v14 = type(a1) == "table"
    assert(v14, "Bad argument #1 to Promise.fold: must be a table")
    if type(a2) ~= "function" then
        local v15 = nil
        if type(a2) ~= "table" then
            v14 = false
        else
            v15 = getmetatable(a2)
            if v15 then
                if type(rawget(v15, "__call")) ~= "function" then
                    v14 = false
                else
                    v14 = true
                end
            else
                v14 = false
            end
        end
    else
        v14 = true
    end
    assert(v14, "Bad argument #2 to Promise.fold: must be a function")
    local u13 = tbl_upv_8.resolve(a3)
    v14 = tbl_upv_8.each(
        a1,
        function(a4, a5)
            --[[
              line: 625
              upvalues:
                u13 (ref,  index: 1)
                a2 (copy, index: 2)
            ]]
            local v16 = u13:andThen(
                function(a6)
                    --[[
                      line: 626
                      upvalues:
                        a2 (copy, index: 1)
                        a4 (copy, index: 2)
                        a5 (copy, index: 3)
                    ]]
                    return a2(a6, a4, a5)
                end
            )
            u13 = v16
        end
    )
    local v17 = function()
        --[[
          line: 629
          upvalues:
            u13 (ref, index: 1)
        ]]
        return u13
    end
    return v14:andThen(v17)
end
function tbl_upv_8.some(a1, a2)
    --[[
      name: some
      line: 653
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    local v18 = type(a2) == "number"
    assert(v18, "Bad argument #2 to Promise.some: must be a number")
    return tbl_upv_8._all(debug.traceback(nil, 2), a1, a2)
end
function tbl_upv_8.any(a1)
    --[[
      name: any
      line: 677
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    return tbl_upv_8._all(debug.traceback(nil, 2), a1, 1):andThen(
        function(a2)
            --[[
              line: 678
            ]]
            return a2[1]
        end
    )
end
function tbl_upv_8.allSettled(a1)
    --[[
      name: allSettled
      line: 699
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    if type(a1) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.allSettled"), 2)
    end
    for key_3, value_9 in pairs(a1) do
        if not (tbl_upv_8.is(value_9)) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.allSettled", tostring(key_3)), 2)
        end
    end
    if #a1 ~= 0 then
        return tbl_upv_8._new(
            debug.traceback(nil, 2),
            function(a2, a3, a4)
                --[[
                  line: 717
                  upvalues:
                    a1 (copy, index: 1)
                ]]
                local tbl_upv_12 = {}
                local tbl_upv_13 = {}
                local u14 = 0
                local function resolveOne_2(a5, ...)
                    --[[
                      name: resolveOne
                      line: 727
                      upvalues:
                        u14 (ref,  index: 1)
                        tbl_upv_12 (copy, index: 2)
                        a1 (copy, index: 3)
                        a2 (copy, index: 4)
                    ]]
                    u14 = u14 + 1
                    local v19 = ...
                    tbl_upv_12[a5] = v19
                    if not (#a1 <= u14) then
                        return
                    end
                    a2(tbl_upv_12)
                end
                a4(
                    function()
                        --[[
                          line: 737
                          upvalues:
                            tbl_upv_13 (copy, index: 1)
                        ]]
                        for _, value_10 in ipairs(tbl_upv_13) do
                            value_10:cancel()
                        end
                    end
                )
                for key_upv_4, value_11 in ipairs(a1) do
                    tbl_upv_13[key_upv_4] = value_11:finally(
                        function(...)
                            --[[
                              line: 746
                              upvalues:
                                resolveOne_2 (copy, index: 1)
                                key_upv_4 (copy, index: 2)
                            ]]
                            resolveOne_2(key_upv_4, ...)
                        end
                    )
                end
            end
        )
    end
    return tbl_upv_8.resolve({})
end
function tbl_upv_8.race(a1)
    --[[
      name: race
      line: 777
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    local v20 = type(a1) == "table"
    assert(v20, string.format("Please pass a list of promises to %s", "Promise.race"))
    for key_5, value_12 in pairs(a1) do
        assert(tbl_upv_8.is(value_12), string.format("Non-promise value passed into %s at index %s", "Promise.race", tostring(key_5)))
    end
    return tbl_upv_8._new(
        debug.traceback(nil, 2),
        function(a2, a3, a4)
            --[[
              line: 784
              upvalues:
                a1 (copy, index: 1)
            ]]
            local tbl_upv_14 = {}
            local u15 = false
            local function cancel_2()
                --[[
                  name: cancel
                  line: 788
                  upvalues:
                    tbl_upv_14 (copy, index: 1)
                ]]
                for _, value_13 in ipairs(tbl_upv_14) do
                    value_13:cancel()
                end
            end
            local function finalize(a5)
                --[[
                  name: finalize
                  line: 794
                ]]
                return function() end
            end
            if a4(function() end) then
                return
            end
            for key_6, value_14 in ipairs(a1) do
                tbl_upv_14[key_6] = value_14:andThen(
                    function() end,
                    function(...)
                        --[[
                          line: 795
                          upvalues:
                            tbl_upv_14 (copy, index: 1)
                            u15 (ref,  index: 2)
                            a3 (copy, index: 3)
                        ]]
                        for _, value_15 in ipairs(tbl_upv_14) do
                            value_15:cancel()
                        end
                        u15 = true
                        return a3(...)
                    end
                )
            end
            if u15 then
                for _, value_16 in ipairs(tbl_upv_14) do
                    value_16:cancel()
                end
            end
        end
    )
end
function tbl_upv_8.each(a1, a2)
    --[[
      name: each
      line: 872
      upvalues:
        tbl_upv_8 (copy, index: 1)
        u1 (ref,  index: 2)
    ]]
    local v21 = type(a1) == "table"
    assert(v21, string.format("Please pass a list of promises to %s", "Promise.each"))
    if type(a2) ~= "function" then
        local v22 = nil
        if type(a2) ~= "table" then
            v21 = false
        else
            v22 = getmetatable(a2)
            if v22 then
                if type(rawget(v22, "__call")) ~= "function" then
                    v21 = false
                else
                    v21 = true
                end
            else
                v21 = false
            end
        end
    else
        v21 = true
    end
    assert(v21, string.format("Please pass a handler function to %s!", "Promise.each"))
    return tbl_upv_8._new(
        debug.traceback(nil, 2),
        function(a3, a4, a5)
            --[[
              line: 876
              upvalues:
                a1 (copy, index: 1)
                tbl_upv_8 (copy, index: 2)
                u1 (ref,  index: 3)
                a2 (copy, index: 4)
            ]]
            local tbl_15 = {}
            local tbl_upv_16 = {}
            local u16 = false
            local function cancel_3()
                --[[
                  name: cancel
                  line: 882
                  upvalues:
                    tbl_upv_16 (copy, index: 1)
                ]]
                for _, value_17 in ipairs(tbl_upv_16) do
                    value_17:cancel()
                end
            end
            a5(
                function()
                    --[[
                      line: 888
                      upvalues:
                        u16 (ref,  index: 1)
                        tbl_upv_16 (copy, index: 2)
                    ]]
                    u16 = true
                    for _, value_18 in ipairs(tbl_upv_16) do
                        value_18:cancel()
                    end
                end
            )
            local tbl_17 = {}
            for key_7, value_19 in ipairs(a1) do
                if not (tbl_upv_8.is(value_19)) then
                    tbl_17[key_7] = value_19
                    continue
                end
                if value_19:getStatus() ~= tbl_upv_8.Status.Cancelled then
                    if value_19:getStatus() ~= tbl_upv_8.Status.Rejected then
                        local v23 = value_19:andThen(
                            function(...)
                                --[[
                                  line: 921
                                ]]
                                return ...
                            end
                        )
                        table.insert(tbl_upv_16, v23)
                        tbl_17[key_7] = v23
                        continue
                    end
                    for _, value_20 in ipairs(tbl_upv_16) do
                        value_20:cancel()
                    end
                    return a4(select(2, value_19:await()))
                else
                    for _, value_21 in ipairs(tbl_upv_16) do
                        value_21:cancel()
                    end
                    local new_1 = u1.new
                    local tbl_18 = {error = "Promise is cancelled"}
                    tbl_18.kind = u1.Kind.AlreadyCancelled
                    tbl_18.context = string.format("The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s", key_7, value_19._source)
                    return a4(new_1(tbl_18))
                end
            end
            local v24, v25 = nil, nil
            for key_8, v26 in ipairs(tbl_17) do
                local v27 = tbl_upv_8.is(v26)
                if v27 then
                    local v28, v24 = v26:await()
                    if v28 then
                        v26 = v24
                        if u16 then
                            return
                        end
                        local v29 = tbl_upv_8.resolve(a2(v26, key_8))
                        table.insert(tbl_upv_16, v29)
                        local v30, v25 = v29:await()
                        if v30 then
                            tbl_15[key_8] = v25
                            continue
                        end
                        for _, value_22 in ipairs(tbl_upv_16) do
                            value_22:cancel()
                        end
                        return a4(v25)
                    end
                    for _, value_23 in ipairs(tbl_upv_16) do
                        value_23:cancel()
                    end
                    return a4(v24)
                else
                    if u16 then
                        return
                    end
                    local v29 = tbl_upv_8.resolve(a2(v26, key_8))
                    table.insert(tbl_upv_16, v29)
                    local v30, v25 = v29:await()
                    if v30 then
                        tbl_15[key_8] = v25
                        continue
                    end
                    for _, value_22 in ipairs(tbl_upv_16) do
                        value_22:cancel()
                    end
                    return a4(v25)
                end
            end
            a3(tbl_15)
        end
    )
end
function tbl_upv_8.is(a1)
    --[[
      name: is
      line: 971
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    if type(a1) ~= "table" then
        return false
    end
    local metatable_3 = getmetatable(a1)
    if metatable_3 ~= tbl_upv_8 then
        local v31
        if metatable_3 ~= nil then
            if type(metatable_3) == "table" and type(rawget(metatable_3, "__index")) == "table" then
                local value_24 = rawget(rawget(metatable_3, "__index"), "andThen")
                local v32
                if type(value_24) ~= "function" then
                    local v33 = nil
                    if type(value_24) ~= "table" then
                        v32 = false
                    else
                        v33 = getmetatable(value_24)
                        if v33 then
                            if type(rawget(v33, "__call")) ~= "function" then
                                v32 = false
                            else
                                v32 = true
                            end
                        else
                            v32 = false
                        end
                    end
                else
                    v32 = true
                end
                if v32 then
                    return true
                end
            end
            return false
        end
        v31 = a1.andThen
        if type(v31) ~= "function" then
            if type(v31) == "table" then
                local metatable_4 = getmetatable(v31)
                if metatable_4 and type(rawget(metatable_4, "__call")) == "function" then
                    return true
                end
            end
            return false
        end
    end
    return true
end
function tbl_upv_8.promisify(a1)
    --[[
      name: promisify
      line: 1020
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    return function(...)
        --[[
          line: 1021
          upvalues:
            tbl_upv_8 (copy, index: 1)
            a1 (copy, index: 2)
        ]]
        return tbl_upv_8._try(debug.traceback(nil, 2), a1, ...)
    end
end
local u17 = nil
local u18 = nil
function tbl_upv_8.delay(a1)
    --[[
      name: delay
      line: 1051
      upvalues:
        tbl_upv_8 (copy, index: 1)
        u18 (ref,  index: 2)
        u17 (ref,  index: 3)
    ]]
    local v34 = type(a1) == "number"
    assert(v34, "Bad argument #1 to Promise.delay, must be a number.")
    if not (a1 >= 0.016666666666666666) or a1 == math.huge then
        a1 = 0.016666666666666666
    end
    local v35 = debug.traceback(nil, 2)
    local v36 = function(a2, a3, a4)
        --[[
          line: 1059
          upvalues:
            tbl_upv_8 (copy, index: 1)
            a1 (ref,  index: 2)
            u18 (ref,  index: 3)
            u17 (ref,  index: 4)
        ]]
        local v37 = tbl_upv_8._getTime()
        local v38 = v37 + a1
        local tbl_upv_19 = {}
        tbl_upv_19.resolve = a2
        tbl_upv_19.startTime = v37
        tbl_upv_19.endTime = v38
        if u18 == nil then
            u17 = tbl_upv_19
            local v39 = tbl_upv_8._timeEvent:Connect(
                function()
                    --[[
                      line: 1071
                      upvalues:
                        tbl_upv_8 (copy, index: 1)
                        u18 (ref,  index: 3)
                    ]]
                    local v40 = tbl_upv_8._getTime()
                    while v41 ~= nil and (v41.endTime < v40) do
                        v41 = v41.next
                        if v41 ~= nil then
                            v41.previous = nil
                        else
                            u18:Disconnect()
                            u18 = nil
                        end
                        v41.resolve(tbl_upv_8._getTime() - v41.startTime)
                    end
                end
            )
            u18 = v39
        elseif u17.endTime < v38 then
            local v42 = u17
            local next_1 = v42.next
            local v43 = v42
            while next_1 ~= nil do
                if next_1.endTime < v38 then
                    next_1 = next_1.next
                    continue
                else
                    break
                end
            end
            v43.next = tbl_upv_19
            tbl_upv_19.previous = v43
            if next_1 ~= nil then
                tbl_upv_19.next = next_1
                next_1.previous = tbl_upv_19
            end
        else
            tbl_upv_19.next = u17
            u17.previous = tbl_upv_19
            u17 = tbl_upv_19
        end
        a4(
            function()
                --[[
                  line: 1116
                  upvalues:
                    tbl_upv_19 (copy, index: 1)
                    u17 (ref,  index: 2)
                    u18 (ref,  index: 3)
                ]]
                local next_2 = tbl_upv_19.next
                if u17 ~= tbl_upv_19 then
                    local previous_1 = tbl_upv_19.previous
                    previous_1.next = next_2
                    if next_2 ~= nil then
                        next_2.previous = previous_1
                    end
                else
                    if next_2 ~= nil then
                        next_2.previous = nil
                    else
                        u18:Disconnect()
                        u18 = nil
                    end
                    u17 = next_2
                end
            end
        )
    end
    return tbl_upv_8._new(v35, v36)
end
function tbl_upv_8.prototype.timeout(a1, a2, a3)
    --[[
      name: timeout
      line: 1180
      upvalues:
        tbl_upv_8 (copy, index: 1)
        u1 (ref,  index: 2)
    ]]
    local u19 = debug.traceback(nil, 2)
    return tbl_upv_8.race(
        {
            tbl_upv_8.delay(a2):andThen(
                function()
                    --[[
                      line: 1184
                      upvalues:
                        tbl_upv_8 (copy, index: 1)
                        a3 (copy, index: 2)
                        u1 (ref,  index: 3)
                        a2 (copy, index: 4)
                        u19 (copy, index: 5)
                    ]]
                    local reject_2 = tbl_upv_8.reject
                    if a3 == nil then
                        local _ = u1.new({error = "Timed out", kind = u1.Kind.TimedOut, context = string.format("Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s", a2, u19)})
                    end
                    return reject_2(a3)
                end
            ),
            a1
        }
    )
end
function tbl_upv_8.prototype.getStatus(a1)
    --[[
      name: getStatus
      line: 1204
    ]]
    return a1._status
end
function tbl_upv_8.prototype._andThen(a1, a2, a3, a4)
    --[[
      name: _andThen
      line: 1213
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    a1._unhandledRejection = false
    if a1._status ~= tbl_upv_8.Status.Cancelled then
        return tbl_upv_8._new(
            a2,
            function(a5, a6, a7)
                --[[
                  line: 1225
                  upvalues:
                    a3 (copy, index: 1)
                    a2 (copy, index: 2)
                    a4 (copy, index: 4)
                    a1 (copy, index: 5)
                    tbl_upv_8 (copy, index: 6)
                ]]
                local u20 = a5
                if a3 then
                    local _ = a2
                end
                local u21 = a6
                if a4 then

                end
                if a1._status == tbl_upv_8.Status.Started then
                    table.insert(a1._queuedResolve, u20)
                    table.insert(a1._queuedReject, u21)
                    a7(
                        function()
                            --[[
                              line: 1244
                              upvalues:
                                a1 (copy, index: 1)
                                tbl_upv_8 (copy, index: 2)
                                u20 (ref,  index: 3)
                                u21 (ref,  index: 4)
                            ]]
                            if a1._status ~= tbl_upv_8.Status.Started then
                                return
                            end
                            table.remove(a1._queuedResolve, table.find(a1._queuedResolve, u20))
                            table.remove(a1._queuedReject, table.find(a1._queuedReject, u21))
                        end
                    )
                elseif a1._status == tbl_upv_8.Status.Resolved then
                    u20(unpack(a1._values, 1, a1._valuesLength))
                elseif a1._status == tbl_upv_8.Status.Rejected then
                    u21(unpack(a1._values, 1, a1._valuesLength))
                end
            end,
            a1
        )
    end
    local v44 = tbl_upv_8.new(function()
        --[[
          line: 1218
        ]]
    end)
    v44:cancel()
    return v44
end
function tbl_upv_8.prototype.andThen(a1, a2, a3)
    --[[
      name: andThen
      line: 1283
    ]]
    local v45 = true
    if a2 ~= nil then
        if type(a2) ~= "function" then
            local v46 = nil
            if type(a2) ~= "table" then
                v45 = false
            else
                v46 = getmetatable(a2)
                if v46 then
                    if type(rawget(v46, "__call")) ~= "function" then
                        v45 = false
                    else
                        v45 = true
                    end
                else
                    v45 = false
                end
            end
        else
            v45 = true
        end
    end
    assert(v45, string.format("Please pass a handler function to %s!", "Promise:andThen"))
    v45 = true
    if a3 ~= nil then
        if type(a3) ~= "function" then
            local v47 = nil
            if type(a3) ~= "table" then
                v45 = false
            else
                v47 = getmetatable(a3)
                if v47 then
                    if type(rawget(v47, "__call")) ~= "function" then
                        v45 = false
                    else
                        v45 = true
                    end
                else
                    v45 = false
                end
            end
        else
            v45 = true
        end
    end
    assert(v45, string.format("Please pass a handler function to %s!", "Promise:andThen"))
    return a1:_andThen(debug.traceback(nil, 2), a2, a3)
end
function tbl_upv_8.prototype.catch(a1, a2)
    --[[
      name: catch
      line: 1310
    ]]
    local v48 = true
    if a2 ~= nil then
        if type(a2) ~= "function" then
            local v49 = nil
            if type(a2) ~= "table" then
                v48 = false
            else
                v49 = getmetatable(a2)
                if v49 then
                    if type(rawget(v49, "__call")) ~= "function" then
                        v48 = false
                    else
                        v48 = true
                    end
                else
                    v48 = false
                end
            end
        else
            v48 = true
        end
    end
    assert(v48, string.format("Please pass a handler function to %s!", "Promise:catch"))
    return a1:_andThen(debug.traceback(nil, 2), nil, a2)
end
function tbl_upv_8.prototype.tap(a1, a2)
    --[[
      name: tap
      line: 1331
      upvalues:
        tbl_upv_8 (copy, index: 1)
        pack (copy, index: 2)
    ]]
    local v50
    if type(a2) ~= "function" then
        local v51 = nil
        if type(a2) ~= "table" then
            v50 = false
        else
            v51 = getmetatable(a2)
            if v51 then
                if type(rawget(v51, "__call")) ~= "function" then
                    v50 = false
                else
                    v50 = true
                end
            else
                v50 = false
            end
        end
    else
        v50 = true
    end
    assert(v50, string.format("Please pass a handler function to %s!", "Promise:tap"))
    return a1:_andThen(
        debug.traceback(nil, 2),
        function(...)
            --[[
              line: 1333
              upvalues:
                a2 (copy, index: 1)
                tbl_upv_8 (copy, index: 2)
                pack (copy, index: 3)
            ]]
            local v52 = a2(...)
            if not tbl_upv_8.is(v52) then
                return ...
            end
            local u22, u23 = pack(...)
            return v52:andThen(
                function()
                    --[[
                      line: 1338
                      upvalues:
                        u23 (copy, index: 1)
                        u22 (copy, index: 2)
                    ]]
                    return unpack(u23, 1, u22)
                end
            )
        end
    )
end
function tbl_upv_8.prototype.andThenCall(a1, a2, ...)
    --[[
      name: andThenCall
      line: 1366
      upvalues:
        pack (copy, index: 1)
    ]]
    local v53
    if type(a2) ~= "function" then
        local v54 = nil
        if type(a2) ~= "table" then
            v53 = false
        else
            v54 = getmetatable(a2)
            if v54 then
                if type(rawget(v54, "__call")) ~= "function" then
                    v53 = false
                else
                    v53 = true
                end
            else
                v53 = false
            end
        end
    else
        v53 = true
    end
    assert(v53, string.format("Please pass a handler function to %s!", "Promise:andThenCall"))
    local u24, u25 = pack(...)
    return a1:_andThen(
        debug.traceback(nil, 2),
        function()
            --[[
              line: 1369
              upvalues:
                a2 (copy, index: 1)
                u25 (copy, index: 2)
                u24 (copy, index: 3)
            ]]
            return a2(unpack(u25, 1, u24))
        end
    )
end
function tbl_upv_8.prototype.andThenReturn(a1, ...)
    --[[
      name: andThenReturn
      line: 1396
      upvalues:
        pack (copy, index: 1)
    ]]
    local u26, u27 = pack(...)
    return a1:_andThen(
        debug.traceback(nil, 2),
        function()
            --[[
              line: 1398
              upvalues:
                u27 (copy, index: 1)
                u26 (copy, index: 2)
            ]]
            return unpack(u27, 1, u26)
        end
    )
end
function tbl_upv_8.prototype.cancel(a1)
    --[[
      name: cancel
      line: 1414
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    if a1._status ~= tbl_upv_8.Status.Started then
        return
    end
    a1._status = tbl_upv_8.Status.Cancelled
    if a1._cancellationHook then
        a1._cancellationHook()
    end
    coroutine.close(a1._thread)
    if a1._parent then
        a1._parent:_consumerCancelled(a1)
    end
    for key_9 in pairs(a1._consumers) do
        key_9:cancel()
    end
    a1:_finalize()
end
function tbl_upv_8.prototype._consumerCancelled(a1, a2)
    --[[
      name: _consumerCancelled
      line: 1442
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    if a1._status ~= tbl_upv_8.Status.Started then
        return
    end
    a1._consumers[a2] = nil
    if next(a1._consumers) == nil then
        a1:cancel()
    end
end
function tbl_upv_8.prototype._finally(a1, a2, a3)
    --[[
      name: _finally
      line: 1458
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    a1._unhandledRejection = false
    return (tbl_upv_8._new(
        a2,
        function(a4, a5, a6)
            --[[
              line: 1461
              upvalues:
                a1 (copy, index: 1)
                a3 (copy, index: 2)
                tbl_upv_8 (copy, index: 3)
            ]]
            local u28 = nil
            a6(
                function()
                    --[[
                      line: 1464
                      upvalues:
                        a1 (copy, index: 1)
                        u28 (ref,  index: 2)
                    ]]
                    a1:_consumerCancelled(a1)
                    if not u28 then
                        return
                    end
                    u28:cancel()
                end
            )
            local v55 = a4
            if a3 then
                local v56 = function(...)
                    --[[
                      line: 1477
                      upvalues:
                        a3 (copy, index: 1)
                        tbl_upv_8 (copy, index: 2)
                        u28 (ref,  index: 3)
                        a4 (copy, index: 4)
                        a1 (copy, index: 5)
                        a5 (copy, index: 6)
                    ]]
                    local v57 = a3(...)
                    if tbl_upv_8.is(v57) then
                        u28 = v57
                        v57:finally(
                            function(a7)
                                --[[
                                  line: 1484
                                  upvalues:
                                    tbl_upv_8 (copy, index: 1)
                                    a4 (copy, index: 2)
                                    a1 (copy, index: 3)
                                ]]
                                if a7 == tbl_upv_8.Status.Rejected then
                                    return
                                end
                                a4(a1)
                            end
                        ):catch(
                            function(...)
                                --[[
                                  line: 1489
                                  upvalues:
                                    a5 (copy, index: 1)
                                ]]
                                a5(...)
                            end
                        )
                    else
                        a4(a1)
                    end
                end
                v55 = v56
            end
            if a1._status ~= tbl_upv_8.Status.Started then
                v55(a1._status)
            else
                table.insert(a1._queuedFinally, v55)
            end
        end
    ))
end
function tbl_upv_8.prototype.finally(a1, a2)
    --[[
      name: finally
      line: 1559
    ]]
    local v58 = true
    if a2 ~= nil then
        if type(a2) ~= "function" then
            local v59 = nil
            if type(a2) ~= "table" then
                v58 = false
            else
                v59 = getmetatable(a2)
                if v59 then
                    if type(rawget(v59, "__call")) ~= "function" then
                        v58 = false
                    else
                        v58 = true
                    end
                else
                    v58 = false
                end
            end
        else
            v58 = true
        end
    end
    assert(v58, string.format("Please pass a handler function to %s!", "Promise:finally"))
    return a1:_finally(debug.traceback(nil, 2), a2)
end
function tbl_upv_8.prototype.finallyCall(a1, a2, ...)
    --[[
      name: finallyCall
      line: 1573
      upvalues:
        pack (copy, index: 1)
    ]]
    local v60
    if type(a2) ~= "function" then
        local v61 = nil
        if type(a2) ~= "table" then
            v60 = false
        else
            v61 = getmetatable(a2)
            if v61 then
                if type(rawget(v61, "__call")) ~= "function" then
                    v60 = false
                else
                    v60 = true
                end
            else
                v60 = false
            end
        end
    else
        v60 = true
    end
    assert(v60, string.format("Please pass a handler function to %s!", "Promise:finallyCall"))
    local u29, u30 = pack(...)
    return a1:_finally(
        debug.traceback(nil, 2),
        function()
            --[[
              line: 1576
              upvalues:
                a2 (copy, index: 1)
                u30 (copy, index: 2)
                u29 (copy, index: 3)
            ]]
            return a2(unpack(u30, 1, u29))
        end
    )
end
function tbl_upv_8.prototype.finallyReturn(a1, ...)
    --[[
      name: finallyReturn
      line: 1599
      upvalues:
        pack (copy, index: 1)
    ]]
    local u31, u32 = pack(...)
    return a1:_finally(
        debug.traceback(nil, 2),
        function()
            --[[
              line: 1601
              upvalues:
                u32 (copy, index: 1)
                u31 (copy, index: 2)
            ]]
            return unpack(u32, 1, u31)
        end
    )
end
function tbl_upv_8.prototype.awaitStatus(a1)
    --[[
      name: awaitStatus
      line: 1613
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    a1._unhandledRejection = false
    if a1._status == tbl_upv_8.Status.Started then
        local u33 = coroutine.running()
        a1:finally(
            function()
                --[[
                  line: 1620
                  upvalues:
                    u33 (copy, index: 1)
                ]]
                task.spawn(u33)
            end
        ):catch(function()
            --[[
              line: 1626
            ]]
        end)
        coroutine.yield()
    end
    if a1._status ~= tbl_upv_8.Status.Resolved and a1._status ~= tbl_upv_8.Status.Rejected then
        return a1._status
    end
    return a1._status, unpack(a1._values, 1, a1._valuesLength)
end
local function awaitHelper(a1, ...)
    --[[
      name: awaitHelper
      line: 1641
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    return a1 == tbl_upv_8.Status.Resolved, ...
end
function tbl_upv_8.prototype.await(a1)
    --[[
      name: await
      line: 1666
      upvalues:
        awaitHelper (copy, index: 1)
    ]]
    return awaitHelper(a1:awaitStatus())
end
local function expectHelper(a1, ...)
    --[[
      name: expectHelper
      line: 1670
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    if a1 ~= tbl_upv_8.Status.Resolved then
        local v62 = ...
        local v63 = ((v62 == nil) and "Expected Promise rejected with no value.") or (...)
        error(v63, 3)
    end
    return ...
end
function tbl_upv_8.prototype.expect(a1)
    --[[
      name: expect
      line: 1703
      upvalues:
        expectHelper (copy, index: 1)
    ]]
    return expectHelper(a1:awaitStatus())
end
tbl_upv_8.prototype.awaitValue = tbl_upv_8.prototype.expect
function tbl_upv_8.prototype._unwrap(a1)
    --[[
      name: _unwrap
      line: 1717
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    if a1._status == tbl_upv_8.Status.Started then
        error("Promise has not resolved or rejected.", 2)
    end
    return a1._status == tbl_upv_8.Status.Resolved, unpack(a1._values, 1, a1._valuesLength)
end
function tbl_upv_8.prototype._resolve(a1, ...)
    --[[
      name: _resolve
      line: 1727
      upvalues:
        tbl_upv_8 (copy, index: 1)
        u1 (ref,  index: 2)
        pack (copy, index: 3)
    ]]
    if a1._status == tbl_upv_8.Status.Started then
        local v64 = ...
        local v65 = nil
        if tbl_upv_8.is(v64) then
            if select("#", ...) > 1 then
                warn((string.format("When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s", a1._source)))
            end
            local u34 = ...
            v65 = u34:andThen(
                function(...)
                    --[[
                      line: 1748
                      upvalues:
                        a1 (copy, index: 1)
                    ]]
                    a1:_resolve(...)
                end,
                function(...)
                    --[[
                      line: 1750
                      upvalues:
                        u34 (copy, index: 1)
                        u1 (ref,  index: 2)
                        a1 (copy, index: 3)
                    ]]
                    local v66 = u34._values[1]
                    if u34._error then
                        v66 = u1.new({context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]", error = u34._error, kind = u1.Kind.ExecutionError})
                    end
                    if u1.isKind(v66, u1.Kind.ExecutionError) then
                        return a1:_reject(v66:extend({trace = "", error = "This Promise was chained to a Promise that errored.", context = string.format("The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n", a1._source)}))
                    end
                    a1:_reject(...)
                end
            )
            if v65._status == tbl_upv_8.Status.Cancelled then
                a1:cancel()
            elseif v65._status == tbl_upv_8.Status.Started then
                a1._parent = v65
                v65._consumers[a1] = true
            end
        else
            a1._status = tbl_upv_8.Status.Resolved
            local v67, v68 = pack(...)
            a1._valuesLength = v67
            a1._values = v68
            for _, value_25 in ipairs(a1._queuedResolve) do
                coroutine.wrap(value_25)(...)
            end
            a1:_finalize()
        end
    else
        local v69 = ...
        if tbl_upv_8.is(v69) then
            local v70 = ...
            v70:_consumerCancelled(a1)
        end
    end
end
function tbl_upv_8.prototype._reject(a1, ...)
    --[[
      name: _reject
      line: 1798
      upvalues:
        tbl_upv_8 (copy, index: 1)
        pack (copy, index: 2)
    ]]
    if a1._status ~= tbl_upv_8.Status.Started then
        return
    end
    a1._status = tbl_upv_8.Status.Rejected
    local v71, v72 = pack(...)
    a1._valuesLength = v71
    a1._values = v72
    local v73 = next(a1._queuedReject) == nil
    if v73 then
        local v74 = ...
        local str_upv_1 = tostring(v74)
        coroutine.wrap(
            function()
                --[[
                  line: 1820
                  upvalues:
                    tbl_upv_8 (copy, index: 1)
                    a1 (copy, index: 2)
                    str_upv_1 (copy, index: 3)
                ]]
                tbl_upv_8._timeEvent:Wait()
                if not a1._unhandledRejection then
                    return
                end
                local v75 = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", str_upv_1, a1._source)
                for _, value_26 in ipairs(tbl_upv_8._unhandledRejectionCallbacks) do
                    task.spawn(value_26, a1, unpack(a1._values, 1, a1._valuesLength))
                end
                if tbl_upv_8.TEST then
                    return
                end
                warn(v75)
            end
        )()
    else
        for _, value_27 in ipairs(a1._queuedReject) do
            coroutine.wrap(value_27)(...)
        end
    end
    a1:_finalize()
end
function tbl_upv_8.prototype._finalize(a1)
    --[[
      name: _finalize
      line: 1852
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    for _, value_28 in ipairs(a1._queuedFinally) do
        coroutine.wrap(value_28)(a1._status)
    end
    a1._queuedFinally = nil
    a1._queuedReject = nil
    a1._queuedResolve = nil
    if not (tbl_upv_8.TEST) then
        a1._parent = nil
        a1._consumers = nil
    end
    task.defer(coroutine.close, a1._thread)
end
function tbl_upv_8.prototype.now(a1, a2)
    --[[
      name: now
      line: 1889
      upvalues:
        tbl_upv_8 (copy, index: 1)
        u1 (ref,  index: 2)
    ]]
    local v76 = debug.traceback(nil, 2)
    if a1._status == tbl_upv_8.Status.Resolved then
        return a1:_andThen(
            v76,
            function(...)
                --[[
                  line: 1892
                ]]
                return ...
            end
        )
    end
    local reject_3 = tbl_upv_8.reject
    local v77
    if a2 ~= nil then
        v77 = a2
    else
        v77 = u1.new({error = "This Promise was not resolved in time for :now()", kind = u1.Kind.NotResolvedInTime, context = ":now() was called at:\n\n" .. v76}) or a2
    end
    return reject_3(v77)
end
function tbl_upv_8.retry(a1, a2, ...)
    --[[
      name: retry
      line: 1934
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    local v78
    if type(a1) ~= "function" then
        local v79 = nil
        if type(a1) ~= "table" then
            v78 = false
        else
            v79 = getmetatable(a1)
            if v79 then
                if type(rawget(v79, "__call")) ~= "function" then
                    v78 = false
                else
                    v78 = true
                end
            else
                v78 = false
            end
        end
    else
        v78 = true
    end
    assert(v78, "Parameter #1 to Promise.retry must be a function")
    v78 = type(a2) == "number"
    assert(v78, "Parameter #2 to Promise.retry must be a number")
    local tbl_upv_20 = {...}
    local u35 = select("#", ...)
    return tbl_upv_8.resolve(a1(...)):catch(
        function(...)
            --[[
              line: 1940
              upvalues:
                a2 (copy, index: 1)
                tbl_upv_8 (copy, index: 2)
                a1 (copy, index: 3)
                tbl_upv_20 (copy, index: 4)
                u35 (copy, index: 5)
            ]]
            if a2 > 0 then
                return tbl_upv_8.retry(a1, a2 - 1, unpack(tbl_upv_20, 1, u35))
            end
            return tbl_upv_8.reject(...)
        end
    )
end
function tbl_upv_8.retryWithDelay(a1, a2, a3, ...)
    --[[
      name: retryWithDelay
      line: 1962
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    local v80
    if type(a1) ~= "function" then
        local v81 = nil
        if type(a1) ~= "table" then
            v80 = false
        else
            v81 = getmetatable(a1)
            if v81 then
                if type(rawget(v81, "__call")) ~= "function" then
                    v80 = false
                else
                    v80 = true
                end
            else
                v80 = false
            end
        end
    else
        v80 = true
    end
    assert(v80, "Parameter #1 to Promise.retry must be a function")
    v80 = type(a2) == "number"
    assert(v80, "Parameter #2 (times) to Promise.retry must be a number")
    v80 = type(a3) == "number"
    assert(v80, "Parameter #3 (seconds) to Promise.retry must be a number")
    local tbl_upv_21 = {...}
    local u36 = select("#", ...)
    return tbl_upv_8.resolve(a1(...)):catch(
        function(...)
            --[[
              line: 1969
              upvalues:
                a2 (copy, index: 1)
                tbl_upv_8 (copy, index: 2)
                a3 (copy, index: 3)
                a1 (copy, index: 4)
                tbl_upv_21 (copy, index: 5)
                u36 (copy, index: 6)
            ]]
            if a2 > 0 then
                tbl_upv_8.delay(a3):await()
                return tbl_upv_8.retryWithDelay(a1, a2 - 1, a3, unpack(tbl_upv_21, 1, u36))
            end
            return tbl_upv_8.reject(...)
        end
    )
end
function tbl_upv_8.fromEvent(a1, a2)
    --[[
      name: fromEvent
      line: 2004
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    local v82 = a2
        or function()
            --[[
              line: 2005
            ]]
            return true
        end
    a2 = v82
    local v83 = debug.traceback(nil, 2)
    local v84 = function(a3, a4, a5)
        --[[
          line: 2009
          upvalues:
            a1 (copy, index: 1)
            a2 (ref,  index: 2)
        ]]
        local u37 = nil
        local u38 = false
        local function disconnect_1()
            --[[
              name: disconnect
              line: 2013
              upvalues:
                u37 (ref, index: 1)
            ]]
            u37:Disconnect()
            u37 = nil
        end
        local v85 = a1:Connect(
            function(...)
                --[[
                  line: 2022
                  upvalues:
                    a2 (ref,  index: 1)
                    a3 (copy, index: 2)
                    u37 (ref,  index: 3)
                    u38 (ref,  index: 4)
                ]]
                local v86 = a2(...)
                if v86 == true then
                    a3(...)
                    if u37 then
                        u37:Disconnect()
                        u37 = nil
                    else
                        u38 = true
                    end
                elseif type(v86) ~= "boolean" then
                    error("Promise.fromEvent predicate should always return a boolean")
                end
            end
        )
        u37 = v85
        if u38 and u37 then
            return disconnect_1()
        end
        a5(disconnect_1)
    end
    return tbl_upv_8._new(v83, v84)
end
function tbl_upv_8.onUnhandledRejection(a1)
    --[[
      name: onUnhandledRejection
      line: 2056
      upvalues:
        tbl_upv_8 (copy, index: 1)
    ]]
    table.insert(tbl_upv_8._unhandledRejectionCallbacks, a1)
    return function()
        --[[
          line: 2059
          upvalues:
            tbl_upv_8 (copy, index: 1)
            a1 (copy, index: 2)
        ]]
        local v87 = table.find(tbl_upv_8._unhandledRejectionCallbacks, a1)
        if not v87 then
            return
        end
        table.remove(tbl_upv_8._unhandledRejectionCallbacks, v87)
    end
end
return tbl_upv_8