local parent = script.Parent
local play_button = script.Parent.PlayButton
local mouse_hover_module = require(game.ReplicatedStorage.Modules.MouseHoverModule)
local has_game_started = game.ReplicatedStorage.hasGameStarted

if has_game_started.Value == true then
    play_button.Text = "PLAY"
    play_button.BackgroundColor3 = Color3.new(0, 0.66667, 0)
end

local mouse_enter_leave_event_result, signal = mouse_hover_module.MouseEnterLeaveEvent(play_button)

mouse_enter_leave_event_result:Connect(function()
    if parent.Visible == false then
        return
    end

    local clone = game.ReplicatedStorage.UISounds._click:Clone()
    clone.Parent = game.Workspace
    clone:Play()
    game.Debris:AddItem(clone, 0.5)
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local tween_properties = { TextSize = 32 }
    tween_properties.Size = UDim2.new(0, 265, 0, 52)
    tween_service:Create(play_button, tween_info, tween_properties):Play()
end)

signal:Connect(function()
    if parent.Visible == false then
        return
    end

    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local tween_properties = { TextSize = 28 }
    tween_properties.Size = UDim2.new(0, 250, 0, 44)
    tween_service:Create(play_button, tween_info, tween_properties):Play()
end)

game.ReplicatedStorage.hasGameStarted.Changed:Connect(function()
    if has_game_started.Value ~= false then
        play_button.Text = "PLAY"
        local tween_service = game:GetService("TweenService")
        local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local tween_properties = {}
        tween_properties.BackgroundColor3 = Color3.new(0, 0.66667, 0)
        tween_service:Create(play_button, tween_info, tween_properties):Play()
    else
        play_button.Text = "SELECT TEAM"
        local tween_service_2 = game:GetService("TweenService")
        local tween_info_2 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local tween_properties_2 = {}
        tween_properties_2.BackgroundColor3 = Color3.new(0.66667, 0.66667, 0)
        tween_service_2:Create(play_button, tween_info_2, tween_properties_2):Play()
    end
end)
