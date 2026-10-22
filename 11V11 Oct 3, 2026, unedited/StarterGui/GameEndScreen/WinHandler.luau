--[[
    Script Path: Game/StarterGui/GameEndScreen/WinHandler
    Class: LocalScript
    Time: 2026-10-03 12:27:08
--]]

local UpperShutter_upv_1 = script.Parent.UpperShutter
local LowerShutter_upv_1 = script.Parent.LowerShutter
local GameEnd_upv_1 = script.Parent.GameEnd
local bottomFrame_upv_1 = script.Parent.bottomFrame
local MVP_upv_1 = bottomFrame_upv_1.MVP
local topScore_upv_1 = bottomFrame_upv_1.topScore
local topAssists_upv_1 = bottomFrame_upv_1.topAssists
local topFrame_upv_1 = script.Parent.topFrame
local RewardsFrame_upv_1 = script.Parent.RewardsFrame
local TeamInfo_upv_1 = game.ReplicatedStorage.TeamInfo
local CurrentCamera_upv_1 = workspace.CurrentCamera
LowerShutter_upv_1.Size = UDim2.new(1, 0, 0.55, 0)
UpperShutter_upv_1.Size = UDim2.new(1, 0, 0.55, 0)
script.Parent.LOADING.Visible = true
local v1 = 1
while true do
    task.wait(0.3)
    if v1 == 1 then
        script.Parent.LOADING.Text = "LOADING."
    elseif v1 == 2 then
        script.Parent.LOADING.Text = "LOADING.."
    elseif v1 == 3 then
        script.Parent.LOADING.Text = "LOADING..."
        v1 = 0
    end
    local v2 = v1 + 1
    if game.Players.LocalPlayer:FindFirstChild("dataLoaded") then
        break
    end
    v1 = v2
end
local TweenService_1 = game:GetService("TweenService")
local v3 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tbl_1 = {}
tbl_1.Size = UDim2.new(1, 0, 0, 0)
TweenService_1:Create(LowerShutter_upv_1, v3, tbl_1):Play()
local TweenService_2 = game:GetService("TweenService")
local v4 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tbl_2 = {}
tbl_2.Size = UDim2.new(1, 0, 0, 0)
TweenService_2:Create(UpperShutter_upv_1, v4, tbl_2):Play()
local tbl_3 = {TextTransparency = 1, TextStrokeTransparency = 1}
game:GetService("TweenService"):Create(script.Parent.LOADING, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_3):Play()
task.delay(
    0.5,
    function()
        --[[
          line: 40
        ]]
        script.Parent.LOADING.Visible = false
    end
)
function shutter()
    --[[
      name: shutter
      line: 44
      upvalues:
        UpperShutter_upv_1 (copy, index: 1)
        LowerShutter_upv_1 (copy, index: 2)
    ]]
    if game.Players.LocalPlayer:GetAttribute("Freecam") then
        return
    end
    UpperShutter_upv_1.Visible = true
    LowerShutter_upv_1.Visible = true
    local TweenService_3 = game:GetService("TweenService")
    local v5 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_4 = {}
    tbl_4.Size = UDim2.new(1, 0, 0.55, 0)
    TweenService_3:Create(LowerShutter_upv_1, v5, tbl_4):Play()
    local TweenService_4 = game:GetService("TweenService")
    local v6 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_5 = {}
    tbl_5.Size = UDim2.new(1, 0, 0.55, 0)
    TweenService_4:Create(UpperShutter_upv_1, v6, tbl_5):Play()
    task.delay(
        2,
        function()
            --[[
              line: 54
              upvalues:
                LowerShutter_upv_1 (copy, index: 1)
                UpperShutter_upv_1 (copy, index: 2)
            ]]
            game.Lighting.Blur.Size = 2
            task.wait(0.5)
            local TweenService_5 = game:GetService("TweenService")
            local v7 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_6 = {}
            tbl_6.Size = UDim2.new(1, 0, 0, 0)
            TweenService_5:Create(LowerShutter_upv_1, v7, tbl_6):Play()
            local TweenService_6 = game:GetService("TweenService")
            local v8 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_7 = {}
            tbl_7.Size = UDim2.new(1, 0, 0, 0)
            TweenService_6:Create(UpperShutter_upv_1, v8, tbl_7):Play()
            task.wait(0.5)
            UpperShutter_upv_1.Visible = false
            LowerShutter_upv_1.Visible = false
        end
    )
