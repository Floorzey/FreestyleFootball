local top_frame = script.Parent.topFrame
local bottom_frame = script.Parent.bottomFrame
local shottype = bottom_frame.SHOTTYPE
local button_right = shottype.ButtonRight
local button_left = shottype.ButtonLeft
local confirm_button = shottype.ConfirmButton
local countdown = top_frame.COUNTDOWN
local timing_bar = script.Parent.TimingBar
local bar = timing_bar.Bar
local values = { "CENTER", "BOTTOM LEFT", "TOP LEFT", "BOTTOM RIGHT", "TOP RIGHT" }
local local_player = game.Players.LocalPlayer
local character = local_player.Character or (local_player.CharacterAdded:Wait())
character:WaitForChild("Humanoid")
local mouse = local_player:GetMouse()
local current_camera = game.Workspace.CurrentCamera
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key_handler_service = knit.GetService("KeyHandlerService")
local key = key_handler_service:GetKey("GoalClient")
local key_2 = key_handler_service:GetKey("OOBClient")
local remote_event = key_handler_service:GetKey("Penalty")

function pullUp()
    top_frame.Position = UDim2.new(0, 0, 0, -150)
    bottom_frame.Position = UDim2.new(0, 0, 1, 150)
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0, 0, 0, 0)
    tween_service:Create(top_frame, tween_info, tween_properties):Play()
    local tween_service_2 = game:GetService("TweenService")
    local tween_info_2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = {}
    tween_properties_2.Position = UDim2.new(0, 0, 1, 0)
    tween_service_2:Create(bottom_frame, tween_info_2, tween_properties_2):Play()
end

function dropAway()
    top_frame.Position = UDim2.new(0, 0, 0, 0)
    bottom_frame.Position = UDim2.new(0, 0, 1, 0)
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0, 0, 0, -150)
    tween_service:Create(top_frame, tween_info, tween_properties):Play()
    local tween_service_2 = game:GetService("TweenService")
    local tween_info_2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = {}
    tween_properties_2.Position = UDim2.new(0, 0, 1, 150)
    tween_service_2:Create(bottom_frame, tween_info_2, tween_properties_2):Play()
end

function handleTiming()
    timing_bar.Position = UDim2.new(0.5, 0, 1, 50)
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0.5, 0, 1, -200)
    tween_service:Create(timing_bar, tween_info, tween_properties):Play()
    bar.Position = UDim2.new(0, 0, 0.5, 0)
    task.wait(0.4)
    local tween = game:GetService("TweenService"):Create(
        bar,
        TweenInfo.new(0.75, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
        { Position = UDim2.new(1, 0, 0.5, 0) }
    )
    tween:Play()
    local connection_3 = nil
    local connection = tween.Completed:Connect(function()
        connection_3:Disconnect()
        local tween_service_2 = game:GetService("TweenService")
        local tween_info_2 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_2 = {}
        tween_properties_2.Position = UDim2.new(0, 0, 0.5, 0)
        tween_service_2:Create(bar, tween_info_2, tween_properties_2):Play()
    end)
    connection_3 = connection
    local connection_4 = nil
    local connection_2 = tween:GetPropertyChangedSignal("PlaybackState"):Connect(function()
        if tween.PlaybackState ~= Enum.PlaybackState.Paused then
            return
        end
        connection_3:Disconnect()
        connection_4:Disconnect()
    end)
    connection_4 = connection_2
    tween.Destroying:Once(function()
        connection_4:Disconnect()
        connection_3:Disconnect()
    end)
    return tween
end

function hideTimingBar()
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0.5, 0, 1, 50)
    tween_service:Create(timing_bar, tween_info, tween_properties):Play()
end

function clearMarkers()
    for _, descendant in pairs(game.Workspace.gameArea.Field.GoalboxAway:GetDescendants()) do
        if not (descendant:IsA("ParticleEmitter")) then
            continue
        end
        if descendant.Name == "SpotMarker" then
            descendant.Enabled = false
        end
    end
    for _, descendant_2 in pairs(game.Workspace.gameArea.Field.GoalboxHome:GetDescendants()) do
        if not (descendant_2:IsA("ParticleEmitter")) then
            continue
        end
        if descendant_2.Name == "SpotMarker" then
            descendant_2.Enabled = false
        end
    end
end

