local oob = script.Parent.OOB
local offsides = script.Parent.OFFSIDES
local doubletouch = script.Parent.DOUBLETOUCH
local _ = script.Parent.DISALLOWEDGOAL
local goal = script.Parent.GOAL
local team_steal = script.Parent.TeamSteal
local selfgoal = script.Parent.SELFGOAL
local upper_shutter = script.Parent.UpperShutter
local lower_shutter = script.Parent.LowerShutter
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key_handler_service = knit.GetService("KeyHandlerService")
local number = 0

local function clear_goal_cinematic()
    script.Parent.LowerCinematicBar.Visible = false
    script.Parent.UpperCinematicBar.Visible = false
    local character = game.Players.LocalPlayer.Character

    if character then
        character = character:FindFirstChild("Neck_CameraSubject") or character:FindFirstChildOfClass("Humanoid")
    end

    if character then
        game.Workspace.CurrentCamera.CameraSubject = character
    end
end

game.ReplicatedStorage.ChildAdded:Connect(function(child)
    if
        child.Name ~= "gameStarting"
        and (
            child.Name ~= "playResetting"
            and (child.Name ~= "Shootout" and (child.Name ~= "FinalShootout" and child.Name ~= "EndScreen"))
        )
    then
        return
    end

    number = number + 1
    clear_goal_cinematic()
end)

function shutter()
    if game.Players.LocalPlayer:GetAttribute("Freecam") then
        return
    end

    upper_shutter.Visible = true
    lower_shutter.Visible = true
    game:GetService("TweenService")
        :Create(lower_shutter, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0.7, 0),
        })
        :Play()
    game:GetService("TweenService")
        :Create(upper_shutter, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0.7, 0),
        })
        :Play()

    task.delay(0.5, function()
        game.Lighting.Blur.Size = 2
        oob.Visible = false
        goal.Visible = false
        selfgoal.Visible = false
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

key_handler_service:GetKey("OOBClient").OnClientEvent:Connect(function(text)
    oob.Visible = true
    oob.Size = UDim2.new(0, 0, 0, 0)
    oob.OOB.Text = "OUT OF BOUNDS"

    if text == nil then
        oob.playerName.Text = "<PLAYER LEFT>"
    else
        oob.playerName.Text = text
    end

    game:GetService("TweenService")
        :Create(oob.OOB, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0,
            TextStrokeTransparency = 0.5,
        })
        :Play()
    game:GetService("TweenService")
        :Create(oob.playerName, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0,
            TextStrokeTransparency = 0.5,
        })
        :Play()

    task.delay(2, function()
        game:GetService("TweenService")
            :Create(oob.OOB, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 1,
                TextStrokeTransparency = 1,
            })
            :Play()
        game:GetService("TweenService")
            :Create(oob.playerName, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 1,
                TextStrokeTransparency = 1,
            })
            :Play()
        task.wait(0.5)
        oob.Visible = false
    end)
end)

key_handler_service:GetKey("FoulClient").OnClientEvent:Connect(function(text)
    oob.Visible = true
    oob.Size = UDim2.new(0, 0, 0, 0)
    oob.OOB.Text = "FOUL"

    if text == nil then
        oob.playerName.Text = "<PLAYER LEFT>"
    else
        oob.playerName.Text = text
    end

    game:GetService("TweenService")
        :Create(oob.OOB, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0,
            TextStrokeTransparency = 0.5,
        })
        :Play()
    game:GetService("TweenService")
        :Create(oob.playerName, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0,
            TextStrokeTransparency = 0.5,
        })
        :Play()

    task.delay(2, function()
        game:GetService("TweenService")
            :Create(oob.OOB, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 1,
                TextStrokeTransparency = 1,
            })
            :Play()
        game:GetService("TweenService")
            :Create(oob.playerName, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 1,
                TextStrokeTransparency = 1,
            })
            :Play()
        task.wait(0.5)
        oob.Visible = false
    end)
end)

key_handler_service:GetKey("OffsidesClient").OnClientEvent:Connect(function(text)
    offsides.Visible = true
    offsides.Size = UDim2.new(0, 0, 0, 0)

    if text == nil then
        offsides.playerName.Text = "<PLAYER LEFT>"
    else
        offsides.playerName.Text = text
    end

    game:GetService("TweenService")
        :Create(offsides.OFFSIDE, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0,
            TextStrokeTransparency = 0.5,
        })
        :Play()
    game:GetService("TweenService")
        :Create(offsides.playerName, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0,
            TextStrokeTransparency = 0.5,
        })
        :Play()

    task.delay(2, function()
        game:GetService("TweenService")
            :Create(offsides.OFFSIDE, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 1,
                TextStrokeTransparency = 1,
            })
            :Play()
        game:GetService("TweenService")
            :Create(offsides.playerName, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 1,
                TextStrokeTransparency = 1,
            })
            :Play()
        task.wait(0.5)
        offsides.Visible = false
    end)
end)

