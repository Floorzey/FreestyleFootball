local ball_status = game.Workspace.ballStatus
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key_handler_service = knit.GetService("KeyHandlerService")
key_handler_service:GetKey("SharpEyesClient").OnClientEvent:Connect(function()
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.TintColor = Color3.fromRGB(243, 171, 172)
    tween_service:Create(game.Lighting.ColorCorrection, tween_info, tween_properties):Play()
    local ball = game.Workspace.Temp:FindFirstChild("Ball") or (game.Workspace.Temp:WaitForChild("Ball"))
    if ball then
        local highlight = Instance.new("Highlight")
        highlight.Parent = ball
        highlight.Name = "SharpEyeHighlight"
        highlight.FillColor = Color3.new(0.839216, 0, 0)
        highlight.OutlineTransparency = 1
        highlight.FillTransparency = 1
        local tween_properties_2 = { FillTransparency = 0 }
        game:GetService("TweenService")
            :Create(highlight, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_2)
            :Play()
        local connection_3 = game:GetService("RunService").RenderStepped:Connect(function()
            if not game.Workspace.Temp:FindFirstChild("Ball") then
                return
            end
            if not (game.Workspace.Temp.Ball:FindFirstChild("SharpEyeHighlight")) then
                local highlight_2 = Instance.new("Highlight")
                highlight_2.Parent = ball
                highlight_2.Name = "SharpEyeHighlight"
                highlight_2.FillColor = Color3.new(0.839216, 0, 0)
                highlight_2.OutlineTransparency = 1
                highlight_2.FillTransparency = 1
                local tween_properties_3 = { FillTransparency = 0 }
                game:GetService("TweenService")
                    :Create(
                        highlight_2,
                        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        tween_properties_3
                    )
                    :Play()
            end
        end)
        local connection_5 = connection_3
        local connection_4 = ball_status.lastKicked.Changed:Connect(function()
            if ball_status.lastKicked.Value == nil then
                return
            end
            for _, child in pairs(game.Workspace.CharacterContainer:GetChildren()) do
                for key, child_2 in pairs(child:GetChildren()) do
                    if child_2.Name == "SharpEyeHighlight" then
                        child_2:Destroy()
                    end
                end
            end
            local color3 = Color3.new(0.839216, 0.486275, 0.486275)
            if ball_status.lastKicked.Value.SelectedTeam.Value == game.Players.LocalPlayer.SelectedTeam.Value then
                color3 = Color3.new(0, 1, 0)
            end
            local highlight_2 = Instance.new("Highlight")
            highlight_2.Parent = ball_status.lastKicked.Value.Character
            highlight_2.Name = "SharpEyeHighlight"
            highlight_2.FillColor = color3
            highlight_2.OutlineTransparency = 1
            highlight_2.FillTransparency = 1
            local tween_properties_3 = { FillTransparency = 0 }
            game:GetService("TweenService")
                :Create(
                    highlight_2,
                    TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties_3
                )
                :Play()
        end)
        local connection_6 = connection_4
        task.delay(10, function()
            connection_5:Disconnect()
            connection_6:Disconnect()
            if game.Workspace.Temp:FindFirstChild("Ball") then
                for _, child in pairs(game.Workspace.Temp.Ball:GetChildren()) do
                    if not (child:IsA("Highlight")) then
                        continue
                    end
                    if child.Name == "SharpEyeHighlight" then
                        local tween_properties_3 = { FillTransparency = 1 }
                        game:GetService("TweenService")
                            :Create(
                                child,
                                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                tween_properties_3
                            )
                            :Play()
                        game.Debris:AddItem(child, 2)
                    end
                end
            end
            for _, child_2 in pairs(game.Workspace.CharacterContainer:GetChildren()) do
                for key, child_3 in pairs(child_2:GetChildren()) do
                    if child_3.Name == "SharpEyeHighlight" then
                        child_3:Destroy()
                    end
                end
            end
            local tween_service_2 = game:GetService("TweenService")
            local tween_info_2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_4 = {}
            tween_properties_4.TintColor = Color3.new(1, 1, 1)
            tween_service_2:Create(game.Lighting.ColorCorrection, tween_info_2, tween_properties_4):Play()
        end)
    end
end)
key_handler_service:GetKey("ScoreSFXClient").OnClientEvent:Connect(function()
    if game.Players.LocalPlayer.Settings.Misc.CrowdNoise.Value == false then
        return
    end
    for _, child in pairs(game.Workspace.miscFX:GetChildren()) do
        if child.Name == "CameraFlash" then
            local child_entry = child["ScoreSFX" .. math.random(1, 3)]
            child_entry.Volume = 0
            child_entry:Play()
            local tween_properties = { Volume = 2 }
            game:GetService("TweenService")
                :Create(
                    child_entry,
                    TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties
                )
                :Play()
            task.delay(8, function()
                local tween_properties_2 = { Volume = 0 }
                game:GetService("TweenService")
                    :Create(
                        child_entry,
                        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        tween_properties_2
                    )
                    :Play()
                task.wait(0.5)
                child_entry:Stop()
                child_entry.Volume = child_entry:GetAttribute("Volume")
            end)
        end
    end
end)
key_handler_service:GetKey("GameEndSFXClient").OnClientEvent:Connect(function()
    if game.Players.LocalPlayer.Settings.Misc.CrowdNoise.Value == false then
        return
    end
    for _, child in pairs(game.Workspace.miscFX:GetChildren()) do
        if child.Name == "CameraFlash" then
            local child_entry = child["gameEndCrowd" .. math.random(1, 2)]
            child_entry.Volume = 0
            child_entry:Play()
            local tween_properties = { Volume = 2 }
            game:GetService("TweenService")
                :Create(
                    child_entry,
                    TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties
                )
                :Play()
            task.delay(24.2, function()
                local tween_properties_2 = { Volume = 0 }
                game:GetService("TweenService")
                    :Create(
                        child_entry,
                        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        tween_properties_2
                    )
                    :Play()
                task.wait(0.5)
                child_entry:Stop()
                child_entry.Volume = child_entry:GetAttribute("Volume")
            end)
        end
    end
end)
key_handler_service:GetKey("FailSFXClient").OnClientEvent:Connect(function(argument)
    if game.Players.LocalPlayer.Settings.Misc.CrowdNoise.Value == false then
        return
    end
    for _, child in pairs(game.Workspace.miscFX:GetChildren()) do
        if child.Name == "CameraFlash" then
            local child_entry = child["FailSFX" .. math.random(1, 3)]
            child_entry.Volume = 0
            child_entry:Play()
            local tween_properties = { Volume = 2 }
            game:GetService("TweenService")
                :Create(
                    child_entry,
                    TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties
                )
                :Play()
            task.delay(argument, function()
                local tween_properties_2 = { Volume = 0 }
                game:GetService("TweenService")
                    :Create(
                        child_entry,
                        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        tween_properties_2
                    )
                    :Play()
                task.wait(0.5)
                child_entry:Stop()
                child_entry.Volume = child_entry:GetAttribute("Volume")
            end)
        end
    end
end)
local local_player = game.Players.LocalPlayer
local_player:WaitForChild("dataLoaded")

