local collection_service = game:GetService("CollectionService")
local attributes = require("../mod/attributes")
local tween = require("../mod/tween")
require("../types")
local logger = require("../mod/logger")
local utility = require("../mod/utility")
local bezier = require("../obj/Bezier")
local promise = require("../pkg/Promise")
require("../obj/ObjectCache")
local random = Random.new()
local shockwave_line = {}
local value = nil

function shockwave_line.init(argument)
    value = argument
end

function shockwave_line.deinit()
    value = nil
end

function shockwave_line.emit(argument: userdata, instance: userdata, items: any)
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
    local get_result_6 = attributes.get(instance, "Rate_Start", 30)
    local get_result_7 = attributes.get(instance, "Rate_End", 30)
    local get_result_8 = attributes.get(instance, "FixedAmount", 0)
    local get_result_9 = attributes.get(instance, "Scale_Start", 1)
    local get_result_10 = attributes.get(instance, "Scale_End", 1)
    local get_result_11 = attributes.get(instance, "Duration", 1)
    local get_result_12 = attributes.get(instance, "Direction", Vector3.new(0, 0, -1))
    local get_result_13 = attributes.get(instance, "Length", 50)
    local range = attributes.getRange(instance, "Rotation", NumberRange.new(-180, 180))
    local get_result_14 = attributes.get(instance, "PartOffset", Vector3.new(0, 0, 0), true)
    local get_result_15 = attributes.get(instance, "BaseOffset", get_result_14)
    local get_result_16 = attributes.get(instance, "Offset_Start", get_result_14)
    local get_result_17 = attributes.get(instance, "Offset_End", get_result_14)
    local get_result_18 = attributes.get(instance, "Offset_Start_Duration", 0.5)
    local get_result_19 = attributes.get(instance, "Offset_End_Duration", 0.5)
    local range2 = attributes.getRange(instance, "Lifetime", NumberRange.new(2, 3), NumberRange.new(0, (1 / 0)))
    local get_result_20 = attributes.get(instance, "SizeScaleStart", Vector3.new(0, 0, 0))
    local get_result_21 = attributes.get(instance, "SizeScaleEnd", Vector3.new(0, 0, 0))
    local get_result_22 = attributes.get(instance, "MinSize", Vector3.new(2, 1, 2))
    local get_result_23 = attributes.get(instance, "MaxSize", Vector3.new(3, 2, 3))
    local get_result_24 = attributes.get(instance, "Size_Curve", utility.default_bezier, true)
    local get_result_25 = attributes.get(instance, "Size_Duration", 0.5, true)
    local get_result_26 = attributes.get(instance, "Size_Start_Curve", get_result_24)
    local get_result_27 = attributes.get(instance, "Size_End_Curve", get_result_24)
    local get_result_28 = attributes.get(instance, "Size_Start_Duration", get_result_25)
    local get_result_29 = attributes.get(instance, "Size_End_Duration", get_result_25)
    local get_result_30 = attributes.get(instance, "Transparency_Duration", 0.5)
    local transparency = attributes.get(instance, "Transparency_Start", 0)
    local get_result_31 = attributes.get(instance, "Transparency_End", 0)
    local get_result_32 = attributes.get(instance, "SyncPosition", false)
    local maximum = math.max(get_result_11, 0.001)

    if get_result_8 > 0 then
        get_result_6 = get_result_8 / maximum
        get_result_7 = get_result_6
    end

    local unit = get_result_12.Unit
    local vector = unit ~= unit and Vector3.new(-0, -0, -1) or unit
    task.wait(get_result_5)
    local items_2 = {}
    local transformed_origin_extents = utility.getTransformedOriginExtents(argument)
    local number = 0
    local number_2 = 0
    local get_result_33 = get_result_6
    local get_result_34 = get_result_9

    if get_result_9 ~= get_result_10 then
        local from_params = tween.fromParams
        local get_result_35 = attributes.get(instance, "Scale_Curve", utility.default_bezier)
        table.insert(
            items,
            from_params(get_result_35, maximum, function(argument_2, argument_3)
                get_result_34 = utility.lerp(get_result_9, get_result_10, argument_2)

                return argument_3
            end)
        )
    end

    if get_result_6 ~= get_result_7 then
        local from_params_2 = tween.fromParams
        local get_result_36 = attributes.get(instance, "Rate_Curve", utility.default_bezier)
        table.insert(
            items,
            from_params_2(get_result_36, maximum, function(argument_2, argument_3)
                get_result_33 = utility.lerp(get_result_6, get_result_7, argument_2)

                return argument_3
            end)
        )
    end

    local get_result_37 = attributes.get(instance, "Path_Curve", utility.linear_bezier)
    local success, result = pcall(function()
        return utility.deserializePath(get_result_37)
    end)

    if not success then
        logger.error(`failed to decode bezier path data with error: {result}`)
    end

    local bezier_2 = bezier.new(result, 0)
    table.insert(
        items,
        tween.fromParams(utility.linear_bezier, maximum, function(argument_2, argument_3)
            number = number + argument_3
            local quotient = 1 / get_result_33
            local product = maximum * get_result_33

            if number < quotient or product <= number_2 then
                return argument_3
            end

            for index = 1, number // quotient do
                local index_2

                if product <= number_2 then
                    index_2 = index
                else
                    number_2 = number_2 + 1
                    local difference = 1 - bezier_2:getEase((math.clamp(number_2 / product, 0, 1))).y

                    if get_result_32 then
                        transformed_origin_extents = utility.getTransformedOriginExtents(argument)
                    end

                    local transformed_origin_extents2 = utility.getTransformedOriginExtents(argument)
                    local raycast_result = workspace:Raycast(
                        transformed_origin_extents.Position
                            + transformed_origin_extents:VectorToWorldSpace(vector) * get_result_13 * difference,
                        transformed_origin_extents2:VectorToWorldSpace(get_result),
                        raycast_params
                    )

                    if not raycast_result then
                        number = 0

                        return argument_3
                    end

                    local next_number_result = random:NextNumber(get_result_22.X, get_result_23.X)
                    local next_number_result_2 = random:NextNumber(get_result_22.Y, get_result_23.Y)
                    local next_number_result_3 = random:NextNumber(get_result_22.Z, get_result_23.Z)
                    local random_id = utility.getRandomId()
                    local get_result_38 = value:get(random_id)
                    local parent = get_result_38._getReal()
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

                    local prepare_emit_on_finish_result = items.effects.prepareEmitOnFinish(parent, items)

                    table.insert(items, function()
                        if value then
                            value:free(random_id)
                        end
                    end)

                    get_result_38.Color = raycast_result.Instance.Color
                    get_result_38.Material = raycast_result.Material
                    get_result_38.Transparency = raycast_result.Instance.Transparency

                    if get_result_38.Transparency == 0 then
                        get_result_38.Transparency = transparency
                    end

                    get_result_38.Size = Vector3.new(0, 0, 0)
                    local next_number_result_4 = random:NextNumber(range.Min, range.Max)
                    local negated_value = -math.cos(next_number_result_4)
                    local negated_value_2 = -math.sin(next_number_result_4)
                    local unit2 = transformed_origin_extents2
                        :VectorToWorldSpace((Vector3.new(negated_value, 0, negated_value_2)))
                        :Cross(raycast_result.Normal).Unit
                    local product_2 = CFrame.fromMatrix(raycast_result.Position, unit2, raycast_result.Normal)
                        * CFrame.fromOrientation(-math.atan(next_number_result_2 / next_number_result_3), 0, 0)
                    get_result_38.CFrame = CFrame.new(get_result_16) * product_2
                    local connection = nil
                    local connection_2 = nil
                    local vector_2 = Vector3.new(0, 0, 0)

                    if get_result_16 ~= get_result_15 then
                        connection_2 = tween.fromParams(
                            attributes.get(instance, "Offset_Start_Curve", utility.default_bezier),
                            get_result_18,
                            function(argument_4, argument_5)
                                vector_2 = get_result_16:Lerp(get_result_15, argument_4)
                                get_result_38.CFrame = CFrame.new(vector_2) * product_2

                                return argument_5
                            end
                        )
                        table.insert(items, connection_2)
                    end

                    local product_3 = Vector3.new(next_number_result, next_number_result_2, next_number_result_3)
                        * get_result_34

                    if product_3 * get_result_20 == product_3 then
                        get_result_38.Size = product_3 * get_result_20
                    else
                        connection = tween.fromParams(get_result_26, get_result_28, function(argument_4, argument_5)
                            get_result_38.Size = (product_3 * get_result_20):Lerp(product_3, argument_4)

                            return argument_5
                        end)
                        table.insert(items, connection)
                    end

                    local finished = items.effects.emitNested(parent, items.depth + 1, items).Finished
                    table.insert(items_2, finished)

                    task.delay(random:NextNumber(range2.Min, range2.Max), function()
                        if connection then
                            connection:Disconnect()
                        end

                        if connection_2 then
                            connection_2:Disconnect()
                        end

                        local size = get_result_38.Size
                        local transparency_2 = get_result_38.Transparency

                        if size ~= product_3 * get_result_21 then
                            table.insert(
                                items,
                                tween.fromParams(get_result_27, get_result_29, function(argument_4, argument_5)
                                    get_result_38.Size = size:Lerp(product_3 * get_result_21, argument_4)

                                    return argument_5
                                end)
                            )
                        end

                        if vector_2 ~= get_result_17 then
                            local from_params_3 = tween.fromParams
                            local get_result_39 = attributes.get(instance, "Offset_End_Curve", utility.default_bezier)
                            table.insert(
                                items,
                                from_params_3(get_result_39, get_result_19, function(argument_4, argument_5)
                                    get_result_38.CFrame = CFrame.new(vector_2:Lerp(get_result_17, argument_4))
                                        * product_2

                                    return argument_5
                                end)
                            )
                        end

                        if transparency_2 ~= get_result_31 then
                            local from_params_4 = tween.fromParams
                            local get_result_40 = attributes.get(instance, "Transparency_Curve", utility.default_bezier)
                            table.insert(
                                items,
                                from_params_4(get_result_40, get_result_30, function(argument_4, argument_5)
                                    get_result_38.Transparency = utility.lerp(transparency_2, get_result_31, argument_4)

                                    return argument_5
                                end)
                            )
                        end

                        local finished2 = items.effects.emitOnFinish(
                            prepare_emit_on_finish_result,
                            parent,
                            items.depth + 1,
                            items
                        ).Finished
                        table.insert(items_2, finished2)
                    end)
                end
            end

            number = number % quotient

            return argument_3
        end, nil, nil, true, utility.RENDER_PRIORITY + items.depth)
    )
    task.wait(range2.Max + maximum + math.max(get_result_29, get_result_19))
    promise.all(items_2):await()
end

return shockwave_line
