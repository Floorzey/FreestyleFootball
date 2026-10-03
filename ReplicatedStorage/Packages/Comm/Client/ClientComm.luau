--[[
    Script Path: Game/ReplicatedStorage/Packages/Comm/Client/ClientComm
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local Parent_upv_1 = require(script.Parent)
local Util_upv_1 = require(script.Parent.Parent.Util)
local _ = require(script.Parent.Parent.Types)
local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.new(a1, a2, a3)
    --[[
      name: new
      line: 46
      upvalues:
        Util_upv_1 (copy, index: 1)
        tbl_upv_1 (copy, index: 2)
    ]]
    assert(not Util_upv_1.IsServer, "ClientComm must be constructed from the client")
    local v1 = typeof(a1) == "Instance"
    assert(v1, "Parent must be of type Instance")
    local v2 = Util_upv_1.DefaultCommFolderName
    if a3 then
        v2 = a3
    end
    local v3 = a1:WaitForChild(v2, Util_upv_1.WaitForChildTimeout)
    assert(v3 ~= nil, "Could not find namespace for ClientComm in parent: " .. v2)
    local v4 = setmetatable({}, tbl_upv_1)
    v4._instancesFolder = v3
    v4._usePromise = a2
    return v4
end
function tbl_upv_1.GetFunction(a1, a2, a3, a4)
    --[[
      name: GetFunction
      line: 95
      upvalues:
        Parent_upv_1 (copy, index: 1)
    ]]
    return Parent_upv_1.GetFunction(a1._instancesFolder, a2, a1._usePromise, a3, a4)
end
function tbl_upv_1.GetSignal(a1, a2, a3, a4)
    --[[
      name: GetSignal
      line: 123
      upvalues:
        Parent_upv_1 (copy, index: 1)
    ]]
    return Parent_upv_1.GetSignal(a1._instancesFolder, a2, a3, a4)
end
function tbl_upv_1.GetProperty(a1, a2, a3, a4)
    --[[
      name: GetProperty
      line: 165
      upvalues:
        Parent_upv_1 (copy, index: 1)
    ]]
    return Parent_upv_1.GetProperty(a1._instancesFolder, a2, a3, a4)
end
function tbl_upv_1.BuildObject(a1, a2, a3)
    --[[
      name: BuildObject
      line: 192
    ]]
    local tbl_2 = {}
    local RF_1 = a1._instancesFolder:FindFirstChild("RF")
    local RE_1 = a1._instancesFolder:FindFirstChild("RE")
    local RP_1 = a1._instancesFolder:FindFirstChild("RP")
    if RF_1 then
        for _, value_1 in ipairs(RF_1:GetChildren()) do
            if value_1:IsA("RemoteFunction") then
                local u1 = a1:GetFunction(value_1.Name, a2, a3)
                tbl_2[value_1.Name] = function(a4, ...)
                    --[[
                      line: 203
                      upvalues:
                        u1 (copy, index: 1)
                    ]]
                    return u1(...)
                end
            end
        end
    end
    if RE_1 then
        for _, value_2 in ipairs(RE_1:GetChildren()) do
            if value_2:IsA("RemoteEvent") then
                tbl_2[value_2.Name] = a1:GetSignal(value_2.Name, a2, a3)
            end
        end
    end
    if RP_1 then
        for _, value_3 in ipairs(RP_1:GetChildren()) do
            if value_3:IsA("RemoteEvent") then
                tbl_2[value_3.Name] = a1:GetProperty(value_3.Name, a2, a3)
            end
        end
    end
    return tbl_2
end
function tbl_upv_1.Destroy(a1)
    --[[
      name: Destroy
      line: 230
    ]]
end
return tbl_upv_1