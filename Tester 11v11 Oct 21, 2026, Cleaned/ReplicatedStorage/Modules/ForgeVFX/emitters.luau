local beam = require("./effects/beam")
local spin = require("./effects/spin")
local mesh = require("./effects/mesh")
local sound = require("./effects/sound")
local bezier = require("./effects/bezier")
local screen = require("./effects/screen")
local particle = require("./effects/particle")
local lightning = require("./effects/lightning")
local camera_shake = require("./effects/camera_shake")
local tweener = require("./effects/tweener")
local randomizer = require("./effects/randomizer")
local shockwave_ring = require("./effects/shockwave_ring")
local shockwave_line = require("./effects/shockwave_line")
local shockwave_debris = require("./effects/shockwave_debris")
local attributes = require("./mod/attributes")
require("./types")
local utility = require("./mod/utility")
local promise = require("./pkg/Promise")
local emitters = {}

local function process_randomizers(argument: userdata, argument_2: any)
    local query_descendants_result = argument:QueryDescendants(`> RayValue.{utility.PROPERTY_RANDOMIZER_TAG}`)
    local query_descendants_result_2 = argument:QueryDescendants(`> RayValue.{utility.ATTRIBUTE_RANDOMIZER_TAG}`)

    if argument:IsA("RayValue") then
        if argument:HasTag(utility.PROPERTY_RANDOMIZER_TAG) then
            table.insert(query_descendants_result, argument)
        elseif argument:HasTag(utility.ATTRIBUTE_RANDOMIZER_TAG) then
            table.insert(query_descendants_result_2, argument)
        end
    end

    for _, item in query_descendants_result do
        utility.try("failed to emit property randomizer with error: %s", randomizer.emit, item, argument_2, false)
    end

    for _, item_2 in query_descendants_result_2 do
        utility.try("failed to emit attribute randomizer with error: %s", randomizer.emit, item_2, argument_2, true)
    end
end

function emitters.particle(instance: userdata, items: any, argument: table, argument_2: table, argument_3: number)
    local get_result = attributes.get(instance, "EmitCount", utility.PLUGIN_CONTEXT and 1 or nil)
    local get_result_2 = attributes.get(instance, "EmitDuration", 0, true)

    if not (get_result and (get_result > 0 or get_result_2 > 0)) then
        return
    end

    if instance:IsDescendantOf(workspace) then
        utility.try("failed to emit particle with error: %s", particle.emit, instance, instance, items, argument_3)

        return
    end

    local parent, instance_2 = utility.cloneParticleAncestry(instance, argument_2)

    if not parent then
        return
    end

    local clone = instance:Clone()
    clone.Archivable = false
    clone.Parent = parent

    if argument[instance_2] then
        argument[instance_2] = argument[instance_2] + 1
    else
        instance_2.Parent = workspace.Terrain
        argument[instance_2] = 1
    end

    table.insert(items, function()
        local argument_4 = argument
        local instance_3 = instance_2
        argument_4[instance_3] = argument_4[instance_3] - 1

        if argument[instance_2] <= 0 then
            instance_2:Destroy()
        end
    end)

    utility.try("failed to emit particle with error: %s", particle.emit, instance, clone, items, argument_3)
end

function emitters.beam(argument: userdata, items: any, argument_2: number)
    local attachment0 = argument.Attachment0
    local attachment1 = argument.Attachment1

    if not (attachment0 and attachment1) then
        return
    end

    local clone = argument:Clone()
    clone.Archivable = false
    clone.Parent = workspace.Terrain
    local number_range = NumberRange.new(1, 1)

    if
        attributes.get(argument, "Length_Scale_Start", number_range, true) ~= number_range
        or attributes.get(argument, "Length_Scale_End", number_range, true) ~= number_range
    then
        local forge_temp_attachment = attachment0:Clone()
        local forge_temp_attachment_2 = attachment1:Clone()
        table.insert(items, forge_temp_attachment)
        table.insert(items, forge_temp_attachment_2)
        forge_temp_attachment.Name = "_ForgeTempAttachment"
        forge_temp_attachment_2.Name = "_ForgeTempAttachment"
        forge_temp_attachment:AddTag(utility.EMIT_EXCLUDE_TAG)
        forge_temp_attachment_2:AddTag(utility.EMIT_EXCLUDE_TAG)
        clone.Attachment0 = forge_temp_attachment
        clone.Attachment1 = forge_temp_attachment_2
        forge_temp_attachment.Parent = attachment0.Parent
        forge_temp_attachment_2.Parent = attachment1.Parent
    end

    table.insert(items, clone)
    utility.try("failed to emit beam with error: %s", beam.emit, argument, clone, items, argument_2)
