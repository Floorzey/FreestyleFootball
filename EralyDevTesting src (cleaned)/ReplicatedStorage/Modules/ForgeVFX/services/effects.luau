require("../types")
local logger = require("../mod/logger")
local utility = require("../mod/utility")
local emitters = require("../emitters")
local promise = require("../pkg/Promise")
local concat_result = table.concat({
    "Beam",
    "Trail",
    "Sound",
    "ParticleEmitter",
    `.{utility.BEZIER_TAG}`,
    `.{utility.LIGHTNING_TAG}`,
    "Model",
    "RayValue",
    "BasePart[$Enabled=true]",
    "#Rings > Part",
    "#Lines > Part",
    "#Debris > Part",
}, ",")
local effects = {}
local value = nil

local function clear() end

local values = {
    Finished = promise.resolve(),
    Clear = clear,
}

function effects.init(argument)
    value = argument
end

function effects.deinit()
    value = nil
end

local function emit_with_context(depth: number, context: table?, ...)
    if not (value and value.setup) then
        logger.error("effects service not initialized")

        return values
    end

    local values_2 = {}
    local values_3 = {}

    local function query_and_emit_descendants(argument: userdata, argument_2: number)
        local query_descendants_result = argument:QueryDescendants(concat_result)
        local query_descendants_result_count = #query_descendants_result

        if query_descendants_result_count == 0 then
            return {}
        end

        local create_result = table.create(query_descendants_result_count)
        local values_6 = {}
        local values_7 = {}
        values_6[argument] = false
        values_7[argument] = argument_2

        for _, item_3 in query_descendants_result do
            local parent = item_3.Parent
            local item_4 = item_3
            local items_2 = {}

            while values_7[parent] == nil do
                table.insert(items_2, parent)
                parent = parent.Parent
            end

            local value_entry = values_6[parent]
            local value_entry_2 = values_7[parent]

            for index = #items_2, 1, -1 do
                local item_entry = items_2[index]
                value_entry_2 += 1
                values_7[item_entry] = value_entry_2
                value_entry = value_entry
                    or (utility.shouldSkipNested(item_entry) or item_entry:HasTag(utility.EMIT_EXCLUDE_TAG))
                values_6[item_entry] = value_entry
                local _ = index
            end

            if not value_entry then
                table.insert(
                    create_result,
                    utility.createEmitPromise(effects, item_4, values_7[item_4.Parent], function(argument_3)
                        emitters.dispatch(item_4, argument_3, values_2, values_3, value.caches.shared_part, 1)
                    end, context)
                )
            end
        end

        return create_result
    end

    local items = {}

    for _, item in { ... } do
        if
            item:IsA("BasePart")
            and (
                item:GetAttribute("Enabled")
                and not utility.findFirstClassWithTag(item, "Attachment", utility.SHOCKWAVE_TAG)
            )
        then
            if not utility.lock(item) then
                local first_ancestor_of_class = item:FindFirstAncestorOfClass("Model")

                if not first_ancestor_of_class or utility.isSpinModelStatic(first_ancestor_of_class) then
                    local running_result = coroutine.running()
                    local values_4 = {
                        depth = depth,
                        effects = effects,
                        _context = context,
                    }

                    if emitters.screen(item, values_4) then
                        local result = query_and_emit_descendants(item, depth + 1)

                        if #result > 0 then
                            local all_result = promise.all(result)
                            table.insert(
                                items,
                                all_result:finally(function()
                                    utility.unlock(item, running_result)
                                    utility.cleanupScope(values_4)
                                end)
                            )
                        else
                            utility.unlock(item, running_result)
                            utility.cleanupScope(values_4)
                        end
                    end
                end
            end
        else
            table.insert(
                items,
                utility.createEmitPromise(effects, item, depth, function(argument)
                    emitters.dispatch(item, argument, values_2, values_3, value.caches.shared_part, 1)
                end, context)
            )

            if not utility.shouldSkipNested(item) then
                for _, item_2 in query_and_emit_descendants(item, depth + 1) do
                    table.insert(items, item_2)
                end
            end
        end
    end

    local values_5 = {
        Finished = promise.all(items),
    }
    values_5.Clear = context
            and function()
                for _, item_3 in context._promises do
                    item_3:cancel()
                end

                values_5.Finished:cancel()
            end
        or clear

    return values_5
end

function effects.emit(depth: number, ...)
    return emit_with_context(depth, {
        _promises = {},
    }, ...)
end

function effects.prepareEmitFolder(instance: userdata, child_name: string, items: any)
    local first_child = instance:FindFirstChild(child_name)

    if not (first_child and first_child:IsA("Folder")) then
        return nil
    end

    first_child.Parent = nil
    table.insert(items, first_child)

    return first_child
end

function effects.prepareEmitOnFinish(instance: userdata, items: any)
    return effects.prepareEmitFolder(instance, "EmitOnFinish", items)
end

function effects.emitNested(instance: userdata, depth: number, argument: any)
    if not (value and value.setup) then
        return values
    end

    local children = instance:GetChildren()

    if #children == 0 then
        return values
    end

    local context

    if argument then
        context = argument._context
    else
        context = nil
    end

    return emit_with_context(depth, context, table.unpack(children))
end

function effects.emitFromFolder(instance: userdata?, parent: userdata, depth: number, argument: any)
    if not instance then
        return values
    end

    local children = instance:GetChildren()

    if #children == 0 then
        return values
    end

    for _, item in children do
        item.Parent = parent
    end

    local context

    if argument then
        context = argument._context
    else
        context = nil
    end

    return emit_with_context(depth, context, table.unpack(children))
end

function effects.emitOnFinish(instance: userdata?, parent: userdata, argument: number, argument_2: any)
    return effects.emitFromFolder(instance, parent, argument, argument_2)
end

return effects
