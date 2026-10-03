--[[
    Script Path: Game/ReplicatedStorage/Packages/Comm/Client/ClientRemoteSignal
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local Signal_upv_1 = require(script.Parent.Parent.Parent.Signal)
local _ = require(script.Parent.Parent.Types)
local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.new(a1, a2, a3)
    --[[
      name: new
      line: 24
      upvalues:
        tbl_upv_1 (copy, index: 1)
        Signal_upv_1 (copy, index: 2)
    ]]
    local u1 = setmetatable({}, tbl_upv_1)
    u1._re = a1
    if (a3) and (#a3 > 0) then
        u1._hasOutbound = true
        u1._outbound = a3
    else
        u1._hasOutbound = false
    end
    if a2 and #a2 > 0 then
        u1._directConnect = false
        u1._signal = Signal_upv_1.new()
        u1._reConn = u1._re.OnClientEvent:Connect(
            function(...)
                --[[
                  line: 40
                  upvalues:
                    a2 (copy, index: 1)
                    u1 (copy, index: 2)
                ]]
                local v1 = table.pack(...)
                for _, value_1 in a2 do
                    if table.pack(value_1(v1))[1] then
                        v1.n = #v1
                        continue
                    end
                    return
                end
                u1._signal:Fire(table.unpack(v1, 1, v1.n))
            end
        )
    else
        u1._directConnect = true
    end
    return u1
end
function tbl_upv_1._processOutboundMiddleware(a1, ...)
    --[[
      name: _processOutboundMiddleware
      line: 57
    ]]
    local v2 = table.pack(...)
    local v3 = nil
    for _, value_2 in a1._outbound do
        v3 = table.pack(value_2(v2))
        if v3[1] then
            v2.n = #v2
            continue
        end
        return table.unpack(v3, 2, v3.n)
    end
    return table.unpack(v2, 1, v2.n)
end
function tbl_upv_1.Connect(a1, a2)
    --[[
      name: Connect
      line: 76
    ]]
    if a1._directConnect then
        return a1._re.OnClientEvent:Connect(a2)
    end
    return a1._signal:Connect(a2)
end
function tbl_upv_1.Fire(a1, ...)
    --[[
      name: Fire
      line: 92
    ]]
    if a1._hasOutbound then
        a1._re:FireServer(a1:_processOutboundMiddleware(...))
    else
        a1._re:FireServer(...)
    end
end
function tbl_upv_1.Destroy(a1)
    --[[
      name: Destroy
      line: 103
    ]]
    if not a1._signal then
        return
    end
    a1._signal:Destroy()
end
return tbl_upv_1