end

function emitters.trail(argument: userdata)
    argument.Enabled = true
end

function emitters.bezier(argument: userdata, items: any, argument_2: boolean?)
    local part = argument:FindFirstChildOfClass("Part")

    if not part then
        return
    end

    if not argument_2 and argument:GetAttribute("Enabled") then
        argument:SetAttribute("Enabled", false)
    end

    local clone = part:Clone()
    clone.Locked = true
    table.insert(items, clone)
    utility.try("failed to emit bezier with error: %s", bezier.emit, argument, clone, items, argument_2)
end

function emitters.lightning(argument: userdata, items: any, argument_2: boolean?)
    local part = argument:FindFirstChildOfClass("Part")

    if not part then
        return
    end

    if not argument_2 and argument:GetAttribute("Enabled") then
        argument:SetAttribute("Enabled", false)
    end

    local clone = part:Clone()
    clone.Locked = true
    table.insert(items, clone)
    utility.try("failed to emit lightning with error: %s", lightning.emit, argument, clone, items, argument_2)
end

function emitters.mesh(instance: userdata, argument: any, argument_2: any, argument_3: number, argument_4: boolean?)
    local start = instance:FindFirstChild("Start")

    if not start then
        return
    end

    if not argument_4 and instance:GetAttribute("Enabled") then
        instance:SetAttribute("Enabled", false)
    end

    local items = {}
    local context = argument._context
    local condition = instance:HasTag(utility.ENABLED_VFX_TAG) and attributes.get(instance, "EmitDuration", 0) > 0

    for index = 1, condition and not argument_4 and 1 or attributes.get(instance, "EmitCount", 1) do
        local promise_2 = promise.new(function(callback)
            utility.try(
                "failed to emit mesh with error: %s",
                mesh.emit,
                instance,
                utility.assembleMeshVFX(start, argument, argument_2),
                argument,
                argument_3,
                argument_4
            )
            callback()
        end)
        table.insert(items, promise_2)
        local index_2

        if context then
            table.insert(context._promises, promise_2)
            index_2 = index
        else
            index_2 = index
        end
    end

    promise.all(items):await()
end

function emitters.spin(argument: userdata, argument_2: any)
    if utility.lock(argument) then
        return
    end

    utility.try("failed to emit spinning model with error: %s", spin.emit, argument, argument_2)
    utility.unlock(argument)
end

function emitters.camera_shake(argument: userdata, argument_2: any)
    utility.try("failed to emit camera shake with error: %s", camera_shake.emit, argument, argument_2)
end

function emitters.property_tweener(argument: userdata, argument_2: any)
    if not argument.Parent or utility.lock(argument) then
        return
    end

    utility.try("failed to emit property tweener with error: %s", tweener.emit, argument, argument_2, false)
    utility.unlock(argument)
end

function emitters.attribute_tweener(argument: userdata, argument_2: any)
    if not argument.Parent or utility.lock(argument) then
        return
    end

    utility.try(
        "failed to emit attribute tweener with error: %s",
        tweener.emit,
        argument.Parent,
        argument,
        argument_2,
        true
    )
    utility.unlock(argument)
end

function emitters.screen(argument: userdata, argument_2: any)
    local try_result, value =
        utility.try("failed to emit screen effect with error: %s", screen.emit, argument, argument_2)

    if try_result then
        return value
    end

    return false
