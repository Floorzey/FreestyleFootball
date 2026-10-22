local run_service = game:GetService("RunService")
local collection_service = game:GetService("CollectionService")
local heartbeat = run_service.Heartbeat
local _ = script.Parent
local items = {}
local main_handler = {
    add = function(argument, argument_2)
        local is_instance = typeof(argument_2) ~= "Instance"
        assert(is_instance, "Make sure you are initializing from the Raycast module, not from this handler.")
        table.insert(items, argument_2)
    end,

    remove = function(argument, argument_2)
        for index in ipairs(items) do
            if items[index].object == argument_2 then
                items[index]:Destroy()
                setmetatable(items[index], nil)
                table.remove(items, index)
            end
        end
    end,

    check = function(argument, argument_2)
        for _, item in ipairs(items) do
            if item.object == argument_2 then
                return item
            end
        end
    end,
}

function OnTagRemoved(argument)
    main_handler:remove(argument)
end

collection_service:GetInstanceRemovedSignal("RaycastModuleManaged"):Connect(OnTagRemoved)

heartbeat:Connect(function()
    for _, item in ipairs(items) do
        if item.deleted then
            main_handler:remove(item.object)
        else
            local item_2 = item

            for _, item_3 in ipairs(item.points) do
                if item_2.active then
                    local solve_result, value, value_2 = item_3.solver:solve(item_3, item_2.debugMode)
                    local raycast_result = workspace:Raycast(solve_result, value, item_2.raycastParams)
                    item_3.solver:lastPosition(item_3, value_2)

                    if raycast_result then
                        local instance = raycast_result.Instance
                        local first_ancestor_of_class = not item_2.partMode
                            and instance:FindFirstAncestorOfClass("Model")

                        if first_ancestor_of_class then
                            first_ancestor_of_class = first_ancestor_of_class:FindFirstChildOfClass("Humanoid")
                        end

                        local first_ancestor_of_class_2 = first_ancestor_of_class or item_2.partMode and instance

                        if first_ancestor_of_class_2 and not item_2.targetsHit[first_ancestor_of_class_2] then
                            item_2.targetsHit[first_ancestor_of_class_2] = true
                            item_2.OnHit:Fire(instance, first_ancestor_of_class, raycast_result, item_3.group)
                        end
                    end

                    item_2.OnUpdate:Fire(item_3.LastPosition)
                else
                    item_3.LastPosition = nil
                end
            end
        end
    end
end)

return main_handler
