local parent = require(script.Parent)
local util = require(script.Parent.Parent.Util)
local _ = require(script.Parent.Parent.Types)
local client_comm = {}
client_comm.__index = client_comm

function client_comm.new(argument, use_promise, argument_2)
    assert(not util.IsServer, "ClientComm must be constructed from the client")
    local is_instance = typeof(argument) == "Instance"
    assert(is_instance, "Parent must be of type Instance")
    local default_comm_folder_name = util.DefaultCommFolderName

    if argument_2 then
        default_comm_folder_name = argument_2
    end

    local instances_folder = argument:WaitForChild(default_comm_folder_name, util.WaitForChildTimeout)
    assert(instances_folder ~= nil, "Could not find namespace for ClientComm in parent: " .. default_comm_folder_name)
    local instance = setmetatable({}, client_comm)
    instance._instancesFolder = instances_folder
    instance._usePromise = use_promise

    return instance
end

function client_comm.GetFunction(argument, argument_2, argument_3, argument_4)
    return parent.GetFunction(argument._instancesFolder, argument_2, argument._usePromise, argument_3, argument_4)
end

function client_comm.GetSignal(argument, argument_2, argument_3, argument_4)
    return parent.GetSignal(argument._instancesFolder, argument_2, argument_3, argument_4)
end

function client_comm.GetProperty(argument, argument_2, argument_3, argument_4)
    return parent.GetProperty(argument._instancesFolder, argument_2, argument_3, argument_4)
end

function client_comm.BuildObject(argument, argument_2, argument_3)
    local values = {}
    local rf = argument._instancesFolder:FindFirstChild("RF")
    local re = argument._instancesFolder:FindFirstChild("RE")
    local rp = argument._instancesFolder:FindFirstChild("RP")

    if rf then
        for _, child in ipairs(rf:GetChildren()) do
            if child:IsA("RemoteFunction") then
                local function_value = argument:GetFunction(child.Name, argument_2, argument_3)
                values[child.Name] = function(argument_4, ...)
                    return function_value(...)
                end
            end
        end
    end

    if re then
        for _, child_2 in ipairs(re:GetChildren()) do
            if child_2:IsA("RemoteEvent") then
                values[child_2.Name] = argument:GetSignal(child_2.Name, argument_2, argument_3)
            end
        end
    end

    if rp then
        for _, child_3 in ipairs(rp:GetChildren()) do
            if child_3:IsA("RemoteEvent") then
                values[child_3.Name] = argument:GetProperty(child_3.Name, argument_2, argument_3)
            end
        end
    end

    return values
end

function client_comm.Destroy(argument) end

return client_comm
