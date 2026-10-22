local script_octree_node = require(script.OctreeNode)
local script_octree_region_utils = require(script.OctreeRegionUtils)
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
local octree = {
    ClassName = "Octree",
}
octree.__index = octree
local new = script_octree_node.new
local get_neighbors_within_radius = script_octree_region_utils.GetNeighborsWithinRadius

function octree.new()
    local values_2 = {
        MaxDepth = 4,
        MaxRegionSize = table.create(3, 512),
        RegionHashMap = {},
    }

    return setmetatable(values_2, octree)
end

function octree.ClearNodes(argument)
    argument.MaxDepth = 4
    argument.MaxRegionSize = table.create(3, 512)
    table.clear(argument.RegionHashMap)
end

function octree.GetAllNodes(argument)
    local number = 0
    local values_2 = {}

    for _, item in next, argument.RegionHashMap do
        for _, item_2 in ipairs(item) do
            for key in next, item_2.Nodes do
                number += 1
                values_2[number] = key
            end
        end
    end

    return values_2
end

function octree.CreateNode(argument: table, argument_2: vector, argument_3: any)
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

function octree.RadiusSearch(argument: table, argument_2: vector, argument_3: number)
    if typeof(argument_2) ~= "Vector3" then
        error("Bad position value")
    end

    if type(argument_3) ~= "number" then
        error("Bad radius value")
    end

    local x = argument_2.X
    local y = argument_2.Y
    local z = argument_2.Z
    local sum = argument_3 + 0.8660254037844386 * argument.MaxRegionSize[1]
    local sum_2 = sum * sum + 1e-9
    local number = 0
    local number_2 = 0
    local values_2 = {}
    local values_3 = {}

    for _, item in next, argument.RegionHashMap do
        for _, item_2 in ipairs(item) do
            local position = item_2.Position
            local difference = x - position[1]
            local difference_2 = y - position[2]
            local difference_3 = z - position[3]

            if difference * difference + difference_2 * difference_2 + difference_3 * difference_3 <= sum_2 then
                number, number_2 = get_neighbors_within_radius(
                    item_2,
                    argument_3,
                    x,
                    y,
                    z,
                    values_3,
                    values_2,
                    argument.MaxDepth,
                    number,
                    number_2
                )
            end
        end
    end

    return values_3, values_2
end

local function nearest_neighbor_sort(argument, argument_2)
    return argument.Distance2 < argument_2.Distance2
end

