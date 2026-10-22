return {
    Create = function(argument, argument_2)
        game.Players:GetPlayerFromCharacter(argument_2)
        local size = argument.size
        local cframe = argument.cframe
        local enabled = argument.isSphere or false
        local sweep = argument.sweep
        local from_position = argument.from_position
        local ball = game.Workspace.Temp:FindFirstChild("Ball")

        if ball and (from_position or sweep) and not enabled then
            local vector = from_position and ball.Position - from_position
                or ball.AssemblyLinearVelocity * math.clamp(sweep, 0, 0.05)

            if vector.Magnitude > 8 then
                vector = vector.Unit * 8
            end

            local relative_vector = cframe:VectorToObjectSpace(vector)
            cframe += vector / 2
            local absolute_value = math.abs(relative_vector.X)
            local absolute_value_2 = math.abs(relative_vector.Y)
            local absolute_value_3 = math.abs(relative_vector.Z)
            size += Vector3.new(absolute_value, absolute_value_2, absolute_value_3)
        end

        local overlap_params = OverlapParams.new()
        overlap_params.FilterType = Enum.RaycastFilterType.Include
        overlap_params.FilterDescendantsInstances = { game.Workspace.Temp }
        local part_bounds_in_radius

        if enabled == true then
            part_bounds_in_radius = workspace:GetPartBoundsInRadius(cframe.Position, size.X / 2, overlap_params)
        else
            part_bounds_in_radius = workspace:GetPartBoundsInBox(cframe, size, overlap_params)
        end

        for _, instance in pairs(part_bounds_in_radius) do
            if instance.Name == "Ball" and not instance:FindFirstChild("Scored") then
                return instance
            end
        end

        return nil
    end,
}
