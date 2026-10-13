local number = 0
local values = { script.SunFlare, script.Bit0, script.Bit1, script.Bit2, script.Bit3, script.Bit4, script.Bit5 }
local number_2 = 1
local number_3 = 0
game["Run Service"].RenderStepped:Connect(function(delta_time)
    local position_offset = workspace.CurrentCamera.CFrame.Position + game.Lighting:GetSunDirection() * 500
    local world_to_viewport_point_result, enabled = workspace.CurrentCamera:WorldToViewportPoint(position_offset)
    local vector_2 = Vector2.new(workspace.CurrentCamera.ViewportSize.x / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
        - Vector2.new(world_to_viewport_point_result.x, world_to_viewport_point_result.y)
    local unit = vector_2.Unit
    number_3 = math.deg(math.atan2(-vector_2.y, vector_2.x)) + 180
    local magnitude_offset_offset = vector_2.Magnitude * 3 / #values
    for n = 1, #values do
        local n_offset = n - 1
        local viewport_point_to_ray_result = workspace.CurrentCamera:ViewportPointToRay(
            world_to_viewport_point_result.x + ((unit.x * n_offset) * magnitude_offset_offset),
            world_to_viewport_point_result.y + ((unit.y * n_offset) * magnitude_offset_offset),
            1
        )
        values[n].Position = viewport_point_to_ray_result.Origin + (viewport_point_to_ray_result.Direction.Unit * 10)
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
            local clamped_value = math.clamp(1 - ((0.1 - vector.X) / 0.1), 0, 1)
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
    if number_2 > 0 then
        local raycast_params = RaycastParams.new()
        raycast_params.RespectCanCollide = false
        if
            game.Workspace:Raycast(
                game.Workspace.CurrentCamera.CFrame.Position,
                (position_offset - game.Workspace.CurrentCamera.CFrame.Position).Unit * 500,
                raycast_params
            )
        then
            number = number - (delta_time * 10)
        else
            number = number + (delta_time * 10)
        end
        number = math.clamp(number, 0, 1)
        number_2 = math.min(number, number_2)
    end
end)
game["Run Service"]:BindToRenderStep("PreCamera", 5000, function()
    if
        not game.Players.LocalPlayer:FindFirstChild("Settings")
        or not game.Players.LocalPlayer.Settings.Misc.SunFlare.Value
    then
        return
    end
    for _, item in values do
        item.Parent = game.Workspace
        for key, item_2 in item:GetDescendants() do
            if item_2:IsA("ParticleEmitter") then
                item_2.Brightness = number_2 * 0.15
                item_2.Rotation = NumberRange.new(number_3)
                item_2.ZOffset = workspace.CurrentCamera:WorldToViewportPoint(item_2.Parent.WorldPosition).Z - 1
                item_2.Enabled = false
                item_2:Clear()
                item_2:Emit(1)
            end
        end
    end
end)
