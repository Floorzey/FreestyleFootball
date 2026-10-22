local util = require(script.Parent.Util)
local _ = require(script.Parent.Types)
local promise = require(script.Parent.Parent.Promise)
local client_remote_signal = require(script.ClientRemoteSignal)
local client_remote_property = require(script.ClientRemoteProperty)
local client = {}

function client.GetFunction(parent, child_name, argument, argument_2, argument_3)
    assert(not util.IsServer, "GetFunction must be called from the client")
    local remote_function = util.GetCommSubFolder(parent, "RF")
        :Expect("Failed to get Comm RF folder")
        :WaitForChild(child_name, util.WaitForChildTimeout)
    assert(remote_function ~= nil, "Failed to find RemoteFunction: " .. child_name)
    local condition = (type(argument_2) == "table") and (#argument_2 > 0)
    local condition_2 = (type(argument_3) == "table") and (#argument_3 > 0)

    local function process_outbound(argument_4)
        local value = nil

        for _, callback in ipairs(argument_3) do
            value = table.pack(callback(argument_4))

            if value[1] then
                argument_4.n = #argument_4
                continue
            end

            return table.unpack(value, 2, value.n)
        end

        return table.unpack(argument_4, 1, argument_4.n)
    end

    if condition then
        if argument then
            return function(...)
                local values = table.pack(...)

                return promise.new(function(callback, callback_2)
                    local success, value = pcall(function()
                        if condition_2 then
                            return table.pack(remote_function:InvokeServer(process_outbound(values)))
                        end

                        return table.pack(remote_function:InvokeServer(table.unpack(values, 1, values.n)))
                    end)

                    if success then
                        local value_2 = nil

                        for _, callback_3 in ipairs(argument_2) do
                            value_2 = table.pack(callback_3(value))

                            if value_2[1] then
                                value.n = #value
                                continue
                            end

                            return table.unpack(value_2, 2, value_2.n)
                        end

                        callback(table.unpack(value, 1, value.n))
                    else
                        callback_2(value)
                    end
                end)
            end
        end

        return function(...)
            local values

            if condition_2 then
                values = table.pack(remote_function:InvokeServer(process_outbound(table.pack(...))))
            else
                local values_2 = table.pack(remote_function:InvokeServer(...))
                values = values_2
            end

            local value = nil

            for _, callback in ipairs(argument_2) do
                value = table.pack(callback(values))

                if value[1] then
                    values.n = #values
                    continue
                end

                return table.unpack(value, 2, value.n)
            end

            return table.unpack(values, 1, values.n)
        end
    end

    if argument then
        return function(...)
            local values = table.pack(...)

            return promise.new(function(callback, callback_2)
                local success, value = pcall(function()
                    if condition_2 then
                        return table.pack(remote_function:InvokeServer(process_outbound(values)))
                    end

                    return table.pack(remote_function:InvokeServer(table.unpack(values, 1, values.n)))
                end)

                if success then
                    callback(table.unpack(value, 1, value.n))
                else
                    callback_2(value)
                end
            end)
        end
    elseif condition_2 then
        return function(...)
            return remote_function:InvokeServer(process_outbound(table.pack(...)))
        end
    else
        return function(...)
            return remote_function:InvokeServer(...)
        end
    end
end

function client.GetSignal(parent, child_name, argument, outbound)
    assert(not util.IsServer, "GetSignal must be called from the client")
    local re = util.GetCommSubFolder(parent, "RE")
        :Expect("Failed to get Comm RE folder")
        :WaitForChild(child_name, util.WaitForChildTimeout)
    assert(re ~= nil, "Failed to find RemoteEvent: " .. child_name)

    return client_remote_signal.new(re, argument, outbound)
end

function client.GetProperty(parent, child_name, argument, argument_2)
    assert(not util.IsServer, "GetProperty must be called from the client")
    local wait_for_child_result = util.GetCommSubFolder(parent, "RP")
        :Expect("Failed to get Comm RP folder")
        :WaitForChild(child_name, util.WaitForChildTimeout)
    assert(wait_for_child_result ~= nil, "Failed to find RemoteEvent for RemoteProperty: " .. child_name)

    return client_remote_property.new(wait_for_child_result, argument, argument_2)
end

return client
