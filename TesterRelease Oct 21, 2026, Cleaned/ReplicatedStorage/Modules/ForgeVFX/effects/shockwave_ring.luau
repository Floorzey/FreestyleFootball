local collection_service = game:GetService("CollectionService")
local attributes = require("../mod/attributes")
local tween = require("../mod/tween")
require("../types")
local utility = require("../mod/utility")
local promise = require("../pkg/Promise")
require("../obj/ObjectCache")
local random = Random.new()
local shockwave_ring = {}
local value = nil

function shockwave_ring.init(argument)
    value = argument
end

function shockwave_ring.deinit()
    value = nil
end

function shockwave_ring.emit(argument: userdata, instance: userdata, items: any)
    if not value then
        return
    end

    local get_result = attributes.get(argument, "RayDirection", Vector3.new(0, -50, 0))
    local collision_group = attributes.get(argument, "RayCollisionGroup", "Default")
    local get_result_2 = attributes.get(argument, "FilterTag", "")
    local get_result_3 = attributes.get(argument, "FilterType", "Exclude")
    local ignore_water = attributes.get(argument, "IgnoreWater", true)
    local get_result_4 = attributes.get(argument, "IgnoreCanCollide", false)
    local raycast_params = RaycastParams.new()
    raycast_params.CollisionGroup = collision_group
    raycast_params.IgnoreWater = ignore_water
    raycast_params.RespectCanCollide = not get_result_4
    raycast_params.FilterType = Enum.RaycastFilterType[get_result_3]
    raycast_params.FilterDescendantsInstances = collection_service:GetTagged(get_result_2)

    if get_result_3 == "Exclude" then
        raycast_params:AddToFilter({ workspace.Terrain })
    end

    local get_result_5 = attributes.get(instance, "EmitDelay", 0)
    local get_result_6 = attributes.get(instance, "Radius", 5)
    local get_result_7 = attributes.get(instance, "Segments", 7)
    local range = attributes.getRange(instance, "Lifetime", NumberRange.new(2, 3), NumberRange.new(0, (1 / 0)))
    local get_result_8 = attributes.get(instance, "PartOffset", Vector3.new(0, 0, 0), true)
    local get_result_9 = attributes.get(instance, "BaseOffset", get_result_8)
    local get_result_10 = attributes.get(instance, "Offset_Start", get_result_8)
    local get_result_11 = attributes.get(instance, "Offset_End", get_result_8)
    local get_result_12 = attributes.get(instance, "Offset_Start_Duration", 0.5)
    local get_result_13 = attributes.get(instance, "Offset_End_Duration", 0.5)
    local get_result_14 = attributes.get(instance, "SizeScaleStart", Vector3.new(0, 0, 0))
    local get_result_15 = attributes.get(instance, "SizeScaleEnd", Vector3.new(0, 0, 0))
    local get_result_16 = attributes.get(instance, "MinSize", Vector3.new(2, 1, 2))
    local get_result_17 = attributes.get(instance, "MaxSize", Vector3.new(3, 2, 3))
    local get_result_18 = attributes.get(instance, "Size_Curve", utility.default_bezier, true)
    local get_result_19 = attributes.get(instance, "Size_Duration", 0.5, true)
    local get_result_20 = attributes.get(instance, "Size_Start_Curve", get_result_18)
    local get_result_21 = attributes.get(instance, "Size_End_Curve", get_result_18)
    local get_result_22 = attributes.get(instance, "Size_Start_Duration", get_result_19)
    local get_result_23 = attributes.get(instance, "Size_End_Duration", get_result_19)
    local get_result_24 = attributes.get(instance, "Transparency_Duration", 0.5)
    local transparency = attributes.get(instance, "Transparency_Start", 0)
    local get_result_25 = attributes.get(instance, "Transparency_End", 0)
    task.wait(get_result_5)
    local transformed_origin_extents = utility.getTransformedOriginExtents(argument)
    local items_2 = {}

    for index = 0, get_result_7 - 1 do
        local product = index / get_result_7 * 3.141592653589793 * 2
        local product_2 = get_result_6 * math.cos(product)
        local product_3 = get_result_6 * math.sin(product)
        local raycast_result = workspace:Raycast(
            (transformed_origin_extents * CFrame.new(product_2, 0, product_3)).Position,
            transformed_origin_extents:VectorToWorldSpace(get_result),
            raycast_params
        )
        local index_2

        if raycast_result then
            local next_number_result = random:NextNumber(get_result_16.X, get_result_17.X)
            local next_number_result_2 = random:NextNumber(get_result_16.Y, get_result_17.Y)
            local next_number_result_3 = random:NextNumber(get_result_16.Z, get_result_17.Z)
            local random_id = utility.getRandomId()
            local get_result_26 = value:get(random_id)
            local parent = get_result_26._getReal()
            utility.copyProperties(instance, parent, utility.COPY_PART_PROPERTIES)
            utility.copyProperties(instance, parent, utility.COPY_EXTENDED_PART_PROPERTIES)

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

            local prepare_emit_on_finish_result = items.effects.prepareEmitOnFinish(get_result_26, items)

            table.insert(items, function()
                if value then
                    value:free(random_id)
                end
            end)

            get_result_26.Color = raycast_result.Instance.Color
            get_result_26.Material = raycast_result.Material
            get_result_26.Transparency = raycast_result.Instance.Transparency

            if get_result_26.Transparency == 0 then
                get_result_26.Transparency = transparency
            end

            get_result_26.Size = Vector3.new(0, 0, 0)
            local negated_value = -math.cos(product)
            local negated_value_2 = -math.sin(product)
            local unit = transformed_origin_extents
                :VectorToWorldSpace((Vector3.new(negated_value, 0, negated_value_2)))
                :Cross(raycast_result.Normal).Unit
            local product_4 = CFrame.fromMatrix(raycast_result.Position, unit, raycast_result.Normal)
                * CFrame.fromOrientation(-math.atan(next_number_result_2 / next_number_result_3), 0, 0)
            get_result_26.CFrame = CFrame.new(get_result_10) * product_4
            local connection = nil
            local connection_2 = nil
            local vector = Vector3.new(0, 0, 0)

            if get_result_10 ~= get_result_9 then
                connection_2 = tween.fromParams(
                    attributes.get(instance, "Offset_Start_Curve", utility.default_bezier),
                    get_result_12,
                    function(argument_2, argument_3)
                        vector = get_result_10:Lerp(get_result_9, argument_2)
                        get_result_26.CFrame = CFrame.new(vector) * product_4

                        return argument_3
                    end
                )
                table.insert(items, connection)
            end

            local vector_2 = Vector3.new(next_number_result, next_number_result_2, next_number_result_3)

            if vector_2 * get_result_14 == vector_2 then
                get_result_26.Size = vector_2 * get_result_14
            else
                connection = tween.fromParams(get_result_20, get_result_22, function(argument_2, argument_3)
                    get_result_26.Size = (vector_2 * get_result_14):Lerp(vector_2, argument_2)

                    return argument_3
                end)
                table.insert(items, connection)
            end

            local finished = items.effects.emitNested(get_result_26, items.depth + 1, items).Finished
            table.insert(items_2, finished)

            task.delay(random:NextNumber(range.Min, range.Max), function()
                if connection then
                    connection:Disconnect()
                end

                if connection_2 then
                    connection_2:Disconnect()
                end

                local size = get_result_26.Size
                local transparency_2 = get_result_26.Transparency

                if size ~= vector_2 * get_result_15 then
                    table.insert(
                        items,
                        tween.fromParams(get_result_21, get_result_23, function(argument_2, argument_3)
                            get_result_26.Size = size:Lerp(vector_2 * get_result_15, argument_2)

                            return argument_3
                        end)
                    )
                end

                if vector ~= get_result_11 then
                    local from_params = tween.fromParams
                    local get_result_27 = attributes.get(instance, "Offset_End_Curve", utility.default_bezier)
                    table.insert(
                        items,
                        from_params(get_result_27, get_result_13, function(argument_2, argument_3)
                            get_result_26.CFrame = CFrame.new(vector:Lerp(get_result_11, argument_2)) * product_4

                            return argument_3
                        end)
                    )
                end

                if transparency_2 ~= get_result_25 then
                    local from_params_2 = tween.fromParams
                    local get_result_28 = attributes.get(instance, "Transparency_Curve", utility.default_bezier)
                    table.insert(
                        items,
                        from_params_2(get_result_28, get_result_24, function(argument_2, argument_3)
                            get_result_26.Transparency = utility.lerp(transparency_2, get_result_25, argument_2)

                            return argument_3
                        end)
                    )
                end

                local finished2 = items.effects.emitOnFinish(
                    prepare_emit_on_finish_result,
                    get_result_26,
                    items.depth + 1,
                    items
                ).Finished
                table.insert(items_2, finished2)
            end)
        else
            index_2 = index
        end
    end

    task.wait(range.Max + math.max(get_result_23, get_result_13))
    promise.all(items_2):await()
end

return shockwave_ring
