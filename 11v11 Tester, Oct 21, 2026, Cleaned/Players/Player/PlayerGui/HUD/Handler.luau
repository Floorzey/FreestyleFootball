local replicated_storage = game:GetService("ReplicatedStorage")
local skill_info = require(replicated_storage.Modules.wiki).skill_info
local local_player = game.Players.LocalPlayer
local character = local_player.Character or local_player.CharacterAdded:Wait()
local stamina_frame = script.Parent.StaminaFrame
local skill_cd = script.Parent.SkillCD
local user_input_service = game:GetService("UserInputService")
local controls = local_player:WaitForChild("Settings"):WaitForChild("Controls")
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key_handler_service = knit.GetService("KeyHandlerService")
local stamina = character:WaitForChild("Stats"):WaitForChild("Stamina")
local max_stamina = character:WaitForChild("Stats"):WaitForChild("MaxStamina")
local selected_skill = local_player:WaitForChild("Data"):WaitForChild("SelectedSkill")

local function get_skill_display_name(display_name)
    local skill_info_entry_2 = skill_info[display_name]

    if skill_info_entry_2 then
        display_name = skill_info_entry_2.display_name or display_name
    end

    return display_name
end

local function update_skill_keybind()
    if selected_skill.Value == "Right Footed" and local_player.SelectedPosition.Value ~= "GK" then
        skill_cd.Keybind.Text = "PASSIVE"

        return
    end

    if user_input_service.GamepadEnabled then
        skill_cd.Keybind.Text = "[X]"

        return
    end

    skill_cd.Keybind.Text = "[" .. string.upper(controls.Skill.Value) .. "]"
end

local main_bar = script.Parent.StaminaFrame.Stamina.MainBar
local _ = script.Parent.StaminaFrame.Stamina.GreyBar

stamina.Changed:Connect(function()
    game:GetService("TweenService")
        :Create(main_bar, TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Size = UDim2.new(stamina.Value / 100, 0, 1, 0),
        })
        :Play()
end)

local key = key_handler_service:GetKey("UpdateMaxStaminaRejoin")
local timestamp = tick()

max_stamina.Changed:Connect(function()
    if tick() - timestamp > 0.5 then
        timestamp = tick()
        key:FireServer(max_stamina.Value)
    end
end)

local_player.ChildAdded:Connect(function(child)
    if child.Name == "InPlay" then
        stamina_frame.Visible = true
        skill_cd.Visible = true
    end
end)

local_player.ChildRemoved:Connect(function(child)
    if child.Name == "InPlay" then
        stamina_frame.Visible = false
        skill_cd.Visible = false
    end
end)

game.ReplicatedStorage.ChildAdded:Connect(function(child)
    if child.Name == "EndScreen" then
        stamina_frame.Visible = false
        skill_cd.Visible = false
    end
end)

local function trunc(argument: number)
    local tostring_result = tostring(argument)
    local match_index = string.find(argument, ".", 1, true)

    if match_index then
        return string.sub(tostring_result, 1, match_index + 1)
    end

    return tostring_result .. ".0"
end

selected_skill.Changed:Connect(function()
    local value_2 = selected_skill.Value
    local skill_info_entry_2 = skill_info[value_2]

    if skill_info_entry_2 then
        value_2 = skill_info_entry_2.display_name or value_2
    end

    skill_cd.SkillName.Text = string.upper(value_2)

    if selected_skill.Value == "Right Footed" and local_player.SelectedPosition.Value ~= "GK" then
        skill_cd.Keybind.Text = "PASSIVE"

        return
    end

    if user_input_service.GamepadEnabled then
        skill_cd.Keybind.Text = "[X]"

        return
    end

    skill_cd.Keybind.Text = "[" .. string.upper(controls.Skill.Value) .. "]"
end)

controls.Skill.Changed:Connect(update_skill_keybind)
controls.Flipped.Changed:Connect(update_skill_keybind)

if selected_skill.Value == "Right Footed" and local_player.SelectedPosition.Value ~= "GK" then
    skill_cd.Keybind.Text = "PASSIVE"
elseif user_input_service.GamepadEnabled then
    skill_cd.Keybind.Text = "[X]"
else
    skill_cd.Keybind.Text = "[" .. string.upper(controls.Skill.Value) .. "]"
end