local function get_most_or_least_z(argument, enabled)
    if enabled ~= true then
        local number_4 = 15.807
        local value = nil
        for _, player in ipairs(argument) do
            if not player.Character then
                continue
            end
            if player.Character.HumanoidRootPart.Position.Z < number_4 then
                number_4, value = player.Character.HumanoidRootPart.Position.Z, player
            end
        end
        return value
    else
        local number_5 = 15.807
        local value_2 = nil
        value_2 = value_2
        for _, player_2 in ipairs(argument) do
            if not player_2.Character then
                continue
            end
            if number_5 < player_2.Character.HumanoidRootPart.Position.Z then
                number_5, value_2 = player_2.Character.HumanoidRootPart.Position.Z, player_2
            end
        end
        return value_2
    end
end

ball_status.lastKicked.Changed:Connect(function()
    if ball_status.lastKicked.Value ~= local_player then
        local ball = game.Workspace.Temp:FindFirstChild("Ball")
        if ball then
            for _, child in pairs(ball:GetChildren()) do
                if child.Name == "PossessionHighlight" then
                    child:Destroy()
                end
            end
        end
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character == nil then
                continue
            end
            if
                player.Character:FindFirstChild("TeammateHighlight")
                or not player.Character:FindFirstChild("TeammateHighlight")
                    and (player.Character:FindFirstChild("OffsideHighlight"))
            then
                for key, child_2 in pairs(player.Character:GetChildren()) do
                    if child_2.Name == "TeammateHighlight" then
                        child_2:Destroy()
                    end
                    if child_2.Name == "OffsideHighlight" then
                        child_2:Destroy()
                    end
                end
            end
        end
    else
        local ball_2
        if local_player.Settings.Misc.Highlights.Value ~= true then
            local ball_3 = game.Workspace.Temp:FindFirstChild("Ball")
            if ball_3 then
                for _, child_3 in pairs(ball_3:GetChildren()) do
                    if child_3.Name == "PossessionHighlight" then
                        child_3:Destroy()
                    end
                end
            end
            for _, player_2 in pairs(game.Players:GetPlayers()) do
                if player_2.Character == nil then
                    continue
                end
                if
                    player_2.Character:FindFirstChild("TeammateHighlight")
                    or not player_2.Character:FindFirstChild("TeammateHighlight")
                        and (player_2.Character:FindFirstChild("OffsideHighlight"))
                then
                    for key_2, child_4 in pairs(player_2.Character:GetChildren()) do
                        if child_4.Name == "TeammateHighlight" then
                            child_4:Destroy()
                        end
                        if child_4.Name == "OffsideHighlight" then
                            child_4:Destroy()
                        end
                    end
                end
            end
        else
            ball_2 = game.Workspace.Temp:FindFirstChild("Ball")
            if ball_2 then
                local highlight = Instance.new("Highlight")
                highlight.Name = "PossessionHighlight"
                highlight.Parent = ball_2
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.OutlineTransparency = 1
                highlight.FillTransparency = 1
                local tween_properties = { OutlineTransparency = 0 }
                game:GetService("TweenService")
                    :Create(
                        highlight,
                        TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        tween_properties
                    )
                    :Play()
            end
            for _, player_3 in pairs(game.Players:GetPlayers()) do
                if
                    not (player_3:FindFirstChild("dataLoaded"))
                    or player_3.SelectedTeam.Value ~= local_player.SelectedTeam.Value
                then
                    continue
                end
                if player_3 ~= local_player then
                    local highlight_2 = Instance.new("Highlight")
                    highlight_2.Name = "TeammateHighlight"
                    highlight_2.Parent = player_3.Character
                    highlight_2.OutlineColor = Color3.new(0, 1, 0)
                    highlight_2.DepthMode = Enum.HighlightDepthMode.Occluded
                    highlight_2.OutlineTransparency = 0.6
                    highlight_2.FillTransparency = 1
                    local tween_properties_2 = { OutlineTransparency = 0 }
                    game:GetService("TweenService")
                        :Create(
                            highlight_2,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            tween_properties_2
                        )
                        :Play()
                end
            end
            local connection_5 = nil
            local connection_3 = game:GetService("RunService").RenderStepped:Connect(function()
                if ball_status.lastKicked.Value == local_player then
                    if local_player.SelectedTeam.Value ~= "Home" then
                        local player_8 = nil
                        if local_player.SelectedTeam.Value == "Away" then
                            local items_2 = {}
                            for _, player_4 in pairs(game.Players:GetPlayers()) do
                                if
                                    player_4.SelectedPosition.Value == "GK" or not (player_4:FindFirstChild("InPlay"))
                                then
                                    continue
                                end
                                if player_4.SelectedTeam.Value ~= local_player.SelectedTeam.Value then
                                    table.insert(items_2, player_4)
                                end
                            end
                            local number_4 = 15.807
                            player_8 = nil
                            local target = number_4
                            for _, player_9 in ipairs(items_2) do
                                if not player_9.Character then
                                    continue
                                end
                                if player_9.Character.HumanoidRootPart.Position.Z < target then
                                    target, player_8 = player_9.Character.HumanoidRootPart.Position.Z, player_9
                                end
                            end
                            if player_8 and not (player_8.Character:FindFirstChild("OffsideHighlight")) then
                                target = Instance.new("Highlight")
                                target.Name = "OffsideHighlight"
                                target.Parent = player_8.Character
                                target.OutlineColor = Color3.new(1, 0, 0)
                                target.DepthMode = Enum.HighlightDepthMode.Occluded
                                target.OutlineTransparency = 0.6
                                target.FillTransparency = 1
                                local tween_properties_3 = { OutlineTransparency = 0 }
                                game:GetService("TweenService")
                                    :Create(
                                        target,
                                        TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                        tween_properties_3
                                    )
                                    :Play()
                                for _, player_5 in pairs(game.Players:GetPlayers()) do
                                    if player_5 == player_8 then
                                        continue
                                    end
                                    if player_5.Character:FindFirstChild("OffsideHighlight") then
                                        player_5.Character.OffsideHighlight:Destroy()
                                    end
                                end
                            end
                        end
                    else
                        local items_3 = {}
                        for _, player_6 in pairs(game.Players:GetPlayers()) do
                            if player_6.SelectedPosition.Value == "GK" or not (player_6:FindFirstChild("InPlay")) then
                                continue
                            end
                            if player_6.SelectedTeam.Value ~= local_player.SelectedTeam.Value then
                                table.insert(items_3, player_6)
                            end
                        end
                        local number_5 = 15.807
                        local player_10 = nil
                        local target_2 = number_5
                        for _, player_11 in ipairs(items_3) do
                            if not player_11.Character then
                                continue
                            end
                            if target_2 < player_11.Character.HumanoidRootPart.Position.Z then
                                target_2, player_10 = player_11.Character.HumanoidRootPart.Position.Z, player_11
                            end
                        end
                        if player_10 and not (player_10.Character:FindFirstChild("OffsideHighlight")) then
                            target_2 = Instance.new("Highlight")
                            target_2.Name = "OffsideHighlight"
                            target_2.Parent = player_10.Character
                            target_2.OutlineColor = Color3.new(1, 0, 0)
                            target_2.DepthMode = Enum.HighlightDepthMode.Occluded
                            target_2.OutlineTransparency = 0.6
                            target_2.FillTransparency = 1
                            local tween_properties_4 = { OutlineTransparency = 0 }
                            game:GetService("TweenService")
                                :Create(
                                    target_2,
                                    TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                    tween_properties_4
                                )
                                :Play()
                            for _, player_7 in pairs(game.Players:GetPlayers()) do
                                if player_7 == player_10 then
                                    continue
                                end
                                if player_7.Character:FindFirstChild("OffsideHighlight") then
                                    player_7.Character.OffsideHighlight:Destroy()
                                end
                            end
                        end
                    end
                    if ball_2 and not (ball_2:FindFirstChild("PossessionHighlight")) then
                        local highlight_3 = Instance.new("Highlight")
                        highlight_3.Name = "PossessionHighlight"
                        highlight_3.Parent = ball_2
                        highlight_3.OutlineColor = Color3.new(1, 1, 1)
                        highlight_3.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight_3.OutlineTransparency = 1
                        highlight_3.FillTransparency = 1
                        local tween_properties_5 = { OutlineTransparency = 0 }
                        game:GetService("TweenService")
                            :Create(
                                highlight_3,
                                TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                tween_properties_5
                            )
                            :Play()
                    end
                else
                    connection_5:Disconnect()
                end
            end)
            connection_5 = connection_3
            local connection_6 = nil
            local connection_4 = ball_status.lastKicked.Changed:Connect(function()
                if ball_status.lastKicked.Value == local_player then
                    return
                end
                connection_5:Disconnect()
                connection_6:Disconnect()
            end)
            connection_6 = connection_4
        end
    end
end)
game.Workspace.Temp.ChildAdded:Connect(function(child)
    if child.Name ~= "Ball" then
        return
    end
    if ball_status.lastKicked.Value == local_player then
        local highlight = Instance.new("Highlight")
        highlight.Name = "PossessionHighlight"
        highlight.Parent = child
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        highlight.OutlineTransparency = 1
        highlight.FillTransparency = 1
        local tween_properties = { OutlineTransparency = 0 }
        game:GetService("TweenService")
            :Create(highlight, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties)
            :Play()
        for _, player in pairs(game.Players:GetPlayers()) do
            if
                not (player:FindFirstChild("dataLoaded"))
                or player.SelectedTeam.Value ~= local_player.SelectedTeam.Value
            then
                continue
            end
            if player ~= local_player then
                local highlight_2 = Instance.new("Highlight")
                highlight_2.Name = "TeammateHighlight"
                highlight_2.Parent = player.Character
                highlight_2.OutlineColor = Color3.new(0, 1, 0)
                highlight_2.DepthMode = Enum.HighlightDepthMode.Occluded
                highlight_2.OutlineTransparency = 0.6
                highlight_2.FillTransparency = 1
                local tween_properties_2 = { OutlineTransparency = 0 }
                game:GetService("TweenService")
                    :Create(
                        highlight_2,
                        TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        tween_properties_2
                    )
                    :Play()
            end
        end
    end
end)
key_handler_service:GetKey("passMarkerClient").OnClientEvent:Connect(function(position, value)
    for _, child in pairs(game.Workspace.FX:GetChildren()) do
        if not (child:FindFirstChild("owner")) or child.Name ~= "PassMarker" then
            continue
        end
        if child.owner.Value == value then
            child:Destroy()
        end
    end
    local pass_marker = game.ReplicatedStorage.VFX.PassMarker
    if value.SelectedTeam.Value ~= game.Players.LocalPlayer.SelectedTeam.Value then
        pass_marker = game.ReplicatedStorage.VFX.PassMarkerRed
    end
    local clone = pass_marker:Clone()
    clone.Parent = game.Workspace.FX
    clone.Position = position
    clone.owner.Value = value
    clone.TitleGui.TextLabel.Text = string.upper(value.DisplayName)
    local tween_properties = { TextTransparency = 0, TextStrokeTransparency = 0 }
    game:GetService("TweenService")
        :Create(
            clone.TitleGui.TextLabel,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    local tween_properties_2 = { Volume = 0.25 }
    game:GetService("TweenService")
        :Create(clone.sfx, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_2)
        :Play()
    clone.fx.circle:Emit(1)
    clone.arrowAttach.arrow:Emit(1)
    task.delay(1.5, function()
        if clone == nil or clone.Parent == nil then
            return
        end
        clone.fx.circle.Enabled = false
        clone.arrowAttach.arrow.Enabled = false
        local tween_properties_3 = { TextTransparency = 1, TextStrokeTransparency = 1 }
        game:GetService("TweenService")
            :Create(
                clone.TitleGui.TextLabel,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_3
            )
            :Play()
        local tween_properties_4 = { Volume = 0 }
        game:GetService("TweenService")
            :Create(clone.sfx, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_4)
            :Play()
        game.Debris:AddItem(clone, 1)
    end)
end)
local lobby = workspace:WaitForChild("Lobby")
local_player.ChildAdded:Connect(function(child)
    if child.Name ~= "InPlay" or not game.Workspace:FindFirstChild("Lobby") then
        return
    end
    lobby.Parent = game.ReplicatedStorage
end)
local_player.ChildRemoved:Connect(function(child)
    if child.Name ~= "InPlay" or (game.Workspace:FindFirstChild("Lobby")) then
        return
    end
    lobby.Parent = workspace
end)
game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LoadMapClient").OnClientEvent:Connect(function()
    game.Lighting.Blur.Size = 2
    if game.Workspace:FindFirstChild("Lobby") then
        return
    end
    lobby.Parent = workspace
end)
key_handler_service:GetKey("SetCharInvisible").OnClientEvent:Connect(function(instance, enabled)
    if enabled == true then
        for _, child in pairs(instance:GetChildren()) do
            if child:IsA("BasePart") then
                child.Transparency = 1
            end
            if not (child:IsA("Accessory")) then
                continue
            end
            for key, child_2 in pairs(child:GetChildren()) do
                if child_2:IsA("BasePart") then
                    child_2.Transparency = 1
                end
            end
        end
        local connection_3 = instance.ChildAdded:Connect(function(child_5)
            if not child_5:IsA("Accessory") then
                return
            end
            for _, child_6 in pairs(child_5:GetChildren()) do
                if child_6:IsA("BasePart") then
                    child_6.Transparency = 1
                end
            end
        end)
        task.delay(5, function()
            connection_3:Disconnect()
        end)
    elseif enabled == false then
        for _, child_3 in pairs(instance:GetChildren()) do
            if
                child_3:IsA("BasePart")
                and child_3.Name ~= "BallWeldPos"
                and child_3.Name ~= "Hand"
                and child_3.Name ~= "HumanoidRootPart"
                and child_3.Name ~= "Neck_CameraSubject"
                and child_3.Name ~= "SlipCone"
                and child_3.Name ~= "CollisionBox"
            then
                child_3.Transparency = 0
            end
            if not (child_3:IsA("Accessory")) then
                continue
            end
            for key_2, child_4 in pairs(child_3:GetChildren()) do
                if child_4:IsA("BasePart") then
                    child_4.Transparency = 0
                end
            end
        end
    end
end)
local_player:WaitForChild("dataLoaded")
local _ = require(game.ReplicatedStorage.Modules:WaitForChild("ScreenRain"))
local game_settings = UserSettings().GameSettings
local saved_quality_level = game_settings.SavedQualityLevel
local number = 0
local number_2 = 5
local number_3 = 10

