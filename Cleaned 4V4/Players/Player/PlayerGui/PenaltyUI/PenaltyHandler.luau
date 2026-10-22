local top_frame = script.Parent.topFrame
local countdown = top_frame.COUNTDOWN
local local_player = game.Players.LocalPlayer
local character = local_player.Character or local_player.CharacterAdded:Wait()
character:WaitForChild("Humanoid")
local _ = local_player:GetMouse()
local user_input_service = game:GetService("UserInputService")

game.ReplicatedStorage.Remotes.PenaltyCountdown.OnClientEvent:Connect(function()
    if not character then
        return
    end

    task.wait(3)
    local tween_service = game:service("TweenService")
    local tween_info = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0, 0, 0, 0)
    tween_service:Create(top_frame, tween_info, tween_properties):Play()
    local enabled = false
    local text = 10
    countdown.Text = text

    game.ReplicatedStorage.Remotes.PenaltyCountdownFinish.OnClientEvent:Once(function()
        enabled = true
    end)

    for _ = 1, 10 do
        task.wait(1)

        if enabled == true then
            break
        else
            text -= 1
            countdown.Text = text
            local clone = game.ReplicatedStorage.UISounds.countdown_tick:Clone()
            clone.Parent = game.Workspace
            clone:Play()
            game.Debris:AddItem(clone, 3)
        end
    end

    local service_result = game:service("TweenService")
    local tween_info_2 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = {}
    tween_properties_2.Position = UDim2.new(0, 0, 0, -200)
    service_result:Create(top_frame, tween_info_2, tween_properties_2):Play()
end)
