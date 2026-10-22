local values = {}
values.Blue = Color3.fromRGB(0, 85, 255)
values.Red = Color3.fromRGB(185, 0, 0)
local values_2 = {}
values_2.Blue = Color3.fromRGB(255, 255, 255)
values_2.Red = Color3.fromRGB(255, 255, 255)
local values_3 = {}
values_3.Blue = "BLU"
values_3.Red = "RED"
local team_info = game.ReplicatedStorage.TeamInfo
local game_time = game.ReplicatedStorage.gameTime
local score_and_timer_frame = script.Parent.ScoreAndTimerFrame
local blue_team = score_and_timer_frame.BlueTeam
local red_team = score_and_timer_frame.RedTeam
local score = score_and_timer_frame.Score
local timer = score_and_timer_frame.Timer
local tab_frame = script.Parent.TabFrame
local container = tab_frame.HomeFrame.Container
local container_2 = tab_frame.AwayFrame.Container
local user_input_service = game:GetService("UserInputService")

user_input_service.InputChanged:Connect(function()
    if user_input_service:GetLastInputType() ~= Enum.UserInputType.Touch then
        score_and_timer_frame.Size = UDim2.new(0, 400, 0, 100)
        red_team.Size = UDim2.new(0, 85, 0, 43)
        red_team.Position = UDim2.new(0.25, 0, 0.69, 0)
        blue_team.Size = UDim2.new(0, 85, 0, 43)
        blue_team.Position = UDim2.new(0.75, 0, 0.69, 0)
        score.Size = UDim2.new(0, 102, 0, 43)
        timer.Size = UDim2.new(0, 102, 0, 43)
    else
        score_and_timer_frame.Size = UDim2.new(0, 400, 0, 38)
        red_team.Size = UDim2.new(0, 40, 0, 22)
        red_team.Position = UDim2.new(0.375, 0, 0.69, 0)
        blue_team.Size = UDim2.new(0, 40, 0, 22)
        blue_team.Position = UDim2.new(0.625, 0, 0.69, 0)
        score.Size = UDim2.new(0, 40, 0, 22)
        timer.Size = UDim2.new(0, 40, 0, 22)
    end
end)

if game.ReplicatedStorage.hasGameStarted.Value == true then
    if user_input_service:GetLastInputType() ~= Enum.UserInputType.Touch then
        local tween_service = game:GetService("TweenService")
        local tween_info = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tween_properties = {}
        tween_properties.Position = UDim2.new(0.5, 0, 0, 80)
        tween_service:Create(score_and_timer_frame, tween_info, tween_properties):Play()
    else
        local tween_service_2 = game:GetService("TweenService")
        local tween_info_2 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tween_properties_2 = {}
        tween_properties_2.Position = UDim2.new(0.5, 0, 0, 55)
        tween_service_2:Create(score_and_timer_frame, tween_info_2, tween_properties_2):Play()
    end
end

game.ReplicatedStorage.hasGameStarted.Changed:Connect(function()
    if game.ReplicatedStorage.hasGameStarted.Value == false then
        local tween_service_3 = game:GetService("TweenService")
        local tween_info_3 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tween_properties_3 = {}
        tween_properties_3.Position = UDim2.new(0.5, 0, 0, -100)
        tween_service_3:Create(score_and_timer_frame, tween_info_3, tween_properties_3):Play()
    elseif user_input_service:GetLastInputType() ~= Enum.UserInputType.Touch then
        local tween_service_4 = game:GetService("TweenService")
        local tween_info_4 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tween_properties_4 = {}
        tween_properties_4.Position = UDim2.new(0.5, 0, 0, 80)
        tween_service_4:Create(score_and_timer_frame, tween_info_4, tween_properties_4):Play()
    else
        local tween_service_5 = game:GetService("TweenService")
        local tween_info_5 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tween_properties_5 = {}
        tween_properties_5.Position = UDim2.new(0.5, 0, 0, 55)
        tween_service_5:Create(score_and_timer_frame, tween_info_5, tween_properties_5):Play()
    end
end)

game_time.Changed:Connect(function()
    timer.Time.Text = math.floor(game_time.Value / 60)
        .. (((game_time.Value % 60 < 10) and ":0") or ":")
        .. game_time.Value % 60
end)