function doGFXLevel()
    if saved_quality_level == Enum.SavedQualitySetting.Automatic then
        number = 0.5
    elseif saved_quality_level ~= Enum.SavedQualitySetting.QualityLevel10 then
        number = tonumber("0." .. string.sub(saved_quality_level.Name, 13))
    else
        number = 1
    end
    if number < 0.8 then
        number_2 = 10
        number_3 = 20
        if not (number < 0.5) then
            return
        end
        number_2 = 8
        number_3 = 16
        if not (number < 0.25) then
            return
        end
        number_2 = 5
        number_3 = 10
    else
        number_2 = 15
        number_3 = 30
    end
end

doGFXLevel()
UserSettings().GameSettings:GetPropertyChangedSignal("SavedQualityLevel"):Connect(function()
    saved_quality_level = UserSettings().GameSettings.SavedQualityLevel
    doGFXLevel()
end)
local settings = local_player:FindFirstChild("Settings")

function doGrass()
    if settings.Misc.GrassVisuals.Value ~= true then
        game.Workspace.Terrain:Clear()
    else
        game.Workspace.Terrain:FillBlock(
            CFrame.new(Vector3.new(267, -10.25, 20)),
            Vector3.new(800, 32, 800),
            Enum.Material.Grass
        )
    end
end

