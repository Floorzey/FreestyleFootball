--[[
    Script Path: Game/ReplicatedStorage/Modules/client/quests
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local tbl_1 = {}
repeat
    task.wait()
until game:IsLoaded()
local Players_1 = game:GetService("Players")
local _ = game:GetService("ReplicatedStorage")
local LocalPlayer_upv_1 = Players_1.LocalPlayer
local Data_upv_1 = LocalPlayer_upv_1:WaitForChild("Data")
local SurfaceGui_upv_1 = workspace:WaitForChild("QuestBoard"):WaitForChild("SurfaceGui")
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
local u1 = Knit_1.GetService("KeyHandlerService"):GetKey("Quests")
local tbl_upv_2 = {Steals = "Do this quest by successfully tackling the ball away from the enemy without fouling", Assists = "Do this quest by helping your striker/teammate score", Goals = "Do this quest by scoring on the enemy team (OWNGOALS MAKE THIS GO DOWN)", Saves = "Do this quest by saving shots from the enemy team"}
local tbl_upv_3 = {}
local function getStatValue(a1)
    --[[
      name: getStatValue
      line: 49
      upvalues:
        Data_upv_1 (copy, index: 1)
    ]]
    return Data_upv_1:FindFirstChild(a1)
end
local function formatMoney(a1)
    --[[
      name: formatMoney
      line: 53
    ]]
    return "$" .. string.format("%d", a1)
end
local tbl_upv_4 = {}
local function updateFrame(a1, a2)
    --[[
      name: updateFrame
      line: 57
      upvalues:
        tbl_upv_2 (copy, index: 1)
        Data_upv_1 (copy, index: 2)
        tbl_upv_3 (copy, index: 3)
    ]]
    if not a1 then
        return
    end
    if a2 then
        local QuestName_1 = a1:FindFirstChild("QuestName")
        local QuestDescription_1 = a1:FindFirstChild("QuestDescription")
        local QuestProgress_1 = a1:FindFirstChild("QuestProgress")
        local QuestReward_1 = a1:FindFirstChild("QuestReward")
        local Claim_1 = a1:FindFirstChild("Claim")
        if QuestName_1 then
            QuestName_1.Text = a2.Type
        end
        if QuestDescription_1 then
            QuestDescription_1.Text = tbl_upv_2[a2.Type] or ""
        end
        if QuestReward_1 then
            QuestReward_1.Text = "Reward: " .. ("$" .. string.format("%d", a2.Reward))
        end
        local v1 = Data_upv_1:FindFirstChild(a2.Type)
        local v2 = math.max(0, ((v1 and (v1.Value)) or 0) - a2.Baseline)
        local Amount_1 = a2.Amount
        local v3 = Amount_1 <= v2
        if QuestProgress_1 then
            QuestProgress_1.Text = "Progress: " .. math.min(v2, Amount_1) .. " / " .. Amount_1
        end
        if Claim_1 then
            local v4 = tbl_upv_3[a1.Name]
            Claim_1.Active = v3 and (not v4)
            local v5
            if not (v3) or v4 then
                v5 = 0.5
            else
                v5 = 0
            end
            Claim_1.ImageTransparency = v5
            local v6 = Data_upv_1:FindFirstChild(a2.Type)
            if math.max(0, ((v6 and (v6.Value)) or 0) - a2.Baseline) < a2.Amount then
                return
            end
            local v7 = Claim_1:FindFirstChildWhichIsA("TextLabel")
            if v7 then
                if v4 then
                    v7.Text = "Claimed"
                    return
                end
                if v3 then
                    v7.Text = "Claim"
                    return
                end
                v7.Text = "Claim"
            end
        end
    end
end
local function decodeQuest(a1)
    --[[
      name: decodeQuest
      line: 28
    ]]
    if a1 and a1 ~= "" and a1 ~= "None" then
        local v8 = string.split(a1, "|")
        if #v8 ~= 3 then
            if #v8 ~= 4 then
                return nil
            end
            local tbl_5 = {}
            tbl_5.Type = v8[1]
            tbl_5.Amount = tonumber(v8[2])
            tbl_5.Reward = tonumber(v8[3])
            tbl_5.Baseline = tonumber(v8[4])
            return tbl_5
        else
            local tbl_6 = {Baseline = 0}
            tbl_6.Type = v8[1]
            tbl_6.Amount = tonumber(v8[2])
            tbl_6.Reward = tonumber(v8[3])
            return tbl_6
        end
    end
    return nil
end
local function refreshBoard()
    --[[
      name: refreshBoard
      line: 112
      upvalues:
        tbl_upv_4 (copy, index: 1)
        tbl_upv_3 (copy, index: 2)
        Data_upv_1 (copy, index: 3)
        decodeQuest (copy, index: 4)
        SurfaceGui_upv_1 (copy, index: 5)
        updateFrame (copy, index: 6)
        u1 (copy, index: 7)
    ]]
    for _, value_1 in ipairs(tbl_upv_4) do
        value_1:Disconnect()
    end
    table.clear(tbl_upv_4)
    table.clear(tbl_upv_3)
    for _, value_upv_2 in ipairs({"Quest1", "Quest2", "Quest3"}) do
        local v9 = Data_upv_1:FindFirstChild(value_upv_2)
        if not (v9) then
            print("missing slot", value_upv_2)
            continue
        end
        local u2 = decodeQuest(v9.Value)
        if not (u2) then
            print("failed to decode", v9.Value)
            continue
        end
        local u3 = SurfaceGui_upv_1.Container:FindFirstChild(u2.Type)
        if not (u3) then
            print("missing frame for", u2.Type)
            continue
        end
        print("found frame", u3.Name, "setting visible")
        updateFrame(u3, u2)
        u3.Visible = true
        local v10 = Data_upv_1:FindFirstChild(u2.Type)
        if v10 then
            table.insert(
                tbl_upv_4,
                (v10.Changed:Connect(
                    function()
                        --[[
                          line: 137
                          upvalues:
                            updateFrame (copy, index: 1)
                            u3 (copy, index: 2)
                            u2 (copy, index: 3)
                        ]]
                        updateFrame(u3, u2)
                    end
                ))
            )
        end
        local Claim_2 = u3:FindFirstChild("Claim")
        if Claim_2 then
            Claim_2.MouseButton1Click:Connect(
                function()
                    --[[
                      line: 145
                      upvalues:
                        tbl_upv_3 (copy, index: 1)
                        u3 (copy, index: 2)
                        u2 (copy, index: 3)
                        Data_upv_1 (copy, index: 4)
                        u1 (copy, index: 5)
                        value_upv_2 (copy, index: 6)
                        updateFrame (copy, index: 7)
                    ]]
                    if tbl_upv_3[u3.Name] then
                        return
                    end
                    local v11 = Data_upv_1:FindFirstChild(u2.Type)
                    if (((v11 and (v11.Value)) or 0) < u2.Amount) then
                        return
                    end
                    u1:FireServer(value_upv_2, u2.Reward)
                    tbl_upv_3[u3.Name] = true
                    updateFrame(u3, u2)
                end
            )
        end
    end
end
for v1, value_3 in ipairs({"Quest1", "Quest2", "Quest3"}) do
    Data_upv_1:WaitForChild(value_3).Changed:Connect(
        function()
            --[[
              line: 165
              upvalues:
                refreshBoard (copy, index: 1)
            ]]
            refreshBoard()
        end
    )
end
function tbl_1.init()
    --[[
      name: init
      line: 171
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        refreshBoard (copy, index: 2)
    ]]
    local Data_2 = LocalPlayer_upv_1:WaitForChild("Data")
    local Quest1_1 = Data_2:WaitForChild("Quest1")
    local Quest2_1 = Data_2:WaitForChild("Quest2")
    local Quest3_1 = Data_2:WaitForChild("Quest3")
    while true do
        if Quest1_1.Value == "" or Quest1_1.Value == "None" or Quest2_1.Value == "" or Quest2_1.Value == "None" or Quest3_1.Value == "" then
            task.wait(0.1)
            continue
        end
        if Quest3_1.Value ~= "None" then
            break
        end
        task.wait(0.1)
    end
    print("Quest values:", Quest1_1.Value, Quest2_1.Value, Quest3_1.Value)
    refreshBoard()
end
tbl_1.init()
return tbl_1