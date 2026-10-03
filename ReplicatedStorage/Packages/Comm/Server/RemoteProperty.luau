--[[
    Script Path: Game/ReplicatedStorage/Packages/Comm/Server/RemoteProperty
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local Players_upv_1 = game:GetService("Players")
local Util_1 = require(script.Parent.Parent.Util)
local _ = require(script.Parent.Parent.Types)
local RemoteSignal_upv_1 = require(script.Parent.RemoteSignal)
local None_upv_1 = Util_1.None
local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.new(a1, a2, a3, a4, a5)
    --[[
      name: new
      line: 53
      upvalues:
        tbl_upv_1 (copy, index: 1)
        RemoteSignal_upv_1 (copy, index: 2)
        Players_upv_1 (copy, index: 3)
        None_upv_1 (copy, index: 4)
    ]]
    local u1 = setmetatable({}, tbl_upv_1)
    u1._rs = RemoteSignal_upv_1.new(a1, a2, a4, a5)
    u1._value = a3
    u1._perPlayer = {}
    u1._playerRemoving = Players_upv_1.PlayerRemoving:Connect(
        function(a6)
            --[[
              line: 64
              upvalues:
                u1 (copy, index: 1)
            ]]
            u1._perPlayer[a6] = nil
        end
    )
    u1._rs:Connect(
        function(a7)
            --[[
              line: 67
              upvalues:
                u1 (copy, index: 1)
                None_upv_1 (copy, index: 2)
            ]]
            local v1 = u1._perPlayer[a7]
            local v2
            if v1 == nil then
                v2 = u1._value
            elseif v1 ~= None_upv_1 then
                v2 = v1
            else
                v2 = nil
            end
            u1._rs:Fire(a7, v2)
        end
    )
    return u1
end
function tbl_upv_1.Set(a1, a2)
    --[[
      name: Set
      line: 91
    ]]
    a1._value = a2
    table.clear(a1._perPlayer)
    a1._rs:FireAll(a2)
end
function tbl_upv_1.SetTop(a1, a2)
    --[[
      name: SetTop
      line: 118
      upvalues:
        Players_upv_1 (copy, index: 1)
    ]]
    a1._value = a2
    for _, value_1 in ipairs(Players_upv_1:GetPlayers()) do
        if a1._perPlayer[value_1] == nil then
            a1._rs:Fire(value_1, a2)
        end
    end
end
function tbl_upv_1.SetFilter(a1, a2, a3)
    --[[
      name: SetFilter
      line: 141
      upvalues:
        Players_upv_1 (copy, index: 1)
    ]]
    for _, value_2 in ipairs(Players_upv_1:GetPlayers()) do
        if a2(value_2, a3) then
            a1:SetFor(value_2, a3)
        end
    end
end
function tbl_upv_1.SetFor(a1, a2, a3)
    --[[
      name: SetFor
      line: 163
      upvalues:
        None_upv_1 (copy, index: 1)
    ]]
    if a2.Parent then
        local _perPlayer_1 = a1._perPlayer
        local v3
        if a3 ~= nil then
            v3 = a3
        else
            v3 = None_upv_1
        end
        _perPlayer_1[a2] = v3
    end
    a1._rs:Fire(a2, a3)
end
function tbl_upv_1.SetForList(a1, a2, a3)
    --[[
      name: SetForList
      line: 179
    ]]
    for _, value_3 in ipairs(a2) do
        a1:SetFor(value_3, a3)
    end
end
function tbl_upv_1.ClearFor(a1, a2)
    --[[
      name: ClearFor
      line: 206
    ]]
    if a1._perPlayer[a2] == nil then
        return
    end
    a1._perPlayer[a2] = nil
    a1._rs:Fire(a2, a1._value)
end
function tbl_upv_1.ClearForList(a1, a2)
    --[[
      name: ClearForList
      line: 219
    ]]
    for _, value_4 in ipairs(a2) do
        a1:ClearFor(value_4)
    end
end
function tbl_upv_1.ClearFilter(a1, a2)
    --[[
      name: ClearFilter
      line: 229
      upvalues:
        Players_upv_1 (copy, index: 1)
    ]]
    for _, value_5 in ipairs(Players_upv_1:GetPlayers()) do
        if a2(value_5) then
            a1:ClearFor(value_5)
        end
    end
end
function tbl_upv_1.Get(a1)
    --[[
      name: Get
      line: 247
    ]]
    return a1._value
end
function tbl_upv_1.GetFor(a1, a2)
    --[[
      name: GetFor
      line: 281
      upvalues:
        None_upv_1 (copy, index: 1)
    ]]
    local v4 = a1._perPlayer[a2]
    if v4 ~= nil then
        if v4 ~= None_upv_1 then
            return v4
        end
        return nil
    end
    return a1._value
end
function tbl_upv_1.Destroy(a1)
    --[[
      name: Destroy
      line: 290
    ]]
    a1._rs:Destroy()
    a1._playerRemoving:Disconnect()
end
return tbl_upv_1