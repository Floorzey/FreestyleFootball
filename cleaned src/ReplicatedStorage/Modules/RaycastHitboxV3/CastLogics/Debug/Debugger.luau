local debris = game:GetService("Debris")

return function(vector, argument)
    local part = Instance.new("Part")
    part.BrickColor = BrickColor.new("Bright red")
    part.Material = Enum.Material.Neon
    part.Anchored = true
    part.CanCollide = false
    part.Name = "RaycastHitboxDebugPart"
    local magnitude = vector.Magnitude
    part.Size = Vector3.new(0.1, 0.1, magnitude)
    part.CFrame = argument * CFrame.new(0, 0, -magnitude / 2)
    part.Parent = workspace.Terrain
    debris:AddItem(part, 1)
end
