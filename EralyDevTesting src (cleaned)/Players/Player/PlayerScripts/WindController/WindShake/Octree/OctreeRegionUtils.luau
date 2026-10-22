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
    sum,
    sum_2
)
    if not argument_8 then
        error("Missing MaxDepth.")
    end

    local sum_3 = argument_2 + 0.8660254037844386 * (argument.Size[1] / 2)
    local sum_4 = sum_3 * sum_3 + 1e-6
    local product = argument_2 * argument_2

    for _, item in next, argument.SubRegions do
        local position = item.Position
        local difference = argument_3 - position[1]
        local difference_2 = argument_4 - position[2]
        local difference_3 = argument_5 - position[3]

        if difference * difference + difference_2 * difference_2 + difference_3 * difference_3 <= sum_4 then
            if item.Depth == argument_8 then
                for key in next, item.Nodes do
                    local difference_4 = key.PositionX - argument_3
                    local difference_5 = key.PositionY - argument_4
                    local difference_6 = key.PositionZ - argument_5
                    local sum_5 = difference_4 * difference_4
                        + difference_5 * difference_5
                        + difference_6 * difference_6

                    if sum_5 <= product then
                        sum += 1
                        sum_2 += 1
                        argument_6[sum] = key.Object
                        argument_7[sum_2] = sum_5
                    end
                end
            else
                sum, sum_2 = get_neighbors_within_radius(
                    item,
                    argument_2,
                    argument_3,
                    argument_4,
                    argument_5,
                    argument_6,
                    argument_7,
                    argument_8,
                    sum,
                    sum_2
                )
            end
        end
    end

    return sum, sum_2
end

octree_region_utils.GetNeighborsWithinRadius = get_neighbors_within_radius

return octree_region_utils