task.delay(5, function()
    doGrass()
end)
settings.Misc.GrassVisuals.Changed:Connect(doGrass)
game.Workspace:WaitForChild("Cloud")

function doNight()
    if settings.Misc.Night.Value ~= true then
        for _, descendant in ipairs(workspace.miscFX.NightLights:GetDescendants()) do
            if descendant:IsA("SurfaceLight") then
                descendant.Enabled = false
            end
        end
        game.Lighting.Atmosphere.Haze = 2.07
        game.Lighting.ClockTime = 13.5
        game.Lighting.Ambient = Color3.new(0, 0, 0)
        game.Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        game.Workspace.Cloud.Cloud.Transparency = NumberSequence.new(0)
        game.Workspace.Cloud.Cloud.LightEmission = 0
    else
        for _, descendant_2 in ipairs(workspace.miscFX.NightLights:GetDescendants()) do
            if not (descendant_2:IsA("SurfaceLight")) then
                continue
            end
            if settings.Misc.MapSelection.Value ~= "Blue Lock Chamber" then
                descendant_2.Enabled = true
                continue
            end
            if descendant_2.Parent:GetAttribute("Higher") then
                descendant_2.Enabled = false
            else
                descendant_2.Enabled = true
            end
        end
        game.Lighting.ClockTime = 22
        game.Lighting.Atmosphere.Haze = 0.2
        if settings.Misc.MapSelection.Value ~= "Blue Lock Chamber" then
            game.Lighting.Ambient = Color3.new(0, 0, 0)
            game.Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        else
            game.Lighting.Ambient = Color3.new(0.882353, 0.882353, 0.882353)
            game.Lighting.OutdoorAmbient = Color3.new(0.882353, 0.882353, 0.882353)
        end
        game.Workspace.Cloud.Cloud.Transparency = NumberSequence.new(0.8)
        game.Workspace.Cloud.Cloud.LightEmission = 1
    end