key_handler_service:GetKey("TeamStealNotification").OnClientEvent:Connect(function(argument)
    local clone = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
    clone.Parent = game.Workspace
    clone:Play()
    game.Debris:AddItem(clone, 3)
    team_steal.Visible = true
    team_steal.Size = UDim2.new(0, 0, 0, 0)
    game:GetService("TweenService")
        :Create(team_steal.TextLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0,
            TextStrokeTransparency = 0.5,
        })
        :Play()

    task.delay(2, function()
        game:GetService("TweenService")
            :Create(team_steal.TextLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 1,
                TextStrokeTransparency = 1,
            })
            :Play()
        task.wait(0.5)
        team_steal.Visible = false
    end)
end)

key_handler_service:GetKey("NotifClient").OnClientEvent:Connect(function(text, text_2)
    doubletouch.Visible = true
    doubletouch.Size = UDim2.new(0, 0, 0, 0)

    if text == nil then
        doubletouch.playerName.Text = "<PLAYER LEFT>"
    else
        doubletouch.playerName.Text = text
    end

    doubletouch.TOUCH.Text = text_2
    game:GetService("TweenService")
        :Create(doubletouch.TOUCH, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0,
            TextStrokeTransparency = 0.5,
        })
        :Play()
    game:GetService("TweenService")
        :Create(doubletouch.playerName, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0,
            TextStrokeTransparency = 0.5,
        })
        :Play()

    task.delay(2, function()
        game:GetService("TweenService")
            :Create(doubletouch.TOUCH, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 1,
                TextStrokeTransparency = 1,
            })
            :Play()
        game:GetService("TweenService")
            :Create(doubletouch.playerName, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 1,
                TextStrokeTransparency = 1,
            })
            :Play()
        task.wait(0.5)
        doubletouch.Visible = false
    end)
end)

key_handler_service:GetKey("GoalClient").OnClientEvent:Connect(function(player, argument, argument_2)
    number = number + 1
    local number_2 = number
    clear_goal_cinematic()
    goal.Visible = true
    goal.Size = UDim2.new(0, 0, 0, 5)
    goal.playerName.Text = player and (player.DisplayName or "<PLAYER LEFT>") or "<PLAYER LEFT>"
    game:GetService("TweenService")
        :Create(game.Lighting.Blur, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = 20,
        })
        :Play()
    game:GetService("TweenService")
        :Create(goal, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0, 5),
        })
        :Play()

    task.delay(0.5, function()
        if number_2 ~= number then
            return
        end

        game:GetService("TweenService")
            :Create(goal, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 75),
            })
            :Play()

        task.delay(2, function()
            if number_2 ~= number then
                return
            end

            game:GetService("TweenService")
                :Create(goal, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 0, 5),
                })
                :Play()
            shutter()
            task.wait(0.55)

            if number_2 ~= number then
                return
            end

            if not (player and (player.Character and player.Character:FindFirstChildOfClass("Humanoid"))) then
                clear_goal_cinematic()

                return
            end

            script.Parent.LowerCinematicBar.Visible = true
            script.Parent.UpperCinematicBar.Visible = true
            game.Workspace.CurrentCamera.CameraSubject = player.Character:FindFirstChildOfClass("Humanoid")
            local task_wait = task.wait
            local tonumber_result = tonumber(argument) or 5.5
            task_wait((math.clamp(tonumber_result, 1, 5.5)))

            if number_2 ~= number then
                return
            end

            shutter()
            clear_goal_cinematic()
        end)
    end)
end)

key_handler_service:GetKey("SelfGoalClient").OnClientEvent:Connect(function(text)
    selfgoal.Visible = true
    selfgoal.Size = UDim2.new(0, 0, 0, 5)

    if text == nil then
        selfgoal.playerName.Text = "<PLAYER LEFT>"
    else
        selfgoal.playerName.Text = text
    end

    game:GetService("TweenService")
        :Create(game.Lighting.Blur, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = 20,
        })
        :Play()
    game:GetService("TweenService")
        :Create(selfgoal, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0, 5),
        })
        :Play()

    task.delay(0.5, function()
        game:GetService("TweenService")
            :Create(selfgoal, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 75),
            })
            :Play()

        task.delay(2, function()
            game:GetService("TweenService")
                :Create(selfgoal, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 0, 5),
                })
                :Play()
            shutter()
        end)
    end)
end)

function shutterEventFunc()
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

key_handler_service:GetKey("Shutter").OnClientEvent:Connect(shutterEventFunc)
game.ReplicatedStorage.Shutter.Event:Connect(shutterEventFunc)

key_handler_service:GetKey("GainPointsNotification").OnClientEvent:Connect(function(text)
    local clone = game.ReplicatedStorage.UISounds.notification_sound_previs1:Clone()
    clone.Parent = game.Workspace
    clone:Play()
    game.Debris:AddItem(clone, 5)
    local clone_2 = script.PointNotifications:Clone()
    clone_2.Parent = script.Parent.PointNotificationFrame
    clone_2.Text = text
    game:GetService("TweenService")
        :Create(clone_2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0,
            TextStrokeTransparency = 0,
        })
        :Play()

    task.delay(1, function()
        game:GetService("TweenService")
            :Create(clone_2, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 1,
                TextStrokeTransparency = 1,
            })
            :Play()
        task.wait(0.8)
        clone_2.Visible = false
    end)

    game.Debris:AddItem(clone_2, 3)
end)