timer.Time.Text = math.floor(game_time.Value / 60)
    .. (((game_time.Value % 60 < 10) and ":0") or ":")
    .. game_time.Value % 60

function handleScoreColor()
    local value = team_info.BlueTeamPoints.Value
    local value_2 = team_info.RedTeamPoints.Value

    if value_2 < value then
        local tween_service_3 = game:GetService("TweenService")
        local tween_info_3 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tween_properties_3 = {}
        tween_properties_3.BackgroundColor3 = Color3.new(0, 0.333333, 1)
        tween_service_3:Create(score, tween_info_3, tween_properties_3):Play()
        local tween_service_4 = game:GetService("TweenService")
        local tween_info_4 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tween_properties_4 = { Thickness = 2 }
        tween_properties_4.Color = Color3.new(1, 1, 1)
        tween_service_4:Create(score.UIStroke, tween_info_4, tween_properties_4):Play()
        local tween_service_5 = game:GetService("TweenService")
        local tween_info_5 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tween_properties_5 = {}
        tween_properties_5.TextStrokeColor3 = Color3.new(1, 1, 1)
        tween_service_5:Create(score.Score, tween_info_5, tween_properties_5):Play()
    elseif value < value_2 then
        local tween_service_6 = game:GetService("TweenService")
        local tween_info_6 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tween_properties_6 = {}
        tween_properties_6.BackgroundColor3 = Color3.new(0.854902, 0, 0)
        tween_service_6:Create(score, tween_info_6, tween_properties_6):Play()
        local tween_service_7 = game:GetService("TweenService")
        local tween_info_7 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tween_properties_7 = { Thickness = 2 }
        tween_properties_7.Color = Color3.new(1, 1, 1)
        tween_service_7:Create(score.UIStroke, tween_info_7, tween_properties_7):Play()
        local tween_service_8 = game:GetService("TweenService")
        local tween_info_8 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tween_properties_8 = {}
        tween_properties_8.TextStrokeColor3 = Color3.new(1, 1, 1)
        tween_service_8:Create(score.Score, tween_info_8, tween_properties_8):Play()
    elseif value_2 == value then
        local tween_service_9 = game:GetService("TweenService")
        local tween_info_9 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tween_properties_9 = {}
        tween_properties_9.BackgroundColor3 = Color3.new(0, 0, 0)
        tween_service_9:Create(score, tween_info_9, tween_properties_9):Play()
        local tween_service_10 = game:GetService("TweenService")
        local tween_info_10 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tween_properties_10 = { Thickness = 1 }
        tween_properties_10.Color = Color3.new(1, 1, 1)
        tween_service_10:Create(score.UIStroke, tween_info_10, tween_properties_10):Play()
        local tween_service_11 = game:GetService("TweenService")
        local tween_info_11 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tween_properties_11 = {}
        tween_properties_11.TextStrokeColor3 = Color3.new(0, 0, 0)
        tween_service_11:Create(score.Score, tween_info_11, tween_properties_11):Play()
    end
end

team_info.BlueTeamPoints.Changed:Connect(function()
    score.Score.Text = team_info.RedTeamPoints.Value .. "  -  " .. team_info.BlueTeamPoints.Value
    handleScoreColor()
end)

score.Score.Text = team_info.RedTeamPoints.Value .. "  -  " .. team_info.BlueTeamPoints.Value
handleScoreColor()

team_info.RedTeamPoints.Changed:Connect(function()
    score.Score.Text = team_info.RedTeamPoints.Value .. "  -  " .. team_info.BlueTeamPoints.Value
    handleScoreColor()
end)

score.Score.Text = team_info.RedTeamPoints.Value .. "  -  " .. team_info.BlueTeamPoints.Value
handleScoreColor()