local user_input_service = game:GetService("UserInputService")
local animation_track = character.Humanoid.Animator:LoadAnimation(
    game.ReplicatedStorage.AnimFolder:FindFirstChild(local_player.Data.animationType.Value).PenaltyIdle
)
local animation_track_2 = character.Humanoid.Animator:LoadAnimation(
    game.ReplicatedStorage.AnimFolder:FindFirstChild(local_player.Data.animationType.Value).PenaltyShotL
)
local animation_track_3 = character.Humanoid.Animator:LoadAnimation(
    game.ReplicatedStorage.AnimFolder:FindFirstChild(local_player.Data.animationType.Value).PenaltyShotR
)
remote_event.OnClientEvent:Connect(function()
    if not character then
        return
    end
    local is_selected_team_value = ((local_player.SelectedTeam.Value ~= "Away") and "Away") or "Home"
    local folder = Instance.new("Folder")
    folder.Name = "CameraOverride"
    folder.Parent = character.Status
    task.spawn(function()
        repeat
            wait()
            current_camera.CameraType = Enum.CameraType.Scriptable
        until current_camera.CameraType == Enum.CameraType.Scriptable
    end)
    animation_track:Play()
    local shootout_camera_pos =
        game.Workspace.PlayerPositions[local_player.SelectedTeam.Value .. "Team"].ShootoutCameraPos
    current_camera.CFrame = shootout_camera_pos.CFrame
    local connection = game:GetService("RunService").RenderStepped:Connect(function()
        local tween_service_2 = game:service("TweenService")
        local tween_info_2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_2 = {}
        tween_properties_2.CFrame = shootout_camera_pos.CFrame
            * CFrame.Angles(
                math.rad(((mouse.Y - (mouse.ViewSizeY / 2)) / mouse.ViewSizeY) * -10),
                math.rad(((mouse.X - (mouse.ViewSizeX / 2)) / mouse.ViewSizeX) * -10),
                0
            )
        tween_service_2:Create(current_camera, tween_info_2, tween_properties_2):Play()
    end)
    task.wait(3)
    pullUp()
    local bindable_event = Instance.new("BindableEvent")
    local enabled = false
    task.spawn(function()
        local text = 10
        countdown.Text = text
        for _ = 1, 10 do
            task.wait(1)
            if enabled ~= true then
                text = text - 1
                countdown.Text = text
                local clone = game.ReplicatedStorage.UISounds.countdown_tick:Clone()
                clone.Parent = game.Workspace
                clone:Play()
                game.Debris:AddItem(clone, 3)
                continue
            end
            return
        end
        bindable_event:Fire()
    end)
    local number = 1
    shottype.Text = values[number]
    clearMarkers()
    game.Workspace.gameArea.Field["Goalbox" .. is_selected_team_value][values[number]].Attachment.SpotMarker.Enabled =
        true
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
        game.Workspace.gameArea.Field["Goalbox" .. is_selected_team_value][values[number]].Attachment.SpotMarker.Enabled =
            true
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
        game.Workspace.gameArea.Field["Goalbox" .. is_selected_team_value][values[number]].Attachment.SpotMarker.Enabled =
            true
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
    local tween_service = game:service("TweenService")
    local tween_info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.CFrame = character.Neck_CameraSubject.CFrame
        * CFrame.new(character.Humanoid.CameraOffset.X, 0.5, 0)
    tween_service:Create(current_camera, tween_info, tween_properties):Play()
    task.delay(0.2, function()
        repeat
            wait()
            current_camera.CameraType = Enum.CameraType.Custom
        until current_camera.CameraType == Enum.CameraType.Custom
        folder:Destroy()
    end)
    dropAway()
    clearMarkers()
    connection_2:Disconnect()
    connection_3:Disconnect()
    connection_4:Disconnect()
    local enabled_2 = false
    animation_track:Stop()
    local animation_track_4
    if number == 4 or number == 5 then
        animation_track_4 = animation_track_3
    else
        animation_track_4 = animation_track_2
    end
    animation_track_4:Play()
    local connection_10 = nil
    local connection_11 = nil
    local connection_12 = nil
    local connection_5 = key.OnClientEvent:Connect(function()
        task.wait(3)
        animation_track_4:Stop()
        connection_10:Disconnect()
        connection_11:Disconnect()
        connection_12:Disconnect()
    end)
    connection_10 = connection_5
    local connection_6 = key_2.OnClientEvent:Connect(function()
        task.wait(2)
        animation_track_4:Stop()
        connection_10:Disconnect()
        connection_11:Disconnect()
        connection_12:Disconnect()
    end)
    connection_11 = connection_6
    local connection_7 = game.ReplicatedStorage.ChildAdded:Connect(function(child)
        if child.Name ~= "RedCalled" then
            return
        end
        task.wait(2)
        animation_track_4:Stop()
        connection_10:Disconnect()
        connection_11:Disconnect()
        connection_12:Disconnect()
    end)
    connection_12 = connection_7
    local handle_timing_result = handleTiming()
    local connection_13 = nil
    local connection_8 = user_input_service.InputBegan:Connect(function(input)
        if
            input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.KeyCode ~= Enum.KeyCode.ButtonR1
            and input.KeyCode ~= Enum.KeyCode.ButtonL1
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
        connection_13:Disconnect()
    end)
    connection_13 = connection_8
    local_player.PlayerGui.Buttons.penButtonFrame.TextButton.Visible = true
    local connection_9 = local_player.PlayerGui.Buttons.penButtonFrame.TextButton.Activated:Connect(function()
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
        connection_13:Disconnect()
    end)
    task.wait(0.867)
    handle_timing_result:Cancel()
    connection_13:Disconnect()
    connection_9:Disconnect()
    task.delay(0.4, function()
        hideTimingBar()
        local_player.PlayerGui.Buttons.penButtonFrame.TextButton.Visible = false
    end)
    remote_event:FireServer(values[number], enabled_2)
    character.HumanoidRootPart.Anchored = false
    local folder_2 = Instance.new("Folder")
    folder_2.Name = "CameraLocked"
    folder_2.Parent = character.Status
    game.Debris:AddItem(folder_2, 0.5)
    local body_velocity = Instance.new("BodyVelocity")
    body_velocity.Velocity = (Vector3.new(0, 15, 0) + (character.HumanoidRootPart.CFrame.rightVector * -15))
        + (character.HumanoidRootPart.CFrame.lookVector * 15)
    body_velocity.MaxForce = Vector3.new(1e+05, 1e+05, 1e+05)
    body_velocity.Parent = character.HumanoidRootPart
    game.Debris:AddItem(body_velocity, 0.15)
end)
