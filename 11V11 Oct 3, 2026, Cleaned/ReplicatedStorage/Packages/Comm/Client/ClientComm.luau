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

function client_comm.GetFunction(self, argument, argument_2, argument_3)
    return parent.GetFunction(self._instancesFolder, argument, self._usePromise, argument_2, argument_3)
end

function client_comm.GetSignal(self, argument, argument_2, argument_3)
    return parent.GetSignal(self._instancesFolder, argument, argument_2, argument_3)
end

function client_comm.GetProperty(self, argument, argument_2, argument_3)
    return parent.GetProperty(self._instancesFolder, argument, argument_2, argument_3)
end

function client_comm.BuildObject(self, argument, argument_2)
    local values = {}
    local rf = self._instancesFolder:FindFirstChild("RF")
    local re = self._instancesFolder:FindFirstChild("RE")
    local rp = self._instancesFolder:FindFirstChild("RP")
    if rf then
        for _, child in ipairs(rf:GetChildren()) do
            if child:IsA("RemoteFunction") then
                local function_value = self:GetFunction(child.Name, argument, argument_2)
                values[child.Name] = function(argument_3, ...)
                    return function_value(...)
                end
            end
        end
    end
    if re then
        for _, child_2 in ipairs(re:GetChildren()) do
            if child_2:IsA("RemoteEvent") then
                values[child_2.Name] = self:GetSignal(child_2.Name, argument, argument_2)
            end
        end
    end
    if rp then
        for _, child_3 in ipairs(rp:GetChildren()) do
            if child_3:IsA("RemoteEvent") then
                values[child_3.Name] = self:GetProperty(child_3.Name, argument, argument_2)
            end
        end
    end
    return values
end

function client_comm.Destroy(self) end

return client_comm
