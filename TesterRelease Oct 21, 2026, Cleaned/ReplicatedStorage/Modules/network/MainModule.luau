local script_signal = require(script.Signal)
local script_task = require(script.Task)
local script_types = require(script.Types)
local callback = nil
local callback_2 = nil
local callback_3 = nil
local callback_4 = nil
local value = nil
local run_service = game:GetService("RunService")
local players = game:GetService("Players")
local reads = script_types.Reads
local writes = script_types.Writes
local import = script_types.Import
local export_value = script_types.Export
local truncate = script_types.Truncate
local ended = script_types.Ended
local number_u8 = reads.NumberU8
local number_u82 = writes.NumberU8
local number_u16 = reads.NumberU16
local number_u162 = writes.NumberU16
local values = {}
local values_2 = {}
local value_2 = nil
local value_3 = nil
local value_4 = nil
local remote_event = nil
local attribute_value = nil
local values_3 = {
    BufferLength = 128,
    BufferOffset = 0,
    InstancesOffset = 0,
    Buffer = buffer.create(128),
    Instances = {},
}

local function constructor(argument: any, attribute_name: string, ...)
    local value_entry = values_2[attribute_name]

    if value_entry then
        return value_entry
    end

    local instance = setmetatable({}, values)
    instance.Name = attribute_name

    if run_service:IsServer() then
        instance.Id = attribute_value
        instance.OnServerEvent = script_signal()
        remote_event:SetAttribute(attribute_name, attribute_value)
        values_2[attribute_value] = instance
        attribute_value = attribute_value + 1
    else
        instance.Id = remote_event:GetAttribute(attribute_name)
        instance.OnClientEvent = script_signal()

        if instance.Id then
            values_2[instance.Id] = instance
        end
    end

    local reads_2, writes_2 = callback(table.pack(...))
    instance.Reads = reads_2
    instance.Writes = writes_2
    values_2[instance.Name] = instance

    return instance
end

values.__index = values
values.Type = "Packet"

function values.Response(argument, ...)
    argument.ResponseTimeout = argument.ResponseTimeout or 10
    local response_reads, response_writes = callback(table.pack(...))
    argument.ResponseReads = response_reads
    argument.ResponseWrites = response_writes

    return argument
end

function values.Fire(argument, ...)
    if not argument.ResponseReads then
        import(values_3)
        number_u82(argument.Id)
        callback_4(argument.Writes, { ... })
        values_3 = export_value()

        return
    end

    if run_service:IsServer() then
        error("You must use FireClient(player)", 2)
    end

    local value_8 = nil

    for index = 1, 128 do
        value_8 = value_4[value_4.Index]

        if not value_8 then
            break
        end

        value_4.Index = (value_4.Index + 1) % 128
        local _ = index
    end

    if value_8 then
        error("Cannot have more than 128 yielded threads", 2)
    end

    import(values_3)
    number_u82(argument.Id)
    number_u82(value_4.Index)
    value_4[value_4.Index] = {
        Yielded = coroutine.running(),
        Timeout = script_task:Delay(
            argument.ResponseTimeout,
            value,
            value_4,
            value_4.Index,
            argument.ResponseTimeoutValue
        ),
    }
    value_4.Index = (value_4.Index + 1) % 128
    callback_4(argument.Writes, { ... })
    values_3 = export_value()

    return coroutine.yield()
end

function values.FireClient(argument, argument_2, ...)
    if argument_2.Parent == nil then
        return
    end

    if not argument.ResponseReads then
        import(value_2[argument_2] or {
            BufferLength = 128,
            BufferOffset = 0,
            InstancesOffset = 0,
            Buffer = buffer.create(128),
            Instances = {},
        })
        number_u82(argument.Id)
        callback_4(argument.Writes, { ... })
        value_2[argument_2] = export_value()

        return
    end

    local entry = value_3[argument_2]

    if entry == nil then
        entry = {
            Index = 0,
        }
        value_3[argument_2] = entry
    end

    local value_8 = nil

    for index = 1, 128 do
        value_8 = entry[entry.Index]

        if not value_8 then
            break
        end

        entry.Index = (entry.Index + 1) % 128
        local _ = index
    end

    if not value_8 then
        import(value_2[argument_2] or {
            BufferLength = 128,
            BufferOffset = 0,
            InstancesOffset = 0,
            Buffer = buffer.create(128),
            Instances = {},
        })
        number_u82(argument.Id)
        number_u82(entry.Index)
        entry[entry.Index] = {
            Yielded = coroutine.running(),
            Timeout = script_task:Delay(
                argument.ResponseTimeout,
                value,
                entry,
                entry.Index,
                argument.ResponseTimeoutValue
            ),
        }
        entry.Index = (entry.Index + 1) % 128
        callback_4(argument.Writes, { ... })
        value_2[argument_2] = export_value()

        return coroutine.yield()
    end

    error("Cannot have more than 128 yielded threads", 2)
end