end

doNight()
settings.Misc.Night.Changed:Connect(doNight)
local character = local_player.Character or (local_player.CharacterAdded:Wait())
local connection = nil

function doCinematic()
    if settings.Misc.CinematicMode.Value == true then
        local_player.PlayerGui.ScoreAndTimer.Enabled = false
        local_player.PlayerGui.HUD.Enabled = false
        character.HumanoidRootPart.UIAttach.ChargeGUI.Enabled = false
    elseif settings.Misc.CinematicMode.Value == false then
        local_player.PlayerGui.ScoreAndTimer.Enabled = true
        local_player.PlayerGui.HUD.Enabled = true
        character.HumanoidRootPart.UIAttach.ChargeGUI.Enabled = true
    end
end

doCinematic()
settings.Misc.CinematicMode.Changed:Connect(doCinematic)

function doRain()
    if settings.Misc.RainEnabled.Value ~= false then
        game.Workspace.rain:Play()
        for _, child in pairs(game.Lighting:GetChildren()) do
            if child:IsA("Sky") then
                child:Destroy()
            end
        end
        game.ReplicatedStorage.Rainy:Clone().Parent = game.Lighting
        local tween_properties = { Density = 0.2 }
        game:GetService("TweenService")
            :Create(
                game.Lighting.Atmosphere,
                TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties
            )
            :Play()
    else
        game.Workspace.rain:Stop()
        for _, child_2 in pairs(game.Lighting:GetChildren()) do
            if child_2:IsA("Sky") then
                child_2:Destroy()
            end
        end
        game.ReplicatedStorage.Sky:Clone().Parent = game.Lighting
        local tween_properties_2 = { Density = 0.2 }
        game:GetService("TweenService")
            :Create(
                game.Lighting.Atmosphere,
                TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_2
            )
            :Play()
    end
