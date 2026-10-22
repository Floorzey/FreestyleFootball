local promise = require(script.Parent.Parent.Parent.Promise)
local signal = require(script.Parent.Parent.Parent.Signal)
local client_remote_signal = require(script.Parent.ClientRemoteSignal)
local _ = require(script.Parent.Parent.Types)
local client_remote_property = {}
client_remote_property.__index = client_remote_property

function client_remote_property.new(re, argument, outbound)
    local instance = setmetatable({}, client_remote_property)
    instance._rs = client_remote_signal.new(re, argument, outbound)
    instance._ready = false
    instance._value = nil
    instance.Changed = signal.new()
    instance._rs:Fire()
    local callback = nil
    instance._readyPromise = promise.new(function(argument_2)
        callback = argument_2
    end)
    instance._changed = instance._rs:Connect(function(value)
        local condition = value ~= instance._value
        instance._value = value

        if not instance._ready then
            instance._ready = true
            callback(value)
        end

        if not condition then
            return
        end

        instance.Changed:Fire(value)
    end)

    return instance
end

function client_remote_property.Get(argument)
    return argument._value
end

function client_remote_property.OnReady(argument)
    return argument._readyPromise
end

function client_remote_property.IsReady(argument)
    return argument._ready
end

function client_remote_property.Observe(argument, argument_2)
    if argument._ready then
        task.defer(argument_2, argument._value)
    end

    return argument.Changed:Connect(argument_2)
end

function client_remote_property.Destroy(argument)
    argument._rs:Destroy()

    if argument._readyPromise then
        argument._readyPromise:cancel()
    end

    if argument._changed then
        argument._changed:Disconnect()
    end

    argument.Changed:Destroy()
end

return client_remote_property
