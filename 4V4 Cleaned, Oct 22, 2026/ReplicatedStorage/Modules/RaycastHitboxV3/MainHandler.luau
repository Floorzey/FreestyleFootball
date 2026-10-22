local run_service = game:GetService("RunService")
local collection_service = game:GetService("CollectionService")
local items = {}
local main_handler = {}

function main_handler.add(argument, argument_2)
    local is_instance = typeof(argument_2) ~= "Instance"
    assert(is_instance, "Make sure you are initializing from the Raycast module, not from this handler.")
    table.insert(items, argument_2)
end

function main_handler.remove(argument, argument_2)
    for index in ipairs(items) do
        if items[index].object == argument_2 then
            items[index]:Destroy()
            setmetatable(items[index], nil)
            table.remove(items, index)
        end
    end
end

function main_handler.check(argument, argument_2)
    for _, item in ipairs(items) do
        if item.object ~= argument_2 then
            continue
        end

        return item
    end
end

function OnTagRemoved(argument)
    main_handler:remove(argument)
end

collection_service:GetInstanceRemovedSignal("RaycastModuleManaged"):Connect(OnTagRemoved)

run_service.Heartbeat:Connect(function()
    for _, item in ipairs(items) do
        if item.deleted then
            main_handler:remove(item.object)
            continue
        end

        for index, item_2 in ipairs(item.points) do
            if not item.active then
                item_2.LastPosition = nil
                continue
            end

            local solve_result, first_ancestor_of_class, value = item_2.solver:solve(item_2, item.debugMode)
            local raycast_result = workspace:Raycast(solve_result, first_ancestor_of_class, item.raycastParams)
            item_2.solver:lastPosition(item_2, value)

            if not raycast_result then
                item.OnUpdate:Fire(item_2.LastPosition)
                continue
            end

            local instance = raycast_result.Instance
            first_ancestor_of_class = not item.partMode and instance:FindFirstAncestorOfClass("Model")
            solve_result = first_ancestor_of_class and first_ancestor_of_class:FindFirstChildOfClass("Humanoid")
            first_ancestor_of_class = solve_result or (item.partMode and instance)

            if first_ancestor_of_class and not item.targetsHit[first_ancestor_of_class] then
                item.targetsHit[first_ancestor_of_class] = true
                item.OnHit:Fire(instance, first_ancestor_of_class, raycast_result, item_2.group)
            end

            item.OnUpdate:Fire(item_2.LastPosition)
        end
    end
end)

return main_handler
