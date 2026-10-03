--[[
    Script Path: Game/ReplicatedStorage/Packages/Comm/Server/RemoteSignal
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local Players_upv_1 = game:GetService("Players")
local Signal_upv_1 = require(script.Parent.Parent.Parent.Signal)
local _ = require(script.Parent.Parent.Types)
local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.new(a1, a2, a3, a4, a5)
    --[[
      name: new
      line: 27
      upvalues:
        tbl_upv_1 (copy, index: 1)
        Signal_upv_1 (copy, index: 2)
    ]]
    local u1 = setmetatable({}, tbl_upv_1)
    local v1
    if a3 ~= true then
        v1 = Instance.new("RemoteEvent")
    else
        v1 = Instance.new("UnreliableRemoteEvent")
    end
    u1._re = v1
    u1._re.Name = a2
    u1._re.Parent = a1
    if (a5) and (#a5 > 0) then
        u1._hasOutbound = true
        u1._outbound = a5
    else
        u1._hasOutbound = false
    end
    if a4 and #a4 > 0 then
        u1._directConnect = false
        u1._signal = Signal_upv_1.new()
        u1._re.OnServerEvent:Connect(
            function(a6, ...)
                --[[
                  line: 47
                  upvalues:
                    a4 (copy, index: 1)
                    u1 (copy, index: 2)
                ]]
                local v2 = table.pack(...)
                for _, value_1 in a4 do
                    if table.pack(value_1(a6, v2))[1] then
                        v2.n = #v2
                        continue
                    end
                    return
                end
                u1._signal:Fire(a6, table.unpack(v2, 1, v2.n))
            end
        )
    else
        u1._directConnect = true
    end
    return u1
end
function tbl_upv_1.IsUnreliable(a1)
    --[[
      name: IsUnreliable
      line: 69
    ]]
    return a1._re:IsA("UnreliableRemoteEvent")
end
function tbl_upv_1.Connect(a1, a2)
    --[[
      name: Connect
      line: 80
    ]]
    if a1._directConnect then
        return a1._re.OnServerEvent:Connect(a2)
    end
    return a1._signal:Connect(a2)
end
function tbl_upv_1._processOutboundMiddleware(a1, a2, ...)
    --[[
      name: _processOutboundMiddleware
      line: 88
    ]]
    if not a1._hasOutbound then
        return ...
    end
    local v3 = table.pack(...)
    local v4 = nil
    for _, value_2 in a1._outbound do
        v4 = table.pack(value_2(a2, v3))
        if v4[1] then
            v3.n = #v3
            continue
        end
        return table.unpack(v4, 2, v4.n)
    end
    return table.unpack(v3, 1, v3.n)
end
function tbl_upv_1.Fire(a1, a2, ...)
    --[[
      name: Fire
      line: 113
    ]]
    a1._re:FireClient(a2, a1:_processOutboundMiddleware(a2, ...))
end
function tbl_upv_1.FireAll(a1, ...)
    --[[
      name: FireAll
      line: 126
    ]]
    a1._re:FireAllClients(a1:_processOutboundMiddleware(nil, ...))
end
function tbl_upv_1.FireExcept(a1, a2, ...)
    --[[
      name: FireExcept
      line: 141
    ]]
    a1:FireFilter(
        function(a3)
            --[[
              line: 142
              upvalues:
                a2 (copy, index: 1)
            ]]
            return a3 ~= a2
        end,
        ...
    )
end
function tbl_upv_1.FireFilter(a1, a2, ...)
    --[[
      name: FireFilter
      line: 171
      upvalues:
        Players_upv_1 (copy, index: 1)
    ]]
    for _, value_3 in Players_upv_1:GetPlayers() do
        if a2(value_3, ...) then
            a1._re:FireClient(value_3, a1:_processOutboundMiddleware(nil, ...))
        end
    end
end
function tbl_upv_1.FireFor(a1, a2, ...)
    --[[
      name: FireFor
      line: 195
    ]]
    for _, value_4 in a2 do
        a1._re:FireClient(value_4, a1:_processOutboundMiddleware(nil, ...))
    end
end
function tbl_upv_1.Destroy(a1)
    --[[
      name: Destroy
      line: 204
    ]]
    a1._re:Destroy()
    if not a1._signal then
        return
    end
    a1._signal:Destroy()
end
return tbl_upv_1