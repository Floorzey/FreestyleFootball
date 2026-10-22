local number = 0
local values = {
    script.SunFlare,
    script.Bit0,
    script.Bit1,
    script.Bit2,
    script.Bit3,
    script.Bit4,
    script.Bit5,
}
local number_2 = 1
local number_3 = 0

game["Run Service"].RenderStepped:Connect(function(delta_time)
    local sum = workspace.CurrentCamera.CFrame.Position + game.Lighting:GetSunDirection() * 500
    local world_to_viewport_point_result, enabled = workspace.CurrentCamera:WorldToViewportPoint(sum)
    local vector_2 = Vector2.new(workspace.CurrentCamera.ViewportSize.x / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
        - Vector2.new(world_to_viewport_point_result.x, world_to_viewport_point_result.y)
    local product = vector_2.Magnitude * 3
    local unit = vector_2.Unit
    local angle = math.atan2(-vector_2.y, vector_2.x)
    number_3 = math.deg(angle) + 180
    local quotient = product / #values

    for index = 1, #values do
        local difference = index - 1
        local viewport_point_to_ray_result = workspace.CurrentCamera:ViewportPointToRay(
            world_to_viewport_point_result.x + unit.x * difference * quotient,
            world_to_viewport_point_result.y + unit.y * difference * quotient,
            1
        )
        values[index].Position = viewport_point_to_ray_result.Origin + viewport_point_to_ray_result.Direction.Unit * 10
        local _ = index
    end

    local vector = Vector2.new(
        world_to_viewport_point_result.X / game.Workspace.CurrentCamera.ViewportSize.X,
        world_to_viewport_point_result.Y / game.Workspace.CurrentCamera.ViewportSize.Y
    )
    number_2 = 1

    if enabled == false then
        number_2 = 0
    end

    if number_2 > 0 then
        if vector.X < 0.1 then
            local clamped_value = math.clamp(1 - (0.1 - vector.X) / 0.1, 0, 1)
            number_2 = math.min(number_2, clamped_value)
        end

        if vector.X > 0.9 then
            local clamped_value_2 = math.clamp(1 - (vector.X - 0.9) / 0.1, 0, 1)
            number_2 = math.min(number_2, clamped_value_2)
        end

        if vector.Y < 0.1 then
            local clamped_value_3 = math.clamp(1 - (0.1 - vector.Y) / 0.1, 0, 1)
            number_2 = math.min(number_2, clamped_value_3)
        end

        if vector.Y > 0.9 then
            local clamped_value_4 = math.clamp(1 - (vector.Y - 0.9) / 0.1, 0, 1)
            number_2 = math.min(number_2, clamped_value_4)
        end
    end

    if not (number_2 > 0) then
        return
    end

    local raycast_params = RaycastParams.new()
    raycast_params.RespectCanCollide = false

    if
        game.Workspace:Raycast(
            game.Workspace.CurrentCamera.CFrame.Position,
            (sum - game.Workspace.CurrentCamera.CFrame.Position).Unit * 500,
            raycast_params
        )
    then
        number = number - delta_time * 10
    else
        number = number + delta_time * 10
    end

    number = math.clamp(number, 0, 1)
    number_2 = math.min(number, number_2)
end)

game["Run Service"]:BindToRenderStep("PreCamera", 5000, function()
    if not game.Players.LocalPlayer:FindFirstChild("Settings") then
        return
    end

    if not game.Players.LocalPlayer.Settings.Misc.SunFlare.Value then
        return
    end

    for _, item in values do
        item.Parent = game.Workspace

        for _, descendant in item:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant.Brightness = number_2 * 0.15
                descendant.Rotation = NumberRange.new(number_3)
                local world_to_viewport_point_result, _ =
                    workspace.CurrentCamera:WorldToViewportPoint(descendant.Parent.WorldPosition)
                descendant.ZOffset = world_to_viewport_point_result.Z - 1
                descendant.Enabled = false
                descendant:Clear()
                descendant:Emit(1)
            end
        end
    end
end)
