local collection_service = game:GetService("CollectionService")
local object_cache = require("../obj/ObjectCache")
require("../types")
local utility = require("../mod/utility")
local flipbook = require("../mod/common/flipbook")

return {
    init = function(items)
        local decal = Instance.new("Decal")
        local do_not_remove_forge_texture_cache = Instance.new("Part")
        do_not_remove_forge_texture_cache.Name = "DO_NOT_REMOVE_ForgeTextureCache"
        do_not_remove_forge_texture_cache.Transparency = 1
        do_not_remove_forge_texture_cache.Size = Vector3.new(0, 0, 0)
        do_not_remove_forge_texture_cache.Archivable = false
        do_not_remove_forge_texture_cache.Anchored = true
        do_not_remove_forge_texture_cache.CanCollide = false
        do_not_remove_forge_texture_cache.CanQuery = false
        do_not_remove_forge_texture_cache.Locked = true
        do_not_remove_forge_texture_cache.Parent = workspace.Terrain
        utility.protectParent(items, do_not_remove_forge_texture_cache)
        local object_cache_2 = object_cache.new(decal, do_not_remove_forge_texture_cache, {
            size = 360,

            on_free = function(argument)
                argument.value.Texture = ""
            end,
        })
        local values = {}

        local function create_loader(
            argument: userdata,
            callback: (...any) -> ...any,
            callback_2: ((...any) -> ...any)?
        )
            local items_2 = {}
            local items_3 = {}
            table.insert(items_2, items_3)

            local function refresh()
                utility.cleanupScope(items_3)

                callback(function(texture: string)
                    if texture == "" then
                        return
                    end

                    object_cache_2:get(texture).Texture = texture

                    table.insert(items_3, function()
                        object_cache_2:free(texture)
                    end)
                end)
            end

            utility.cleanupScope(items_3)

            callback(function(texture: string)
                if texture == "" then
                    return
                end

                object_cache_2:get(texture).Texture = texture

                table.insert(items_3, function()
                    object_cache_2:free(texture)
                end)
            end)

            if utility.PLUGIN_CONTEXT and callback_2 then
                for _, item in callback_2((utility.reboundfn(1, refresh))) do
                    table.insert(items_2, item)
                end
            end

            values[argument] = items_2
        end

        local function load_textures(instance_2: userdata)
            if instance_2:IsDescendantOf(workspace.Terrain) then
                return
            end

            if not utility.isMeshVFX(instance_2) then
                if instance_2:IsA("Beam") then
                    create_loader(instance_2, function(callback)
                        callback(instance_2.Texture)
                        local flipbook_data = flipbook.getFlipbookData(instance_2)

                        if flipbook_data then
                            local texture_prefix = flipbook.getTexturePrefix(instance_2)

                            for _, item in flipbook_data do
                                callback(`{texture_prefix}{item}`)
                            end
                        end
                    end, function(argument)
                        return {
                            instance_2:GetPropertyChangedSignal("Texture"):Connect(argument),
                            instance_2.AttributeChanged:Connect(argument),
                        }
                    end)

                    return
                end

                create_loader(instance_2, function(callback)
                    local function check(argument: userdata)
                        if argument:IsA("ParticleEmitter") then
                            callback(argument.Texture)
                        end
                    end

                    local instance_3 = instance_2

                    if instance_3:IsA("ParticleEmitter") then
                        callback(instance_3.Texture)
                    end

                    for _, descendant in instance_2:GetDescendants() do
                        if descendant:IsA("ParticleEmitter") then
                            callback(descendant.Texture)
                        end
                    end
                end, function(argument)
                    return {
                        instance_2.DescendantAdded:Connect(argument),
                        instance_2.DescendantRemoving:Connect(argument),
                    }
                end)

                return
            end

            local start = instance_2:FindFirstChild("Start")

            if not (start and start:IsA("BasePart")) then
                return
            end

            create_loader(instance_2, function(callback)
                local mesh_decals, value = utility.getMeshDecals(instance_2, start)

                for _, item in mesh_decals do
                    local item_2

                    if typeof(item) == "string" then
                        item_2 = item
                    else
                        item_2 = item.Texture or item
                    end

                    callback(item_2)
                end

                for _, item_3 in value do
                    local texture_prefix = flipbook.getTexturePrefix(instance_2)

                    for _, item_4 in item_3 do
                        callback(`{texture_prefix}{item_4}`)
                    end
                end
            end, function(argument)
                return { start.DescendantAdded:Connect(argument), start.DescendantRemoving:Connect(argument) }
            end)
        end

        for _, instance in collection_service:GetTagged(utility.TEXTURE_LOAD_TAG) do
            load_textures(instance)
        end

        collection_service:GetInstanceAddedSignal(utility.TEXTURE_LOAD_TAG):Connect(load_textures)

        collection_service:GetInstanceRemovedSignal(utility.TEXTURE_LOAD_TAG):Connect(function(argument)
            local value_entry = values[argument]

            if value_entry then
                utility.cleanupScope(value_entry)
                values[argument] = nil
            end
        end)

        table.insert(items, function()
            object_cache_2:destroy()

            for _, item in values do
                utility.cleanupScope(item)
            end
        end)
    end,
}