function setupTabFrame()
    for _, value in pairs(game.Players:GetPlayers()) do
        if not (value:FindFirstChild("dataLoaded")) or value.SelectedTeam.Value == "N/A" then
            continue
        end

        if not ((((value.SelectedTeam.Value == "Blue") and container_2) or container):FindFirstChild(value.Name)) then
            local value_2 = value.SelectedTeam.Value
            local clone = script.plrInfoTemplate:Clone()
            clone.UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, values[value_2]),
                ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)),
            })
            clone.UIStroke.UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, values_2[value_2]),
                ColorSequenceKeypoint.new(1, Color3.new(0.294118, 0.294118, 0.294118)),
            })
            clone.plrName.Text = string.upper(value.DisplayName)
            clone.POSITION.Text = value.SelectedPosition.Value
            clone.GOALS.Text = value.GoalsThisGame.Value
            clone.OOB.Text = value.PenaltyCount.Value
            clone.ASSISTS.Text = value.AssistsThisGame.Value
            clone.POINTS.Text = value.Points.Value
            clone.Name = value.Name
            clone.Parent = ((value.SelectedTeam.Value == "Blue") and container_2) or container
            value_2 = value.SelectedPosition.Changed:Connect(function()
                clone.POSITION.Text = value.SelectedPosition.Value
            end)
            local connection = value.GoalsThisGame.Changed:Connect(function()
                clone.GOALS.Text = value.GoalsThisGame.Value
            end)
            local connection_2 = value.PenaltyCount.Changed:Connect(function()
                clone.OOB.Text = value.PenaltyCount.Value
            end)
            local connection_3 = value.AssistsThisGame.Changed:Connect(function()
                clone.ASSISTS.Text = value.AssistsThisGame.Value
            end)
            local connection_4 = value.Points.Changed:Connect(function()
                clone.POINTS.Text = value.Points.Value
            end)

            value.SelectedTeam.Changed:Once(function()
                clone:Destroy()
            end)

            clone.Destroying:Once(function()
                value_2:Disconnect()
                connection:Disconnect()
                connection_2:Disconnect()
                connection_3:Disconnect()
                connection_4:Disconnect()
            end)

            local connection_6 = nil
            local connection_5 = value.AncestryChanged:Connect(function()
                if value:IsDescendantOf(game) then
                    return
                end

                clone:Destroy()
                connection_6:Disconnect()
            end)
            connection_6 = connection_5
        end
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input, game_processed)
    if input.KeyCode ~= Enum.KeyCode.Tab then
        return
    end

    setupTabFrame()
    tab_frame.Visible = true
end)

game:GetService("UserInputService").InputEnded:Connect(function(input, game_processed)
    if input.KeyCode ~= Enum.KeyCode.Tab then
        return
    end

    tab_frame.Visible = false
end)

local shootout = script.Parent.Shootout
local final_shootout = script.Parent.FinalShootout

