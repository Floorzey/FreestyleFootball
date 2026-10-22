local attributes = require("../mod/attributes")
local lerp = require("../mod/lerp")
local tween = require("../mod/tween")
require("../types")
local utility = require("../mod/utility")
local random = Random.new()

return {
    emit = function(argument: userdata, items: any, argument_2: boolean)
        local target = utility.getTarget(argument)

        if not target then
            return
        end

        local name = argument.Name
        local get_result = attributes.get(argument, "EmitDelay", 0)
        local get_result_2 = attributes.get(argument, "ResetOnFinish", true)
        local range = attributes.getRange(argument, "Duration", NumberRange.new(1, 1), NumberRange.new(0, (1 / 0)))

        if get_result > 0 then
            task.wait(get_result)
        end

        local get_result_3 = attributes.get(argument, "_END_VALUE", nil)
        local get_result_4 = attributes.get(argument, "_START_VALUE", nil)
        local get_result_5

        if argument_2 then
            get_result_5 = attributes.get(target, name, nil)
        else
            local pcall_result
            pcall_result, get_result_5 = pcall(function()
                return target[name]
            end)

            if not pcall_result then
                return
            end
        end

        local get_result_6 = get_result_4 or get_result_5
        local value_type = typeof(get_result_6)

        if value_type ~= typeof(get_result_3) then
            return
        end

        local next_number_result = random:NextNumber(range.Min, range.Max)
        local get_result_7 = attributes.get(argument, "Speed_Start", 1)
        local get_result_8 = attributes.get(argument, "Speed_End", 1)
        local get_result_9 = get_result_7
        local value

        if get_result_7 == get_result_8 then
            value = nil
        else
            value = tween.fromParams(
                attributes.get(argument, "Speed_Curve", utility.default_bezier),
                attributes.get(argument, "Speed_Duration", 0.1),
                function(argument_3, argument_4)
                    get_result_9 = utility.lerp(get_result_7, get_result_8, argument_3)

                    return argument_4
                end
            )
            table.insert(items, value)
        end

        local other = lerp[value_type] or lerp.Other
        local callback

        if argument_2 then
            callback = function(argument_3, argument_4)
                attributes.set(target, name, other(get_result_6, get_result_3, argument_3))

                return argument_4 * get_result_9
            end
        else
            callback = function(argument_3, argument_4)
                target[name] = other(get_result_6, get_result_3, argument_3)

                return argument_4 * get_result_9
            end
        end

        local from_params = tween.fromParams
        local get_result_10 = attributes.get(argument, "Easing_Curve", utility.linear_bezier)
        table.insert(
            items,
            from_params(
                get_result_10,
                next_number_result,
                callback,
                value,
                nil,
                nil,
                utility.RENDER_PRIORITY + items.depth
            )
        )

        if get_result_2 then
            table.insert(items, function()
                if argument_2 then
                    attributes.set(target, name, get_result_6)

                    return
                end

                target[name] = get_result_6
            end)
        end

        tween.timer(next_number_result, function(argument_3, argument_4)
            if get_result_9 > 0 or argument_4 > 0 and (value and value.Connected) then
                return argument_3 * get_result_9
            end

            return nil
        end, value, items)
    end,
}
