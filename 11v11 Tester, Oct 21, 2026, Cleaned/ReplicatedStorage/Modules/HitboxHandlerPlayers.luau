return {
    Create = function(argument, argument_2)
        game.Players:GetPlayerFromCharacter(argument_2)
        local size = argument.size
        local cframe = argument.cframe
        local enabled = argument.isSphere or false
        local overlap_params = OverlapParams.new()
        overlap_params.FilterType = Enum.RaycastFilterType.Include
        overlap_params.FilterDescendantsInstances = { game.Workspace.CharacterContainer }
        local part_bounds_in_radius

        if enabled == true then
            part_bounds_in_radius = workspace:GetPartBoundsInRadius(cframe.Position, size.X / 2, overlap_params)
        else
            part_bounds_in_radius = workspace:GetPartBoundsInBox(cframe, size, overlap_params)
        end

        local items = {}

        for _, item in pairs(part_bounds_in_radius) do
            if item.Name == "HumanoidRootPart" and item.Parent ~= argument_2 then
                table.insert(items, item)
            end
        end

        return items
    end,
}
