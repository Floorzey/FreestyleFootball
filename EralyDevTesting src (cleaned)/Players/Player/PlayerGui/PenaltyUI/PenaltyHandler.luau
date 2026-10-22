local top_frame = script.Parent.topFrame
local bottom_frame = script.Parent.bottomFrame
local shottype = bottom_frame.SHOTTYPE
local button_right = shottype.ButtonRight
local button_left = shottype.ButtonLeft
local confirm_button = shottype.ConfirmButton
local countdown = top_frame.COUNTDOWN
local _ = top_frame.SHOT
local timing_bar = script.Parent.TimingBar
local bar = timing_bar.Bar
local values = { "CENTER", "BOTTOM LEFT", "TOP LEFT", "BOTTOM RIGHT", "TOP RIGHT" }
local local_player = game.Players.LocalPlayer
local character = local_player.Character or local_player.CharacterAdded:Wait()
character:WaitForChild("Humanoid")
local mouse = local_player:GetMouse()
local current_camera = game.Workspace.CurrentCamera
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key_handler_service = knit.GetService("KeyHandlerService")
local key = key_handler_service:GetKey("GoalClient")
local key2 = key_handler_service:GetKey("OOBClient")
local key3 = key_handler_service:GetKey("Penalty")

function pullUp()
    top_frame.Position = UDim2.new(0, 0, 0, -150)
    bottom_frame.Position = UDim2.new(0, 0, 1, 150)
    game:GetService("TweenService")
        :Create(top_frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 0),
        })
        :Play()
    game:GetService("TweenService")
        :Create(bottom_frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 1, 0),
        })
        :Play()
end

function dropAway()
    top_frame.Position = UDim2.new(0, 0, 0, 0)
    bottom_frame.Position = UDim2.new(0, 0, 1, 0)
    game:GetService("TweenService")
        :Create(top_frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, -150),
        })
        :Play()
    game:GetService("TweenService")
        :Create(bottom_frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 1, 150),
        })
        :Play()
end

function handleTiming()
    timing_bar.Position = UDim2.new(0.5, 0, 1, 50)
    game:GetService("TweenService")
        :Create(timing_bar, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, -200),
        })
        :Play()
    bar.Position = UDim2.new(0, 0, 0.5, 0)
    task.wait(0.4)
    local tween = game:GetService("TweenService")
        :Create(bar, TweenInfo.new(0.75, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, 0, 0.5, 0),
        })
    tween:Play()
    local connection = nil
    connection = tween.Completed:Connect(function()
        connection:Disconnect()
        game:GetService("TweenService")
            :Create(bar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0.5, 0),
            })
            :Play()
    end)
    local connection_2 = nil
    connection_2 = tween:GetPropertyChangedSignal("PlaybackState"):Connect(function()
        if tween.PlaybackState == Enum.PlaybackState.Paused then
            connection:Disconnect()
            connection_2:Disconnect()
        end
    end)

    tween.Destroying:Once(function()
        connection_2:Disconnect()
        connection:Disconnect()
    end)

    return tween
end

function hideTimingBar()
    game:GetService("TweenService")
        :Create(timing_bar, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 50),
        })
        :Play()
end

