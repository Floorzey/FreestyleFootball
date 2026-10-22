local run_service = game:GetService("RunService")
local option = require(script.Parent.Parent.Option)
local util = {}
util.IsServer = run_service:IsServer()
util.WaitForChildTimeout = 60
util.DefaultCommFolderName = "__comm__"
util.None = newproxy()

function util.GetCommSubFolder(parent, child_name)
    local first_child
    if util.IsServer then
        first_child = parent:FindFirstChild(child_name)
        if not first_child then
            first_child = Instance.new("Folder")
            first_child.Name = child_name
            first_child.Parent = parent
        end
    else
        first_child = parent:WaitForChild(child_name, util.WaitForChildTimeout)
    end
    return option.Wrap(first_child)
end

return util
