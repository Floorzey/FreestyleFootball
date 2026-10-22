--[[
    Script Path: Game/ReplicatedStorage/Packages/Comm/Client/ClientRemoteProperty
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local Promise_upv_1 = require(script.Parent.Parent.Parent.Promise)
local Signal_upv_1 = require(script.Parent.Parent.Parent.Signal)
local ClientRemoteSignal_upv_1 = require(script.Parent.ClientRemoteSignal)
local _ = require(script.Parent.Parent.Types)
local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.new(a1, a2, a3)
    --[[
      name: new
      line: 32
      upvalues:
        tbl_upv_1 (copy, index: 1)
        ClientRemoteSignal_upv_1 (copy, index: 2)
        Signal_upv_1 (copy, index: 3)
        Promise_upv_1 (copy, index: 4)
    ]]
    local u1 = setmetatable({}, tbl_upv_1)
    u1._rs = ClientRemoteSignal_upv_1.new(a1, a2, a3)
    u1._ready = false
    u1._value = nil
    u1.Changed = Signal_upv_1.new()
    u1._rs:Fire()
    local u2 = nil
    u1._readyPromise = Promise_upv_1.new(
        function(a4)
            --[[
              line: 45
              upvalues:
                u2 (ref, index: 1)
            ]]
            u2 = a4
        end
    )
    u1._changed = u1._rs:Connect(
        function(a5)
            --[[
              line: 48
              upvalues:
                u1 (copy, index: 1)
                u2 (ref,  index: 2)
            ]]
            local v1 = a5 ~= u1._value
            u1._value = a5
            if not (u1._ready) then
                u1._ready = true
                u2(a5)
            end
            if not v1 then
                return
            end
            u1.Changed:Fire(a5)
        end
    )
    return u1
end
function tbl_upv_1.Get(a1)
    --[[
      name: Get
      line: 71
    ]]
    return a1._value
end
function tbl_upv_1.OnReady(a1)
    --[[
      name: OnReady
      line: 94
    ]]
    return a1._readyPromise
end
function tbl_upv_1.IsReady(a1)
    --[[
      name: IsReady
      line: 110
    ]]
    return a1._ready
end
function tbl_upv_1.Observe(a1, a2)
    --[[
      name: Observe
      line: 135
    ]]
    if a1._ready then
        task.defer(a2, a1._value)
    end
    return a1.Changed:Connect(a2)
end
function tbl_upv_1.Destroy(a1)
    --[[
      name: Destroy
      line: 145
    ]]
    a1._rs:Destroy()
    if a1._readyPromise then
        a1._readyPromise:cancel()
    end
    if a1._changed then
        a1._changed:Disconnect()
    end
    a1.Changed:Destroy()
end
return tbl_upv_1