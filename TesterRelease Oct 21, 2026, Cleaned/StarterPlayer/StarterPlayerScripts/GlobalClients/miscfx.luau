local ball_status = game.Workspace.ballStatus
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key_handler_service = knit.GetService("KeyHandlerService")

key_handler_service:GetKey("SharpEyesClient").OnClientEvent:Connect(function()
    game:GetService("TweenService")
        :Create(game.Lighting.ColorCorrection, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TintColor = Color3.fromRGB(243, 171, 172),
        })
        :Play()
    local ball = game.Workspace.Temp:FindFirstChild("Ball") or game.Workspace.Temp:WaitForChild("Ball")

    if not ball then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Parent = ball
    highlight.Name = "SharpEyeHighlight"
    highlight.FillColor = Color3.new(0.839216, 0, 0)
    highlight.OutlineTransparency = 1
    highlight.FillTransparency = 1
    game:GetService("TweenService")
        :Create(highlight, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            FillTransparency = 0,
        })
        :Play()
    local connection_3 = game:GetService("RunService").RenderStepped:Connect(function()
        if
            not (
                game.Workspace.Temp:FindFirstChild("Ball")
                and not game.Workspace.Temp.Ball:FindFirstChild("SharpEyeHighlight")
            )
        then
            return
        end

        local highlight2 = Instance.new("Highlight")
        highlight2.Parent = ball
        highlight2.Name = "SharpEyeHighlight"
        highlight2.FillColor = Color3.new(0.839216, 0, 0)
        highlight2.OutlineTransparency = 1
        highlight2.FillTransparency = 1
        game:GetService("TweenService")
            :Create(highlight2, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                FillTransparency = 0,
            })
            :Play()
    end)
    local connection_4 = ball_status.lastKicked.Changed:Connect(function()
        if ball_status.lastKicked.Value == nil then
            return
        end

        for _, child in pairs(game.Workspace.CharacterContainer:GetChildren()) do
            for _, child2 in pairs(child:GetChildren()) do
                if child2.Name == "SharpEyeHighlight" then
                    child2:Destroy()
                end
            end
        end

        local color3 = Color3.new(0.839216, 0.486275, 0.486275)

        if ball_status.lastKicked.Value.SelectedTeam.Value == game.Players.LocalPlayer.SelectedTeam.Value then
            color3 = Color3.new(0, 1, 0)
        end

        local highlight2 = Instance.new("Highlight")
        highlight2.Parent = ball_status.lastKicked.Value.Character
        highlight2.Name = "SharpEyeHighlight"
        highlight2.FillColor = color3
        highlight2.OutlineTransparency = 1
        highlight2.FillTransparency = 1
        game:GetService("TweenService")
            :Create(highlight2, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                FillTransparency = 0,
            })
            :Play()
    end)

    task.delay(10, function()
        connection_3:Disconnect()
        connection_4:Disconnect()

        if game.Workspace.Temp:FindFirstChild("Ball") then
            for _, child in pairs(game.Workspace.Temp.Ball:GetChildren()) do
                if child:IsA("Highlight") and child.Name == "SharpEyeHighlight" then
                    game:GetService("TweenService")
                        :Create(child, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            FillTransparency = 1,
                        })
                        :Play()
                    game.Debris:AddItem(child, 2)
                end
            end
        end

        for _, child_2 in pairs(game.Workspace.CharacterContainer:GetChildren()) do
            for _, child2 in pairs(child_2:GetChildren()) do
                if child2.Name == "SharpEyeHighlight" then
                    child2:Destroy()
                end
            end
        end

        game:GetService("TweenService")
            :Create(
                game.Lighting.ColorCorrection,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    TintColor = Color3.new(1, 1, 1),
                }
            )
            :Play()
    end)
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
            game:GetService("TweenService")
                :Create(child_entry, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Volume = 2,
                })
                :Play()

            task.delay(8, function()
                game:GetService("TweenService")
                    :Create(child_entry, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Volume = 0,
                    })
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
            game:GetService("TweenService")
                :Create(child_entry, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Volume = 2,
                })
                :Play()

            task.delay(24.2, function()
                game:GetService("TweenService")
                    :Create(child_entry, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Volume = 0,
                    })
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
            game:GetService("TweenService")
                :Create(child_entry, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Volume = 2,
                })
                :Play()

            task.delay(argument, function()
                game:GetService("TweenService")
                    :Create(child_entry, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Volume = 0,
                    })
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
local _ = local_player.Settings.Misc

