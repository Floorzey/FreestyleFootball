local attributes = require("../mod/attributes")
local tween = require("../mod/tween")
require("../types")
local utility = require("../mod/utility")
local flipbook = require("../mod/common/flipbook")
local promise = require("../pkg/Promise")
local random = Random.new()

local function get_legacy_widths(argument: userdata, argument_2: number)
    return attributes.get(argument, "Width0", argument.Width0, true) * argument_2,
        attributes.get(argument, "Width1", argument.Width1, true) * argument_2,
        attributes.get(argument, "StartWidth0", argument.Width0, true) * argument_2,
        attributes.get(argument, "StartWidth1", argument.Width1, true) * argument_2
end

return {
    emit = function(ref: userdata, argument: userdata, items: any, argument_2: number)
        local prepare_emit_on_finish_result = items.effects.prepareEmitOnFinish(argument, items)
        local result, value, value_2, value_3 = get_legacy_widths(ref, argument_2)
        local width0 = attributes.get(ref, "Width0_Start", value_2)
        local get_result = attributes.get(ref, "Width0_End", result)
        local width1 = attributes.get(ref, "Width1_Start", value_3)
        local get_result_2 = attributes.get(ref, "Width1_End", value)
        local get_result_3 = attributes.get(ref, "CurveSize0_Start", argument.CurveSize0)
        local get_result_4 = attributes.get(ref, "CurveSize0_End", argument.CurveSize0)
        local get_result_5 = attributes.get(ref, "CurveSize1_Start", argument.CurveSize1)
        local get_result_6 = attributes.get(ref, "CurveSize1_End", argument.CurveSize1)
        local get_result_7 = attributes.get(ref, "EmitDelay", 0)
        local get_result_8 = attributes.get(ref, "Duration", 1, true)
        local get_result_9 = attributes.get(ref, "EndTransparencyScale", 1, true)
        local range = attributes.getRange(
            ref,
            "EffectDuration",
            NumberRange.new(get_result_8, get_result_8),
            NumberRange.new(0, (1 / 0))
        )
        local get_result_10 = attributes.get(ref, "Length_Scale_Start", NumberRange.new(1, 1))
        local get_result_11 = attributes.get(ref, "Length_Scale_End", NumberRange.new(1, 1))
        local get_result_12 = attributes.get(ref, "Length_Texture_Start", ref.TextureLength)
        local get_result_13 = attributes.get(ref, "Length_Texture_End", ref.TextureLength)
        local effect_duration = random:NextNumber(range.Min, range.Max)
        local next_number_result = random:NextNumber(get_result_11.Min, get_result_11.Max)
        local next_number_result_2 = random:NextNumber(get_result_10.Min, get_result_10.Max)
        local get_result_14 = attributes.get(ref, "Transparency_Scale_Start", 1)
        local get_result_15 = attributes.get(ref, "Transparency_Scale_End", get_result_9)
        local get_result_16 = attributes.get(ref, "Speed_Texture_Start", ref.TextureSpeed)
        local get_result_17 = attributes.get(ref, "Speed_Texture_End", ref.TextureSpeed)
        local get_result_18 = attributes.get(ref, "Speed_Start", 1)
        local get_result_19 = attributes.get(ref, "Speed_End", 1)
        local texture_speed = argument.TextureSpeed
        task.wait(get_result_7)
        argument.Enabled = true
        local items_2 = {}
        local number = 1
        local speed_tween = nil
        local finished = items.effects.emitNested(argument, items.depth + 1, items).Finished
        table.insert(items_2, finished)

        if get_result_16 ~= get_result_17 then
            tween.fromParams(
                attributes.get(ref, "Speed_Texture_Curve", utility.default_bezier),
                effect_duration,
                function(argument_3, argument_4)
                    texture_speed = utility.lerp(get_result_16, get_result_17, argument_3)
                    argument.TextureSpeed = texture_speed * number

                    return argument_4
                end
            )
        end

        if get_result_18 ~= get_result_19 then
            speed_tween = tween.fromParams(
                attributes.get(ref, "Speed_Curve", utility.default_bezier),
                attributes.get(argument, "Speed_Duration", 0.1),
                function(argument_3, argument_4)
                    number = utility.lerp(get_result_18, get_result_19, argument_3)
                    argument.TextureSpeed = texture_speed * number

                    return argument_4
                end
            )
            table.insert(items, speed_tween)
        end

        local keypoints = ref.Transparency.Keypoints
        local keypoints_count = #keypoints
        local create_result = table.create(keypoints_count)
        local create_result_2 = table.create(keypoints_count)

        for key, item in keypoints do
            create_result_2[key] = {
                time = item.Time,
                value = item.Value,
                envelope = item.Envelope,
            }
        end

        local value_4 = nil

        local function set_t_scale(argument_3: number)
            if value_4 and math.abs(argument_3 - value_4) < 0.001 then
                return
            end

            value_4 = argument_3
            local difference = argument_3 > 1 and argument_3 - 1 or 1 - argument_3

            for key_2, item_2 in create_result_2 do
                local value_5 = item_2.value
                create_result[key_2] = NumberSequenceKeypoint.new(
                    item_2.time,
                    value_5 + (argument_3 > 1 and 1 - value_5 or -value_5) * difference,
                    item_2.envelope
                )
            end

            argument.Transparency = NumberSequence.new(create_result)
        end

        local attachment0 = argument.Attachment0
        local attachment1 = argument.Attachment1
        local cframe

        if attachment0 then
            cframe = attachment0.CFrame
        else
            cframe = attachment0
        end

        local cframe_2

        if attachment1 then
            cframe_2 = attachment1.CFrame
        else
            cframe_2 = attachment1
        end

        local function set_length_scale(argument_3: number)
            if not (cframe and cframe_2) then
                return
            end

            local product = (cframe_2.Position - cframe.Position) * 0.5
            local sum = cframe.Position + product
            local product_2 = product * argument_3
            attachment0.CFrame = CFrame.new(sum - product_2) * (cframe - cframe.Position)
            attachment1.CFrame = CFrame.new(sum + product_2) * (cframe_2 - cframe_2.Position)
        end

        table.insert(items, function()
            set_length_scale(1)
        end)

        if get_result_14 == get_result_15 then
            if get_result_14 ~= 1 then
                set_t_scale(get_result_14)
            end
        else
            local from_params = tween.fromParams
            local get_result_20 = attributes.get(ref, "Transparency_Scale_Curve", utility.default_bezier)
            table.insert(
                items,
                from_params(get_result_20, effect_duration, function(argument_3, argument_4)
                    set_t_scale(utility.lerp(get_result_14, get_result_15, argument_3))

                    return argument_4 * number
                end, speed_tween)
            )
        end

        if get_result_12 ~= get_result_13 then
            local from_params_2 = tween.fromParams
            local get_result_21 = attributes.get(ref, "Length_Texture_Curve", utility.default_bezier)
            table.insert(
                items,
                from_params_2(get_result_21, effect_duration, function(argument_3, argument_4)
                    argument.TextureLength = utility.lerp(get_result_12, get_result_13, argument_3)

                    return argument_4 * number
                end, speed_tween)
            )
        end

        if next_number_result_2 == next_number_result then
            if get_result_12 ~= 1 then
                set_length_scale(next_number_result_2)
            end
        else
            local from_params_3 = tween.fromParams
            local get_result_22 = attributes.get(ref, "Length_Scale_Curve", utility.default_bezier)
            table.insert(
                items,
                from_params_3(get_result_22, effect_duration, function(argument_3, argument_4)
                    set_length_scale((utility.lerp(next_number_result_2, next_number_result, argument_3)))

                    return argument_4 * number
                end, speed_tween)
            )
        end

        if width0 == get_result then
            argument.Width0 = width0
        else
            local from_params_4 = tween.fromParams
            local get_result_23 = attributes.get(ref, "Width0_Curve", utility.default_bezier)
            table.insert(
                items,
                from_params_4(get_result_23, effect_duration, function(argument_3, argument_4)
                    argument.Width0 = utility.lerp(width0, get_result, argument_3)

                    return argument_4 * number
                end, speed_tween)
            )
        end

        if width1 == get_result_2 then
            argument.Width1 = width1
        else
            local from_params_5 = tween.fromParams
            local get_result_24 = attributes.get(ref, "Width1_Curve", utility.default_bezier)
            table.insert(
                items,
                from_params_5(get_result_24, effect_duration, function(argument_3, argument_4)
                    argument.Width1 = utility.lerp(width1, get_result_2, argument_3)

                    return argument_4 * number
                end, speed_tween)
            )
        end

        if get_result_3 == get_result_4 then
            argument.Width0 = width0
        else
            local from_params_6 = tween.fromParams
            local get_result_25 = attributes.get(ref, "CurveSize0_Curve", utility.default_bezier)
            table.insert(
                items,
                from_params_6(get_result_25, effect_duration, function(argument_3, argument_4)
                    argument.CurveSize0 = utility.lerp(get_result_3, get_result_4, argument_3)

                    return argument_4 * number
                end, speed_tween)
            )
        end

        if get_result_5 == get_result_6 then
            argument.Width1 = width1
        else
            local from_params_7 = tween.fromParams
            local get_result_26 = attributes.get(ref, "CurveSize1_Curve", utility.default_bezier)
            table.insert(
                items,
                from_params_7(get_result_26, effect_duration, function(argument_3, argument_4)
                    argument.CurveSize1 = utility.lerp(get_result_5, get_result_6, argument_3)

                    return argument_4 * number
                end, speed_tween)
            )
        end

        local flipbook_data = flipbook.getFlipbookData(ref)
        local get_change_duration_result

        if flipbook_data then
            local values = {
                ref = ref,
                frames = flipbook_data,
                speedTween = speed_tween,
                effectDuration = effect_duration,
                curve = attributes.get(ref, "Flipbook_Change_Curve", utility.linear_bezier),
                duration = attributes.get(ref, "Flipbook_Change_Duration", effect_duration),

                getSpeed = function()
                    return number
                end,

                setTexture = function(texture)
                    argument.Texture = texture
                end,
            }
            get_change_duration_result = flipbook.getChangeDuration(values)
            local from_params_8 = tween.fromParams
            local curve = values.curve
            local create_update_callback_result = flipbook.createUpdateCallback(values)
            table.insert(
                items,
                from_params_8(curve, get_change_duration_result, create_update_callback_result, speed_tween)
            )
        else
            get_change_duration_result = 0
        end

        tween.timer(math.max(effect_duration, get_change_duration_result), function(argument_3, argument_4)
            if number > 0 or argument_4 > 0 and (speed_tween and speed_tween.Connected) then
                return argument_3 * number
            end

            return nil
        end, speed_tween, items)

        if prepare_emit_on_finish_result then
            local finished2 = items.effects.emitOnFinish(
                prepare_emit_on_finish_result,
                argument.Parent or workspace.Terrain,
                items.depth + 1,
                items
            ).Finished
            table.insert(items_2, finished2)
        end

        promise.all(items_2):await()
    end,
}
