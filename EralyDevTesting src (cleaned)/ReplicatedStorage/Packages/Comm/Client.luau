local util = require(script.Parent.Util)
require(script.Parent.Types)
local promise = require(script.Parent.Parent.Promise)
local script_client_remote_signal = require(script.ClientRemoteSignal)
local script_client_remote_property = require(script.ClientRemoteProperty)

return {
    GetFunction = function(parent: userdata, child_name: string, argument: boolean, argument_2: any, argument_3: any)
        assert(not util.IsServer, "GetFunction must be called from the client")
        local remote_function = util.GetCommSubFolder(parent, "RF")
            :Expect("Failed to get Comm RF folder")
            :WaitForChild(child_name, util.WaitForChildTimeout)
        assert(remote_function ~= nil, "Failed to find RemoteFunction: " .. child_name)
        local condition

        if type(argument_2) == "table" then
            condition = #argument_2 > 0
        else
            condition = false
        end

        local condition_2

        if type(argument_3) == "table" then
            condition_2 = #argument_3 > 0
        else
            condition_2 = false
        end

        local function process_outbound(argument_4)
            for _, callback in ipairs(argument_3) do
                local values = table.pack(callback(argument_4))

                if not values[1] then
                    return table.unpack(values, 2, values.n)
                end

                argument_4.n = #argument_4
            end

            return table.unpack(argument_4, 1, argument_4.n)
        end

        return condition
                and (argument and function(...)
                    local values = table.pack(...)

                    return promise.new(function(callback, callback_2)
                        local success, result = pcall(function()
                            if condition_2 then
                                return table.pack(remote_function:InvokeServer(process_outbound(values)))
                            end

                            return table.pack(remote_function:InvokeServer(table.unpack(values, 1, values.n)))
                        end)

                        if not success then
                            callback_2(result)

                            return
                        end

                        for _, callback_3 in ipairs(argument_2) do
                            local values_2 = table.pack(callback_3(result))

                            if not values_2[1] then
                                return table.unpack(values_2, 2, values_2.n)
                            end

                            result.n = #result
                        end

                        callback(table.unpack(result, 1, result.n))
                    end)
                end or function(...)
                    local values

                    if condition_2 then
                        values = table.pack(remote_function:InvokeServer(process_outbound(table.pack(...))))
                    else
                        values = table.pack(remote_function:InvokeServer(...))
                    end

                    for _, callback in ipairs(argument_2) do
                        local values_2 = table.pack(callback(values))

                        if not values_2[1] then
                            return table.unpack(values_2, 2, values_2.n)
                        end

                        values.n = #values
                    end

                    return table.unpack(values, 1, values.n)
                end)
            or (
                argument
                    and function(...)
                        local values = table.pack(...)

                        return promise.new(function(callback, callback_2)
                            local success, result = pcall(function()
                                if condition_2 then
                                    return table.pack(remote_function:InvokeServer(process_outbound(values)))
                                end

                                return table.pack(remote_function:InvokeServer(table.unpack(values, 1, values.n)))
                            end)

                            if success then
                                callback(table.unpack(result, 1, result.n))

                                return
                            end

                            callback_2(result)
                        end)
                    end
                or (
                    condition_2
                        and function(...)
                            return remote_function:InvokeServer(process_outbound(table.pack(...)))
                        end
                    or function(...)
                        return remote_function:InvokeServer(...)
                    end
                )
            )
    end,

    GetSignal = function(parent: userdata, child_name: string, argument: any, outbound: any)
        assert(not util.IsServer, "GetSignal must be called from the client")
        local re = util.GetCommSubFolder(parent, "RE")
            :Expect("Failed to get Comm RE folder")
            :WaitForChild(child_name, util.WaitForChildTimeout)
        assert(re ~= nil, "Failed to find RemoteEvent: " .. child_name)

        return script_client_remote_signal.new(re, argument, outbound)
    end,

    GetProperty = function(parent: userdata, child_name: string, argument: any, argument_2: any)
        assert(not util.IsServer, "GetProperty must be called from the client")
        local wait_for_child_result = util.GetCommSubFolder(parent, "RP")
            :Expect("Failed to get Comm RP folder")
            :WaitForChild(child_name, util.WaitForChildTimeout)
        assert(wait_for_child_result ~= nil, "Failed to find RemoteEvent for RemoteProperty: " .. child_name)

        return script_client_remote_property.new(wait_for_child_result, argument, argument_2)
    end,
}
