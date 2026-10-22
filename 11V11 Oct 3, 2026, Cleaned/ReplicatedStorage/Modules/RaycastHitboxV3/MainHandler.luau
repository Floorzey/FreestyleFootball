local run_service = game:GetService("RunService")
local collection_service = game:GetService("CollectionService")
local items = {}
local main_handler = {}

function main_handler.add(self, argument)
    local is_instance = typeof(argument) ~= "Instance"
    assert(is_instance, "Make sure you are initializing from the Raycast module, not from this handler.")
    table.insert(items, argument)
end

function main_handler.remove(self, argument)
    for index in ipairs(items) do
        if items[index].object == argument then
            items[index]:Destroy()
            setmetatable(items[index], nil)
            table.remove(items, index)
        end
    end
end

function main_handler.check(self, argument)
    for _, item in ipairs(items) do
        if item.object ~= argument then
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
            local solve_result, value, value_2 = item_2.solver:solve(item_2, item.debugMode)
            local raycast_result = workspace:Raycast(solve_result, value, item.raycastParams)
            item_2.solver:lastPosition(item_2, value_2)
            if not raycast_result then
                item.OnUpdate:Fire(item_2.LastPosition)
                continue
            end
            local instance = raycast_result.Instance
            local first_ancestor_of_class = not item.partMode and (instance:FindFirstAncestorOfClass("Model"))
            local humanoid = first_ancestor_of_class and (first_ancestor_of_class:FindFirstChildOfClass("Humanoid"))
            local part_mode = humanoid or (item.partMode and instance)
            if part_mode and not item.targetsHit[part_mode] then
                item.targetsHit[part_mode] = true
                item.OnHit:Fire(instance, first_ancestor_of_class, raycast_result, item_2.group)
            end
            item.OnUpdate:Fire(item_2.LastPosition)
        end
    end
end)

return main_handler
