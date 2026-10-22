local octree_node = require(script.OctreeNode)
local octree_region_utils = require(script.OctreeRegionUtils)
local values = {
    { 0.25, 0.25, -0.25 },
    { -0.25, 0.25, -0.25 },
    { 0.25, 0.25, 0.25 },
    { -0.25, 0.25, 0.25 },
    { 0.25, -0.25, -0.25 },
    { -0.25, -0.25, -0.25 },
    { 0.25, -0.25, 0.25 },
    { -0.25, -0.25, 0.25 },
}
local octree = { ClassName = "Octree" }
octree.__index = octree
local new = octree_node.new
local get_neighbors_within_radius = octree_region_utils.GetNeighborsWithinRadius

function octree.new()
    return (setmetatable({ MaxDepth = 4, MaxRegionSize = table.create(3, 512), RegionHashMap = {} }, octree))
end

function octree.ClearNodes(argument)
    argument.MaxDepth = 4
    argument.MaxRegionSize = table.create(3, 512)
    table.clear(argument.RegionHashMap)
end

function octree.GetAllNodes(argument)
    local values_2 = {}
    local number = 0

    for _, item in next, argument.RegionHashMap do
        for index, item_2 in ipairs(item) do
            for key in next, item_2.Nodes do
                number += 1
                values_2[number] = key
            end
        end
    end

    return values_2
end

function octree.CreateNode(argument, argument_2, argument_3)
    if typeof(argument_2) ~= "Vector3" then
        error("Bad position value")
    end

    if not argument_3 then
        error("Bad object value.")
    end

    local result = new(argument, argument_3)
    result:SetPosition(argument_2)

    return result
end

function octree.RadiusSearch(argument, argument_2, argument_3)
    if typeof(argument_2) ~= "Vector3" then
        error("Bad position value")
    end

    if type(argument_3) ~= "number" then
        error("Bad radius value")
    end

    local x = argument_2.X
    local y = argument_2.Y
    local z = argument_2.Z
    local values_2 = {}
    local values_3 = {}
    local number = 0
    local number_2 = 0
    local sum = argument_3 + 0.8660254037844386 * argument.MaxRegionSize[1]

    for _, item in next, argument.RegionHashMap do
        for index, item_2 in ipairs(item) do
            local position = item_2.Position
            local difference = x - position[1]
            local difference_2 = y - position[2]
            local difference_3 = z - position[3]

            if
                ((difference * difference) + (difference_2 * difference_2)) + (difference_3 * difference_3)
                <= (sum * sum) + 1e-09
            then
                local result, value = get_neighbors_within_radius(
                    item_2,
                    argument_3,
                    x,
                    y,
                    z,
                    values_2,
                    values_3,
                    argument.MaxDepth,
                    number,
                    number_2
                )
                number, number_2 = result, value
            end
        end
    end

    return values_2, values_3
end

local function nearest_neighbor_sort(argument, argument_2)
    return argument.Distance2 < argument_2.Distance2
end

function octree.KNearestNeighborsSearch(argument, argument_2, argument_3, argument_4)
    if typeof(argument_2) ~= "Vector3" then
        error("Bad position value")
    end

    if type(argument_4) ~= "number" then
        error("Bad radius value")
    end

    local x = argument_2.X
    local y = argument_2.Y
    local z = argument_2.Z
    local values_2 = {}
    local values_3 = {}
    local number = 0
    local number_2 = 0
    local sum = argument_4 + 0.8660254037844386 * argument.MaxRegionSize[1]

    for _, item in next, argument.RegionHashMap do
        for index_2, item_2 in ipairs(item) do
            local position = item_2.Position
            local difference = x - position[1]
            local difference_2 = y - position[2]
            local difference_3 = z - position[3]

            if
                ((difference * difference) + (difference_2 * difference_2)) + (difference_3 * difference_3)
                <= (sum * sum) + 1e-09
            then
                local result, value = get_neighbors_within_radius(
                    item_2,
                    argument_4,
                    x,
                    y,
                    z,
                    values_2,
                    values_3,
                    argument.MaxDepth,
                    number,
                    number_2
                )
                number, number_2 = result, value
            end
        end
    end

    local create_result = table.create(number_2)

    for index, distance2 in ipairs(values_3) do
        create_result[index] = { Distance2 = distance2, Index = index }
    end

    table.sort(create_result, nearest_neighbor_sort)
    number = math.min(number_2, argument_3)
    number_2 = table.create(number)
    local create_result_2 = table.create(number)

    for n = 1, number do
        local create_result_entry = create_result[n]
        create_result_2[n] = create_result_entry.Distance2
        number_2[n] = values_2[create_result_entry.Index]
    end

    return number_2, create_result_2
end

