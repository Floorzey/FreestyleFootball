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
local workspace_current_camera = workspace.CurrentCamera
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

    number += 1

    if game.Players.LocalPlayer:FindFirstChild("dataLoaded") then
        game:GetService("TweenService")
            :Create(lower_shutter, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 0),
            })
            :Play()
        game:GetService("TweenService")
            :Create(upper_shutter, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 0),
            })
            :Play()
        game:GetService("TweenService")
            :Create(script.Parent.LOADING, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 1,
                TextStrokeTransparency = 1,
            })
            :Play()

        task.delay(0.5, function()
            script.Parent.LOADING.Visible = false
        end)

        function shutter()
            if game.Players.LocalPlayer:GetAttribute("Freecam") then
                return
            end

            upper_shutter.Visible = true
            lower_shutter.Visible = true
            game:GetService("TweenService")
                :Create(lower_shutter, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 0.55, 0),
                })
                :Play()
            game:GetService("TweenService")
                :Create(upper_shutter, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 0.55, 0),
                })
                :Play()

            task.delay(2, function()
                game.Lighting.Blur.Size = 2
                task.wait(0.5)
                game:GetService("TweenService")
                    :Create(lower_shutter, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 0),
                    })
                    :Play()
                game:GetService("TweenService")
                    :Create(upper_shutter, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 0),
                    })
                    :Play()
                task.wait(0.5)
                upper_shutter.Visible = false
                lower_shutter.Visible = false
            end)
        end

        function rewardsDisplay(argument, argument_2)
            game:GetService("TweenService")
                :Create(
                    rewards_frame.lineDivider,
                    TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {
                        BackgroundTransparency = 0,
                    }
                )
                :Play()
            game:GetService("TweenService")
                :Create(rewards_frame.Coins, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextTransparency = 0,
                })
                :Play()
            game:GetService("TweenService")
                :Create(rewards_frame.Coins, TweenInfo.new(1.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    TextSize = 25,
                })
                :Play()
            game:GetService("TweenService")
                :Create(rewards_frame.EXP, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextTransparency = 0,
                })
                :Play()
            game:GetService("TweenService")
                :Create(rewards_frame.EXP, TweenInfo.new(1.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    TextSize = 25,
                })
                :Play()
            game:GetService("TweenService")
                :Create(rewards_frame.CoinsImage, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    ImageTransparency = 0,
                })
                :Play()
            game:GetService("TweenService")
                :Create(rewards_frame.CoinsImage, TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 60, 0, 60),
                })
                :Play()
            game:GetService("TweenService")
                :Create(rewards_frame.EXPImage, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    ImageTransparency = 0,
                })
                :Play()
            game:GetService("TweenService")
                :Create(rewards_frame.EXPImage, TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 60, 0, 60),
                })
                :Play()
            local clone = game.ReplicatedStorage.UISounds.ui_starbar_fill:Clone()
            clone.Parent = game.Workspace
            clone:Play()
            game.Debris:AddItem(clone, 3)
            rewards_frame.EXP.Text = "+0 EXP"
            rewards_frame.Coins.Text = "+0 COINS"

            task.spawn(function()
                local rounded_value = math.floor(argument_2 / 84)

                for index = 1, 84 do
                    rewards_frame.EXP.Text = "+" .. rounded_value * index .. " EXP"
                    game:GetService("RunService").RenderStepped:Wait()
                    local _ = index
                end

                game:GetService("TweenService")
                    :Create(
                        rewards_frame.EXPImage,
                        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                        {
                            Size = UDim2.new(0, 75, 0, 75),
                        }
                    )
                    :Play()
                game:GetService("TweenService")
                    :Create(rewards_frame.EXP, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        TextSize = 30,
                    })
                    :Play()
            end)

            task.spawn(function()
                local rounded_value = math.floor(argument / 84)

                for index = 1, 84 do
                    rewards_frame.Coins.Text = "+" .. rounded_value * index .. " COINS"
                    game:GetService("RunService").RenderStepped:Wait()
                    local _ = index
                end

                game:GetService("TweenService")
                    :Create(
                        rewards_frame.CoinsImage,
                        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                        {
                            Size = UDim2.new(0, 75, 0, 75),
                        }
                    )
                    :Play()
                game:GetService("TweenService")
                    :Create(rewards_frame.Coins, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        TextSize = 30,
                    })
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
                game:GetService("TweenService")
                    :Create(
                        rewards_frame.lineDivider,
                        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {
                            BackgroundTransparency = 1,
                        }
                    )
                    :Play()
                game:GetService("TweenService")
                    :Create(rewards_frame.Coins, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 1,
                    })
                    :Play()
                game:GetService("TweenService")
                    :Create(rewards_frame.EXP, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 1,
                    })
                    :Play()
                game:GetService("TweenService")
                    :Create(
                        rewards_frame.CoinsImage,
                        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {
                            ImageTransparency = 1,
                        }
                    )
                    :Play()
                game:GetService("TweenService")
                    :Create(
                        rewards_frame.CoinsImage,
                        TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {
                            Size = UDim2.new(0, 50, 0, 50),
                        }
                    )
                    :Play()
                game:GetService("TweenService")
                    :Create(
                        rewards_frame.EXPImage,
                        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {
                            ImageTransparency = 1,
                        }
                    )
                    :Play()
                game:GetService("TweenService")
                    :Create(
                        rewards_frame.EXPImage,
                        TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {
                            Size = UDim2.new(0, 50, 0, 50),
                        }
                    )
                    :Play()
            end)
        end

        local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
        knit.OnStart():await()
        local key_handler_service = knit.GetService("KeyHandlerService")

        key_handler_service
            :GetKey("WinClient").OnClientEvent
            :Connect(function(argument, argument_2, argument_3, argument_4, argument_5, argument_6)
                shutter()
                local clone = game.ReplicatedStorage.UISounds.ui_start_travel:Clone()
                clone.Parent = game.Workspace
                clone:Play()
                game.Debris:AddItem(clone, 3)
                game_end.Text = argument_6 and "MERCY RULE" or "FULL TIME"
                task.wait(0.5)
                workspace_current_camera.CameraType = Enum.CameraType.Scriptable
                local camera_override = Instance.new("Folder")
                camera_override.Name = "CameraOverride"
                camera_override.Parent = game.Players.LocalPlayer.Character.Status
                local connection = game:GetService("RunService").RenderStepped:Connect(function()
                    workspace_current_camera.CFrame = game.Workspace.GameEndPositions.Camera.CFrame
                end)

                task.delay(24, function()
                    if connection.Connected then
                        connection:Disconnect()
                    end

                    workspace_current_camera.CameraType = Enum.CameraType.Custom
                    game.Lighting.Blur.Size = 2

                    if camera_override.Parent then
                        camera_override:Destroy()
                    end
                end)

                local local_player = argument_2 or game.Players.LocalPlayer
                local player = argument_3 or local_player
                local player_2 = argument_4 or local_player
                local values = argument_5
                    or {
                        Coins = 0,
                        EXP = 0,
                    }
                game:GetService("TweenService")
                    :Create(game_end, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 0,
                        TextStrokeTransparency = 0.5,
                    })
                    :Play()
                task.wait(2)
                game:GetService("TweenService")
                    :Create(game_end, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 1,
                        TextStrokeTransparency = 1,
                    })
                    :Play()
                top_frame.Outcome.Text = argument == game.Players.LocalPlayer.SelectedTeam.Value and "VICTORY" or "LOSS"
                top_frame.Outcome.TextColor3 = argument == game.Players.LocalPlayer.SelectedTeam.Value
                        and Color3.new(0, 1, 0)
                    or Color3.new(1, 0, 0)
                top_frame.Outcome.TextStrokeColor3 = argument == game.Players.LocalPlayer.SelectedTeam.Value
                        and Color3.new(0, 1, 0)
                    or Color3.new(1, 0, 0)
                top_frame.Score.Text = team_info.HomeTeamPoints.Value .. "  -  " .. team_info.AwayTeamPoints.Value
                game:GetService("TweenService")
                    :Create(bottom_frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Position = UDim2.new(0, 0, 1, 0),
                    })
                    :Play()
                game:GetService("TweenService")
                    :Create(top_frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Position = UDim2.new(0, 0, 0, 0),
                    })
                    :Play()
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

                if player == nil then
                    player = game.Players.LocalPlayer
                end

                if player_2 == nil then
                    player_2 = game.Players.LocalPlayer
                end

                mvp.plrName.Text = "MVP - " .. local_player.DisplayName
                top_score.plrName.Text = "TOP SCORER - " .. player.DisplayName
                top_assists.plrName.Text = "TOP ASSISTS - " .. player_2.DisplayName
                mvp.Info.Text = local_player.Points.Value .. " POINTS"
                top_score.Info.Text = player.GoalsThisGame.Value .. " GOALS"
                top_assists.Info.Text = player_2.AssistsThisGame.Value .. " ASSISTS"
                local clone_4 = game.ReplicatedStorage.UISounds.ui_starbar_impact_1:Clone()
                clone_4.Parent = game.Workspace
                clone_4:Play()
                game.Debris:AddItem(clone_4, 3)
                game:GetService("TweenService")
                    :Create(top_assists, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0,
                    })
                    :Play()
                game:GetService("TweenService")
                    :Create(top_assists.Arrow, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        ImageTransparency = 0,
                    })
                    :Play()
                game:GetService("TweenService")
                    :Create(top_assists.plrName, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 0,
                        TextStrokeTransparency = 0,
                    })
                    :Play()
                game:GetService("TweenService")
                    :Create(top_assists.Info, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 0,
                        TextStrokeTransparency = 0,
                    })
                    :Play()

                task.delay(0.1, function()
                    game:GetService("TweenService")
                        :Create(top_assists, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            BackgroundTransparency = 0.25,
                        })
                        :Play()
                    game:GetService("TweenService")
                        :Create(top_assists.Arrow, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            ImageTransparency = 0.25,
                        })
                        :Play()
                    game:GetService("TweenService")
                        :Create(
                            top_assists.plrName,
                            TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {
                                TextTransparency = 0,
                                TextStrokeTransparency = 1,
                            }
                        )
                        :Play()
                    game:GetService("TweenService")
                        :Create(top_assists.Info, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            TextTransparency = 0,
                            TextStrokeTransparency = 1,
                        })
                        :Play()
                end)

                task.wait(0.55)
                local clone_5 = game.ReplicatedStorage.UISounds.ui_starbar_impact_2:Clone()
                clone_5.Parent = game.Workspace
                clone_5:Play()
                game.Debris:AddItem(clone_5, 3)
                game:GetService("TweenService")
                    :Create(top_score, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0,
                    })
                    :Play()
                game:GetService("TweenService")
                    :Create(top_score.Arrow, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        ImageTransparency = 0,
                    })
                    :Play()
                game:GetService("TweenService")
                    :Create(top_score.plrName, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 0,
                        TextStrokeTransparency = 0,
                    })
                    :Play()
                game:GetService("TweenService")
                    :Create(top_score.Info, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 0,
                        TextStrokeTransparency = 0,
                    })
                    :Play()

                task.delay(0.1, function()
                    game:GetService("TweenService")
                        :Create(top_score, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            BackgroundTransparency = 0.25,
                        })
                        :Play()
                    game:GetService("TweenService")
                        :Create(top_score.Arrow, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            ImageTransparency = 0.25,
                        })
                        :Play()
                    game:GetService("TweenService")
                        :Create(top_score.plrName, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            TextTransparency = 0,
                            TextStrokeTransparency = 1,
                        })
                        :Play()
                    game:GetService("TweenService")
                        :Create(top_score.Info, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            TextTransparency = 0,
                            TextStrokeTransparency = 1,
                        })
                        :Play()
                end)

                task.wait(0.55)
                local clone_6 = game.ReplicatedStorage.UISounds.ui_starbar_impact_3:Clone()
                clone_6.Parent = game.Workspace
                clone_6:Play()
                game.Debris:AddItem(clone_6, 3)
                game:GetService("TweenService")
                    :Create(mvp, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0,
                    })
                    :Play()
                game:GetService("TweenService")
                    :Create(mvp.Arrow, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        ImageTransparency = 0,
                    })
                    :Play()
                game:GetService("TweenService")
                    :Create(mvp.plrName, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 0,
                        TextStrokeTransparency = 0,
                    })
                    :Play()
                game:GetService("TweenService")
                    :Create(mvp.Info, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 0,
                        TextStrokeTransparency = 0,
                    })
                    :Play()

                task.delay(0.1, function()
                    game:GetService("TweenService")
                        :Create(mvp, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            BackgroundTransparency = 0.25,
                        })
                        :Play()
                    game:GetService("TweenService")
                        :Create(mvp.Arrow, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            ImageTransparency = 0.25,
                        })
                        :Play()
                    game:GetService("TweenService")
                        :Create(mvp.plrName, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            TextTransparency = 0,
                            TextStrokeTransparency = 1,
                        })
                        :Play()
                    game:GetService("TweenService")
                        :Create(mvp.Info, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            TextTransparency = 0,
                            TextStrokeTransparency = 1,
                        })
                        :Play()
                end)

                task.wait(13.9)
                local clone_7 = game.ReplicatedStorage.UISounds.ui_start_travel:Clone()
                clone_7.Parent = game.Workspace
                clone_7:Play()
                game.Debris:AddItem(clone_7, 3)
                connection:Disconnect()
                workspace_current_camera.CameraType = Enum.CameraType.Custom
                upper_shutter.Visible = true
                lower_shutter.Visible = true
                game:GetService("TweenService")
                    :Create(lower_shutter, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0.55, 0),
                    })
                    :Play()
                game:GetService("TweenService")
                    :Create(upper_shutter, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0.55, 0),
                    })
                    :Play()

                task.delay(0.5, function()
                    rewardsDisplay(values.Coins, values.EXP)
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
                    game:GetService("TweenService")
                        :Create(lower_shutter, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = UDim2.new(1, 0, 0, 0),
                        })
                        :Play()
                    game:GetService("TweenService")
                        :Create(upper_shutter, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = UDim2.new(1, 0, 0, 0),
                        })
                        :Play()
                    task.wait(0.5)
                    upper_shutter.Visible = false
                    lower_shutter.Visible = false
                end)

                camera_override:Destroy()
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
            end)

        key_handler_service:GetKey("DrawClient").OnClientEvent:Connect(function(enabled)
            shutter()
            task.wait(0.5)

            if enabled == true then
                game_end.Text = "FULL TIME"
            else
                game_end.Text = "PENALTY SHOOTOUT"
            end

            game:GetService("TweenService")
                :Create(game_end, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextTransparency = 0,
                    TextStrokeTransparency = 0.5,
                })
                :Play()
            task.wait(2)
            game:GetService("TweenService")
                :Create(game_end, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextTransparency = 1,
                    TextStrokeTransparency = 1,
                })
                :Play()
        end)

        key_handler_service:GetKey("FinalShootoutClient").OnClientEvent:Connect(function()
            shutter()
            task.wait(0.5)
            game_end.Text = "FINAL SHOOTOUT"
            game:GetService("TweenService")
                :Create(game_end, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextTransparency = 0,
                    TextStrokeTransparency = 0.5,
                })
                :Play()
            task.wait(2)
            game:GetService("TweenService")
                :Create(game_end, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextTransparency = 1,
                    TextStrokeTransparency = 1,
                })
                :Play()
        end)

        key_handler_service:GetKey("HalftimeClient").OnClientEvent:Connect(function()
            shutter()
            task.wait(0.5)
            game_end.Text = "HALF TIME"
            game:GetService("TweenService")
                :Create(game_end, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextTransparency = 0,
                    TextStrokeTransparency = 0.5,
                })
                :Play()
            task.wait(2)
            game:GetService("TweenService")
                :Create(game_end, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextTransparency = 1,
                    TextStrokeTransparency = 1,
                })
                :Play()
        end)

        return
    end
end
