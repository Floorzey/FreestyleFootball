local hitbox_handler_players = {}
hitbox_handler_players.Create = function(argument, argument_2)
    local _ = game.Players:GetPlayerFromCharacter(argument_2)
    local size = argument.size
    local cframe = argument.cframe
    local overlap_params = OverlapParams.new()
    overlap_params.FilterType = Enum.RaycastFilterType.Include
    overlap_params.FilterDescendantsInstances = { game.Workspace.CharacterContainer }
    local part_bounds_in_box

    if (argument.isSphere or false) ~= true then
        part_bounds_in_box = workspace:GetPartBoundsInBox(cframe, size, overlap_params)
    else
        part_bounds_in_box = workspace:GetPartBoundsInRadius(cframe.Position, size.X / 2, overlap_params)
    end

    local items = {}

    for key, item in pairs(part_bounds_in_box) do
        if item.Name ~= "HumanoidRootPart" then
            continue
        end

        if item.Parent ~= argument_2 then
            table.insert(items, item)
        end
    end

    return items
end

return hitbox_handler_players