function octree.KNearestNeighborsSearch(argument: table, argument_2: vector, argument_3: number, argument_4: number)
    if typeof(argument_2) ~= "Vector3" then
        error("Bad position value")
    end

    if type(argument_4) ~= "number" then
        error("Bad radius value")
    end

    local x = argument_2.X
    local y = argument_2.Y
    local z = argument_2.Z
    local sum = argument_4 + 0.8660254037844386 * argument.MaxRegionSize[1]
    local sum_2 = sum * sum + 1e-9
    local number = 0
    local values_2 = {}
    local number_2 = 0
    local values_3 = {}

    for _, item in next, argument.RegionHashMap do
        for _, item_2 in ipairs(item) do
            local position = item_2.Position
            local difference = x - position[1]
            local difference_2 = y - position[2]
            local difference_3 = z - position[3]

            if difference * difference + difference_2 * difference_2 + difference_3 * difference_3 <= sum_2 then
                number, number_2 = get_neighbors_within_radius(
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
            end
        end
    end

    local create_result = table.create(number_2)

    for index_2, distance2 in ipairs(values_3) do
        create_result[index_2] = {
            Distance2 = distance2,
            Index = index_2,
        }
    end

    table.sort(create_result, nearest_neighbor_sort)
    local minimum = math.min(number_2, argument_3)
    local create_result_2 = table.create(minimum)
    local create_result_3 = table.create(minimum)

    for index = 1, minimum do
        local create_result_entry = create_result[index]
        create_result_3[index] = create_result_entry.Distance2
        create_result_2[index] = values_2[create_result_entry.Index]
        local _ = index
    end

    return create_result_2, create_result_3
end

local function get_or_create_region(argument: any, argument_2: number, argument_3: number, argument_4: number)
    local region_hash_map = argument.RegionHashMap
    local max_region_size = argument.MaxRegionSize
    local max_region_size_entry = max_region_size[1]
    local max_region_size_entry_2 = max_region_size[2]
    local max_region_size_entry_3 = max_region_size[3]
    local rounded_value = math.floor(argument_2 / max_region_size_entry + 0.5)
    local rounded_value_2 = math.floor(argument_3 / max_region_size_entry_2 + 0.5)
    local rounded_value_3 = math.floor(argument_4 / max_region_size_entry_3 + 0.5)
    local sum = rounded_value * 73856093 + rounded_value_2 * 19351301 + rounded_value_3 * 83492791
    local region_hash_map_entry = region_hash_map[sum]

    if not region_hash_map_entry then
        region_hash_map_entry = {}
        region_hash_map[sum] = region_hash_map_entry
    end

    local product = max_region_size_entry * rounded_value
    local product_2 = max_region_size_entry_2 * rounded_value_2
    local product_3 = max_region_size_entry_3 * rounded_value_3

    for _, item in ipairs(region_hash_map_entry) do
        local position = item.Position

        if position[1] == product and (position[2] == product_2 and position[3] == product_3) then
            return item
        end
    end

    local quotient = max_region_size_entry / 2
    local quotient_2 = max_region_size_entry_2 / 2
    local quotient_3 = max_region_size_entry_3 / 2
    local properties = {
        Depth = 1,
        NodeCount = 0,
        Parent = nil,
        ParentIndex = nil,
        LowerBounds = { product - quotient, product_2 - quotient_2, product_3 - quotient_3 },
        Nodes = {},
        Position = { product, product_2, product_3 },
        Size = { max_region_size_entry, max_region_size_entry_2, max_region_size_entry_3 },
        SubRegions = {},
        UpperBounds = { product + quotient, product_2 + quotient_2, product_3 + quotient_3 },
    }
    table.insert(region_hash_map_entry, properties)

    return properties
end

function octree.GetOrCreateLowestSubRegion(argument: table, argument_2: number, argument_3: number, argument_4: number)
    local parent = get_or_create_region(argument, argument_2, argument_3, argument_4)

    for index = parent.Depth, argument.MaxDepth do
        local position = parent.Position
        local parent_index = position[1] < argument_2 and 1 or 2

        if argument_3 <= position[2] then
            parent_index += 4
        end

        if position[3] <= argument_4 then
            parent_index += 2
        end

        local sub_regions = parent.SubRegions
        local sub_region_entry = sub_regions[parent_index]

        if sub_region_entry then
            parent = sub_region_entry
        else
            local size = parent.Size
            local value_entry = values[parent_index]
            local size_entry = size[1]
            local size_entry_2 = size[2]
            local size_entry_3 = size[3]
            local sum = position[1] + value_entry[1] * size_entry
            local sum_2 = position[2] + value_entry[2] * size_entry_2
            local sum_3 = position[3] + value_entry[3] * size_entry_3
            local quotient = size_entry / 2
            local quotient_2 = size_entry_2 / 2
            local quotient_3 = size_entry_3 / 2
            local quotient_4 = quotient / 2
            local quotient_5 = quotient_2 / 2
            local quotient_6 = quotient_3 / 2
            parent = {
                NodeCount = 0,
                Depth = parent and (parent.Depth + 1 or 1) or 1,
                LowerBounds = { sum - quotient_4, sum_2 - quotient_5, sum_3 - quotient_6 },
                Nodes = {},
                Parent = parent,
                ParentIndex = parent_index,
                Position = { sum, sum_2, sum_3 },
                Size = { quotient, quotient_2, quotient_3 },
                SubRegions = {},
                UpperBounds = { sum + quotient_4, sum_2 + quotient_5, sum_3 + quotient_6 },
            }
            sub_regions[parent_index] = parent
        end

        local _ = index
    end

    return parent
end

return octree
