local function cubic_bezier(argument, argument_2, argument_3, argument_4, argument_5)
    return (1 - argument_5) ^ 3 * argument
        + 3 * (1 - argument_5) ^ 2 * argument_5 * argument_2
        + 3 * (1 - argument_5) * argument_5 ^ 2 * argument_3
        + argument_5 ^ 3 * argument_4
end

local function cubic_bezier_derivative(argument, argument_2, argument_3, argument_4, argument_5)
    return 3 * (1 - argument_5) ^ 2 * (argument_2 - argument)
        + 6 * (1 - argument_5) * argument_5 * (argument_3 - argument_2)
        + 3 * argument_5 ^ 2 * (argument_4 - argument_3)
end

local bezier = {}
bezier.__index = bezier

function bezier.new(points: table, accuracy: number?)
    local instance = setmetatable({}, bezier)
    instance.points = points
    instance.accuracy = accuracy or 20
    instance.point_count = 0
    instance.cumulative_lengths = {}
    instance:_recalculate()

    return instance
end

function bezier.setPoints(argument: any, points: table)
    argument.points = points
    argument.ease_lut = nil
    argument:_recalculate()
end

function bezier.getSegmentPoints(argument: any, argument_2: number)
    if argument_2 < 1 or argument.point_count - 1 < argument_2 then
        if argument_2 <= 0 then
            return Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), Vector3.new(0, 0, 0)
        end

        error("attempt to get a non-existent segment at index " .. argument_2)
    end

    local difference = (argument_2 - 1) * 4 - math.max(argument_2 - 2, 0)
    local maximum = math.max(difference, 1)

    return argument.points[maximum],
        argument.points[maximum + 1],
        argument.points[maximum + 2],
        argument.points[maximum + 3]
end

function bezier.forSample(argument: any, argument_2: number, callback: (...any) -> ...any)
    local quotient = argument.length // argument_2

    if quotient == 0 then
        return
    end

    for index = 0, quotient do
        callback(argument:getPositionArcSpace(index / quotient), index)
        local _ = index
    end
end

function bezier.getPosition(argument: any, argument_2: number)
    local segment_index, value = argument:getSegmentIndex(argument_2)
    local segment_points, value_2, value_3, value_4 = argument:getSegmentPoints(segment_index)

    return (1 - value) ^ 3 * segment_points
        + 3 * (1 - value) ^ 2 * value * value_2
        + 3 * (1 - value) * value ^ 2 * value_3
        + value ^ 3 * value_4
end

function bezier.getSegmentIndex(argument: any, argument_2: number)
    local clamped_value = math.clamp(argument_2, 0, 1)
    local difference = argument.point_count - 1
    local product = clamped_value * difference
    local sum = math.floor(product) + 1
    local minimum = math.min(sum, difference)
    local difference_2 = product - math.floor(product)

    return minimum, clamped_value == 1 and 1 or difference_2
end

function bezier.getEasedSegmentIndex(argument: any, argument_2: number)
    local difference = argument.point_count - 1

    for index = 1, difference do
        local segment_points, _, _, value = argument:getSegmentPoints(index)
        local x = segment_points.x
        local x2 = value.x

        if x <= argument_2 and argument_2 < x2 then
            return index, (argument_2 - x) / (x2 - x)
        end

        local _ = index
    end

    return difference, 1
end

function bezier._getEaseRaw(argument: any, argument_2: number)
    local eased_segment_index, difference = argument:getEasedSegmentIndex(argument_2)
    local segment_points, value, value_2, value_3 = argument:getSegmentPoints(eased_segment_index)

    for index = 1, 5 do
        local x = value.x
        local x2 = value_2.x
        local sum = 3 * (1 - difference) ^ 2 * (x - segment_points.x)
            + 6 * (1 - difference) * difference * (x2 - x)
            + 3 * difference ^ 2 * (value_3.x - x2)

        if sum == 0 then
            break
        end

        local quotient = (
            (1 - difference) ^ 3 * segment_points.x
            + 3 * (1 - difference) ^ 2 * difference * value.x
            + 3 * (1 - difference) * difference ^ 2 * value_2.x
            + difference ^ 3 * value_3.x
            - argument_2
        ) / sum
        local difference_2 = difference - quotient
        difference = difference_2 < 0 and 0 or (difference_2 > 1 and 1 or difference_2)

        if math.abs(quotient) < 0.001 then
            break
        end

        local _ = index
    end

    return (1 - difference) ^ 3 * segment_points
        + 3 * (1 - difference) ^ 2 * difference * value
        + 3 * (1 - difference) * difference ^ 2 * value_2
        + difference ^ 3 * value_3
end

function bezier._buildEaseLUT(argument)
    local ease_lut = table.create(65)

    for index = 0, 64 do
        ease_lut[index] = argument:_getEaseRaw(index / 64)
        local _ = index
    end

    argument.ease_lut = ease_lut
end

function bezier.getEase(argument: any, argument_2: number)
    local ease_lut = argument.ease_lut

    if not ease_lut then
        argument:_buildEaseLUT()
        ease_lut = argument.ease_lut
    end

    local clamped_value = math.clamp(argument_2, 0, 1)
    local product = clamped_value * 64
    local rounded_value = math.floor(product)
    local minimum = math.min(rounded_value + 1, 64)
    local difference = product - rounded_value
    local ease_lut_entry = ease_lut[rounded_value]
    local ease_lut_entry_2 = ease_lut[minimum]

    if ease_lut_entry and ease_lut_entry_2 then
        return ease_lut_entry:Lerp(ease_lut_entry_2, difference)
    end

    return argument:_getEaseRaw(clamped_value)
end

function bezier.getPositionArcSpace(argument: any, argument_2: number)
    if argument.length <= 0 then
        return argument.points[1] or Vector3.new(0, 0, 0)
    end

    local product = math.clamp(argument_2, 0, 1) * argument.cumulative_lengths[argument.accuracy + 1]
    local sum = argument.accuracy + 1
    local number = 1
    local value = nil

    while number < sum do
        value = number + (sum - number) // 2

        if argument.cumulative_lengths[value] < product then
            number = value + 1
        else
            sum = value
        end
    end

    if product < argument.cumulative_lengths[value] and value > 1 then
        value -= 1
    end

    local cumulative_length_entry = argument.cumulative_lengths[value]

    if cumulative_length_entry == product then
        return argument:getPosition((value - 1) / argument.accuracy)
    end

    return argument:getPosition(
        (
            value
            - 1
            + (product - cumulative_length_entry)
                / (argument.cumulative_lengths[value + 1] - cumulative_length_entry)
        ) / argument.accuracy
    )
end

function bezier._recalculate(argument)
    table.clear(argument.cumulative_lengths)
    table.insert(argument.cumulative_lengths, 0)
    argument.point_count = math.ceil(#argument.points / 3)
    local value = nil
    local length = 0

    for index = 1, argument.accuracy do
        local position = argument:getPosition(index / argument.accuracy)
        local get_position_result = value or argument:getPosition(0)
        length += vector.magnitude(position - get_position_result)
        table.insert(argument.cumulative_lengths, length)
        value = position
        local _ = index
    end

    argument.length = length

    for key, item in argument.cumulative_lengths do
        argument.cumulative_lengths[key] = item / length
    end
end

return bezier