game.ReplicatedStorage.ChildAdded:Connect(function(child)
    if child.Name == "Shootout" then
        task.wait(0.8)
        local red_success = child:WaitForChild("RedSuccess")
        local red_team_fail = child:WaitForChild("RedTeamFail")
        local blue_success = child:WaitForChild("BlueSuccess")
        local blue_team_fail = child:WaitForChild("BlueTeamFail")
        local current_shot_num = child:WaitForChild("currentShotNum")
        local tween_service_3 = game:GetService("TweenService")
        local tween_info_3 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tween_properties_3 = {}
        tween_properties_3.Position = UDim2.new(0.5, 0, 0, 148)
        tween_service_3:Create(shootout, tween_info_3, tween_properties_3):Play()

        for _, child_2 in pairs(shootout.RedTeam:GetChildren()) do
            if child_2:IsA("ImageLabel") then
                local tween_properties_4 = { BackgroundTransparency = 0.5 }
                game:GetService("TweenService")
                    :Create(
                        child_2,
                        TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                        tween_properties_4
                    )
                    :Play()
                local tween_properties_5 = { Transparency = 0.5 }
                game:GetService("TweenService")
                    :Create(
                        child_2.UIStroke,
                        TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                        tween_properties_5
                    )
                    :Play()
            end
        end

        for _, child_3 in pairs(shootout.BlueTeam:GetChildren()) do
            if child_3:IsA("ImageLabel") then
                local tween_properties_6 = { BackgroundTransparency = 0.5 }
                game:GetService("TweenService")
                    :Create(
                        child_3,
                        TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                        tween_properties_6
                    )
                    :Play()
                local tween_properties_7 = { Transparency = 0.5 }
                game:GetService("TweenService")
                    :Create(
                        child_3.UIStroke,
                        TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                        tween_properties_7
                    )
                    :Play()
            end
        end

        local connection = red_success.Changed:Connect(function()
            if current_shot_num.Value ~= 1 then
                if current_shot_num.Value ~= 3 then
                    if current_shot_num.Value ~= 5 then
                        return
                    end

                    if red_success.Value >= 1 then
                        shootout.RedTeam.Shot3.Result.BackgroundColor3 = Color3.new(0, 0.666667, 0)
                        local tween_properties_13 = { BackgroundTransparency = 0 }
                        game:GetService("TweenService")
                            :Create(
                                shootout.RedTeam.Shot3.Result,
                                TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                                tween_properties_13
                            )
                            :Play()
                    end
                elseif red_success.Value >= 1 then
                    shootout.RedTeam.Shot2.Result.BackgroundColor3 = Color3.new(0, 0.666667, 0)
                    local tween_properties_14 = { BackgroundTransparency = 0 }
                    game:GetService("TweenService")
                        :Create(
                            shootout.RedTeam.Shot2.Result,
                            TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                            tween_properties_14
                        )
                        :Play()
                end
            elseif red_success.Value >= 1 then
                shootout.RedTeam.Shot1.Result.BackgroundColor3 = Color3.new(0, 0.666667, 0)
                local tween_properties_15 = { BackgroundTransparency = 0 }
                game:GetService("TweenService")
                    :Create(
                        shootout.RedTeam.Shot1.Result,
                        TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                        tween_properties_15
                    )
                    :Play()
            end
        end)
        local connection_2 = blue_success.Changed:Connect(function()
            if current_shot_num.Value ~= 2 then
                if current_shot_num.Value ~= 4 then
                    if current_shot_num.Value ~= 6 then
                        return
                    end

                    if blue_success.Value >= 1 then
                        shootout.BlueTeam.Shot3.Result.BackgroundColor3 = Color3.new(0, 0.666667, 0)
                        local tween_properties_13 = { BackgroundTransparency = 0 }
                        game:GetService("TweenService")
                            :Create(
                                shootout.BlueTeam.Shot3.Result,
                                TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                                tween_properties_13
                            )
                            :Play()
                    end
                elseif blue_success.Value >= 1 then
                    shootout.BlueTeam.Shot2.Result.BackgroundColor3 = Color3.new(0, 0.666667, 0)
                    local tween_properties_14 = { BackgroundTransparency = 0 }
                    game:GetService("TweenService")
                        :Create(
                            shootout.BlueTeam.Shot2.Result,
                            TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                            tween_properties_14
                        )
                        :Play()
                end
            elseif blue_success.Value >= 1 then
                shootout.BlueTeam.Shot1.Result.BackgroundColor3 = Color3.new(0, 0.666667, 0)
                local tween_properties_15 = { BackgroundTransparency = 0 }
                game:GetService("TweenService")
                    :Create(
                        shootout.BlueTeam.Shot1.Result,
                        TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                        tween_properties_15
                    )
                    :Play()
            end
        end)
        local connection_3 = red_team_fail.Changed:Connect(function()
            if current_shot_num.Value ~= 1 then
                if current_shot_num.Value ~= 3 then
                    if current_shot_num.Value ~= 5 then
                        return
                    end

                    if red_team_fail.Value >= 1 then
                        shootout.RedTeam.Shot3.Result.BackgroundColor3 = Color3.new(0.666667, 0, 0)
                        local tween_properties_13 = { BackgroundTransparency = 0 }
                        game:GetService("TweenService")
                            :Create(
                                shootout.RedTeam.Shot3.Result,
                                TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                                tween_properties_13
                            )
                            :Play()
                    end
                elseif red_team_fail.Value >= 1 then
                    shootout.RedTeam.Shot2.Result.BackgroundColor3 = Color3.new(0.666667, 0, 0)
                    local tween_properties_14 = { BackgroundTransparency = 0 }
                    game:GetService("TweenService")
                        :Create(
                            shootout.RedTeam.Shot2.Result,
                            TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                            tween_properties_14
                        )
                        :Play()
                end
            elseif red_team_fail.Value >= 1 then
                shootout.RedTeam.Shot1.Result.BackgroundColor3 = Color3.new(0.666667, 0, 0)
                local tween_properties_15 = { BackgroundTransparency = 0 }
                game:GetService("TweenService")
                    :Create(
                        shootout.RedTeam.Shot1.Result,
                        TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                        tween_properties_15
                    )
                    :Play()
            end
        end)
        local connection_4 = blue_team_fail.Changed:Connect(function()
            if current_shot_num.Value ~= 2 then
                if current_shot_num.Value ~= 4 then
                    if current_shot_num.Value ~= 6 then
                        return
                    end

                    if blue_team_fail.Value >= 1 then
                        shootout.BlueTeam.Shot3.Result.BackgroundColor3 = Color3.new(0.666667, 0, 0)
                        local tween_properties_13 = { BackgroundTransparency = 0 }
                        game:GetService("TweenService")
                            :Create(
                                shootout.BlueTeam.Shot3.Result,
                                TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                                tween_properties_13
                            )
                            :Play()
                    end
                elseif blue_team_fail.Value >= 1 then
                    shootout.BlueTeam.Shot2.Result.BackgroundColor3 = Color3.new(0.666667, 0, 0)
                    local tween_properties_14 = { BackgroundTransparency = 0 }
                    game:GetService("TweenService")
                        :Create(
                            shootout.BlueTeam.Shot2.Result,
                            TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                            tween_properties_14
                        )
                        :Play()
                end
            elseif blue_team_fail.Value >= 1 then
                shootout.BlueTeam.Shot1.Result.BackgroundColor3 = Color3.new(0.666667, 0, 0)
                local tween_properties_15 = { BackgroundTransparency = 0 }
                game:GetService("TweenService")
                    :Create(
                        shootout.BlueTeam.Shot1.Result,
                        TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                        tween_properties_15
                    )
                    :Play()
            end
        end)

        child.Destroying:Once(function()
            task.wait(0.5)
            connection:Disconnect()
            connection_2:Disconnect()
            connection_3:Disconnect()
            connection_4:Disconnect()
            local tween_service_5 = game:GetService("TweenService")
            local tween_info_5 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
            local tween_properties_13 = {}
            tween_properties_13.Position = UDim2.new(0.5, 0, 0, 100)
            tween_service_5:Create(shootout, tween_info_5, tween_properties_13):Play()

            for _, child_4 in pairs(shootout.RedTeam:GetChildren()) do
                if child_4:IsA("ImageLabel") then
                    local tween_properties_14 = { BackgroundTransparency = 1 }
                    game:GetService("TweenService")
                        :Create(
                            child_4,
                            TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                            tween_properties_14
                        )
                        :Play()
                    local tween_properties_15 = { BackgroundTransparency = 1 }
                    game:GetService("TweenService")
                        :Create(
                            child_4.Result,
                            TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                            tween_properties_15
                        )
                        :Play()
                    local tween_properties_16 = { Transparency = 1 }
                    game:GetService("TweenService")
                        :Create(
                            child_4.UIStroke,
                            TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                            tween_properties_16
                        )
                        :Play()
                end
            end

            for _, child_5 in pairs(shootout.BlueTeam:GetChildren()) do
                if child_5:IsA("ImageLabel") then
                    local tween_properties_17 = { BackgroundTransparency = 1 }
                    game:GetService("TweenService")
                        :Create(
                            child_5,
                            TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                            tween_properties_17
                        )
                        :Play()
                    local tween_properties_18 = { BackgroundTransparency = 1 }
                    game:GetService("TweenService")
                        :Create(
                            child_5.Result,
                            TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                            tween_properties_18
                        )
                        :Play()
                    local tween_properties_19 = { Transparency = 1 }
                    game:GetService("TweenService")
                        :Create(
                            child_5.UIStroke,
                            TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                            tween_properties_19
                        )
                        :Play()
                end
            end
        end)
    elseif child.Name == "FinalShootout" then
        task.wait(0.8)
        local shot = final_shootout.RedTeam.Shot
        local shot_2 = final_shootout.BlueTeam.Shot
        local tween_service_4 = game:GetService("TweenService")
        local tween_info_4 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tween_properties_8 = {}
        tween_properties_8.Position = UDim2.new(0.5, 0, 0, 148)
        tween_service_4:Create(final_shootout, tween_info_4, tween_properties_8):Play()
        local tween_properties_9 = { BackgroundTransparency = 0.5 }
        game:GetService("TweenService")
            :Create(shot, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tween_properties_9)
            :Play()
        local tween_properties_10 = { Transparency = 0.5 }
        game:GetService("TweenService")
            :Create(
                shot.UIStroke,
                TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                tween_properties_10
            )
            :Play()
        local tween_properties_11 = { BackgroundTransparency = 0.5 }
        game:GetService("TweenService")
            :Create(shot_2, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tween_properties_11)
            :Play()
        local tween_properties_12 = { Transparency = 0.5 }
        game:GetService("TweenService")
            :Create(
                shot_2.UIStroke,
                TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                tween_properties_12
            )
            :Play()
        local connection_5 = child.ChildAdded:Connect(function(child_4)
            if child_4.Name == "RedTeamSuccess" then
                shot.Result.BackgroundColor3 = Color3.new(0, 0.666667, 0)
                local tween_properties_13 = { BackgroundTransparency = 0 }
                game:GetService("TweenService")
                    :Create(
                        shot.Result,
                        TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                        tween_properties_13
                    )
                    :Play()

                child_4.Destroying:Connect(function()
                    local tween_properties_17 = { BackgroundTransparency = 1 }
                    game:GetService("TweenService")
                        :Create(
                            shot.Result,
                            TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                            tween_properties_17
                        )
                        :Play()
                end)
            elseif child_4.Name == "BlueTeamSuccess" then
                shot_2.Result.BackgroundColor3 = Color3.new(0, 0.666667, 0)
                local tween_properties_14 = { BackgroundTransparency = 0 }
                game:GetService("TweenService")
                    :Create(
                        shot_2.Result,
                        TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                        tween_properties_14
                    )
                    :Play()

                child_4.Destroying:Connect(function()
                    local tween_properties_17 = { BackgroundTransparency = 1 }
                    game:GetService("TweenService")
                        :Create(
                            shot_2.Result,
                            TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                            tween_properties_17
                        )
                        :Play()
                end)
            elseif child_4.Name == "RedTeamFail" then
                shot.Result.BackgroundColor3 = Color3.new(0.666667, 0, 0)
                local tween_properties_15 = { BackgroundTransparency = 0 }
                game:GetService("TweenService")
                    :Create(
                        shot.Result,
                        TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                        tween_properties_15
                    )
                    :Play()

                child_4.Destroying:Connect(function()
                    local tween_properties_17 = { BackgroundTransparency = 1 }
                    game:GetService("TweenService")
                        :Create(
                            shot.Result,
                            TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                            tween_properties_17
                        )
                        :Play()
                end)
            elseif child_4.Name == "BlueTeamFail" then
                shot_2.Result.BackgroundColor3 = Color3.new(0.666667, 0, 0)
                local tween_properties_16 = { BackgroundTransparency = 0 }
                game:GetService("TweenService")
                    :Create(
                        shot_2.Result,
                        TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                        tween_properties_16
                    )
                    :Play()

                child_4.Destroying:Connect(function()
                    local tween_properties_17 = { BackgroundTransparency = 1 }
                    game:GetService("TweenService")
                        :Create(
                            shot_2.Result,
                            TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                            tween_properties_17
                        )
                        :Play()
                end)
            end
        end)

        child.Destroying:Once(function()
            task.wait(0.5)
            connection_5:Disconnect()
            local tween_service_5 = game:GetService("TweenService")
            local tween_info_5 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
            local tween_properties_13 = {}
            tween_properties_13.Position = UDim2.new(0.5, 0, 0, 100)
            tween_service_5:Create(final_shootout, tween_info_5, tween_properties_13):Play()
            local tween_properties_14 = { BackgroundTransparency = 1 }
            game:GetService("TweenService")
                :Create(shot, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tween_properties_14)
                :Play()
            local tween_properties_15 = { Transparency = 1 }
            game:GetService("TweenService")
                :Create(
                    shot.UIStroke,
                    TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                    tween_properties_15
                )
                :Play()
            local tween_properties_16 = { BackgroundTransparency = 1 }
            game:GetService("TweenService")
                :Create(
                    shot.Result,
                    TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                    tween_properties_16
                )
                :Play()
            local tween_properties_17 = { BackgroundTransparency = 1 }
            game:GetService("TweenService")
                :Create(
                    shot_2,
                    TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                    tween_properties_17
                )
                :Play()
            local tween_properties_18 = { Transparency = 1 }
            game:GetService("TweenService")
                :Create(
                    shot_2.UIStroke,
                    TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                    tween_properties_18
                )
                :Play()
            local tween_properties_19 = { BackgroundTransparency = 1 }
            game:GetService("TweenService")
                :Create(
                    shot_2.Result,
                    TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
                    tween_properties_19
                )
                :Play()
        end)
    end
end)