end

doRain()
settings.Misc.RainEnabled.Changed:Connect(doRain)

function doStorm()
    if settings.Misc.StormEnabled.Value ~= false then
        game.Workspace.Rainstorm:Play()
        for _, child in pairs(game.Lighting:GetChildren()) do
            if child:IsA("Sky") then
                child:Destroy()
            end
        end
        game.ReplicatedStorage.Rainy:Clone().Parent = game.Lighting
        local tween_properties = { Density = 0.4 }
        game:GetService("TweenService")
            :Create(
                game.Lighting.Atmosphere,
                TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties
            )
            :Play()
    else
        game.Workspace.Rainstorm:Stop()
        for _, child_2 in pairs(game.Lighting:GetChildren()) do
            if child_2:IsA("Sky") then
                child_2:Destroy()
            end
        end
        game.ReplicatedStorage.Sky:Clone().Parent = game.Lighting
        local tween_properties_2 = { Density = 0.2 }
        game:GetService("TweenService")
            :Create(
                game.Lighting.Atmosphere,
                TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_2
            )
            :Play()
    end
end

doStorm()
settings.Misc.StormEnabled.Changed:Connect(doStorm)
local parent = nil
local connection_2 = nil

function doSnow()
    if settings.Misc.SnowEnabled.Value ~= false then
        game.Workspace.Snowstorm:Play()
        game.Workspace.Terrain:SetMaterialColor(Enum.Material.Grass, Color3.new(1, 1, 1))
        game.Lighting.Sky:Destroy()
        game.ReplicatedStorage.Rainy:Clone().Parent = game.Lighting
        local tween_properties = { Density = 0.25 }
        game:GetService("TweenService")
            :Create(
                game.Lighting.Atmosphere,
                TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties
            )
            :Play()
        for _, child in ipairs(workspace.gameArea.Grass:GetChildren()) do
            child.MaterialVariant = "SnowyGrass"
            child.Color = Color3.new(0.886275, 0.886275, 0.886275)
            if child:IsA("UnionOperation") then
                child.UsePartColor = true
            end
        end
        workspace.gameArea.Surround.MaterialVariant = "SnowyGrass"
        workspace.gameArea.Surround.Color = Color3.new(0.886275, 0.886275, 0.886275)
        workspace.gameArea.Surround.UsePartColor = true
        local connection_3 = game.Workspace.gameArea.Grass.ChildAdded:Connect(function(child_4)
            if child_4.Name ~= "FieldBase" then
                return
            end
            child_4.MaterialVariant = "SnowyGrass"
            child_4.Color = Color3.new(0.886275, 0.886275, 0.886275)
        end)
        connection_2 = connection_3
    else
        if connection_2 then
            connection_2:Disconnect()
        end
        game.Workspace.Terrain:SetMaterialColor(Enum.Material.Grass, Color3.new(0, 0.52549, 0.121569))
        game.Workspace.Snowstorm:Stop()
        for _, child_2 in pairs(game.Lighting:GetChildren()) do
            if child_2:IsA("Sky") then
                child_2:Destroy()
            end
        end
        game.ReplicatedStorage.Sky:Clone().Parent = game.Lighting
        for _, child_3 in ipairs(workspace.gameArea.Grass:GetChildren()) do
            child_3.MaterialVariant = ""
            child_3.Color = Color3.new(0.172549, 0.6, 0.0980392)
            if child_3:IsA("UnionOperation") then
                child_3.UsePartColor = false
            end
        end
        workspace.gameArea.Surround.MaterialVariant = ""
        workspace.gameArea.Surround.Color = Color3.new(0.172549, 0.6, 0.0980392)
        workspace.gameArea.Surround.UsePartColor = false
        local tween_properties_2 = { Density = 0.2 }
        game:GetService("TweenService")
            :Create(
                game.Lighting.Atmosphere,
                TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_2
            )
            :Play()
    end
end

doSnow()
settings.Misc.SnowEnabled.Changed:Connect(doSnow)