function values.Serialize(argument, ...)
    import({
        BufferLength = 128,
        BufferOffset = 0,
        InstancesOffset = 0,
        Buffer = buffer.create(128),
        Instances = {},
    })
    callback_4(argument.Writes, { ... })

    return truncate()
end

function values.Deserialize(argument, buffer_2, instances)
    import({
        BufferOffset = 0,
        InstancesOffset = 0,
        Buffer = buffer_2,
        BufferLength = buffer.len(buffer_2),
        Instances = instances or {},
    })

    return callback_3(argument.Reads)
end

callback = function(argument: table)
    local create_result = table.create(#argument)
    local create_result_2 = table.create(#argument)

    for index, item in ipairs(argument) do
        if type(item) == "table" then
            local result, value_8 = callback_2(item)
            create_result[index] = result
            create_result_2[index] = value_8
        else
            local write_entry = writes[item]
            create_result[index] = reads[item]
            create_result_2[index] = write_entry
        end
    end

    return create_result, create_result_2
end

callback_2 = function(argument: table)
    if #argument == 1 then
        local argument_entry = argument[1]
        local callback_5, callback_6

        if type(argument_entry) == "table" then
            callback_5, callback_6 = callback_2(argument_entry)
        else
            callback_5 = reads[argument_entry]
            callback_6 = writes[argument_entry]
        end

        return function()
            local result_2 = number_u16()
            local create_result_3 = table.create(result_2)

            for index = 1, result_2 do
                create_result_3[index] = callback_5()
                local _ = index
            end

            return create_result_3
        end, function(argument_2: table)
            number_u162(#argument_2)

            for _, item_2 in argument_2 do
                callback_6(item_2)
            end
        end
    end

    local items = {}

    for key, _ in argument do
        table.insert(items, key)
    end

    table.sort(items)
    local create_result = table.create(#items)
    local create_result_2 = table.create(#items)

    for key_2, item in items do
        local argument_entry_2 = argument[item]

        if type(argument_entry_2) == "table" then
            local result, value_8 = callback_2(argument_entry_2)
            create_result[key_2] = result
            create_result_2[key_2] = value_8
        else
            local write_entry = writes[argument_entry_2]
            create_result[key_2] = reads[argument_entry_2]
            create_result_2[key_2] = write_entry
        end
    end

    return function()
        local values_5 = {}

        for key_3, callback_7 in create_result do
            values_5[items[key_3]] = callback_7()
        end

        return values_5
    end, function(argument_2: table)
        for key_3, callback_7 in create_result_2 do
            callback_7(argument_2[items[key_3]])
        end
    end
end

callback_3 = function(argument: table)
    local create_result = table.create(#argument)

    for key, callback_5 in argument do
        create_result[key] = callback_5()
    end

    return table.unpack(create_result)
end

callback_4 = function(argument: table, argument_2: table)
    for key, callback_5 in argument do
        callback_5(argument_2[key])
    end
end

value = function(argument: table, argument_2: number, argument_3: any)
    task.defer(argument[argument_2].Yielded, argument_3)
    argument[argument_2] = nil
end

if run_service:IsServer() then
    value_2 = {}
    value_3 = {}
    attribute_value = 0
    remote_event = Instance.new("RemoteEvent", script)
    local values_4 = {}
    local spawn_result = task.spawn(function()
        while true do
            coroutine.yield()

            if values_3.BufferOffset > 0 then
                local create_result = buffer.create(values_3.BufferOffset)
                buffer.copy(create_result, 0, values_3.Buffer, 0, values_3.BufferOffset)

                if values_3.InstancesOffset == 0 then
                    remote_event:FireAllClients(create_result)
                else
                    remote_event:FireAllClients(create_result, values_3.Instances)
                    values_3.InstancesOffset = 0
                    table.clear(values_3.Instances)
                end

                values_3.BufferOffset = 0
            end

            for key, item in value_2 do
                local create_result_2 = buffer.create(item.BufferOffset)
                buffer.copy(create_result_2, 0, item.Buffer, 0, item.BufferOffset)

                if item.InstancesOffset == 0 then
                    remote_event:FireClient(key, create_result_2)
                else
                    remote_event:FireClient(key, create_result_2, item.Instances)
                end
            end

            table.clear(value_2)
            table.clear(values_4)
        end
    end)

    local function value_5(argument: table, argument_2: userdata, argument_3: number, ...)
        if argument.OnServerInvoke == nil then
            if run_service:IsStudio() then
                warn("OnServerInvoke not found for packet:", argument.Name, "discarding event:", ...)
            end

            return
        end

        local values_5 = { argument.OnServerInvoke(argument_2, ...) }

        if argument_2.Parent == nil then
            return
        end

        import(value_2[argument_2] or {
            BufferLength = 128,
            BufferOffset = 0,
            InstancesOffset = 0,
            Buffer = buffer.create(128),
            Instances = {},
        })
        number_u82(argument.Id)
        number_u82(argument_3 + 128)
        callback_4(argument.ResponseWrites, values_5)
        value_2[argument_2] = export_value()
    end

    local function value_6(argument: userdata, buffer_2: buffer, instances: table?)
        local value_entry = values_4[argument] or 0
        local length = buffer.len(buffer_2)
        local sum = value_entry + math.max(length, 800)

        if sum > 8000 then
            if run_service:IsStudio() then
                warn(argument.Name, "is exceeding the data/rate limit; some events may be dropped")
            end

            return
        end

        values_4[argument] = sum
        import({
            BufferOffset = 0,
            InstancesOffset = 0,
            Buffer = buffer_2,
            BufferLength = buffer.len(buffer_2),
            Instances = instances or {},
        })

        while ended() == false do
            local value_entry_2 = values_2[number_u8()]

            if value_entry_2.ResponseReads then
                local result = number_u8()

                if result < 128 then
                    script_task:Defer(value_5, value_entry_2, argument, result, callback_3(value_entry_2.Reads))
                else
                    local difference = result - 128
                    local entry_entry = value_3[argument][difference]

                    if entry_entry then
                        task.cancel(entry_entry.Timeout)
                        task.defer(entry_entry.Yielded, callback_3(value_entry_2.ResponseReads))
                        value_3[argument][difference] = nil
                    elseif run_service:IsStudio() then
                        warn(
                            "Response thread not found for packet:",
                            value_entry_2.Name,
                            "discarding response:",
                            callback_3(value_entry_2.ResponseReads)
                        )
                    else
                        callback_3(value_entry_2.ResponseReads)
                    end
                end
            else
                value_entry_2.OnServerEvent:Fire(argument, callback_3(value_entry_2.Reads))
            end
        end
    end

    remote_event.OnServerEvent:Connect(function(player: userdata, ...)
        local _, result = pcall(value_6, player, ...)

        if result and run_service:IsStudio() then
            warn(player.Name, result)
        end
    end)

    players.PlayerRemoving:Connect(function(player)
        value_2[player] = nil
        value_3[player] = nil
        values_4[player] = nil
    end)

    run_service.Heartbeat:Connect(function(delta_time)
        task.defer(spawn_result)
    end)
else
    value_4 = {
        Index = 0,
    }
    remote_event = script:WaitForChild("RemoteEvent")
    local number = 0
    local spawn_result_2 = task.spawn(function()
        while true do
            repeat
                coroutine.yield()
            until values_3.BufferOffset > 0

            local create_result = buffer.create(values_3.BufferOffset)
            buffer.copy(create_result, 0, values_3.Buffer, 0, values_3.BufferOffset)

            if values_3.InstancesOffset == 0 then
                remote_event:FireServer(create_result)
            else
                remote_event:FireServer(create_result, values_3.Instances)
                values_3.InstancesOffset = 0
                table.clear(values_3.Instances)
            end

            values_3.BufferOffset = 0
        end
    end)

    local function value_7(argument: table, argument_2: number, ...)
        if argument.OnClientInvoke == nil then
            warn("OnClientInvoke not found for packet:", argument.Name, "discarding event:", ...)

            return
        end

        local values_5 = { argument.OnClientInvoke(...) }
        import(values_3)
        number_u82(argument.Id)
        number_u82(argument_2 + 128)
        callback_4(argument.ResponseWrites, values_5)
        values_3 = export_value()
    end

    remote_event.OnClientEvent:Connect(function(buffer_2: buffer, instances: table?)
        import({
            BufferOffset = 0,
            InstancesOffset = 0,
            Buffer = buffer_2,
            BufferLength = buffer.len(buffer_2),
            Instances = instances or {},
        })

        while ended() == false do
            local value_entry = values_2[number_u8()]

            if value_entry.ResponseReads then
                local result = number_u8()

                if result < 128 then
                    script_task:Defer(value_7, value_entry, result, callback_3(value_entry.Reads))
                else
                    local difference = result - 128
                    local entry = value_4[difference]

                    if entry then
                        task.cancel(entry.Timeout)
                        task.defer(entry.Yielded, callback_3(value_entry.ResponseReads))
                        value_4[difference] = nil
                    else
                        warn(
                            "Response thread not found for packet:",
                            value_entry.Name,
                            "discarding response:",
                            callback_3(value_entry.ResponseReads)
                        )
                    end
                end
            else
                value_entry.OnClientEvent:Fire(callback_3(value_entry.Reads))
            end
        end
    end)

    remote_event.AttributeChanged:Connect(function(attribute_name)
        local value_entry = values_2[attribute_name]

        if not value_entry then
            return
        end

        if value_entry.Id then
            values_2[value_entry.Id] = nil
        end

        value_entry.Id = remote_event:GetAttribute(attribute_name)

        if value_entry.Id then
            values_2[value_entry.Id] = value_entry
        end
    end)

    run_service.Heartbeat:Connect(function(delta_time)
        number = number + delta_time

        if number > 0.016666666666666666 then
            number = number % 0.016666666666666666
            task.defer(spawn_result_2)
        end
    end)
end

return setmetatable(script_types.Types, {
    __call = constructor,
})
