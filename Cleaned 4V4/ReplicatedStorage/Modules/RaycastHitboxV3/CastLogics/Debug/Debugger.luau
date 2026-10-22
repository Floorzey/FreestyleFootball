local debris = game:GetService("Debris")

return function(vector, argument)
    local raycast_hitbox_debug_part = Instance.new("Part")
    raycast_hitbox_debug_part.BrickColor = BrickColor.new("Bright red")
    raycast_hitbox_debug_part.Material = Enum.Material.Neon
    raycast_hitbox_debug_part.Anchored = true
    raycast_hitbox_debug_part.CanCollide = false
    raycast_hitbox_debug_part.Name = "RaycastHitboxDebugPart"
    local magnitude = vector.Magnitude
    raycast_hitbox_debug_part.Size = Vector3.new(0.1, 0.1, magnitude)
    raycast_hitbox_debug_part.CFrame = argument * CFrame.new(0, 0, -magnitude / 2)
    raycast_hitbox_debug_part.Parent = workspace.Terrain
    debris:AddItem(raycast_hitbox_debug_part, 1)
end