function doSeasonal()
    if settings.Misc.Seasonal.Value ~= false then
        game.Workspace.Terrain:SetMaterialColor(Enum.Material.Grass, Color3.fromRGB(181, 181, 181))
        for _, child in ipairs(workspace.gameArea.Grass:GetChildren()) do
            child.MaterialVariant = ""
            child.Color = Color3.fromRGB(181, 181, 181)
            if child:IsA("UnionOperation") then
                child.UsePartColor = true
            end
        end
        workspace.gameArea.Surround.MaterialVariant = ""
        workspace.gameArea.Surround.Color = Color3.fromRGB(134, 81, 60)
        workspace.gameArea.Surround.UsePartColor = true
        local connection_3 = game.Workspace.gameArea.Grass.ChildAdded:Connect(function(child_3)
            if child_3.Name ~= "FieldBase" then
                return
            end
            child_3.MaterialVariant = ""
            child_3.Color = Color3.fromRGB(134, 81, 60)
        end)
        connection = connection_3
    elseif settings.Misc.SnowEnabled.Value == false then
        if connection then
            connection:Disconnect()
        end
        game.Workspace.Terrain:SetMaterialColor(Enum.Material.Grass, Color3.new(0, 0.52549, 0.121569))
        for _, child_2 in ipairs(workspace.gameArea.Grass:GetChildren()) do
            child_2.MaterialVariant = ""
            child_2.Color = Color3.new(0.172549, 0.6, 0.0980392)
            if child_2:IsA("UnionOperation") then
                child_2.UsePartColor = false
            end
        end
        workspace.gameArea.Surround.MaterialVariant = ""
        workspace.gameArea.Surround.Color = Color3.new(0.172549, 0.6, 0.0980392)
        workspace.gameArea.Surround.UsePartColor = false
    end
end

