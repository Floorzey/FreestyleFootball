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
    local argument_offset = argument_2 + 0.8660254037844386 * (argument.Size[1] / 2)
    for _, item in next, argument.SubRegions do
        local position = item.Position
        local argument_offset_2 = argument_3 - position[1]
        local argument_offset_3 = argument_4 - position[2]
        local argument_offset_4 = argument_5 - position[3]
        if
            not (
                ((argument_offset_2 * argument_offset_2) + (argument_offset_3 * argument_offset_3))
                    + (argument_offset_4 * argument_offset_4)
                <= (argument_offset * argument_offset) + 1e-06
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
            local position_x_offset = key.PositionX - argument_3
            local position_y_offset = key.PositionY - argument_4
            local position_z_offset = key.PositionZ - argument_5
            local position_x_offset_offset_offset_offset = (position_x_offset * position_x_offset)
                + (position_y_offset * position_y_offset)
                + position_z_offset * position_z_offset
            if position_x_offset_offset_offset_offset <= argument_2 * argument_2 then
                result += 1
                argument_9 += 1
                argument_6[result] = key.Object
                argument_7[argument_9] = position_x_offset_offset_offset_offset
            end
        end
    end
    return result, argument_9
end

octree_region_utils.GetNeighborsWithinRadius = get_neighbors_within_radius

return octree_region_utils
