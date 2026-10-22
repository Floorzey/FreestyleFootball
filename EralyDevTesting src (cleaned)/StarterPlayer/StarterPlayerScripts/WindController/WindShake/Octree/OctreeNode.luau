local octree_node = {
    ClassName = "OctreeNode",
}
octree_node.__index = octree_node

function octree_node.new(octree, object)
    local properties = {
        CurrentLowestRegion = nil,
        Position = nil,
        PositionX = nil,
        PositionY = nil,
        PositionZ = nil,
        Octree = octree or error("No octree"),
        Object = object or error("No object"),
    }

    return setmetatable(properties, octree_node)
end

function octree_node.KNearestNeighborsSearch(argument: table, argument_2: number, argument_3: number)
    return argument.Octree:KNearestNeighborsSearch(argument.Position, argument_2, argument_3)
end

function octree_node.GetObject(argument)
    warn("OctreeNode:GetObject is deprecated.")

    return argument.Object
end

function octree_node.RadiusSearch(argument: table, argument_2: number)
    return argument.Octree:RadiusSearch(argument.Position, argument_2)
end

function octree_node.GetPosition(argument)
    warn("OctreeNode:GetPosition is deprecated.")

    return argument.Position
end

function octree_node.GetRawPosition(argument)
    return argument.PositionX, argument.PositionY, argument.PositionZ
end

function octree_node.SetPosition(argument: table, position: vector)
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

    if argument.CurrentLowestRegion then
        local current_lowest_region = argument.CurrentLowestRegion
        local lower_bounds = current_lowest_region.LowerBounds
        local upper_bounds = current_lowest_region.UpperBounds

        if
            lower_bounds[1] <= x
            and (
                x <= upper_bounds[1]
                and (
                    lower_bounds[2] <= y and (y <= upper_bounds[2] and (lower_bounds[3] <= z and z <= upper_bounds[3]))
                )
            )
        then
            return
        end
    end

    local or_create_lowest_sub_region = argument.Octree:GetOrCreateLowestSubRegion(x, y, z)
    local current_lowest_region_3

    if argument.CurrentLowestRegion then
        local current_lowest_region_2 = argument.CurrentLowestRegion

        if current_lowest_region_2.Depth ~= or_create_lowest_sub_region.Depth then
            error("fromLowest.Depth ~= toLowest.Depth")
        end

        if current_lowest_region_2 == or_create_lowest_sub_region then
            error("fromLowest == toLowest")
            current_lowest_region_3 = or_create_lowest_sub_region
        else
            current_lowest_region_3 = or_create_lowest_sub_region
        end

        while current_lowest_region_2 ~= or_create_lowest_sub_region do
            local nodes = current_lowest_region_2.Nodes

            if not nodes[argument] then
                error("CurrentFrom.Nodes doesn't have a node here.")
            end

            local node_count = current_lowest_region_2.NodeCount

            if node_count <= 0 then
                error("NodeCount is <= 0.")
            end

            local node_count_2 = node_count - 1
            nodes[argument] = nil
            current_lowest_region_2.NodeCount = node_count_2
            local parent_index = current_lowest_region_2.ParentIndex

            if node_count_2 <= 0 and parent_index then
                local parent = current_lowest_region_2.Parent

                if not parent then
                    error("CurrentFrom.Parent doesn't exist.")
                end

                local sub_regions = parent.SubRegions

                if sub_regions[parent_index] ~= current_lowest_region_2 then
                    error("Failed equality check.")
                end

                sub_regions[parent_index] = nil
            end

            local nodes2 = or_create_lowest_sub_region.Nodes

            if nodes2[argument] then
                error("CurrentTo.Nodes already has a node here.")
            end

            nodes2[argument] = argument
            or_create_lowest_sub_region.NodeCount = or_create_lowest_sub_region.NodeCount + 1
            current_lowest_region_2 = current_lowest_region_2.Parent
            or_create_lowest_sub_region = or_create_lowest_sub_region.Parent
        end
    else
        current_lowest_region_3 = or_create_lowest_sub_region

        while or_create_lowest_sub_region do
            local nodes_2 = or_create_lowest_sub_region.Nodes

            if not nodes_2[argument] then
                nodes_2[argument] = argument
                or_create_lowest_sub_region.NodeCount = or_create_lowest_sub_region.NodeCount + 1
            end

            or_create_lowest_sub_region = or_create_lowest_sub_region.Parent
        end
    end

    argument.CurrentLowestRegion = current_lowest_region_3
end

function octree_node.Destroy(argument)
    local current_lowest_region = argument.CurrentLowestRegion

    if not current_lowest_region then
        return
    end

    while current_lowest_region do
        local nodes = current_lowest_region.Nodes

        if not nodes[argument] then
            error("CurrentFrom.Nodes doesn't have a node here.")
        end

        local node_count = current_lowest_region.NodeCount

        if node_count <= 0 then
            error("NodeCount is <= 0.")
        end

        local node_count_2 = node_count - 1
        nodes[argument] = nil
        current_lowest_region.NodeCount = node_count_2
        local parent = current_lowest_region.Parent
        local parent_index = current_lowest_region.ParentIndex

        if node_count_2 <= 0 and parent_index then
            if not parent then
                error("Current.Parent doesn't exist.")
            end

            local sub_regions = parent.SubRegions

            if sub_regions[parent_index] ~= current_lowest_region then
                error("Failed equality check.")
            end

            sub_regions[parent_index] = nil
            current_lowest_region = parent
        else
            current_lowest_region = parent
        end
    end
end

return octree_node
