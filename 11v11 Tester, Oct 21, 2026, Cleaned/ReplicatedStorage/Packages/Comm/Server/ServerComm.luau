local script_parent = require(script.Parent)
require(script.Parent.Parent.Types)
local util = require(script.Parent.Parent.Util)
local server_comm = {}
server_comm.__index = server_comm

function server_comm.new(parent: userdata, argument: string?)
    assert(util.IsServer, "ServerComm must be constructed from the server")
    local is_instance = typeof(parent) == "Instance"
    assert(is_instance, "Parent must be of type Instance")
    local default_comm_folder_name = argument or util.DefaultCommFolderName
    local condition = not parent:FindFirstChild(default_comm_folder_name)
    assert(condition, "Parent already has another ServerComm bound to namespace " .. default_comm_folder_name)
    local instance = setmetatable({}, server_comm)
    instance._instancesFolder = Instance.new("Folder")
    instance._instancesFolder.Name = default_comm_folder_name
    instance._instancesFolder.Parent = parent

    return instance
end

function server_comm.BindFunction(
    argument: table,
    argument_2: string,
    argument_3: any,
    argument_4: any,
    argument_5: any
)
    return script_parent.BindFunction(argument._instancesFolder, argument_2, argument_3, argument_4, argument_5)
end

function server_comm.WrapMethod(
    argument: table,
    argument_2: table,
    argument_3: string,
    argument_4: any,
    argument_5: any
)
    return script_parent.WrapMethod(argument._instancesFolder, argument_2, argument_3, argument_4, argument_5)
end

function server_comm.CreateSignal(
    argument: table,
    argument_2: string,
    argument_3: boolean?,
    argument_4: any,
    argument_5: any
)
    return script_parent.CreateSignal(argument._instancesFolder, argument_2, argument_3, argument_4, argument_5)
end

function server_comm.CreateProperty(
    argument: table,
    argument_2: string,
    argument_3: any,
    argument_4: any,
    argument_5: any
)
    return script_parent.CreateProperty(argument._instancesFolder, argument_2, argument_3, argument_4, argument_5)
end

function server_comm.Destroy(argument)
    argument._instancesFolder:Destroy()
end

return server_comm
