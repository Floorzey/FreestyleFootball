local _ = game:GetService("RunService")

task.spawn(function()
    for _, value in pairs(game.Players:GetPlayers()) do
        if value ~= game.Players.LocalPlayer then
            local character_2 = value.Character or value.CharacterAdded:Wait()
            character_2:WaitForChild("HumanoidRootPart").Anchored = true
            local connection = character_2.HumanoidRootPart:GetPropertyChangedSignal("Anchored"):Connect(function()
                if character_2.HumanoidRootPart.Anchored ~= false then
                    return
                end

                character_2.HumanoidRootPart.Anchored = true
            end)
            local connection_3 = nil
            local connection_2 = value.AncestryChanged:Connect(function()
                if value:IsDescendantOf(game) then
                    return
                end

                connection:Disconnect()
                connection_3:Disconnect()
            end)
            connection_3 = connection_2
        end
    end
end)

game.Players.PlayerAdded:Connect(function(player)
    local character_2 = player.Character or player.CharacterAdded:Wait()
    character_2:WaitForChild("HumanoidRootPart").Anchored = true
    local connection = character_2.HumanoidRootPart:GetPropertyChangedSignal("Anchored"):Connect(function()
        if character_2.HumanoidRootPart.Anchored ~= false then
            return
        end

        character_2.HumanoidRootPart.Anchored = true
        character_2.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
    end)
    local connection_3 = nil
    local connection_2 = player.AncestryChanged:Connect(function()
        if player:IsDescendantOf(game) then
            return
        end

        connection:Disconnect()
        connection_3:Disconnect()
    end)
    connection_3 = connection_2
end)

local local_player = game.Players.LocalPlayer
local character = local_player.Character or local_player.CharacterAdded:Wait()
character:WaitForChild("HumanoidRootPart")

task.spawn(function()
    repeat
        task.wait(0.03)
    until character:FindFirstChild("HumanoidRootPart")

    task.spawn(function()
        local _, value_2 = pcall(function()
            game.ReplicatedStorage.Remotes.charReplicate:FireServer(character.HumanoidRootPart.CFrame)
        end)

        if value_2 then
            warn(value_2)
        end

        for child_name, value in pairs(game.ReplicatedStorage.Remotes.getCharReplicationPositions:InvokeServer()) do
            local character_2 = game.Workspace.CharacterContainer:FindFirstChild(child_name)
            local pcall_result, value_3 = pcall(function()
                if not character_2 then
                    return
                end

                if not (character_2:FindFirstChild("HumanoidRootPart")) then
                    return
                end

                local tween_properties = {}
                tween_properties.CFrame = value
                game:GetService("TweenService")
                    :Create(
                        character_2.HumanoidRootPart,
                        TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                        tween_properties
                    )
                    :Play()
            end)

            if value_3 then
                warn(value_3)
            end
        end
    end)
end)