local function get_most_or_least_z(argument, enabled)
    if enabled == true then
        local number_4 = 15.807
        local value = nil

        for _, player in ipairs(argument) do
            if player.Character and number_4 < player.Character.HumanoidRootPart.Position.Z then
                number_4 = player.Character.HumanoidRootPart.Position.Z
                value = player
            end
        end

        return value
    end

    local number_5 = 15.807
    local value_2 = nil

    for _, player_2 in ipairs(argument) do
        if player_2.Character and player_2.Character.HumanoidRootPart.Position.Z < number_5 then
            number_5 = player_2.Character.HumanoidRootPart.Position.Z
            value_2 = player_2
        end
    end

    return value_2
end

ball_status.lastKicked.Changed:Connect(function()
    if ball_status.lastKicked.Value ~= local_player or local_player.Settings.Misc.Highlights.Value ~= true then
        local ball = game.Workspace.Temp:FindFirstChild("Ball")

        if ball then
            for _, child in pairs(ball:GetChildren()) do
                if child.Name == "PossessionHighlight" then
                    child:Destroy()
                end
            end
        end

        for _, player in pairs(game.Players:GetPlayers()) do
            if
                player.Character ~= nil
                and (
                    player.Character:FindFirstChild("TeammateHighlight")
                    or player.Character:FindFirstChild("OffsideHighlight")
                )
            then
                for _, child_2 in pairs(player.Character:GetChildren()) do
                    if child_2.Name == "TeammateHighlight" then
                        child_2:Destroy()
                    end

                    if child_2.Name == "OffsideHighlight" then
                        child_2:Destroy()
                    end
                end
            end
        end

        return
    end

    local ball_2 = game.Workspace.Temp:FindFirstChild("Ball")

    if ball_2 then
        local highlight = Instance.new("Highlight")
        highlight.Name = "PossessionHighlight"
        highlight.Parent = ball_2
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.OutlineTransparency = 1
        highlight.FillTransparency = 1
        game:GetService("TweenService")
            :Create(highlight, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                OutlineTransparency = 0,
            })
            :Play()
    end

    for _, player_2 in pairs(game.Players:GetPlayers()) do
        if
            player_2:FindFirstChild("dataLoaded")
            and (player_2.SelectedTeam.Value == local_player.SelectedTeam.Value and player_2 ~= local_player)
        then
            local highlight_2 = Instance.new("Highlight")
            highlight_2.Name = "TeammateHighlight"
            highlight_2.Parent = player_2.Character
            highlight_2.OutlineColor = Color3.new(0, 1, 0)
            highlight_2.DepthMode = Enum.HighlightDepthMode.Occluded
            highlight_2.OutlineTransparency = 0.6
            highlight_2.FillTransparency = 1
            game:GetService("TweenService")
                :Create(highlight_2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    OutlineTransparency = 0,
                })
                :Play()
        end
    end

    local connection_3 = nil
    connection_3 = game:GetService("RunService").RenderStepped:Connect(function()
        if ball_status.lastKicked.Value ~= local_player then
            connection_3:Disconnect()

            return
        end

        if local_player.SelectedTeam.Value == "Home" then
            local items_2 = {}

            for _, player_3 in pairs(game.Players:GetPlayers()) do
                if
                    player_3.SelectedPosition.Value ~= "GK"
                    and (
                        player_3:FindFirstChild("InPlay")
                        and player_3.SelectedTeam.Value ~= local_player.SelectedTeam.Value
                    )
                then
                    table.insert(items_2, player_3)
                end
            end

            local number_4 = 15.807
            local player_7 = nil

            for _, player_8 in ipairs(items_2) do
                if player_8.Character and number_4 < player_8.Character.HumanoidRootPart.Position.Z then
                    number_4 = player_8.Character.HumanoidRootPart.Position.Z
                    player_7 = player_8
                end
            end

            if player_7 and not player_7.Character:FindFirstChild("OffsideHighlight") then
                local highlight_3 = Instance.new("Highlight")
                highlight_3.Name = "OffsideHighlight"
                highlight_3.Parent = player_7.Character
                highlight_3.OutlineColor = Color3.new(1, 0, 0)
                highlight_3.DepthMode = Enum.HighlightDepthMode.Occluded
                highlight_3.OutlineTransparency = 0.6
                highlight_3.FillTransparency = 1
                game:GetService("TweenService")
                    :Create(highlight_3, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        OutlineTransparency = 0,
                    })
                    :Play()

                for _, player_4 in pairs(game.Players:GetPlayers()) do
                    if player_4 ~= player_7 and player_4.Character:FindFirstChild("OffsideHighlight") then
                        player_4.Character.OffsideHighlight:Destroy()
                    end
                end
            end
        elseif local_player.SelectedTeam.Value == "Away" then
            local items_3 = {}

            for _, player_5 in pairs(game.Players:GetPlayers()) do
                if
                    player_5.SelectedPosition.Value ~= "GK"
                    and (
                        player_5:FindFirstChild("InPlay")
                        and player_5.SelectedTeam.Value ~= local_player.SelectedTeam.Value
                    )
                then
                    table.insert(items_3, player_5)
                end
            end

            local number_5 = 15.807
            local player_9 = nil

            for _, player_10 in ipairs(items_3) do
                if player_10.Character and player_10.Character.HumanoidRootPart.Position.Z < number_5 then
                    number_5 = player_10.Character.HumanoidRootPart.Position.Z
                    player_9 = player_10
                end
            end

            if player_9 and not player_9.Character:FindFirstChild("OffsideHighlight") then
                local highlight_4 = Instance.new("Highlight")
                highlight_4.Name = "OffsideHighlight"
                highlight_4.Parent = player_9.Character
                highlight_4.OutlineColor = Color3.new(1, 0, 0)
                highlight_4.DepthMode = Enum.HighlightDepthMode.Occluded
                highlight_4.OutlineTransparency = 0.6
                highlight_4.FillTransparency = 1
                game:GetService("TweenService")
                    :Create(highlight_4, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        OutlineTransparency = 0,
                    })
                    :Play()

                for _, player_6 in pairs(game.Players:GetPlayers()) do
                    if player_6 ~= player_9 and player_6.Character:FindFirstChild("OffsideHighlight") then
                        player_6.Character.OffsideHighlight:Destroy()
                    end
                end
            end
        end

        if not (ball_2 and not ball_2:FindFirstChild("PossessionHighlight")) then
            return
        end

        local highlight_5 = Instance.new("Highlight")
        highlight_5.Name = "PossessionHighlight"
        highlight_5.Parent = ball_2
        highlight_5.OutlineColor = Color3.new(1, 1, 1)
        highlight_5.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight_5.OutlineTransparency = 1
        highlight_5.FillTransparency = 1
        game:GetService("TweenService")
            :Create(highlight_5, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                OutlineTransparency = 0,
            })
            :Play()
    end)
    local connection_4 = nil
    connection_4 = ball_status.lastKicked.Changed:Connect(function()
        if ball_status.lastKicked.Value ~= local_player then
            connection_3:Disconnect()
            connection_4:Disconnect()
        end
    end)
