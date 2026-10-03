--[[
    Script Path: Game/Players/Player/PlayerScripts/clientMapHandler
    Class: LocalScript
    Time: 2026-10-03 12:27:02
--]]

local Misc_upv_1 = game.Players.LocalPlayer:WaitForChild("Settings"):WaitForChild("Misc")
function handleMap(a1)
    --[[
      name: handleMap
      line: 5
      upvalues:
        Misc_upv_1 (copy, index: 1)
    ]]
    local u1 = game.ReplicatedStorage.SelectableMaps:FindFirstChild(Misc_upv_1.MapSelection.Value)
    if not u1 then
        return
    end
    task.spawn(
        function()
            --[[
              line: 8
              upvalues:
                u1 (copy, index: 1)
                Misc_upv_1 (copy, index: 2)
            ]]
            game.ReplicatedStorage.Shutter:Fire()
            task.wait(0.55)
            for _, value_1 in pairs(game.Workspace.gameArea.SelectedMap:GetChildren()) do
                value_1:Destroy()
            end
            for _, value_2 in pairs(u1:GetChildren()) do
                if value_2:IsA("Model") or value_2:IsA("BasePart") then
                    value_2:Clone().Parent = game.Workspace.gameArea.SelectedMap
                end
            end
            if Misc_upv_1.MapSelection.Value ~= "Blue Lock Chamber" or Misc_upv_1.Night.Value ~= true then
                return
            end
            game.Lighting.Ambient = Color3.new(0.882353, 0.882353, 0.882353)
            game.Lighting.OutdoorAmbient = Color3.new(0.882353, 0.882353, 0.882353)
        end
    )
end
function handleGrass(a1)
    --[[
      name: handleGrass
      line: 28
      upvalues:
        Misc_upv_1 (copy, index: 1)
    ]]
    local u2 = game.ReplicatedStorage.SelectableGrass:FindFirstChild(Misc_upv_1.GrassSelection.Value)
    if not u2 then
        return
    end
    task.spawn(
        function()
            --[[
              line: 32
              upvalues:
                u2 (copy, index: 1)
            ]]
            game.ReplicatedStorage.Shutter:Fire()
            task.wait(0.55)
            for _, value_3 in pairs(game.Workspace.gameArea.Grass:GetChildren()) do
                value_3:Destroy()
            end
            for _, value_4 in pairs(u2:GetChildren()) do
                if value_4:IsA("Model") or value_4:IsA("BasePart") then
                    value_4:Clone().Parent = game.Workspace.gameArea.Grass
                end
            end
        end
    )
end
Misc_upv_1.MapSelection.Changed:Connect(handleMap)
Misc_upv_1.GrassSelection.Changed:Connect(handleGrass)
task.delay(
    1,
    function()
        --[[
          line: 51
        ]]
        handleMap(true)
        handleGrass(true)
    end
)