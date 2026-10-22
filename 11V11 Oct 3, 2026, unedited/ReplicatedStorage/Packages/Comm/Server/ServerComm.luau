--[[
    Script Path: Game/ReplicatedStorage/Packages/Comm/Server/ServerComm
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local Parent_upv_1 = require(script.Parent)
local _ = require(script.Parent.Parent.Types)
local Util_upv_1 = require(script.Parent.Parent.Util)
local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.new(a1, a2)
    --[[
      name: new
      line: 44
      upvalues:
        Util_upv_1 (copy, index: 1)
        tbl_upv_1 (copy, index: 2)
    ]]
    assert(Util_upv_1.IsServer, "ServerComm must be constructed from the server")
    local v1 = typeof(a1) == "Instance"
    assert(v1, "Parent must be of type Instance")
    local v2 = Util_upv_1.DefaultCommFolderName
    if a2 then
        v2 = a2
    end
    assert(not a1:FindFirstChild(v2), "Parent already has another ServerComm bound to namespace " .. v2)
    local v3 = setmetatable({}, tbl_upv_1)
    v3._instancesFolder = Instance.new("Folder")
    v3._instancesFolder.Name = v2
    v3._instancesFolder.Parent = a1
    return v3
end
function tbl_upv_1.BindFunction(a1, a2, a3, a4, a5)
    --[[
      name: BindFunction
      line: 76
      upvalues:
        Parent_upv_1 (copy, index: 1)
    ]]
    return Parent_upv_1.BindFunction(a1._instancesFolder, a2, a3, a4, a5)
end
function tbl_upv_1.WrapMethod(a1, a2, a3, a4, a5)
    --[[
      name: WrapMethod
      line: 108
      upvalues:
        Parent_upv_1 (copy, index: 1)
    ]]
    return Parent_upv_1.WrapMethod(a1._instancesFolder, a2, a3, a4, a5)
end
function tbl_upv_1.CreateSignal(a1, a2, a3, a4, a5)
    --[[
      name: CreateSignal
      line: 146
      upvalues:
        Parent_upv_1 (copy, index: 1)
    ]]
    return Parent_upv_1.CreateSignal(a1._instancesFolder, a2, a3, a4, a5)
end
function tbl_upv_1.CreateProperty(a1, a2, a3, a4, a5)
    --[[
      name: CreateProperty
      line: 195
      upvalues:
        Parent_upv_1 (copy, index: 1)
    ]]
    return Parent_upv_1.CreateProperty(a1._instancesFolder, a2, a3, a4, a5)
end
function tbl_upv_1.Destroy(a1)
    --[[
      name: Destroy
      line: 207
    ]]
    a1._instancesFolder:Destroy()
end
return tbl_upv_1