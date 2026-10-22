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

function octree.ClearNodes(self)
    self.MaxDepth = 4
    self.MaxRegionSize = table.create(3, 512)
    table.clear(self.RegionHashMap)
end

function octree.GetAllNodes(self)
    local values_2 = {}
    local number = 0
    for _, item in next, self.RegionHashMap do
        for index, item_2 in ipairs(item) do
            for key in next, item_2.Nodes do
                number += 1
                values_2[number] = key
            end
        end
    end
    return values_2
end

function octree.CreateNode(self, argument, argument_2)
    if typeof(argument) ~= "Vector3" then
        error("Bad position value")
    end
    if not argument_2 then
        error("Bad object value.")
    end
    local result = new(self, argument_2)
    result:SetPosition(argument)
    return result
end

function octree.RadiusSearch(self, argument, argument_2)
    if typeof(argument) ~= "Vector3" then
        error("Bad position value")
    end
    if type(argument_2) ~= "number" then
        error("Bad radius value")
    end
    local x = argument.X
    local y = argument.Y
    local z = argument.Z
    local values_2 = {}
    local values_3 = {}
    local number = 0
    local number_2 = 0
    local argument_offset = argument_2 + 0.8660254037844386 * self.MaxRegionSize[1]
    for _, item in next, self.RegionHashMap do
        for index, item_2 in ipairs(item) do
            local position = item_2.Position
            local x_offset = x - position[1]
            local y_offset = y - position[2]
            local z_offset = z - position[3]
            if
                ((x_offset * x_offset) + (y_offset * y_offset)) + (z_offset * z_offset)
                <= (argument_offset * argument_offset) + 1e-09
            then
                local result, value = get_neighbors_within_radius(
                    item_2,
                    argument_2,
                    x,
                    y,
                    z,
                    values_2,
                    values_3,
                    self.MaxDepth,
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

function octree.KNearestNeighborsSearch(self, argument, argument_2, argument_3)
    if typeof(argument) ~= "Vector3" then
        error("Bad position value")
    end
    if type(argument_3) ~= "number" then
        error("Bad radius value")
    end
    local x = argument.X
    local y = argument.Y
    local z = argument.Z
    local values_2 = {}
    local values_3 = {}
    local number = 0
    local number_2 = 0
    local argument_offset = argument_3 + 0.8660254037844386 * self.MaxRegionSize[1]
    for _, item in next, self.RegionHashMap do
        for index_2, item_2 in ipairs(item) do
            local position = item_2.Position
            local x_offset = x - position[1]
            local y_offset = y - position[2]
            local z_offset = z - position[3]
            if
                ((x_offset * x_offset) + (y_offset * y_offset)) + (z_offset * z_offset)
                <= (argument_offset * argument_offset) + 1e-09
            then
                local result, value = get_neighbors_within_radius(
                    item_2,
                    argument_3,
                    x,
                    y,
                    z,
                    values_2,
                    values_3,
                    self.MaxDepth,
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
    local minimum = math.min(number_2, argument_2)
    local create_result_2 = table.create(minimum)
    local create_result_3 = table.create(minimum)
    for n = 1, minimum do
        local create_result_entry = create_result[n]
        create_result_3[n] = create_result_entry.Distance2
        create_result_2[n] = values_2[create_result_entry.Index]
    end
    return create_result_2, create_result_3
end

local function get_or_create_region(argument, argument_2, argument_3, argument_4)
    local region_hash_map = argument.RegionHashMap
    local max_region_size = argument.MaxRegionSize
    local max_region_size_entry = max_region_size[1]
    local max_region_size_entry_2 = max_region_size[2]
    local max_region_size_entry_3 = max_region_size[3]
    local rounded_value = math.floor((argument_2 / max_region_size_entry) + 0.5)
    local rounded_value_2 = math.floor((argument_3 / max_region_size_entry_2) + 0.5)
    local rounded_value_3 = math.floor((argument_4 / max_region_size_entry_3) + 0.5)
    local rounded_value_offset_offset_offset = (rounded_value * 73856093)
        + (rounded_value_2 * 19351301)
        + rounded_value_3 * 83492791
    local region_hash_map_entry = region_hash_map[rounded_value_offset_offset_offset]
    if not region_hash_map_entry then
        region_hash_map_entry = {}
        region_hash_map[rounded_value_offset_offset_offset] = region_hash_map_entry
    end
    local max_region_size_entry_offset = max_region_size_entry * rounded_value
    local max_region_size_entry_offset_2 = max_region_size_entry_2 * rounded_value_2
    local max_region_size_entry_offset_3 = max_region_size_entry_3 * rounded_value_3
    for _, item in ipairs(region_hash_map_entry) do
        local position = item.Position
        if
            position[1] ~= max_region_size_entry_offset
            or position[2] ~= max_region_size_entry_offset_2
            or position[3] ~= max_region_size_entry_offset_3
        then
            continue
        end
        return item
    end
    local max_region_size_entry_offset_4 = max_region_size_entry / 2
    local max_region_size_entry_offset_5 = max_region_size_entry_2 / 2
    local max_region_size_entry_offset_6 = max_region_size_entry_3 / 2
    local lower_bounds = {
        max_region_size_entry_offset - max_region_size_entry_offset_4,
        max_region_size_entry_offset_2 - max_region_size_entry_offset_5,
        max_region_size_entry_offset_3 - max_region_size_entry_offset_6,
    }
    local position_2 = { max_region_size_entry_offset, max_region_size_entry_offset_2, max_region_size_entry_offset_3 }
    local size = { max_region_size_entry, max_region_size_entry_2, max_region_size_entry_3 }
    local upper_bounds = {
        max_region_size_entry_offset + max_region_size_entry_offset_4,
        max_region_size_entry_offset_2 + max_region_size_entry_offset_5,
        max_region_size_entry_offset_3 + max_region_size_entry_offset_6,
    }
    local values_2 = { NodeCount = 0, Depth = 1 }
    values_2.LowerBounds = lower_bounds
    values_2.Nodes = {}
    values_2.Position = position_2
    values_2.Size = size
    values_2.SubRegions = {}
    values_2.UpperBounds = upper_bounds
    table.insert(region_hash_map_entry, values_2)
    return values_2
end

function octree.GetOrCreateLowestSubRegion(self, argument, argument_2, argument_3)
    local result = get_or_create_region(self, argument, argument_2, argument_3)
    local value = nil
    local parent = result
    for _ = result.Depth, self.MaxDepth do
        local position = parent.Position
        local parent_index = ((position[1] < argument) and 1) or 2
        parent_index = ((argument_2 <= position[2]) and (parent_index + 4)) or parent_index
        parent_index = ((position[3] <= argument_3) and (parent_index + 2)) or parent_index
        local sub_regions = parent.SubRegions
        value = sub_regions[parent_index]
        if not value then
            local size = parent.Size
            local value_entry = values[parent_index]
            local size_entry = parent.Size[1]
            local size_entry_2 = parent.Size[2]
            local size_entry_3 = parent.Size[3]
            local position_entry_offset = position[1] + values[parent_index][1] * parent.Size[1]
            local position_entry_offset_2 = position[2] + values[parent_index][2] * parent.Size[2]
            local position_entry_offset_3 = position[3] + values[parent_index][3] * parent.Size[3]
            local size_entry_offset = parent.Size[1] / 2
            local size_entry_offset_2 = parent.Size[2] / 2
            local size_entry_offset_3 = parent.Size[3] / 2
            local size_entry_offset_offset = parent.Size[1] / 2 / 2
            local size_entry_offset_offset_2 = parent.Size[2] / 2 / 2
            local size_entry_offset_offset_3 = parent.Size[3] / 2 / 2
            local lower_bounds = {
                position[1] + values[parent_index][1] * parent.Size[1] - parent.Size[1] / 2 / 2,
                position[2] + values[parent_index][2] * parent.Size[2] - parent.Size[2] / 2 / 2,
                position[3] + values[parent_index][3] * parent.Size[3] - parent.Size[3] / 2 / 2,
            }
            local position_2 = { position_entry_offset, position_entry_offset_2, position_entry_offset_3 }
            local size_2 = { size_entry_offset, size_entry_offset_2, size_entry_offset_3 }
            local upper_bounds = {
                position_entry_offset + size_entry_offset_offset,
                position_entry_offset_2 + size_entry_offset_offset_2,
                position_entry_offset_3 + size_entry_offset_offset_3,
            }
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
