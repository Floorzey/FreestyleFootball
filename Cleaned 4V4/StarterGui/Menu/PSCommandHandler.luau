local ps_owner_id = game.ReplicatedStorage:FindFirstChild("PSOwnerID")
    or game.ReplicatedStorage:WaitForChild("PSOwnerID", 30)

if not ps_owner_id or game.Players.LocalPlayer.UserId ~= ps_owner_id.Value then
    return
end

local ps_commands_frame = script.Parent.PSCommandsFrame
script.Parent.LeftFrame.PSCommandsButton.Visible = true
local replicated_storage = game.ReplicatedStorage
local mouse = game.Players.LocalPlayer:GetMouse()
local slider = script:WaitForChild("Slider")
local enabled = false
local user_input_service = game:GetService("UserInputService")

user_input_service.InputChanged:Connect(function()
    if user_input_service:GetLastInputType() ~= Enum.UserInputType.Touch then
        ps_commands_frame.Position = UDim2.new(0.23, 0, 0.5, 0)
    else
        ps_commands_frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    end
end)

local function make_slider(parent, argument)
    local clone_result = slider:clone()
    clone_result.Parent = parent
    clone_result.Position = UDim2.new(argument, 0, 0.5, 0)
    local x = parent.AbsolutePosition.X
    local x_2 = parent.AbsoluteSize.X

    clone_result.MouseButton1Down:connect(function()
        if enabled then
            return
        end

        enabled = true

        repeat
            clone_result.Position =
                UDim2.new(math.round(Snap(math.clamp((mouse.X - x) / x_2, 0, 1), 0.02) * 100) / 100, 0, 0.5, 0)
            game:GetService("RunService").RenderStepped:wait()
        until not enabled
    end)

    return clone_result
end

local result = make_slider(ps_commands_frame.ShotPower, 0)
local result_2 = make_slider(ps_commands_frame.RunSpeed, 0)

local function update()
    if replicated_storage:FindFirstChild("NoSkillUsage") then
        ps_commands_frame.noSkillsButton.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.noSkillsButton.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end

    if replicated_storage:FindFirstChild("timerPaused") then
        ps_commands_frame.PauseTimerButton.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.PauseTimerButton.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end

    if replicated_storage:FindFirstChild("NoSkillCD") then
        ps_commands_frame.NoSkillCDButton.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.NoSkillCDButton.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end

    if replicated_storage:FindFirstChild("firstPersonLock") then
        ps_commands_frame.lockFirstPerson.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.lockFirstPerson.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end

    if replicated_storage:FindFirstChild("noPlayReset") then
        ps_commands_frame.noPlayResetButton.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.noPlayResetButton.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end

    if replicated_storage:FindFirstChild("InfiniteStamina") then
        ps_commands_frame.InfiniteStamina.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.InfiniteStamina.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end

    if replicated_storage:FindFirstChild("lockedHitbox") then
        ps_commands_frame.LockedHitbox.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.LockedHitbox.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end

    if replicated_storage:FindFirstChild("NoTeamLimits") then
        ps_commands_frame.DisableTeamLimits.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.DisableTeamLimits.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
end

replicated_storage.ChildAdded:Connect(update)
replicated_storage.ChildRemoved:Connect(update)

function Snap(argument, argument_2)
    return argument - (argument % argument_2)
end

function sliderValToMult1(argument)
    if argument < 0.1 then
        return 1
    end

    if argument < 0.2 then
        return 1.2
    end

    if argument < 0.3 then
        return 1.4
    end

    if argument < 0.4 then
        return 1.6
    end

    if argument < 0.5 then
        return 1.8
    end

    if argument < 0.6 then
        return 2
    end

    if argument < 0.7 then
        return 3
    elseif argument < 0.8 then
        return 4
    else
        return 5
    end
end

function sliderValToMult2(argument)
    if argument < 0.1 then
        return 1
    end

    if argument < 0.2 then
        return 1.2
    end

    if argument < 0.3 then
        return 1.4
    end

    if argument < 0.4 then
        return 1.6
    end

    if argument < 0.5 then
        return 1.8
    end

    if argument < 0.6 then
        return 2
    end

    if argument < 0.7 then
        return 2.2
    end

    if argument < 0.8 then
        return 2.4
    elseif argument < 0.9 then
        return 2.6
    else
        return 3
    end
end

