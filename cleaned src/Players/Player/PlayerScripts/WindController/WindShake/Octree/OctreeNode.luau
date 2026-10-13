local octree_node = { ClassName = "OctreeNode" }
octree_node.__index = octree_node

function octree_node.new(octree, object)
    local values = { Octree = 0, Object = 0 }
    values.Octree = octree or error("No octree")
    values.Object = object or error("No object")
    return (setmetatable(values, octree_node))
end

function octree_node.KNearestNeighborsSearch(self, argument, argument_2)
    return self.Octree:KNearestNeighborsSearch(self.Position, argument, argument_2)
end

function octree_node.GetObject(self)
    warn("OctreeNode:GetObject is deprecated.")
    return self.Object
end

function octree_node.RadiusSearch(self, argument)
    return self.Octree:RadiusSearch(self.Position, argument)
end

function octree_node.GetPosition(self)
    warn("OctreeNode:GetPosition is deprecated.")
    return self.Position
end

function octree_node.GetRawPosition(self)
    return self.PositionX, self.PositionY, self.PositionZ
end

function octree_node.SetPosition(self, position)
    if self.Position == position then
        return
    end
    local x = position.X
    local y = position.Y
    local z = position.Z
    self.PositionX = x
    self.PositionY = y
    self.PositionZ = z
    self.Position = position
    local value, value_2 = nil, nil
    if self.CurrentLowestRegion then
        local current_lowest_region = self.CurrentLowestRegion
        value = current_lowest_region.LowerBounds
        value_2 = current_lowest_region.UpperBounds
        if
            value[1] <= x
            and x <= value_2[1]
            and value[2] <= y
            and y <= value_2[2]
            and value[3] <= z
            and z <= value_2[3]
        then
            return
        end
    end
    local current_lowest_region_2 = self.Octree:GetOrCreateLowestSubRegion(x, y, z)
    local value_3 = nil
    if self.CurrentLowestRegion then
        value_3 = self.CurrentLowestRegion
        if value_3.Depth ~= current_lowest_region_2.Depth then
            error("fromLowest.Depth ~= toLowest.Depth")
        end
        if value_3 == current_lowest_region_2 then
            error("fromLowest == toLowest")
        end
        local current_lowest_region_3
        value_2, current_lowest_region_3 = value_3, current_lowest_region_2
        while value_2 ~= current_lowest_region_3 do
            local nodes = value_2.Nodes
            if not nodes[self] then
                error("CurrentFrom.Nodes doesn't have a node here.")
            end
            local node_count = value_2.NodeCount
            if node_count <= 0 then
                error("NodeCount is <= 0.")
            end
            node_count -= 1
            nodes[self] = nil
            value_2.NodeCount = node_count
            local parent_index = value_2.ParentIndex
            if node_count <= 0 and parent_index then
                local parent = value_2.Parent
                if not parent then
                    error("CurrentFrom.Parent doesn't exist.")
                end
                local sub_regions = parent.SubRegions
                if sub_regions[parent_index] ~= value_2 then
                    error("Failed equality check.")
                end
                sub_regions[parent_index] = nil
            end
            local nodes_2 = current_lowest_region_3.Nodes
            if nodes_2[self] then
                error("CurrentTo.Nodes already has a node here.")
            end
            nodes_2[self] = self
            current_lowest_region_3.NodeCount = current_lowest_region_3.NodeCount + 1
            value_2, current_lowest_region_3 = value_2.Parent, current_lowest_region_3.Parent
        end
    else
        value = current_lowest_region_2
        while value do
            local nodes_3 = value.Nodes
            if not nodes_3[self] then
                nodes_3[self] = self
                value.NodeCount = value.NodeCount + 1
            end
            value = value.Parent
        end
    end
    self.CurrentLowestRegion = current_lowest_region_2
end

function octree_node.Destroy(self)
    local current_lowest_region = self.CurrentLowestRegion
    if current_lowest_region then
        local current_lowest_region_2 = current_lowest_region
        while current_lowest_region_2 do
            local nodes = current_lowest_region_2.Nodes
            if not nodes[self] then
                error("CurrentFrom.Nodes doesn't have a node here.")
            end
            local node_count = current_lowest_region_2.NodeCount
            if node_count <= 0 then
                error("NodeCount is <= 0.")
            end
            node_count -= 1
            nodes[self] = nil
            current_lowest_region_2.NodeCount = node_count
            local parent = current_lowest_region_2.Parent
            local parent_index = current_lowest_region_2.ParentIndex
            if not (node_count <= 0) or not parent_index then
                current_lowest_region_2 = parent
                continue
            end
            if not parent then
                error("Current.Parent doesn't exist.")
            end
            local sub_regions = parent.SubRegions
            if sub_regions[parent_index] ~= current_lowest_region_2 then
                error("Failed equality check.")
            end
            sub_regions[parent_index] = nil
            current_lowest_region_2 = parent
        end
    end
end

return octree_node
