local object_cache = require("../obj/ObjectCache")
local utility = require("../mod/utility")

return {
    init = function(items: table)
        local part = Instance.new("Part")
        part.Transparency = 1
        part.Anchored = true
        part.CanCollide = false
        part.CanQuery = false
        part.Locked = true
        local do_not_remove_forge_shared_part_cache = Instance.new("Folder")
        do_not_remove_forge_shared_part_cache.Name = "DO_NOT_REMOVE_ForgeSharedPartCache"
        do_not_remove_forge_shared_part_cache.Archivable = false
        do_not_remove_forge_shared_part_cache.Parent = workspace.Terrain
        utility.protectParent(items, do_not_remove_forge_shared_part_cache)
        local object_cache_2 = object_cache.new(part, do_not_remove_forge_shared_part_cache, {
            size = 150,

            on_free = function(argument)
                local value = argument.value
                value.Transparency = 1
                value.Anchored = true
                value.CanQuery = false
                value.CanCollide = false
                value.CollisionGroup = "ForgeMouseIgnore"
                value.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                value.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                value.Parent = do_not_remove_forge_shared_part_cache
                value:ClearAllChildren()
            end,
        })
        local values = {
            shared_part = object_cache_2,
        }

        table.insert(items, function()
            object_cache_2:destroy()
        end)

        return values
    end,
}
