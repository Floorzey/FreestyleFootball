--[[
    Script Path: Game/ReplicatedStorage/Packages/Signal
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local u1 = nil
local function u2(a1, ...)
    --[[
      name: acquireRunnerThreadAndCallEventHandler
      line: 44
      upvalues:
        u1 (ref, index: 1)
    ]]
    local v1 = u1
    u1 = nil
    a1(...)
    u1 = v1
end
local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.Disconnect(a1)
    --[[
      name: Disconnect
      line: 81
    ]]
    if not a1.Connected then
        return
    end
    a1.Connected = false
    if a1._signal._handlerListHead ~= a1 then
        local _handlerListHead_1 = a1._signal._handlerListHead
        while _handlerListHead_1 and _handlerListHead_1._next ~= a1 do
            _handlerListHead_1 = _handlerListHead_1._next
        end
        if _handlerListHead_1 then
            _handlerListHead_1._next = a1._next
        end
    else
        a1._signal._handlerListHead = a1._next
    end
end
tbl_upv_1.Destroy = tbl_upv_1.Disconnect
local tbl_2 = {__index = 0, __newindex = 0}
function tbl_2.__index(a1, a2)
    --[[
      name: __index
      line: 108
    ]]
    error(("Attempt to get Connection::%s (not a valid member)"):format(tostring(a2)), 2)
end
function tbl_2.__newindex(a1, a2, a3)
    --[[
      name: __newindex
      line: 111
    ]]
    error(("Attempt to set Connection::%s (not a valid member)"):format(tostring(a2)), 2)
end
setmetatable(tbl_upv_1, tbl_2)
local tbl_upv_3 = {}
tbl_upv_3.__index = tbl_upv_3
function tbl_upv_3.new()
    --[[
      name: new
      line: 147
      upvalues:
        tbl_upv_3 (copy, index: 1)
    ]]
    return (setmetatable({_handlerListHead = false}, tbl_upv_3))
end
function tbl_upv_3.Wrap(a1)
    --[[
      name: Wrap
      line: 170
      upvalues:
        tbl_upv_3 (copy, index: 1)
    ]]
    local v2 = typeof(a1) == "RBXScriptSignal"
    assert(v2, "Argument #1 to Signal.Wrap must be a RBXScriptSignal; got " .. typeof(a1))
    local u3 = tbl_upv_3.new()
    u3._proxyHandler = a1:Connect(
        function(...)
            --[[
              line: 177
              upvalues:
                u3 (copy, index: 1)
            ]]
            u3:Fire(...)
        end
    )
    return u3
end
function tbl_upv_3.Is(a1)
    --[[
      name: Is
      line: 190
      upvalues:
        tbl_upv_3 (copy, index: 1)
    ]]
    local v3 = (type(a1) == "table") and (getmetatable(a1) == tbl_upv_3)
    return v3
end
function tbl_upv_3.Connect(a1, a2)
    --[[
      name: Connect
      line: 207
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v4 = setmetatable({Connected = true, _next = false, _signal = a1, _fn = a2}, tbl_upv_1)
    if a1._handlerListHead then
        v4._next = a1._handlerListHead
    end
    a1._handlerListHead = v4
    return v4
end
function tbl_upv_3.ConnectOnce(a1, a2)
    --[[
      name: ConnectOnce
      line: 230
    ]]
    return a1:Once(a2)
end
function tbl_upv_3.Once(a1, a2)
    --[[
      name: Once
      line: 249
    ]]
    local u4 = nil
    local u5 = false
    local v5 = a1:Connect(
        function(...)
            --[[
              line: 253
              upvalues:
                u5 (ref,  index: 1)
                u4 (ref,  index: 2)
                a2 (copy, index: 3)
            ]]
            if u5 then
                return
            end
            u5 = true
            u4:Disconnect()
            a2(...)
        end
    )
    u4 = v5
    return u4
end
function tbl_upv_3.GetConnections(a1)
    --[[
      name: GetConnections
      line: 266
    ]]
    local tbl_4 = {}
    local _handlerListHead_2 = a1._handlerListHead
    while _handlerListHead_2 do
        table.insert(tbl_4, _handlerListHead_2)
        _handlerListHead_2 = _handlerListHead_2._next
    end
    return tbl_4
end
function tbl_upv_3.DisconnectAll(a1)
    --[[
      name: DisconnectAll
      line: 286
    ]]
    local _handlerListHead_3 = a1._handlerListHead
    while _handlerListHead_3 do
        _handlerListHead_3.Connected = false
        _handlerListHead_3 = _handlerListHead_3._next
    end
    a1._handlerListHead = false
    if not a1._yieldedThreads then
        return
    end
    for key_1 in a1._yieldedThreads do
        if coroutine.status(key_1) == "suspended" then
            warn(debug.traceback(key_1, "signal disconnected; yielded thread cancelled", 2))
            task.cancel(key_1)
        end
    end
    table.clear(a1._yieldedThreads)
end
local function runEventHandlerInFreeThread(...)
    --[[
      name: runEventHandlerInFreeThread
      line: 55
      upvalues:
        u2 (copy, index: 1)
    ]]
    u2(...)
    while true do
        u2(coroutine.yield())
    end
end
function tbl_upv_3.Fire(a1, ...)
    --[[
      name: Fire
      line: 320
      upvalues:
        u1 (ref,  index: 1)
        runEventHandlerInFreeThread (copy, index: 2)
    ]]
    local _handlerListHead_4 = a1._handlerListHead
    while _handlerListHead_4 do
        if not (_handlerListHead_4.Connected) then
            _handlerListHead_4 = _handlerListHead_4._next
            continue
        end
        if not (u1) then
            u1 = coroutine.create(runEventHandlerInFreeThread)
        end
        task.spawn(u1, _handlerListHead_4._fn, ...)
        _handlerListHead_4 = _handlerListHead_4._next
    end
end
function tbl_upv_3.FireDeferred(a1, ...)
    --[[
      name: FireDeferred
      line: 341
    ]]
    local u6 = a1._handlerListHead
    while (u6) do
        task.defer(
            function(...)
                --[[
                  line: 345
                  upvalues:
                    u6 (copy, index: 1)
                ]]
                if not u6.Connected then
                    return
                end
                u6._fn(...)
            end,
            ...
        )
        u6 = u6._next
    end
end
function tbl_upv_3.Wait(a1)
    --[[
      name: Wait
      line: 369
    ]]
    local u7 = rawget(a1, "_yieldedThreads")
    if not (u7) then
        u7 = {}
        rawset(a1, "_yieldedThreads", u7)
    end
    local u8 = coroutine.running()
    u7[u8] = true
    a1:Once(
        function(...)
            --[[
              line: 379
              upvalues:
                u7 (ref,  index: 1)
                u8 (copy, index: 2)
            ]]
            u7[u8] = nil
            task.spawn(u8, ...)
        end
    )
    return coroutine.yield()
end
function tbl_upv_3.Destroy(a1)
    --[[
      name: Destroy
      line: 399
    ]]
    a1:DisconnectAll()
    local value_1 = rawget(a1, "_proxyHandler")
    if not value_1 then
        return
    end
    value_1:Disconnect()
end
local tbl_5 = {__index = 0, __newindex = 0}
function tbl_5.__index(a1, a2)
    --[[
      name: __index
      line: 410
    ]]
    error(("Attempt to get Signal::%s (not a valid member)"):format(tostring(a2)), 2)
end
function tbl_5.__newindex(a1, a2, a3)
    --[[
      name: __newindex
      line: 413
    ]]
    error(("Attempt to set Signal::%s (not a valid member)"):format(tostring(a2)), 2)
end
setmetatable(tbl_upv_3, tbl_5)
local tbl_6 = {}
tbl_6.new = tbl_upv_3.new
tbl_6.Wrap = tbl_upv_3.Wrap
tbl_6.Is = tbl_upv_3.Is
return table.freeze(tbl_6)