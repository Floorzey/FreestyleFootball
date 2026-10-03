--[[
    Script Path: Game/Players/Player/PlayerScripts/GlobalClients/miscfx/LiquidModule
    Class: ModuleScript
    Time: 2026-10-03 12:27:03
--]]

local tbl_1 = {}
function handleWater(a1)
    --[[
      name: handleWater
      line: 3
    ]]
    local u1 = require(game.ReplicatedStorage.Modules.RaycastHitboxV3):Initialize(a1, {workspace.gameArea.Field})
    u1:PartMode(true)
    u1.OnHit:Connect(
        function(a2, a3, a4)
            --[[
              line: 8
              upvalues:
                a1 (copy, index: 1)
            ]]
            if (a2:IsDescendantOf(game.Workspace.FX)) or (a2.Parent:FindFirstChildOfClass("Humanoid")) then
                return
            end
            if not (a2.Transparency > 0.5) or a2.Name == "CollisionBaseplate" then
                if a2.CanTouch ~= false and a2.CanCollide ~= false then
                    local Position_1 = a4.Position
                    if a2 then
                        local v1 = game.ReplicatedStorage.VFX.RainDrop:Clone()
                        v1.Parent = game.Workspace.FX
                        v1.Position = Position_1
                        v1.MIDDLE.BLOOD02:Emit(1)
                        v1.MIDDLE["WATER SPRAY"]:Emit(math.random(5, 10))
                        game.Debris:AddItem(v1, 4)
                        game.Debris:AddItem(a1, 0.05)
                    end
                    return
                end
                return
            end
        end
    )
    u1:HitStart()
    task.delay(
        5,
        function()
            --[[
              line: 24
              upvalues:
                u1 (copy, index: 1)
            ]]
            if u1 == nil or u1.HitStop == nil then
                return
            end
            u1:HitStop()
        end
    )
end
function tbl_1.newWater(a1, a2)
    --[[
      name: newWater
      line: 31
    ]]
    local v2 = game.ReplicatedStorage.WaterDrop:Clone()
    v2.Position = a1
    v2.Parent = workspace.FX
    v2.Anchored = true
    game.Debris:AddItem(v2, 15)
    local TweenService_1 = game:GetService("TweenService")
    local v3 = TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)
    local tbl_2 = {}
    tbl_2.Position = a1 + (a2.Unit * 90)
    TweenService_1:Create(v2, v3, tbl_2):Play()
    handleWater(v2)
    return v2
end
return tbl_1