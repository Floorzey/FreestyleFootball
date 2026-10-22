local upper_shutter = script.Parent.UpperShutter
local lower_shutter = script.Parent.LowerShutter
local game_end = script.Parent.GameEnd
local bottom_frame = script.Parent.bottomFrame
local mvp = bottom_frame.MVP
local top_score = bottom_frame.topScore
local top_assists = bottom_frame.topAssists
local top_frame = script.Parent.topFrame
local rewards_frame = script.Parent.RewardsFrame
local team_info = game.ReplicatedStorage.TeamInfo
local current_camera = workspace.CurrentCamera
lower_shutter.Size = UDim2.new(1, 0, 0.55, 0)
upper_shutter.Size = UDim2.new(1, 0, 0.55, 0)
script.Parent.LOADING.Visible = true
local number = 1

while true do
    task.wait(0.3)

    if number == 1 then
        script.Parent.LOADING.Text = "LOADING."
    elseif number == 2 then
        script.Parent.LOADING.Text = "LOADING.."
    elseif number == 3 then
        script.Parent.LOADING.Text = "LOADING..."
        number = 0
    end

    local sum = number + 1

    if game.Players.LocalPlayer:FindFirstChild("dataLoaded") then
        break
    end

    number = sum
end

local tween_service = game:GetService("TweenService")
local tween_info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tween_properties = {}
tween_properties.Size = UDim2.new(1, 0, 0, 0)
tween_service:Create(lower_shutter, tween_info, tween_properties):Play()
local tween_service_2 = game:GetService("TweenService")
local tween_info_2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tween_properties_2 = {}
tween_properties_2.Size = UDim2.new(1, 0, 0, 0)
tween_service_2:Create(upper_shutter, tween_info_2, tween_properties_2):Play()
local tween_properties_3 = { TextTransparency = 1, TextStrokeTransparency = 1 }
game:GetService("TweenService")
    :Create(
        script.Parent.LOADING,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        tween_properties_3
    )
    :Play()

task.delay(0.5, function()
    script.Parent.LOADING.Visible = false
end)

function shutter()
    upper_shutter.Visible = true
    lower_shutter.Visible = true
    local tween_service_3 = game:GetService("TweenService")
    local tween_info_3 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_4 = {}
    tween_properties_4.Size = UDim2.new(1, 0, 0.55, 0)
    tween_service_3:Create(lower_shutter, tween_info_3, tween_properties_4):Play()
    local tween_service_4 = game:GetService("TweenService")
    local tween_info_4 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_5 = {}
    tween_properties_5.Size = UDim2.new(1, 0, 0.55, 0)
    tween_service_4:Create(upper_shutter, tween_info_4, tween_properties_5):Play()

    task.delay(2, function()
        game.Lighting.Blur.Size = 2
        task.wait(0.5)
        local tween_service_5 = game:GetService("TweenService")
        local tween_info_5 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_6 = {}
        tween_properties_6.Size = UDim2.new(1, 0, 0, 0)
        tween_service_5:Create(lower_shutter, tween_info_5, tween_properties_6):Play()
        local tween_service_6 = game:GetService("TweenService")
        local tween_info_6 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_7 = {}
        tween_properties_7.Size = UDim2.new(1, 0, 0, 0)
        tween_service_6:Create(upper_shutter, tween_info_6, tween_properties_7):Play()
        task.wait(0.5)
        upper_shutter.Visible = false
        lower_shutter.Visible = false
    end)
end

