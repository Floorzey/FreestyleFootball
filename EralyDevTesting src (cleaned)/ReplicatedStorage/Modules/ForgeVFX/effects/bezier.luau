local run_service = game:GetService("RunService")
local attributes = require("../mod/attributes")
local tween = require("../mod/tween")
require("../types")
local utility = require("../mod/utility")
local bezier_2 = require("../mod/common/bezier")
local bezier_3 = require("../obj/Bezier")
local promise = require("../pkg/Promise")
require("../obj/ObjectCache")
local bezier = {}
local value = nil

function bezier.init(argument)
    value = argument
end

function bezier.deinit()
    value = nil
end

local function read_bezier_attributes(argument: userdata)
    return {
        facePath = attributes.get(argument, "FacePath", false),
        arcSpace = attributes.get(argument, "ArcSpace", false),
        rotSpeedStart = attributes.getRange(argument, "RotSpeed_Start", NumberRange.new(0, 0)),
        rotSpeedEnd = attributes.getRange(argument, "RotSpeed_End", NumberRange.new(0, 0)),
        minInitRot = attributes.get(argument, "MinInitRot", Vector3.new(0, 0, 0)),
        maxInitRot = attributes.get(argument, "MaxInitRot", Vector3.new(0, 0, 0)),
        speedCurve = attributes.get(argument, "Speed_Curve", utility.default_bezier),
        speedDuration = attributes.get(argument, "Speed_Duration", 0.1),
        easingCurve = attributes.get(argument, "Easing_Curve", utility.linear_bezier),
    }
end