end)

game.Workspace.Temp.ChildAdded:Connect(function(child)
    if not (child.Name == "Ball" and ball_status.lastKicked.Value == local_player) then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "PossessionHighlight"
    highlight.Parent = child
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    highlight.OutlineTransparency = 1
    highlight.FillTransparency = 1
    game:GetService("TweenService")
        :Create(highlight, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            OutlineTransparency = 0,
        })
        :Play()

    for _, player in pairs(game.Players:GetPlayers()) do
        if
            player:FindFirstChild("dataLoaded")
            and (player.SelectedTeam.Value == local_player.SelectedTeam.Value and player ~= local_player)
        then
            local highlight2 = Instance.new("Highlight")
            highlight2.Name = "TeammateHighlight"
            highlight2.Parent = player.Character
            highlight2.OutlineColor = Color3.new(0, 1, 0)
            highlight2.DepthMode = Enum.HighlightDepthMode.Occluded
            highlight2.OutlineTransparency = 0.6
            highlight2.FillTransparency = 1
            game:GetService("TweenService")
                :Create(highlight2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    OutlineTransparency = 0,
                })
                :Play()
        end
    end
end)

key_handler_service:GetKey("passMarkerClient").OnClientEvent:Connect(function(position, value)
    for _, child in pairs(game.Workspace.FX:GetChildren()) do
        if child:FindFirstChild("owner") and (child.Name == "PassMarker" and child.owner.Value == value) then
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
    game:GetService("TweenService")
        :Create(clone.TitleGui.TextLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0,
            TextStrokeTransparency = 0,
        })
        :Play()
    game:GetService("TweenService")
        :Create(clone.sfx, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Volume = 0.25,
        })
        :Play()
    clone.fx.circle:Emit(1)
    clone.arrowAttach.arrow:Emit(1)

    task.delay(1.5, function()
        if clone == nil or clone.Parent == nil then
            return
        end

        clone.fx.circle.Enabled = false
        clone.arrowAttach.arrow.Enabled = false
        game:GetService("TweenService")
            :Create(clone.TitleGui.TextLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 1,
                TextStrokeTransparency = 1,
            })
            :Play()
        game:GetService("TweenService")
            :Create(clone.sfx, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Volume = 0,
            })
            :Play()
        game.Debris:AddItem(clone, 1)
    end)
