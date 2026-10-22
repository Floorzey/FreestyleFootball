local script_parent = script.Parent
local play_button = script.Parent.PlayButton
local mouse_hover_module = require(game.ReplicatedStorage.Modules.MouseHoverModule)
local has_game_started = game.ReplicatedStorage.hasGameStarted

if has_game_started.Value == true then
    play_button.Text = "PLAY"
    play_button.BackgroundColor3 = Color3.new(0, 0.66667, 0)
end

local mouse_enter_leave_event_result, signal = mouse_hover_module.MouseEnterLeaveEvent(play_button)

mouse_enter_leave_event_result:Connect(function()
    if script_parent.Visible == false then
        return
    end

    local clone = game.ReplicatedStorage.UISounds._click:Clone()
    clone.Parent = game.Workspace
    clone:Play()
    game.Debris:AddItem(clone, 0.5)
    game:GetService("TweenService")
        :Create(play_button, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            TextSize = 32,
            Size = UDim2.new(0, 265, 0, 52),
        })
        :Play()
end)

signal:Connect(function()
    if script_parent.Visible == false then
        return
    end

    game:GetService("TweenService")
        :Create(play_button, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            TextSize = 28,
            Size = UDim2.new(0, 250, 0, 44),
        })
        :Play()
end)

game.ReplicatedStorage.hasGameStarted.Changed:Connect(function()
    if has_game_started.Value == false then
        play_button.Text = "SELECT TEAM"
        game:GetService("TweenService")
            :Create(play_button, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.new(0.66667, 0.66667, 0),
            })
            :Play()

        return
    end

    play_button.Text = "PLAY"
    game:GetService("TweenService")
        :Create(play_button, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.new(0, 0.66667, 0),
        })
        :Play()
end)
