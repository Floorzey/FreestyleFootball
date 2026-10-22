--[[
    Script Path: Game/ReplicatedStorage/Packages/Comm/Server
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local RemoteProperty_upv_1 = require(script.RemoteProperty)
local RemoteSignal_upv_1 = require(script.RemoteSignal)
local _ = require(script.Parent.Types)
local Util_upv_1 = require(script.Parent.Util)
local tbl_upv_1 = {}
function tbl_upv_1.BindFunction(a1, a2, a3, a4, a5)
    --[[
      name: BindFunction
      line: 37
      upvalues:
        Util_upv_1 (copy, index: 1)
    ]]
    assert(Util_upv_1.IsServer, "BindFunction must be called from the server")
    local v1 = Util_upv_1.GetCommSubFolder(a1, "RF"):Expect("Failed to get Comm RF folder")
    local v2 = Instance.new("RemoteFunction")
    v2.Name = a2
    local v3 = (type(a4) == "table") and (#a4 > 0)
    local v4 = (type(a5) == "table") and (#a5 > 0)
    local function ProcessOutbound(a6, ...)
        --[[
          name: ProcessOutbound
          line: 50
          upvalues:
            a5 (copy, index: 1)
        ]]
        local v5 = table.pack(...)
        local v6 = nil
        for _, value_1 in ipairs(a5) do
            v6 = table.pack(value_1(a6, v5))
            if v6[1] then
                v5.n = #v5
                continue
            end
            return table.unpack(v6, 2, v6.n)
        end
        return table.unpack(v5, 1, v5.n)
    end
    if (v3) and (v4) then
        function v2.OnServerInvoke(a7, ...)
            --[[
              name: OnServerInvoke
              line: 62
              upvalues:
                a4 (copy, index: 1)
                ProcessOutbound (copy, index: 2)
                a3 (copy, index: 3)
            ]]
            local v7 = table.pack(...)
            local v8 = nil
            for _, value_2 in ipairs(a4) do
                v8 = table.pack(value_2(a7, v7))
                if v8[1] then
                    v7.n = #v7
                    continue
                end
                return table.unpack(v8, 2, v8.n)
            end
            return ProcessOutbound(a7, a3(a7, table.unpack(v7, 1, v7.n)))
        end
    elseif v3 then
        function v2.OnServerInvoke(a8, ...)
            --[[
              name: OnServerInvoke
              line: 75
              upvalues:
                a4 (copy, index: 1)
                a3 (copy, index: 2)
            ]]
            local v9 = table.pack(...)
            local v10 = nil
            for _, value_3 in ipairs(a4) do
                v10 = table.pack(value_3(a8, v9))
                if v10[1] then
                    v9.n = #v9
                    continue
                end
                return table.unpack(v10, 2, v10.n)
            end
            return a3(a8, table.unpack(v9, 1, v9.n))
        end
    elseif v4 then
        function v2.OnServerInvoke(a9, ...)
            --[[
              name: OnServerInvoke
              line: 88
              upvalues:
                ProcessOutbound (copy, index: 1)
                a3 (copy, index: 2)
            ]]
            return ProcessOutbound(a9, a3(a9, ...))
        end
    else
        v2.OnServerInvoke = a3
    end
    v2.Parent = v1
    return v2
end
function tbl_upv_1.WrapMethod(a1, a2, a3, a4, a5)
    --[[
      name: WrapMethod
      line: 99
      upvalues:
        Util_upv_1 (copy, index: 1)
        tbl_upv_1 (copy, index: 2)
    ]]
    assert(Util_upv_1.IsServer, "WrapMethod must be called from the server")
    local u1 = a2[a3]
    local v11 = type(u1) == "function"
    assert(v11, "Value at index " .. a3 .. " must be a function; got " .. type(u1))
    return tbl_upv_1.BindFunction(
        a1,
        a3,
        function(...)
            --[[
              line: 109
              upvalues:
                u1 (copy, index: 1)
                a2 (copy, index: 2)
            ]]
            return u1(a2, ...)
        end,
        a4,
        a5
    )
end
function tbl_upv_1.CreateSignal(a1, a2, a3, a4, a5)
    --[[
      name: CreateSignal
      line: 114
      upvalues:
        Util_upv_1 (copy, index: 1)
        RemoteSignal_upv_1 (copy, index: 2)
    ]]
    assert(Util_upv_1.IsServer, "CreateSignal must be called from the server")
    return (RemoteSignal_upv_1.new(Util_upv_1.GetCommSubFolder(a1, "RE"):Expect("Failed to get Comm RE folder"), a2, a3, a4, a5))
end
function tbl_upv_1.CreateProperty(a1, a2, a3, a4, a5)
    --[[
      name: CreateProperty
      line: 127
      upvalues:
        Util_upv_1 (copy, index: 1)
        RemoteProperty_upv_1 (copy, index: 2)
    ]]
    assert(Util_upv_1.IsServer, "CreateProperty must be called from the server")
    return (RemoteProperty_upv_1.new(Util_upv_1.GetCommSubFolder(a1, "RP"):Expect("Failed to get Comm RP folder"), a2, a3, a4, a5))
end
return tbl_upv_1