end)

local _ = game.ReplicatedStorage.Map
local lobby = workspace:WaitForChild("Lobby")

local_player.ChildAdded:Connect(function(child)
    if child.Name == "InPlay" and game.Workspace:FindFirstChild("Lobby") then
        lobby.Parent = game.ReplicatedStorage
    end
end)

local_player.ChildRemoved:Connect(function(child)
    if child.Name == "InPlay" and not game.Workspace:FindFirstChild("Lobby") then
        lobby.Parent = workspace
    end
end)

game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LoadMapClient").OnClientEvent:Connect(function()
    game.Lighting.Blur.Size = 2

    if not game.Workspace:FindFirstChild("Lobby") then
        lobby.Parent = workspace
    end
end)

key_handler_service:GetKey("SetCharInvisible").OnClientEvent:Connect(function(instance, enabled)
    if enabled ~= true then
        if enabled == false then
            for _, child in pairs(instance:GetChildren()) do
                if
                    child:IsA("BasePart")
                    and (
                        child.Name ~= "BallWeldPos"
                        and (
                            child.Name ~= "Hand"
                            and (
                                child.Name ~= "HumanoidRootPart"
                                and (
                                    child.Name ~= "Neck_CameraSubject"
                                    and (child.Name ~= "SlipCone" and child.Name ~= "CollisionBox")
                                )
                            )
                        )
                    )
                then
                    child.Transparency = 0
                end

                if child:IsA("Accessory") then
                    for _, child2 in pairs(child:GetChildren()) do
                        if child2:IsA("BasePart") then
                            child2.Transparency = 0
                        end
                    end
                end
            end
        end

        return
    end

    for _, child_2 in pairs(instance:GetChildren()) do
        if child_2:IsA("BasePart") then
            child_2.Transparency = 1
        end

        if child_2:IsA("Accessory") then
            for _, child2_2 in pairs(child_2:GetChildren()) do
                if child2_2:IsA("BasePart") then
                    child2_2.Transparency = 1
                end
            end
        end
    end

    local connection_3 = instance.ChildAdded:Connect(function(child_4)
        if child_4:IsA("Accessory") then
            for _, child_3 in pairs(child_4:GetChildren()) do
                if child_3:IsA("BasePart") then
                    child_3.Transparency = 1
                end
            end
        end
    end)

    task.delay(5, function()
        connection_3:Disconnect()
    end)
end)

local_player:WaitForChild("dataLoaded")
require(game.ReplicatedStorage.Modules:WaitForChild("ScreenRain"))
local saved_quality_level = UserSettings().GameSettings.SavedQualityLevel
local number = 0
local number_2 = 5
local number_3 = 10

