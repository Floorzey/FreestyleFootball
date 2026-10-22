local parent = require(script.Parent)
local _ = require(script.Parent.Parent.Types)
local util = require(script.Parent.Parent.Util)
local server_comm = {}
server_comm.__index = server_comm

function server_comm.new(parent_2, argument)
    assert(util.IsServer, "ServerComm must be constructed from the server")
    local is_instance = typeof(parent_2) == "Instance"
    assert(is_instance, "Parent must be of type Instance")
    local default_comm_folder_name = util.DefaultCommFolderName

    if argument then
        default_comm_folder_name = argument
    end

    assert(
        not parent_2:FindFirstChild(default_comm_folder_name),
        "Parent already has another ServerComm bound to namespace " .. default_comm_folder_name
    )
    local instance = setmetatable({}, server_comm)
    instance._instancesFolder = Instance.new("Folder")
    instance._instancesFolder.Name = default_comm_folder_name
    instance._instancesFolder.Parent = parent_2

    return instance
end

function server_comm.BindFunction(argument, argument_2, argument_3, argument_4, argument_5)
    return parent.BindFunction(argument._instancesFolder, argument_2, argument_3, argument_4, argument_5)
end

function server_comm.WrapMethod(argument, argument_2, argument_3, argument_4, argument_5)
    return parent.WrapMethod(argument._instancesFolder, argument_2, argument_3, argument_4, argument_5)
end

function server_comm.CreateSignal(argument, argument_2, argument_3, argument_4, argument_5)
    return parent.CreateSignal(argument._instancesFolder, argument_2, argument_3, argument_4, argument_5)
end

function server_comm.CreateProperty(argument, argument_2, argument_3, argument_4, argument_5)
    return parent.CreateProperty(argument._instancesFolder, argument_2, argument_3, argument_4, argument_5)
end

function server_comm.Destroy(argument)
    argument._instancesFolder:Destroy()
end

return server_comm