function clearMarkers()
    for _, descendant in pairs(game.Workspace.gameArea.Field.GoalboxAway:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") and descendant.Name == "SpotMarker" then
            descendant.Enabled = false
        end
    end

    for _, descendant_2 in pairs(game.Workspace.gameArea.Field.GoalboxHome:GetDescendants()) do
        if descendant_2:IsA("ParticleEmitter") and descendant_2.Name == "SpotMarker" then
            descendant_2.Enabled = false
        end
    end
end

local user_input_service = game:GetService("UserInputService")

key3.OnClientEvent:Connect(function()
    character = local_player.Character

    if not (character and character:FindFirstChild("Humanoid")) then
        return
    end

    local first_child = game.ReplicatedStorage.AnimFolder:FindFirstChild(local_player.Data.animationType.Value)

    if not first_child then
        return
    end

    local penalty_idle_track = character.Humanoid.Animator:LoadAnimation(first_child.PenaltyIdle)
    local penalty_shot_l_track = character.Humanoid.Animator:LoadAnimation(first_child.PenaltyShotL)
    local penalty_shot_r_track = character.Humanoid.Animator:LoadAnimation(first_child.PenaltyShotR)
    local text = local_player.SelectedTeam.Value == "Away" and "Home" or "Away"
    local camera_override = Instance.new("Folder")
    camera_override.Name = "CameraOverride"
    camera_override.Parent = character.Status

    task.spawn(function()
        repeat
            wait()
            current_camera.CameraType = Enum.CameraType.Scriptable
        until current_camera.CameraType == Enum.CameraType.Scriptable
    end)

    penalty_idle_track:Play()
    local shootout_camera_pos =
        game.Workspace.PlayerPositions[local_player.SelectedTeam.Value .. "Team"].ShootoutCameraPos
    current_camera.CFrame = shootout_camera_pos.CFrame
    local connection = game:GetService("RunService").RenderStepped:Connect(function()
        game:service("TweenService")
            :Create(current_camera, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                CFrame = shootout_camera_pos.CFrame * CFrame.Angles(
                    math.rad((mouse.Y - mouse.ViewSizeY / 2) / mouse.ViewSizeY * -10),
                    math.rad((mouse.X - mouse.ViewSizeX / 2) / mouse.ViewSizeX * -10),
                    0
                ),
            })
            :Play()
    end)
    task.wait(3)
    pullUp()
    local bindable_event = Instance.new("BindableEvent")
    local enabled = false

    task.spawn(function()
        local text_2 = 10
        countdown.Text = text_2

        for index = 1, 10 do
            task.wait(1)

            if enabled == true then
                return
            end

            text_2 = text_2 - 1
            countdown.Text = text_2
            local clone = game.ReplicatedStorage.UISounds.countdown_tick:Clone()
            clone.Parent = game.Workspace
            clone:Play()
            game.Debris:AddItem(clone, 3)
            local _ = index
        end

        bindable_event:Fire()
    end)

    local number = 1
    shottype.Text = values[number]
    clearMarkers()
    game.Workspace.gameArea.Field["Goalbox" .. text][values[number]].Attachment.SpotMarker.Enabled = true
    local connection_2 = button_right.MouseButton1Click:Connect(function()
        local clone = game.ReplicatedStorage.UISounds["ui-click"]:Clone()
        clone.Parent = game.Workspace
        clone:Play()
        game.Debris:AddItem(clone, 3)
        number = number + 1

        if number > 5 then
            number = 1
        end

        shottype.Text = values[number]
        clearMarkers()
        game.Workspace.gameArea.Field["Goalbox" .. text][values[number]].Attachment.SpotMarker.Enabled = true
    end)
    local connection_3 = button_left.MouseButton1Click:Connect(function()
        local clone = game.ReplicatedStorage.UISounds["ui-click"]:Clone()
        clone.Parent = game.Workspace
        clone:Play()
        game.Debris:AddItem(clone, 3)
        number = number - 1

        if number < 1 then
            number = 5
        end

        shottype.Text = values[number]
        clearMarkers()
        game.Workspace.gameArea.Field["Goalbox" .. text][values[number]].Attachment.SpotMarker.Enabled = true
    end)
    local connection_4 = confirm_button.MouseButton1Click:Connect(function()
        local clone = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
        clone.Parent = game.Workspace
        clone:Play()
        game.Debris:AddItem(clone, 3)
        enabled = true
        bindable_event:Fire()
    end)
    bindable_event.Event:Wait()
    connection:Disconnect()
    game:service("TweenService")
        :Create(current_camera, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CFrame = character.Neck_CameraSubject.CFrame * CFrame.new(character.Humanoid.CameraOffset.X, 0.5, 0),
        })
        :Play()

    task.delay(0.2, function()
        repeat
            wait()
            current_camera.CameraType = Enum.CameraType.Custom
        until current_camera.CameraType == Enum.CameraType.Custom

        camera_override:Destroy()
    end)

    dropAway()
    clearMarkers()
    connection_2:Disconnect()
    connection_3:Disconnect()
    connection_4:Disconnect()
    local enabled_2 = false
    penalty_idle_track:Stop()

    if number ~= 4 and number ~= 5 then
        penalty_shot_r_track = penalty_shot_l_track
    end

    penalty_shot_r_track:Play()
    local connection_6 = nil
    local connection_7 = nil
    local connection_8 = nil
    connection_6 = key.OnClientEvent:Connect(function()
        task.wait(3)
        penalty_shot_r_track:Stop()
        connection_6:Disconnect()
        connection_7:Disconnect()
        connection_8:Disconnect()
    end)
    connection_7 = key2.OnClientEvent:Connect(function()
        task.wait(2)
        penalty_shot_r_track:Stop()
        connection_6:Disconnect()
        connection_7:Disconnect()
        connection_8:Disconnect()
    end)
    connection_8 = game.ReplicatedStorage.ChildAdded:Connect(function(child)
        if child.Name ~= "RedCalled" then
            return
        end

        task.wait(2)
        penalty_shot_r_track:Stop()
        connection_6:Disconnect()
        connection_7:Disconnect()
        connection_8:Disconnect()
    end)
    local handle_timing_result = handleTiming()
    local connection_9 = nil
    connection_9 = user_input_service.InputBegan:Connect(function(input)
        if
            not (
                input.UserInputType == Enum.UserInputType.MouseButton1
                or (input.KeyCode == Enum.KeyCode.ButtonR1 or input.KeyCode == Enum.KeyCode.ButtonL1)
            )
        then
            return
        end

        if bar.Position.X.Scale > 0.9 then
            local clone = game.ReplicatedStorage.UISounds.ui_achieve:Clone()
            clone.Parent = game.Workspace
            clone:Play()
            game.Debris:AddItem(clone, 3)
            enabled_2 = true
        else
            local clone_2 = game.ReplicatedStorage.UISounds["ui-error3"]:Clone()
            clone_2.Parent = game.Workspace
            clone_2:Play()
            game.Debris:AddItem(clone_2, 3)
        end

        handle_timing_result:Pause()
        connection_9:Disconnect()
    end)
    local_player.PlayerGui.Buttons.penButtonFrame.TextButton.Visible = true
    local connection_5 = local_player.PlayerGui.Buttons.penButtonFrame.TextButton.Activated:Connect(function()
        if bar.Position.X.Scale > 0.9 then
            local clone = game.ReplicatedStorage.UISounds.ui_achieve:Clone()
            clone.Parent = game.Workspace
            clone:Play()
            game.Debris:AddItem(clone, 3)
            enabled_2 = true
        else
            local clone_2 = game.ReplicatedStorage.UISounds["ui-error3"]:Clone()
            clone_2.Parent = game.Workspace
            clone_2:Play()
            game.Debris:AddItem(clone_2, 3)
        end

        handle_timing_result:Pause()
        local_player.PlayerGui.Buttons.penButtonFrame.TextButton.Visible = false
        connection_9:Disconnect()
    end)
    task.wait(0.867)
    handle_timing_result:Cancel()
    connection_9:Disconnect()
    connection_5:Disconnect()

    task.delay(0.4, function()
        hideTimingBar()
        local_player.PlayerGui.Buttons.penButtonFrame.TextButton.Visible = false
    end)

    key3:FireServer(values[number], enabled_2)
    character.HumanoidRootPart.Anchored = false
    local camera_locked = Instance.new("Folder")
    camera_locked.Name = "CameraLocked"
    camera_locked.Parent = character.Status
    game.Debris:AddItem(camera_locked, 0.5)
    local body_velocity = Instance.new("BodyVelocity")
    body_velocity.Velocity = Vector3.new(0, 15, 0)
        + character.HumanoidRootPart.CFrame.rightVector * -15
        + character.HumanoidRootPart.CFrame.lookVector * 15
    body_velocity.MaxForce = Vector3.new(100000, 100000, 100000)
    body_velocity.Parent = character.HumanoidRootPart
    game.Debris:AddItem(body_velocity, 0.15)
end)
