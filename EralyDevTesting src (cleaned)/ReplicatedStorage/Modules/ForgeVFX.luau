local run_service = game:GetService("RunService")
local collection_service = game:GetService("CollectionService")
local replicated_storage = game:GetService("ReplicatedStorage")
local logger = require("@self/mod/logger")
local utility = require("@self/mod/utility")
local attributes = require("@self/mod/attributes")
local sound = require("@self/effects/sound")
local bezier = require("@self/effects/bezier")
local lightning = require("@self/effects/lightning")
local camera_shake = require("@self/effects/camera_shake")
local shockwave_ring = require("@self/effects/shockwave_ring")
local shockwave_line = require("@self/effects/shockwave_line")
local shockwave_debris = require("@self/effects/shockwave_debris")
local caches = require("@self/services/caches")
local effects = require("@self/services/effects")
local texture_loader = require("@self/services/texture_loader")
local enabled_effects = require("@self/services/enabled_effects")
local plugin_context = utility.PLUGIN_CONTEXT
local server_context = utility.SERVER_CONTEXT
local forge_vfx = {
    scope = {},
    setup = false,
}

function forge_vfx.init(argument: table?)
    if forge_vfx.setup then
        return
    end

    if server_context then
        task.spawn(function()
            local number = 0

            while true do
                number += 1
                local success, result = pcall(utility.setCollisionGroups, utility.COLLISION_GROUPS)

                if not success then
                    task.wait(number)
                end

                if success or number >= 5 then
                    if not success then
                        logger.warn(
                            `couldn't register necessary collision groups after {number} tries with the last error being: {result}`
                        )
                    end

                    return
                end
            end
        end)
    end

    forge_vfx.setup = true

    if run_service:IsServer() and not plugin_context then
        return
    end

    forge_vfx.caches = caches.init(forge_vfx.scope)
    shared.vfx = forge_vfx
    effects.init(forge_vfx)
    texture_loader.init(forge_vfx.scope)
    enabled_effects.init(forge_vfx.scope, forge_vfx.caches.shared_part, effects)
    sound.init()
    camera_shake.init()
    bezier.init(forge_vfx.caches.shared_part)
    lightning.init(forge_vfx.caches.shared_part)
    shockwave_ring.init(forge_vfx.caches.shared_part)
    shockwave_line.init(forge_vfx.caches.shared_part)
    shockwave_debris.init(forge_vfx.caches.shared_part)
end

function forge_vfx.deinit()
    if not forge_vfx.setup then
        return
    end

    forge_vfx.setup = false
    shared.vfx = nil

    if run_service:IsServer() and not plugin_context then
        return
    end

    utility.cleanupScope(forge_vfx.scope)
    effects.deinit()
    sound.deinit()
    bezier.deinit()
    lightning.deinit()
    camera_shake.deinit()
    shockwave_ring.deinit()
    shockwave_line.deinit()
    shockwave_debris.deinit()

    for _, instance in collection_service:GetTagged(utility.CLEANUP_TAG) do
        instance:Destroy()
    end
end

local function full_emit(argument: number, argument_2: number, ...)
    if not forge_vfx.setup then
        logger.error("not initialized")
    end

    return effects.emit(argument_2, ...)
end

function forge_vfx.emit(argument, ...)
    if typeof(argument) == "number" then
        return full_emit(argument, 0, ...)
    end

    return full_emit(1, 0, argument, ...)
end

function forge_vfx.emitWithDepth(argument: number, ...)
    return full_emit(1, argument, ...)
end

function forge_vfx.cacheAttributes(instance: userdata, argument: boolean)
    if utility.SERVER_CONTEXT then
        logger.error("attributes can only be cached in a client-side context")
    end

    if not instance:IsDescendantOf(replicated_storage) then
        logger.error("attributes can only be cached for VFX inside ReplicatedStorage")
    end

    attributes.cache(instance)

    if argument then
        return
    end

    for _, descendant in instance:GetDescendants() do
        attributes.cache(descendant)
    end
end

function forge_vfx.restoreAttributes(argument: userdata, argument_2: boolean?)
    if utility.SERVER_CONTEXT then
        logger.error("attributes can only be restored in a client-side context")
    end

    attributes.restore(argument)

    if argument_2 then
        return
    end

    for _, descendant in argument:GetDescendants() do
        attributes.restore(descendant)
    end
end

local function set_enabled(argument: userdata, attribute_value: boolean)
    if argument:IsA("ParticleEmitter") then
        argument.Enabled = attribute_value

        return
    end

    if argument:IsA("Beam") then
        argument.Enabled = attribute_value

        return
    end

    if attributes.isCached(argument) then
        attributes.trigger(argument, "Enabled", attribute_value)

        return
    end

    argument:SetAttribute("Enabled", attribute_value)
end

function forge_vfx.enable(argument: userdata)
    set_enabled(argument, true)

    for _, descendant in argument:GetDescendants() do
        set_enabled(descendant, true)
    end
end

function forge_vfx.disable(argument: userdata)
    set_enabled(argument, false)

    for _, descendant in argument:GetDescendants() do
        set_enabled(descendant, false)
    end
end

forge_vfx.retime = require("@self/mod/retime").batch
forge_vfx.resize = require("@self/mod/resize").batch
forge_vfx.recolor = require("@self/mod/recolor")

return forge_vfx
