--[[
    Script Path: Game/ReplicatedStorage/Packages/Comm/Client
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local Util_upv_1 = require(script.Parent.Util)
local _ = require(script.Parent.Types)
local Promise_upv_1 = require(script.Parent.Parent.Promise)
local ClientRemoteSignal_upv_1 = require(script.ClientRemoteSignal)
local ClientRemoteProperty_upv_1 = require(script.ClientRemoteProperty)
local tbl_1 = {}
function tbl_1.GetFunction(a1, a2, a3, a4, a5)
    --[[
      name: GetFunction
      line: 9
      upvalues:
        Util_upv_1 (copy, index: 1)
        Promise_upv_1 (copy, index: 2)
    ]]
    assert(not Util_upv_1.IsServer, "GetFunction must be called from the client")
    local u1 = Util_upv_1.GetCommSubFolder(a1, "RF"):Expect("Failed to get Comm RF folder"):WaitForChild(a2, Util_upv_1.WaitForChildTimeout)
    assert(u1 ~= nil, "Failed to find RemoteFunction: " .. a2)
    local v1 = (type(a4) == "table") and (#a4 > 0)
    local u2 = (type(a5) == "table") and (#a5 > 0)
    local function ProcessOutbound(a6)
        --[[
          name: ProcessOutbound
          line: 22
          upvalues:
            a5 (copy, index: 1)
        ]]
        local v2 = nil
        for _, value_1 in ipairs(a5) do
            v2 = table.pack(value_1(a6))
            if v2[1] then
                a6.n = #a6
                continue
            end
            return table.unpack(v2, 2, v2.n)
        end
        return table.unpack(a6, 1, a6.n)
    end
    if v1 then
        if a3 then
            return function(...)
                --[[
                  line: 34
                  upvalues:
                    Promise_upv_1 (copy, index: 1)
                    u2 (copy, index: 2)
                    u1 (copy, index: 3)
                    ProcessOutbound (copy, index: 4)
                    a4 (copy, index: 5)
                ]]
                local u3 = table.pack(...)
                return Promise_upv_1.new(
                    function(a7, a8)
                        --[[
                          line: 36
                          upvalues:
                            u2 (copy, index: 1)
                            u1 (copy, index: 2)
                            ProcessOutbound (copy, index: 3)
                            u3 (copy, index: 4)
                            a4 (copy, index: 5)
                        ]]
                        local success_1, v3 = pcall(
                            function()
                                --[[
                                  line: 37
                                  upvalues:
                                    u2 (copy, index: 1)
                                    u1 (copy, index: 2)
                                    ProcessOutbound (copy, index: 3)
                                    u3 (copy, index: 4)
                                ]]
                                if u2 then
                                    return table.pack(u1:InvokeServer(ProcessOutbound(u3)))
                                end
                                return table.pack(u1:InvokeServer(table.unpack(u3, 1, u3.n)))
                            end
                        )
                        if success_1 then
                            local v4 = nil
                            for _, value_2 in ipairs(a4) do
                                v4 = table.pack(value_2(v3))
                                if v4[1] then
                                    v3.n = #v3
                                    continue
                                end
                                return table.unpack(v4, 2, v4.n)
                            end
                            a7(table.unpack(v3, 1, v3.n))
                        else
                            a8(v3)
                        end
                    end
                )
            end
        end
        return function(...)
            --[[
              line: 59
              upvalues:
                u2 (copy, index: 1)
                u1 (copy, index: 2)
                ProcessOutbound (copy, index: 3)
                a4 (copy, index: 4)
            ]]
            local v5
            if u2 then
                v5 = table.pack(u1:InvokeServer(ProcessOutbound(table.pack(...))))
            else
                local v6 = table.pack(u1:InvokeServer(...))
                v5 = v6
            end
            local v7 = nil
            for _, value_3 in ipairs(a4) do
                v7 = table.pack(value_3(v5))
                if v7[1] then
                    v5.n = #v5
                    continue
                end
                return table.unpack(v7, 2, v7.n)
            end
            return table.unpack(v5, 1, v5.n)
        end
    end
    if a3 then
        return function(...)
            --[[
              line: 78
              upvalues:
                Promise_upv_1 (copy, index: 1)
                u2 (copy, index: 2)
                u1 (copy, index: 3)
                ProcessOutbound (copy, index: 4)
            ]]
            local u4 = table.pack(...)
            return Promise_upv_1.new(
                function(a9, a10)
                    --[[
                      line: 80
                      upvalues:
                        u2 (copy, index: 1)
                        u1 (copy, index: 2)
                        ProcessOutbound (copy, index: 3)
                        u4 (copy, index: 4)
                    ]]
                    local success_2, v8 = pcall(
                        function()
                            --[[
                              line: 81
                              upvalues:
                                u2 (copy, index: 1)
                                u1 (copy, index: 2)
                                ProcessOutbound (copy, index: 3)
                                u4 (copy, index: 4)
                            ]]
                            if u2 then
                                return table.pack(u1:InvokeServer(ProcessOutbound(u4)))
                            end
                            return table.pack(u1:InvokeServer(table.unpack(u4, 1, u4.n)))
                        end
                    )
                    if success_2 then
                        a9(table.unpack(v8, 1, v8.n))
                    else
                        a10(v8)
                    end
                end
            )
        end
    elseif u2 then
        return function(...)
            --[[
              line: 97
              upvalues:
                u1 (copy, index: 1)
                ProcessOutbound (copy, index: 2)
            ]]
            return u1:InvokeServer(ProcessOutbound(table.pack(...)))
        end
    else
        return function(...)
            --[[
              line: 101
              upvalues:
                u1 (copy, index: 1)
            ]]
            return u1:InvokeServer(...)
        end
    end
end
function tbl_1.GetSignal(a1, a2, a3, a4)
    --[[
      name: GetSignal
      line: 109
      upvalues:
        Util_upv_1 (copy, index: 1)
        ClientRemoteSignal_upv_1 (copy, index: 2)
    ]]
    assert(not Util_upv_1.IsServer, "GetSignal must be called from the client")
    local v9 = Util_upv_1.GetCommSubFolder(a1, "RE"):Expect("Failed to get Comm RE folder"):WaitForChild(a2, Util_upv_1.WaitForChildTimeout)
    assert(v9 ~= nil, "Failed to find RemoteEvent: " .. a2)
    return ClientRemoteSignal_upv_1.new(v9, a3, a4)
end
function tbl_1.GetProperty(a1, a2, a3, a4)
    --[[
      name: GetProperty
      line: 122
      upvalues:
        Util_upv_1 (copy, index: 1)
        ClientRemoteProperty_upv_1 (copy, index: 2)
    ]]
    assert(not Util_upv_1.IsServer, "GetProperty must be called from the client")
    local v10 = Util_upv_1.GetCommSubFolder(a1, "RP"):Expect("Failed to get Comm RP folder"):WaitForChild(a2, Util_upv_1.WaitForChildTimeout)
    assert(v10 ~= nil, "Failed to find RemoteEvent for RemoteProperty: " .. a2)
    return ClientRemoteProperty_upv_1.new(v10, a3, a4)
end
return tbl_1