local oob = script.Parent.OOB
local offsides = script.Parent.OFFSIDES
local doubletouch = script.Parent.DOUBLETOUCH
local disallowedgoal = script.Parent.DISALLOWEDGOAL
local goal = script.Parent.GOAL
local team_steal = script.Parent.TeamSteal
local selfgoal = script.Parent.SELFGOAL
local upper_shutter = script.Parent.UpperShutter
local lower_shutter = script.Parent.LowerShutter

function shutter()
    upper_shutter.Visible = true
    lower_shutter.Visible = true
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Size = UDim2.new(1, 0, 0.55, 0)
    tween_service:Create(lower_shutter, tween_info, tween_properties):Play()
    local tween_service_2 = game:GetService("TweenService")
    local tween_info_2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = {}
    tween_properties_2.Size = UDim2.new(1, 0, 0.55, 0)
    tween_service_2:Create(upper_shutter, tween_info_2, tween_properties_2):Play()

    task.delay(0.5, function()
        game.Lighting.Blur.Size = 2
        oob.Visible = false
        goal.Visible = false
        selfgoal.Visible = false
        task.wait(0.5)
        local tween_service_3 = game:GetService("TweenService")
        local tween_info_3 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_3 = {}
        tween_properties_3.Size = UDim2.new(1, 0, 0, 0)
        tween_service_3:Create(lower_shutter, tween_info_3, tween_properties_3):Play()
        local tween_service_4 = game:GetService("TweenService")
        local tween_info_4 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_4 = {}
        tween_properties_4.Size = UDim2.new(1, 0, 0, 0)
        tween_service_4:Create(upper_shutter, tween_info_4, tween_properties_4):Play()
        task.wait(0.5)
        upper_shutter.Visible = false
        lower_shutter.Visible = false
    end)
end

