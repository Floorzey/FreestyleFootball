local run_service = game:GetService("RunService")
local attributes = require("../mod/attributes")
local tween = require("../mod/tween")
require("../types")
local utility = require("../mod/utility")
local flipbook = require("../mod/common/flipbook")
local oklab = require("../mod/color/Oklab")
local promise = require("../pkg/Promise")
local random = Random.new()

return {
    emit = function(instance: userdata, argument: userdata, items: any, argument_2: number, argument_3: boolean?)
        local start = instance:FindFirstChild("Start")
        local end_value = instance:FindFirstChild("End")

        if
            not (
                start
                and (
                    end_value
                    and (
                        start:IsA("BasePart")
                        and (
                            end_value:IsA("BasePart") and (not attributes.get(instance, "Enabled", false) or argument_3)
                        )
                    )
                )
            )
        then
            return
        end

        local get_result = attributes.get(instance, "Duration", 1, true)
        local range = attributes.getRange(
            instance,
            "EffectDuration",
            NumberRange.new(get_result, get_result),
            NumberRange.new(0, (1 / 0))
        )
        local effect_duration = random:NextNumber(range.Min, range.Max)
        local get_result_2 = attributes.get(instance, "EmitDelay", 0)
        local get_result_3 = attributes.get(instance, "DestroyDelay", 0)
        local get_result_4 = attributes.get(instance, "EmitDuration", 0)
        local get_result_5 = attributes.get(instance, "Flipbook", false, true)
        local get_result_6 = attributes.get(instance, "FlipbookFadeOffset", 0, true)
        local text = (get_result_5 or not start:FindFirstChildOfClass("Decal")) and "Mesh_" or "Decal_"
        local attribute = instance:GetAttribute("StartTransparency")

        if attribute ~= nil then
            instance:SetAttribute(text .. "StartTransparency", attribute)
            instance:SetAttribute("StartTransparency", nil)
        end

        local attribute2 = instance:GetAttribute("EndTransparency")

        if attribute2 ~= nil then
            instance:SetAttribute(text .. "EndTransparency", attribute2)
            instance:SetAttribute("EndTransparency", nil)
        end

        local condition = instance:HasTag(utility.ENABLED_VFX_TAG) and get_result_4 > 0
        local get_result_7 = attributes.get(instance, "Decal_StartTransparency", 0, true)
        local get_result_8 = attributes.get(instance, "Decal_EndTransparency", 1, true)
        local decal_2

        if start then
            decal_2 = start:FindFirstChildOfClass("Decal")
        else
            decal_2 = start
        end

        local number = decal_2 and 1 or 0
        local get_result_9 = attributes.get(instance, "Mesh_StartTransparency", number, true)
        local get_result_10 = attributes.get(instance, "Mesh_EndTransparency", number, true)
        local get_result_11 = attributes.get(instance, "SyncPosition", false)
        local get_result_12 = attributes.get(instance, "Speed_Start", 1)
        local get_result_13 = attributes.get(instance, "Speed_End", 1)
        local transparency = attributes.get(instance, "Part_Transparency_Start", get_result_9)
        local get_result_14 = attributes.get(instance, "Part_Transparency_End", get_result_10)
        local get_result_15 = attributes.get(instance, "SpreadAngle", Vector3.new(0, 0, 0))
        local range2 = attributes.getRange(instance, "Part_RotSpeed_Start", NumberRange.new(0, 0))
        local range3 = attributes.getRange(instance, "Part_RotSpeed_End", NumberRange.new(0, 0))
        local get_result_16 = attributes.get(instance, "RotAroundOrigin", false)
        local get_result_17 = attributes.get(instance, "MinInitRot", Vector3.new(0, 0, 0))
        local get_result_18 = attributes.get(instance, "MaxInitRot", Vector3.new(0, 0, 0))
        local next_number_result = random:NextNumber(range2.Min, range2.Max)
        local next_number_result_2 = random:NextNumber(range3.Min, range3.Max)
        local next_number_result_3 = random:NextNumber(get_result_17.x, get_result_18.x)
        local next_number_result_4 = random:NextNumber(get_result_17.y, get_result_18.y)
        local product = vector.create(
            next_number_result_3,
            next_number_result_4,
            random:NextNumber(get_result_17.z, get_result_18.z)
        ) * utility.DEG_TO_RAD
        task.wait(get_result_2)

        if condition and not argument_3 then
            utility.forceEmit(instance, true)
            attributes.trigger(instance, "Enabled", true)

            utility.onCancel(items, function()
                local stop_emit_duration_result = utility.stopEmitDuration(instance)

                if stop_emit_duration_result then
                    utility.cancelToken(stop_emit_duration_result)
                end
            end)

            if get_result_12 ~= get_result_13 then
                attributes.setState(instance, "SpeedTweening", true)
                local from_params = tween.fromParams
                local get_result_19 = attributes.get(instance, "Speed_Curve", utility.default_bezier)
                local get_result_20 = attributes.get(instance, "Speed_Duration", 0.1)
                table.insert(
                    items,
                    from_params(
                        get_result_19,
                        get_result_20,
                        function(argument_4, argument_5)
                            attributes.setState(
                                instance,
                                "SpeedOverride",
                                utility.lerp(get_result_12, get_result_13, argument_4)
                            )

                            return argument_5
                        end,
                        nil,
                        function()
                            attributes.setState(instance, "SpeedTweening", nil)
                        end
                    )
                )
            end

            task.wait(get_result_4)
            utility.awaitEmitDuration(utility.stopEmitDuration(instance))

            return
        end

        local first_ancestor_of_class = instance:FindFirstAncestorOfClass("Attachment") or start
        local parent

        if typeof(argument) == "table" then
            parent = argument._getReal() or argument
        else
            parent = argument
        end

        local transformed_origin_extents = utility.getTransformedOriginExtents(first_ancestor_of_class)
        local relative_cframe = start.CFrame:ToObjectSpace(end_value.CFrame)
        local get_result_21 = get_result_12
        local next_number_result_5 = next_number_result
        local from_orientation_result = CFrame.fromOrientation(product.x, product.y, product.z)
        local c_frame_identity = CFrame.identity
        local c_frame_from_orientation = CFrame.fromOrientation
        local next_number_result_6 = random:NextNumber(-get_result_15.x, get_result_15.x)
        local radians = math.rad(next_number_result_6)
        local next_number_result_7 = random:NextNumber(-get_result_15.y, get_result_15.y)
        local result = c_frame_from_orientation(radians, math.rad(next_number_result_7), 0)

        local function update_pos(argument_4: number)
            local transformed_origin_extents_2 = get_result_11
                    and utility.getTransformedOriginExtents(first_ancestor_of_class)
                or transformed_origin_extents
            local product_5 = product:Sign() * next_number_result_5 * argument_4
            from_orientation_result = from_orientation_result
                * CFrame.fromOrientation(product_5.x, product_5.y, product_5.z)
            local product_6

            if get_result_16 then
                product_6 = transformed_origin_extents_2 * result * from_orientation_result * c_frame_identity
            else
                product_6 = transformed_origin_extents_2 * result * c_frame_identity * from_orientation_result
            end

            argument.CFrame = product_6 * from_orientation_result
        end

        update_pos(0)
        local random_id = utility.getRandomId()
        run_service:BindToRenderStep(random_id, utility.RENDER_PRIORITY + items.depth, update_pos)

        table.insert(items, function()
            run_service:UnbindFromRenderStep(random_id)
        end)

        local items_2 = {}
        local prepare_emit_on_finish_result = items.effects.prepareEmitOnFinish(argument, items)
        local finished = items.effects.emitNested(argument, items.depth + 1, items).Finished
        table.insert(items_2, finished)
        local speed_tween

        if get_result_12 == get_result_13 or attributes.getState(instance, "SpeedOverride", nil) then
            speed_tween = nil
        else
            speed_tween = tween.fromParams(
                attributes.get(instance, "Speed_Curve", utility.default_bezier),
                attributes.get(instance, "Speed_Duration", 0.1),
                function(argument_4, argument_5)
                    get_result_21 = utility.lerp(get_result_12, get_result_13, argument_4)

                    return argument_5
                end
            )
            table.insert(items, speed_tween)
        end

        if relative_cframe ~= CFrame.identity then
            local from_params_2 = tween.fromParams
            local get_result_22 = attributes.get(instance, "Part_CFrame_Curve", utility.default_bezier)
            table.insert(
                items,
                from_params_2(get_result_22, effect_duration, function(argument_4, argument_5)
                    c_frame_identity = CFrame.identity:Lerp(relative_cframe, argument_4)

                    return argument_5 * attributes.getState(instance, "SpeedOverride", get_result_21)
                end, speed_tween)
            )
        end

        if next_number_result ~= next_number_result_2 then
            local from_params_3 = tween.fromParams
            local get_result_23 = attributes.get(instance, "Part_RotSpeed_Curve", utility.default_bezier)
            table.insert(
                items,
                from_params_3(get_result_23, effect_duration, function(argument_4, argument_5)
                    next_number_result_5 = utility.lerp(next_number_result, next_number_result_2, argument_4)

                    return argument_5 * attributes.getState(instance, "SpeedOverride", get_result_21)
                end, speed_tween)
            )
        end

        if transparency == get_result_14 then
            argument.Transparency = transparency
        else
            local from_params_4 = tween.fromParams
            local get_result_24 = attributes.get(instance, "Part_Transparency_Curve", utility.default_bezier)
            table.insert(
                items,
                from_params_4(get_result_24, effect_duration, function(argument_4, argument_5)
                    argument.Transparency = utility.lerp(transparency, get_result_14, argument_4)

                    return argument_5 * attributes.getState(instance, "SpeedOverride", get_result_21)
                end, speed_tween)
            )
        end

        local size = start.Size * argument_2
        local product_2 = end_value.Size * argument_2

        if size == product_2 then
            argument.Size = size
        else
            local negated_value = -1
            local from_params_5 = tween.fromParams
            local get_result_25 = attributes.get(instance, "Part_Size_Curve", utility.default_bezier)
            table.insert(
                items,
                from_params_5(get_result_25, effect_duration, function(argument_4, argument_5)
                    local state = attributes.getState(instance, "SpeedOverride", get_result_21)

                    if math.abs(argument_4 - negated_value) < 0.005 then
                        return argument_5 * state
                    end

                    negated_value = argument_4
                    argument.Size = size:Lerp(product_2, argument_4)

                    return argument_5 * state
                end, speed_tween)
            )
        end

        local special_mesh = start:FindFirstChildOfClass("SpecialMesh")
        local special_mesh_2 = end_value:FindFirstChildOfClass("SpecialMesh")
        local special_mesh_3 = argument:FindFirstChildOfClass("SpecialMesh")

        if special_mesh_3 then
            if special_mesh and special_mesh_2 then
                local product_3 = special_mesh.Scale * argument_2
                local product_4 = special_mesh_2.Scale * argument_2

                if product_3 ~= product_4 then
                    local from_params_6 = tween.fromParams
                    local get_result_26 = attributes.get(instance, "Mesh_Scale_Curve", utility.default_bezier)
                    table.insert(
                        items,
                        from_params_6(get_result_26, effect_duration, function(argument_4, argument_5)
                            special_mesh_3.Scale = utility.lerp(product_3, product_4, argument_4)

                            return argument_5 * attributes.getState(instance, "SpeedOverride", get_result_21)
                        end, speed_tween)
                    )
                end
            else
                special_mesh_3.Parent = nil

                table.insert(items, function()
                    special_mesh_3.Parent = parent
                end)
            end
        end

        local mesh_decals, value, value_2 = utility.getMeshDecals(instance, argument)
        local number_2 = 0

        if get_result_5 then
            table.sort(mesh_decals, function(argument_4, argument_5)
                local match = argument_4.Name:match("%d+") or 0
                local match_2 = argument_5.Name:match("%d+") or 0

                return tonumber(match) < tonumber(match_2)
            end)

            local decal = Instance.new("Decal")
            decal.Parent = parent
            table.insert(items, decal)

            if get_result_6 > 0 and get_result_7 ~= get_result_8 then
                table.insert(
                    items,
                    tween.fromParams(
                        utility.default_bezier,
                        effect_duration + get_result_6,
                        function(argument_4, argument_5)
                            decal.Transparency = utility.lerp(get_result_7, get_result_8, argument_4)

                            return argument_5 * attributes.getState(instance, "SpeedOverride", get_result_21)
                        end,
                        speed_tween
                    )
                )
            end

            table.insert(
                items,
                tween.fromParams(utility.default_bezier, effect_duration, function(argument_4, argument_5)
                    local rounded_value = math.round(#mesh_decals * argument_4)
                    local mesh_decal_entry = mesh_decals[math.max(rounded_value, 1)]
                    decal.Texture = mesh_decal_entry.Texture
                    decal.Color3 = mesh_decal_entry.Color3
                    decal.ZIndex = mesh_decal_entry.ZIndex

                    if get_result_6 == 0 then
                        decal.Transparency = utility.lerp(get_result_7, get_result_8, argument_4)
                        decal.ZIndex = mesh_decal_entry.ZIndex
                    end

                    return argument_5 * attributes.getState(instance, "SpeedOverride", get_result_21)
                end, speed_tween)
            )
        else
            for _, ref in mesh_decals do
                local entry = value_2[ref]
                local transparency_2 = attributes.get(ref, "Transparency_Start", get_result_7)
                local get_result_27 = attributes.get(ref, "Transparency_End", get_result_8)

                if transparency_2 == get_result_27 then
                    ref.Transparency = transparency_2
                else
                    local from_params_7 = tween.fromParams
                    local get_result_28 = attributes.get(ref, "Transparency_Curve", utility.default_bezier)
                    table.insert(
                        items,
                        from_params_7(get_result_28, effect_duration, function(argument_4, argument_5)
                            ref.Transparency = utility.lerp(transparency_2, get_result_27, argument_4)

                            return argument_5 * attributes.getState(instance, "SpeedOverride", get_result_21)
                        end, speed_tween)
                    )
                end

                if ref.Color3 ~= entry.Color3 then
                    local from_params_8 = tween.fromParams
                    local get_result_29 = attributes.get(ref, "Color_Curve", utility.default_bezier)
                    table.insert(
                        items,
                        from_params_8(get_result_29, effect_duration, function(argument_4, argument_5)
                            local from_srgb_result = oklab.fromSRGB(ref.Color3)
                            local from_srgb_result_2 = oklab.fromSRGB(entry.Color3)
                            ref.Color3 = oklab.toSRGB(from_srgb_result:Lerp(from_srgb_result_2, argument_4), true)

                            return argument_5 * attributes.getState(instance, "SpeedOverride", get_result_21)
                        end, speed_tween)
                    )
                end

                local frames = value[ref]

                if frames then
                    local values = {
                        ref = ref,
                        frames = frames,
                        speedTween = speed_tween,
                        effectDuration = effect_duration,
                        curve = attributes.get(ref, "Flipbook_Change_Curve", utility.linear_bezier),
                        duration = attributes.get(ref, "Flipbook_Change_Duration", effect_duration),

                        getSpeed = function()
                            return attributes.getState(instance, "SpeedOverride", get_result_21)
                        end,

                        setTexture = function(texture)
                            ref.Texture = texture
                        end,
                    }
                    local change_duration = flipbook.getChangeDuration(values)

                    if number_2 < change_duration then
                        number_2 = change_duration
                    end

                    local from_params_9 = tween.fromParams
                    local curve = values.curve
                    local create_update_callback_result = flipbook.createUpdateCallback(values)
                    table.insert(
                        items,
                        from_params_9(curve, change_duration, create_update_callback_result, speed_tween)
                    )
                end
            end
        end

        tween.timer(math.max(effect_duration, number_2) + get_result_6 + get_result_3, function(argument_4, argument_5)
            local state = attributes.getState(instance, "SpeedOverride", get_result_21)
            get_result_21 = state

            if state > 0 then
                return argument_4 * state
            end

            if not (argument_5 > 0) then
                return nil
            end

            local connected

            if speed_tween then
                connected = speed_tween.Connected
            else
                connected = attributes.getState(instance, "SpeedTweening", false)
            end

            if connected then
                return argument_4 * state
            end

            return nil
        end, speed_tween, items)

        promise.all(items_2):await()
        items.effects.emitOnFinish(prepare_emit_on_finish_result, parent, items.depth + 1, items).Finished:await()
    end,
}