function bezier.emit(instance: userdata, argument: userdata, items: any, argument_2: boolean?)
    local points = instance:FindFirstChild("Points")

    if not (points and (points:IsA("Attachment") and value)) then
        return
    end

    local read_common_attributes_result = bezier_2.readCommonAttributes(instance)
    local result = read_bezier_attributes(instance)
    local draw_func_map_entry_entry = bezier_2.drawFuncMap[read_common_attributes_result.shapeType]
        and bezier_2.drawFuncMap[read_common_attributes_result.shapeType][read_common_attributes_result.shapeStyle]

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
            table.insert(
                items,
                tween.fromParams(
                    result.speedCurve,
                    result.speedDuration,
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

    local validate_parent_result = bezier_2.validateParent(instance)

    if not validate_parent_result then
        return
    end

    local transformed_origin_extents, value_2 = utility.getTransformedOriginExtents(validate_parent_result)

    if not transformed_origin_extents then
        return
    end

    local find_end_attachments_result, value_3 = bezier_2.findEndAttachments(instance)
    local bezier_points = utility.getBezierPoints(points)
    local random = Random.new()
    local bezier_4 = not find_end_attachments_result and bezier_3.new(bezier_points)
    local create_hitbox_params_result = bezier_2.createHitboxParams({
        enabled = read_common_attributes_result.hitboxEnabled,
        collisionGroup = read_common_attributes_result.hitboxCollisionGroup,
        filterTag = read_common_attributes_result.hitboxFilterTag,
        filterType = read_common_attributes_result.hitboxFilterType,
        ignoreCanCollide = read_common_attributes_result.hitboxIgnoreCanCollide,
    }, validate_parent_result, points)
    local items_2 = {}

    for index = 1, read_common_attributes_result.emitCount do
        local next_number_result = random:NextNumber(result.rotSpeedStart.Min, result.rotSpeedStart.Max)
        local next_number_result_2 = random:NextNumber(result.rotSpeedEnd.Min, result.rotSpeedEnd.Max)
        local next_number_result_3 = random:NextNumber(result.minInitRot.x, result.maxInitRot.x)
        local next_number_result_4 = random:NextNumber(result.minInitRot.y, result.maxInitRot.y)
        local create_result = vector.create(
            next_number_result_3,
            next_number_result_4,
            random:NextNumber(result.minInitRot.z, result.maxInitRot.z)
        )
        local next_number_result_5 =
            random:NextNumber(read_common_attributes_result.duration.Min, read_common_attributes_result.duration.Max)
        local next_number_result_6 = read_common_attributes_result.projectileEnabled
            and random:NextNumber(
                read_common_attributes_result.projectileLifetime.Min,
                read_common_attributes_result.projectileLifetime.Max
            )
        table.insert(
            items_2,
            promise.new(function(callback)
                local calculate_emission_c_frame_result = bezier_2.calculateEmissionCFrame(
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
                local bezier_5 = bezier_4
                    or bezier_2.createBezierWithEndpoint(
                        bezier_points,
                        calculate_emission_c_frame_result,
                        find_end_attachments_result,
                        value_3
                    )
                local callback_2 = bezier_2.createPosGetter(
                    bezier_5,
                    bezier_points,
                    calculate_emission_c_frame_result,
                    find_end_attachments_result,
                    result.arcSpace
                )
                local random_id = utility.getRandomId()

                if not value then
                    callback()

                    return
                end

                local get_result = value:get(random_id)
                get_result.CFrame = CFrame.new(callback_2(0))
                local parent = get_result._getReal()
                utility.copyProperties(argument, parent, utility.COPY_PART_PROPERTIES)
                utility.copyProperties(argument, parent, utility.COPY_EXTENDED_PART_PROPERTIES)
                local clone = argument:Clone()

                for _, child in clone:GetChildren() do
                    child.Parent = parent
                end

                clone:Destroy()
                local prepare_emit_on_finish_result = items.effects.prepareEmitOnFinish(parent, items)
                local finished = items.effects.emitNested(parent, items.depth + 1, items).Finished
                table.insert(items_2, finished)

                table.insert(items, function()
                    if value then
                        value:free(random_id)
                    end
                end)

                local vector_2 = Vector3.new(0, 0, 0)
                local vector_3 = Vector3.new(0, 0, 0)
                local enabled = false
                local enabled_2 = false
                local c_frame_identity = CFrame.identity
                local speed_start = read_common_attributes_result.speedStart
                local from_orientation_result =
                    CFrame.fromOrientation(create_result.x, create_result.y, create_result.z)
                local next_number_result_7 = next_number_result

                local function on_finish()
                    if enabled_2 then
                        return
                    end

                    if read_common_attributes_result.syncPosition then
                        local transformed_origin_extents2 = utility.getTransformedOriginExtents(validate_parent_result)
                        local c_frame2 = get_result.CFrame

                        local function update_pos()
                            get_result.CFrame = utility.getTransformedOriginExtents(validate_parent_result)
                                * transformed_origin_extents2:ToObjectSpace(c_frame2)
                        end

                        local random_id2 = utility.getRandomId()
                        run_service:BindToRenderStep(random_id2, utility.RENDER_PRIORITY + items.depth, update_pos)

                        table.insert(items, function()
                            run_service:UnbindFromRenderStep(random_id2)
                        end)
                    end

                    enabled_2 = true

                    items.effects
                        .emitOnFinish(prepare_emit_on_finish_result, parent, items.depth + 1, items).Finished
                        :finally(function()
                            callback()
                        end)
                end

                local function shapecast()
                    if read_common_attributes_result.hitboxEnabled then
                        return workspace:GetPartsInPart(parent, create_hitbox_params_result)[1] ~= nil
                    end

                    return false
                end

                local value_4

                if
                    read_common_attributes_result.speedStart == read_common_attributes_result.speedEnd
                    or attributes.getState(instance, "SpeedOverride", nil)
                then
                    value_4 = nil
                else
                    value_4 = tween.fromParams(result.speedCurve, result.speedDuration, function(argument_3, argument_4)
                        speed_start = utility.lerp(
                            read_common_attributes_result.speedStart,
                            read_common_attributes_result.speedEnd,
                            argument_3
                        )

                        return argument_4
                    end)
                    table.insert(items, value_4)
                end

                local function get_effective_speed()
                    return attributes.getState(instance, "SpeedOverride", speed_start)
                end

                local function is_speed_tweening()
                    if value_4 then
                        return value_4.Connected
                    end

                    return attributes.getState(instance, "SpeedTweening", false)
                end

                bezier_2.createPropertyTween(
                    items,
                    instance,
                    "RotSpeed",
                    next_number_result_5,
                    next_number_result,
                    next_number_result_2,
                    function(argument_3)
                        next_number_result_7 = argument_3
                    end,
                    function()
                        return get_effective_speed()
                    end,
                    value_4
                )

                table.insert(
                    items,
                    tween.fromParams(
                        result.easingCurve,
                        next_number_result_5,
                        function(argument_3, argument_4, argument_5)
                            local result_2 = callback_2(argument_3)
                            local cframe = CFrame.new(result_2)

                            if result.facePath then
                                local result_3 = callback_2(
                                    (math.clamp((argument_5 + 0.016666666666666666) / next_number_result_5, 0, 1))
                                )

                                if result_2 == result_3 then
                                    cframe = cframe * c_frame_identity.Rotation
                                else
                                    cframe = CFrame.lookAt(result_2, result_3)
                                end
                            end

                            local product = create_result:Sign()
                                * next_number_result_7
                                * utility.DEG_TO_RAD
                                * argument_4
                            from_orientation_result = from_orientation_result
                                * CFrame.fromOrientation(product.x, product.y, product.z)
                            c_frame_identity = cframe
                            local cframe_2 = cframe * from_orientation_result

                            if read_common_attributes_result.syncPosition then
                                get_result.CFrame = utility.getTransformedOriginExtents(validate_parent_result)
                                    * transformed_origin_extents:ToObjectSpace(cframe_2)
                            else
                                get_result.CFrame = cframe_2
                            end

                            vector_3 = (result_2 - vector_2) / argument_4
                            vector_2 = result_2
                            local condition_2

                            if read_common_attributes_result.hitboxEnabled then
                                condition_2 = workspace:GetPartsInPart(parent, create_hitbox_params_result)[1] ~= nil
                            else
                                condition_2 = false
                            end

                            if condition_2 then
                                on_finish()
                                enabled = true

                                return nil
                            end

                            local state = attributes.getState(instance, "SpeedOverride", speed_start)
                            speed_start = state

                            if state == 0 then
                                local connected

                                if value_4 then
                                    connected = value_4.Connected
                                else
                                    connected = attributes.getState(instance, "SpeedTweening", false)
                                end

                                if not connected then
                                    return nil
                                end
                            end

                            if
                                not (
                                    (
                                        not read_common_attributes_result.projectileEnabled
                                        or argument_3 * next_number_result_5 >= next_number_result_6
                                    )
                                    and read_common_attributes_result.projectileEnabled
                                )
                            then
                                return argument_4 * state
                            end

                            on_finish()

                            return nil
                        end,
                        value_4,
                        function(argument_3)
                            if not read_common_attributes_result.projectileEnabled or enabled then
                                if argument_3 then
                                    on_finish()
                                end

                                return
                            end

                            local look_vector

                            if read_common_attributes_result.projectileMatchEnd and find_end_attachments_result then
                                look_vector = find_end_attachments_result.WorldCFrame.LookVector
                            else
                                look_vector = vector_3.Unit
                            end

                            vector_3 = (look_vector ~= look_vector and Vector3.new(0, 0, 0) or look_vector)
                                * read_common_attributes_result.projectileSpeed
                            local position = parent.Position
                            local transformed_origin_extents2 =
                                utility.getTransformedOriginExtents(validate_parent_result)

                            tween.timer(next_number_result_6, function(argument_4, argument_5)
                                if read_common_attributes_result.syncPosition then
                                    get_result.CFrame = utility.getTransformedOriginExtents(validate_parent_result)
                                        * transformed_origin_extents2:ToObjectSpace(
                                            CFrame.new(position + vector_3 * argument_5)
                                        )
                                else
                                    get_result.CFrame = CFrame.new(position + vector_3 * argument_5)
                                        * parent.CFrame.Rotation
                                end

                                local condition_2

                                if read_common_attributes_result.hitboxEnabled then
                                    condition_2 = workspace:GetPartsInPart(parent, create_hitbox_params_result)[1]
                                        ~= nil
                                else
                                    condition_2 = false
                                end

                                if condition_2 then
                                    on_finish()
                                    enabled = true

                                    return nil
                                end

                                local state = attributes.getState(instance, "SpeedOverride", speed_start)
                                speed_start = state

                                if state > 0 then
                                    return argument_4 * state
                                end

                                if not (argument_5 > 0) then
                                    return nil
                                end

                                local connected

                                if value_4 then
                                    connected = value_4.Connected
                                else
                                    connected = attributes.getState(instance, "SpeedTweening", false)
                                end

                                if connected then
                                    return argument_4 * state
                                end

                                return nil
                            end, value_4, items, utility.RENDER_PRIORITY + items.depth)

                            if not enabled then
                                on_finish()
                            end
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
    task.wait(read_common_attributes_result.destroyDelay)
end

return bezier
