local run_service = game:GetService("RunService")
local option = require(script.Parent.Parent.Option)
local util = {
    IsServer = run_service:IsServer(),
    WaitForChildTimeout = 60,
    DefaultCommFolderName = "__comm__",
    None = newproxy(),
}

function util.GetCommSubFolder(parent: userdata, child_name: string)
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