doSeasonal()
settings.Misc.Seasonal.Changed:Connect(doSeasonal)
local items = {}
local liquid_module = require(script.LiquidModule)
task.spawn(function()
    while task.wait(math.random(1, 5) / 2) do
        if settings.Misc.StormEnabled.Value ~= false then
            local is_random_value = math.random(1, 2) == 1
            formLightning(is_random_value)
        end
    end
end)
task.spawn(function()
    while task.wait(0.1) do
        if settings.Misc.RainEnabled.Value ~= false then
            if settings.Misc.RainEnabled.Value == true then
                for _ = 1, math.random(number_2, number_3) do
                    if #items < 400 then
                        local new_water_result = liquid_module.newWater(
                            (game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1))
                                + Vector3.new(math.random(-75, 40), 67.5, math.random(-75, 40)),
                            Vector3.new(math.random(35, 45), -100, math.random(40, 60))
                        )
                        table.insert(items, new_water_result)
                        new_water_result.Destroying:Once(function()
                            table.remove(items, table.find(items, new_water_result))
                        end)
                    end
                end
            elseif settings.Misc.SnowEnabled.Value ~= true then
                if settings.Misc.StormEnabled.Value ~= true then
                    continue
                end
                for _ = 1, math.random(number_2, number_3 * 2) do
                    if #items < 400 then
                        local new_water_result_2 = liquid_module.newWater(
                            (game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1))
                                + Vector3.new(math.random(-75, 40), 67.5, math.random(-75, 40)),
                            Vector3.new(math.random(35, 45), -100, math.random(40, 60))
                        )
                        table.insert(items, new_water_result_2)
                        new_water_result_2.Destroying:Once(function()
                            table.remove(items, table.find(items, new_water_result_2))
                        end)
                    end
                end
            elseif local_player:FindFirstChild("InPlay") then
                if not parent then
                    parent = Instance.new("Part")
                    parent.Size = Vector3.new(125, 0.10000000149011612, 125)
                    parent.Transparency = 1
                    parent.CanCollide = false
                    parent.CanTouch = false
                    parent.CanQuery = false
                    parent.Anchored = true
                    parent.Parent = game.Workspace.FX
                    local clone = game.ReplicatedStorage.VFX.snowParticle:Clone()
                    clone.Parent = parent
                end
                parent.Position = Vector3.new(
                    game.Workspace.CurrentCamera.CFrame.Position.X,
                    50,
                    game.Workspace.CurrentCamera.CFrame.Position.Z
                )
            else
                if settings.Misc.StormEnabled.Value ~= true then
                    continue
                end
                for _ = 1, math.random(number_2, number_3 * 2) do
                    if #items < 400 then
                        local new_water_result_3 = liquid_module.newWater(
                            (game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1))
                                + Vector3.new(math.random(-75, 40), 67.5, math.random(-75, 40)),
                            Vector3.new(math.random(35, 45), -100, math.random(40, 60))
                        )
                        table.insert(items, new_water_result_3)
                        new_water_result_3.Destroying:Once(function()
                            table.remove(items, table.find(items, new_water_result_3))
                        end)
                    end
                end
            end
        elseif settings.Misc.SnowEnabled == false then
            if settings.Misc.StormEnabled == false then
                continue
            end
            if settings.Misc.RainEnabled.Value == true then
                for _ = 1, math.random(number_2, number_3) do
                    if #items < 400 then
                        local new_water_result_4 = liquid_module.newWater(
                            (game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1))
                                + Vector3.new(math.random(-75, 40), 67.5, math.random(-75, 40)),
                            Vector3.new(math.random(35, 45), -100, math.random(40, 60))
                        )
                        table.insert(items, new_water_result_4)
                        new_water_result_4.Destroying:Once(function()
                            table.remove(items, table.find(items, new_water_result_4))
                        end)
                    end
                end
            elseif settings.Misc.SnowEnabled.Value ~= true then
                if settings.Misc.StormEnabled.Value ~= true then
                    continue
                end
                for _ = 1, math.random(number_2, number_3 * 2) do
                    if #items < 400 then
                        local new_water_result_5 = liquid_module.newWater(
                            (game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1))
                                + Vector3.new(math.random(-75, 40), 67.5, math.random(-75, 40)),
                            Vector3.new(math.random(35, 45), -100, math.random(40, 60))
                        )
                        table.insert(items, new_water_result_5)
                        new_water_result_5.Destroying:Once(function()
                            table.remove(items, table.find(items, new_water_result_5))
                        end)
                    end
                end
            elseif local_player:FindFirstChild("InPlay") then
                if not parent then
                    parent = Instance.new("Part")
                    parent.Size = Vector3.new(125, 0.10000000149011612, 125)
                    parent.Transparency = 1
                    parent.CanCollide = false
                    parent.CanTouch = false
                    parent.CanQuery = false
                    parent.Anchored = true
                    parent.Parent = game.Workspace.FX
                    local clone_2 = game.ReplicatedStorage.VFX.snowParticle:Clone()
                    clone_2.Parent = parent
                end
                parent.Position = Vector3.new(
                    game.Workspace.CurrentCamera.CFrame.Position.X,
                    50,
                    game.Workspace.CurrentCamera.CFrame.Position.Z
                )
            else
                if settings.Misc.StormEnabled.Value ~= true then
                    continue
                end
                for _ = 1, math.random(number_2, number_3 * 2) do
                    if #items < 400 then
                        local new_water_result_6 = liquid_module.newWater(
                            (game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1))
                                + Vector3.new(math.random(-75, 40), 67.5, math.random(-75, 40)),
                            Vector3.new(math.random(35, 45), -100, math.random(40, 60))
                        )
                        table.insert(items, new_water_result_6)
                        new_water_result_6.Destroying:Once(function()
                            table.remove(items, table.find(items, new_water_result_6))
                        end)
                    end
                end
            end
        elseif settings.Misc.RainEnabled.Value == true then
            for _ = 1, math.random(number_2, number_3) do
                if #items < 400 then
                    local new_water_result_7 = liquid_module.newWater(
                        (game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1))
                            + Vector3.new(math.random(-75, 40), 67.5, math.random(-75, 40)),
                        Vector3.new(math.random(35, 45), -100, math.random(40, 60))
                    )
                    table.insert(items, new_water_result_7)
                    new_water_result_7.Destroying:Once(function()
                        table.remove(items, table.find(items, new_water_result_7))
                    end)
                end
            end
        elseif settings.Misc.SnowEnabled.Value ~= true then
            if settings.Misc.StormEnabled.Value ~= true then
                continue
            end
            for _ = 1, math.random(number_2, number_3 * 2) do
                if #items < 400 then
                    local new_water_result_8 = liquid_module.newWater(
                        (game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1))
                            + Vector3.new(math.random(-75, 40), 67.5, math.random(-75, 40)),
                        Vector3.new(math.random(35, 45), -100, math.random(40, 60))
                    )
                    table.insert(items, new_water_result_8)
                    new_water_result_8.Destroying:Once(function()
                        table.remove(items, table.find(items, new_water_result_8))
                    end)
                end
            end
        elseif local_player:FindFirstChild("InPlay") then
            if not parent then
                parent = Instance.new("Part")
                parent.Size = Vector3.new(125, 0.10000000149011612, 125)
                parent.Transparency = 1
                parent.CanCollide = false
                parent.CanTouch = false
                parent.CanQuery = false
                parent.Anchored = true
                parent.Parent = game.Workspace.FX
                local clone_3 = game.ReplicatedStorage.VFX.snowParticle:Clone()
                clone_3.Parent = parent
            end
            parent.Position = Vector3.new(
                game.Workspace.CurrentCamera.CFrame.Position.X,
                50,
                game.Workspace.CurrentCamera.CFrame.Position.Z
            )
        else
            if settings.Misc.StormEnabled.Value ~= true then
                continue
            end
            for _ = 1, math.random(number_2, number_3 * 2) do
                if #items < 400 then
                    local new_water_result_9 = liquid_module.newWater(
                        (game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1))
                            + Vector3.new(math.random(-75, 40), 67.5, math.random(-75, 40)),
                        Vector3.new(math.random(35, 45), -100, math.random(40, 60))
                    )
                    table.insert(items, new_water_result_9)
                    new_water_result_9.Destroying:Once(function()
                        table.remove(items, table.find(items, new_water_result_9))
                    end)
                end
            end
        end
    end
end)

function formLightning(argument)
    local part = Instance.new("Part")
    part.Parent = game.Workspace.Temp
    part.Transparency = 1
    part.CanCollide = false
    part.Anchored = true
    part.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        + Vector3.new(math.random(-1250, 1250), 0, math.random(-1250, 1250))
    game.Debris:AddItem(part, 3)
    local clone = script["lightning_strike" .. math.random(1, 2)]:Clone()
    clone.Parent = part
    clone.PlaybackSpeed = math.random(40, 60) / 100
    clone:Play()
    task.wait(0.05)
end

key_handler_service:GetKey("PSCommand").OnClientEvent:Connect(function(argument)
    game.TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(argument)
end)