function doGFXLevel()
    if saved_quality_level == Enum.SavedQualitySetting.Automatic then
        number = 0.5
    elseif saved_quality_level == Enum.SavedQualitySetting.QualityLevel10 then
        number = 1
    else
        local text = "0." .. string.sub(saved_quality_level.Name, 13)
        number = tonumber(text)
    end

    if number < 0.8 then
        number_2 = 10
        number_3 = 20

        if number < 0.5 then
            number_2 = 8
            number_3 = 16

            if number < 0.25 then
                number_2 = 5
                number_3 = 10
            end
        end
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
    if settings.Misc.GrassVisuals.Value == true then
        game.Workspace.Terrain:FillBlock(
            CFrame.new(Vector3.new(267, -10.25, 20)),
            Vector3.new(800, 32, 800),
            Enum.Material.Grass
        )

        return
    end

    game.Workspace.Terrain:Clear()
end

task.delay(5, function()
    doGrass()
end)

settings.Misc.GrassVisuals.Changed:Connect(doGrass)
game.Workspace:WaitForChild("Cloud")

function doNight()
    if settings.Misc.Night.Value == true then
        for _, descendant in ipairs(workspace.miscFX.NightLights:GetDescendants()) do
            if descendant:IsA("SurfaceLight") then
                if
                    settings.Misc.MapSelection.Value == "Blue Lock Chamber" and descendant.Parent:GetAttribute("Higher")
                then
                    descendant.Enabled = false
                else
                    descendant.Enabled = true
                end
            end
        end

        game.Lighting.ClockTime = 22
        game.Lighting.Atmosphere.Haze = 0.2

        if settings.Misc.MapSelection.Value == "Blue Lock Chamber" then
            game.Lighting.Ambient = Color3.new(0.882353, 0.882353, 0.882353)
            game.Lighting.OutdoorAmbient = Color3.new(0.882353, 0.882353, 0.882353)
        else
            game.Lighting.Ambient = Color3.new(0, 0, 0)
            game.Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        end

        game.Workspace.Cloud.Cloud.Transparency = NumberSequence.new(0.8)
        game.Workspace.Cloud.Cloud.LightEmission = 1

        return
    end

    for _, descendant_2 in ipairs(workspace.miscFX.NightLights:GetDescendants()) do
        if descendant_2:IsA("SurfaceLight") then
            descendant_2.Enabled = false
        end
    end

    game.Lighting.Atmosphere.Haze = 2.07
    game.Lighting.ClockTime = 13.5
    game.Lighting.Ambient = Color3.new(0, 0, 0)
    game.Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
    game.Workspace.Cloud.Cloud.Transparency = NumberSequence.new(0)
    game.Workspace.Cloud.Cloud.LightEmission = 0
end

doNight()
settings.Misc.Night.Changed:Connect(doNight)
local character = local_player.Character or local_player.CharacterAdded:Wait()
local connection = nil

function doCinematic()
    if settings.Misc.CinematicMode.Value ~= true then
        if settings.Misc.CinematicMode.Value == false then
            local_player.PlayerGui.ScoreAndTimer.Enabled = true
            local_player.PlayerGui.HUD.Enabled = true
            character.HumanoidRootPart.UIAttach.ChargeGUI.Enabled = true
        end

        return
    end

    local_player.PlayerGui.ScoreAndTimer.Enabled = false
    local_player.PlayerGui.HUD.Enabled = false
    character.HumanoidRootPart.UIAttach.ChargeGUI.Enabled = false
end

doCinematic()
settings.Misc.CinematicMode.Changed:Connect(doCinematic)

function doRain()
    if settings.Misc.RainEnabled.Value == false then
        game.Workspace.rain:Stop()

        for _, child in pairs(game.Lighting:GetChildren()) do
            if child:IsA("Sky") then
                child:Destroy()
            end
        end

        game.ReplicatedStorage.Sky:Clone().Parent = game.Lighting
        game:GetService("TweenService")
            :Create(game.Lighting.Atmosphere, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Density = 0.2,
            })
            :Play()

        return
    end

    game.Workspace.rain:Play()

    for _, child_2 in pairs(game.Lighting:GetChildren()) do
        if child_2:IsA("Sky") then
            child_2:Destroy()
        end
    end

    game.ReplicatedStorage.Rainy:Clone().Parent = game.Lighting
    game:GetService("TweenService")
        :Create(game.Lighting.Atmosphere, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Density = 0.2,
        })
        :Play()