end
function rewardsDisplay(a1, a2)
    --[[
      name: rewardsDisplay
      line: 69
      upvalues:
        RewardsFrame_upv_1 (copy, index: 1)
    ]]
    local tbl_8 = {BackgroundTransparency = 0}
    game:GetService("TweenService"):Create(RewardsFrame_upv_1.lineDivider, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_8):Play()
    local tbl_9 = {TextTransparency = 0}
    game:GetService("TweenService"):Create(RewardsFrame_upv_1.Coins, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_9):Play()
    local tbl_10 = {TextSize = 25}
    game:GetService("TweenService"):Create(RewardsFrame_upv_1.Coins, TweenInfo.new(1.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), tbl_10):Play()
    local tbl_11 = {TextTransparency = 0}
    game:GetService("TweenService"):Create(RewardsFrame_upv_1.EXP, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_11):Play()
    local tbl_12 = {TextSize = 25}
    game:GetService("TweenService"):Create(RewardsFrame_upv_1.EXP, TweenInfo.new(1.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), tbl_12):Play()
    local tbl_13 = {ImageTransparency = 0}
    game:GetService("TweenService"):Create(RewardsFrame_upv_1.CoinsImage, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_13):Play()
    local TweenService_7 = game:GetService("TweenService")
    local v9 = TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_14 = {}
    tbl_14.Size = UDim2.new(0, 60, 0, 60)
    TweenService_7:Create(RewardsFrame_upv_1.CoinsImage, v9, tbl_14):Play()
    local tbl_15 = {ImageTransparency = 0}
    game:GetService("TweenService"):Create(RewardsFrame_upv_1.EXPImage, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_15):Play()
    local TweenService_8 = game:GetService("TweenService")
    local v10 = TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_16 = {}
    tbl_16.Size = UDim2.new(0, 60, 0, 60)
    TweenService_8:Create(RewardsFrame_upv_1.EXPImage, v10, tbl_16):Play()
    local v11 = game.ReplicatedStorage.UISounds.ui_starbar_fill:Clone()
    v11.Parent = game.Workspace
    v11:Play()
    game.Debris:AddItem(v11, 3)
    RewardsFrame_upv_1.EXP.Text = "+0 EXP"
    RewardsFrame_upv_1.Coins.Text = "+0 COINS"
    task.spawn(
        function()
            --[[
              line: 103
              upvalues:
                a2 (copy, index: 1)
                RewardsFrame_upv_1 (copy, index: 2)
            ]]
            local v12 = math.floor(a2 / 84)
            for n_1 = 1, 84 do
                RewardsFrame_upv_1.EXP.Text = "+" .. v12 * n_1 .. " EXP"
                game:GetService("RunService").RenderStepped:Wait()
            end
            local v13 = game:GetService("TweenService")
            local v14 = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            local tbl_17 = {}
            tbl_17.Size = UDim2.new(0, 75, 0, 75)
            v13:Create(RewardsFrame_upv_1.EXPImage, v14, tbl_17):Play()
            local tbl_18 = {TextSize = 30}
            game:GetService("TweenService"):Create(RewardsFrame_upv_1.EXP, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), tbl_18):Play()
        end
    )
    task.spawn(
        function()
            --[[
              line: 116
              upvalues:
                a1 (copy, index: 1)
                RewardsFrame_upv_1 (copy, index: 2)
            ]]
            local v15 = math.floor(a1 / 84)
            for n_2 = 1, 84 do
                RewardsFrame_upv_1.Coins.Text = "+" .. v15 * n_2 .. " COINS"
                game:GetService("RunService").RenderStepped:Wait()
            end
            local v16 = game:GetService("TweenService")
            local v17 = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            local tbl_19 = {}
            tbl_19.Size = UDim2.new(0, 75, 0, 75)
            v16:Create(RewardsFrame_upv_1.CoinsImage, v17, tbl_19):Play()
            local tbl_20 = {TextSize = 30}
            game:GetService("TweenService"):Create(RewardsFrame_upv_1.Coins, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), tbl_20):Play()
        end
    )
    task.delay(
        1.4,
        function()
            --[[
              line: 129
              upvalues:
                RewardsFrame_upv_1 (copy, index: 1)
            ]]
            local v18 = game.ReplicatedStorage.UISounds.ui_starbar_launch:Clone()
            v18.Parent = game.Workspace
            v18:Play()
            game.Debris:AddItem(v18, 3)
            local v19 = game.ReplicatedStorage.UISounds.ui_count_complete:Clone()
            v19.Parent = game.Workspace
            v19:Play()
            game.Debris:AddItem(v19, 3)
            task.wait(2.5)
            local tbl_21 = {BackgroundTransparency = 1}
            game:GetService("TweenService"):Create(RewardsFrame_upv_1.lineDivider, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_21):Play()
            local tbl_22 = {TextTransparency = 1}
            game:GetService("TweenService"):Create(RewardsFrame_upv_1.Coins, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_22):Play()
            local tbl_23 = {TextTransparency = 1}
            game:GetService("TweenService"):Create(RewardsFrame_upv_1.EXP, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_23):Play()
            local tbl_24 = {ImageTransparency = 1}
            game:GetService("TweenService"):Create(RewardsFrame_upv_1.CoinsImage, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_24):Play()
            local TweenService_9 = game:GetService("TweenService")
            local v20 = TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_25 = {}
            tbl_25.Size = UDim2.new(0, 50, 0, 50)
            TweenService_9:Create(RewardsFrame_upv_1.CoinsImage, v20, tbl_25):Play()
            local tbl_26 = {ImageTransparency = 1}
            game:GetService("TweenService"):Create(RewardsFrame_upv_1.EXPImage, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_26):Play()
            local TweenService_10 = game:GetService("TweenService")
            local v21 = TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_27 = {}
            tbl_27.Size = UDim2.new(0, 50, 0, 50)
            TweenService_10:Create(RewardsFrame_upv_1.EXPImage, v21, tbl_27):Play()
        end
    )
