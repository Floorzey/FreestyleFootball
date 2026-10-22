local octree_node = { ClassName = "OctreeNode" }
octree_node.__index = octree_node

function octree_node.new(octree, object)
    local values = { Octree = 0, Object = 0 }
    values.Octree = octree or error("No octree")
    values.Object = object or error("No object")

    return (setmetatable(values, octree_node))
end

function octree_node.KNearestNeighborsSearch(argument, argument_2, argument_3)
    return argument.Octree:KNearestNeighborsSearch(argument.Position, argument_2, argument_3)
end

function octree_node.GetObject(argument)
    warn("OctreeNode:GetObject is deprecated.")

    return argument.Object
end

function octree_node.RadiusSearch(argument, argument_2)
    return argument.Octree:RadiusSearch(argument.Position, argument_2)
end

function octree_node.GetPosition(argument)
    warn("OctreeNode:GetPosition is deprecated.")

    return argument.Position
end

function octree_node.GetRawPosition(argument)
    return argument.PositionX, argument.PositionY, argument.PositionZ
end

function octree_node.SetPosition(argument, position)
    if argument.Position == position then
        return
    end

    local x = position.X
    local y = position.Y
    local z = position.Z
    argument.PositionX = x
    argument.PositionY = y
    argument.PositionZ = z
    argument.Position = position
    local value, value_2 = nil, nil

    if argument.CurrentLowestRegion then
        local current_lowest_region = argument.CurrentLowestRegion
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

    local current_lowest_region_2 = argument.Octree:GetOrCreateLowestSubRegion(x, y, z)

    if argument.CurrentLowestRegion then
        z = argument.CurrentLowestRegion

        if z.Depth ~= current_lowest_region_2.Depth then
            error("fromLowest.Depth ~= toLowest.Depth")
        end

        if z == current_lowest_region_2 then
            error("fromLowest == toLowest")
        end

        y, z = z, current_lowest_region_2

        while y ~= z do
            local nodes = y.Nodes

            if not nodes[argument] then
                error("CurrentFrom.Nodes doesn't have a node here.")
            end

            local node_count = y.NodeCount

            if node_count <= 0 then
                error("NodeCount is <= 0.")
            end

            node_count -= 1
            nodes[argument] = nil
            y.NodeCount = node_count
            local parent_index = y.ParentIndex

            if node_count <= 0 and parent_index then
                local parent = y.Parent

                if not parent then
                    error("CurrentFrom.Parent doesn't exist.")
                end

                local sub_regions = parent.SubRegions

                if sub_regions[parent_index] ~= y then
                    error("Failed equality check.")
                end

                sub_regions[parent_index] = nil
            end

            local nodes_2 = z.Nodes

            if nodes_2[argument] then
                error("CurrentTo.Nodes already has a node here.")
            end

            nodes_2[argument] = argument
            z.NodeCount = z.NodeCount + 1
            y, z = y.Parent, z.Parent
        end
    else
        value = current_lowest_region_2

        while value do
            local nodes_3 = value.Nodes

            if not nodes_3[argument] then
                nodes_3[argument] = argument
                value.NodeCount = value.NodeCount + 1
            end

            value = value.Parent
        end
    end

    argument.CurrentLowestRegion = current_lowest_region_2
end

function octree_node.Destroy(argument)
    local current_lowest_region = argument.CurrentLowestRegion

    if not current_lowest_region then
        return
    end

    local current_lowest_region_2 = current_lowest_region

    while current_lowest_region_2 do
        local nodes = current_lowest_region_2.Nodes

        if not nodes[argument] then
            error("CurrentFrom.Nodes doesn't have a node here.")
        end

        local node_count = current_lowest_region_2.NodeCount

        if node_count <= 0 then
            error("NodeCount is <= 0.")
        end

        node_count -= 1
        nodes[argument] = nil
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

return octree_node
