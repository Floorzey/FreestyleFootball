local attributes = require("../mod/attributes")
local tween = require("../mod/tween")
require("../types")
local utility = require("../mod/utility")
local bezier = require("../mod/common/bezier")
local bezier_2 = require("../obj/Bezier")
local promise = require("../pkg/Promise")
require("../obj/ObjectCache")
local lightning = {}
local value = nil

function lightning.init(argument)
    value = argument
end

function lightning.deinit()
    value = nil
end

local function read_lightning_attributes(argument: userdata)
    local shake_instance = {}
    local get_result = attributes.get(argument, "Segments", 8)
    shake_instance.segments = math.max(get_result, 2)
    shake_instance.jaggedness =
        attributes.getRange(argument, "Jaggedness", NumberRange.new(0.5, 1), NumberRange.new(0, (1 / 0)))
    shake_instance.offsetScale = attributes.get(argument, "OffsetScale", 1)
    shake_instance.refreshRate = attributes.get(argument, "RefreshRate", 15)
    shake_instance.independentSegments = attributes.get(argument, "IndependentSegments", false)
    shake_instance.refreshDuringDissipate = attributes.get(argument, "RefreshDuringDissipate", false)
    shake_instance.nestedEffectMode =
        attributes.getEnum(argument, "NestedEffectMode", "None", { "None", "All", "Head", "Tail" })
    shake_instance.colorSequence = attributes.get(argument, "Color", ColorSequence.new(Color3.new(1, 1, 1)))
    shake_instance.colorEasingData = attributes.get(argument, "Color_Curve", utility.linear_bezier)
    shake_instance.colorDuration = attributes.get(argument, "Color_Duration", 1)
    shake_instance.transparencyStart = attributes.get(argument, "Transparency_Start", 0)
    shake_instance.transparencyEnd = attributes.get(argument, "Transparency_End", 0)
    shake_instance.fillColorSequence = attributes.get(argument, "Fill_Color", ColorSequence.new(Color3.new(1, 1, 1)))
    shake_instance.fillColorEasingData = attributes.get(argument, "Fill_Color_Curve", utility.linear_bezier)
    shake_instance.fillColorDuration = attributes.get(argument, "Fill_Color_Duration", 1)
    shake_instance.fillTransparencyStart = attributes.get(argument, "Fill_Transparency_Start", 1)
    shake_instance.fillTransparencyEnd = attributes.get(argument, "Fill_Transparency_End", 1)
    shake_instance.fillDepthMode =
        attributes.getEnum(argument, "Fill_DepthMode", "Occluded", { "AlwaysOnTop", "Occluded" })
    shake_instance.fadeInStart = attributes.get(argument, "Fade_In_Start", 1)
    shake_instance.fadeInDuration = attributes.get(argument, "Fade_In_Duration", 0)
    shake_instance.fadeInCurveData = attributes.get(argument, "Fade_In_Curve", utility.default_bezier)
    shake_instance.fadeOutEnd = attributes.get(argument, "Fade_Out_End", 1)
    shake_instance.fadeOutDuration = attributes.get(argument, "Fade_Out_Duration", 0)
    shake_instance.fadeOutCurveData = attributes.get(argument, "Fade_Out_Curve", utility.default_bezier)
    shake_instance.lengthStart = attributes.get(argument, "Length_Start", 1)
    shake_instance.lengthEnd = attributes.get(argument, "Length_End", 1)
    shake_instance.dissipateMode =
        attributes.getEnum(argument, "Dissipate_Mode", "None", { "None", "Retract", "Scale" })
    shake_instance.dissipateDuration = attributes.get(argument, "Dissipate_Duration", 0.5)
    shake_instance.dissipateCurveData = attributes.get(argument, "Dissipate_Curve", utility.default_bezier)
    shake_instance.widthStart = attributes.get(argument, "Width_Start", 2)
    shake_instance.widthEnd = attributes.get(argument, "Width_End", 0.2)

    return shake_instance
end

local function create_segment_states(argument: number)
    local values = {}

    for index = 1, argument do
        values[index] = {
            birthTime = nil,
            initialWidth = nil,
            initialTransparency = nil,
            wasVisible = false,
        }
        local _ = index
    end

    return values
end

local function compute_jagged_offset(
    argument: userdata,
    argument_2,
    argument_3: number,
    argument_4: number,
    argument_5: vector,
    argument_6: vector
)
    local next_number_result = argument:NextNumber(argument_2.Min, argument_2.Max)
    local minimum = math.min(next_number_result * argument_3 * argument_4, argument_4 * 0.8)
    local next_number_result_2 = argument:NextNumber(0, 6.283185307179586)

    return (argument_5 * math.cos(next_number_result_2) + argument_6 * math.sin(next_number_result_2)) * minimum
end

local function generate_lightning_points(
    argument: userdata,
    argument_2: number,
    callback: (...any) -> ...any,
    argument_3,
    argument_4: number
)
    local create_result = table.create(argument_2 + 1)
    local quotient = 1 / argument_2
    create_result[1] = callback(0)
    local create_result_entry = create_result[1]

    for index = 1, argument_2 - 1 do
        local product = index * quotient
        local result = callback(product)
        local vector = callback((math.min(product + 0.01, 1))) - result
        local perpendicular_vectors, value_2 =
            bezier.getPerpendicularVectors(vector.Magnitude <= 0.001 and Vector3.new(0, 1, 0) or vector.Unit)
        local magnitude = (result - create_result_entry).Magnitude
        local next_number_result = argument:NextNumber(argument_3.Min, argument_3.Max)
        local minimum = math.min(next_number_result * argument_4 * magnitude, magnitude * 0.8)
        local next_number_result_2 = argument:NextNumber(0, 6.283185307179586)
        create_result_entry = result
            + (perpendicular_vectors * math.cos(next_number_result_2) + value_2 * math.sin(next_number_result_2))
                * minimum
        create_result[index + 1] = create_result_entry
        local _ = index
    end

    create_result[argument_2 + 1] = callback(1)

    return create_result
