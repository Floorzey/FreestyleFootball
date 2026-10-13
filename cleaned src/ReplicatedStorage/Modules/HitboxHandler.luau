local hitbox_handler = {}
hitbox_handler.Create = function(argument, argument_2)
    local _ = game.Players:GetPlayerFromCharacter(argument_2)
    local size = argument.size
    local cframe = argument.cframe
    local overlap_params = OverlapParams.new()
    overlap_params.FilterType = Enum.RaycastFilterType.Include
    overlap_params.FilterDescendantsInstances = { game.Workspace.Temp }
    local part_bounds_in_box
    if (argument.isSphere or false) ~= true then
        part_bounds_in_box = workspace:GetPartBoundsInBox(cframe, size, overlap_params)
    else
        part_bounds_in_box = workspace:GetPartBoundsInRadius(cframe.Position, size.X / 2, overlap_params)
    end
    for key, instance in pairs(part_bounds_in_box) do
        if instance.Name ~= "Ball" or instance:FindFirstChild("Scored") then
            continue
        end
        return instance
    end
    return nil
end

return hitbox_handler
