local quests = {}

repeat
    task.wait()
until game:IsLoaded()

local players = game:GetService("Players")
game:GetService("ReplicatedStorage")
local local_player = players.LocalPlayer
local data = local_player:WaitForChild("Data")
local surface_gui = workspace:WaitForChild("QuestBoard"):WaitForChild("SurfaceGui")
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key = knit.GetService("KeyHandlerService"):GetKey("Quests")
local values = {
    Goals = "Do this quest by scoring on the enemy team (OWNGOALS MAKE THIS GO DOWN)",
    Assists = "Do this quest by helping your striker/teammate score",
    Saves = "Do this quest by saving shots from the enemy team",
    Steals = "Do this quest by successfully tackling the ball away from the enemy without fouling",
}
local values_2 = {}

local function decode_quest(argument)
    if not (argument and (argument ~= "" and argument ~= "None")) then
        return nil
    end

    local parts = string.split(argument, "|")

    return #parts == 3
            and {
                Baseline = 0,
                Type = parts[1],
                Amount = tonumber(parts[2]),
                Reward = tonumber(parts[3]),
            }
        or (
            #parts == 4
                and {
                    Type = parts[1],
                    Amount = tonumber(parts[2]),
                    Reward = tonumber(parts[3]),
                    Baseline = tonumber(parts[4]),
                }
            or nil
        )
end

local function get_stat_value(child_name_2)
    return data:FindFirstChild(child_name_2)
end

local function format_money(argument)
    return "$" .. string.format("%d", argument)
end

local function update_frame(instance, argument)
    if not (instance and argument) then
        return
    end

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
        quest_reward.Text = "Reward: " .. "$" .. string.format("%d", argument.Reward)
    end

    local first_child = data:FindFirstChild(argument.Type)
    local maximum = math.max(0, (first_child and first_child.Value or 0) - argument.Baseline)
    local amount = argument.Amount
    local condition = amount <= maximum

    if quest_progress then
        quest_progress.Text = "Progress: " .. math.min(maximum, amount) .. " / " .. amount
    end

    if not claim then
        return
    end

    local value_entry = values_2[instance.Name]
    local active

    if condition then
        active = not value_entry
    else
        active = condition
    end

    claim.Active = active
    claim.ImageTransparency = condition and not value_entry and 0 or 0.5
    local first_child_2 = data:FindFirstChild(argument.Type)

    if math.max(0, (first_child_2 and first_child_2.Value or 0) - argument.Baseline) < argument.Amount then
        return
    end

    local text_label = claim:FindFirstChildWhichIsA("TextLabel")

    if not text_label then
        return
    end

    if value_entry then
        text_label.Text = "Claimed"

        return
    end

    if condition then
        text_label.Text = "Claim"

        return
    end

    text_label.Text = "Claim"
end

local items = {}

local function refresh_board()
    for _, connection_2 in ipairs(items) do
        connection_2:Disconnect()
    end

    table.clear(items)
    table.clear(values_2)

    for _, child_name_2 in ipairs({ "Quest1", "Quest2", "Quest3" }) do
        local first_child = data:FindFirstChild(child_name_2)

        if first_child then
            local result = decode_quest(first_child.Value)

            if result then
                local instance = surface_gui.Container:FindFirstChild(result.Type)

                if instance then
                    print("found frame", instance.Name, "setting visible")
                    update_frame(instance, result)
                    instance.Visible = true
                    local first_child_2 = data:FindFirstChild(result.Type)

                    if first_child_2 then
                        local connection = first_child_2.Changed:Connect(function()
                            update_frame(instance, result)
                        end)
                        table.insert(items, connection)
                    end

                    local claim = instance:FindFirstChild("Claim")

                    if claim then
                        claim.MouseButton1Click:Connect(function()
                            if values_2[instance.Name] then
                                return
                            end

                            local first_child_3 = data:FindFirstChild(result.Type)

                            if (first_child_3 and first_child_3.Value or 0) < result.Amount then
                                return
                            end

                            key:FireServer(child_name_2, result.Reward)
                            values_2[instance.Name] = true
                            update_frame(instance, result)
                        end)
                    end
                else
                    print("missing frame for", result.Type)
                end
            else
                print("failed to decode", first_child.Value)
            end
        else
            print("missing slot", child_name_2)
        end
    end
end

for _, child_name in ipairs({ "Quest1", "Quest2", "Quest3" }) do
    data:WaitForChild(child_name).Changed:Connect(function()
        refresh_board()
    end)
end

function quests.init()
    local data2 = local_player:WaitForChild("Data")
    local quest1 = data2:WaitForChild("Quest1")
    local quest2 = data2:WaitForChild("Quest2")
    local quest3 = data2:WaitForChild("Quest3")

    while
        quest1.Value == ""
        or (
            quest1.Value == "None"
            or (quest2.Value == "" or (quest2.Value == "None" or (quest3.Value == "" or quest3.Value == "None")))
        )
    do
        task.wait(0.1)
    end

    print("Quest values:", quest1.Value, quest2.Value, quest3.Value)
    refresh_board()
end

quests.init()

return quests