end

local function generate_projectile_points(
    argument: userdata,
    argument_2: number,
    argument_3: vector,
    argument_4: vector,
    argument_5,
    argument_6: number,
    quotient: vector
)
    local create_result = table.create(argument_2 + 1)
    local quotient_2 = 1 / argument_2
    local vector = argument_4 - argument_3
    local magnitude = vector.Magnitude

    if magnitude > 0.001 then
        quotient = vector / magnitude
    end

    local perpendicular_vectors, value_2 = bezier.getPerpendicularVectors(quotient)
    local product = magnitude * quotient_2
    create_result[1] = argument_3

    for index = 1, argument_2 - 1 do
        local interpolated_value = argument_3:Lerp(argument_4, index * quotient_2)
        local next_number_result = argument:NextNumber(argument_5.Min, argument_5.Max)
        local minimum = math.min(next_number_result * argument_6 * product, product * 0.8)
        local next_number_result_2 = argument:NextNumber(0, 6.283185307179586)
        local product_2 = (
            perpendicular_vectors * math.cos(next_number_result_2) + value_2 * math.sin(next_number_result_2)
        ) * minimum
        create_result[index + 1] = interpolated_value + product_2
        local _ = index
    end

    create_result[argument_2 + 1] = argument_4

    return create_result
end

local function get_blended_position(
    argument: number,
    callback: (...any) -> ...any,
    argument_2: vector,
    argument_3: vector,
    argument_4: table
)
    local clamped_value = math.clamp(
        (argument_4.distanceTraveled - (1 - argument) * argument_4.boltLength) / argument_4.transitionBuffer,
        0,
        1
    )
    local product = math.min(argument_4.distanceTraveled / argument_4.boltLength, 1) * argument_4.curvedLengthT

    return callback((math.min(1, argument_4.curvedTailT + argument * argument_4.curvedLengthT + product))):Lerp(
        argument_2:Lerp(argument_3, argument),
        clamped_value
    )
end

local function generate_transition_points(
    argument: userdata,
    argument_2: number,
    callback: (...any) -> ...any,
    argument_3: vector,
    argument_4: vector,
    argument_5,
    argument_6: number,
    quotient: vector,
    argument_7: table
)
    local create_result = table.create(argument_2 + 1)
    local create_result_2 = table.create(argument_2 + 1)
    local quotient_2 = 1 / argument_2
    local vector = argument_4 - argument_3
    local magnitude = vector.Magnitude

    if magnitude > 0.001 then
        quotient = vector / magnitude
    end

    local perpendicular_vectors, value_2 = bezier.getPerpendicularVectors(quotient)
    local product = magnitude * quotient_2

    for index = 0, argument_2 do
        local result = get_blended_position(index * quotient_2, callback, argument_3, argument_4, argument_7)
        local index_2

        if index == 0 or index == argument_2 then
            create_result[index + 1] = result
            create_result_2[index + 1] = Vector3.new(0, 0, 0)
            index_2 = index
        else
            local next_number_result = argument:NextNumber(argument_5.Min, argument_5.Max)
            local minimum = math.min(next_number_result * argument_6 * product, product * 0.8)
            local next_number_result_2 = argument:NextNumber(0, 6.283185307179586)
            local product_2 = (
                perpendicular_vectors * math.cos(next_number_result_2) + value_2 * math.sin(next_number_result_2)
            ) * minimum
            create_result[index + 1] = result + product_2
            create_result_2[index + 1] = product_2
            index_2 = index
        end
    end

    return create_result, create_result_2
end

local function update_transition_points(
    argument: number,
    callback: (...any) -> ...any,
    argument_2: vector,
    argument_3: vector,
    argument_4: table
)
    local create_result = table.create(argument + 1)
    local quotient = 1 / argument
    local jagged_offsets = argument_4.jaggedOffsets

    for index = 0, argument do
        local result = get_blended_position(index * quotient, callback, argument_2, argument_3, argument_4)
        create_result[index + 1] = result + (not jagged_offsets and Vector3.new(0, 0, 0) or jagged_offsets[index + 1])
        local _ = index
    end

    return create_result
end

local function is_transition_complete(argument: table)
    return argument.distanceTraveled >= argument.boltLength + argument.transitionBuffer
end

