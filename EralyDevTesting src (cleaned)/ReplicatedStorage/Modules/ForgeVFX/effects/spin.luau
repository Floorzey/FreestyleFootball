local attributes = require("../mod/attributes")
local tween = require("../mod/tween")
require("../types")
local utility = require("../mod/utility")

return {
    emit = function(argument: userdata, items: any)
        if utility.isSpinModelStatic(argument) then
            return
        end

        local product = attributes.get(argument, "SpinRotation", Vector3.new(0, 0, 0)) * utility.DEG_TO_RAD
        local get_result = attributes.get(argument, "Scale_Start", 1)
        local get_result_2 = attributes.get(argument, "Scale_End", 1)
        local get_result_3 = attributes.get(argument, "EmitDelay", 0)
        local get_result_4 = attributes.get(argument, "ResetDelay", 0)
        local get_result_5 = attributes.get(argument, "ResetOnFinish", true)
        local get_result_6 = attributes.get(argument, "SyncPosition", false)
        local get_result_7 = attributes.get(argument, "SpinDuration", 0.5)
        local get_result_8 = attributes.get(argument, "SpinSpeed_Duration", 0.1)
        local get_result_9 = attributes.get(argument, "SpinSpeed_Start", 0)
        local get_result_10 = attributes.get(argument, "SpinSpeed_End", 1)
        local get_result_11 = get_result_9
        task.wait(get_result_3)
        local value

        if get_result_9 == get_result_10 then
            value = nil
        else
            value = tween.fromParams(
                attributes.get(argument, "SpinSpeed_Curve", utility.default_bezier),
                get_result_8,
                function(argument_2, argument_3)
                    get_result_11 = utility.lerp(get_result_9, get_result_10, argument_2)

                    return argument_3
                end
            )
            table.insert(items, value)
        end

        local pivot = argument:GetPivot()
        local scale = argument:GetScale()

        if get_result == get_result_2 then
            argument:ScaleTo(get_result)
        else
            local from_params = tween.fromParams
            local get_result_12 = attributes.get(argument, "Scale_Curve", utility.default_bezier)
            table.insert(
                items,
                from_params(get_result_12, get_result_7, function(argument_2, argument_3)
                    argument:ScaleTo(utility.lerp(get_result, get_result_2, argument_2))

                    return argument_3
                end)
            )
        end

        local first_ancestor_of_class = argument:FindFirstAncestorOfClass("Attachment")
            or argument:FindFirstAncestorWhichIsA("BasePart")

        if get_result_5 then
            table.insert(items, function()
                argument:PivotTo(
                    first_ancestor_of_class and utility.getTransformedOriginExtents(first_ancestor_of_class) or pivot
                )
                argument:ScaleTo(scale)
            end)
        end

        local product_2 = product * get_result_7

        tween.timer(get_result_7 + get_result_4, function(argument_2, argument_3)
            local product_3 = product_2 * math.clamp(argument_3 / get_result_7, 0, 1)
            local get_transformed_origin_extents_result

            if first_ancestor_of_class and get_result_6 then
                get_transformed_origin_extents_result = utility.getTransformedOriginExtents(first_ancestor_of_class)
            else
                get_transformed_origin_extents_result = pivot
            end

            argument:PivotTo(
                get_transformed_origin_extents_result * CFrame.fromOrientation(product_3.x, product_3.y, product_3.z)
            )

            if get_result_11 > 0 or argument_3 > 0 and value.Connected then
                return argument_2 * get_result_11
            end

            return nil
        end, value, items, utility.RENDER_PRIORITY + items.depth)
    end,
}
