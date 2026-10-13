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
        local matches = value ~= instance._value
        instance._value = value
        if not instance._ready then
            instance._ready = true
            callback(value)
        end
        if not matches then
            return
        end
        instance.Changed:Fire(value)
    end)
    return instance
end

function client_remote_property.Get(self)
    return self._value
end

function client_remote_property.OnReady(self)
    return self._readyPromise
end

function client_remote_property.IsReady(self)
    return self._ready
end

function client_remote_property.Observe(self, argument)
    if self._ready then
        task.defer(argument, self._value)
    end
    return self.Changed:Connect(argument)
end

function client_remote_property.Destroy(self)
    self._rs:Destroy()
    if self._readyPromise then
        self._readyPromise:cancel()
    end
    if self._changed then
        self._changed:Disconnect()
    end
    self.Changed:Destroy()
end

return client_remote_property
