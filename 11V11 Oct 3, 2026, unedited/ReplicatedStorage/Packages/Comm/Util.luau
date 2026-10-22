--[[
    Script Path: Game/ReplicatedStorage/Packages/Comm/Util
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local RunService_1 = game:GetService("RunService")
local Option_upv_1 = require(script.Parent.Parent.Option)
local tbl_upv_1 = {}
tbl_upv_1.IsServer = RunService_1:IsServer()
tbl_upv_1.WaitForChildTimeout = 60
tbl_upv_1.DefaultCommFolderName = "__comm__"
tbl_upv_1.None = newproxy()
function tbl_upv_1.GetCommSubFolder(a1, a2)
    --[[
      name: GetCommSubFolder
      line: 12
      upvalues:
        tbl_upv_1 (copy, index: 1)
        Option_upv_1 (copy, index: 2)
    ]]
    local v1
    if tbl_upv_1.IsServer then
        v1 = a1:FindFirstChild(a2)
        if not (v1) then
            v1 = Instance.new("Folder")
            v1.Name = a2
            v1.Parent = a1
        end
    else
        v1 = a1:WaitForChild(a2, tbl_upv_1.WaitForChildTimeout)
    end
    return Option_upv_1.Wrap(v1)
end
return tbl_upv_1