end

function emitters.shockwave_ring(argument: userdata, argument_2: userdata, argument_3: any)
    utility.try("failed to emit shockwave ring with error: %s", shockwave_ring.emit, argument, argument_2, argument_3)
end

function emitters.shockwave_debris(argument: userdata, argument_2: userdata, argument_3: any)
    utility.try(
        "failed to emit shockwave debris with error: %s",
        shockwave_debris.emit,
        argument,
        argument_2,
        argument_3
    )
end

function emitters.shockwave_line(argument: userdata, argument_2: userdata, argument_3: any)
    utility.try("failed to emit shockwave line with error: %s", shockwave_line.emit, argument, argument_2, argument_3)
end

function emitters.sound(argument: userdata, argument_2: any)
    if attributes.get(argument, "EmitCount", 1, true) <= 0 then
        return
    end

    utility.try("failed to emit sound with error: %s", sound.emit, argument, argument_2)
end

function emitters.dispatch(
    instance: any,
    items: any,
    argument: table,
    argument_2: table,
    argument_3: any,
    argument_4: number
)
    local class_name = instance.ClassName
    process_randomizers(instance, items)

    if class_name == "ParticleEmitter" then
        emitters.particle(instance, items, argument, argument_2, argument_4)

        return
    end

    if class_name == "Beam" then
        emitters.beam(instance, items, argument_4)

        return
    end

    if class_name == "Trail" then
        emitters.trail(instance)

        return
    end

    if class_name == "Sound" then
        emitters.sound(instance, items)

        return
    end

    if class_name == "RayValue" then
        if instance:HasTag(utility.SCREENSHAKE_TAG) then
            emitters.camera_shake(instance, items)

            return
        end

        if instance:HasTag(utility.ATTRIBUTE_TWEENER_TAG) then
            emitters.attribute_tweener(instance, items)

            return
        end

        if not instance:HasTag(utility.PROPERTY_RANDOMIZER_TAG) then
            if instance:HasTag(utility.ATTRIBUTE_RANDOMIZER_TAG) then
                return
            end

            emitters.property_tweener(instance, items)
        end

        return
    end

    if instance:HasTag(utility.BEZIER_TAG) then
        emitters.bezier(instance, items)

        return
    end

    if instance:HasTag(utility.LIGHTNING_TAG) then
        emitters.lightning(instance, items)

        return
    end

    if class_name == "Model" then
        if utility.isMeshVFX(instance) then
            emitters.mesh(instance, items, argument_3, argument_4)

            return
        end

        emitters.spin(instance, items)

        return
    end

    local find_first_class_with_tag_result = class_name == "Part"
        and utility.findFirstClassWithTag(instance, "Attachment", utility.SHOCKWAVE_TAG)

    if not find_first_class_with_tag_result then
        return
    end

    local name = instance.Parent and (instance.Parent.Name or "") or ""

    if name == "Rings" then
        emitters.shockwave_ring(find_first_class_with_tag_result, instance, items)

        return
    end

    if name == "Debris" then
        emitters.shockwave_debris(find_first_class_with_tag_result, instance, items)

        return
    end

    if name == "Lines" then
        emitters.shockwave_line(find_first_class_with_tag_result, instance, items)
    end
end

emitters.enabled_registry = {
    mesh = {
        check = function(argument: userdata)
            return utility.isMeshVFX(argument)
        end,

        emit = function(instance: userdata, argument: any, argument_2: any)
            emitters.mesh(instance, argument, argument_2, 1, true)
        end,
    },
    bezier = {
        check = function(argument: userdata)
            return argument:HasTag(utility.BEZIER_TAG)
        end,

        emit = function(argument: userdata, items: any, argument_2: any)
            emitters.bezier(argument, items, true)
        end,
    },
    lightning = {
        check = function(argument: userdata)
            return argument:HasTag(utility.LIGHTNING_TAG)
        end,

        emit = function(argument: userdata, items: any, argument_2: any)
            emitters.lightning(argument, items, true)
        end,
    },
}

return emitters