game:GetService("UserInputService").InputEnded:connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 or enabled ~= true then
        return
    end

    enabled = false
    game.ReplicatedStorage.Remotes.PSCommand:FireServer(
        "setShotPower",
        { val = sliderValToMult1(result.Position.X.Scale) }
    )
    game.ReplicatedStorage.Remotes.PSCommand:FireServer(
        "setRunSpeed",
        { val = sliderValToMult2(result_2.Position.X.Scale) }
    )
end)

result:GetPropertyChangedSignal("Position"):Connect(function()
    ps_commands_frame.ShotPower.AMOUNT.Text = "x" .. sliderValToMult1(result.Position.X.Scale)
end)

result_2:GetPropertyChangedSignal("Position"):Connect(function()
    ps_commands_frame.RunSpeed.AMOUNT.Text = "x" .. sliderValToMult2(result_2.Position.X.Scale)
end)

script.Parent.LeftFrame.PSCommandsButton.MouseButton1Click:Connect(function()
    ps_commands_frame.Visible = not ps_commands_frame.Visible
end)

ps_commands_frame.CloseButton.MouseButton1Click:Connect(function()
    ps_commands_frame.Visible = not ps_commands_frame.Visible
end)

ps_commands_frame.PauseTimerButton.MouseButton1Click:Connect(function()
    game.ReplicatedStorage.Remotes.PSCommand:FireServer("PauseTimer")
end)

ps_commands_frame.EndMatchButton.MouseButton1Click:Connect(function()
    game.ReplicatedStorage.Remotes.PSCommand:FireServer("EndGame")
end)

ps_commands_frame.lockFirstPerson.MouseButton1Click:Connect(function()
    game.ReplicatedStorage.Remotes.PSCommand:FireServer("ToggleFirstPersonLock")
end)

ps_commands_frame.NoSkillCDButton.MouseButton1Click:Connect(function()
    game.ReplicatedStorage.Remotes.PSCommand:FireServer("NoSkillCooldown")
end)

ps_commands_frame.LockedHitbox.MouseButton1Click:Connect(function()
    game.ReplicatedStorage.Remotes.PSCommand:FireServer("LockedHitbox")
end)

ps_commands_frame.noSkillsButton.MouseButton1Click:Connect(function()
    game.ReplicatedStorage.Remotes.PSCommand:FireServer("NoSkillUsage")
end)

ps_commands_frame.noPlayResetButton.MouseButton1Click:Connect(function()
    game.ReplicatedStorage.Remotes.PSCommand:FireServer("DisablePlayReset")
end)

ps_commands_frame.InfiniteStamina.MouseButton1Click:Connect(function()
    game.ReplicatedStorage.Remotes.PSCommand:FireServer("InfiniteStamina")
end)

ps_commands_frame.penShootoutButton.MouseButton1Click:Connect(function()
    game.ReplicatedStorage.Remotes.PSCommand:FireServer("StartShootout")
end)

ps_commands_frame.DisableTeamLimits.MouseButton1Click:Connect(function()
    game.ReplicatedStorage.Remotes.PSCommand:FireServer("NoTeamLimit")
end)

ps_commands_frame.PlaceDefender.MouseButton1Click:Connect(function()
    game.ReplicatedStorage.Remotes.PSCommand:FireServer("PlaceDefender")
end)

ps_commands_frame.ClearDefenders.MouseButton1Click:Connect(function()
    game.ReplicatedStorage.Remotes.PSCommand:FireServer("ClearDefenders")
end)

ps_commands_frame.SetAutomaticKick.MouseButton1Click:Connect(function()
    game.ReplicatedStorage.Remotes.PSCommand:FireServer("SetAutoKick")
end)

ps_commands_frame.ClearAutoKicks.MouseButton1Click:Connect(function()
    game.ReplicatedStorage.Remotes.PSCommand:FireServer("ClearAutoKick")
end)

ps_commands_frame.BringBallButton.MouseButton1Click:Connect(function()
    game.ReplicatedStorage.Remotes.PSCommand:FireServer("BringBall")
end)

ps_commands_frame.KickPlayer.FocusLost:Connect(function()
    game.ReplicatedStorage.Remotes.PSCommand:FireServer("Kick", { User = ps_commands_frame.KickPlayer.Text })
end)

ps_commands_frame.BanPlayer.FocusLost:Connect(function()
    game.ReplicatedStorage.Remotes.PSCommand:FireServer("Ban", { User = ps_commands_frame.BanPlayer.Text })
end)

ps_commands_frame.SetHalfLength.FocusLost:Connect(function()
    game.ReplicatedStorage.Remotes.PSCommand:FireServer("SetHalfLength", { t = ps_commands_frame.SetHalfLength.Text })
end)
