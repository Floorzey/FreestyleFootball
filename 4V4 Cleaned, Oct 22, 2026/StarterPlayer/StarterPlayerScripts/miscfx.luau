local ball_status = game.Workspace.ballStatus

game.ReplicatedStorage.Remotes.SharpEyesClient.OnClientEvent:Connect(function()
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_3 = {}
    tween_properties_3.TintColor = Color3.fromRGB(243, 171, 172)
    tween_service:Create(game.Lighting.ColorCorrection, tween_info, tween_properties_3):Play()
    local ball = game.Workspace.Temp:FindFirstChild("Ball") or game.Workspace.Temp:WaitForChild("Ball")

    if not ball then
        return
    end

    local sharp_eye_highlight = Instance.new("Highlight")
    sharp_eye_highlight.Parent = ball
    sharp_eye_highlight.Name = "SharpEyeHighlight"
    sharp_eye_highlight.FillColor = Color3.new(0.839216, 0, 0)
    sharp_eye_highlight.OutlineTransparency = 1
    sharp_eye_highlight.FillTransparency = 1
    local tween_properties_4 = { FillTransparency = 0 }
    game:GetService("TweenService")
        :Create(
            sharp_eye_highlight,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_4
        )
        :Play()
    local connection = game:GetService("RunService").RenderStepped:Connect(function()
        if not game.Workspace.Temp:FindFirstChild("Ball") then
            return
        end

        if game.Workspace.Temp.Ball:FindFirstChild("SharpEyeHighlight") then
            return
        end

        local sharp_eye_highlight_2 = Instance.new("Highlight")
        sharp_eye_highlight_2.Parent = ball
        sharp_eye_highlight_2.Name = "SharpEyeHighlight"
        sharp_eye_highlight_2.FillColor = Color3.new(0.839216, 0, 0)
        sharp_eye_highlight_2.OutlineTransparency = 1
        sharp_eye_highlight_2.FillTransparency = 1
        local tween_properties_5 = { FillTransparency = 0 }
        game:GetService("TweenService")
            :Create(
                sharp_eye_highlight_2,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_5
            )
            :Play()
    end)
    local connection_3 = connection
    local connection_2 = ball_status.lastKicked.Changed:Connect(function()
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

        local sharp_eye_highlight_2 = Instance.new("Highlight")
        sharp_eye_highlight_2.Parent = ball_status.lastKicked.Value.Character
        sharp_eye_highlight_2.Name = "SharpEyeHighlight"
        sharp_eye_highlight_2.FillColor = color3
        sharp_eye_highlight_2.OutlineTransparency = 1
        sharp_eye_highlight_2.FillTransparency = 1
        local tween_properties_5 = { FillTransparency = 0 }
        game:GetService("TweenService")
            :Create(
                sharp_eye_highlight_2,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_5
            )
            :Play()
    end)
    local connection_4 = connection_2

    task.delay(10, function()
        connection_3:Disconnect()
        connection_4:Disconnect()

        if game.Workspace.Temp:FindFirstChild("Ball") then
            for _, child in pairs(game.Workspace.Temp.Ball:GetChildren()) do
                if not (child:IsA("Highlight")) then
                    continue
                end

                if child.Name == "SharpEyeHighlight" then
                    local tween_properties_5 = { FillTransparency = 1 }
                    game:GetService("TweenService")
                        :Create(
                            child,
                            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            tween_properties_5
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
        local tween_properties_6 = {}
        tween_properties_6.TintColor = Color3.new(1, 1, 1)
        tween_service_2:Create(game.Lighting.ColorCorrection, tween_info_2, tween_properties_6):Play()
    end)
end)

game.ReplicatedStorage.Remotes.ScoreSFXClient.OnClientEvent:Connect(function()
    if game.Players.LocalPlayer.Settings.Misc.CrowdNoise.Value == false then
        return
    end

    for _, child in pairs(game.Workspace.miscFX:GetChildren()) do
        if child.Name == "CameraFlash" then
            local child_entry = child["ScoreSFX" .. math.random(1, 2)]
            child_entry.Volume = 0
            child_entry:Play()
            local tween_properties_3 = { Volume = 2 }
            game:GetService("TweenService")
                :Create(
                    child_entry,
                    TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties_3
                )
                :Play()

            task.delay(8, function()
                local tween_properties_4 = { Volume = 0 }
                game:GetService("TweenService")
                    :Create(
                        child_entry,
                        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        tween_properties_4
                    )
                    :Play()
                task.wait(0.5)
                child_entry:Stop()
                child_entry.Volume = child_entry:GetAttribute("Volume")
            end)
        end
    end
end)

game.ReplicatedStorage.Remotes.GameEndSFXClient.OnClientEvent:Connect(function()
    if game.Players.LocalPlayer.Settings.Misc.CrowdNoise.Value == false then
        return
    end

    for _, child in pairs(game.Workspace.miscFX:GetChildren()) do
        if child.Name == "CameraFlash" then
            local game_end_crowd1 = child.gameEndCrowd1
            game_end_crowd1.Volume = 0
            game_end_crowd1:Play()
            local tween_properties_3 = { Volume = 2 }
            game:GetService("TweenService")
                :Create(
                    game_end_crowd1,
                    TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties_3
                )
                :Play()

            task.delay(24.2, function()
                local tween_properties_4 = { Volume = 0 }
                game:GetService("TweenService")
                    :Create(
                        game_end_crowd1,
                        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        tween_properties_4
                    )
                    :Play()
                task.wait(0.5)
                game_end_crowd1:Stop()
                game_end_crowd1.Volume = game_end_crowd1:GetAttribute("Volume")
            end)
        end
    end
end)

game.ReplicatedStorage.Remotes.FailSFXClient.OnClientEvent:Connect(function(argument)
    if game.Players.LocalPlayer.Settings.Misc.CrowdNoise.Value == false then
        return
    end

    for _, child in pairs(game.Workspace.miscFX:GetChildren()) do
        if child.Name == "CameraFlash" then
            local fail_sfx1 = child.FailSFX1
            fail_sfx1.Volume = 0
            fail_sfx1:Play()
            local tween_properties_3 = { Volume = 3 }
            game:GetService("TweenService")
                :Create(
                    fail_sfx1,
                    TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties_3
                )
                :Play()

            task.delay(argument, function()
                local tween_properties_4 = { Volume = 0 }
                game:GetService("TweenService")
                    :Create(
                        fail_sfx1,
                        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        tween_properties_4
                    )
                    :Play()
                task.wait(0.5)
                fail_sfx1:Stop()
                fail_sfx1.Volume = fail_sfx1:GetAttribute("Volume")
            end)
        end
    end
end)

local local_player = game.Players.LocalPlayer

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
    end

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
                    and player.Character:FindFirstChild("OffsideHighlight")
            then
                for key, child_2 in pairs(player.Character:GetChildren()) do
                    if child_2.Name == "TeammateHighlight" then
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
                        and player_2.Character:FindFirstChild("OffsideHighlight")
                then
                    for key_2, child_4 in pairs(player_2.Character:GetChildren()) do
                        if child_4.Name == "TeammateHighlight" then
                            child_4:Destroy()
                        end
                    end
                end
            end
        else
            ball_2 = game.Workspace.Temp:FindFirstChild("Ball")

            if ball_2 then
                local possession_highlight = Instance.new("Highlight")
                possession_highlight.Name = "PossessionHighlight"
                possession_highlight.Parent = ball_2
                possession_highlight.OutlineColor = Color3.new(1, 1, 1)
                possession_highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                possession_highlight.OutlineTransparency = 1
                possession_highlight.FillTransparency = 1
                local tween_properties_3 = { OutlineTransparency = 0 }
                game:GetService("TweenService")
                    :Create(
                        possession_highlight,
                        TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        tween_properties_3
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
                    local teammate_highlight = Instance.new("Highlight")
                    teammate_highlight.Name = "TeammateHighlight"
                    teammate_highlight.Parent = player_3.Character
                    teammate_highlight.OutlineColor = Color3.new(0, 1, 0)
                    teammate_highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                    teammate_highlight.OutlineTransparency = 0.6
                    teammate_highlight.FillTransparency = 1
                    local tween_properties_4 = { OutlineTransparency = 0 }
                    game:GetService("TweenService")
                        :Create(
                            teammate_highlight,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            tween_properties_4
                        )
                        :Play()
                end
            end

            local connection_3 = nil
            local connection = game:GetService("RunService").RenderStepped:Connect(function()
                ball_2 = game.Workspace.Temp:FindFirstChild("Ball")

                if ball_status.lastKicked.Value == local_player then
                    if ball_2 and not (ball_2:FindFirstChild("PossessionHighlight")) then
                        local possession_highlight_2 = Instance.new("Highlight")
                        possession_highlight_2.Name = "PossessionHighlight"
                        possession_highlight_2.Parent = ball_2
                        possession_highlight_2.OutlineColor = Color3.new(1, 1, 1)
                        possession_highlight_2.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        possession_highlight_2.OutlineTransparency = 1
                        possession_highlight_2.FillTransparency = 1
                        local tween_properties_5 = { OutlineTransparency = 0 }
                        game:GetService("TweenService")
                            :Create(
                                possession_highlight_2,
                                TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                tween_properties_5
                            )
                            :Play()
                    end
                else
                    connection_3:Disconnect()
                end
            end)
            connection_3 = connection
            local connection_4 = nil
            local connection_2 = ball_status.lastKicked.Changed:Connect(function()
                if ball_status.lastKicked.Value == local_player then
                    return
                end

                connection_3:Disconnect()
                connection_4:Disconnect()
            end)
            connection_4 = connection_2
        end
    end
end)

game.Workspace.Temp.ChildAdded:Connect(function(child)
    if child.Name ~= "Ball" then
        return
    end

    if ball_status.lastKicked.Value ~= local_player then
        return
    end

    local possession_highlight = Instance.new("Highlight")
    possession_highlight.Name = "PossessionHighlight"
    possession_highlight.Parent = child
    possession_highlight.OutlineColor = Color3.new(1, 1, 1)
    possession_highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    possession_highlight.OutlineTransparency = 1
    possession_highlight.FillTransparency = 1
    local tween_properties_3 = { OutlineTransparency = 0 }
    game:GetService("TweenService")
        :Create(
            possession_highlight,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_3
        )
        :Play()

    for _, player in pairs(game.Players:GetPlayers()) do
        if
            not (player:FindFirstChild("dataLoaded"))
            or player.SelectedTeam.Value ~= local_player.SelectedTeam.Value
        then
            continue
        end

        if player ~= local_player then
            local teammate_highlight = Instance.new("Highlight")
            teammate_highlight.Name = "TeammateHighlight"
            teammate_highlight.Parent = player.Character
            teammate_highlight.OutlineColor = Color3.new(0, 1, 0)
            teammate_highlight.DepthMode = Enum.HighlightDepthMode.Occluded
            teammate_highlight.OutlineTransparency = 0.6
            teammate_highlight.FillTransparency = 1
            local tween_properties_4 = { OutlineTransparency = 0 }
            game:GetService("TweenService")
                :Create(
                    teammate_highlight,
                    TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties_4
                )
                :Play()
        end
    end
end)

game.ReplicatedStorage.Remotes.passMarkerClient.OnClientEvent:Connect(function(position, value)
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
    local tween_properties_3 = { TextTransparency = 0, TextStrokeTransparency = 0 }
    game:GetService("TweenService")
        :Create(
            clone.TitleGui.TextLabel,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_3
        )
        :Play()
    local tween_properties_4 = { Volume = 0.25 }
    game:GetService("TweenService")
        :Create(clone.sfx, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_4)
        :Play()
    clone.fx.circle:Emit(1)
    clone.arrowAttach.arrow:Emit(1)

    task.delay(1.5, function()
        if clone == nil or clone.Parent == nil then
            return
        end

        clone.fx.circle.Enabled = false
        clone.arrowAttach.arrow.Enabled = false
        local tween_properties_5 = { TextTransparency = 1, TextStrokeTransparency = 1 }
        game:GetService("TweenService")
            :Create(
                clone.TitleGui.TextLabel,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_5
            )
            :Play()
        local tween_properties_6 = { Volume = 0 }
        game:GetService("TweenService")
            :Create(clone.sfx, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_6)
            :Play()
        game.Debris:AddItem(clone, 1)
    end)
end)

task.wait(5)
local_player:WaitForChild("dataLoaded")
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
        game.Lighting.ClockTime = 14.5
        game.Lighting.Ambient = Color3.new(0, 0, 0)
        game.Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        game.Workspace.Cloud.Cloud.LightEmission = 0
    else
        game.Lighting.ClockTime = 22
        game.Lighting.Ambient = Color3.new(0, 0, 0)
        game.Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        game.Workspace.Cloud.Cloud.LightEmission = 1
    end
end

doNight()
settings.Misc.Night.Changed:Connect(doNight)

settings.Misc.RainEnabled.Changed:Connect(function()
    if settings.Misc.RainEnabled.Value ~= false then
        game.Workspace.rain:Play()

        for _, child in pairs(game.Lighting:GetChildren()) do
            if child:IsA("Sky") then
                child:Destroy()
            end
        end

        game.ReplicatedStorage.Rainy:Clone().Parent = game.Lighting
        local tween_properties_3 = { Density = 0.2 }
        game:GetService("TweenService")
            :Create(
                game.Lighting.Atmosphere,
                TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_3
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
        local tween_properties_4 = { Density = 0.2 }
        game:GetService("TweenService")
            :Create(
                game.Lighting.Atmosphere,
                TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_4
            )
            :Play()
    end
end)

settings.Misc.StormEnabled.Changed:Connect(function()
    if settings.Misc.StormEnabled.Value ~= false then
        game.Workspace.Rainstorm:Play()

        for _, child in pairs(game.Lighting:GetChildren()) do
            if child:IsA("Sky") then
                child:Destroy()
            end
        end

        game.ReplicatedStorage.Rainy:Clone().Parent = game.Lighting
        local tween_properties_3 = { Density = 0.4 }
        game:GetService("TweenService")
            :Create(
                game.Lighting.Atmosphere,
                TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_3
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
        local tween_properties_4 = { Density = 0.2 }
        game:GetService("TweenService")
            :Create(
                game.Lighting.Atmosphere,
                TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_4
            )
            :Play()
    end
end)

local character = local_player.Character or local_player.CharacterAdded:Wait()

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

if settings.Misc.RainEnabled.Value == true then
    game.Workspace.rain:Play()
    game.Lighting.Sky:Destroy()
    game.ReplicatedStorage.Rainy:Clone().Parent = game.Lighting
    local tween_properties = { Density = 0.2 }
    game:GetService("TweenService")
        :Create(
            game.Lighting.Atmosphere,
            TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
end

if settings.Misc.StormEnabled.Value == true then
    game.Workspace.Rainstorm:Play()
    game.Lighting.Sky:Destroy()
    game.ReplicatedStorage.Rainy:Clone().Parent = game.Lighting
    local tween_properties_2 = { Density = 0.4 }
    game:GetService("TweenService")
        :Create(
            game.Lighting.Atmosphere,
            TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_2
        )
        :Play()
end

local items = {}
local liquid_module = require(script.LiquidModule)

task.spawn(function()
    while task.wait(math.random(1, 5) / 2) do
        if settings.Misc.StormEnabled.Value ~= false then
            local condition = math.random(1, 2) == 1
            formLightning(condition)
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if settings.Misc.RainEnabled.Value == false then
            if settings.Misc.StormEnabled == false then
                continue
            end

            if settings.Misc.RainEnabled.Value == true then
                for _ = 1, math.random(number_2, number_3) do
                    if #items < 400 then
                        local new_water_result = liquid_module.newWater(
                            (game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1))
                                + Vector3.new(math.random(-75, 40), 325, math.random(-75, 40)),
                            Vector3.new(math.random(35, 45), -100, math.random(40, 60))
                        )
                        table.insert(items, new_water_result)

                        new_water_result.Destroying:Once(function()
                            table.remove(items, table.find(items, new_water_result))
                        end)
                    end
                end
            elseif settings.Misc.StormEnabled.Value == true then
                for _ = 1, math.random(number_2, number_3 * 2) do
                    if #items < 400 then
                        local new_water_result_2 = liquid_module.newWater(
                            (game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1))
                                + Vector3.new(math.random(-75, 40), 325, math.random(-75, 40)),
                            Vector3.new(math.random(35, 45), -100, math.random(40, 60))
                        )
                        table.insert(items, new_water_result_2)

                        new_water_result_2.Destroying:Once(function()
                            table.remove(items, table.find(items, new_water_result_2))
                        end)
                    end
                end
            end
        elseif settings.Misc.RainEnabled.Value == true then
            for _ = 1, math.random(number_2, number_3) do
                if #items < 400 then
                    local new_water_result_3 = liquid_module.newWater(
                        (game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1))
                            + Vector3.new(math.random(-75, 40), 325, math.random(-75, 40)),
                        Vector3.new(math.random(35, 45), -100, math.random(40, 60))
                    )
                    table.insert(items, new_water_result_3)

                    new_water_result_3.Destroying:Once(function()
                        table.remove(items, table.find(items, new_water_result_3))
                    end)
                end
            end
        elseif settings.Misc.StormEnabled.Value == true then
            for _ = 1, math.random(number_2, number_3 * 2) do
                if #items < 400 then
                    local new_water_result_4 = liquid_module.newWater(
                        (game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1))
                            + Vector3.new(math.random(-75, 40), 325, math.random(-75, 40)),
                        Vector3.new(math.random(35, 45), -100, math.random(40, 60))
                    )
                    table.insert(items, new_water_result_4)

                    new_water_result_4.Destroying:Once(function()
                        table.remove(items, table.find(items, new_water_result_4))
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

game.ReplicatedStorage.Remotes.PSCommand.OnClientEvent:Connect(function(argument)
    game.TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(argument)
end)
