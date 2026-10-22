local misc = game.Players.LocalPlayer:WaitForChild("Settings"):WaitForChild("Misc")

function handleMap(argument)
    local first_child = game.ReplicatedStorage.SelectableMaps:FindFirstChild(misc.MapSelection.Value)

    if not first_child then
        return
    end

    task.spawn(function()
        game.ReplicatedStorage.Shutter:Fire()
        task.wait(0.55)

        for _, child in pairs(game.Workspace.gameArea.SelectedMap:GetChildren()) do
            child:Destroy()
        end

        for _, child_2 in pairs(first_child:GetChildren()) do
            if child_2:IsA("Model") or child_2:IsA("BasePart") then
                child_2:Clone().Parent = game.Workspace.gameArea.SelectedMap
            end
        end

        if misc.MapSelection.Value == "Blue Lock Chamber" and misc.Night.Value == true then
            game.Lighting.Ambient = Color3.new(0.882353, 0.882353, 0.882353)
            game.Lighting.OutdoorAmbient = Color3.new(0.882353, 0.882353, 0.882353)
        end
    end)
end

function handleGrass(argument)
    local first_child = game.ReplicatedStorage.SelectableGrass:FindFirstChild(misc.GrassSelection.Value)

    if not first_child then
        return
    end

    task.spawn(function()
        game.ReplicatedStorage.Shutter:Fire()
        task.wait(0.55)

        for _, child in pairs(game.Workspace.gameArea.Grass:GetChildren()) do
            child:Destroy()
        end

        for _, child_2 in pairs(first_child:GetChildren()) do
            if child_2:IsA("Model") or child_2:IsA("BasePart") then
                child_2:Clone().Parent = game.Workspace.gameArea.Grass
            end
        end
    end)
end

misc.MapSelection.Changed:Connect(handleMap)
misc.GrassSelection.Changed:Connect(handleGrass)

task.delay(1, function()
    handleMap(true)
    handleGrass(true)
end)
