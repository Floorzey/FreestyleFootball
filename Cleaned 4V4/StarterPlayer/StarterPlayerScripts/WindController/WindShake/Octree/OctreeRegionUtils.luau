local octree_region_utils = {}

local function get_neighbors_within_radius(
    argument,
    argument_2,
    argument_3,
    argument_4,
    argument_5,
    argument_6,
    argument_7,
    argument_8,
    result,
    argument_9
)
    if not argument_8 then
        error("Missing MaxDepth.")
    end

    local sum = argument_2 + 0.8660254037844386 * (argument.Size[1] / 2)

    for _, item in next, argument.SubRegions do
        local position = item.Position
        local difference = argument_3 - position[1]
        local difference_2 = argument_4 - difference[2]
        local difference_3 = argument_5 - difference[3]

        if
            not (
                ((difference * difference) + (difference_2 * difference_2)) + (difference_3 * difference_3)
                <= (sum * sum) + 1e-06
            )
        then
            continue
        end

        if item.Depth ~= argument_8 then
            local result_2, value = get_neighbors_within_radius(
                item,
                argument_2,
                argument_3,
                argument_4,
                argument_5,
                argument_6,
                argument_7,
                argument_8,
                result,
                argument_9
            )
            result, argument_9 = result_2, value
            continue
        end

        for key in next, item.Nodes do
            local difference_4 = key.PositionX - argument_3
            local difference_5 = key.PositionY - argument_4
            local difference_6 = key.PositionZ - argument_5
            local sum_2 = (difference_4 * difference_4) + (difference_5 * difference_5) + difference_6 * difference_6

            if sum_2 <= argument_2 * argument_2 then
                result += 1
                argument_9 += 1
                argument_6[result] = key.Object
                argument_7[argument_9] = sum_2
            end
        end
    end

    return result, argument_9
end

octree_region_utils.GetNeighborsWithinRadius = get_neighbors_within_radius

return octree_region_utils