local_player.SelectedPosition.Changed:Connect(function()
    if local_player.SelectedPosition.Value == "GK" then
        local value_2 = local_player.Data.GoalieSkill.Value
        local skill_info_entry_2 = skill_info[value_2]

        if skill_info_entry_2 then
            value_2 = skill_info_entry_2.display_name or value_2
        end

        skill_cd.SkillName.Text = string.upper(value_2)
    else
        local value_3 = local_player.Data.SelectedSkill.Value
        local skill_info_entry_3 = skill_info[value_3]

        if skill_info_entry_3 then
            value_3 = skill_info_entry_3.display_name or value_3
        end

        skill_cd.SkillName.Text = string.upper(value_3)
    end

    if selected_skill.Value == "Right Footed" and local_player.SelectedPosition.Value ~= "GK" then
        skill_cd.Keybind.Text = "PASSIVE"

        return
    end

    if user_input_service.GamepadEnabled then
        skill_cd.Keybind.Text = "[X]"

        return
    end

    skill_cd.Keybind.Text = "[" .. string.upper(controls.Skill.Value) .. "]"
end)

local value = selected_skill.Value
local skill_info_entry = skill_info[value]

if skill_info_entry then
    value = skill_info_entry.display_name or value
end

skill_cd.SkillName.Text = string.upper(value)

key_handler_service:GetKey("skillCD").OnClientEvent:Connect(function(argument)
    if game.ReplicatedStorage:FindFirstChild("NoSkillCD") then
        return
    end

    local sum = tick() + argument
    game:GetService("TweenService")
        :Create(skill_cd, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.new(0.95, 0, 0),
        })
        :Play()
    game:GetService("TweenService")
        :Create(skill_cd.SkillName, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.new(0.95, 0, 0),
        })
        :Play()
    game:GetService("TweenService")
        :Create(skill_cd.Keybind, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.new(0.95, 0, 0),
        })
        :Play()
    game:GetService("TweenService")
        :Create(skill_cd, TweenInfo.new(argument, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 0, 0, 2),
        })
        :Play()

    task.delay(argument - 0.25, function()
        game:GetService("TweenService")
            :Create(skill_cd, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.new(1, 1, 1),
            })
            :Play()
        game:GetService("TweenService")
            :Create(skill_cd.SkillName, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextColor3 = Color3.new(1, 1, 1),
            })
            :Play()
        game:GetService("TweenService")
            :Create(skill_cd.Keybind, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextColor3 = Color3.new(1, 1, 1),
            })
            :Play()
        game:GetService("TweenService")
            :Create(skill_cd, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 300, 0, 2),
            })
            :Play()
    end)

    local connection = game:GetService("RunService").RenderStepped:Connect(function()
        local skill_name = skill_cd.SkillName
        local difference = sum - tick()
        local tostring_result = tostring(difference)
        local match_index = string.find(difference, ".", 1, true)
        local substring

        if match_index then
            substring = string.sub(tostring_result, 1, match_index + 1)
        else
            substring = tostring_result .. ".0"
        end

        skill_name.Text = substring .. "s"
    end)

    task.delay(argument, function()
        connection:Disconnect()

        if local_player.SelectedPosition.Value == "GK" then
            local value2 = local_player.Data.GoalieSkill.Value
            local skill_info_entry_2 = skill_info[value2]

            if skill_info_entry_2 then
                value2 = skill_info_entry_2.display_name or value2
            end

            skill_cd.SkillName.Text = string.upper(value2)

            return
        end

        local value2_2 = selected_skill.Value
        local skill_info_entry_3 = skill_info[value2_2]

        if skill_info_entry_3 then
            value2_2 = skill_info_entry_3.display_name or value2_2
        end

        skill_cd.SkillName.Text = string.upper(value2_2)
    end)
end)

user_input_service.InputChanged:Connect(function()
    if selected_skill.Value == "Right Footed" and local_player.SelectedPosition.Value ~= "GK" then
        skill_cd.Keybind.Text = "PASSIVE"

        return
    end

    if user_input_service.GamepadEnabled then
        skill_cd.Keybind.Text = "[X]"

        return
    end

    skill_cd.Keybind.Text = "[" .. string.upper(controls.Skill.Value) .. "]"
end)

if selected_skill.Value == "Right Footed" and local_player.SelectedPosition.Value ~= "GK" then
    skill_cd.Keybind.Text = "PASSIVE"
elseif user_input_service.GamepadEnabled then
    skill_cd.Keybind.Text = "[X]"
else
    skill_cd.Keybind.Text = "[" .. string.upper(controls.Skill.Value) .. "]"
end