game.ReplicatedStorage.Remotes.OOBClient.OnClientEvent:Connect(function(text)
    oob.Visible = true
    oob.Size = UDim2.new(0, 0, 0, 0)
    oob.OOB.Text = "OUT OF BOUNDS"

    if text ~= nil then
        oob.playerName.Text = text
    else
        oob.playerName.Text = "<PLAYER LEFT>"
    end

    local tween_properties = { TextTransparency = 0, TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(oob.OOB, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties)
        :Play()
    local tween_properties_2 = { TextTransparency = 0, TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(oob.playerName, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_2)
        :Play()

    task.delay(2, function()
        local tween_properties_3 = { TextTransparency = 1, TextStrokeTransparency = 1 }
        game:GetService("TweenService")
            :Create(oob.OOB, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_3)
            :Play()
        local tween_properties_4 = { TextTransparency = 1, TextStrokeTransparency = 1 }
        game:GetService("TweenService")
            :Create(
                oob.playerName,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_4
            )
            :Play()
        task.wait(0.5)
        oob.Visible = false
    end)
end)

game.ReplicatedStorage.Remotes.FoulClient.OnClientEvent:Connect(function(text)
    oob.Visible = true
    oob.Size = UDim2.new(0, 0, 0, 0)
    oob.OOB.Text = "FOUL"

    if text ~= nil then
        oob.playerName.Text = text
    else
        oob.playerName.Text = "<PLAYER LEFT>"
    end

    local tween_properties = { TextTransparency = 0, TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(oob.OOB, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties)
        :Play()
    local tween_properties_2 = { TextTransparency = 0, TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(oob.playerName, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_2)
        :Play()

    task.delay(2, function()
        local tween_properties_3 = { TextTransparency = 1, TextStrokeTransparency = 1 }
        game:GetService("TweenService")
            :Create(oob.OOB, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_3)
            :Play()
        local tween_properties_4 = { TextTransparency = 1, TextStrokeTransparency = 1 }
        game:GetService("TweenService")
            :Create(
                oob.playerName,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_4
            )
            :Play()
        task.wait(0.5)
        oob.Visible = false
    end)
end)

game.ReplicatedStorage.Remotes.OffsidesClient.OnClientEvent:Connect(function(text)
    offsides.Visible = true
    offsides.Size = UDim2.new(0, 0, 0, 0)

    if text ~= nil then
        offsides.playerName.Text = text
    else
        offsides.playerName.Text = "<PLAYER LEFT>"
    end

    local tween_properties = { TextTransparency = 0, TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(offsides.OFFSIDE, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties)
        :Play()
    local tween_properties_2 = { TextTransparency = 0, TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            offsides.playerName,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_2
        )
        :Play()

    task.delay(2, function()
        local tween_properties_3 = { TextTransparency = 1, TextStrokeTransparency = 1 }
        game:GetService("TweenService")
            :Create(
                offsides.OFFSIDE,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_3
            )
            :Play()
        local tween_properties_4 = { TextTransparency = 1, TextStrokeTransparency = 1 }
        game:GetService("TweenService")
            :Create(
                offsides.playerName,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_4
            )
            :Play()
        task.wait(0.5)
        offsides.Visible = false
    end)
end)

game.ReplicatedStorage.Remotes.TeamStealNotification.OnClientEvent:Connect(function(argument)
    local clone = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
    clone.Parent = game.Workspace
    clone:Play()
    game.Debris:AddItem(clone, 3)
    team_steal.Visible = true
    team_steal.Size = UDim2.new(0, 0, 0, 0)
    local tween_properties = { TextTransparency = 0, TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            team_steal.TextLabel,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()

    task.delay(2, function()
        local tween_properties_2 = { TextTransparency = 1, TextStrokeTransparency = 1 }
        game:GetService("TweenService")
            :Create(
                team_steal.TextLabel,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_2
            )
            :Play()
        task.wait(0.5)
        team_steal.Visible = false
    end)
end)

game.ReplicatedStorage.Remotes.DoubleTouch.OnClientEvent:Connect(function(text)
    doubletouch.Visible = true
    doubletouch.Size = UDim2.new(0, 0, 0, 0)

    if text ~= nil then
        doubletouch.playerName.Text = text
    else
        doubletouch.playerName.Text = "<PLAYER LEFT>"
    end

    local tween_properties = { TextTransparency = 0, TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            doubletouch.TOUCH,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    local tween_properties_2 = { TextTransparency = 0, TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            doubletouch.playerName,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_2
        )
        :Play()

    task.delay(2, function()
        local tween_properties_3 = { TextTransparency = 1, TextStrokeTransparency = 1 }
        game:GetService("TweenService")
            :Create(
                doubletouch.TOUCH,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_3
            )
            :Play()
        local tween_properties_4 = { TextTransparency = 1, TextStrokeTransparency = 1 }
        game:GetService("TweenService")
            :Create(
                doubletouch.playerName,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_4
            )
            :Play()
        task.wait(0.5)
        doubletouch.Visible = false
    end)
end)

game.ReplicatedStorage.Remotes.DisallowedGoal.OnClientEvent:Connect(function(text)
    disallowedgoal.Visible = true
    disallowedgoal.Size = UDim2.new(0, 0, 0, 0)

    if text ~= nil then
        disallowedgoal.playerName.Text = text
    else
        disallowedgoal.playerName.Text = "<PLAYER LEFT>"
    end

    local tween_properties = { TextTransparency = 0, TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            disallowedgoal.TOUCH,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    local tween_properties_2 = { TextTransparency = 0, TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            disallowedgoal.playerName,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_2
        )
        :Play()

    task.delay(2, function()
        local tween_properties_3 = { TextTransparency = 1, TextStrokeTransparency = 1 }
        game:GetService("TweenService")
            :Create(
                disallowedgoal.TOUCH,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_3
            )
            :Play()
        local tween_properties_4 = { TextTransparency = 1, TextStrokeTransparency = 1 }
        game:GetService("TweenService")
            :Create(
                disallowedgoal.playerName,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_4
            )
            :Play()
        task.wait(0.5)
        disallowedgoal.Visible = false
    end)
end)

game.ReplicatedStorage.Remotes.GoalClient.OnClientEvent:Connect(function(player)
    goal.Visible = true
    goal.Size = UDim2.new(0, 0, 0, 5)

    if player ~= nil then
        goal.playerName.Text = player.DisplayName
    else
        goal.playerName.Text = "<PLAYER LEFT>"
    end

    local tween_properties = { Size = 20 }
    game:GetService("TweenService")
        :Create(
            game.Lighting.Blur,
            TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = {}
    tween_properties_2.Size = UDim2.new(1, 0, 0, 5)
    tween_service:Create(goal, tween_info, tween_properties_2):Play()

    task.delay(0.5, function()
        local tween_service_2 = game:GetService("TweenService")
        local tween_info_2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_3 = {}
        tween_properties_3.Size = UDim2.new(1, 0, 0, 75)
        tween_service_2:Create(goal, tween_info_2, tween_properties_3):Play()

        task.delay(2, function()
            local tween_service_3 = game:GetService("TweenService")
            local tween_info_3 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_4 = {}
            tween_properties_4.Size = UDim2.new(1, 0, 0, 5)
            tween_service_3:Create(goal, tween_info_3, tween_properties_4):Play()
            shutter()
            task.wait(0.55)
            script.Parent.LowerCinematicBar.Visible = true
            script.Parent.UpperCinematicBar.Visible = true
            game.Workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
            task.wait(4.25)
            shutter()
            task.wait(0.55)
            script.Parent.LowerCinematicBar.Visible = false
            script.Parent.UpperCinematicBar.Visible = false
            game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Neck_CameraSubject
        end)
    end)
end)

game.ReplicatedStorage.Remotes.SelfGoalClient.OnClientEvent:Connect(function(text)
    selfgoal.Visible = true
    selfgoal.Size = UDim2.new(0, 0, 0, 5)

    if text ~= nil then
        selfgoal.playerName.Text = text
    else
        selfgoal.playerName.Text = "<PLAYER LEFT>"
    end

    local tween_properties = { Size = 20 }
    game:GetService("TweenService")
        :Create(
            game.Lighting.Blur,
            TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = {}
    tween_properties_2.Size = UDim2.new(1, 0, 0, 5)
    tween_service:Create(selfgoal, tween_info, tween_properties_2):Play()

    task.delay(0.5, function()
        local tween_service_2 = game:GetService("TweenService")
        local tween_info_2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_3 = {}
        tween_properties_3.Size = UDim2.new(1, 0, 0, 75)
        tween_service_2:Create(selfgoal, tween_info_2, tween_properties_3):Play()

        task.delay(2, function()
            local tween_service_3 = game:GetService("TweenService")
            local tween_info_3 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_4 = {}
            tween_properties_4.Size = UDim2.new(1, 0, 0, 5)
            tween_service_3:Create(selfgoal, tween_info_3, tween_properties_4):Play()
            shutter()
        end)
    end)
end)

function shutterEventFunc()
    upper_shutter.Visible = true
    lower_shutter.Visible = true
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Size = UDim2.new(1, 0, 0.55, 0)
    tween_service:Create(lower_shutter, tween_info, tween_properties):Play()
    local tween_service_2 = game:GetService("TweenService")
    local tween_info_2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = {}
    tween_properties_2.Size = UDim2.new(1, 0, 0.55, 0)
    tween_service_2:Create(upper_shutter, tween_info_2, tween_properties_2):Play()

    task.delay(0.5, function()
        task.wait(0.5)
        local tween_service_3 = game:GetService("TweenService")
        local tween_info_3 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_3 = {}
        tween_properties_3.Size = UDim2.new(1, 0, 0, 0)
        tween_service_3:Create(lower_shutter, tween_info_3, tween_properties_3):Play()
        local tween_service_4 = game:GetService("TweenService")
        local tween_info_4 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_4 = {}
        tween_properties_4.Size = UDim2.new(1, 0, 0, 0)
        tween_service_4:Create(upper_shutter, tween_info_4, tween_properties_4):Play()
        task.wait(0.5)
        upper_shutter.Visible = false
        lower_shutter.Visible = false
    end)
end

game.ReplicatedStorage.Remotes.Shutter.OnClientEvent:Connect(shutterEventFunc)
game.ReplicatedStorage.Shutter.Event:Connect(shutterEventFunc)

game.ReplicatedStorage.Remotes.GainPointsNotification.OnClientEvent:Connect(function(text)
    local clone = game.ReplicatedStorage.UISounds.notification_sound_previs1:Clone()
    clone.Parent = game.Workspace
    clone:Play()
    game.Debris:AddItem(clone, 5)
    local clone_2 = script.PointNotifications:Clone()
    clone_2.Parent = script.Parent.PointNotificationFrame
    clone_2.Text = text
    local tween_properties = { TextTransparency = 0, TextStrokeTransparency = 0 }
    game:GetService("TweenService")
        :Create(clone_2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties)
        :Play()

    task.delay(1, function()
        local tween_properties_2 = { TextTransparency = 1, TextStrokeTransparency = 1 }
        game:GetService("TweenService")
            :Create(clone_2, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties_2)
            :Play()
        task.wait(0.8)
        clone_2.Visible = false
    end)

    game.Debris:AddItem(clone_2, 3)
end)
