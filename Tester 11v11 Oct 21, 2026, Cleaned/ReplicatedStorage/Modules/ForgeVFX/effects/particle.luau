local attributes = require("../mod/attributes")
local tween = require("../mod/tween")
require("../types")
local utility = require("../mod/utility")

return {
    emit = function(argument: userdata, argument_2: userdata, items: any)
        if argument.Enabled then
            argument.Enabled = false
        end

        local get_result = attributes.get(argument, "EmitDelay", 0)
        local get_result_2 = attributes.get(argument, "EmitCount", 1)
        local get_result_3 = attributes.get(argument, "EmitDuration", 0)
        local condition = get_result_3 > 0
        task.wait(get_result)

        if condition then
            argument_2.Enabled = true
        end

        local get_result_4 = attributes.get(argument, "TimeScale_Duration", 0.1)
        local time_scale = attributes.get(argument, "TimeScale_Start", argument_2.TimeScale, true)
        local get_result_5 = attributes.get(argument, "TimeScale_End", argument_2.TimeScale, true)
        local value = nil

        if time_scale == get_result_5 then
            if time_scale ~= argument_2.TimeScale then
                argument_2.TimeScale = time_scale
            end
        else
            value = tween.fromParams(
                attributes.get(argument, "TimeScale_Curve", utility.default_bezier),
                get_result_4,
                function(argument_3, argument_4)
                    argument_2.TimeScale = utility.lerp(time_scale, get_result_5, (math.clamp(argument_3, 0, 1)))

                    return argument_4
                end
            )
            table.insert(items, value)
        end

        utility.onCancel(items, function()
            if condition then
                argument_2.Enabled = false
            end

            argument_2:Clear()
        end)

        argument_2:Emit(get_result_2)

        if condition then
            task.wait(get_result_3)
            argument_2.Enabled = false
        end

        tween.timer(argument.Lifetime.Max, function(argument_3, argument_4)
            if argument.TimeScale > 0 or argument_4 > 0 and (value and value.Connected) then
                return argument_3 * argument.TimeScale
            end

            return nil
        end, value, items)
    end,
}