end
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
local v22 = Knit_1.GetService("KeyHandlerService")
v22:GetKey("WinClient").OnClientEvent:Connect(
    function(a1, a2, a3, a4, a5, a6)
        --[[
          line: 167
          upvalues:
            GameEnd_upv_1 (copy, index: 1)
            CurrentCamera_upv_1 (copy, index: 2)
            topFrame_upv_1 (copy, index: 3)
            TeamInfo_upv_1 (copy, index: 4)
            bottomFrame_upv_1 (copy, index: 5)
            MVP_upv_1 (copy, index: 6)
            topScore_upv_1 (copy, index: 7)
            topAssists_upv_1 (copy, index: 8)
            UpperShutter_upv_1 (copy, index: 9)
            LowerShutter_upv_1 (copy, index: 10)
        ]]
        shutter()
        local v23 = game.ReplicatedStorage.UISounds.ui_start_travel:Clone()
        v23.Parent = game.Workspace
        v23:Play()
        game.Debris:AddItem(v23, 3)
        GameEnd_upv_1.Text = (a6 and "MERCY RULE") or "FULL TIME"
        task.wait(0.5)
        CurrentCamera_upv_1.CameraType = Enum.CameraType.Scriptable
        local v24 = Instance.new("Folder")
        v24.Name = "CameraOverride"
        v24.Parent = game.Players.LocalPlayer.Character.Status
        local v25 = game:GetService("RunService").RenderStepped:Connect(
            function()
                --[[
                  line: 179
                  upvalues:
                    CurrentCamera_upv_1 (copy, index: 1)
                ]]
                CurrentCamera_upv_1.CFrame = game.Workspace.GameEndPositions.Camera.CFrame
            end
        )
        local tbl_28 = {TextTransparency = 0, TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(GameEnd_upv_1, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_28):Play()
        task.wait(2)
        local tbl_29 = {TextTransparency = 1, TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(GameEnd_upv_1, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_29):Play()
        topFrame_upv_1.Outcome.Text = ((a1 ~= game.Players.LocalPlayer.SelectedTeam.Value) and "LOSS") or "VICTORY"
        local Outcome_1 = topFrame_upv_1.Outcome
        Outcome_1.TextColor3 = a1 == game.Players.LocalPlayer.SelectedTeam.Value and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
        local Outcome_2 = topFrame_upv_1.Outcome
        Outcome_2.TextStrokeColor3 = a1 == game.Players.LocalPlayer.SelectedTeam.Value and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
        topFrame_upv_1.Score.Text = TeamInfo_upv_1.HomeTeamPoints.Value .. "  -  " .. TeamInfo_upv_1.AwayTeamPoints.Value
        local TweenService_11 = game:GetService("TweenService")
        local v28 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_30 = {}
        tbl_30.Position = UDim2.new(0, 0, 1, 0)
        TweenService_11:Create(bottomFrame_upv_1, v28, tbl_30):Play()
        local TweenService_12 = game:GetService("TweenService")
        local v29 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_31 = {}
        tbl_31.Position = UDim2.new(0, 0, 0, 0)
        TweenService_12:Create(topFrame_upv_1, v29, tbl_31):Play()
        local v30 = game.ReplicatedStorage.UISounds.ui_start_travel:Clone()
        v30.Parent = game.Workspace
        v30:Play()
        game.Debris:AddItem(v30, 3)
        local v31 = game.ReplicatedStorage.UISounds.ui_starbar_launch:Clone()
        v31.Parent = game.Workspace
        v31:Play()
        game.Debris:AddItem(v31, 3)
        task.wait(1)
        if a2 == nil then
            a2 = game.Players.LocalPlayer
        end
        if a3 == nil then
            a3 = game.Players.LocalPlayer
        end
        if a4 == nil then
            a4 = game.Players.LocalPlayer
        end
        MVP_upv_1.plrName.Text = "MVP - " .. a2.DisplayName
        topScore_upv_1.plrName.Text = "TOP SCORER - " .. a3.DisplayName
        topAssists_upv_1.plrName.Text = "TOP ASSISTS - " .. a4.DisplayName
        MVP_upv_1.Info.Text = a2.Points.Value .. " POINTS"
        topScore_upv_1.Info.Text = a3.GoalsThisGame.Value .. " GOALS"
        topAssists_upv_1.Info.Text = a4.AssistsThisGame.Value .. " ASSISTS"
        local v32 = game.ReplicatedStorage.UISounds.ui_starbar_impact_1:Clone()
        v32.Parent = game.Workspace
        v32:Play()
        game.Debris:AddItem(v32, 3)
        local tbl_32 = {BackgroundTransparency = 0}
        game:GetService("TweenService"):Create(topAssists_upv_1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_32):Play()
        local tbl_33 = {ImageTransparency = 0}
        game:GetService("TweenService"):Create(topAssists_upv_1.Arrow, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_33):Play()
        local tbl_34 = {TextTransparency = 0, TextStrokeTransparency = 0}
        game:GetService("TweenService"):Create(topAssists_upv_1.plrName, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_34):Play()
        local tbl_35 = {TextTransparency = 0, TextStrokeTransparency = 0}
        game:GetService("TweenService"):Create(topAssists_upv_1.Info, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_35):Play()
        task.delay(
            0.1,
            function()
                --[[
                  line: 238
                  upvalues:
                    topAssists_upv_1 (copy, index: 1)
                ]]
                local tbl_36 = {BackgroundTransparency = 0.25}
                game:GetService("TweenService"):Create(topAssists_upv_1, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_36):Play()
                local tbl_37 = {ImageTransparency = 0.25}
                game:GetService("TweenService"):Create(topAssists_upv_1.Arrow, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_37):Play()
                local tbl_38 = {TextTransparency = 0, TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(topAssists_upv_1.plrName, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_38):Play()
                local tbl_39 = {TextTransparency = 0, TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(topAssists_upv_1.Info, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_39):Play()
            end
        )
        task.wait(0.55)
        local v33 = game.ReplicatedStorage.UISounds.ui_starbar_impact_2:Clone()
        v33.Parent = game.Workspace
        v33:Play()
        game.Debris:AddItem(v33, 3)
        local tbl_40 = {BackgroundTransparency = 0}
        game:GetService("TweenService"):Create(topScore_upv_1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_40):Play()
        local tbl_41 = {ImageTransparency = 0}
        game:GetService("TweenService"):Create(topScore_upv_1.Arrow, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_41):Play()
        local tbl_42 = {TextTransparency = 0, TextStrokeTransparency = 0}
        game:GetService("TweenService"):Create(topScore_upv_1.plrName, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_42):Play()
        local tbl_43 = {TextTransparency = 0, TextStrokeTransparency = 0}
        game:GetService("TweenService"):Create(topScore_upv_1.Info, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_43):Play()
        task.delay(
            0.1,
            function()
                --[[
                  line: 274
                  upvalues:
                    topScore_upv_1 (copy, index: 1)
                ]]
                local tbl_44 = {BackgroundTransparency = 0.25}
                game:GetService("TweenService"):Create(topScore_upv_1, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_44):Play()
                local tbl_45 = {ImageTransparency = 0.25}
                game:GetService("TweenService"):Create(topScore_upv_1.Arrow, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_45):Play()
                local tbl_46 = {TextTransparency = 0, TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(topScore_upv_1.plrName, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_46):Play()
                local tbl_47 = {TextTransparency = 0, TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(topScore_upv_1.Info, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_47):Play()
            end
        )
        task.wait(0.55)
        local v34 = game.ReplicatedStorage.UISounds.ui_starbar_impact_3:Clone()
        v34.Parent = game.Workspace
        v34:Play()
        game.Debris:AddItem(v34, 3)
        local tbl_48 = {BackgroundTransparency = 0}
        game:GetService("TweenService"):Create(MVP_upv_1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_48):Play()
        local tbl_49 = {ImageTransparency = 0}
        game:GetService("TweenService"):Create(MVP_upv_1.Arrow, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_49):Play()
        local tbl_50 = {TextTransparency = 0, TextStrokeTransparency = 0}
        game:GetService("TweenService"):Create(MVP_upv_1.plrName, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_50):Play()
        local tbl_51 = {TextTransparency = 0, TextStrokeTransparency = 0}
        game:GetService("TweenService"):Create(MVP_upv_1.Info, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_51):Play()
        task.delay(
            0.1,
            function()
                --[[
                  line: 310
                  upvalues:
                    MVP_upv_1 (copy, index: 1)
                ]]
                local tbl_52 = {BackgroundTransparency = 0.25}
                game:GetService("TweenService"):Create(MVP_upv_1, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_52):Play()
                local tbl_53 = {ImageTransparency = 0.25}
                game:GetService("TweenService"):Create(MVP_upv_1.Arrow, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_53):Play()
                local tbl_54 = {TextTransparency = 0, TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(MVP_upv_1.plrName, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_54):Play()
                local tbl_55 = {TextTransparency = 0, TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(MVP_upv_1.Info, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_55):Play()
            end
        )
        task.wait(13.9)
        local v35 = game.ReplicatedStorage.UISounds.ui_start_travel:Clone()
        v35.Parent = game.Workspace
        v35:Play()
        game.Debris:AddItem(v35, 3)
        v25:Disconnect()
        CurrentCamera_upv_1.CameraType = Enum.CameraType.Custom
        UpperShutter_upv_1.Visible = true
        LowerShutter_upv_1.Visible = true
        local TweenService_13 = game:GetService("TweenService")
        local v36 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_56 = {}
        tbl_56.Size = UDim2.new(1, 0, 0.55, 0)
        TweenService_13:Create(LowerShutter_upv_1, v36, tbl_56):Play()
        local TweenService_14 = game:GetService("TweenService")
        local v37 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_57 = {}
        tbl_57.Size = UDim2.new(1, 0, 0.55, 0)
        TweenService_14:Create(UpperShutter_upv_1, v37, tbl_57):Play()
        task.delay(
            0.5,
            function()
                --[[
                  line: 344
                  upvalues:
                    a5 (copy, index: 1)
                ]]
                rewardsDisplay(a5.Coins, a5.EXP)
            end
        )
        task.delay(
            4,
            function()
                --[[
                  line: 347
                  upvalues:
                    LowerShutter_upv_1 (copy, index: 1)
                    UpperShutter_upv_1 (copy, index: 2)
                ]]
                local v38 = game.ReplicatedStorage.UISounds.ui_start_travel:Clone()
                v38.Parent = game.Workspace
                v38:Play()
                game.Debris:AddItem(v38, 3)
                local v39 = game.ReplicatedStorage.UISounds.ui_starbar_launch:Clone()
                v39.Parent = game.Workspace
                v39:Play()
                game.Debris:AddItem(v39, 3)
                local TweenService_15 = game:GetService("TweenService")
                local v40 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_58 = {}
                tbl_58.Size = UDim2.new(1, 0, 0, 0)
                TweenService_15:Create(LowerShutter_upv_1, v40, tbl_58):Play()
                local TweenService_16 = game:GetService("TweenService")
                local v41 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_59 = {}
                tbl_59.Size = UDim2.new(1, 0, 0, 0)
                TweenService_16:Create(UpperShutter_upv_1, v41, tbl_59):Play()
                task.wait(0.5)
                UpperShutter_upv_1.Visible = false
                LowerShutter_upv_1.Visible = false
            end
        )
        v24:Destroy()
        bottomFrame_upv_1.Position = UDim2.new(0, 0, 1, 133)
        topFrame_upv_1.Position = UDim2.new(0, 0, 0, -133)
        MVP_upv_1.BackgroundTransparency = 1
        MVP_upv_1.Arrow.ImageTransparency = 1
        MVP_upv_1.plrName.TextTransparency = 1
        MVP_upv_1.plrName.TextStrokeTransparency = 1
        MVP_upv_1.Info.TextTransparency = 1
        MVP_upv_1.Info.TextStrokeTransparency = 1
        topScore_upv_1.BackgroundTransparency = 1
        topScore_upv_1.Arrow.ImageTransparency = 1
        topScore_upv_1.plrName.TextTransparency = 1
        topScore_upv_1.plrName.TextStrokeTransparency = 1
        topScore_upv_1.Info.TextTransparency = 1
        topScore_upv_1.Info.TextStrokeTransparency = 1
        topAssists_upv_1.BackgroundTransparency = 1
        topAssists_upv_1.Arrow.ImageTransparency = 1
        topAssists_upv_1.plrName.TextTransparency = 1
        topAssists_upv_1.plrName.TextStrokeTransparency = 1
        topAssists_upv_1.Info.TextTransparency = 1
        topAssists_upv_1.Info.TextStrokeTransparency = 1
    end
)
v22:GetKey("DrawClient").OnClientEvent:Connect(
    function(a1)
        --[[
          line: 391
          upvalues:
            GameEnd_upv_1 (copy, index: 1)
        ]]
        shutter()
        task.wait(0.5)
        if a1 ~= true then
            GameEnd_upv_1.Text = "PENALTY SHOOTOUT"
        else
            GameEnd_upv_1.Text = "FULL TIME"
        end
        local tbl_60 = {TextTransparency = 0, TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(GameEnd_upv_1, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_60):Play()
        task.wait(2)
        local tbl_61 = {TextTransparency = 1, TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(GameEnd_upv_1, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_61):Play()
    end
)
v22:GetKey("FinalShootoutClient").OnClientEvent:Connect(
    function()
        --[[
          line: 411
          upvalues:
            GameEnd_upv_1 (copy, index: 1)
        ]]
        shutter()
        task.wait(0.5)
        GameEnd_upv_1.Text = "FINAL SHOOTOUT"
        local tbl_62 = {TextTransparency = 0, TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(GameEnd_upv_1, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_62):Play()
        task.wait(2)
        local tbl_63 = {TextTransparency = 1, TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(GameEnd_upv_1, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_63):Play()
    end
)
v22:GetKey("HalftimeClient").OnClientEvent:Connect(
    function()
        --[[
          line: 426
          upvalues:
            GameEnd_upv_1 (copy, index: 1)
        ]]
        shutter()
        task.wait(0.5)
        GameEnd_upv_1.Text = "HALF TIME"
        local tbl_64 = {TextTransparency = 0, TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(GameEnd_upv_1, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_64):Play()
        task.wait(2)
        local tbl_65 = {TextTransparency = 1, TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(GameEnd_upv_1, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_65):Play()
    end
)