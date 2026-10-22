local remote_property = require(script.RemoteProperty)
local remote_signal = require(script.RemoteSignal)
local _ = require(script.Parent.Types)
local util = require(script.Parent.Util)
local server = {}

function server.BindFunction(parent, name, on_server_invoke, argument, argument_2)
    assert(util.IsServer, "BindFunction must be called from the server")
    local parent_2 = util.GetCommSubFolder(parent, "RF"):Expect("Failed to get Comm RF folder")
    local remote_function = Instance.new("RemoteFunction")
    remote_function.Name = name
    local condition = (type(argument) == "table") and (#argument > 0)
    local condition_2 = (type(argument_2) == "table") and (#argument_2 > 0)

    local function process_outbound(argument_3, ...)
        local values = table.pack(...)
        local value = nil

        for _, callback in ipairs(argument_2) do
            value = table.pack(callback(argument_3, values))

            if value[1] then
                values.n = #values
                continue
            end

            return table.unpack(value, 2, value.n)
        end

        return table.unpack(values, 1, values.n)
    end

    if condition and condition_2 then
        function remote_function.OnServerInvoke(argument_3, ...)
            local values = table.pack(...)
            local value = nil

            for _, callback in ipairs(argument) do
                value = table.pack(callback(argument_3, values))

                if value[1] then
                    values.n = #values
                    continue
                end

                return table.unpack(value, 2, value.n)
            end

            return process_outbound(argument_3, on_server_invoke(argument_3, table.unpack(values, 1, values.n)))
        end
    elseif condition then
        function remote_function.OnServerInvoke(argument_3, ...)
            local values = table.pack(...)
            local value = nil

            for _, callback in ipairs(argument) do
                value = table.pack(callback(argument_3, values))

                if value[1] then
                    values.n = #values
                    continue
                end

                return table.unpack(value, 2, value.n)
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
end

function server.WrapMethod(argument, argument_2, name, argument_3, argument_4)
    assert(util.IsServer, "WrapMethod must be called from the server")
    local callback = argument_2[name]
    local is_function = type(callback) == "function"
    assert(is_function, "Value at index " .. name .. " must be a function; got " .. type(callback))

    return server.BindFunction(argument, name, function(...)
        return callback(argument_2, ...)
    end, argument_3, argument_4)
end

function server.CreateSignal(parent, name, enabled, argument, outbound)
    assert(util.IsServer, "CreateSignal must be called from the server")

    return (
        remote_signal.new(
            util.GetCommSubFolder(parent, "RE"):Expect("Failed to get Comm RE folder"),
            name,
            enabled,
            argument,
            outbound
        )
    )
end

function server.CreateProperty(parent, argument, argument_2, argument_3, argument_4)
    assert(util.IsServer, "CreateProperty must be called from the server")

    return (
        remote_property.new(
            util.GetCommSubFolder(parent, "RP"):Expect("Failed to get Comm RP folder"),
            argument,
            argument_2,
            argument_3,
            argument_4
        )
    )
end

return server