local function get_or_create_region(argument, argument_2, argument_3, argument_4)
    local region_hash_map = argument.RegionHashMap
    local max_region_size = argument.MaxRegionSize
    local max_region_size_entry = max_region_size[1]
    local max_region_size_entry_2 = max_region_size[2]
    local upper_bounds = max_region_size[3]
    local rounded_value = math.floor((argument_2 / max_region_size_entry) + 0.5)
    local rounded_value_2 = math.floor((argument_3 / max_region_size_entry_2) + 0.5)
    local rounded_value_3 = math.floor((argument_4 / upper_bounds) + 0.5)
    local sum = (rounded_value * 73856093) + (rounded_value_2 * 19351301) + rounded_value_3 * 83492791
    local region_hash_map_entry = region_hash_map[sum]

    if not region_hash_map_entry then
        region_hash_map_entry = {}
        region_hash_map[sum] = region_hash_map_entry
    end

    local product = max_region_size_entry * rounded_value
    local product_2 = max_region_size_entry_2 * rounded_value_2
    local product_3 = upper_bounds * rounded_value_3

    for _, item in ipairs(region_hash_map_entry) do
        local position = item.Position

        if position[1] ~= product or position[2] ~= product_2 or position[3] ~= product_3 then
            continue
        end

        return item
    end

    local quotient = max_region_size_entry / 2
    local quotient_2 = max_region_size_entry_2 / 2
    local quotient_3 = upper_bounds / 2
    local lower_bounds = { product - quotient, product_2 - quotient_2, product_3 - quotient_3 }
    local position_2 = { product, product_2, product_3 }
    local size = { max_region_size_entry, max_region_size_entry_2, upper_bounds }
    upper_bounds = { product + quotient, product_2 + quotient_2, product_3 + quotient_3 }
    quotient_3 = { NodeCount = 0, Depth = 1 }
    quotient_3.LowerBounds = lower_bounds
    quotient_3.Nodes = {}
    quotient_3.Position = position_2
    quotient_3.Size = size
    quotient_3.SubRegions = {}
    quotient_3.UpperBounds = upper_bounds
    table.insert(region_hash_map_entry, quotient_3)

    return quotient_3
end

function octree.GetOrCreateLowestSubRegion(argument, argument_2, argument_3, argument_4)
    local result = get_or_create_region(argument, argument_2, argument_3, argument_4)
    local value = nil
    local parent = result

    for _ = result.Depth, argument.MaxDepth do
        local position = parent.Position
        local parent_index = ((position[1] < argument_2) and 1) or 2
        parent_index = ((argument_3 <= position[2]) and (parent_index + 4)) or parent_index
        parent_index = ((position[3] <= argument_4) and (parent_index + 2)) or parent_index
        local sub_regions = parent.SubRegions
        value = sub_regions[parent_index]

        if not value then
            local size = parent.Size
            local value_entry = values[parent_index]
            local size_entry = parent.Size[1]
            local size_entry_2 = parent.Size[2]
            local size_entry_3 = parent.Size[3]
            local sum = position[1] + values[parent_index][1] * parent.Size[1]
            local sum_2 = position[2] + values[parent_index][2] * parent.Size[2]
            local sum_3 = position[3] + values[parent_index][3] * parent.Size[3]
            local quotient = parent.Size[1] / 2
            local quotient_2 = parent.Size[2] / 2
            local quotient_3 = parent.Size[3] / 2
            local quotient_4 = parent.Size[1] / 2 / 2
            local quotient_5 = parent.Size[2] / 2 / 2
            local quotient_6 = parent.Size[3] / 2 / 2
            local lower_bounds = {
                position[1] + values[parent_index][1] * parent.Size[1] - parent.Size[1] / 2 / 2,
                position[2] + values[parent_index][2] * parent.Size[2] - parent.Size[2] / 2 / 2,
                position[3] + values[parent_index][3] * parent.Size[3] - parent.Size[3] / 2 / 2,
            }
            local position_2 = { sum, sum_2, sum_3 }
            local size_2 = { quotient, quotient_2, quotient_3 }
            local upper_bounds = { sum + quotient_4, sum_2 + quotient_5, sum_3 + quotient_6 }
            local properties = {
                LowerBounds = 0,
                UpperBounds = 0,
                SubRegions = 0,
                NodeCount = 0,
                ParentIndex = 0,
                Position = 0,
                Nodes = 0,
                Depth = 0,
                Parent = 0,
                Size = 0,
            }
            properties.Depth = (parent and (parent.Depth + 1)) or 1
            properties.LowerBounds = lower_bounds
            properties.Nodes = {}
            properties.Parent = parent
            properties.ParentIndex = parent_index
            properties.Position = position_2
            properties.Size = size_2
            properties.SubRegions = {}
            properties.UpperBounds = upper_bounds
            sub_regions[parent_index] = properties
            value = properties
        end

        parent = value
    end

    return parent
end

return octree
