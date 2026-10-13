local quests = {}
repeat
    task.wait()
until game:IsLoaded()
local players = game:GetService("Players")
local _ = game:GetService("ReplicatedStorage")
local local_player = players.LocalPlayer
local data = local_player:WaitForChild("Data")
local surface_gui = workspace:WaitForChild("QuestBoard"):WaitForChild("SurfaceGui")
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local remote_event = knit.GetService("KeyHandlerService"):GetKey("Quests")
local values = {
    Steals = "Do this quest by successfully tackling the ball away from the enemy without fouling",
    Assists = "Do this quest by helping your striker/teammate score",
    Goals = "Do this quest by scoring on the enemy team (OWNGOALS MAKE THIS GO DOWN)",
    Saves = "Do this quest by saving shots from the enemy team",
}
local values_2 = {}

local function get_stat_value(child_name_2)
    return data:FindFirstChild(child_name_2)
end

local function format_money(argument)
    return "$" .. string.format("%d", argument)
end

local items = {}

local function update_frame(instance, argument)
    if not instance then
        return
    end
    if argument then
        local quest_name = instance:FindFirstChild("QuestName")
        local quest_description = instance:FindFirstChild("QuestDescription")
        local quest_progress = instance:FindFirstChild("QuestProgress")
        local quest_reward = instance:FindFirstChild("QuestReward")
        local claim = instance:FindFirstChild("Claim")
        if quest_name then
            quest_name.Text = argument.Type
        end
        if quest_description then
            quest_description.Text = values[argument.Type] or ""
        end
        if quest_reward then
            quest_reward.Text = "Reward: " .. ("$" .. string.format("%d", argument.Reward))
        end
        local first_child = data:FindFirstChild(argument.Type)
        local maximum = math.max(0, ((first_child and first_child.Value) or 0) - argument.Baseline)
        local amount = argument.Amount
        local is_amount = amount <= maximum
        if quest_progress then
            quest_progress.Text = "Progress: " .. math.min(maximum, amount) .. " / " .. amount
        end
        if claim then
            local value_entry = values_2[instance.Name]
            claim.Active = is_amount and not value_entry
            local image_transparency
            if not is_amount or value_entry then
                image_transparency = 0.5
            else
                image_transparency = 0
            end
            claim.ImageTransparency = image_transparency
            local first_child_2 = data:FindFirstChild(argument.Type)
            if math.max(0, ((first_child_2 and first_child_2.Value) or 0) - argument.Baseline) < argument.Amount then
                return
            end
            local text_label = claim:FindFirstChildWhichIsA("TextLabel")
            if text_label then
                if value_entry then
                    text_label.Text = "Claimed"
                    return
                end
                if is_amount then
                    text_label.Text = "Claim"
                    return
                end
                text_label.Text = "Claim"
            end
        end
    end
end

local function decode_quest(argument)
    if argument and argument ~= "" and argument ~= "None" then
        local parts = string.split(argument, "|")
        if #parts ~= 3 then
            if #parts ~= 4 then
                return nil
            end
            local values_3 = {}
            values_3.Type = parts[1]
            values_3.Amount = tonumber(parts[2])
            values_3.Reward = tonumber(parts[3])
            values_3.Baseline = tonumber(parts[4])
            return values_3
        else
            local values_4 = { Baseline = 0 }
            values_4.Type = parts[1]
            values_4.Amount = tonumber(parts[2])
            values_4.Reward = tonumber(parts[3])
            return values_4
        end
    end
    return nil
end

local function refresh_board()
    for _, connection in ipairs(items) do
        connection:Disconnect()
    end
    table.clear(items)
    table.clear(values_2)
    for _, value in ipairs({ "Quest1", "Quest2", "Quest3" }) do
        local first_child = data:FindFirstChild(value)
        if not first_child then
            print("missing slot", value)
            continue
        end
        local result = decode_quest(first_child.Value)
        if not result then
            print("failed to decode", first_child.Value)
            continue
        end
        local instance = surface_gui.Container:FindFirstChild(result.Type)
        if not instance then
            print("missing frame for", result.Type)
            continue
        end
        print("found frame", instance.Name, "setting visible")
        update_frame(instance, result)
        instance.Visible = true
        local first_child_2 = data:FindFirstChild(result.Type)
        if first_child_2 then
            table.insert(items, (first_child_2.Changed:Connect(function()
                update_frame(instance, result)
            end)))
        end
        local claim = instance:FindFirstChild("Claim")
        if claim then
            claim.MouseButton1Click:Connect(function()
                if values_2[instance.Name] then
                    return
                end
                local first_child_3 = data:FindFirstChild(result.Type)
                if ((first_child_3 and first_child_3.Value) or 0) < result.Amount then
                    return
                end
                remote_event:FireServer(value, result.Reward)
                values_2[instance.Name] = true
                update_frame(instance, result)
            end)
        end
    end
end

for index, child_name in ipairs({ "Quest1", "Quest2", "Quest3" }) do
    data:WaitForChild(child_name).Changed:Connect(function()
        refresh_board()
    end)
end

function quests.init()
    local data_2 = local_player:WaitForChild("Data")
    local quest1 = data_2:WaitForChild("Quest1")
    local quest2 = data_2:WaitForChild("Quest2")
    local quest3 = data_2:WaitForChild("Quest3")
    while true do
        if
            quest1.Value == ""
            or quest1.Value == "None"
            or quest2.Value == ""
            or quest2.Value == "None"
            or quest3.Value == ""
        then
            task.wait(0.1)
            continue
        end
        if quest3.Value ~= "None" then
            break
        end
        task.wait(0.1)
    end
    print("Quest values:", quest1.Value, quest2.Value, quest3.Value)
    refresh_board()
end

quests.init()

return quests
