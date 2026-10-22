local oklab = require("./color/Oklab")
local lerp = {
    number = function(argument: number, argument_2: number, argument_3: number)
        return argument + (argument_2 - argument) * argument_3
    end,

    Vector3 = function(argument: vector, argument_2: vector, argument_3: number)
        return argument:Lerp(argument_2, argument_3)
    end,

    Vector2 = function(argument, argument_2, argument_3: number)
        return argument:Lerp(argument_2, argument_3)
    end,

    CFrame = function(argument, argument_2, argument_3: number)
        return argument:Lerp(argument_2, argument_3)
    end,

    UDim2 = function(argument, argument_2, argument_3: number)
        return argument:Lerp(argument_2, argument_3)
    end,
}

function lerp.UDim(argument, argument_2, argument_3: number)
    return UDim.new(
        lerp.number(argument.Scale, argument_2.Scale, argument_3),
        lerp.number(argument.Offset, argument_2.Offset, argument_3)
    )
end

function lerp.NumberRange(argument, argument_2, argument_3: number)
    return NumberRange.new(
        lerp.number(argument.Min, argument_2.Min, argument_3),
        lerp.number(argument.Max, argument_2.Max, argument_3)
    )
end

function lerp.Color3(argument, argument_2, argument_3: number)
    return oklab.toSRGB(oklab.fromSRGB(argument):Lerp(oklab.fromSRGB(argument_2), argument_3))
end

function lerp.PhysicalProperties(argument: userdata, argument_2: userdata, argument_3: number)
    return PhysicalProperties.new(
        lerp.number(argument.Density, argument_2.Density, argument_3),
        lerp.number(argument.Friction, argument_2.Friction, argument_3),
        lerp.number(argument.Elasticity, argument_2.Elasticity, argument_3),
        lerp.number(argument.FrictionWeight, argument_2.FrictionWeight, argument_3),
        lerp.number(argument.ElasticityWeight, argument_2.ElasticityWeight, argument_3)
    )
end

function lerp.Rect(argument, argument_2, argument_3: number)
    return Rect.new(argument.Min:Lerp(argument_2.Min, argument_3), argument.Max:Lerp(argument_2.Max, argument_3))
end

function lerp.NumberSequence(argument: userdata, argument_2: userdata, argument_3: number)
    local values = {}
    local values_2 = {}
    local number = 0

    for _, item in argument.Keypoints do
        local item_2 = item
        local value_3 = nil
        local value_4 = nil

        for _, item_3 in argument_2.Keypoints do
            if item_3.Time == item_2.Time then
                value_3 = item_3
                value_4 = value_3
                local value_5 = value_3
                value_3 = value_4
                value_5 = value_4
                break
            end

            if item_3.Time < item_2.Time and (value_3 == nil or item_3.Time > value_3.Time) then
                value_3 = item_3
            elseif item_3.Time > item_2.Time and (value_4 == nil or item_3.Time < value_4.Time) then
                value_4 = item_3
            end
        end

        local value, envelope

        if value_4 == value_3 then
            value = value_4.Value
            envelope = value_4.Envelope
        else
            local quotient = (item_2.Time - value_3.Time) / (value_4.Time - value_3.Time)
            value = (value_4.Value - value_3.Value) * quotient + value_3.Value
            envelope = (value_4.Envelope - value_3.Envelope) * quotient + value_3.Envelope
        end

        number += 1
        values[number] = NumberSequenceKeypoint.new(
            item_2.Time,
            (value - item_2.Value) * argument_3 + item_2.Value,
            (envelope - item_2.Envelope) * argument_3 + item_2.Envelope
        )
        values_2[item_2.Time] = true
    end

    for _, item_4 in argument_2.Keypoints do
        if not values_2[item_4.Time] then
            local item_5 = item_4
            local value_6 = nil
            local value_7 = nil

            for _, item_6 in argument.Keypoints do
                if item_6.Time == item_5.Time then
                    value_6 = item_6
                    value_7 = value_6
                    local value_8 = value_6
                    value_6 = value_7
                    value_8 = value_7
                    break
                end

                if item_6.Time < item_5.Time and (value_6 == nil or item_6.Time > value_6.Time) then
                    value_6 = item_6
                elseif item_6.Time > item_5.Time and (value_7 == nil or item_6.Time < value_7.Time) then
                    value_7 = item_6
                end
            end

            local value_2, envelope_2

            if value_7 == value_6 then
                value_2 = value_7.Value
                envelope_2 = value_7.Envelope
            else
                local quotient_2 = (item_5.Time - value_6.Time) / (value_7.Time - value_6.Time)
                value_2 = (value_7.Value - value_6.Value) * quotient_2 + value_6.Value
                envelope_2 = (value_7.Envelope - value_6.Envelope) * quotient_2 + value_6.Envelope
            end

            number += 1
            values[number] = NumberSequenceKeypoint.new(
                item_5.Time,
                (item_5.Value - value_2) * argument_3 + value_2,
                (item_5.Envelope - envelope_2) * argument_3 + envelope_2
            )
        end
    end

    table.sort(values, function(argument_4, argument_5)
        return argument_4.Time < argument_5.Time
    end)

    local items

    if #values > 20 then
        local quotient_3 = (#values - 1) / 19
        items = {}

        for index = 0, 19 do
            local value_entry = values[math.floor(index * quotient_3 + 1)]
            table.insert(items, value_entry)
            local _ = index
        end

        if items[#items].Time < values[#values].Time then
            items[#items] = values[#values]
        end
    else
        items = values
    end

    return NumberSequence.new(items)
end

local function get_color_at_time(argument: userdata, argument_2: number)
    local keypoints = argument.Keypoints

    if argument_2 <= keypoints[1].Time then
        return keypoints[1].Value
    end

    if keypoints[#keypoints].Time <= argument_2 then
        return keypoints[#keypoints].Value
    end

    local value = nil
    local value_2 = nil

    for index = 1, #keypoints do
        local keypoint_entry = keypoints[index]

        if keypoint_entry.Time == argument_2 then
            return keypoint_entry.Value
        end

        local index_2

        if keypoint_entry.Time < argument_2 then
            value = keypoint_entry
            index_2 = index
        else
            if argument_2 < keypoint_entry.Time then
                value_2 = keypoint_entry
                break
            end

            index_2 = index
        end
    end

    return value.Value:Lerp(value_2.Value, (argument_2 - value.Time) / (value_2.Time - value.Time))
end

function lerp.ColorSequence(argument: userdata, argument_2: userdata, argument_3: number)
    local items = {}

    for _, item in ipairs(argument_2.Keypoints) do
        local result = get_color_at_time(argument, item.Time)
        local to_srgb_result = oklab.toSRGB(oklab.fromSRGB(result:Lerp(item.Value, argument_3)))
        table.insert(items, ColorSequenceKeypoint.new(item.Time, to_srgb_result))
    end

    return ColorSequence.new(items)
end

function lerp.Other(argument: any, argument_2: any, argument_3: number)
    if argument_3 < 0.5 then
        argument_2 = argument or argument_2
    end

    return argument_2
end

return lerp
