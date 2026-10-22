local top_frame = script.Parent.topFrame
local bottom_frame = script.Parent.bottomFrame
local confirm_button = bottom_frame.ConfirmButton
local countdown = top_frame.COUNTDOWN
local _ = top_frame.SHOT
local timing_bar = script.Parent.TimingBar
local bar = timing_bar.Bar
local local_player = game.Players.LocalPlayer
local character = local_player.Character or local_player.CharacterAdded:Wait()
character:WaitForChild("Humanoid")
local_player:GetMouse()
local current_camera = game.Workspace.CurrentCamera
local free_kick_ui = game.ReplicatedStorage.VFX.FreeKickUI
local instance = nil

function pullUp()
    instance = free_kick_ui:Clone()
    instance.Parent = game.Workspace.Temp.Ball
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
    instance:Destroy()
    instance = nil
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
    task.wait(0.45)
    local tween = game:GetService("TweenService")
        :Create(bar, TweenInfo.new(0.867, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
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

local user_input_service = game:GetService("UserInputService")
local run_service = game:GetService("RunService")
local cframe = CFrame.new(0, 4, 12)

function radifyVector(argument: vector)
    return CFrame.Angles(math.rad(argument.X), math.rad(argument.Y), (math.rad(argument.Z)))
end

game.ReplicatedStorage.Remotes.FreeKick.OnClientEvent:Connect(function()
    character = local_player.Character

    if not (character and character:FindFirstChild("Humanoid")) then
        return
    end

    local anim_folder = game.ReplicatedStorage.AnimFolder:FindFirstChild(local_player.Data.animationType.Value)
        or game.ReplicatedStorage.AnimFolder
    local penalty_idle_track = character.Humanoid.Animator:LoadAnimation(anim_folder.PenaltyIdle)
    local penalty_shot_l_track = character.Humanoid.Animator:LoadAnimation(anim_folder.PenaltyShotL)
    character.Humanoid.Animator:LoadAnimation(anim_folder.PenaltyShotR)
    local ball = game.Workspace.Temp:FindFirstChild("Ball")

    if not ball then
        return
    end

    local _ = local_player.SelectedTeam.Value == "Away"
    local camera_override = Instance.new("Folder")
    camera_override.Name = "CameraOverride"
    camera_override.Parent = character.Status

    task.spawn(function()
        repeat
            current_camera.CameraType = Enum.CameraType.Scriptable
            wait()
        until current_camera.CameraType == Enum.CameraType.Scriptable
    end)

    penalty_idle_track:Play()
    local number = 0
    current_camera.CFrame = ball.CFrame * radifyVector(Vector3.new(0, 3, 0) * number) * cframe
    local connection = run_service.RenderStepped:Connect(function(delta_time)
        if user_input_service:IsKeyDown("D") then
            number = number + 30 * delta_time
        elseif user_input_service:IsKeyDown("A") then
            number = number - 30 * delta_time
        end

        if number > 120 then
            number = 120
        end

        if number < -120 then
            number = -120
        end

        current_camera.CFrame = ball.CFrame * radifyVector(Vector3.new(0, 3, 0) * number) * cframe
    end)
    task.wait(3)
    pullUp()
    local enabled = false
    local enabled_2 = false
    local connection_2 = instance.Frame.MouseEnter:Connect(function()
        enabled = true
    end)
    local connection_3 = instance.Frame.MouseLeave:Connect(function()
        enabled = false
        enabled_2 = false
    end)
    local connection_4 = user_input_service.InputBegan:Connect(function(input)
        if enabled == false then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end

        enabled_2 = not enabled_2
        game:GetService("TweenService")
            :Create(instance.Frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.new(1, 1, 1),
            })
            :Play()

        task.delay(0.1, function()
            game:GetService("TweenService")
                :Create(instance.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Color3.new(0, 0, 0),
                })
                :Play()
        end)
    end)
    local vector = Vector2.new(0, 0)
    local connection_5 = run_service.RenderStepped:Connect(function()
        if not (enabled_2 == true and enabled == true) then
            return
        end

        local difference = user_input_service:GetMouseLocation() - Vector2.new(608.5, 463)

        if difference.X < 0 then
            difference = Vector2.new(0, difference.Y)
        end

        if difference.X > 1 then
            difference = Vector2.new(1, difference.Y)
        end

        if difference.Y < 0 then
            difference = Vector2.new(difference.X, 0)
        end

        if difference.Y > 1 then
            difference = Vector2.new(difference.Y, 1)
        end

        vector = Vector2.new(difference.X, difference.Y)
        instance.Frame.CursorPoint.Position = UDim2.new(difference.X, 0, difference.Y, 0)
    end)
    local bindable_event = Instance.new("BindableEvent")
    local enabled_3 = false

    task.spawn(function()
        local text = 10
        countdown.Text = text

        for index = 1, 10 do
            task.wait(1)

            if enabled_3 == true then
                return
            end

            text = text - 1
            countdown.Text = text
            local _ = index
        end

        bindable_event:Fire()
    end)

    local connection_6 = confirm_button.MouseButton1Click:Connect(function()
        local clone = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
        clone.Parent = game.Workspace
        clone:Play()
        game.Debris:AddItem(clone, 3)
        enabled_3 = true
        bindable_event:Fire()
    end)
    bindable_event.Event:Wait()
    connection:Disconnect()
    connection_2:Disconnect()
    connection_3:Disconnect()
    connection_4:Disconnect()
    connection_5:Disconnect()
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
    connection_6:Disconnect()
    local enabled_4 = false
    penalty_idle_track:Stop()
    penalty_shot_l_track:Play()
    local handle_timing_result = handleTiming()
    local connection_7 = nil
    connection_7 = user_input_service.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end

        if bar.Position.X.Scale > 0.9 then
            local clone = game.ReplicatedStorage.UISounds.ui_achieve:Clone()
            clone.Parent = game.Workspace
            clone:Play()
            game.Debris:AddItem(clone, 3)
            enabled_4 = true
        else
            local clone_2 = game.ReplicatedStorage.UISounds["ui-error3"]:Clone()
            clone_2.Parent = game.Workspace
            clone_2:Play()
            game.Debris:AddItem(clone_2, 3)
        end

        handle_timing_result:Pause()
        connection_7:Disconnect()
    end)
    task.wait(0.867)
    handle_timing_result:Cancel()
    connection_7:Disconnect()

    task.delay(0.4, function()
        hideTimingBar()
    end)

    game.ReplicatedStorage.Remotes.FreeKick:FireServer(number, enabled_4)
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
