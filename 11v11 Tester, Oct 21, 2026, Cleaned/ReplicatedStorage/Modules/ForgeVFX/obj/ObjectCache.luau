local utility = require("../mod/utility")
local object_cache = {}
object_cache.__index = object_cache

local function reconcile(argument, argument_2)
    for key, item in argument_2 do
        if argument[key] == nil then
            argument[key] = item
        end
    end

    return argument
end

local create_result = table.create(10000)
local create_result_2 = table.create(10000)
local enabled = false
local create_result_3 = coroutine.create(function()
    while true do
        workspace:BulkMoveTo(create_result, create_result_2, Enum.BulkMoveMode.FireCFrameChanged)
        table.clear(create_result)
        table.clear(create_result_2)
        enabled = false
        coroutine.yield()
    end
end)

function object_cache.new(ref: userdata, parent: userdata?, argument: table?)
    local instance = setmetatable({}, object_cache)
    instance.ref = ref
    instance.parent = parent
    instance.amount = 0
    instance.restore_amount = 0
    local params = argument or {}

    for key, item in
        {
            size = 100,
            excess_lifetime = 30,
        }
    do
        if params[key] == nil then
            params[key] = item
        end
    end

    instance.params = params
    instance.scope = { ref, parent }
    instance.unused = table.create(instance.params.size)
    instance.item_map = {}
    instance.part_mode = ref:IsA("BasePart")

    for index = 1, instance.params.size do
        instance:_add()
        local _ = index
    end

    table.insert(
        instance.scope,
        task.spawn(function()
            while true do
                repeat
                    if not task.wait(15) then
                        return
                    end

                    if instance.restore_amount > 0 then
                        for index_2 = 1, instance.restore_amount do
                            instance:_add()
                            local instance_2 = instance
                            instance_2.restore_amount = instance_2.restore_amount - 1
                            local _ = index_2
                        end
                    end
                until instance.amount > instance.params.size

                local number = 0

                for index_3 = 1, #instance.unused do
                    if instance.amount <= instance.params.size then
                        break
                    end

                    local difference = index_3 - number
                    local unused_entry = instance.unused[difference]
                    local index_4

                    if
                        unused_entry.dependents == 0
                        and os.clock() - unused_entry.added <= instance.params.excess_lifetime
                    then
                        unused_entry:destroy()
                        table.remove(instance.unused, difference)
                        instance.item_map[unused_entry.key] = nil
                        local instance_3 = instance
                        instance_3.amount = instance_3.amount - 1
                        number += 1
                        index_4 = index_3
                    else
                        index_4 = index_3
                    end
                end
            end
        end)
    )

    return instance
end

function object_cache._add(argument: any, key: any, argument_2: boolean?)
    local value = argument.ref:Clone()
    value.Archivable = false
    value.Parent = argument.parent
    local values = {
        dependents = 1,
        key = key,
        value = value,
        added = os.clock(),
    }
    local enabled_2 = false

    function values.destroy(argument_3)
        enabled_2 = true
        value:Destroy()
    end

    argument.amount = argument.amount + 1

    value.Destroying:Connect(function()
        if enabled_2 then
            return
        end

        local match_index = table.find(argument.unused, values)

        if match_index then
            table.remove(argument.unused, match_index)
        end

        if values.key then
            argument.item_map[values.key] = nil
        end

        local argument_3 = argument
        argument_3.amount = argument_3.amount - 1
        local argument_4 = argument
        argument_4.restore_amount = argument_4.restore_amount + 1
    end)

    if key then
        argument.item_map[key] = values
    end

    if not argument_2 then
        table.insert(argument.unused, values)
    end

    return values
end

function object_cache.has(argument, argument_2)
    return argument.item_map[argument_2] and true or false
end

function object_cache.peek(argument, argument_2)
    return argument.item_map[argument_2]
end

function object_cache.get(argument, key)
    if argument:has(key) then
        local peek_result = argument:peek(key)

        if peek_result then
            peek_result.dependents = peek_result.dependents + 1
        end

        return peek_result.value
    end

    local remove_result = table.remove(argument.unused)

    if remove_result then
        remove_result.key = key
        remove_result.added = os.clock()
        argument.item_map[key] = remove_result
    else
        remove_result = argument:_add(key, true)
    end

    if not argument.part_mode then
        return remove_result.value
    end

    return setmetatable({
        _getReal = function()
            return remove_result.value
        end,
    }, {
        __newindex = function(argument_2, argument_3, argument_4)
            if argument_3 == "CFrame" then
                table.insert(create_result, remove_result.value)
                table.insert(create_result_2, argument_4)

                if not enabled then
                    enabled = true
                    task.defer(create_result_3)
                end
            else
                remove_result.value[argument_3] = argument_4
            end
        end,

        __index = function(argument_2, argument_3)
            local callback = remove_result.value[argument_3]

            return typeof(callback) == "function"
                    and function(argument_4, ...)
                        return callback(remove_result.value, ...)
                    end
                or callback
        end,
    })
end

function object_cache.free(argument, argument_2)
    local item_map_entry = argument.item_map[argument_2]

    if not item_map_entry then
        return
    end

    item_map_entry.dependents = math.max(item_map_entry.dependents - 1, 0)

    if item_map_entry.dependents ~= 0 then
        return
    end

    item_map_entry.added = os.clock()

    if argument.params.on_free then
        argument.params.on_free(item_map_entry)
    end

    table.insert(argument.unused, item_map_entry)
end

function object_cache.destroy(argument)
    utility.cleanupScope(argument.scope)

    for _, item in argument.item_map do
        item.value:Destroy()
    end

    table.clear(argument.unused)
    table.clear(argument.item_map)
end

return object_cache