end

doRain()
settings.Misc.RainEnabled.Changed:Connect(doRain)

function doStorm()
    if settings.Misc.StormEnabled.Value == false then
        game.Workspace.Rainstorm:Stop()

        for _, child in pairs(game.Lighting:GetChildren()) do
            if child:IsA("Sky") then
                child:Destroy()
            end
        end

        game.ReplicatedStorage.Sky:Clone().Parent = game.Lighting
        game:GetService("TweenService")
            :Create(game.Lighting.Atmosphere, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Density = 0.2,
            })
            :Play()

        return
    end

    game.Workspace.Rainstorm:Play()

    for _, child_2 in pairs(game.Lighting:GetChildren()) do
        if child_2:IsA("Sky") then
            child_2:Destroy()
        end
    end

    game.ReplicatedStorage.Rainy:Clone().Parent = game.Lighting
    game:GetService("TweenService")
        :Create(game.Lighting.Atmosphere, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Density = 0.4,
        })
        :Play()
end

doStorm()
settings.Misc.StormEnabled.Changed:Connect(doStorm)
local parent = nil
local connection_2 = nil

function doSnow()
    if settings.Misc.SnowEnabled.Value == false then
        if connection_2 then
            connection_2:Disconnect()
        end

        game.Workspace.Terrain:SetMaterialColor(Enum.Material.Grass, Color3.new(0, 0.52549, 0.121569))
        game.Workspace.Snowstorm:Stop()

        for _, child in pairs(game.Lighting:GetChildren()) do
            if child:IsA("Sky") then
                child:Destroy()
            end
        end

        game.ReplicatedStorage.Sky:Clone().Parent = game.Lighting

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
        game:GetService("TweenService")
            :Create(game.Lighting.Atmosphere, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Density = 0.2,
            })
            :Play()

        return
    end

    game.Workspace.Snowstorm:Play()
    game.Workspace.Terrain:SetMaterialColor(Enum.Material.Grass, Color3.new(1, 1, 1))
    game.Lighting.Sky:Destroy()
    game.ReplicatedStorage.Rainy:Clone().Parent = game.Lighting
    game:GetService("TweenService")
        :Create(game.Lighting.Atmosphere, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Density = 0.25,
        })
        :Play()

    for _, child_3 in ipairs(workspace.gameArea.Grass:GetChildren()) do
        child_3.MaterialVariant = "SnowyGrass"
        child_3.Color = Color3.new(0.886275, 0.886275, 0.886275)

        if child_3:IsA("UnionOperation") then
            child_3.UsePartColor = true
        end
    end

    workspace.gameArea.Surround.MaterialVariant = "SnowyGrass"
    workspace.gameArea.Surround.Color = Color3.new(0.886275, 0.886275, 0.886275)
    workspace.gameArea.Surround.UsePartColor = true
    connection_2 = game.Workspace.gameArea.Grass.ChildAdded:Connect(function(child_4)
        if child_4.Name == "FieldBase" then
            child_4.MaterialVariant = "SnowyGrass"
            child_4.Color = Color3.new(0.886275, 0.886275, 0.886275)
        end
    end)
end

doSnow()
settings.Misc.SnowEnabled.Changed:Connect(doSnow)

