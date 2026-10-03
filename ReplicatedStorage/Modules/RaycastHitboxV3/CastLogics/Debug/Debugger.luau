--[[
    Script Path: Game/ReplicatedStorage/Modules/RaycastHitboxV3/CastLogics/Debug/Debugger
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local Debris_upv_1 = game:GetService("Debris")
return function(a1, a2)
    --[[
      line: 3
      upvalues:
        Debris_upv_1 (copy, index: 1)
    ]]
    local v1 = Instance.new("Part")
    v1.BrickColor = BrickColor.new("Bright red")
    v1.Material = Enum.Material.Neon
    v1.Anchored = true
    v1.CanCollide = false
    v1.Name = "RaycastHitboxDebugPart"
    local Magnitude_1 = a1.Magnitude
    v1.Size = Vector3.new(0.1, 0.1, Magnitude_1)
    v1.CFrame = a2 * CFrame.new(0, 0, -Magnitude_1 / 2)
    v1.Parent = workspace.Terrain
    Debris_upv_1:AddItem(v1, 1)
end