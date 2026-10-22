local run_service = game:GetService("RunService")
local collection_service = game:GetService("CollectionService")
local attributes = require("../mod/attributes")
local tween = require("../mod/tween")
require("../types")
local utility = require("../mod/utility")
local promise = require("../pkg/Promise")
require("../obj/ObjectCache")
local random = Random.new()
local shockwave_debris = {}
local items = {}
local value = nil
local connection = nil

function shockwave_debris.init(argument)
    if connection then
        return
    end

    value = argument

    if not utility.PLUGIN_CONTEXT then
        return
    end

    connection = run_service.RenderStepped:Connect(function(delta_time)
        if #items == 0 then
            return
        end

        workspace:StepPhysics(delta_time, items)
    end)
end

function shockwave_debris.deinit()
    if connection then
        connection:Disconnect()
        connection = nil
    end

    value = nil

    for _, instance in items do
        instance:Destroy()
    end

    table.clear(items)
end

function shockwave_debris.emit(argument: userdata, instance: userdata, items_2: any)
    if not value then
        return
    end

    local get_result = attributes.get(instance, "InheritanceEnabled", true)
    local get_result_2 = attributes.get(instance, "InheritanceRadius", 5)
    local collision_group = attributes.get(argument, "RayCollisionGroup", "Default")
    local get_result_3 = attributes.get(argument, "FilterTag", "")
    local get_result_4 = attributes.get(argument, "FilterType", "Exclude")
    local get_result_5 = attributes.get(argument, "IgnoreCanCollide", false)
    local overlap_params

    if get_result then
        local max_parts = attributes.get(instance, "InheritanceMaxResults", 5)
        overlap_params = OverlapParams.new()
        overlap_params.MaxParts = max_parts
        overlap_params.CollisionGroup = collision_group
        overlap_params.RespectCanCollide = not get_result_5
        overlap_params.FilterType = Enum.RaycastFilterType[get_result_4]
        overlap_params.FilterDescendantsInstances = collection_service:GetTagged(get_result_3)

        if get_result_4 == "Exclude" then
            overlap_params:AddToFilter({ workspace.Terrain })
        end
    else
        overlap_params = nil
    end

    local get_result_6 = attributes.get(instance, "EmitDelay", 0)
    local range = attributes.getRange(instance, "Amount", NumberRange.new(5, 10), NumberRange.new(0, (1 / 0)))
    local range2 = attributes.getRange(instance, "Lifetime", NumberRange.new(2, 3), NumberRange.new(0, (1 / 0)))
    local range3 = attributes.getRange(instance, "Airtime", NumberRange.new(0.5, 0.5), NumberRange.new(0, (1 / 0)))
    local range4 = attributes.getRange(instance, "LinearMagnitude", NumberRange.new(15, 25))
    local range5 = attributes.getRange(instance, "AngularMagnitude", NumberRange.new(5, 15))
    local get_result_7 = attributes.get(instance, "SizeScaleEnd", Vector3.new(0, 0, 0))
    local get_result_8 = attributes.get(instance, "MinSize", Vector3.new(2, 1, 2))
    local get_result_9 = attributes.get(instance, "MaxSize", Vector3.new(3, 2, 3))
    local get_result_10 = attributes.get(instance, "MinDirection", Vector3.new(-1, -1, -1))
    local get_result_11 = attributes.get(instance, "MaxDirection", Vector3.new(1, 1, 1))
    local next_integer_result = random:NextInteger(range.Min, range.Max)
    local get_result_12 = attributes.get(instance, "Size_Curve", utility.default_bezier)
    local get_result_13 = attributes.get(instance, "Transparency_Curve", utility.default_bezier)
    local get_result_14 = attributes.get(instance, "Transparency_Duration", 0.5)
    local get_result_15 = attributes.get(instance, "Size_Duration", 0.5)
    local transparency = attributes.get(instance, "Transparency_Start", 0)
    local get_result_16 = attributes.get(instance, "Transparency_End", 1)
    local items_3 = {}
    local items_4 = {}
    instance.CanCollide = false
    local transformed_origin_extents = utility.getTransformedOriginExtents(argument)
    local position = transformed_origin_extents.Position

    if overlap_params then
        for _, item in workspace:GetPartBoundsInRadius(position, get_result_2, overlap_params) do
            if item.Transparency ~= 1 then
                table.insert(items_3, item)
            end
        end
    end

    task.wait(get_result_6)

    for index = 1, next_integer_result do
        local enabled

        if #items_3 == 0 then
            enabled = false
        else
            enabled = items_3[random:NextInteger(1, #items_3)]
        end

        local random_id = utility.getRandomId()
        local get_result_17 = value:get(random_id)
        local parent = get_result_17._getReal()
        utility.copyProperties(instance, parent, utility.COPY_PART_PROPERTIES)
        utility.copyProperties(instance, parent, utility.COPY_EXTENDED_PART_PROPERTIES)
        local index_2

        if #instance:GetChildren() == 0 then
            index_2 = index
        else
            local clone = instance:Clone()
            index_2 = index

            for _, child in clone:GetChildren() do
                child.Parent = parent
            end

            clone:Destroy()
        end

        local prepare_emit_on_finish_result = items_2.effects.prepareEmitOnFinish(parent, items_2)
        local prepare_emit_folder_result = items_2.effects.prepareEmitFolder(parent, "EmitOnImpact", items_2)

        if prepare_emit_folder_result and #prepare_emit_folder_result:GetChildren() > 0 then
            local connection_2 = nil
            connection_2 = parent.Touched:Connect(function(hit)
                if
                    not (get_result_5 or hit:CanCollideWith(parent))
                    or (hit:IsDescendantOf(workspace.Terrain) or get_result_4 == "Exclude" and hit:HasTag(get_result_3))
                then
                    return
                end

                connection_2:Disconnect()
                local finished_2 = items_2.effects.emitFromFolder(
                    prepare_emit_folder_result,
                    parent,
                    items_2.depth + 1,
                    items_2
                ).Finished
                table.insert(items_4, finished_2)
            end)

            table.insert(items_2, function()
                if connection_2 then
                    connection_2:Disconnect()
                    connection_2 = nil
                end
            end)
        end

        get_result_17.Anchored = false
        get_result_17.CanCollide = true

        if get_result_17.CollisionGroup == "Default" then
            get_result_17.CollisionGroup = "ForgeDebris"
        end

        get_result_17.CFrame = CFrame.new(position)
        local next_number_result = random:NextNumber(get_result_8.X, get_result_9.X)
        local next_number_result_2 = random:NextNumber(get_result_8.Y, get_result_9.Y)
        local vector =
            Vector3.new(next_number_result, next_number_result_2, random:NextNumber(get_result_8.Z, get_result_9.Z))
        get_result_17.Size = vector

        if enabled then
            get_result_17.Material = enabled.Material
            get_result_17.Color = enabled.Color
            get_result_17.Transparency = enabled.Transparency
        else
            get_result_17.Transparency = transparency
        end

        table.insert(items_2, function()
            local match_index = table.find(items, parent)

            if match_index then
                table.remove(items, match_index)
            end

            if value then
                value:free(random_id)
            end
        end)

        table.insert(items, parent)
        get_result_17.AssemblyLinearVelocity =
            transformed_origin_extents:VectorToWorldSpace(get_result_17.AssemblyLinearVelocity)
        local world_vector =
            transformed_origin_extents:VectorToWorldSpace((utility.randomUnitVector(get_result_10, get_result_11)))
        get_result_17:ApplyImpulse(
            get_result_17.AssemblyMass
                * utility.getImpulseForce(
                    position,
                    position + world_vector.Unit * random:NextNumber(range4.Min, range4.Max),
                    random:NextNumber(range3.Min, range3.Max)
                )
        )
        get_result_17:ApplyAngularImpulse(
            get_result_17.AssemblyMass * random:NextUnitVector() * random:NextNumber(range5.Min, range5.Max)
        )
        local finished = items_2.effects.emitNested(parent, items_2.depth + 1, items_2).Finished
        table.insert(items_4, finished)

        task.delay(random:NextNumber(range2.Min, range2.Max), function()
            local size = get_result_17.Size
            local transparency_2 = get_result_17.Transparency

            if size ~= vector * get_result_7 then
                table.insert(
                    items_2,
                    tween.fromParams(get_result_12, get_result_15, function(argument_2, argument_3)
                        get_result_17.Size = size:Lerp(vector * get_result_7, argument_2)

                        return argument_3
                    end)
                )
            end

            if transparency_2 ~= get_result_16 then
                table.insert(
                    items_2,
                    tween.fromParams(get_result_13, get_result_14, function(argument_2, argument_3)
                        get_result_17.Transparency = utility.lerp(transparency_2, get_result_16, argument_2)

                        return argument_3
                    end)
                )
            end

            local finished2 =
                items_2.effects.emitOnFinish(prepare_emit_on_finish_result, parent, items_2.depth + 1, items_2).Finished
            table.insert(items_4, finished2)
        end)
    end

    task.wait(range2.Max + math.max(get_result_14, get_result_15))
    promise.all(items_4):await()
end

return shockwave_debris