function doSeasonal()
    if settings.Misc.Seasonal.Value == false then
        if settings.Misc.SnowEnabled.Value == false then
            if connection then
                connection:Disconnect()
            end

            game.Workspace.Terrain:SetMaterialColor(Enum.Material.Grass, Color3.new(0, 0.52549, 0.121569))

            for _, child in ipairs(workspace.gameArea.Grass:GetChildren()) do
                child.MaterialVariant = ""
                child.Color = Color3.new(0.172549, 0.6, 0.0980392)

                if child:IsA("UnionOperation") then
                    child.UsePartColor = false
                end
            end

            workspace.gameArea.Surround.MaterialVariant = ""
            workspace.gameArea.Surround.Color = Color3.new(0.172549, 0.6, 0.0980392)
            workspace.gameArea.Surround.UsePartColor = false
        end
    else
        game.Workspace.Terrain:SetMaterialColor(Enum.Material.Grass, Color3.fromRGB(181, 181, 181))

        for _, child_2 in ipairs(workspace.gameArea.Grass:GetChildren()) do
            child_2.MaterialVariant = ""
            child_2.Color = Color3.fromRGB(181, 181, 181)

            if child_2:IsA("UnionOperation") then
                child_2.UsePartColor = true
            end
        end

        workspace.gameArea.Surround.MaterialVariant = ""
        workspace.gameArea.Surround.Color = Color3.fromRGB(134, 81, 60)
        workspace.gameArea.Surround.UsePartColor = true
        connection = game.Workspace.gameArea.Grass.ChildAdded:Connect(function(child_3)
            if child_3.Name == "FieldBase" then
                child_3.MaterialVariant = ""
                child_3.Color = Color3.fromRGB(134, 81, 60)
            end
        end)
    end
end

doSeasonal()
settings.Misc.Seasonal.Changed:Connect(doSeasonal)
local items = {}
local script_liquid_module = require(script.LiquidModule)

task.spawn(function()
    while task.wait(math.random(1, 5) / 2) do
        if settings.Misc.StormEnabled.Value ~= false then
            formLightning(math.random(1, 2) == 1)
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if
            settings.Misc.RainEnabled.Value ~= false
            or (settings.Misc.SnowEnabled ~= false or settings.Misc.StormEnabled ~= false)
        then
            if settings.Misc.RainEnabled.Value == true then
                for index = 1, math.random(number_2, number_3) do
                    local index_3

                    if #items < 400 then
                        local product = game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1)
                        local random_value = math.random(-75, 40)
                        local sum = product + Vector3.new(random_value, 67.5, math.random(-75, 40))
                        local new_water = script_liquid_module.newWater
                        local random_value_2 = math.random(35, 45)
                        local result = new_water(sum, (Vector3.new(random_value_2, -100, math.random(40, 60))))
                        table.insert(items, result)

                        result.Destroying:Once(function()
                            table.remove(items, table.find(items, result))
                        end)

                        index_3 = index
                    else
                        index_3 = index
                    end
                end
            elseif settings.Misc.SnowEnabled.Value == true and local_player:FindFirstChild("InPlay") then
                if not parent then
                    parent = Instance.new("Part")
                    parent.Size = Vector3.new(125, 0.1, 125)
                    parent.Transparency = 1
                    parent.CanCollide = false
                    parent.CanTouch = false
                    parent.CanQuery = false
                    parent.Anchored = true
                    parent.Parent = game.Workspace.FX
                    game.ReplicatedStorage.VFX.snowParticle:Clone().Parent = parent
                end

                parent.Position = Vector3.new(
                    game.Workspace.CurrentCamera.CFrame.Position.X,
                    50,
                    game.Workspace.CurrentCamera.CFrame.Position.Z
                )
            elseif settings.Misc.StormEnabled.Value == true then
                for index_2 = 1, math.random(number_2, number_3 * 2) do
                    local index_4

                    if #items < 400 then
                        local product_2 = game.Workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1)
                        local random_value_3 = math.random(-75, 40)
                        local sum_2 = product_2 + Vector3.new(random_value_3, 67.5, math.random(-75, 40))
                        local new_water_2 = script_liquid_module.newWater
                        local random_value_4 = math.random(35, 45)
                        local result_2 = new_water_2(sum_2, (Vector3.new(random_value_4, -100, math.random(40, 60))))
                        table.insert(items, result_2)

                        result_2.Destroying:Once(function()
                            table.remove(items, table.find(items, result_2))
                        end)

                        index_4 = index_2
                    else
                        index_4 = index_2
                    end
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
    local position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    local random_value = math.random(-1250, 1250)
    part.Position = position + Vector3.new(random_value, 0, math.random(-1250, 1250))
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