function lightning.emit(instance: userdata, argument: userdata, items: any, argument_2: boolean?)
    local points = instance:FindFirstChild("Points")

    if not (points and (points:IsA("Attachment") and value)) then
        return
    end

    local read_common_attributes_result = bezier.readCommonAttributes(instance)
    local shake_instance = read_lightning_attributes(instance)
    local draw_func_map_entry_entry = bezier.drawFuncMap[read_common_attributes_result.shapeType]
        and bezier.drawFuncMap[read_common_attributes_result.shapeType][read_common_attributes_result.shapeStyle]

    if not draw_func_map_entry_entry then
        return
    end

    local condition = read_common_attributes_result.emitDuration > 0
    task.wait(read_common_attributes_result.emitDelay)

    if condition and not argument_2 then
        utility.forceEmit(instance, true)
        attributes.trigger(instance, "Enabled", true)

        utility.onCancel(items, function()
            local stop_emit_duration_result = utility.stopEmitDuration(instance)

            if stop_emit_duration_result then
                utility.cancelToken(stop_emit_duration_result)
            end
        end)

        if read_common_attributes_result.speedStart ~= read_common_attributes_result.speedEnd then
            attributes.setState(instance, "SpeedTweening", true)
            local from_params = tween.fromParams
            local get_result = attributes.get(instance, "Speed_Curve", utility.default_bezier)
            local get_result_2 = attributes.get(instance, "Speed_Duration", 0.1)
            table.insert(
                items,
                from_params(
                    get_result,
                    get_result_2,
                    function(argument_3, argument_4)
                        attributes.setState(
                            instance,
                            "SpeedOverride",
                            utility.lerp(
                                read_common_attributes_result.speedStart,
                                read_common_attributes_result.speedEnd,
                                argument_3
                            )
                        )

                        return argument_4
                    end,
                    nil,
                    function()
                        attributes.setState(instance, "SpeedTweening", nil)
                    end
                )
            )
        end

        task.wait(read_common_attributes_result.emitDuration)
        utility.awaitEmitDuration(utility.stopEmitDuration(instance))

        return
    end

    if read_common_attributes_result.emitCount <= 0 then
        return
    end

    local validate_parent_result = bezier.validateParent(instance)

    if not validate_parent_result then
        return
    end

    local transformed_origin_extents, value_2 = utility.getTransformedOriginExtents(validate_parent_result)

    if not transformed_origin_extents then
        return
    end

    local find_end_attachments_result, value_3 = bezier.findEndAttachments(instance)
    local bezier_points = utility.getBezierPoints(points)
    local random = Random.new()
    local bezier_3 = not find_end_attachments_result and bezier_2.new(bezier_points)
    local bezier_4 = bezier_2.new(utility.deserializePath(shake_instance.colorEasingData), 0)
    local bezier_5 = bezier_2.new(utility.deserializePath(shake_instance.fillColorEasingData), 0)
    local bezier_6 = bezier_2.new(utility.deserializePath(shake_instance.fadeInCurveData), 0)
    local bezier_7 = bezier_2.new(utility.deserializePath(shake_instance.fadeOutCurveData), 0)
    local create_hitbox_params_result = bezier.createHitboxParams({
        enabled = read_common_attributes_result.hitboxEnabled,
        collisionGroup = read_common_attributes_result.hitboxCollisionGroup,
        filterTag = read_common_attributes_result.hitboxFilterTag,
        filterType = read_common_attributes_result.hitboxFilterType,
        ignoreCanCollide = read_common_attributes_result.hitboxIgnoreCanCollide,
    }, validate_parent_result, points)
    local items_2 = {}

    for index = 1, read_common_attributes_result.emitCount do
        local next_number_result =
            random:NextNumber(read_common_attributes_result.duration.Min, read_common_attributes_result.duration.Max)
        local next_number_result_2 = read_common_attributes_result.projectileEnabled
            and random:NextNumber(
                read_common_attributes_result.projectileLifetime.Min,
                read_common_attributes_result.projectileLifetime.Max
            )
        table.insert(
            items_2,
            promise.new(function(callback_2)
                local calculate_emission_c_frame_result = bezier.calculateEmissionCFrame(
                    transformed_origin_extents,
                    value_2,
                    {
                        face = read_common_attributes_result.face,
                        spreadAngle = read_common_attributes_result.spreadAngle,
                        mirror = read_common_attributes_result.mirror,
                        mirrorRot = read_common_attributes_result.mirrorRot,
                        partial = read_common_attributes_result.partial,
                        emissionDirection = read_common_attributes_result.emissionDirection,
                    },
                    draw_func_map_entry_entry,
                    random,
                    find_end_attachments_result,
                    validate_parent_result:IsA("Attachment")
                )
                local bezier_8 = bezier_3
                    or bezier.createBezierWithEndpoint(
                        bezier_points,
                        calculate_emission_c_frame_result,
                        find_end_attachments_result,
                        value_3
                    )
                local callback = bezier.createPosGetter(
                    bezier_8,
                    bezier_points,
                    calculate_emission_c_frame_result,
                    find_end_attachments_result,
                    true
                )
                local create_result = table.create(shake_instance.segments)
                local create_result_2 = table.create(shake_instance.segments)
                local result = create_segment_states(shake_instance.segments)
                local quotient_2 = 1 / shake_instance.segments
                local create_result_3 = table.create(shake_instance.segments)

                for index_2 = 1, shake_instance.segments do
                    create_result_3[index_2] = {
                        start = (index_2 - 1) * quotient_2,
                        finish = index_2 * quotient_2,
                    }
                    local _ = index_2
                end

                if not value then
                    callback_2()

                    return
                end

                local condition_2 = shake_instance.fillTransparencyStart < 1 and true
                    or shake_instance.fillTransparencyEnd < 1
                local lightning_container, highlight

                if condition_2 then
                    lightning_container = Instance.new("Model")
                    lightning_container.Name = "LightningContainer"
                    lightning_container.Parent = workspace.Terrain
                    highlight = Instance.new("Highlight")
                    highlight.Adornee = lightning_container
                    highlight.FillColor = bezier.getColorWithEasingOklab(shake_instance.fillColorSequence, 0, bezier_5)
                    highlight.FillTransparency = shake_instance.fillTransparencyStart
                    highlight.OutlineTransparency = 1
                    highlight.DepthMode = Enum.HighlightDepthMode[shake_instance.fillDepthMode]
                    highlight.Parent = lightning_container
                else
                    highlight = nil
                    lightning_container = nil
                end

                local function should_emit_nested(argument_3: number)
                    local nested_effect_mode_2 = shake_instance.nestedEffectMode

                    if nested_effect_mode_2 == "All" then
                        return true
                    end

                    if nested_effect_mode_2 == "Head" then
                        return argument_3 == shake_instance.segments
                    end

                    if nested_effect_mode_2 == "Tail" then
                        return argument_3 == 1
                    end

                    return false
                end

                local value_4

                if shake_instance.nestedEffectMode == "None" then
                    value_4 = nil
                else
                    value_4 = items.effects.prepareEmitOnFinish(argument, items)
                end

                local items_3 = {}
                local items_4 = {}

                for index_3 = 1, shake_instance.segments do
                    local random_id = utility.getRandomId()
                    local parent = value:get(random_id)._getReal()
                    utility.copyProperties(argument, parent, utility.COPY_PART_PROPERTIES)
                    parent.Size = Vector3.new(shake_instance.widthStart, shake_instance.widthStart, 1)
                    parent.Anchored = true
                    parent.CanQuery = false
                    parent.CanTouch = false
                    parent.CanCollide = false

                    if condition_2 and lightning_container then
                        parent.Parent = lightning_container
                    end

                    local nested_effect_mode = shake_instance.nestedEffectMode
                    local enabled

                    if nested_effect_mode == "All" then
                        enabled = true
                    elseif nested_effect_mode == "Head" then
                        enabled = index_3 == shake_instance.segments
                    elseif nested_effect_mode == "Tail" then
                        enabled = index_3 == 1
                    else
                        enabled = false
                    end

                    local index_4

                    if enabled then
                        local clone = argument:Clone()
                        index_4 = index_3

                        for _, child in clone:GetChildren() do
                            child.Parent = parent

                            if shake_instance.nestedEffectMode == "Head" then
                                table.insert(items_3, child)
                            end
                        end

                        clone:Destroy()
                        table.insert(items_4, index_4)
                    else
                        index_4 = index_3
                    end

                    create_result[index_4] = parent
                    create_result_2[index_4] = random_id
                end

                local number

                if shake_instance.nestedEffectMode == "Head" and #items_3 > 0 then
                    for _, item in items_3 do
                        item.Parent = create_result[1]
                    end

                    number = 1
                else
                    number = nil
                end

                table.insert(items, function()
                    if not value then
                        return
                    end

                    for index_5 = 1, shake_instance.segments do
                        value:free(create_result_2[index_5])
                        local _ = index_5
                    end

                    if lightning_container then
                        lightning_container:Destroy()
                    end
                end)

                local lightning_container_2 = lightning_container or argument
                local speed_start = read_common_attributes_result.speedStart
                local width_start = shake_instance.widthStart
                local length_start = shake_instance.lengthStart
                local transparency_start = shake_instance.transparencyStart
                local fill_transparency_start = shake_instance.fillTransparencyStart
                local result_2 = generate_lightning_points(
                    random,
                    shake_instance.segments,
                    callback,
                    shake_instance.jaggedness,
                    shake_instance.offsetScale
                )
                local number_2 = 0
                local enabled_2 = false
                local number_3 = 0
                local number_4 = 0

                for _, item_2 in items_4 do
                    local finished = items.effects.emitNested(
                        create_result[shake_instance.nestedEffectMode == "Head" and 1 or item_2],
                        items.depth + 1,
                        items
                    ).Finished
                    table.insert(items_2, finished)
                end

                local vector = Vector3.new(0, 0, 0)
                local vector_2 = Vector3.new(0, 0, 0)
                local number_5 = 0
                local enabled_3 = false
                local number_6 = 0
                local number_7 = 0
                local number_8 = 0
                local width_start2 = shake_instance.widthStart
                local transformed_origin_extents_2 = transformed_origin_extents
                local quotient = nil
                local value_5 = nil
                local value_6 = nil
                local value_7 = nil
                local value_8

                if
                    read_common_attributes_result.speedStart == read_common_attributes_result.speedEnd
                    or attributes.getState(instance, "SpeedOverride", nil)
                then
                    value_8 = nil
                else
                    value_8 = tween.fromParams(
                        attributes.get(instance, "Speed_Curve", utility.default_bezier),
                        attributes.get(instance, "Speed_Duration", 0.1),
                        function(argument_3, argument_4)
                            speed_start = utility.lerp(
                                read_common_attributes_result.speedStart,
                                read_common_attributes_result.speedEnd,
                                argument_3
                            )

                            return argument_4
                        end
                    )
                    table.insert(items, value_8)
                end

                local function get_effective_speed()
                    return attributes.getState(instance, "SpeedOverride", speed_start)
                end

                local function is_speed_tweening()
                    if value_8 then
                        return value_8.Connected
                    end

                    return attributes.getState(instance, "SpeedTweening", false)
                end

                local function get_speed_delta(argument_3: number, argument_4: boolean?)
                    local state = attributes.getState(instance, "SpeedOverride", speed_start)
                    speed_start = state

                    if state > 0 then
                        return argument_3 * state
                    end

                    if not argument_4 then
                        local connected

                        if value_8 then
                            connected = value_8.Connected
                        else
                            connected = attributes.getState(instance, "SpeedTweening", false)
                        end

                        if not connected then
                            return nil
                        end
                    end

                    return argument_3 * state
                end

                local function get_head_segment_index()
                    local rounded_value = math.ceil(number_6 * shake_instance.segments)

                    return math.clamp(rounded_value, 1, shake_instance.segments)
                end

                local function shapecast()
                    if not read_common_attributes_result.hitboxEnabled then
                        return false
                    end

                    local rounded_value = math.ceil(number_6 * shake_instance.segments)
                    local create_result_entry = create_result[math.clamp(rounded_value, 1, shake_instance.segments)]

                    return create_result_entry
                            and (create_result_entry.Transparency < 1 and workspace:GetPartsInPart(
                                create_result_entry,
                                create_hitbox_params_result
                            )[1])
                            and true
                        or false
                end

                local function refresh_points()
                    if value_5 and (value_6 and quotient) then
                        if value_7 then
                            local value_9 = value_7

                            if value_9.distanceTraveled < value_9.boltLength + value_9.transitionBuffer then
                                local result_3, jagged_offsets = generate_transition_points(
                                    random,
                                    shake_instance.segments,
                                    callback,
                                    value_6,
                                    value_5,
                                    shake_instance.jaggedness,
                                    shake_instance.offsetScale,
                                    quotient,
                                    value_7
                                )
                                result_2 = result_3
                                value_7.jaggedOffsets = jagged_offsets

                                return
                            end
                        end

                        result_2 = generate_projectile_points(
                            random,
                            shake_instance.segments,
                            value_6,
                            value_5,
                            shake_instance.jaggedness,
                            shake_instance.offsetScale,
                            quotient
                        )

                        if value_7 then
                            value_7.jaggedOffsets = nil
                        end
                    else
                        result_2 = generate_lightning_points(
                            random,
                            shake_instance.segments,
                            callback,
                            shake_instance.jaggedness,
                            shake_instance.offsetScale
                        )
                    end
                end

                local function update_points_between_refreshes(argument_3: number)
                    if value_7 then
                        local value_9 = value_7

                        if value_9.distanceTraveled < value_9.boltLength + value_9.transitionBuffer then
                            if value_7.jaggedOffsets then
                                result_2 = update_transition_points(
                                    shake_instance.segments,
                                    callback,
                                    value_6,
                                    value_5,
                                    value_7
                                )

                                return
                            end

                            local result_3, jagged_offsets = generate_transition_points(
                                random,
                                shake_instance.segments,
                                callback,
                                value_6,
                                value_5,
                                shake_instance.jaggedness,
                                shake_instance.offsetScale,
                                quotient,
                                value_7
                            )
                            result_2 = result_3
                            value_7.jaggedOffsets = jagged_offsets

                            return
                        end
                    end

                    local product = quotient * read_common_attributes_result.projectileSpeed * argument_3

                    for index_5 = 1, #result_2 do
                        result_2[index_5] = result_2[index_5] + product
                        local _ = index_5
                    end
                end

                local function update_segments(
                    argument_3: number,
                    argument_4: number?,
                    argument_5: number,
                    enabled_4: boolean?,
                    argument_6: number?
                )
                    local birth_time = os.clock()
                    number_6 = argument_3
                    local maximum = argument_4 or math.max(0, argument_3 - length_start)
                    local width_start_2 = argument_6 or width_start

                    if enabled_4 ~= false and shake_instance.refreshRate > 0 then
                        number_2 = number_2 + argument_5

                        if 1 / shake_instance.refreshRate <= number_2 then
                            refresh_points()
                            number_2 = 0
                        end
                    end

                    for index_5 = 1, shake_instance.segments do
                        local result_entry = result[index_5]
                        local create_result_entry = create_result_3[index_5]
                        local create_result_entry_2 = create_result[index_5]
                        local start = create_result_entry.start
                        local finish = create_result_entry.finish
                        local condition_3

                        if maximum < finish then
                            condition_3 = start < argument_3
                        else
                            condition_3 = false
                        end

                        local index_6

                        if condition_3 then
                            if not result_entry.wasVisible then
                                result_entry.wasVisible = true
                                result_entry.birthTime = birth_time
                                result_entry.initialWidth = width_start
                                result_entry.initialTransparency = transparency_start
                            end

                            create_result_entry_2.Color =
                                bezier.getColorWithEasingOklab(shake_instance.colorSequence, number_3, bezier_4)
                            local initial_transparency

                            if shake_instance.independentSegments and result_entry.initialTransparency then
                                initial_transparency = result_entry.initialTransparency
                            else
                                initial_transparency = transparency_start
                            end

                            local clamped_value = shake_instance.fadeInDuration <= 0 and 1
                                or math.clamp(number_5 / shake_instance.fadeInDuration, 0, 1)
                            local difference = 1 - bezier_6:getEase(clamped_value).y
                            local interpolated_value =
                                utility.lerp(shake_instance.fadeInStart, initial_transparency, difference)
                            local interpolated_value_2

                            if enabled_3 and shake_instance.fadeOutDuration > 0 then
                                local difference_2 = 1
                                    - bezier_7:getEase((math.clamp(number_7 / shake_instance.fadeOutDuration, 0, 1))).y
                                interpolated_value_2 =
                                    utility.lerp(initial_transparency, shake_instance.fadeOutEnd, difference_2)
                            else
                                interpolated_value_2 = initial_transparency
                            end

                            if clamped_value < 1 then
                                initial_transparency = interpolated_value
                            elseif enabled_3 then
                                initial_transparency = interpolated_value_2
                            end

                            create_result_entry_2.Transparency = initial_transparency
                            local product

                            if argument_6 then
                                local initial_width

                                if shake_instance.independentSegments and result_entry.initialWidth then
                                    initial_width = result_entry.initialWidth
                                else
                                    initial_width = width_start
                                end

                                product = initial_width * (width_start <= 0 and 0 or argument_6 / width_start)
                            elseif shake_instance.independentSegments and result_entry.initialWidth then
                                product = result_entry.initialWidth
                            else
                                product = width_start_2
                            end

                            local result_entry_2 = result_2[index_5]
                            local result_entry_3 = result_2[index_5 + 1]

                            if result_entry_2 and result_entry_3 then
                                local interpolated_value_3

                                if start < maximum then
                                    interpolated_value_3 =
                                        result_entry_2:Lerp(result_entry_3, (maximum - start) / (finish - start))
                                else
                                    interpolated_value_3 = result_entry_2
                                end

                                if argument_3 < finish then
                                    result_entry_3 =
                                        result_entry_2:Lerp(result_entry_3, (argument_3 - start) / (finish - start))
                                end

                                local quotient_3 = (interpolated_value_3 + result_entry_3) / 2
                                local magnitude = (result_entry_3 - interpolated_value_3).Magnitude

                                if magnitude > 0.001 then
                                    create_result_entry_2.Size = Vector3.new(product, product, magnitude)
                                    create_result_entry_2.CFrame = CFrame.lookAt(quotient_3, result_entry_3)
                                    index_6 = index_5
                                else
                                    index_6 = index_5
                                end
                            else
                                index_6 = index_5
                            end
                        else
                            create_result_entry_2.Transparency = 1

                            if result_entry.wasVisible then
                                result_entry.wasVisible = false
                                result_entry.birthTime = nil
                                result_entry.initialWidth = nil
                                result_entry.initialTransparency = nil
                                index_6 = index_5
                            else
                                index_6 = index_5
                            end
                        end
                    end

                    if highlight then
                        highlight.FillColor =
                            bezier.getColorWithEasingOklab(shake_instance.fillColorSequence, number_4, bezier_5)
                        highlight.FillTransparency = fill_transparency_start
                    end

                    if number then
                        local rounded_value = math.ceil(number_6 * shake_instance.segments)
                        local clamped_value_2 = math.clamp(rounded_value, 1, shake_instance.segments)

                        if clamped_value_2 ~= number then
                            local parent_2 = create_result[clamped_value_2]

                            for _, item_3 in items_3 do
                                item_3.Parent = parent_2
                            end

                            number = clamped_value_2
                        end
                    end

                    local result_3 = callback((math.min(argument_3, 1)))

                    if argument_5 > 0 then
                        vector = (result_3 - vector_2) / argument_5
                    end

                    vector_2 = result_3
                end

                bezier.createPropertyTween(
                    items,
                    instance,
                    "Width",
                    next_number_result,
                    shake_instance.widthStart,
                    shake_instance.widthEnd,
                    function(argument_3)
                        width_start = argument_3
                    end,
                    get_effective_speed,
                    value_8
                )

                bezier.createPropertyTween(
                    items,
                    instance,
                    "Transparency",
                    next_number_result,
                    shake_instance.transparencyStart,
                    shake_instance.transparencyEnd,
                    function(argument_3)
                        transparency_start = argument_3
                    end,
                    get_effective_speed,
                    value_8
                )

                bezier.createPropertyTween(
                    items,
                    instance,
                    "Length",
                    next_number_result,
                    shake_instance.lengthStart,
                    shake_instance.lengthEnd,
                    function(argument_3)
                        length_start = argument_3
                    end,
                    get_effective_speed,
                    value_8
                )

                if condition_2 then
                    bezier.createPropertyTween(
                        items,
                        instance,
                        "FillTransparency",
                        shake_instance.fillColorDuration,
                        shake_instance.fillTransparencyStart,
                        shake_instance.fillTransparencyEnd,
                        function(argument_3)
                            fill_transparency_start = argument_3
                        end,
                        get_effective_speed,
                        value_8
                    )
                end

                local function handle_dissipation(
                    argument_3: number,
                    argument_4: number,
                    argument_5: number,
                    argument_6: string,
                    argument_7: number,
                    argument_8: string,
                    argument_9: (...any) -> ...any
                )
                    enabled_3 = true
                    number_8 = argument_4
                    width_start2 = argument_5

                    tween.fromParams(argument_6, argument_7, function(argument_10, argument_11, argument_12)
                        number_7 = argument_12
                        local product = argument_11 * attributes.getState(instance, "SpeedOverride", speed_start)
                        number_5 = number_5 + product

                        if shake_instance.refreshDuringDissipate then
                            number_3 = (number_3 + product / shake_instance.colorDuration) % 1
                            number_4 = (number_4 + product / shake_instance.fillColorDuration) % 1
                        end

                        local interpolated_value

                        if argument_8 == "Retract" then
                            interpolated_value = utility.lerp(number_8, argument_3, argument_10)
                        else
                            interpolated_value = nil
                        end

                        local interpolated_value_2

                        if argument_8 == "Scale" then
                            interpolated_value_2 = utility.lerp(width_start2, 0, argument_10)
                        else
                            interpolated_value_2 = nil
                        end

                        update_segments(
                            argument_3,
                            interpolated_value,
                            product,
                            shake_instance.refreshDuringDissipate,
                            interpolated_value_2
                        )
                        local state = attributes.getState(instance, "SpeedOverride", speed_start)
                        speed_start = state

                        if state > 0 then
                            return argument_11 * state
                        end

                        return argument_11 * state
                    end, value_8, argument_9, true, utility.RENDER_PRIORITY + items.depth)
                end

                local function start_dissipation()
                    if enabled_3 or enabled_2 then
                        return
                    end

                    local number_9 = number_6
                    local emit_on_finish_result

                    if value_4 then
                        emit_on_finish_result =
                            items.effects.emitOnFinish(value_4, lightning_container_2, items.depth + 1, items)
                    else
                        emit_on_finish_result = nil
                    end

                    local function on_dissipation_complete()
                        if enabled_2 then
                            return
                        end

                        enabled_2 = true

                        if emit_on_finish_result then
                            emit_on_finish_result.Finished:finally(function()
                                callback_2()
                            end)

                            return
                        end

                        callback_2()
                    end

                    if shake_instance.dissipateMode ~= "None" then
                        local maximum = math.max(0, number_9 - length_start)
                        local dissipate_mode = shake_instance.dissipateMode
                        enabled_3 = true
                        number_8 = maximum
                        width_start2 = width_start

                        tween.fromParams(
                            shake_instance.dissipateCurveData,
                            shake_instance.dissipateDuration,
                            function(argument_3, argument_4, argument_5)
                                number_7 = argument_5
                                local product = argument_4 * attributes.getState(instance, "SpeedOverride", speed_start)
                                number_5 = number_5 + product

                                if shake_instance.refreshDuringDissipate then
                                    number_3 = (number_3 + product / shake_instance.colorDuration) % 1
                                    number_4 = (number_4 + product / shake_instance.fillColorDuration) % 1
                                end

                                local interpolated_value

                                if dissipate_mode == "Retract" then
                                    interpolated_value = utility.lerp(number_8, number_9, argument_3)
                                else
                                    interpolated_value = nil
                                end

                                local interpolated_value_2

                                if dissipate_mode == "Scale" then
                                    interpolated_value_2 = utility.lerp(width_start2, 0, argument_3)
                                else
                                    interpolated_value_2 = nil
                                end

                                update_segments(
                                    number_9,
                                    interpolated_value,
                                    product,
                                    shake_instance.refreshDuringDissipate,
                                    interpolated_value_2
                                )
                                local state = attributes.getState(instance, "SpeedOverride", speed_start)
                                speed_start = state

                                if state > 0 then
                                    return argument_4 * state
                                end

                                return argument_4 * state
                            end,
                            value_8,
                            on_dissipation_complete,
                            true,
                            utility.RENDER_PRIORITY + items.depth
                        )

                        return
                    end

                    if shake_instance.fadeOutDuration <= 0 then
                        if enabled_2 then
                            return
                        end

                        enabled_2 = true

                        if emit_on_finish_result then
                            emit_on_finish_result.Finished:finally(function()
                                callback_2()
                            end)

                            return
                        end

                        callback_2()

                        return
                    end

                    local maximum_2 = math.max(0, number_9 - length_start)
                    enabled_3 = true
                    number_8 = maximum_2
                    width_start2 = width_start
                    local text = "None"

                    tween.fromParams(
                        shake_instance.fadeOutCurveData,
                        shake_instance.fadeOutDuration,
                        function(argument_3, argument_4, argument_5)
                            number_7 = argument_5
                            local product = argument_4 * attributes.getState(instance, "SpeedOverride", speed_start)
                            number_5 = number_5 + product

                            if shake_instance.refreshDuringDissipate then
                                number_3 = (number_3 + product / shake_instance.colorDuration) % 1
                                number_4 = (number_4 + product / shake_instance.fillColorDuration) % 1
                            end

                            local interpolated_value

                            if text == "Retract" then
                                interpolated_value = utility.lerp(number_8, number_9, argument_3)
                            else
                                interpolated_value = nil
                            end

                            local interpolated_value_2

                            if text == "Scale" then
                                interpolated_value_2 = utility.lerp(width_start2, 0, argument_3)
                            else
                                interpolated_value_2 = nil
                            end

                            update_segments(
                                number_9,
                                interpolated_value,
                                product,
                                shake_instance.refreshDuringDissipate,
                                interpolated_value_2
                            )
                            local state = attributes.getState(instance, "SpeedOverride", speed_start)
                            speed_start = state

                            if state > 0 then
                                return argument_4 * state
                            end

                            return argument_4 * state
                        end,
                        value_8,
                        on_dissipation_complete,
                        true,
                        utility.RENDER_PRIORITY + items.depth
                    )
                end

                local from_params_2 = tween.fromParams
                local get_result_3 = attributes.get(instance, "Easing_Curve", utility.linear_bezier)
                table.insert(
                    items,
                    from_params_2(
                        get_result_3,
                        next_number_result,
                        function(argument_3, argument_4, argument_5)
                            local product = argument_4 * attributes.getState(instance, "SpeedOverride", speed_start)
                            number_5 = number_5 + product
                            number_3 = (number_3 + product / shake_instance.colorDuration) % 1
                            number_4 = (number_4 + product / shake_instance.fillColorDuration) % 1

                            if read_common_attributes_result.syncPosition then
                                local transformed_origin_extents2 =
                                    utility.getTransformedOriginExtents(validate_parent_result)
                                local product_2 = transformed_origin_extents2 * transformed_origin_extents_2:Inverse()

                                for index_5 = 1, #result_2 do
                                    result_2[index_5] = product_2:PointToWorldSpace(
                                        transformed_origin_extents_2:PointToObjectSpace(result_2[index_5])
                                    )
                                    local _ = index_5
                                end

                                transformed_origin_extents_2 = transformed_origin_extents2
                            end

                            update_segments(argument_3, nil, product)
                            local enabled_4

                            if read_common_attributes_result.hitboxEnabled then
                                local rounded_value = math.ceil(number_6 * shake_instance.segments)
                                local create_result_entry =
                                    create_result[math.clamp(rounded_value, 1, shake_instance.segments)]
                                enabled_4 = create_result_entry
                                        and (create_result_entry.Transparency < 1 and workspace:GetPartsInPart(
                                            create_result_entry,
                                            create_hitbox_params_result
                                        )[1])
                                        and true
                                    or false
                            else
                                enabled_4 = false
                            end

                            if enabled_4 then
                                start_dissipation()

                                return nil
                            end

                            local state = attributes.getState(instance, "SpeedOverride", speed_start)
                            speed_start = state
                            local product_3

                            if state > 0 then
                                product_3 = argument_4 * state
                            else
                                local connected

                                if value_8 then
                                    connected = value_8.Connected
                                else
                                    connected = attributes.getState(instance, "SpeedTweening", false)
                                end

                                if connected then
                                    product_3 = argument_4 * state
                                else
                                    product_3 = nil
                                end
                            end

                            if product_3 == nil then
                                return nil
                            end

                            if
                                not (
                                    (
                                        not read_common_attributes_result.projectileEnabled
                                        or argument_3 * next_number_result >= next_number_result_2
                                    )
                                    and read_common_attributes_result.projectileEnabled
                                )
                            then
                                return product_3
                            end

                            start_dissipation()

                            return nil
                        end,
                        value_8,
                        function()
                            if enabled_3 or enabled_2 then
                                return
                            end

                            if not read_common_attributes_result.projectileEnabled then
                                if read_common_attributes_result.destroyDelay > 0 then
                                    tween.fromParams(
                                        utility.linear_bezier,
                                        read_common_attributes_result.destroyDelay,
                                        function(argument_3, argument_4)
                                            local product = argument_4
                                                * attributes.getState(instance, "SpeedOverride", speed_start)
                                            number_5 = number_5 + product
                                            number_3 = (number_3 + product / shake_instance.colorDuration) % 1
                                            number_4 = (number_4 + product / shake_instance.fillColorDuration) % 1
                                            update_segments(1, nil, product, true)
                                            local enabled_4

                                            if read_common_attributes_result.hitboxEnabled then
                                                local rounded_value = math.ceil(number_6 * shake_instance.segments)
                                                local create_result_entry =
                                                    create_result[math.clamp(rounded_value, 1, shake_instance.segments)]
                                                enabled_4 = create_result_entry
                                                        and (create_result_entry.Transparency < 1 and workspace:GetPartsInPart(
                                                            create_result_entry,
                                                            create_hitbox_params_result
                                                        )[1])
                                                        and true
                                                    or false
                                            else
                                                enabled_4 = false
                                            end

                                            if enabled_4 then
                                                start_dissipation()

                                                return nil
                                            end

                                            local state = attributes.getState(instance, "SpeedOverride", speed_start)
                                            speed_start = state

                                            if state > 0 then
                                                return argument_4 * state
                                            end

                                            return argument_4 * state
                                        end,
                                        value_8,
                                        function()
                                            start_dissipation()
                                        end,
                                        true,
                                        utility.RENDER_PRIORITY + items.depth
                                    )

                                    return
                                end

                                start_dissipation()

                                return
                            end

                            local look_vector

                            if read_common_attributes_result.projectileMatchEnd and find_end_attachments_result then
                                look_vector = find_end_attachments_result.WorldCFrame.LookVector
                            else
                                look_vector = vector.Unit
                            end

                            local unit = (look_vector ~= look_vector or look_vector.Magnitude < 0.001)
                                    and Vector3.new(0, 0, 1)
                                or look_vector.Unit
                            local result_3 = callback(1)
                            local magnitude = (result_3 - callback((math.max(0, 1 - length_start)))).Magnitude
                            local curved_tail_t = math.max(0, 1 - length_start)
                            local curved_length_t = 1 - curved_tail_t
                            local jagged_offsets = table.create(shake_instance.segments + 1)

                            for index_5 = 0, shake_instance.segments do
                                local result_4 =
                                    callback(curved_tail_t + index_5 / shake_instance.segments * curved_length_t)
                                jagged_offsets[index_5 + 1] = result_2[index_5 + 1] - result_4
                                local _ = index_5
                            end

                            local values = {
                                distanceTraveled = 0,
                                curvedTailT = curved_tail_t,
                                curvedLengthT = curved_length_t,
                                boltLength = magnitude,
                                transitionBuffer = magnitude * 0.3,
                                jaggedOffsets = jagged_offsets,
                            }
                            value_7 = values

                            tween.timer(next_number_result_2, function(argument_3, argument_4)
                                local product = argument_3 * attributes.getState(instance, "SpeedOverride", speed_start)
                                number_5 = number_5 + product
                                number_3 = (number_3 + product / shake_instance.colorDuration) % 1
                                number_4 = (number_4 + product / shake_instance.fillColorDuration) % 1
                                local distance_traveled = argument_4 * read_common_attributes_result.projectileSpeed
                                values.distanceTraveled = distance_traveled
                                local sum = result_3 + unit * distance_traveled
                                value_5 = sum
                                value_6 = sum - unit * magnitude
                                quotient = unit

                                if shake_instance.refreshRate > 0 then
                                    number_2 = number_2 + product

                                    if number_2 >= 1 / shake_instance.refreshRate then
                                        refresh_points()
                                        number_2 = 0
                                    else
                                        update_points_between_refreshes(argument_3)
                                    end
                                else
                                    update_points_between_refreshes(argument_3)
                                end

                                update_segments(1, nil, product, false)
                                local enabled_4

                                if read_common_attributes_result.hitboxEnabled then
                                    local rounded_value = math.ceil(number_6 * shake_instance.segments)
                                    local create_result_entry =
                                        create_result[math.clamp(rounded_value, 1, shake_instance.segments)]
                                    enabled_4 = create_result_entry
                                            and (create_result_entry.Transparency < 1 and workspace:GetPartsInPart(
                                                create_result_entry,
                                                create_hitbox_params_result
                                            )[1])
                                            and true
                                        or false
                                else
                                    enabled_4 = false
                                end

                                if enabled_4 then
                                    start_dissipation()

                                    return nil
                                end

                                if next_number_result_2 <= argument_4 then
                                    return nil
                                end

                                local state = attributes.getState(instance, "SpeedOverride", speed_start)
                                speed_start = state

                                if state > 0 then
                                    return argument_3 * state
                                end

                                return argument_3 * state
                            end, value_8, items, utility.RENDER_PRIORITY + items.depth)

                            start_dissipation()
                        end,
                        true,
                        utility.RENDER_PRIORITY + items.depth
                    )
                )
            end)
        )
        local _ = index
    end

    promise.all(items_2):await()
end

return lightning
