local script_remote_property = require(script.RemoteProperty)
local script_remote_signal = require(script.RemoteSignal)
require(script.Parent.Types)
local util = require(script.Parent.Util)
local server = {
    BindFunction = function(parent: userdata, name: string, on_server_invoke: any, argument: any, argument_2: any)
        assert(util.IsServer, "BindFunction must be called from the server")
        local parent_2 = util.GetCommSubFolder(parent, "RF"):Expect("Failed to get Comm RF folder")
        local remote_function = Instance.new("RemoteFunction")
        remote_function.Name = name
        local condition

        if type(argument) == "table" then
            condition = #argument > 0
        else
            condition = false
        end

        local condition_2

        if type(argument_2) == "table" then
            condition_2 = #argument_2 > 0
        else
            condition_2 = false
        end

        local function process_outbound(argument_3, ...)
            local values = table.pack(...)

            for _, callback in ipairs(argument_2) do
                local values_2 = table.pack(callback(argument_3, values))

                if not values_2[1] then
                    return table.unpack(values_2, 2, values_2.n)
                end

                values.n = #values
            end

            return table.unpack(values, 1, values.n)
        end

        if condition and condition_2 then
            function remote_function.OnServerInvoke(argument_3, ...)
                local values = table.pack(...)

                for _, callback in ipairs(argument) do
                    local values_2 = table.pack(callback(argument_3, values))

                    if not values_2[1] then
                        return table.unpack(values_2, 2, values_2.n)
                    end

                    values.n = #values
                end

                return process_outbound(argument_3, on_server_invoke(argument_3, table.unpack(values, 1, values.n)))
            end
        elseif condition then
            function remote_function.OnServerInvoke(argument_3, ...)
                local values = table.pack(...)

                for _, callback in ipairs(argument) do
                    local values_2 = table.pack(callback(argument_3, values))

                    if not values_2[1] then
                        return table.unpack(values_2, 2, values_2.n)
                    end

                    values.n = #values
                end

                return on_server_invoke(argument_3, table.unpack(values, 1, values.n))
            end
        elseif condition_2 then
            function remote_function.OnServerInvoke(argument_3, ...)
                return process_outbound(argument_3, on_server_invoke(argument_3, ...))
            end
        else
            remote_function.OnServerInvoke = on_server_invoke
        end

        remote_function.Parent = parent_2

        return remote_function
    end,
}

function server.WrapMethod(argument: userdata, argument_2: table, argument_3: string, argument_4: any, argument_5: any)
    assert(util.IsServer, "WrapMethod must be called from the server")
    local callback = argument_2[argument_3]
    local is_function = type(callback) == "function"
    local text = "Value at index " .. argument_3 .. " must be a function; got " .. type(callback)
    assert(is_function, text)

    return server.BindFunction(argument, argument_3, function(...)
        return callback(argument_2, ...)
    end, argument_4, argument_5)
end

function server.CreateSignal(parent: userdata, name: string, enabled: boolean?, argument: any, outbound: any)
    assert(util.IsServer, "CreateSignal must be called from the server")
    local parent_2 = util.GetCommSubFolder(parent, "RE"):Expect("Failed to get Comm RE folder")

    return script_remote_signal.new(parent_2, name, enabled, argument, outbound)
end

function server.CreateProperty(parent: userdata, argument: string, argument_2: any, argument_3: any, argument_4: any)
    assert(util.IsServer, "CreateProperty must be called from the server")
    local expect_result = util.GetCommSubFolder(parent, "RP"):Expect("Failed to get Comm RP folder")

    return script_remote_property.new(expect_result, argument, argument_2, argument_3, argument_4)
end

return server