function rewardsDisplay(argument, argument_2)
    local tween_properties_4 = { BackgroundTransparency = 0 }
    game:GetService("TweenService")
        :Create(
            rewards_frame.lineDivider,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_4
        )
        :Play()
    local tween_properties_5 = { TextTransparency = 0 }
    game:GetService("TweenService")
        :Create(
            rewards_frame.Coins,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_5
        )
        :Play()
    local tween_properties_6 = { TextSize = 25 }
    game:GetService("TweenService")
        :Create(
            rewards_frame.Coins,
            TweenInfo.new(1.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            tween_properties_6
        )
        :Play()
    local tween_properties_7 = { TextTransparency = 0 }
    game:GetService("TweenService")
        :Create(
            rewards_frame.EXP,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_7
        )
        :Play()
    local tween_properties_8 = { TextSize = 25 }
    game:GetService("TweenService")
        :Create(
            rewards_frame.EXP,
            TweenInfo.new(1.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            tween_properties_8
        )
        :Play()
    local tween_properties_9 = { ImageTransparency = 0 }
    game:GetService("TweenService")
        :Create(
            rewards_frame.CoinsImage,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_9
        )
        :Play()
    local tween_service_3 = game:GetService("TweenService")
    local tween_info_3 = TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_10 = {}
    tween_properties_10.Size = UDim2.new(0, 60, 0, 60)
    tween_service_3:Create(rewards_frame.CoinsImage, tween_info_3, tween_properties_10):Play()
    local tween_properties_11 = { ImageTransparency = 0 }
    game:GetService("TweenService")
        :Create(
            rewards_frame.EXPImage,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_11
        )
        :Play()
    local tween_service_4 = game:GetService("TweenService")
    local tween_info_4 = TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_12 = {}
    tween_properties_12.Size = UDim2.new(0, 60, 0, 60)
    tween_service_4:Create(rewards_frame.EXPImage, tween_info_4, tween_properties_12):Play()
    local clone = game.ReplicatedStorage.UISounds.ui_starbar_fill:Clone()
    clone.Parent = game.Workspace
    clone:Play()
    game.Debris:AddItem(clone, 3)
    rewards_frame.EXP.Text = "+0 EXP"
    rewards_frame.Coins.Text = "+0 COINS"

    task.spawn(function()
        local rounded_value = math.floor(argument_2 / 84)

        for n = 1, 84 do
            rewards_frame.EXP.Text = "+" .. rounded_value * n .. " EXP"
            game:GetService("RunService").RenderStepped:Wait()
        end

        local tween_service_5 = game:GetService("TweenService")
        local tween_info_5 = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local tween_properties_13 = {}
        tween_properties_13.Size = UDim2.new(0, 75, 0, 75)
        tween_service_5:Create(rewards_frame.EXPImage, tween_info_5, tween_properties_13):Play()
        local tween_properties_14 = { TextSize = 30 }
        game:GetService("TweenService")
            :Create(
                rewards_frame.EXP,
                TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                tween_properties_14
            )
            :Play()
    end)

    task.spawn(function()
        local rounded_value = math.floor(argument / 84)

        for n = 1, 84 do
            rewards_frame.Coins.Text = "+" .. rounded_value * n .. " COINS"
            game:GetService("RunService").RenderStepped:Wait()
        end

        local tween_service_5 = game:GetService("TweenService")
        local tween_info_5 = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local tween_properties_13 = {}
        tween_properties_13.Size = UDim2.new(0, 75, 0, 75)
        tween_service_5:Create(rewards_frame.CoinsImage, tween_info_5, tween_properties_13):Play()
        local tween_properties_14 = { TextSize = 30 }
        game:GetService("TweenService")
            :Create(
                rewards_frame.Coins,
                TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                tween_properties_14
            )
            :Play()
    end)

    task.delay(1.4, function()
        local clone_2 = game.ReplicatedStorage.UISounds.ui_starbar_launch:Clone()
        clone_2.Parent = game.Workspace
        clone_2:Play()
        game.Debris:AddItem(clone_2, 3)
        local clone_3 = game.ReplicatedStorage.UISounds.ui_count_complete:Clone()
        clone_3.Parent = game.Workspace
        clone_3:Play()
        game.Debris:AddItem(clone_3, 3)
        task.wait(2.5)
        local tween_properties_13 = { BackgroundTransparency = 1 }
        game:GetService("TweenService")
            :Create(
                rewards_frame.lineDivider,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_13
            )
            :Play()
        local tween_properties_14 = { TextTransparency = 1 }
        game:GetService("TweenService")
            :Create(
                rewards_frame.Coins,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_14
            )
            :Play()
        local tween_properties_15 = { TextTransparency = 1 }
        game:GetService("TweenService")
            :Create(
                rewards_frame.EXP,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_15
            )
            :Play()
        local tween_properties_16 = { ImageTransparency = 1 }
        game:GetService("TweenService")
            :Create(
                rewards_frame.CoinsImage,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_16
            )
            :Play()
        local tween_service_5 = game:GetService("TweenService")
        local tween_info_5 = TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_17 = {}
        tween_properties_17.Size = UDim2.new(0, 50, 0, 50)
        tween_service_5:Create(rewards_frame.CoinsImage, tween_info_5, tween_properties_17):Play()
        local tween_properties_18 = { ImageTransparency = 1 }
        game:GetService("TweenService")
            :Create(
                rewards_frame.EXPImage,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_18
            )
            :Play()
        local tween_service_6 = game:GetService("TweenService")
        local tween_info_6 = TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_19 = {}
        tween_properties_19.Size = UDim2.new(0, 50, 0, 50)
        tween_service_6:Create(rewards_frame.EXPImage, tween_info_6, tween_properties_19):Play()
    end)
end

game.ReplicatedStorage.Remotes.WinClient.OnClientEvent:Connect(
    function(argument, local_player, local_player_2, local_player_3, argument_2, argument_3)
        shutter()
        local clone = game.ReplicatedStorage.UISounds.ui_start_travel:Clone()
        clone.Parent = game.Workspace
        clone:Play()
        game.Debris:AddItem(clone, 3)
        game_end.Text = (argument_3 and "MERCY RULE") or "FULL TIME"
        task.wait(0.5)
        current_camera.CameraType = Enum.CameraType.Scriptable
        local connection = game:GetService("RunService").RenderStepped:Connect(function()
            current_camera.CFrame = game.Workspace.GameEndPositions.Camera.CFrame
        end)
        local tween_properties_4 = { TextTransparency = 0, TextStrokeTransparency = 0.5 }
        game:GetService("TweenService")
            :Create(game_end, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_4)
            :Play()
        task.wait(2)
        local tween_properties_5 = { TextTransparency = 1, TextStrokeTransparency = 1 }
        game:GetService("TweenService")
            :Create(game_end, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_5)
            :Play()
        top_frame.Outcome.Text = ((argument ~= game.Players.LocalPlayer.SelectedTeam.Value) and "LOSS") or "VICTORY"
        local outcome = top_frame.Outcome
        outcome.TextColor3 = argument == game.Players.LocalPlayer.SelectedTeam.Value and Color3.new(0, 1, 0)
            or Color3.new(1, 0, 0)
        local outcome_2 = top_frame.Outcome
        outcome_2.TextStrokeColor3 = argument == game.Players.LocalPlayer.SelectedTeam.Value and Color3.new(0, 1, 0)
            or Color3.new(1, 0, 0)
        top_frame.Score.Text = team_info.RedTeamPoints.Value .. "  -  " .. team_info.BlueTeamPoints.Value
        local tween_service_3 = game:GetService("TweenService")
        local tween_info_3 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_6 = {}
        tween_properties_6.Position = UDim2.new(0, 0, 1, 0)
        tween_service_3:Create(bottom_frame, tween_info_3, tween_properties_6):Play()
        local tween_service_4 = game:GetService("TweenService")
        local tween_info_4 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_7 = {}
        tween_properties_7.Position = UDim2.new(0, 0, 0, 0)
        tween_service_4:Create(top_frame, tween_info_4, tween_properties_7):Play()
        local clone_2 = game.ReplicatedStorage.UISounds.ui_start_travel:Clone()
        clone_2.Parent = game.Workspace
        clone_2:Play()
        game.Debris:AddItem(clone_2, 3)
        local clone_3 = game.ReplicatedStorage.UISounds.ui_starbar_launch:Clone()
        clone_3.Parent = game.Workspace
        clone_3:Play()
        game.Debris:AddItem(clone_3, 3)
        task.wait(1)

        if local_player == nil then
            local_player = game.Players.LocalPlayer
        end

        if local_player_2 == nil then
            local_player_2 = game.Players.LocalPlayer
        end

        if local_player_3 == nil then
            local_player_3 = game.Players.LocalPlayer
        end

        mvp.plrName.Text = "MVP - " .. local_player.DisplayName
        top_score.plrName.Text = "TOP SCORER - " .. local_player_2.DisplayName
        top_assists.plrName.Text = "TOP ASSISTS - " .. local_player_3.DisplayName
        mvp.Info.Text = local_player.Points.Value .. " POINTS"
        top_score.Info.Text = local_player_2.GoalsThisGame.Value .. " GOALS"
        top_assists.Info.Text = local_player_3.AssistsThisGame.Value .. " ASSISTS"
        local clone_4 = game.ReplicatedStorage.UISounds.ui_starbar_impact_1:Clone()
        clone_4.Parent = game.Workspace
        clone_4:Play()
        game.Debris:AddItem(clone_4, 3)
        local tween_properties_8 = { BackgroundTransparency = 0 }
        game:GetService("TweenService")
            :Create(
                top_assists,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_8
            )
            :Play()
        local tween_properties_9 = { ImageTransparency = 0 }
        game:GetService("TweenService")
            :Create(
                top_assists.Arrow,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_9
            )
            :Play()
        local tween_properties_10 = { TextTransparency = 0, TextStrokeTransparency = 0 }
        game:GetService("TweenService")
            :Create(
                top_assists.plrName,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_10
            )
            :Play()
        local tween_properties_11 = { TextTransparency = 0, TextStrokeTransparency = 0 }
        game:GetService("TweenService")
            :Create(
                top_assists.Info,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_11
            )
            :Play()

        task.delay(0.1, function()
            local tween_properties_22 = { BackgroundTransparency = 0.25 }
            game:GetService("TweenService")
                :Create(
                    top_assists,
                    TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties_22
                )
                :Play()
            local tween_properties_23 = { ImageTransparency = 0.25 }
            game:GetService("TweenService")
                :Create(
                    top_assists.Arrow,
                    TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties_23
                )
                :Play()
            local tween_properties_24 = { TextTransparency = 0, TextStrokeTransparency = 1 }
            game:GetService("TweenService")
                :Create(
                    top_assists.plrName,
                    TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties_24
                )
                :Play()
            local tween_properties_25 = { TextTransparency = 0, TextStrokeTransparency = 1 }
            game:GetService("TweenService")
                :Create(
                    top_assists.Info,
                    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties_25
                )
                :Play()
        end)

        task.wait(0.55)
        local clone_5 = game.ReplicatedStorage.UISounds.ui_starbar_impact_2:Clone()
        clone_5.Parent = game.Workspace
        clone_5:Play()
        game.Debris:AddItem(clone_5, 3)
        local tween_properties_12 = { BackgroundTransparency = 0 }
        game:GetService("TweenService")
            :Create(top_score, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_12)
            :Play()
        local tween_properties_13 = { ImageTransparency = 0 }
        game:GetService("TweenService")
            :Create(
                top_score.Arrow,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_13
            )
            :Play()
        local tween_properties_14 = { TextTransparency = 0, TextStrokeTransparency = 0 }
        game:GetService("TweenService")
            :Create(
                top_score.plrName,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_14
            )
            :Play()
        local tween_properties_15 = { TextTransparency = 0, TextStrokeTransparency = 0 }
        game:GetService("TweenService")
            :Create(
                top_score.Info,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_15
            )
            :Play()

        task.delay(0.1, function()
            local tween_properties_22 = { BackgroundTransparency = 0.25 }
            game:GetService("TweenService")
                :Create(
                    top_score,
                    TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties_22
                )
                :Play()
            local tween_properties_23 = { ImageTransparency = 0.25 }
            game:GetService("TweenService")
                :Create(
                    top_score.Arrow,
                    TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties_23
                )
                :Play()
            local tween_properties_24 = { TextTransparency = 0, TextStrokeTransparency = 1 }
            game:GetService("TweenService")
                :Create(
                    top_score.plrName,
                    TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties_24
                )
                :Play()
            local tween_properties_25 = { TextTransparency = 0, TextStrokeTransparency = 1 }
            game:GetService("TweenService")
                :Create(
                    top_score.Info,
                    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties_25
                )
                :Play()
        end)

        task.wait(0.55)
        local clone_6 = game.ReplicatedStorage.UISounds.ui_starbar_impact_3:Clone()
        clone_6.Parent = game.Workspace
        clone_6:Play()
        game.Debris:AddItem(clone_6, 3)
        local tween_properties_16 = { BackgroundTransparency = 0 }
        game:GetService("TweenService")
            :Create(mvp, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_16)
            :Play()
        local tween_properties_17 = { ImageTransparency = 0 }
        game:GetService("TweenService")
            :Create(mvp.Arrow, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_17)
            :Play()
        local tween_properties_18 = { TextTransparency = 0, TextStrokeTransparency = 0 }
        game:GetService("TweenService")
            :Create(
                mvp.plrName,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_18
            )
            :Play()
        local tween_properties_19 = { TextTransparency = 0, TextStrokeTransparency = 0 }
        game:GetService("TweenService")
            :Create(mvp.Info, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_19)
            :Play()

        task.delay(0.1, function()
            local tween_properties_22 = { BackgroundTransparency = 0.25 }
            game:GetService("TweenService")
                :Create(mvp, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_22)
                :Play()
            local tween_properties_23 = { ImageTransparency = 0.25 }
            game:GetService("TweenService")
                :Create(
                    mvp.Arrow,
                    TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties_23
                )
                :Play()
            local tween_properties_24 = { TextTransparency = 0, TextStrokeTransparency = 1 }
            game:GetService("TweenService")
                :Create(
                    mvp.plrName,
                    TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties_24
                )
                :Play()
            local tween_properties_25 = { TextTransparency = 0, TextStrokeTransparency = 1 }
            game:GetService("TweenService")
                :Create(
                    mvp.Info,
                    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties_25
                )
                :Play()
        end)

        task.wait(13.9)
        local clone_7 = game.ReplicatedStorage.UISounds.ui_start_travel:Clone()
        clone_7.Parent = game.Workspace
        clone_7:Play()
        game.Debris:AddItem(clone_7, 3)
        connection:Disconnect()
        current_camera.CameraType = Enum.CameraType.Custom
        upper_shutter.Visible = true
        lower_shutter.Visible = true
        local tween_service_5 = game:GetService("TweenService")
        local tween_info_5 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_20 = {}
        tween_properties_20.Size = UDim2.new(1, 0, 0.55, 0)
        tween_service_5:Create(lower_shutter, tween_info_5, tween_properties_20):Play()
        local tween_service_6 = game:GetService("TweenService")
        local tween_info_6 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_21 = {}
        tween_properties_21.Size = UDim2.new(1, 0, 0.55, 0)
        tween_service_6:Create(upper_shutter, tween_info_6, tween_properties_21):Play()

        task.delay(0.5, function()
            rewardsDisplay(argument_2.Coins, argument_2.EXP)
        end)

        task.delay(4, function()
            local clone_8 = game.ReplicatedStorage.UISounds.ui_start_travel:Clone()
            clone_8.Parent = game.Workspace
            clone_8:Play()
            game.Debris:AddItem(clone_8, 3)
            local clone_9 = game.ReplicatedStorage.UISounds.ui_starbar_launch:Clone()
            clone_9.Parent = game.Workspace
            clone_9:Play()
            game.Debris:AddItem(clone_9, 3)
            local tween_service_7 = game:GetService("TweenService")
            local tween_info_7 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_22 = {}
            tween_properties_22.Size = UDim2.new(1, 0, 0, 0)
            tween_service_7:Create(lower_shutter, tween_info_7, tween_properties_22):Play()
            local tween_service_8 = game:GetService("TweenService")
            local tween_info_8 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_23 = {}
            tween_properties_23.Size = UDim2.new(1, 0, 0, 0)
            tween_service_8:Create(upper_shutter, tween_info_8, tween_properties_23):Play()
            task.wait(0.5)
            upper_shutter.Visible = false
            lower_shutter.Visible = false
        end)

        bottom_frame.Position = UDim2.new(0, 0, 1, 133)
        top_frame.Position = UDim2.new(0, 0, 0, -133)
        mvp.BackgroundTransparency = 1
        mvp.Arrow.ImageTransparency = 1
        mvp.plrName.TextTransparency = 1
        mvp.plrName.TextStrokeTransparency = 1
        mvp.Info.TextTransparency = 1
        mvp.Info.TextStrokeTransparency = 1
        top_score.BackgroundTransparency = 1
        top_score.Arrow.ImageTransparency = 1
        top_score.plrName.TextTransparency = 1
        top_score.plrName.TextStrokeTransparency = 1
        top_score.Info.TextTransparency = 1
        top_score.Info.TextStrokeTransparency = 1
        top_assists.BackgroundTransparency = 1
        top_assists.Arrow.ImageTransparency = 1
        top_assists.plrName.TextTransparency = 1
        top_assists.plrName.TextStrokeTransparency = 1
        top_assists.Info.TextTransparency = 1
        top_assists.Info.TextStrokeTransparency = 1
    end
)

game.ReplicatedStorage.Remotes.DrawClient.OnClientEvent:Connect(function(enabled)
    shutter()
    task.wait(0.5)

    if enabled ~= true then
        game_end.Text = "PENALTY SHOOTOUT"
    else
        game_end.Text = "FULL TIME"
    end

    local tween_properties_4 = { TextTransparency = 0, TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(game_end, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_4)
        :Play()
    task.wait(2)
    local tween_properties_5 = { TextTransparency = 1, TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(game_end, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_5)
        :Play()
end)

game.ReplicatedStorage.Remotes.FinalShootoutClient.OnClientEvent:Connect(function()
    shutter()
    task.wait(0.5)
    game_end.Text = "FINAL SHOOTOUT"
    local tween_properties_4 = { TextTransparency = 0, TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(game_end, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_4)
        :Play()
    task.wait(2)
    local tween_properties_5 = { TextTransparency = 1, TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(game_end, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_5)
        :Play()
end)

game.ReplicatedStorage.Remotes.HalftimeClient.OnClientEvent:Connect(function()
    shutter()
    task.wait(0.5)
    game_end.Text = "HALF TIME"
    local tween_properties_4 = { TextTransparency = 0, TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(game_end, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_4)
        :Play()
    task.wait(2)
    local tween_properties_5 = { TextTransparency = 1, TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(game_end, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_5)
        :Play()
end)
