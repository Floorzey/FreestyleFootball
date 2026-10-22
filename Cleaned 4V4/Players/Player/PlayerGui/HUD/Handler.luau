local local_player = game.Players.LocalPlayer
local character = local_player.Character or local_player.CharacterAdded:Wait()
local stamina_frame = script.Parent.StaminaFrame
local skill_cd = script.Parent.SkillCD
local user_input_service = game:GetService("UserInputService")
local_player:WaitForChild("Settings"):WaitForChild("Controls")
local stamina = character:WaitForChild("Stats"):WaitForChild("Stamina")
local selected_skill = local_player:WaitForChild("Data"):WaitForChild("SelectedSkill")
local main_bar = script.Parent.StaminaFrame.Stamina.MainBar

stamina.Changed:Connect(function()
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Size = UDim2.new(stamina.Value / 100, 0, 1, 0)
    tween_service:Create(main_bar, tween_info, tween_properties):Play()
end)

local_player.ChildAdded:Connect(function(child)
    if child.Name ~= "InPlay" then
        return
    end

    stamina_frame.Visible = true
    skill_cd.Visible = true
end)

local_player.ChildRemoved:Connect(function(child)
    if child.Name ~= "InPlay" then
        return
    end

    stamina_frame.Visible = false
    skill_cd.Visible = false
end)

game.ReplicatedStorage.ChildAdded:Connect(function(child)
    if child.Name ~= "EndScreen" then
        return
    end

    stamina_frame.Visible = false
    skill_cd.Visible = false
end)

local function trunc(argument)
    local str = tostring(argument)
    local match_index = string.find(argument, ".", 1, true)

    if match_index then
        return (string.sub(str, 1, match_index + 1))
    end

    return str .. ".0"
end

selected_skill.Changed:Connect(function()
    skill_cd.SkillName.Text = string.upper(selected_skill.Value)
end)

local_player.Settings.Controls.Skill.Changed:Connect(function()
    skill_cd.Keybind.Text = "[" .. string.upper(local_player.Settings.Controls.Skill.Value) .. "]"
end)

skill_cd.Keybind.Text = "[" .. string.upper(local_player.Settings.Controls.Skill.Value) .. "]"

local_player.SelectedPosition.Changed:Connect(function()
    skill_cd.SkillName.Text = string.upper(local_player.Data.SelectedSkill.Value)
end)

skill_cd.SkillName.Text = string.upper(selected_skill.Value)

game.ReplicatedStorage.Remotes.skillCD.OnClientEvent:Connect(function(argument)
    if game.ReplicatedStorage:FindFirstChild("NoSkillCD") then
        return
    end

    local sum = tick() + argument
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.BackgroundColor3 = Color3.new(0.95, 0, 0)
    tween_service:Create(skill_cd, tween_info, tween_properties):Play()
    local tween_service_2 = game:GetService("TweenService")
    local tween_info_2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = {}
    tween_properties_2.TextColor3 = Color3.new(0.95, 0, 0)
    tween_service_2:Create(skill_cd.SkillName, tween_info_2, tween_properties_2):Play()
    local tween_service_3 = game:GetService("TweenService")
    local tween_info_3 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_3 = {}
    tween_properties_3.TextColor3 = Color3.new(0.95, 0, 0)
    tween_service_3:Create(skill_cd.Keybind, tween_info_3, tween_properties_3):Play()
    local tween_service_4 = game:GetService("TweenService")
    local tween_info_4 = TweenInfo.new(argument, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local tween_properties_4 = {}
    tween_properties_4.Size = UDim2.new(0, 0, 0, 2)
    tween_service_4:Create(skill_cd, tween_info_4, tween_properties_4):Play()

    task.delay(argument - 0.25, function()
        local tween_service_5 = game:GetService("TweenService")
        local tween_info_5 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_5 = {}
        tween_properties_5.BackgroundColor3 = Color3.new(1, 1, 1)
        tween_service_5:Create(skill_cd, tween_info_5, tween_properties_5):Play()
        local tween_service_6 = game:GetService("TweenService")
        local tween_info_6 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_6 = {}
        tween_properties_6.TextColor3 = Color3.new(1, 1, 1)
        tween_service_6:Create(skill_cd.SkillName, tween_info_6, tween_properties_6):Play()
        local tween_service_7 = game:GetService("TweenService")
        local tween_info_7 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_7 = {}
        tween_properties_7.TextColor3 = Color3.new(1, 1, 1)
        tween_service_7:Create(skill_cd.Keybind, tween_info_7, tween_properties_7):Play()
        local tween_service_8 = game:GetService("TweenService")
        local tween_info_8 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_8 = {}
        tween_properties_8.Size = UDim2.new(0, 300, 0, 2)
        tween_service_8:Create(skill_cd, tween_info_8, tween_properties_8):Play()
    end)

    local connection = game:GetService("RunService").RenderStepped:Connect(function()
        local skill_name = skill_cd.SkillName
        local difference = sum - tick()
        local str = tostring(difference)
        local match_index = string.find(difference, ".", 1, true)
        local substring = ((not match_index) and (str .. ".0")) or string.sub(str, 1, match_index + 1)
        skill_name.Text = substring .. "s"
    end)

    task.delay(argument, function()
        connection:Disconnect()
        skill_cd.SkillName.Text = string.upper(selected_skill.Value)
    end)
end)

user_input_service.InputChanged:Connect(function()
    if user_input_service.GamepadEnabled ~= true then
        skill_cd.Keybind.Text = "[" .. string.upper(local_player.Settings.Controls.Skill.Value) .. "]"
    else
        skill_cd.Keybind.Text = "[X]"
    end
end)

if user_input_service.GamepadEnabled ~= true then
    skill_cd.Keybind.Text = "[" .. string.upper(local_player.Settings.Controls.Skill.Value) .. "]"
else
    skill_cd.Keybind.Text = "[X]"
end
