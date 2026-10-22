local run_service = game:GetService("RunService")
local collection_service = game:GetService("CollectionService")
local attributes = require("../mod/attributes")
require("../types")
local utility = require("../mod/utility")
local emitters = require("../emitters")

return {
    init = function(items, argument, effects)
        local values = {}
        local values_2 = {}

        local function remove_enabled_effect(argument_2: userdata)
            local value_entry = values[argument_2]

            if value_entry then
                utility.cleanupScope(value_entry)
            end

            values[argument_2] = nil
        end

        local function remove_enabled_effect_full(argument_2: userdata)
            local value_entry = values[argument_2]

            if value_entry then
                utility.cleanupScope(value_entry)
            end

            values[argument_2] = nil
            local connection = values_2[argument_2]

            if connection then
                connection:Disconnect()
                values_2[argument_2] = nil
            end
        end

        local function add_enabled_effect(instance_2: userdata)
            local value = nil

            for _, item in emitters.enabled_registry do
                if item.check(instance_2) then
                    value = item
                    break
                end
            end

            if not value then
                return
            end

            local items_2 = {}
            local items_3 = {}
            table.insert(items_3, items_2)
            values[instance_2] = items_3

            if not values_2[instance_2] then
                values_2[instance_2] = instance_2.AncestryChanged:Connect(function()
                    if
                        instance_2:IsDescendantOf(workspace)
                        or instance_2.Parent and instance_2.Parent:HasTag("AllowEmitting")
                    then
                        if not values[instance_2] then
                            add_enabled_effect(instance_2)
                        end
                    else
                        local instance_3 = instance_2
                        local value_entry = values[instance_3]

                        if value_entry then
                            utility.cleanupScope(value_entry)
                        end

                        values[instance_3] = nil
                    end
                end)
            end

            local function on_enabled(get_result: boolean?)
                if get_result == nil then
                    get_result = attributes.get(instance_2, "Enabled", true)
                end

                local has_tag_result = utility.isForceEmitting(instance_2)
                    or instance_2:IsDescendantOf(workspace)
                    or instance_2.Parent and instance_2.Parent:HasTag("AllowEmitting")

                if get_result and not has_tag_result then
                    return
                end

                if not get_result then
                    utility.cleanupScope(items_2)

                    return
                end

                utility.cleanupScope(items_2)
                local number = 0
                local context = {
                    _promises = {},
                    _scopes = {},
                }
                utility.setEnabledCancelToken(instance_2, context)
                table.insert(
                    items_2,
                    run_service.RenderStepped:Connect(function()
                        local get_result_2 = attributes.get(instance_2, "Rate", 5)
                        local state = attributes.getState(instance_2, "SpeedOverride", 1)

                        if state == 0 then
                            return
                        end

                        if os.clock() - number <= 1 / get_result_2 / state then
                            return
                        end

                        number = os.clock()
                        local values_3 = {
                            depth = 0,
                            effects = effects,
                            _context = context,
                        }
                        table.insert(context._scopes, values_3)
                        value.emit(instance_2, values_3, argument)
                        local match_index = table.find(context._scopes, values_3)

                        if match_index then
                            table.remove(context._scopes, match_index)
                        end

                        utility.cleanupScope(values_3)
                    end)
                )
            end

            table.insert(items_3, attributes.hook(instance_2, "Enabled", on_enabled))
            on_enabled()
        end

        for _, instance in collection_service:GetTagged(utility.ENABLED_VFX_TAG) do
            add_enabled_effect(instance)
        end

        collection_service:GetInstanceAddedSignal(utility.ENABLED_VFX_TAG):Connect(add_enabled_effect)
        collection_service:GetInstanceRemovedSignal(utility.ENABLED_VFX_TAG):Connect(remove_enabled_effect_full)

        table.insert(items, function()
            for _, item in values do
                utility.cleanupScope(item)
            end

            for _, connection in values_2 do
                connection:Disconnect()
            end

            table.clear(values_2)
        end)
    end,
}
