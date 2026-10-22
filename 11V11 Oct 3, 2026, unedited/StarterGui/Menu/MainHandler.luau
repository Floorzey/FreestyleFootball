--[[
    Script Path: Game/StarterGui/Menu/MainHandler
    Class: LocalScript
    Time: 2026-10-03 12:27:08
--]]

local MenuButtons_upv_1 = script.Parent.MenuButtons
local LeftFrame_1 = script.Parent.LeftFrame
local PlayButton_upv_1 = script.Parent.PlayButton
local PosSelectFrame_upv_1 = script.Parent.PosSelectFrame
local TeamSelectFrame_upv_1 = script.Parent.TeamSelectFrame
local SkillFrame_upv_1 = script.Parent.SkillFrame
local NotificationLabel_upv_1 = script.Parent.NotificationLabel
local StatsFrame_upv_1 = script.Parent.StatsFrame
local Holder_upv_1 = script.Parent.Coins.Holder
local Holder_upv_2 = script.Parent.EXP.Holder
local CustomizationFrame_upv_1 = script.Parent.CustomizationFrame
local ColorSelector_upv_1 = CustomizationFrame_upv_1.ColorSelector
local LocalPlayer_upv_1 = game.Players.LocalPlayer
local tbl_upv_1 = {}
tbl_upv_1.N0tRady = true
tbl_upv_1.AnhTuanPro123456 = true
tbl_upv_1.rolevote = true
tbl_upv_1.Magikk3333 = true
tbl_upv_1.FluffyAstral = true
tbl_upv_1.supermanjack2419 = true
tbl_upv_1.max2847621 = true
tbl_upv_1.Flxtraw = true
tbl_upv_1["101extreme566"] = true
tbl_upv_1.DaytonHD1 = true
tbl_upv_1.denfertt = true
tbl_upv_1.PatrickPepe_alt2 = true
tbl_upv_1.zambrotta_z = true
tbl_upv_1.ska5te = true
tbl_upv_1.PAPAPATRATATA6 = true
tbl_upv_1.noobieman_official = true
tbl_upv_1.kaitoudono = true
local tbl_upv_2 = {}
tbl_upv_2.Argentina = "rbxassetid://8131230537"
tbl_upv_2.Brazil = "rbxassetid://11705710978"
tbl_upv_2.Germany = "rbxassetid://8120346775"
tbl_upv_2.France = "rbxassetid://13539436075"
tbl_upv_2.England = "rbxassetid://4807448"
tbl_upv_2.Scotland = "rbxassetid://12261193582"
tbl_upv_2.Wales = "rbxassetid://4460818460"
tbl_upv_2.Spain = "rbxassetid://13397364163"
tbl_upv_2.USA = "rbxassetid://60169251"
tbl_upv_2.Japan = "rbxassetid://8131128121"
tbl_upv_2.Italy = "rbxassetid://11919934085"
tbl_upv_2.Croatia = "rbxassetid://12220234274"
tbl_upv_2.Morocco = "rbxassetid://12598544754"
tbl_upv_2.Canada = "rbxassetid://12300382903"
tbl_upv_2.Portugal = "rbxassetid://13707539058"
tbl_upv_2.Mexico = "rbxassetid://713432113"
tbl_upv_2.Netherlands = "rbxassetid://198692974"
tbl_upv_2[""] = "rbxassetid://10201001615"
repeat
    task.wait()
until LocalPlayer_upv_1:FindFirstChild("dataLoaded")
repeat
    repeat
        task.wait()
    until game.ReplicatedStorage.TeamInfo.CurrentAwayTeam.Value ~= ""
until game.ReplicatedStorage.TeamInfo.CurrentHomeTeam.Value ~= ""
local Accomplishments_upv_1 = StatsFrame_upv_1.PickCategoryFrame.Accomplishments
local PersonalStats_upv_1 = StatsFrame_upv_1.PickCategoryFrame.PersonalStats
local PersonalStatsFrame_upv_1 = StatsFrame_upv_1.PersonalStatsFrame
require(game.ReplicatedStorage.Modules.client)
Accomplishments_upv_1.MouseButton1Click:Connect(
    function()
        --[[
          line: 67
          upvalues:
            Accomplishments_upv_1 (copy, index: 1)
            PersonalStats_upv_1 (copy, index: 2)
            StatsFrame_upv_1 (copy, index: 3)
            PersonalStatsFrame_upv_1 (copy, index: 4)
        ]]
        local tbl_3 = {TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(Accomplishments_upv_1, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_3):Play()
        local tbl_4 = {TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(PersonalStats_upv_1, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_4):Play()
        StatsFrame_upv_1.LeftFrame.Visible = true
        StatsFrame_upv_1.SelectionFrame.Visible = true
        PersonalStatsFrame_upv_1.Visible = false
    end
)
PersonalStats_upv_1.MouseButton1Click:Connect(
    function()
        --[[
          line: 79
          upvalues:
            PersonalStats_upv_1 (copy, index: 1)
            Accomplishments_upv_1 (copy, index: 2)
            StatsFrame_upv_1 (copy, index: 3)
            PersonalStatsFrame_upv_1 (copy, index: 4)
        ]]
        local tbl_5 = {TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(PersonalStats_upv_1, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_5):Play()
        local tbl_6 = {TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(Accomplishments_upv_1, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_6):Play()
        StatsFrame_upv_1.LeftFrame.Visible = false
        StatsFrame_upv_1.SelectionFrame.Visible = false
        PersonalStatsFrame_upv_1.Visible = true
    end
)
local StatSpread_upv_1 = PersonalStatsFrame_upv_1.RadarFrame.StatSpread
local u1 = Vector2.new(106, 106)
local u2 = Vector2.new(0.5, 0.5)
local u3 = Instance.new("ImageLabel")
u3.BackgroundTransparency = 1
u3.AnchorPoint = u2
u3.BorderSizePixel = 0
local tbl_upv_7 = {"DRB", "SHO", "OFF", "DEF", "SPD", "PAS"}
function getRank(a1)
    --[[
      name: getRank
      line: 179
    ]]
    if a1 <= 20 then
        return "E"
    end
    if a1 <= 35 then
        return "D"
    end
    if a1 <= 50 then
        return "C"
    end
    if a1 <= 65 then
        return "B"
    end
    if a1 <= 80 then
        return "A"
    elseif a1 <= 95 then
        return "S"
    else
        return "SS"
    end
end
function getMedian(a1)
    --[[
      name: getMedian
      line: 197
    ]]
    local tbl_8 = {}
    for _, value_1 in pairs(a1) do
        table.insert(tbl_8, value_1)
    end
    table.sort(tbl_8)
    if #tbl_8 % 2 ~= 0 then
        return tbl_8[math.ceil(#tbl_8 / 2)]
    end
    return (tbl_8[#tbl_8 / 2] + tbl_8[(#tbl_8 / 2) + 1]) / 2
end
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
local v1 = Knit_1.GetService("KeyHandlerService")
local u4 = v1:GetKey("EquipCosmetic")
local u5 = v1:GetKey("UpdateSetting")
local u6 = v1:GetKey("UpdateInputSetting")
local u7 = v1:GetKey("RobuxPurchase")
local u8 = v1:GetKey("getAttributePoints")
local u9 = v1:GetKey("getPosStats")
local u10 = v1:GetKey("SelectSkill")
local u11 = v1:GetKey("BuyCheck")
local u12 = v1:GetKey("SelectPosition")
local u13 = v1:GetKey("updateJerseyNumber")
local u14 = v1:GetKey("getDailyShop")
local u15 = v1:GetKey("Purchase")
local u16 = v1:GetKey("EnterCode")
local function DrawLine(a1, a2, a3)
    --[[
      name: DrawLine
      line: 160
    ]]
    local v2 = math.sqrt(math.pow(a1.X - a2.X, 2) + math.pow(a1.Y - a2.Y, 2))
    local v3 = Vector2.new((a1.X + a2.X) / 2, (a1.Y + a2.Y) / 2)
    local v4 = math.atan2(a1.Y - a2.Y, a1.X - a2.X)
    local v5 = Instance.new("Frame")
    v5.Size = UDim2.new(0, v2 + 1, 0, a3)
    v5.AnchorPoint = Vector2.new(0.5, 0.5)
    v5.Position = UDim2.new(0, v3.X, 0, v3.Y)
    v5.Rotation = math.deg(v4)
    local v6 = Instance.new("UIGradient")
    v6.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.2, 0), NumberSequenceKeypoint.new(0.5, 0.8), NumberSequenceKeypoint.new(0.8, 0), NumberSequenceKeypoint.new(1, 0)})
    v6.Parent = v5
    local v7 = Instance.new("UICorner")
    v7.CornerRadius = UDim.new(0.5, 0)
    v7.Parent = v5
    return v5
end
function drawStatBackground()
    --[[
      name: drawStatBackground
      line: 232
      upvalues:
        u1 (copy, index: 1)
        DrawLine (copy, index: 2)
        StatSpread_upv_1 (copy, index: 3)
    ]]
    for n_1 = 1, 6 do
        local v8 = math.rad(((n_1 * 360) / 6) + 30)
        local v9 = v8 - 1.0471975511965976
        local v10 = u1 + Vector2.new(math.sin(v9) * 1, math.cos(v9) * 1) * 105
        local v11 = u1 + Vector2.new(math.sin(v8) * 1, math.cos(v8) * 1) * 105
        local v12 = DrawLine(u1, v10, 2)
        v12.BorderSizePixel = 0
        v12.ZIndex = 4
        v12.Parent = StatSpread_upv_1
        v12.BackgroundColor3 = Color3.new(0.509804, 0.509804, 0.509804)
        v12.Name = "Background"
        local v13 = DrawLine(v10, v11, 2)
        v13.BorderSizePixel = 0
        v13.ZIndex = 4
        v13.Parent = StatSpread_upv_1
        v13.BackgroundColor3 = Color3.new(0.509804, 0.509804, 0.509804)
        v13.Name = "Background"
    end
end
function comma_value(a1)
    --[[
      name: comma_value
      line: 264
    ]]
    local v14 = a1
    local v15
    repeat
        local v16
        v16, v15 = string.gsub(v14, "^(-?%d+)(%d%d%d)", "%1,%2")
        v14 = v16
    until v15 == 0
    return v14
end
local function GetHighest(a1)
    --[[
      name: GetHighest
      line: 276
    ]]
    local v17 = 0
    for _, value_2 in ipairs(a1) do
        if v17 < value_2 then
            v17 = value_2
        end
    end
    return v17
end
function getPlayerValue()
    --[[
      name: getPlayerValue
      line: 295
      upvalues:
        u8 (copy, index: 1)
        LocalPlayer_upv_1 (copy, index: 2)
    ]]
    local v18 = u8:InvokeServer("Overall")
    local tbl_9 = {}
    for _, value_3 in pairs(v18.STR) do
        table.insert(tbl_9, pointsLogorithmicToRating(value_3))
    end
    local v19 = getMedian(tbl_9)
    local tbl_10 = {}
    for _, value_4 in pairs(v18.MID) do
        table.insert(tbl_10, pointsLogorithmicToRating(value_4))
    end
    local v20 = getMedian(tbl_10)
    local tbl_11 = {}
    for _, value_5 in pairs(v18.DEF) do
        table.insert(tbl_11, pointsLogorithmicToRating(value_5))
    end
    local v21 = getMedian(tbl_11)
    local tbl_12 = {}
    for _, value_6 in pairs(v18.KPR) do
        table.insert(tbl_12, pointsLogorithmicToRating(value_6))
    end
    local v22 = {v19, v20, v21, getMedian(tbl_12)}
    local v24 = 0
    for _, value_7 in ipairs(v22) do
        if v24 < value_7 then
            v24 = value_7
        end
    end
    local v25 = getRank(v24)
    v22 = 1
    if v25 == "D" then
        v22 = 4
    elseif v25 == "C" then
        v22 = 12
    elseif v25 == "B" then
        v22 = 36
    elseif v25 == "A" then
        v22 = 108
    elseif v25 == "S" then
        v22 = 216
    elseif v25 == "SS" then
        v22 = 324
    end
    return "$" .. comma_value(math.floor((((((0 + ((LocalPlayer_upv_1.Data.Wins.Value * 100) * v22)) + ((LocalPlayer_upv_1.Data.Goals.Value * 50) * v22)) + ((LocalPlayer_upv_1.Data.Assists.Value * 40) * v22)) + ((LocalPlayer_upv_1.Data.Passes.Value * 20) * v22)) + ((LocalPlayer_upv_1.Data.Tackles.Value * 25) * v22)) + ((LocalPlayer_upv_1.Data.Saves.Value * 75) * v22)))
end
function pointsLogorithmicToRating(a1)
    --[[
      name: pointsLogorithmicToRating
      line: 349
    ]]
    local v26 = 0
    v26 = nil
    repeat
        a1 = a1 - v26 * 2.5
        v26 = v26 + 1
    until a1 - v26 < 0
    v26 = v26 - 1
    v26 = ((v26 > 99) and 99) or v26
    if v26 < 0 then
        v26 = 0
    end
    return v26
end
local RadarFrame_upv_1 = PersonalStatsFrame_upv_1.RadarFrame
local LeftFrame_upv_2 = PersonalStatsFrame_upv_1.LeftFrame
LeftFrame_upv_2.plrName.Text = string.upper(LocalPlayer_upv_1.DisplayName)
LeftFrame_upv_2.plrIcon.Image = game.Players:GetUserThumbnailAsync(LocalPlayer_upv_1.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
LeftFrame_upv_2.Origin.Image = tbl_upv_2[LocalPlayer_upv_1.Data.Origin.Value]
LocalPlayer_upv_1.Data.Origin.Changed:Connect(
    function()
        --[[
          line: 367
          upvalues:
            LeftFrame_upv_2 (copy, index: 1)
            tbl_upv_2 (copy, index: 2)
            LocalPlayer_upv_1 (copy, index: 3)
        ]]
        LeftFrame_upv_2.Origin.Image = tbl_upv_2[LocalPlayer_upv_1.Data.Origin.Value]
    end
)
local SelectionFrame_upv_1 = PersonalStatsFrame_upv_1.SelectionFrame
local u17 = "STR"
local function draw2dTriangle(a1, a2, a3, a4, a5, a6)
    --[[
      name: draw2dTriangle
      line: 105
      upvalues:
        u3 (copy, index: 1)
        u2 (copy, index: 2)
    ]]
    local v27 = a2 - a1
    local v28 = a3 - a1
    local v29 = a3 - a2
    local v30 = v27:Dot(v27)
    local v31 = v28:Dot(v28)
    local v32 = v29:Dot(v29)
    if (v31 < v30) and (v32 < v30) then
        a1, a3 = a3, a1
    elseif v32 < v31 and v30 < v31 then
        a2, a1 = a1, a2
    end
    local v33 = a2 - a1
    local unit_1 = (a3 - a2).unit
    local v34 = unit_1:Cross(v33)
    local v35 = v34 >= 0
    local v36 = math.deg(math.atan2(unit_1.y, unit_1.x))
    local v37
    if v35 then
        v37 = 0
    else
        v37 = 180
    end
    local v38 = v36 + v37
    local v39 = (a1 + a2) / 2
    local v40 = (a1 + a3) / 2
    local v41 = a5 or (u3:Clone())
    v41.Image = (v35 and "rbxassetid://15444411230") or "rbxassetid://15444410184"
    v41.AnchorPoint = u2
    v41.Size = UDim2.new(0, math.abs(unit_1:Dot(v33)), 0, v34)
    v41.Position = UDim2.new(0, v39.x, 0, v39.y)
    v41.Rotation = v38
    v41.Parent = a4
    local v42 = a6 or (u3:Clone())
    v42.Image = (v35 and "rbxassetid://15444410184") or "rbxassetid://15444411230"
    v42.AnchorPoint = u2
    v42.Size = UDim2.new(0, math.abs(unit_1:Dot(a3 - a1)), 0, v34)
    v42.Position = UDim2.new(0, v40.x, 0, v40.y)
    v42.Rotation = v38
    v42.Parent = a4
    local v43 = Instance.new("UIGradient")
    v43.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 1)})
    v43.Parent = v35 and v41 or v42
    local v45 = Instance.new("UIGradient")
    v45.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.4)})
    v45.Parent = v35 and v42 or v41
    return v41, v42
end
function updateStatSpread(a1)
    --[[
      name: updateStatSpread
      line: 374
      upvalues:
        u17 (ref,  index: 1)
        u8 (copy, index: 2)
        RadarFrame_upv_1 (copy, index: 3)
        LeftFrame_upv_2 (copy, index: 4)
        StatSpread_upv_1 (copy, index: 5)
        tbl_upv_7 (copy, index: 6)
        u1 (copy, index: 7)
        DrawLine (copy, index: 8)
        PersonalStatsFrame_upv_1 (copy, index: 9)
        draw2dTriangle (copy, index: 10)
    ]]
    u17 = a1
    local v47 = u8:InvokeServer(a1)
    if u17 ~= a1 then
        return
    end
    local v48
    if a1 ~= "KPR" then
        local tbl_13 = {v47.DRBPoints, v47.SHOPoints, v47.OFFPoints, v47.DEFPoints, v47.SPDPoints, v47.PASPoints}
        RadarFrame_upv_1.DRB.Text = "DRB"
        RadarFrame_upv_1.SHO.Text = "SHO"
        RadarFrame_upv_1.OFF.Text = "OFF"
        RadarFrame_upv_1.DEF.Text = "DEF"
        RadarFrame_upv_1.SPD.Text = "SPD"
        RadarFrame_upv_1.PAS.Text = "PAS"
        LeftFrame_upv_2.DRB.Text = "DRB"
        LeftFrame_upv_2.SHO.Text = "SHO"
        LeftFrame_upv_2.OFF.Text = "OFF"
        LeftFrame_upv_2.DEF.Text = "DEF"
        LeftFrame_upv_2.SPD.Text = "SPD"
        LeftFrame_upv_2.PAS.Text = "PAS"
        v48 = tbl_13
    else
        local tbl_14 = {v47.DIVPoints, v47.HANPoints, v47.KICPoints, v47.REFPoints, v47.SPDPoints, v47.POSPoints}
        RadarFrame_upv_1.DRB.Text = "DIV"
        RadarFrame_upv_1.SHO.Text = "HAN"
        RadarFrame_upv_1.OFF.Text = "KIC"
        RadarFrame_upv_1.DEF.Text = "REF"
        RadarFrame_upv_1.SPD.Text = "SPD"
        RadarFrame_upv_1.PAS.Text = "POS"
        LeftFrame_upv_2.DRB.Text = "DIV"
        LeftFrame_upv_2.SHO.Text = "HAN"
        LeftFrame_upv_2.OFF.Text = "KIC"
        LeftFrame_upv_2.DEF.Text = "REF"
        LeftFrame_upv_2.SPD.Text = "SPD"
        LeftFrame_upv_2.PAS.Text = "POS"
        v48 = tbl_14
    end
    LeftFrame_upv_2.Pos.Text = ((a1 == "Overall") and "OVERALL") or (((a1 == "STR") and "FWD") or (((a1 == "MID") and "MD") or (((a1 == "DEF") and "DE") or ((a1 == "KPR") and "GK"))))
    for _, value_8 in pairs(StatSpread_upv_1:GetChildren()) do
        if value_8:IsA("ImageLabel") or value_8:IsA("Frame") and value_8.Name ~= "Background" then
            value_8:Destroy()
        end
    end
    local tbl_15 = {}
    for key_1, _ in pairs(v48) do
        local v49 = pointsLogorithmicToRating(v48[key_1])
        table.insert(tbl_15, v49)
        local v50 = tbl_upv_7[key_1] or (tbl_upv_7[#tbl_upv_7])
        local v51 = pointsLogorithmicToRating(v48[key_1 - 1] or (v48[#v48]))
        local v52 = math.rad(((key_1 * 360) / 6) + 30)
        local v53 = v52 - 1.0471975511965976
        local v54 = u1 + Vector2.new(math.sin(v53), math.cos(v53)) * ((105 * v51) / 100)
        local v55 = u1 + Vector2.new(math.sin(v52), math.cos(v52)) * ((105 * v49) / 100)
        local v56 = DrawLine(u1, v54, 2)
        v56.BorderSizePixel = 0
        v56.ZIndex = 5
        v56.Parent = StatSpread_upv_1
        v56.BackgroundColor3 = Color3.new(0.666667, 1, 1)
        v56.BackgroundTransparency = 0.5
        v56.Name = "LineLength " .. (105 * v49) / 100
        LeftFrame_upv_2[v50].Amount.Text = v49
        PersonalStatsFrame_upv_1.RadarFrame:FindFirstChild(v50 .. "Rating").Text = v49
        local v57 = PersonalStatsFrame_upv_1.RadarFrame:FindFirstChild(v50 .. "Rank")
        v57.Text = getRank(v49)
        local v58 = DrawLine(v54, v55, 3)
        v58.BorderSizePixel = 0
        v58.ZIndex = 5
        v58.Parent = StatSpread_upv_1
        v58.BackgroundColor3 = Color3.new(0.666667, 1, 1)
        v58.BackgroundTransparency = 0.5
        local v59, v60 = draw2dTriangle(u1, v54, v55, StatSpread_upv_1)
        v59.ImageColor3 = Color3.new(0.666667, 1, 1)
        v60.ImageColor3 = Color3.new(0.666667, 1, 1)
        v59.ZIndex = 4
        v60.ZIndex = 4
        v59.ImageTransparency = 0.75
        v60.ImageTransparency = 0.75
    end
    local v61 = getMedian(tbl_15)
    LeftFrame_upv_2.OverallRating.Text = math.floor(v61)
    LeftFrame_upv_2.OverallRating.OverallRank.Text = getRank(math.floor(v61))
end
updateStatSpread("STR")
drawStatBackground()
SelectionFrame_upv_1.STRButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 489
          upvalues:
            SelectionFrame_upv_1 (copy, index: 1)
        ]]
        local TweenService_1 = game:GetService("TweenService")
        local v62 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_16 = {}
        tbl_16.TextStrokeColor3 = Color3.new(1, 1, 1)
        TweenService_1:Create(SelectionFrame_upv_1.STRButton, v62, tbl_16):Play()
        for _, value_9 in pairs(SelectionFrame_upv_1:GetChildren()) do
            if not (value_9:IsA("TextButton")) then
                continue
            end
            if value_9 ~= SelectionFrame_upv_1.STRButton then
                local TweenService_2 = game:GetService("TweenService")
                local v63 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_17 = {}
                tbl_17.TextStrokeColor3 = Color3.new(0, 0, 0)
                TweenService_2:Create(value_9, v63, tbl_17):Play()
            end
        end
        local v64 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
        v64.Parent = game.Workspace
        v64:Play()
        game.Debris:AddItem(v64, 3)
        updateStatSpread("STR")
    end
)
SelectionFrame_upv_1.MIDButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 507
          upvalues:
            SelectionFrame_upv_1 (copy, index: 1)
        ]]
        local TweenService_3 = game:GetService("TweenService")
        local v65 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_18 = {}
        tbl_18.TextStrokeColor3 = Color3.new(1, 1, 1)
        TweenService_3:Create(SelectionFrame_upv_1.MIDButton, v65, tbl_18):Play()
        for _, value_10 in pairs(SelectionFrame_upv_1:GetChildren()) do
            if not (value_10:IsA("TextButton")) then
                continue
            end
            if value_10 ~= SelectionFrame_upv_1.MIDButton then
                local TweenService_4 = game:GetService("TweenService")
                local v66 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_19 = {}
                tbl_19.TextStrokeColor3 = Color3.new(0, 0, 0)
                TweenService_4:Create(value_10, v66, tbl_19):Play()
            end
        end
        local v67 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
        v67.Parent = game.Workspace
        v67:Play()
        game.Debris:AddItem(v67, 3)
        updateStatSpread("MID")
    end
)
SelectionFrame_upv_1.DEFButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 525
          upvalues:
            SelectionFrame_upv_1 (copy, index: 1)
        ]]
        local TweenService_5 = game:GetService("TweenService")
        local v68 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_20 = {}
        tbl_20.TextStrokeColor3 = Color3.new(1, 1, 1)
        TweenService_5:Create(SelectionFrame_upv_1.DEFButton, v68, tbl_20):Play()
        for _, value_11 in pairs(SelectionFrame_upv_1:GetChildren()) do
            if not (value_11:IsA("TextButton")) then
                continue
            end
            if value_11 ~= SelectionFrame_upv_1.DEFButton then
                local TweenService_6 = game:GetService("TweenService")
                local v69 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_21 = {}
                tbl_21.TextStrokeColor3 = Color3.new(0, 0, 0)
                TweenService_6:Create(value_11, v69, tbl_21):Play()
            end
        end
        local v70 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
        v70.Parent = game.Workspace
        v70:Play()
        game.Debris:AddItem(v70, 3)
        updateStatSpread("DEF")
    end
)
SelectionFrame_upv_1.KPRButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 544
          upvalues:
            SelectionFrame_upv_1 (copy, index: 1)
        ]]
        local TweenService_7 = game:GetService("TweenService")
        local v71 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_22 = {}
        tbl_22.TextStrokeColor3 = Color3.new(1, 1, 1)
        TweenService_7:Create(SelectionFrame_upv_1.KPRButton, v71, tbl_22):Play()
        for _, value_12 in pairs(SelectionFrame_upv_1:GetChildren()) do
            if not (value_12:IsA("TextButton")) then
                continue
            end
            if value_12 ~= SelectionFrame_upv_1.KPRButton then
                local TweenService_8 = game:GetService("TweenService")
                local v72 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_23 = {}
                tbl_23.TextStrokeColor3 = Color3.new(0, 0, 0)
                TweenService_8:Create(value_12, v72, tbl_23):Play()
            end
        end
        local v73 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
        v73.Parent = game.Workspace
        v73:Play()
        game.Debris:AddItem(v73, 3)
        updateStatSpread("KPR")
    end
)
local LeftFrame_upv_3 = StatsFrame_upv_1.LeftFrame
LeftFrame_upv_3.plrName.Text = string.upper(LocalPlayer_upv_1.DisplayName)
LeftFrame_upv_3.plrIcon.Image = game.Players:GetUserThumbnailAsync(LocalPlayer_upv_1.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
function setStatsForSelection(a1)
    --[[
      name: setStatsForSelection
      line: 566
      upvalues:
        LeftFrame_upv_3 (copy, index: 1)
        LocalPlayer_upv_1 (copy, index: 2)
        u9 (copy, index: 3)
    ]]
    if a1 ~= "Overall" then
        local v74 = u9:InvokeServer(a1)
        LeftFrame_upv_3.WINS.Amount.Text = v74.Wins
        LeftFrame_upv_3.LOSSES.Amount.Text = v74.Losses
        LeftFrame_upv_3.GOALS.Amount.Text = v74.Goals
        LeftFrame_upv_3.ASSISTS.Amount.Text = v74.Assists
        LeftFrame_upv_3.PASSES.Amount.Text = v74.Passes
        LeftFrame_upv_3.TACKLES.Amount.Text = v74.Tackles
        LeftFrame_upv_3.SAVES.Amount.Text = v74.Saves
        LeftFrame_upv_3.OOB.Amount.Text = v74.OOB
    else
        LeftFrame_upv_3.WINS.Amount.Text = LocalPlayer_upv_1.Data.Wins.Value
        LeftFrame_upv_3.LOSSES.Amount.Text = LocalPlayer_upv_1.Data.Losses.Value
        LeftFrame_upv_3.GOALS.Amount.Text = LocalPlayer_upv_1.Data.Goals.Value
        LeftFrame_upv_3.ASSISTS.Amount.Text = LocalPlayer_upv_1.Data.Assists.Value
        LeftFrame_upv_3.PASSES.Amount.Text = LocalPlayer_upv_1.Data.Passes.Value
        LeftFrame_upv_3.TACKLES.Amount.Text = LocalPlayer_upv_1.Data.Tackles.Value
        LeftFrame_upv_3.SAVES.Amount.Text = LocalPlayer_upv_1.Data.Saves.Value
        LeftFrame_upv_3.OOB.Amount.Text = LocalPlayer_upv_1.Data.Penalties.Value
    end
end
StatsFrame_upv_1.SelectionFrame.STRButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 589
          upvalues:
            LeftFrame_upv_3 (copy, index: 1)
        ]]
        local v75 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
        v75.Parent = game.Workspace
        v75:Play()
        game.Debris:AddItem(v75, 3)
        LeftFrame_upv_3.posLabel.Text = "FORWARD"
        setStatsForSelection("STR")
    end
)
StatsFrame_upv_1.SelectionFrame.MIDButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 598
          upvalues:
            LeftFrame_upv_3 (copy, index: 1)
        ]]
        local v76 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
        v76.Parent = game.Workspace
        v76:Play()
        game.Debris:AddItem(v76, 3)
        LeftFrame_upv_3.posLabel.Text = "MIDFIELDER"
        setStatsForSelection("MID")
    end
)
StatsFrame_upv_1.SelectionFrame.DEFButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 607
          upvalues:
            LeftFrame_upv_3 (copy, index: 1)
        ]]
        local v77 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
        v77.Parent = game.Workspace
        v77:Play()
        game.Debris:AddItem(v77, 3)
        LeftFrame_upv_3.posLabel.Text = "DEFENDER"
        setStatsForSelection("DEF")
    end
)
StatsFrame_upv_1.SelectionFrame.KPRButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 616
          upvalues:
            LeftFrame_upv_3 (copy, index: 1)
        ]]
        local v78 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
        v78.Parent = game.Workspace
        v78:Play()
        game.Debris:AddItem(v78, 3)
        LeftFrame_upv_3.posLabel.Text = "GOALKEEPER"
        setStatsForSelection("KPR")
    end
)
StatsFrame_upv_1.SelectionFrame.OVRButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 625
          upvalues:
            LeftFrame_upv_3 (copy, index: 1)
        ]]
        local v79 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
        v79.Parent = game.Workspace
        v79:Play()
        game.Debris:AddItem(v79, 3)
        LeftFrame_upv_3.posLabel.Text = "OVERALL"
        setStatsForSelection("Overall")
    end
)
setStatsForSelection("Overall")
LocalPlayer_upv_1.Data.EXP.Changed:Connect(
    function()
        --[[
          line: 636
          upvalues:
            Holder_upv_2 (copy, index: 1)
            LocalPlayer_upv_1 (copy, index: 2)
        ]]
        Holder_upv_2.Bar.Bar.Size = UDim2.new(LocalPlayer_upv_1.Data.EXP.Value / (LocalPlayer_upv_1.Data.Level.Value * 500), 0, 1, 0)
    end
)
LocalPlayer_upv_1.Data.Level.Changed:Connect(
    function()
        --[[
          line: 640
          upvalues:
            Holder_upv_2 (copy, index: 1)
            LocalPlayer_upv_1 (copy, index: 2)
        ]]
        Holder_upv_2.Level.Text = LocalPlayer_upv_1.Data.Level.Value
    end
)
Holder_upv_2.Bar.Bar.Size = UDim2.new(LocalPlayer_upv_1.Data.EXP.Value / (LocalPlayer_upv_1.Data.Level.Value * 500), 0, 1, 0)
Holder_upv_2.Level.Text = LocalPlayer_upv_1.Data.Level.Value
LocalPlayer_upv_1.Data.Coins.Changed:Connect(
    function()
        --[[
          line: 646
          upvalues:
            Holder_upv_1 (copy, index: 1)
            LocalPlayer_upv_1 (copy, index: 2)
        ]]
        Holder_upv_1.Amount.Text = LocalPlayer_upv_1.Data.Coins.Value
    end
)
Holder_upv_1.Amount.Text = LocalPlayer_upv_1.Data.Coins.Value
function notification(a1)
    --[[
      name: notification
      line: 651
      upvalues:
        NotificationLabel_upv_1 (copy, index: 1)
    ]]
    local v80 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
    v80.Parent = game.Workspace
    v80:Play()
    game.Debris:AddItem(v80, 3)
    NotificationLabel_upv_1.Text = a1
    NotificationLabel_upv_1.TextTransparency = 1
    NotificationLabel_upv_1.TextStrokeTransparency = 1
    local tbl_24 = {TextTransparency = 0, TextStrokeTransparency = 0.75}
    game:GetService("TweenService"):Create(NotificationLabel_upv_1, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_24):Play()
    task.delay(
        1,
        function()
            --[[
              line: 663
              upvalues:
                NotificationLabel_upv_1 (copy, index: 1)
            ]]
            local tbl_25 = {TextTransparency = 1, TextStrokeTransparency = 1}
            game:GetService("TweenService"):Create(NotificationLabel_upv_1, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_25):Play()
        end
    )
end
local u18 = "Field"
function setupSkillsFrame(a1)
    --[[
      name: setupSkillsFrame
      line: 673
      upvalues:
        u18 (ref,  index: 1)
        SkillFrame_upv_1 (copy, index: 2)
        tbl_upv_1 (copy, index: 3)
        LocalPlayer_upv_1 (copy, index: 4)
    ]]
    u18 = a1
    for _, value_13 in pairs(SkillFrame_upv_1.SkillList:GetChildren()) do
        if value_13:IsA("TextButton") then
            value_13:Destroy()
        end
    end
    local tbl_26 = {}
    for _, value_14 in pairs(game.ReplicatedStorage.SkillInfo:GetChildren()) do
        if (a1 ~= "Goalie" or value_14:FindFirstChild("Goalie")) and (a1 ~= "Field" or not (value_14:FindFirstChild("Goalie"))) and value_14:IsA("Folder") and (not (value_14:FindFirstChild("DevSpec")) or tbl_upv_1[LocalPlayer_upv_1.Name]) then
            table.insert(tbl_26, {Level = value_14.Level.Value, skillName = value_14.Name})
        end
    end
    table.sort(
        tbl_26,
        function(a2, a3)
            --[[
              line: 697
            ]]
            return a2.Level < a3.Level
        end
    )
    for _, value_15 in pairs(tbl_26) do
        local u19 = game.ReplicatedStorage.SkillInfo:FindFirstChild(value_15.skillName)
        if not (u19) then
            continue
        end
        local u20 = false
        local u21 = script.skillTemplate:Clone()
        u21.Parent = SkillFrame_upv_1.SkillList
        u21.Text = string.upper(u19.Name)
        u21.skillIcon.Image = u19:FindFirstChild("skillIcon").Value
        u21.Type.Value = u19.Type.Value
        if u19.Name == LocalPlayer_upv_1.Data.SelectedSkill.Value or u19.Name == LocalPlayer_upv_1.Data.GoalieSkill.Value then
            u21.UIStroke.Color = Color3.new(1, 1, 1)
        end
        if not (LocalPlayer_upv_1.Data.Level.Value < u19.Level.Value) then
            local u22 = u21.MouseButton1Click:Connect(
                function()
                    --[[
                      line: 719
                      upvalues:
                        u20 (ref,  index: 1)
                        u21 (copy, index: 2)
                        SkillFrame_upv_1 (copy, index: 3)
                        u19 (copy, index: 4)
                        LocalPlayer_upv_1 (copy, index: 5)
                    ]]
                    if u20 ~= true then
                        local TweenService_9 = game:GetService("TweenService")
                        local v81 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        local tbl_27 = {}
                        tbl_27.Color = Color3.new(1, 1, 1)
                        TweenService_9:Create(u21.UIStroke, v81, tbl_27):Play()
                        for _, value_16 in pairs(SkillFrame_upv_1.SkillList:GetChildren()) do
                            if not (value_16:IsA("TextButton")) then
                                continue
                            end
                            if value_16 ~= u21 then
                                local TweenService_10 = game:GetService("TweenService")
                                local v82 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                                local tbl_28 = {}
                                tbl_28.Color = Color3.fromRGB(108, 115, 122)
                                TweenService_10:Create(value_16.UIStroke, v82, tbl_28):Play()
                            end
                        end
                        local RightFrame_1 = SkillFrame_upv_1.RightFrame
                        RightFrame_1.skillIcon.Image = u19.skillIcon.Value
                        RightFrame_1.skillName.Text = string.upper(u19.Name)
                        RightFrame_1.skillDescription.Text = u19.Description.Value
                        RightFrame_1.skillType.Text = string.upper(u19.Type.Value) .. " TYPE"
                        if u19.Name ~= LocalPlayer_upv_1.Data.SelectedSkill.Value and u19.Name ~= LocalPlayer_upv_1.Data.GoalieSkill.Value then
                            RightFrame_1.selectButton.Text = "SELECT"
                        else
                            RightFrame_1.selectButton.Text = "SELECTED"
                        end
                    else
                        local v83 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
                        v83.Parent = game.Workspace
                        v83:Play()
                        game.Debris:AddItem(v83, 3)
                        task.spawn(
                            function()
                                --[[
                                  line: 725
                                  upvalues:
                                    u21 (copy, index: 1)
                                ]]
                                local tbl_29 = {Rotation = 45}
                                game:GetService("TweenService"):Create(u21.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_29):Play()
                                task.wait(0.1)
                                local tbl_30 = {Rotation = -45}
                                game:GetService("TweenService"):Create(u21.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_30):Play()
                                task.wait(0.1)
                                local tbl_31 = {Rotation = 0}
                                game:GetService("TweenService"):Create(u21.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_31):Play()
                            end
                        )
                    end
                end
            )
            u21.Destroying:Once(
                function()
                    --[[
                      line: 761
                      upvalues:
                        u22 (copy, index: 1)
                    ]]
                    u22:Disconnect()
                end
            )
            continue
        end
        local noLevelRequirement_1 = game.ReplicatedStorage:FindFirstChild("noLevelRequirement")
        if not (noLevelRequirement_1) then
            local v84 = true
            u21.Locked.Visible = true
            u21.LockedBG.Visible = true
            u21.LevelReq.Visible = true
            u21.LevelReq.Text = "LEVEL " .. u19.Level.Value
            u20 = v84
        end
        local u22 = u21.MouseButton1Click:Connect(
            function()
                --[[
                  line: 719
                  upvalues:
                    u20 (ref,  index: 1)
                    u21 (copy, index: 2)
                    SkillFrame_upv_1 (copy, index: 3)
                    u19 (copy, index: 4)
                    LocalPlayer_upv_1 (copy, index: 5)
                ]]
                if u20 ~= true then
                    local TweenService_9 = game:GetService("TweenService")
                    local v81 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local tbl_27 = {}
                    tbl_27.Color = Color3.new(1, 1, 1)
                    TweenService_9:Create(u21.UIStroke, v81, tbl_27):Play()
                    for _, value_16 in pairs(SkillFrame_upv_1.SkillList:GetChildren()) do
                        if not (value_16:IsA("TextButton")) then
                            continue
                        end
                        if value_16 ~= u21 then
                            local TweenService_10 = game:GetService("TweenService")
                            local v82 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                            local tbl_28 = {}
                            tbl_28.Color = Color3.fromRGB(108, 115, 122)
                            TweenService_10:Create(value_16.UIStroke, v82, tbl_28):Play()
                        end
                    end
                    local RightFrame_1 = SkillFrame_upv_1.RightFrame
                    RightFrame_1.skillIcon.Image = u19.skillIcon.Value
                    RightFrame_1.skillName.Text = string.upper(u19.Name)
                    RightFrame_1.skillDescription.Text = u19.Description.Value
                    RightFrame_1.skillType.Text = string.upper(u19.Type.Value) .. " TYPE"
                    if u19.Name ~= LocalPlayer_upv_1.Data.SelectedSkill.Value and u19.Name ~= LocalPlayer_upv_1.Data.GoalieSkill.Value then
                        RightFrame_1.selectButton.Text = "SELECT"
                    else
                        RightFrame_1.selectButton.Text = "SELECTED"
                    end
                else
                    local v83 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
                    v83.Parent = game.Workspace
                    v83:Play()
                    game.Debris:AddItem(v83, 3)
                    task.spawn(
                        function()
                            --[[
                              line: 725
                              upvalues:
                                u21 (copy, index: 1)
                            ]]
                            local tbl_29 = {Rotation = 45}
                            game:GetService("TweenService"):Create(u21.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_29):Play()
                            task.wait(0.1)
                            local tbl_30 = {Rotation = -45}
                            game:GetService("TweenService"):Create(u21.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_30):Play()
                            task.wait(0.1)
                            local tbl_31 = {Rotation = 0}
                            game:GetService("TweenService"):Create(u21.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_31):Play()
                        end
                    )
                end
            end
        )
        u21.Destroying:Once(
            function()
                --[[
                  line: 761
                  upvalues:
                    u22 (copy, index: 1)
                ]]
                u22:Disconnect()
            end
        )
    end
    if tbl_upv_1[LocalPlayer_upv_1.Name] and a1 == "Field" then
        local u23 = script.skillTemplate:Clone()
        u23.Parent = SkillFrame_upv_1.SkillList
        u23.Text = "GODSPEED"
        u23.skillIcon.Image = "http://www.roblox.com/asset/?id=5902417546"
        if LocalPlayer_upv_1.Data.SelectedSkill.Value == "Godspeed" then
            u23.UIStroke.Color = Color3.new(1, 1, 1)
        end
        local u24 = u23.MouseButton1Click:Connect(
            function()
                --[[
                  line: 775
                  upvalues:
                    u23 (copy, index: 1)
                    SkillFrame_upv_1 (copy, index: 2)
                    LocalPlayer_upv_1 (copy, index: 3)
                ]]
                local TweenService_11 = game:GetService("TweenService")
                local v85 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_32 = {}
                tbl_32.Color = Color3.new(1, 1, 1)
                TweenService_11:Create(u23.UIStroke, v85, tbl_32):Play()
                for _, value_17 in pairs(SkillFrame_upv_1.SkillList:GetChildren()) do
                    if not (value_17:IsA("TextButton")) then
                        continue
                    end
                    if value_17 ~= u23 then
                        local TweenService_12 = game:GetService("TweenService")
                        local v86 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        local tbl_33 = {}
                        tbl_33.Color = Color3.fromRGB(108, 115, 122)
                        TweenService_12:Create(value_17.UIStroke, v86, tbl_33):Play()
                    end
                end
                local RightFrame_2 = SkillFrame_upv_1.RightFrame
                RightFrame_2.skillIcon.Image = "http://www.roblox.com/asset/?id=5902417546"
                RightFrame_2.skillName.Text = "GODSPEED"
                RightFrame_2.skillDescription.Text = "godspeed godspeed godspeed"
                RightFrame_2.skillType.Text = "SPEED TYPE"
                if LocalPlayer_upv_1.Data.SelectedSkill.Value ~= "Godspeed" then
                    RightFrame_2.selectButton.Text = "SELECT"
                else
                    RightFrame_2.selectButton.Text = "SELECTED"
                end
            end
        )
        u23.Destroying:Once(
            function()
                --[[
                  line: 797
                  upvalues:
                    u24 (copy, index: 1)
                ]]
                u24:Disconnect()
            end
        )
    end
    if LocalPlayer_upv_1.Data.SelectedSkill.Value ~= "Godspeed" then
        local u23
        if a1 ~= "Field" then
            u23 = game.ReplicatedStorage.SkillInfo:FindFirstChild(LocalPlayer_upv_1.Data.GoalieSkill.Value)
        else
            u23 = game.ReplicatedStorage.SkillInfo:FindFirstChild(LocalPlayer_upv_1.Data.SelectedSkill.Value)
        end
        local RightFrame_3 = SkillFrame_upv_1.RightFrame
        RightFrame_3.skillIcon.Image = u23.skillIcon.Value
        RightFrame_3.skillName.Text = string.upper(u23.Name)
        RightFrame_3.skillDescription.Text = u23.Description.Value
        RightFrame_3.skillType.Text = string.upper(u23.Type.Value) .. " TYPE"
        RightFrame_3.selectButton.Text = "SELECTED"
    else
        local v87 = SkillFrame_upv_1.RightFrame
        v87.skillIcon.Image = "http://www.roblox.com/asset/?id=5902417546"
        v87.skillName.Text = "GODSPEED"
        v87.skillDescription.Text = "godspeed godspeed godspeed"
        v87.skillType.Text = "SPEED TYPE"
        v87.selectButton.Text = "SELECTED"
    end
    if tbl_upv_1[LocalPlayer_upv_1.Name] and a1 == "Field" then
        local u25 = script.skillTemplate:Clone()
        u25.Parent = SkillFrame_upv_1.SkillList
        u25.Text = "STREET DRIBBLE"
        u25.skillIcon.Image = "rbxassetid://90759096829751"
        if LocalPlayer_upv_1.Data.SelectedSkill.Value == "Street Dribble" then
            u25.UIStroke.Color = Color3.new(1, 0.74902, 0)
        end
        local u26 = u25.MouseButton1Click:Connect(
            function()
                --[[
                  line: 834
                  upvalues:
                    u25 (copy, index: 1)
                    SkillFrame_upv_1 (copy, index: 2)
                    LocalPlayer_upv_1 (copy, index: 3)
                ]]
                local TweenService_13 = game:GetService("TweenService")
                local v88 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_34 = {}
                tbl_34.Color = Color3.new(1, 1, 1)
                TweenService_13:Create(u25.UIStroke, v88, tbl_34):Play()
                for _, value_18 in pairs(SkillFrame_upv_1.SkillList:GetChildren()) do
                    if not (value_18:IsA("TextButton")) then
                        continue
                    end
                    if value_18 ~= u25 then
                        local TweenService_14 = game:GetService("TweenService")
                        local v89 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        local tbl_35 = {}
                        tbl_35.Color = Color3.fromRGB(108, 115, 122)
                        TweenService_14:Create(value_18.UIStroke, v89, tbl_35):Play()
                    end
                end
                local RightFrame_4 = SkillFrame_upv_1.RightFrame
                RightFrame_4.skillIcon.Image = "rbxassetid://90759096829751"
                RightFrame_4.skillName.Text = "STREET DRIBBLE"
                RightFrame_4.skillDescription.Text = "Street Football Dribble Style!"
                RightFrame_4.skillType.Text = "DRIBBLE TYPE"
                RightFrame_4.selectButton.Text = "SELECTED"
                if LocalPlayer_upv_1.Data.SelectedSkill.Value ~= "Street Dribble" then
                    RightFrame_4.selectButton.Text = "SELECT"
                else
                    RightFrame_4.selectButton.Text = "SELECTED"
                end
            end
        )
        u25.Destroying:Once(
            function()
                --[[
                  line: 857
                  upvalues:
                    u26 (copy, index: 1)
                ]]
                u26:Disconnect()
            end
        )
    end
    if tbl_upv_1[LocalPlayer_upv_1.Name] and a1 == "Field" then
        local u27 = script.skillTemplate:Clone()
        u27.Parent = SkillFrame_upv_1.SkillList
        u27.Text = "EXPLOSIVE RUSH"
        u27.skillIcon.Image = "http://www.roblox.com/asset/?id=15485263286"
        if LocalPlayer_upv_1.Data.SelectedSkill.Value == "Explosive Rush" then
            u27.UIStroke.Color = Color3.new(1, 1, 1)
        end
        local u28 = u27.MouseButton1Click:Connect(
            function()
                --[[
                  line: 871
                  upvalues:
                    u27 (copy, index: 1)
                    SkillFrame_upv_1 (copy, index: 2)
                    LocalPlayer_upv_1 (copy, index: 3)
                ]]
                local TweenService_15 = game:GetService("TweenService")
                local v90 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_36 = {}
                tbl_36.Color = Color3.new(1, 1, 1)
                TweenService_15:Create(u27.UIStroke, v90, tbl_36):Play()
                for _, value_19 in pairs(SkillFrame_upv_1.SkillList:GetChildren()) do
                    if not (value_19:IsA("TextButton")) then
                        continue
                    end
                    if value_19 ~= u27 then
                        local TweenService_16 = game:GetService("TweenService")
                        local v91 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        local tbl_37 = {}
                        tbl_37.Color = Color3.fromRGB(108, 115, 122)
                        TweenService_16:Create(value_19.UIStroke, v91, tbl_37):Play()
                    end
                end
                local RightFrame_5 = SkillFrame_upv_1.RightFrame
                RightFrame_5.skillIcon.Image = "http://www.roblox.com/asset/?id=15485263286"
                RightFrame_5.skillName.Text = "EXPLOSIVE RUSH"
                RightFrame_5.skillDescription.Text = "Catch up."
                RightFrame_5.skillType.Text = "SPEED TYPE"
                if LocalPlayer_upv_1.Data.SelectedSkill.Value ~= "Explosive Rush" then
                    RightFrame_5.selectButton.Text = "SELECT"
                else
                    RightFrame_5.selectButton.Text = "SELECTED"
                end
            end
        )
        u27.Destroying:Once(
            function()
                --[[
                  line: 893
                  upvalues:
                    u28 (copy, index: 1)
                ]]
                u28:Disconnect()
            end
        )
    end
    if LocalPlayer_upv_1.Data.SelectedSkill.Value ~= "Explosive Rush" then
        local v87
        if a1 ~= "Field" then
            v87 = game.ReplicatedStorage.SkillInfo:FindFirstChild(LocalPlayer_upv_1.Data.GoalieSkill.Value)
        else
            v87 = game.ReplicatedStorage.SkillInfo:FindFirstChild(LocalPlayer_upv_1.Data.SelectedSkill.Value)
        end
        local RightFrame_6 = SkillFrame_upv_1.RightFrame
        RightFrame_6.skillIcon.Image = v87.skillIcon.Value
        RightFrame_6.skillName.Text = string.upper(v87.Name)
        RightFrame_6.skillDescription.Text = v87.Description.Value
        RightFrame_6.skillType.Text = string.upper(v87.Type.Value) .. " TYPE"
        RightFrame_6.selectButton.Text = "SELECTED"
    else
        local RightFrame_7 = SkillFrame_upv_1.RightFrame
        RightFrame_7.skillIcon.Image = "http://www.roblox.com/asset/?id=5902417546"
        RightFrame_7.skillName.Text = "EXPLOSIVE RUSH"
        RightFrame_7.skillDescription.Text = "Catch up."
        RightFrame_7.skillType.Text = "SPEED TYPE"
        RightFrame_7.selectButton.Text = "SELECTED"
    end
end
task.spawn(
    function()
        --[[
          line: 920
          upvalues:
            LocalPlayer_upv_1 (copy, index: 1)
        ]]
        repeat
            task.wait()
        until LocalPlayer_upv_1.Data.SelectedSkill.Value ~= ""
        setupSkillsFrame("Field")
    end
)
SkillFrame_upv_1.PickCategoryFrame.FieldSkillsButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 925
          upvalues:
            SkillFrame_upv_1 (copy, index: 1)
        ]]
        local tbl_38 = {TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(SkillFrame_upv_1.PickCategoryFrame.FieldSkillsButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_38):Play()
        local tbl_39 = {TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(SkillFrame_upv_1.PickCategoryFrame.GoalieSkillsButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_39):Play()
        setupSkillsFrame("Field")
    end
)
SkillFrame_upv_1.PickCategoryFrame.GoalieSkillsButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 935
          upvalues:
            SkillFrame_upv_1 (copy, index: 1)
        ]]
        local tbl_40 = {TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(SkillFrame_upv_1.PickCategoryFrame.GoalieSkillsButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_40):Play()
        local tbl_41 = {TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(SkillFrame_upv_1.PickCategoryFrame.FieldSkillsButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_41):Play()
        setupSkillsFrame("Goalie")
    end
)
function updateSkillResults(a1)
    --[[
      name: updateSkillResults
      line: 946
      upvalues:
        SkillFrame_upv_1 (copy, index: 1)
    ]]
    for _, value_20 in pairs(SkillFrame_upv_1.SkillList:GetChildren()) do
        if not (value_20:IsA("TextButton")) then
            continue
        end
        if a1 == "" then
            value_20.Visible = true
            continue
        end
        if string.sub(string.lower(value_20.Text), 1, #a1) ~= string.sub(a1, 1, #a1) then
            value_20.Visible = false
        else
            value_20.Visible = true
        end
        if value_20.Visible ~= false then
            continue
        end
        if string.sub(string.lower(value_20.Type.Value), 1, #a1) == string.sub(a1, 1, #a1) then
            value_20.Visible = true
        end
    end
end
SkillFrame_upv_1.searchBar:GetPropertyChangedSignal("Text"):Connect(
    function()
        --[[
          line: 970
          upvalues:
            SkillFrame_upv_1 (copy, index: 1)
        ]]
        updateSkillResults(SkillFrame_upv_1.searchBar.Text)
    end
)
SkillFrame_upv_1.RightFrame.selectButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 974
          upvalues:
            SkillFrame_upv_1 (copy, index: 1)
            u10 (copy, index: 2)
        ]]
        local v92 = ""
        for _, value_21 in pairs(game.ReplicatedStorage.SkillInfo:GetChildren()) do
            if string.lower(value_21.Name) == string.lower(SkillFrame_upv_1.RightFrame.skillName.Text) then
                v92 = value_21.Name
            end
        end
        if SkillFrame_upv_1.RightFrame.skillName.Text == "GODSPEED" then
            v92 = "Godspeed"
        end
        if SkillFrame_upv_1.RightFrame.skillName.Text == "EXPLOSIVE RUSH" then
            v92 = "Explosive Rush"
        end
        local v93 = u10:InvokeServer(v92)
        local v94 = nil
        if v93 == "MissingLevel" then
            v94 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
            v94.Parent = game.Workspace
            v94:Play()
            game.Debris:AddItem(v94, 3)
        elseif v93 == "Success" then
            v94 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
            v94.Parent = game.Workspace
            v94:Play()
            game.Debris:AddItem(v94, 3)
            SkillFrame_upv_1.RightFrame.selectButton.Text = "SELECTED"
        elseif v93 == nil then
            local v95 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
            v95.Parent = game.Workspace
            v95:Play()
            game.Debris:AddItem(v95, 3)
        end
    end
)
MenuButtons_upv_1.SkillsButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 1007
          upvalues:
            SkillFrame_upv_1 (copy, index: 1)
            u18 (ref,  index: 2)
            StatsFrame_upv_1 (copy, index: 3)
        ]]
        if SkillFrame_upv_1.Visible ~= false then
            local TweenService_17 = game:GetService("TweenService")
            local v96 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_42 = {}
            tbl_42.Position = UDim2.new(0.5, 0, 1, 230)
            TweenService_17:Create(SkillFrame_upv_1, v96, tbl_42):Play()
            task.delay(
                0.35,
                function()
                    --[[
                      line: 1033
                      upvalues:
                        SkillFrame_upv_1 (copy, index: 1)
                    ]]
                    SkillFrame_upv_1.Visible = false
                end
            )
        else
            closeTeamSelect()
            closeModeSelect()
            script.Parent.SettingsFrame.Visible = false
            setupSkillsFrame(u18)
            local TweenService_18 = game:GetService("TweenService")
            local v97 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_43 = {}
            tbl_43.Position = UDim2.new(0.5, 0, 1, 170)
            TweenService_18:Create(StatsFrame_upv_1, v97, tbl_43):Play()
            task.delay(
                0.35,
                function()
                    --[[
                      line: 1016
                      upvalues:
                        StatsFrame_upv_1 (copy, index: 1)
                    ]]
                    StatsFrame_upv_1.Visible = false
                end
            )
            SkillFrame_upv_1.Visible = true
            local TweenService_19 = game:GetService("TweenService")
            local v98 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_44 = {}
            tbl_44.Position = UDim2.new(0.5, 0, 0.5, 0)
            TweenService_19:Create(SkillFrame_upv_1, v98, tbl_44):Play()
            local TweenService_20 = game:GetService("TweenService")
            local v99 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_45 = {}
            tbl_45.Position = UDim2.new(0.5, 0, 1.5, 0)
            TweenService_20:Create(script.Parent.ClubFrame, v99, tbl_45):Play()
            task.delay(
                0.35,
                function()
                    --[[
                      line: 1026
                    ]]
                    script.Parent.ClubFrame.Visible = false
                end
            )
        end
    end
)
MenuButtons_upv_1.StatsButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 1039
          upvalues:
            StatsFrame_upv_1 (copy, index: 1)
            SkillFrame_upv_1 (copy, index: 2)
        ]]
        if StatsFrame_upv_1.Visible ~= false then
            local TweenService_21 = game:GetService("TweenService")
            local v100 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_46 = {}
            tbl_46.Position = UDim2.new(0.5, 0, 1, 170)
            TweenService_21:Create(StatsFrame_upv_1, v100, tbl_46):Play()
            task.delay(
                0.35,
                function()
                    --[[
                      line: 1062
                      upvalues:
                        StatsFrame_upv_1 (copy, index: 1)
                    ]]
                    StatsFrame_upv_1.Visible = false
                end
            )
        else
            closeTeamSelect()
            closeModeSelect()
            script.Parent.SettingsFrame.Visible = false
            local TweenService_22 = game:GetService("TweenService")
            local v101 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_47 = {}
            tbl_47.Position = UDim2.new(0.5, 0, 1, 230)
            TweenService_22:Create(SkillFrame_upv_1, v101, tbl_47):Play()
            task.delay(
                0.35,
                function()
                    --[[
                      line: 1047
                      upvalues:
                        SkillFrame_upv_1 (copy, index: 1)
                    ]]
                    SkillFrame_upv_1.Visible = false
                end
            )
            task.spawn(
                function()
                    --[[
                      line: 1050
                      upvalues:
                        StatsFrame_upv_1 (copy, index: 1)
                    ]]
                    StatsFrame_upv_1.TitleFrame.MoneyValue.Text = getPlayerValue()
                end
            )
            StatsFrame_upv_1.Visible = true
            local TweenService_23 = game:GetService("TweenService")
            local v102 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_48 = {}
            tbl_48.Position = UDim2.new(0.5, 0, 0.5, 0)
            TweenService_23:Create(StatsFrame_upv_1, v102, tbl_48):Play()
        end
    end
)
SkillFrame_upv_1.TitleFrame.CancelButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 1068
          upvalues:
            SkillFrame_upv_1 (copy, index: 1)
        ]]
        local TweenService_24 = game:GetService("TweenService")
        local v103 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_49 = {}
        tbl_49.Position = UDim2.new(0.5, 0, 1, 230)
        TweenService_24:Create(SkillFrame_upv_1, v103, tbl_49):Play()
        task.delay(
            0.35,
            function()
                --[[
                  line: 1072
                  upvalues:
                    SkillFrame_upv_1 (copy, index: 1)
                ]]
                SkillFrame_upv_1.Visible = false
            end
        )
    end
)
StatsFrame_upv_1.TitleFrame.CancelButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 1077
          upvalues:
            StatsFrame_upv_1 (copy, index: 1)
        ]]
        local TweenService_25 = game:GetService("TweenService")
        local v104 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_50 = {}
        tbl_50.Position = UDim2.new(0.5, 0, 1, 170)
        TweenService_25:Create(StatsFrame_upv_1, v104, tbl_50):Play()
        task.delay(
            0.35,
            function()
                --[[
                  line: 1081
                  upvalues:
                    StatsFrame_upv_1 (copy, index: 1)
                ]]
                StatsFrame_upv_1.Visible = false
            end
        )
    end
)
local EquipFrame_upv_1 = CustomizationFrame_upv_1.EquipFrame
local ItemsFrame_upv_1 = CustomizationFrame_upv_1.ItemsFrame
local SelectFrame_upv_1 = CustomizationFrame_upv_1.SelectFrame
local tbl_upv_51 = {}
tbl_upv_51.Default = "http://www.roblox.com/asset/?id=8215214363"
tbl_upv_51.LongSleeve = "rbxassetid://16728126739"
tbl_upv_51.Tracksuit = "rbxassetid://16728138036"
tbl_upv_51.HandWrap = "rbxassetid://72720706206318"
tbl_upv_51.Undershirt = "rbxassetid://18565763187"
tbl_upv_51.None = "rbxassetid://18295163188"
tbl_upv_51.BlackGloves = "rbxassetid://18566362734"
tbl_upv_51.WhiteGloves = "rbxassetid://104532564191542"
tbl_upv_51.BlackFacemask = "rbxassetid://122170710702541"
tbl_upv_51.WhiteFacemask = "rbxassetid://96362968821852"
tbl_upv_51.BlackWristband = "rbxassetid://134371080571386"
tbl_upv_51.WhiteWristband = "rbxassetid://72720706206318"
local tbl_upv_52 = {}
tbl_upv_52.Default = "DEFAULT"
tbl_upv_52.LongSleeve = "LONG SLEEVE"
tbl_upv_52.Undershirt = "JERSEY W/ UNDERSHIRT"
tbl_upv_52.Tracksuit = "TRACKSUIT"
tbl_upv_52.None = "NONE"
tbl_upv_52.BlackGloves = "BLACK GLOVES"
tbl_upv_52.WhiteGloves = "WHITE GLOVES"
tbl_upv_52.BlackFacemask = "BLACK FACEMASK"
tbl_upv_52.WhiteFacemask = "WHITE FACEMASK"
tbl_upv_52.HandWrap = "HAND WRAP"
tbl_upv_52.BlackWristband = "BLACK WRISTBAND"
tbl_upv_52.WhiteWristband = "WHITE WRISTBAND"
local tbl_upv_53 = {}
tbl_upv_53.Common = Color3.new(1, 1, 1)
tbl_upv_53.Rare = Color3.new(0.262745, 0.462745, 0.792157)
tbl_upv_53.Epic = Color3.new(0.792157, 0, 0.862745)
tbl_upv_53.Legendary = Color3.new(1, 0, 0)
tbl_upv_53.Exclusive = Color3.new(1, 0.968627, 0)
function updateShirtType()
    --[[
      name: updateShirtType
      line: 1130
      upvalues:
        SelectFrame_upv_1 (copy, index: 1)
        tbl_upv_52 (copy, index: 2)
        LocalPlayer_upv_1 (copy, index: 3)
        tbl_upv_51 (copy, index: 4)
    ]]
    SelectFrame_upv_1.ShirtsButton.CurrentlyEquipped.Text = ((tbl_upv_52[LocalPlayer_upv_1.Data.shirtType.Value] ~= nil) and (tbl_upv_52[LocalPlayer_upv_1.Data.shirtType.Value])) or "DEFAULT"
    if tbl_upv_51[LocalPlayer_upv_1.Data.shirtType.Value] == nil then
        return
    end
    SelectFrame_upv_1.ShirtsButton.Icon.Image = ((tbl_upv_51[LocalPlayer_upv_1.Data.shirtType.Value] ~= nil) and (tbl_upv_51[LocalPlayer_upv_1.Data.shirtType.Value])) or "http://www.roblox.com/asset/?id=8215214363"
end
updateShirtType()
LocalPlayer_upv_1.Data.shirtType.Changed:Connect(updateShirtType)
function updateAnimationType()
    --[[
      name: updateAnimationType
      line: 1139
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        SelectFrame_upv_1 (copy, index: 2)
        tbl_upv_53 (copy, index: 3)
    ]]
    local v105 = game.ReplicatedStorage.ItemInfo:FindFirstChild(LocalPlayer_upv_1.Data.animationType.Value)
    if not v105 then
        return
    end
    SelectFrame_upv_1.AnimationsButton.CurrentlyEquipped.TextColor3 = tbl_upv_53[v105.Rarity.Value]
    SelectFrame_upv_1.AnimationsButton.CurrentlyEquipped.Text = string.upper(v105.Name)
    SelectFrame_upv_1.AnimationsButton.Icon.Image = v105.itemIcon.Texture
end
updateAnimationType()
LocalPlayer_upv_1.Data.animationType.Changed:Connect(updateAnimationType)
function updateGloveType()
    --[[
      name: updateGloveType
      line: 1150
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        SelectFrame_upv_1 (copy, index: 2)
        tbl_upv_53 (copy, index: 3)
    ]]
    local v106 = game.ReplicatedStorage.ItemInfo:FindFirstChild(LocalPlayer_upv_1.Data.GoalieGloves.Value)
    if not v106 then
        return
    end
    SelectFrame_upv_1.GoalieGlovesButton.CurrentlyEquipped.TextColor3 = tbl_upv_53[v106.Rarity.Value]
    SelectFrame_upv_1.GoalieGlovesButton.CurrentlyEquipped.Text = string.upper(v106.Name)
    SelectFrame_upv_1.GoalieGlovesButton.Icon.Image = v106.itemIcon.Texture
end
updateGloveType()
LocalPlayer_upv_1.Data.GoalieGloves.Changed:Connect(updateGloveType)
function updateAccessory()
    --[[
      name: updateAccessory
      line: 1161
      upvalues:
        SelectFrame_upv_1 (copy, index: 1)
        tbl_upv_52 (copy, index: 2)
        LocalPlayer_upv_1 (copy, index: 3)
        tbl_upv_51 (copy, index: 4)
    ]]
    SelectFrame_upv_1.AccessoriesButton.CurrentlyEquipped.Text = ((tbl_upv_52[LocalPlayer_upv_1.Data.Accessory.Value] ~= nil) and (tbl_upv_52[LocalPlayer_upv_1.Data.Accessory.Value])) or "NONE"
    if tbl_upv_51[LocalPlayer_upv_1.Data.Accessory.Value] == nil then
        return
    end
    SelectFrame_upv_1.AccessoriesButton.Icon.Image = ((tbl_upv_51[LocalPlayer_upv_1.Data.Accessory.Value] ~= nil) and (tbl_upv_51[LocalPlayer_upv_1.Data.Accessory.Value])) or "http://www.roblox.com/asset/?id=18295163188"
end
updateAccessory()
LocalPlayer_upv_1.Data.Accessory.Changed:Connect(updateAccessory)
function updateScoreAura()
    --[[
      name: updateScoreAura
      line: 1170
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        SelectFrame_upv_1 (copy, index: 2)
        tbl_upv_53 (copy, index: 3)
    ]]
    local v107 = game.ReplicatedStorage.ItemInfo:FindFirstChild(LocalPlayer_upv_1.Data.ScoreAura.Value)
    if not v107 then
        return
    end
    SelectFrame_upv_1.AuraButton.CurrentlyEquipped.TextColor3 = tbl_upv_53[v107.Rarity.Value]
    SelectFrame_upv_1.AuraButton.CurrentlyEquipped.Text = string.upper(v107.Name)
    SelectFrame_upv_1.AuraButton.Icon.Image = v107.itemIcon.Texture
end
updateScoreAura()
LocalPlayer_upv_1.Data.ScoreAura.Changed:Connect(updateScoreAura)
function updateMVPEyes()
    --[[
      name: updateMVPEyes
      line: 1181
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        SelectFrame_upv_1 (copy, index: 2)
        tbl_upv_53 (copy, index: 3)
    ]]
    local v108 = game.ReplicatedStorage.ItemInfo:FindFirstChild(LocalPlayer_upv_1.Data.MVPEyes.Value)
    if not v108 then
        return
    end
    SelectFrame_upv_1.EyesButton.CurrentlyEquipped.TextColor3 = tbl_upv_53[v108.Rarity.Value]
    SelectFrame_upv_1.EyesButton.CurrentlyEquipped.Text = string.upper(v108.Name)
    SelectFrame_upv_1.EyesButton.Icon.Image = v108.itemIcon.Texture
end
updateMVPEyes()
LocalPlayer_upv_1.Data.MVPEyes.Changed:Connect(updateMVPEyes)
function updateGoalCeleb()
    --[[
      name: updateGoalCeleb
      line: 1192
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        SelectFrame_upv_1 (copy, index: 2)
        tbl_upv_53 (copy, index: 3)
    ]]
    local v109 = game.ReplicatedStorage.ItemInfo:FindFirstChild(LocalPlayer_upv_1.Data.GoalCelebration.Value)
    if not v109 then
        return
    end
    SelectFrame_upv_1.GoalCelebButton.CurrentlyEquipped.TextColor3 = tbl_upv_53[v109.Rarity.Value]
    SelectFrame_upv_1.GoalCelebButton.CurrentlyEquipped.Text = string.upper(v109.Name)
    SelectFrame_upv_1.GoalCelebButton.Icon.Image = v109.itemIcon.Texture
end
updateGoalCeleb()
LocalPlayer_upv_1.Data.GoalCelebration.Changed:Connect(updateGoalCeleb)
function updateWinCeleb()
    --[[
      name: updateWinCeleb
      line: 1203
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        SelectFrame_upv_1 (copy, index: 2)
        tbl_upv_53 (copy, index: 3)
    ]]
    local v110 = game.ReplicatedStorage.ItemInfo:FindFirstChild(LocalPlayer_upv_1.Data.WinCelebration.Value)
    if not v110 then
        return
    end
    SelectFrame_upv_1.WinCelebButton.CurrentlyEquipped.TextColor3 = tbl_upv_53[v110.Rarity.Value]
    SelectFrame_upv_1.WinCelebButton.CurrentlyEquipped.Text = string.upper(v110.Name)
    SelectFrame_upv_1.WinCelebButton.Icon.Image = v110.itemIcon.Texture
end
updateWinCeleb()
LocalPlayer_upv_1.Data.WinCelebration.Changed:Connect(updateWinCeleb)
local ItemInfo_upv_1 = game.ReplicatedStorage.ItemInfo
function runCustomizationSetup()
    --[[
      name: runCustomizationSetup
      line: 1216
      upvalues:
        ItemsFrame_upv_1 (copy, index: 1)
        LocalPlayer_upv_1 (copy, index: 2)
        ItemInfo_upv_1 (copy, index: 3)
        tbl_upv_53 (copy, index: 4)
    ]]
    for _, value_22 in pairs(ItemsFrame_upv_1.AurasFrame:GetChildren()) do
        if value_22:IsA("ImageButton") then
            value_22:Destroy()
        end
    end
    for _, value_23 in pairs(ItemsFrame_upv_1.AnimationFrame:GetChildren()) do
        if value_23:IsA("ImageButton") then
            value_23:Destroy()
        end
    end
    for _, value_24 in pairs(ItemsFrame_upv_1.GoalieGlovesFrame:GetChildren()) do
        if value_24:IsA("ImageButton") then
            value_24:Destroy()
        end
    end
    for _, value_25 in pairs(ItemsFrame_upv_1.EyesFrame:GetChildren()) do
        if value_25:IsA("ImageButton") then
            value_25:Destroy()
        end
    end
    for _, value_26 in pairs(ItemsFrame_upv_1.GoalCelebFrame:GetChildren()) do
        if value_26:IsA("ImageButton") then
            value_26:Destroy()
        end
    end
    for _, value_27 in pairs(ItemsFrame_upv_1.WinCelebFrame:GetChildren()) do
        if value_27:IsA("ImageButton") then
            value_27:Destroy()
        end
    end
    local v111 = string.split(LocalPlayer_upv_1.Data.Inventory.Value)
    for _, value_28 in pairs(ItemsFrame_upv_1:GetDescendants()) do
        if not (value_28:IsA("ImageButton")) then
            continue
        end
        if table.find(v111, value_28.Name) then
            if not (value_28:FindFirstChild("Locked")) then
                continue
            end
            value_28.Locked.Visible = false
            value_28.LockedBG.Visible = false
            if value_28:FindFirstChild("Price") then
                value_28.Price.Visible = false
            end
        else
            value_28.Locked.Visible = true
            value_28.LockedBG.Visible = true
            if value_28:FindFirstChild("Price") then
                value_28.Price.Visible = true
            end
        end
    end
    for _, value_29 in pairs(v111) do
        local v112 = ItemInfo_upv_1:FindFirstChild(value_29)
        if not (v112) then
            continue
        end
        local u29 = script.itemTemplate:Clone()
        u29.Name = v112.Name
        u29.itemName.Text = string.upper(v112.Name)
        u29.itemName.TextColor3 = tbl_upv_53[v112.Rarity.Value]
        u29.Icon.Image = v112.itemIcon.Texture
        if v112.Type.Value == "Aura" then
            u29.Parent = ItemsFrame_upv_1.AurasFrame
            u29.MouseButton1Click:Connect(
                function()
                    --[[
                      line: 1309
                      upvalues:
                        u29 (copy, index: 1)
                    ]]
                    doSelection(u29)
                end
            )
            continue
        end
        if v112.Type.Value == "AnimationPack" then
            u29.Parent = ItemsFrame_upv_1.AnimationFrame
            u29.MouseButton1Click:Connect(
                function()
                    --[[
                      line: 1309
                      upvalues:
                        u29 (copy, index: 1)
                    ]]
                    doSelection(u29)
                end
            )
            continue
        end
        if v112.Type.Value == "Eyes" then
            u29.Parent = ItemsFrame_upv_1.EyesFrame
            u29.MouseButton1Click:Connect(
                function()
                    --[[
                      line: 1309
                      upvalues:
                        u29 (copy, index: 1)
                    ]]
                    doSelection(u29)
                end
            )
            continue
        end
        if v112.Type.Value == "Glove" then
            u29.Parent = ItemsFrame_upv_1.GoalieGlovesFrame
            u29.MouseButton1Click:Connect(
                function()
                    --[[
                      line: 1309
                      upvalues:
                        u29 (copy, index: 1)
                    ]]
                    doSelection(u29)
                end
            )
            continue
        end
        if v112.Type.Value ~= "GoalCeleb" then
            if v112.Type.Value ~= "WinCeleb" then
                u29.MouseButton1Click:Connect(
                    function()
                        --[[
                          line: 1309
                          upvalues:
                            u29 (copy, index: 1)
                        ]]
                        doSelection(u29)
                    end
                )
                continue
            end
            u29.Parent = ItemsFrame_upv_1.WinCelebFrame
            if v112:FindFirstChild("AlsoGoalCeleb") then
                local u30 = script.itemTemplate:Clone()
                u30.Name = v112.Name
                u30.itemName.Text = string.upper(v112.Name)
                u30.itemName.TextColor3 = tbl_upv_53[v112.Rarity.Value]
                u30.Icon.Image = v112.itemIcon.Texture
                u30.Parent = ItemsFrame_upv_1.GoalCelebFrame
                u30.MouseButton1Click:Connect(
                    function()
                        --[[
                          line: 1304
                          upvalues:
                            u30 (copy, index: 1)
                        ]]
                        doSelection(u30)
                    end
                )
            end
        else
            u29.Parent = ItemsFrame_upv_1.GoalCelebFrame
            if v112:FindFirstChild("AlsoWinCeleb") then
                local u31 = script.itemTemplate:Clone()
                u31.Name = v112.Name
                u31.itemName.Text = string.upper(v112.Name)
                u31.itemName.TextColor3 = tbl_upv_53[v112.Rarity.Value]
                u31.Icon.Image = v112.itemIcon.Texture
                u31.Parent = ItemsFrame_upv_1.WinCelebFrame
                u31.MouseButton1Click:Connect(
                    function()
                        --[[
                          line: 1291
                          upvalues:
                            u31 (copy, index: 1)
                        ]]
                        doSelection(u31)
                    end
                )
            end
        end
        u29.MouseButton1Click:Connect(
            function()
                --[[
                  line: 1309
                  upvalues:
                    u29 (copy, index: 1)
                ]]
                doSelection(u29)
            end
        )
    end
end
runCustomizationSetup()
MenuButtons_upv_1.CustomizeButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 1318
          upvalues:
            ColorSelector_upv_1 (copy, index: 1)
            CustomizationFrame_upv_1 (copy, index: 2)
            MenuButtons_upv_1 (copy, index: 3)
            PlayButton_upv_1 (copy, index: 4)
        ]]
        ColorSelector_upv_1.Visible = false
        CustomizationFrame_upv_1:SetAttribute("vis", true)
        runCustomizationSetup()
        local TweenService_26 = game:GetService("TweenService")
        local v113 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_54 = {}
        tbl_54.Position = UDim2.new(0, 0, 0.5, 0)
        TweenService_26:Create(CustomizationFrame_upv_1.ItemsFrame, v113, tbl_54):Play()
        local TweenService_27 = game:GetService("TweenService")
        local v114 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_55 = {}
        tbl_55.Position = UDim2.new(1, 0, 1, 0)
        TweenService_27:Create(CustomizationFrame_upv_1.SelectFrame, v114, tbl_55):Play()
        local TweenService_28 = game:GetService("TweenService")
        local v115 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_56 = {}
        tbl_56.Position = UDim2.new(0.5, 0, 0.95, 0)
        TweenService_28:Create(CustomizationFrame_upv_1.CancelButton, v115, tbl_56):Play()
        local TweenService_29 = game:GetService("TweenService")
        local v116 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_57 = {}
        tbl_57.Position = UDim2.new(0.5, 0, 1.5, 0)
        TweenService_29:Create(script.Parent.ClubFrame, v116, tbl_57):Play()
        task.delay(
            0.35,
            function()
                --[[
                  line: 1334
                ]]
                script.Parent.ClubFrame.Visible = false
            end
        )
        MenuButtons_upv_1.Visible = false
        PlayButton_upv_1.Visible = false
    end
)
CustomizationFrame_upv_1.CancelButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 1341
          upvalues:
            CustomizationFrame_upv_1 (copy, index: 1)
            ColorSelector_upv_1 (copy, index: 2)
            EquipFrame_upv_1 (copy, index: 3)
            MenuButtons_upv_1 (copy, index: 4)
            PlayButton_upv_1 (copy, index: 5)
        ]]
        CustomizationFrame_upv_1:SetAttribute("vis", false)
        ColorSelector_upv_1.Visible = false
        local TweenService_30 = game:GetService("TweenService")
        local v117 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_58 = {}
        tbl_58.Position = UDim2.new(0, -350, 0.5, 0)
        TweenService_30:Create(CustomizationFrame_upv_1.ItemsFrame, v117, tbl_58):Play()
        local TweenService_31 = game:GetService("TweenService")
        local v118 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_59 = {}
        tbl_59.Position = UDim2.new(1, 800, 1, 0)
        TweenService_31:Create(CustomizationFrame_upv_1.SelectFrame, v118, tbl_59):Play()
        local TweenService_32 = game:GetService("TweenService")
        local v119 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_60 = {}
        tbl_60.Position = UDim2.new(0.5, 0, 0.95, 200)
        TweenService_32:Create(CustomizationFrame_upv_1.CancelButton, v119, tbl_60):Play()
        local TweenService_33 = game:GetService("TweenService")
        local v120 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_61 = {}
        tbl_61.Position = UDim2.new(0.5, 0, 1, 150)
        TweenService_33:Create(EquipFrame_upv_1, v120, tbl_61):Play()
        MenuButtons_upv_1.Visible = true
        PlayButton_upv_1.Visible = true
    end
)
local ShirtsFrame_upv_1 = ItemsFrame_upv_1.ShirtsFrame
local AccessoriesFrame_upv_1 = ItemsFrame_upv_1.AccessoriesFrame
local u32 = nil
local u33 = "shirtType"
SelectFrame_upv_1.AnimationsButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 1367
          upvalues:
            EquipFrame_upv_1 (copy, index: 1)
            u32 (ref,  index: 2)
            u33 (ref,  index: 3)
            ItemsFrame_upv_1 (copy, index: 4)
            ColorSelector_upv_1 (copy, index: 5)
            SelectFrame_upv_1 (copy, index: 6)
        ]]
        local TweenService_34 = game:GetService("TweenService")
        local v121 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_62 = {}
        tbl_62.Position = UDim2.new(0.5, 0, 1, 150)
        TweenService_34:Create(EquipFrame_upv_1, v121, tbl_62):Play()
        u32 = nil
        u33 = "animationType"
        ItemsFrame_upv_1.AnimationFrame.Visible = true
        ColorSelector_upv_1.Visible = false
        local TweenService_35 = game:GetService("TweenService")
        local v122 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_63 = {Thickness = 4, Transparency = 0}
        tbl_63.Color = Color3.new(1, 1, 1)
        TweenService_35:Create(SelectFrame_upv_1.AnimationsButton.UIStroke, v122, tbl_63):Play()
        local TweenService_36 = game:GetService("TweenService")
        local v123 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_64 = {}
        tbl_64.Size = UDim2.new(0, 105, 0, 90)
        TweenService_36:Create(SelectFrame_upv_1.AnimationsButton.Icon, v123, tbl_64):Play()
        for _, value_30 in pairs(ItemsFrame_upv_1:GetChildren()) do
            if (value_30:IsA("Frame") or value_30:IsA("ScrollingFrame")) and value_30 ~= ItemsFrame_upv_1.AnimationFrame then
                value_30.Visible = false
            end
        end
        for _, value_31 in pairs(SelectFrame_upv_1:GetChildren()) do
            if not (value_31:IsA("ImageButton")) then
                continue
            end
            if value_31 ~= SelectFrame_upv_1.AnimationsButton then
                local TweenService_37 = game:GetService("TweenService")
                local v124 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_65 = {Thickness = 2, Transparency = 0.25}
                tbl_65.Color = Color3.new(0.498039, 0.529412, 0.560784)
                TweenService_37:Create(value_31.UIStroke, v124, tbl_65):Play()
                local TweenService_38 = game:GetService("TweenService")
                local v125 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_66 = {}
                tbl_66.Size = UDim2.new(0, 97, 0, 85)
                TweenService_38:Create(value_31.Icon, v125, tbl_66):Play()
            end
        end
    end
)
SelectFrame_upv_1.GoalieGlovesButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 1402
          upvalues:
            EquipFrame_upv_1 (copy, index: 1)
            u32 (ref,  index: 2)
            u33 (ref,  index: 3)
            ItemsFrame_upv_1 (copy, index: 4)
            ColorSelector_upv_1 (copy, index: 5)
            SelectFrame_upv_1 (copy, index: 6)
        ]]
        local TweenService_39 = game:GetService("TweenService")
        local v126 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_67 = {}
        tbl_67.Position = UDim2.new(0.5, 0, 1, 150)
        TweenService_39:Create(EquipFrame_upv_1, v126, tbl_67):Play()
        u32 = nil
        u33 = "GoalieGloves"
        ItemsFrame_upv_1.GoalieGlovesFrame.Visible = true
        ColorSelector_upv_1.Visible = false
        local TweenService_40 = game:GetService("TweenService")
        local v127 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_68 = {Thickness = 4, Transparency = 0}
        tbl_68.Color = Color3.new(1, 1, 1)
        TweenService_40:Create(SelectFrame_upv_1.GoalieGlovesButton.UIStroke, v127, tbl_68):Play()
        local TweenService_41 = game:GetService("TweenService")
        local v128 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_69 = {}
        tbl_69.Size = UDim2.new(0, 105, 0, 90)
        TweenService_41:Create(SelectFrame_upv_1.GoalieGlovesButton.Icon, v128, tbl_69):Play()
        for _, value_32 in pairs(ItemsFrame_upv_1:GetChildren()) do
            if (value_32:IsA("Frame") or value_32:IsA("ScrollingFrame")) and value_32 ~= ItemsFrame_upv_1.GoalieGlovesFrame then
                value_32.Visible = false
            end
        end
        for _, value_33 in pairs(SelectFrame_upv_1:GetChildren()) do
            if not (value_33:IsA("ImageButton")) then
                continue
            end
            if value_33 ~= SelectFrame_upv_1.GoalieGlovesButton then
                local TweenService_42 = game:GetService("TweenService")
                local v129 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_70 = {Thickness = 2, Transparency = 0.25}
                tbl_70.Color = Color3.new(0.498039, 0.529412, 0.560784)
                TweenService_42:Create(value_33.UIStroke, v129, tbl_70):Play()
                local TweenService_43 = game:GetService("TweenService")
                local v130 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_71 = {}
                tbl_71.Size = UDim2.new(0, 97, 0, 85)
                TweenService_43:Create(value_33.Icon, v130, tbl_71):Play()
            end
        end
    end
)
SelectFrame_upv_1.ShirtsButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 1437
          upvalues:
            EquipFrame_upv_1 (copy, index: 1)
            u32 (ref,  index: 2)
            u33 (ref,  index: 3)
            ItemsFrame_upv_1 (copy, index: 4)
            ColorSelector_upv_1 (copy, index: 5)
            SelectFrame_upv_1 (copy, index: 6)
        ]]
        local TweenService_44 = game:GetService("TweenService")
        local v131 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_72 = {}
        tbl_72.Position = UDim2.new(0.5, 0, 1, 150)
        TweenService_44:Create(EquipFrame_upv_1, v131, tbl_72):Play()
        u32 = nil
        u33 = "shirtType"
        ItemsFrame_upv_1.ShirtsFrame.Visible = true
        ColorSelector_upv_1.Visible = false
        local TweenService_45 = game:GetService("TweenService")
        local v132 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_73 = {Thickness = 4, Transparency = 0}
        tbl_73.Color = Color3.new(1, 1, 1)
        TweenService_45:Create(SelectFrame_upv_1.ShirtsButton.UIStroke, v132, tbl_73):Play()
        local TweenService_46 = game:GetService("TweenService")
        local v133 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_74 = {}
        tbl_74.Size = UDim2.new(0, 105, 0, 90)
        TweenService_46:Create(SelectFrame_upv_1.ShirtsButton.Icon, v133, tbl_74):Play()
        for _, value_34 in pairs(ItemsFrame_upv_1:GetChildren()) do
            if (value_34:IsA("Frame") or value_34:IsA("ScrollingFrame")) and value_34 ~= ItemsFrame_upv_1.ShirtsFrame then
                value_34.Visible = false
            end
        end
        for _, value_35 in pairs(SelectFrame_upv_1:GetChildren()) do
            if not (value_35:IsA("ImageButton")) then
                continue
            end
            if value_35 ~= SelectFrame_upv_1.ShirtsButton then
                local TweenService_47 = game:GetService("TweenService")
                local v134 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_75 = {Thickness = 2, Transparency = 0.25}
                tbl_75.Color = Color3.new(0.498039, 0.529412, 0.560784)
                TweenService_47:Create(value_35.UIStroke, v134, tbl_75):Play()
                local TweenService_48 = game:GetService("TweenService")
                local v135 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_76 = {}
                tbl_76.Size = UDim2.new(0, 97, 0, 85)
                TweenService_48:Create(value_35.Icon, v135, tbl_76):Play()
            end
        end
    end
)
SelectFrame_upv_1.AccessoriesButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 1473
          upvalues:
            ColorSelector_upv_1 (copy, index: 1)
            LocalPlayer_upv_1 (copy, index: 2)
            EquipFrame_upv_1 (copy, index: 3)
            u32 (ref,  index: 4)
            u33 (ref,  index: 5)
            ItemsFrame_upv_1 (copy, index: 6)
            SelectFrame_upv_1 (copy, index: 7)
        ]]
        ColorSelector_upv_1.Color.BackgroundColor3 = LocalPlayer_upv_1.Data.AccessoryColor.Value
        ColorSelector_upv_1.Visible = true
        local TweenService_49 = game:GetService("TweenService")
        local v136 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_77 = {}
        tbl_77.Position = UDim2.new(0.5, 0, 1, 150)
        TweenService_49:Create(EquipFrame_upv_1, v136, tbl_77):Play()
        u32 = nil
        u33 = "Accessory"
        ItemsFrame_upv_1.AccessoriesFrame.Visible = true
        local TweenService_50 = game:GetService("TweenService")
        local v137 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_78 = {Thickness = 4, Transparency = 0}
        tbl_78.Color = Color3.new(1, 1, 1)
        TweenService_50:Create(SelectFrame_upv_1.AccessoriesButton.UIStroke, v137, tbl_78):Play()
        local TweenService_51 = game:GetService("TweenService")
        local v138 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_79 = {}
        tbl_79.Size = UDim2.new(0, 105, 0, 90)
        TweenService_51:Create(SelectFrame_upv_1.AccessoriesButton.Icon, v138, tbl_79):Play()
        for _, value_36 in pairs(ItemsFrame_upv_1:GetChildren()) do
            if (value_36:IsA("Frame") or value_36:IsA("ScrollingFrame")) and value_36 ~= ItemsFrame_upv_1.AccessoriesFrame then
                value_36.Visible = false
            end
        end
        for _, value_37 in pairs(SelectFrame_upv_1:GetChildren()) do
            if not (value_37:IsA("ImageButton")) then
                continue
            end
            if value_37 ~= SelectFrame_upv_1.AccessoriesButton then
                local TweenService_52 = game:GetService("TweenService")
                local v139 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_80 = {Thickness = 2, Transparency = 0.25}
                tbl_80.Color = Color3.new(0.498039, 0.529412, 0.560784)
                TweenService_52:Create(value_37.UIStroke, v139, tbl_80):Play()
                local TweenService_53 = game:GetService("TweenService")
                local v140 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_81 = {}
                tbl_81.Size = UDim2.new(0, 97, 0, 85)
                TweenService_53:Create(value_37.Icon, v140, tbl_81):Play()
            end
        end
    end
)
SelectFrame_upv_1.AuraButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 1511
          upvalues:
            ColorSelector_upv_1 (copy, index: 1)
            EquipFrame_upv_1 (copy, index: 2)
            u32 (ref,  index: 3)
            u33 (ref,  index: 4)
            ItemsFrame_upv_1 (copy, index: 5)
            SelectFrame_upv_1 (copy, index: 6)
        ]]
        ColorSelector_upv_1.Visible = false
        local TweenService_54 = game:GetService("TweenService")
        local v141 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_82 = {}
        tbl_82.Position = UDim2.new(0.5, 0, 1, 150)
        TweenService_54:Create(EquipFrame_upv_1, v141, tbl_82):Play()
        u32 = nil
        u33 = "ScoreAura"
        ItemsFrame_upv_1.AurasFrame.Visible = true
        local TweenService_55 = game:GetService("TweenService")
        local v142 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_83 = {Thickness = 4, Transparency = 0}
        tbl_83.Color = Color3.new(1, 1, 1)
        TweenService_55:Create(SelectFrame_upv_1.AuraButton.UIStroke, v142, tbl_83):Play()
        local TweenService_56 = game:GetService("TweenService")
        local v143 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_84 = {}
        tbl_84.Size = UDim2.new(0, 105, 0, 90)
        TweenService_56:Create(SelectFrame_upv_1.AuraButton.Icon, v143, tbl_84):Play()
        for _, value_38 in pairs(ItemsFrame_upv_1:GetChildren()) do
            if (value_38:IsA("Frame") or value_38:IsA("ScrollingFrame")) and value_38 ~= ItemsFrame_upv_1.AurasFrame then
                value_38.Visible = false
            end
        end
        for _, value_39 in pairs(SelectFrame_upv_1:GetChildren()) do
            if not (value_39:IsA("ImageButton")) then
                continue
            end
            if value_39 ~= SelectFrame_upv_1.AuraButton then
                local TweenService_57 = game:GetService("TweenService")
                local v144 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_85 = {Thickness = 2, Transparency = 0.25}
                tbl_85.Color = Color3.new(0.498039, 0.529412, 0.560784)
                TweenService_57:Create(value_39.UIStroke, v144, tbl_85):Play()
                local TweenService_58 = game:GetService("TweenService")
                local v145 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_86 = {}
                tbl_86.Size = UDim2.new(0, 97, 0, 85)
                TweenService_58:Create(value_39.Icon, v145, tbl_86):Play()
            end
        end
    end
)
SelectFrame_upv_1.EyesButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 1546
          upvalues:
            ColorSelector_upv_1 (copy, index: 1)
            EquipFrame_upv_1 (copy, index: 2)
            u32 (ref,  index: 3)
            u33 (ref,  index: 4)
            ItemsFrame_upv_1 (copy, index: 5)
            SelectFrame_upv_1 (copy, index: 6)
        ]]
        ColorSelector_upv_1.Visible = false
        local TweenService_59 = game:GetService("TweenService")
        local v146 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_87 = {}
        tbl_87.Position = UDim2.new(0.5, 0, 1, 150)
        TweenService_59:Create(EquipFrame_upv_1, v146, tbl_87):Play()
        u32 = nil
        u33 = "MVPEyes"
        ItemsFrame_upv_1.EyesFrame.Visible = true
        local TweenService_60 = game:GetService("TweenService")
        local v147 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_88 = {Thickness = 4, Transparency = 0}
        tbl_88.Color = Color3.new(1, 1, 1)
        TweenService_60:Create(SelectFrame_upv_1.EyesButton.UIStroke, v147, tbl_88):Play()
        local TweenService_61 = game:GetService("TweenService")
        local v148 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_89 = {}
        tbl_89.Size = UDim2.new(0, 105, 0, 90)
        TweenService_61:Create(SelectFrame_upv_1.EyesButton.Icon, v148, tbl_89):Play()
        for _, value_40 in pairs(ItemsFrame_upv_1:GetChildren()) do
            if (value_40:IsA("Frame") or value_40:IsA("ScrollingFrame")) and value_40 ~= ItemsFrame_upv_1.EyesFrame then
                value_40.Visible = false
            end
        end
        for _, value_41 in pairs(SelectFrame_upv_1:GetChildren()) do
            if not (value_41:IsA("ImageButton")) then
                continue
            end
            if value_41 ~= SelectFrame_upv_1.EyesButton then
                local TweenService_62 = game:GetService("TweenService")
                local v149 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_90 = {Thickness = 2, Transparency = 0.25}
                tbl_90.Color = Color3.new(0.498039, 0.529412, 0.560784)
                TweenService_62:Create(value_41.UIStroke, v149, tbl_90):Play()
                local TweenService_63 = game:GetService("TweenService")
                local v150 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_91 = {}
                tbl_91.Size = UDim2.new(0, 97, 0, 85)
                TweenService_63:Create(value_41.Icon, v150, tbl_91):Play()
            end
        end
    end
)
SelectFrame_upv_1.GoalCelebButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 1581
          upvalues:
            ColorSelector_upv_1 (copy, index: 1)
            EquipFrame_upv_1 (copy, index: 2)
            u32 (ref,  index: 3)
            u33 (ref,  index: 4)
            ItemsFrame_upv_1 (copy, index: 5)
            SelectFrame_upv_1 (copy, index: 6)
        ]]
        ColorSelector_upv_1.Visible = false
        local TweenService_64 = game:GetService("TweenService")
        local v151 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_92 = {}
        tbl_92.Position = UDim2.new(0.5, 0, 1, 150)
        TweenService_64:Create(EquipFrame_upv_1, v151, tbl_92):Play()
        u32 = nil
        u33 = "GoalCelebration"
        ItemsFrame_upv_1.GoalCelebFrame.Visible = true
        local TweenService_65 = game:GetService("TweenService")
        local v152 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_93 = {Thickness = 4, Transparency = 0}
        tbl_93.Color = Color3.new(1, 1, 1)
        TweenService_65:Create(SelectFrame_upv_1.GoalCelebButton.UIStroke, v152, tbl_93):Play()
        local TweenService_66 = game:GetService("TweenService")
        local v153 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_94 = {}
        tbl_94.Size = UDim2.new(0, 105, 0, 90)
        TweenService_66:Create(SelectFrame_upv_1.GoalCelebButton.Icon, v153, tbl_94):Play()
        for _, value_42 in pairs(ItemsFrame_upv_1:GetChildren()) do
            if (value_42:IsA("Frame") or value_42:IsA("ScrollingFrame")) and value_42 ~= ItemsFrame_upv_1.GoalCelebFrame then
                value_42.Visible = false
            end
        end
        for _, value_43 in pairs(SelectFrame_upv_1:GetChildren()) do
            if not (value_43:IsA("ImageButton")) then
                continue
            end
            if value_43 ~= SelectFrame_upv_1.GoalCelebButton then
                local TweenService_67 = game:GetService("TweenService")
                local v154 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_95 = {Thickness = 2, Transparency = 0.25}
                tbl_95.Color = Color3.new(0.498039, 0.529412, 0.560784)
                TweenService_67:Create(value_43.UIStroke, v154, tbl_95):Play()
                local TweenService_68 = game:GetService("TweenService")
                local v155 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_96 = {}
                tbl_96.Size = UDim2.new(0, 97, 0, 85)
                TweenService_68:Create(value_43.Icon, v155, tbl_96):Play()
            end
        end
    end
)
SelectFrame_upv_1.WinCelebButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 1616
          upvalues:
            ColorSelector_upv_1 (copy, index: 1)
            EquipFrame_upv_1 (copy, index: 2)
            u32 (ref,  index: 3)
            u33 (ref,  index: 4)
            ItemsFrame_upv_1 (copy, index: 5)
            SelectFrame_upv_1 (copy, index: 6)
        ]]
        ColorSelector_upv_1.Visible = false
        local TweenService_69 = game:GetService("TweenService")
        local v156 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_97 = {}
        tbl_97.Position = UDim2.new(0.5, 0, 1, 150)
        TweenService_69:Create(EquipFrame_upv_1, v156, tbl_97):Play()
        u32 = nil
        u33 = "WinCelebration"
        ItemsFrame_upv_1.WinCelebFrame.Visible = true
        local TweenService_70 = game:GetService("TweenService")
        local v157 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_98 = {Thickness = 4, Transparency = 0}
        tbl_98.Color = Color3.new(1, 1, 1)
        TweenService_70:Create(SelectFrame_upv_1.WinCelebButton.UIStroke, v157, tbl_98):Play()
        local TweenService_71 = game:GetService("TweenService")
        local v158 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_99 = {}
        tbl_99.Size = UDim2.new(0, 105, 0, 90)
        TweenService_71:Create(SelectFrame_upv_1.WinCelebButton.Icon, v158, tbl_99):Play()
        for _, value_44 in pairs(ItemsFrame_upv_1:GetChildren()) do
            if (value_44:IsA("Frame") or value_44:IsA("ScrollingFrame")) and value_44 ~= ItemsFrame_upv_1.WinCelebFrame then
                value_44.Visible = false
            end
        end
        for _, value_45 in pairs(SelectFrame_upv_1:GetChildren()) do
            if not (value_45:IsA("ImageButton")) then
                continue
            end
            if value_45 ~= SelectFrame_upv_1.WinCelebButton then
                local TweenService_72 = game:GetService("TweenService")
                local v159 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_100 = {Thickness = 2, Transparency = 0.25}
                tbl_100.Color = Color3.new(0.498039, 0.529412, 0.560784)
                TweenService_72:Create(value_45.UIStroke, v159, tbl_100):Play()
                local TweenService_73 = game:GetService("TweenService")
                local v160 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_101 = {}
                tbl_101.Size = UDim2.new(0, 97, 0, 85)
                TweenService_73:Create(value_45.Icon, v160, tbl_101):Play()
            end
        end
    end
)
EquipFrame_upv_1.EquipButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 1652
          upvalues:
            u32 (ref,  index: 1)
            u4 (copy, index: 2)
            u33 (ref,  index: 3)
            EquipFrame_upv_1 (copy, index: 4)
        ]]
        if u32 ~= nil then
            u4:FireServer(u33, u32)
            local v161 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
            v161.Parent = game.Workspace
            v161:Play()
            game.Debris:AddItem(v161, 2)
            EquipFrame_upv_1.EquipButton.Text = "EQUIPPED"
        end
    end
)
function showConfirmation(a1)
    --[[
      name: showConfirmation
      line: 1665
      upvalues:
        CustomizationFrame_upv_1 (copy, index: 1)
        u11 (copy, index: 2)
    ]]
    CustomizationFrame_upv_1.PopupContainer.Visible = true
    CustomizationFrame_upv_1.PopupContainer.PurchaseText.Text = "WOULD YOU LIKE TO PURCHASE <" .. a1.Type.Text .. "> for " .. a1.Price.Text .. "?"
    local u34 = nil
    local u35 = nil
    local v162 = CustomizationFrame_upv_1.PopupContainer.YesButton.MouseButton1Click:Connect(
        function()
            --[[
              line: 1669
              upvalues:
                u11 (copy, index: 1)
                a1 (copy, index: 2)
                u35 (ref,  index: 3)
                CustomizationFrame_upv_1 (copy, index: 4)
            ]]
            if u11:InvokeServer(a1.Name) ~= nil then
                if a1:FindFirstChild("Locked") then
                    a1.Locked.Visible = false
                    a1.LockedBG.Visible = false
                    if a1:FindFirstChild("Price") then
                        a1.Price.Visible = false
                    end
                    local v163 = game.ReplicatedStorage.UISounds.Item_Box_Get2:Clone()
                    v163.Parent = game.Workspace
                    v163:Play()
                    game.Debris:AddItem(v163, 2)
                end
                u35:Disconnect()
                CustomizationFrame_upv_1.PopupContainer.Visible = false
            else
                local v164 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
                v164.Parent = game.Workspace
                v164:Play()
                game.Debris:AddItem(v164, 3)
                task.spawn(
                    function()
                        --[[
                          line: 1676
                          upvalues:
                            a1 (copy, index: 1)
                        ]]
                        local tbl_102 = {Rotation = 45}
                        game:GetService("TweenService"):Create(a1.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_102):Play()
                        task.wait(0.1)
                        local tbl_103 = {Rotation = -45}
                        game:GetService("TweenService"):Create(a1.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_103):Play()
                        task.wait(0.1)
                        local tbl_104 = {Rotation = 0}
                        game:GetService("TweenService"):Create(a1.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_104):Play()
                    end
                )
            end
        end
    )
    u35 = v162
    local v165 = CustomizationFrame_upv_1.PopupContainer.NoButton.MouseButton1Click:Connect(
        function()
            --[[
              line: 1704
              upvalues:
                u35 (ref,  index: 1)
                u34 (ref,  index: 2)
                CustomizationFrame_upv_1 (copy, index: 3)
            ]]
            u35:Disconnect()
            u34:Disconnect()
            CustomizationFrame_upv_1.PopupContainer.Visible = false
        end
    )
    u34 = v165
end
function doSelection(a1)
    --[[
      name: doSelection
      line: 1711
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        EquipFrame_upv_1 (copy, index: 2)
        u32 (ref,  index: 3)
    ]]
    if not (table.find(string.split(LocalPlayer_upv_1.Data.Inventory.Value), a1.Name)) and a1:FindFirstChild("Price") then
        local TweenService_74 = game:GetService("TweenService")
        local v166 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_105 = {}
        tbl_105.Position = UDim2.new(0.5, 0, 1, 150)
        TweenService_74:Create(EquipFrame_upv_1, v166, tbl_105):Play()
        showConfirmation(a1)
        return
    end
    if u32 ~= a1.Name then
        for _, value_46 in pairs(a1.Parent:GetChildren()) do
            if value_46 == a1 then
                continue
            end
            if value_46:IsA("ImageButton") then
                local TweenService_75 = game:GetService("TweenService")
                local v167 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_106 = {Transparency = 0.25, Thickness = 2}
                tbl_106.Color = Color3.new(0.498039, 0.529412, 0.560784)
                TweenService_75:Create(value_46.UIStroke, v167, tbl_106):Play()
            end
        end
        u32 = a1.Name
        local TweenService_76 = game:GetService("TweenService")
        local v168 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_107 = {}
        tbl_107.Position = UDim2.new(0.5, 0, 1, -125)
        TweenService_76:Create(EquipFrame_upv_1, v168, tbl_107):Play()
        TweenService_76 = game:GetService("TweenService")
        local v169 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_108 = {Transparency = 0, Thickness = 3}
        tbl_108.Color = Color3.new(1, 1, 1)
        TweenService_76:Create(a1.UIStroke, v169, tbl_108):Play()
        EquipFrame_upv_1.EquipButton.Text = "EQUIP"
        for _, value_47 in pairs(LocalPlayer_upv_1.Data:GetChildren()) do
            if not (value_47:IsA("StringValue")) or value_47.Value ~= a1.Name then
                continue
            end
            EquipFrame_upv_1.EquipButton.Text = "EQUIPPED"
            return
        end
    else
        u32 = nil
        local TweenService_77 = game:GetService("TweenService")
        local v170 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_109 = {}
        tbl_109.Position = UDim2.new(0.5, 0, 1, 150)
        TweenService_77:Create(EquipFrame_upv_1, v170, tbl_109):Play()
        local TweenService_78 = game:GetService("TweenService")
        local v171 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_110 = {Transparency = 0.25, Thickness = 2}
        tbl_110.Color = Color3.new(0.498039, 0.529412, 0.560784)
        TweenService_78:Create(a1.UIStroke, v171, tbl_110):Play()
    end
end
ShirtsFrame_upv_1.Default.MouseButton1Click:Connect(
    function()
        --[[
          line: 1759
          upvalues:
            ShirtsFrame_upv_1 (copy, index: 1)
        ]]
        doSelection(ShirtsFrame_upv_1.Default)
    end
)
ShirtsFrame_upv_1.LongSleeve.MouseButton1Click:Connect(
    function()
        --[[
          line: 1763
          upvalues:
            ShirtsFrame_upv_1 (copy, index: 1)
        ]]
        doSelection(ShirtsFrame_upv_1.LongSleeve)
    end
)
ShirtsFrame_upv_1.Undershirt.MouseButton1Click:Connect(
    function()
        --[[
          line: 1767
          upvalues:
            ShirtsFrame_upv_1 (copy, index: 1)
        ]]
        doSelection(ShirtsFrame_upv_1.Undershirt)
    end
)
ShirtsFrame_upv_1.Tracksuit.MouseButton1Click:Connect(
    function()
        --[[
          line: 1771
          upvalues:
            ShirtsFrame_upv_1 (copy, index: 1)
        ]]
        doSelection(ShirtsFrame_upv_1.Tracksuit)
    end
)
AccessoriesFrame_upv_1.None.MouseButton1Click:Connect(
    function()
        --[[
          line: 1775
          upvalues:
            AccessoriesFrame_upv_1 (copy, index: 1)
        ]]
        doSelection(AccessoriesFrame_upv_1.None)
    end
)
AccessoriesFrame_upv_1.BlackGloves.MouseButton1Click:Connect(
    function()
        --[[
          line: 1779
          upvalues:
            AccessoriesFrame_upv_1 (copy, index: 1)
        ]]
        doSelection(AccessoriesFrame_upv_1.BlackGloves)
    end
)
AccessoriesFrame_upv_1.WhiteGloves.MouseButton1Click:Connect(
    function()
        --[[
          line: 1783
          upvalues:
            AccessoriesFrame_upv_1 (copy, index: 1)
        ]]
        doSelection(AccessoriesFrame_upv_1.WhiteGloves)
    end
)
AccessoriesFrame_upv_1.BlackFaceMask.MouseButton1Click:Connect(
    function()
        --[[
          line: 1787
          upvalues:
            AccessoriesFrame_upv_1 (copy, index: 1)
        ]]
        doSelection(AccessoriesFrame_upv_1.BlackFaceMask)
    end
)
AccessoriesFrame_upv_1.HandWrap.MouseButton1Click:Connect(
    function()
        --[[
          line: 1791
          upvalues:
            AccessoriesFrame_upv_1 (copy, index: 1)
        ]]
        doSelection(AccessoriesFrame_upv_1.HandWrap)
    end
)
AccessoriesFrame_upv_1.WhiteFaceMask.MouseButton1Click:Connect(
    function()
        --[[
          line: 1795
          upvalues:
            AccessoriesFrame_upv_1 (copy, index: 1)
        ]]
        doSelection(AccessoriesFrame_upv_1.WhiteFaceMask)
    end
)
AccessoriesFrame_upv_1.WhiteWristband.MouseButton1Click:Connect(
    function()
        --[[
          line: 1799
          upvalues:
            AccessoriesFrame_upv_1 (copy, index: 1)
        ]]
        doSelection(AccessoriesFrame_upv_1.WhiteWristband)
    end
)
AccessoriesFrame_upv_1.BlackWristband.MouseButton1Click:Connect(
    function()
        --[[
          line: 1803
          upvalues:
            AccessoriesFrame_upv_1 (copy, index: 1)
        ]]
        doSelection(AccessoriesFrame_upv_1.BlackWristband)
    end
)
local TeamInfo_upv_1 = game.ReplicatedStorage.TeamInfo
local tbl_upv_111 = {}
tbl_upv_111.Argentina = "Argentina"
tbl_upv_111.AstonVilla = "Aston Vila"
tbl_upv_111.Munich = "Munich"
tbl_upv_111.Dortmund = "Dortmund"
tbl_upv_111.Brazil = "Brazil"
tbl_upv_111.ParisSaints = "Paris"
tbl_upv_111.ManchesterU = "Manchester Utd."
tbl_upv_111.Barcelona = "Barcelona"
tbl_upv_111.Flamengo = "Flamengo"
tbl_upv_111.InterMiami = "Inter Miami"
tbl_upv_111.Japan = "Japan"
tbl_upv_111.Italy = "Italy"
tbl_upv_111.Croatia = "Croatia"
tbl_upv_111.Morocco = "Morocco"
tbl_upv_111.Canada = "Canada"
tbl_upv_111.Portugal = "Portugal"
tbl_upv_111.Mexico = "Mexico"
tbl_upv_111.Netherlands = "Netherlands"
tbl_upv_111.RealMadrid = "Real Madrid"
tbl_upv_111.LiverpoolFC = "Liverpool FC"
tbl_upv_111.SeattleSoundersFC = "Sounders FC"
tbl_upv_111.JuventusFC = "Juventus FC"
tbl_upv_111.Newcastle = "Newcastle Utd."
tbl_upv_111.ManchesterCity = "Man. City"
tbl_upv_111.Germany = "Germany"
tbl_upv_111.England = "England"
tbl_upv_111.Arsenal = "Arsenal"
tbl_upv_111.InterMilan = "Inter Milan"
tbl_upv_111.USA = "USA"
tbl_upv_111.Chelsea = "Chelsea"
tbl_upv_111.Napoli = "Napoli"
tbl_upv_111.France = "France"
tbl_upv_111.Uruguay = "Uruguay"
tbl_upv_111.Roma = "Roma"
tbl_upv_111.Lazio = "Lazio"
tbl_upv_111.SouthKorea = "South Korea"
tbl_upv_111.VascoDaGama = "Vasco da Gama"
tbl_upv_111.Ajax = "AFC Ajax"
tbl_upv_111.Atletico = "Atletico Madrid"
tbl_upv_111.Leverkusen = "B04 Leverkusen"
tbl_upv_111.Wales = "Wales"
tbl_upv_111.Fiorentina = "Fiorentina"
tbl_upv_111.Spurs = "Tottenham Hotspurs"
tbl_upv_111.ACMilan = "AC Milan"
tbl_upv_111.Belgium = "Belgium"
tbl_upv_111.Spain = "Spain"
tbl_upv_111.Scotland = "Scotland"
tbl_upv_111.Poland = "Poland"
tbl_upv_111.Sweden = "Sweden"
tbl_upv_111.Bosnia = "Bosnia & Herzegovina"
tbl_upv_111.Denmark = "Denmark"
tbl_upv_111.Romania = "Romania"
tbl_upv_111.Switzerland = "Switzerland"
local tbl_upv_112 = {}
tbl_upv_112.AstonVilla = BrickColor.new("Baby blue")
tbl_upv_112.Flamengo = BrickColor.new("Dark red")
tbl_upv_112.Argentina = BrickColor.new("Cyan")
tbl_upv_112.Munich = BrickColor.new("Dusty Rose")
tbl_upv_112.Dortmund = BrickColor.new("Bright yellow")
tbl_upv_112.Brazil = BrickColor.new("Dark green")
tbl_upv_112.ParisSaints = BrickColor.new("Dark blue")
tbl_upv_112.ManchesterU = BrickColor.new("Bright red")
tbl_upv_112.Barcelona = BrickColor.new("Deep blue")
tbl_upv_112.InterMiami = BrickColor.new("Carnation pink")
tbl_upv_112.Japan = BrickColor.new("Navy blue")
tbl_upv_112.Italy = BrickColor.new("Lapis")
tbl_upv_112.Croatia = BrickColor.new("Pastel Blue")
tbl_upv_112.Morocco = BrickColor.new("Crimson")
tbl_upv_112.Canada = BrickColor.new("Ghost grey")
tbl_upv_112.Portugal = BrickColor.new("Bright red")
tbl_upv_112.Mexico = BrickColor.new("Black")
tbl_upv_112.Netherlands = BrickColor.new("Neon orange")
tbl_upv_112.RealMadrid = BrickColor.new("Ghost grey")
tbl_upv_112.LiverpoolFC = BrickColor.new("Really red")
tbl_upv_112.SeattleSoundersFC = BrickColor.new("Bright green")
tbl_upv_112.JuventusFC = BrickColor.new("Really black")
tbl_upv_112.Newcastle = BrickColor.new("Smoky grey")
tbl_upv_112.ManchesterCity = BrickColor.new("Electric blue")
tbl_upv_112.Germany = BrickColor.new("Maroon")
tbl_upv_112.Arsenal = BrickColor.new("Really red")
tbl_upv_112.InterMilan = BrickColor.new("Navy blue")
tbl_upv_112.USA = BrickColor.new("Deep blue")
tbl_upv_112.Chelsea = BrickColor.new("Lapis")
tbl_upv_112.Napoli = BrickColor.new("Steel blue")
tbl_upv_112.France = BrickColor.new("Dark blue")
tbl_upv_112.Uruguay = BrickColor.new("Medium blue")
tbl_upv_112.Roma = BrickColor.new("Persimmon")
tbl_upv_112.Lazio = BrickColor.new("Medium blue")
tbl_upv_112.England = BrickColor.new("Fossil")
tbl_upv_112.SouthKorea = BrickColor.new("Mid gray")
tbl_upv_112.VascoDaGama = BrickColor.new("Mid gray")
tbl_upv_112.Ajax = BrickColor.new("Salmon")
tbl_upv_112.Atletico = BrickColor.new("Crimson")
tbl_upv_112.Leverkusen = BrickColor.new("Cocoa")
tbl_upv_112.Wales = BrickColor.new("Sea green")
tbl_upv_112.Fiorentina = BrickColor.new("Royal purple")
tbl_upv_112.Spurs = BrickColor.new("Quill grey")
tbl_upv_112.ACMilan = BrickColor.new("Maroon")
tbl_upv_112.Belgium = BrickColor.new("Deep orange")
tbl_upv_112.Spain = BrickColor.new("Bright orange")
tbl_upv_112.Scotland = BrickColor.new("Electric blue")
tbl_upv_112.Poland = BrickColor.new("Terra Cotta")
tbl_upv_112.Sweden = BrickColor.new("Storm blue")
tbl_upv_112.Bosnia = BrickColor.new("Dark indigo")
tbl_upv_112.Denmark = BrickColor.new("Really red")
tbl_upv_112.Romania = BrickColor.new("Bright yellow")
tbl_upv_112.Switzerland = BrickColor.new("Persimmon")
local tbl_upv_113 = {}
tbl_upv_113.AstonVilla = "rbxassetid://81835506871297"
tbl_upv_113.Flamengo = "rbxassetid://110918350569178"
tbl_upv_113.Argentina = "rbxassetid://15068029862"
tbl_upv_113.Munich = "rbxassetid://15068635815"
tbl_upv_113.Dortmund = "rbxassetid://13460575423"
tbl_upv_113.Brazil = "rbxassetid://15068649812"
tbl_upv_113.ParisSaints = "rbxassetid://13552953245"
tbl_upv_113.ManchesterU = "rbxassetid://14540294821"
tbl_upv_113.Barcelona = "rbxassetid://316144192"
tbl_upv_113.InterMiami = "rbxassetid://15081749904"
tbl_upv_113.Japan = "rbxassetid://15098627666"
tbl_upv_113.Italy = "rbxassetid://15107657423"
tbl_upv_113.Croatia = "rbxassetid://15107652254"
tbl_upv_113.Morocco = "rbxassetid://15107668354"
tbl_upv_113.Canada = "rbxassetid://15107670722"
tbl_upv_113.Portugal = "rbxassetid://15148310170"
tbl_upv_113.Mexico = "rbxassetid://15107685948"
tbl_upv_113.Netherlands = "rbxassetid://15107690732"
tbl_upv_113.RealMadrid = "rbxassetid://15107692601"
tbl_upv_113.LiverpoolFC = "rbxassetid://5525377475"
tbl_upv_113.SeattleSoundersFC = "rbxassetid://15155280087"
tbl_upv_113.JuventusFC = "rbxassetid://15238497443"
tbl_upv_113.Newcastle = "rbxassetid://18897627545"
tbl_upv_113.ManchesterCity = "rbxassetid://14243657473"
tbl_upv_113.Germany = "rbxassetid://18640980135"
tbl_upv_113.England = "rbxassetid://18641004985"
tbl_upv_113.Arsenal = "rbxassetid://18652402819"
tbl_upv_113.InterMilan = "rbxassetid://18816070754"
tbl_upv_113.USA = "rbxassetid://18641031024"
tbl_upv_113.Chelsea = "rbxassetid://18641029244"
tbl_upv_113.Napoli = "rbxassetid://18641026783"
tbl_upv_113.France = "rbxassetid://18641023325"
tbl_upv_113.Uruguay = "rbxassetid://18641021338"
tbl_upv_113.Roma = "rbxassetid://18641019719"
tbl_upv_113.Lazio = "rbxassetid://18641016564"
tbl_upv_113.SouthKorea = "rbxassetid://18641001856"
tbl_upv_113.VascoDaGama = "rbxassetid://18640997828"
tbl_upv_113.Ajax = "rbxassetid://18640996176"
tbl_upv_113.Atletico = "rbxassetid://18640993960"
tbl_upv_113.Leverkusen = "rbxassetid://18640992087"
tbl_upv_113.Wales = "rbxassetid://18640989958"
tbl_upv_113.Fiorentina = "rbxassetid://18640988644"
tbl_upv_113.Spurs = "rbxassetid://18640987300"
tbl_upv_113.ACMilan = "rbxassetid://18640984312"
tbl_upv_113.Belgium = "rbxassetid://18641190960"
tbl_upv_113.Spain = "rbxassetid://18672737980"
tbl_upv_113.Scotland = "rbxassetid://18672741584"
tbl_upv_113.Poland = "rbxassetid://18816097298"
tbl_upv_113.Sweden = "rbxassetid://18897774513"
tbl_upv_113.Bosnia = "rbxassetid://18897785797"
tbl_upv_113.Denmark = "rbxassetid://18897980982"
tbl_upv_113.Romania = "rbxassetid://18897982581"
tbl_upv_113.Switzerland = "rbxassetid://18897984306"
local LocalPlayer_upv_2 = game.Players.LocalPlayer
local u36 = LocalPlayer_upv_2.Character or (LocalPlayer_upv_2.CharacterAdded:Wait())
if LocalPlayer_upv_2:FindFirstChild("InPlay") then
    PlayButton_upv_1.Visible = false
    MenuButtons_upv_1.Visible = false
end
LocalPlayer_upv_2.ChildAdded:Connect(
    function(a1)
        --[[
          line: 1988
          upvalues:
            Holder_upv_1 (copy, index: 1)
            Holder_upv_2 (copy, index: 2)
            SkillFrame_upv_1 (copy, index: 3)
            PlayButton_upv_1 (copy, index: 4)
            MenuButtons_upv_1 (copy, index: 5)
            CustomizationFrame_upv_1 (copy, index: 6)
            ColorSelector_upv_1 (copy, index: 7)
            EquipFrame_upv_1 (copy, index: 8)
        ]]
        if a1.Name ~= "InPlay" then
            return
        end
        Holder_upv_1.Parent.Visible = false
        Holder_upv_2.Parent.Visible = false
        SkillFrame_upv_1.Position = UDim2.new(0.5, 0, 1, 230)
        SkillFrame_upv_1.Visible = false
        PlayButton_upv_1.Visible = false
        MenuButtons_upv_1.Visible = false
        CustomizationFrame_upv_1:SetAttribute("vis", false)
        CustomizationFrame_upv_1.ItemsFrame.Position = UDim2.new(0, -350, 0.5, 0)
        CustomizationFrame_upv_1.SelectFrame.Position = UDim2.new(1, 800, 1, 0)
        CustomizationFrame_upv_1.CancelButton.Position = UDim2.new(0.5, 0, 0.95, 200)
        ColorSelector_upv_1.Visible = false
        EquipFrame_upv_1.Position = UDim2.new(0, -125, 0.5, 150)
    end
)
LocalPlayer_upv_2.ChildRemoved:Connect(
    function(a1)
        --[[
          line: 2005
          upvalues:
            Holder_upv_1 (copy, index: 1)
            Holder_upv_2 (copy, index: 2)
            PlayButton_upv_1 (copy, index: 3)
            MenuButtons_upv_1 (copy, index: 4)
        ]]
        if a1.Name == "InPlay" then
            Holder_upv_1.Parent.Visible = true
            Holder_upv_2.Parent.Visible = true
            local EndScreen_1 = game.ReplicatedStorage:FindFirstChild("EndScreen")
            if EndScreen_1 then
                local v172
                repeat
                    task.wait()
                    v172 = game.ReplicatedStorage:FindFirstChild("EndScreen")
                until not (v172)
            end
            PlayButton_upv_1.Visible = true
            MenuButtons_upv_1.Visible = true
        end
    end
)
local u37 = false
TeamInfo_upv_1.CurrentHomeTeam.Changed:Connect(
    function()
        --[[
          line: 2019
          upvalues:
            TeamSelectFrame_upv_1 (copy, index: 1)
            tbl_upv_112 (copy, index: 2)
            tbl_upv_111 (copy, index: 3)
            tbl_upv_113 (copy, index: 4)
        ]]
        local Value_1 = game.ReplicatedStorage.TeamInfo.CurrentHomeTeam.Value
        local HomeTeam_1 = TeamSelectFrame_upv_1.SelectionFrame.HomeTeam
        HomeTeam_1.BackgroundColor3 = tbl_upv_112[Value_1].Color
        HomeTeam_1.Vignette.ImageColor3 = tbl_upv_112[Value_1].Color
        HomeTeam_1.teamName.Text = tbl_upv_111[Value_1]
        HomeTeam_1.Crest.Image = tbl_upv_113[Value_1]
    end
)
TeamInfo_upv_1.CurrentAwayTeam.Changed:Connect(
    function()
        --[[
          line: 2028
          upvalues:
            TeamSelectFrame_upv_1 (copy, index: 1)
            tbl_upv_112 (copy, index: 2)
            tbl_upv_111 (copy, index: 3)
            tbl_upv_113 (copy, index: 4)
        ]]
        local Value_2 = game.ReplicatedStorage.TeamInfo.CurrentAwayTeam.Value
        local AwayTeam_1 = TeamSelectFrame_upv_1.SelectionFrame.AwayTeam
        AwayTeam_1.BackgroundColor3 = tbl_upv_112[Value_2].Color
        AwayTeam_1.Vignette.ImageColor3 = tbl_upv_112[Value_2].Color
        AwayTeam_1.teamName.Text = tbl_upv_111[Value_2]
        AwayTeam_1.Crest.Image = tbl_upv_113[Value_2]
    end
)
TeamInfo_upv_1.HomeTeamPlayers.Changed:Connect(
    function()
        --[[
          line: 2037
          upvalues:
            TeamSelectFrame_upv_1 (copy, index: 1)
            TeamInfo_upv_1 (copy, index: 2)
        ]]
        updatePositionPlayers()
        TeamSelectFrame_upv_1.SelectionFrame.HomeTeam.plrCount.Text = TeamInfo_upv_1.HomeTeamPlayers.Value .. "/11"
    end
)
TeamInfo_upv_1.AwayTeamPlayers.Changed:Connect(
    function()
        --[[
          line: 2042
          upvalues:
            TeamSelectFrame_upv_1 (copy, index: 1)
            TeamInfo_upv_1 (copy, index: 2)
        ]]
        updatePositionPlayers()
        TeamSelectFrame_upv_1.SelectionFrame.AwayTeam.plrCount.Text = TeamInfo_upv_1.AwayTeamPlayers.Value .. "/11"
    end
)
TeamSelectFrame_upv_1.SelectionFrame.HomeTeam.plrCount.Text = TeamInfo_upv_1.HomeTeamPlayers.Value .. "/11"
TeamSelectFrame_upv_1.SelectionFrame.AwayTeam.plrCount.Text = TeamInfo_upv_1.AwayTeamPlayers.Value .. "/11"
local ModeSelectFrame_upv_1 = script.Parent:WaitForChild("ModeSelectFrame")
local tbl_upv_114 = {}
tbl_upv_114.LW = nil
tbl_upv_114.CF = nil
tbl_upv_114.RW = nil
tbl_upv_114.LAM = nil
tbl_upv_114.RAM = nil
tbl_upv_114.CDM = nil
tbl_upv_114.LCB = nil
tbl_upv_114.RCB = nil
tbl_upv_114.LWB = nil
tbl_upv_114.RWB = nil
tbl_upv_114.GK = nil
local tbl_upv_115 = {}
tbl_upv_115.LW = nil
tbl_upv_115.CF = nil
tbl_upv_115.RW = nil
tbl_upv_115.LAM = nil
tbl_upv_115.RAM = nil
tbl_upv_115.CDM = nil
tbl_upv_115.LCB = nil
tbl_upv_115.RCB = nil
tbl_upv_115.LWB = nil
tbl_upv_115.RWB = nil
tbl_upv_115.GK = nil
function updatePositionPlayers()
    --[[
      name: updatePositionPlayers
      line: 2078
      upvalues:
        tbl_upv_114 (ref, index: 1)
        tbl_upv_115 (ref, index: 2)
    ]]
    tbl_upv_114 = {LW = nil, CF = nil, RW = nil, LAM = nil, RAM = nil, CDM = nil, LCB = nil, RCB = nil, LWB = nil, RWB = nil, GK = nil}
    tbl_upv_115 = {LW = nil, CF = nil, RW = nil, LAM = nil, RAM = nil, CDM = nil, LCB = nil, RCB = nil, LWB = nil, RWB = nil, GK = nil}
    for _, value_48 in pairs(game.Players:GetPlayers()) do
        if not (value_48:FindFirstChild("dataLoaded")) then
            continue
        end
        if value_48.SelectedTeam.Value == "Home" then
            local v173 = tbl_upv_114
            v173[value_48.SelectedPosition.Value] = string.upper(value_48.DisplayName)
            continue
        end
        if value_48.SelectedTeam.Value == "Away" then
            local v173 = tbl_upv_115
            v173[value_48.SelectedPosition.Value] = string.upper(value_48.DisplayName)
        end
    end
end
local u38 = false
function openTeamSelect()
    --[[
      name: openTeamSelect
      line: 2117
      upvalues:
        u37 (ref,  index: 1)
        TeamSelectFrame_upv_1 (copy, index: 2)
        tbl_upv_112 (copy, index: 3)
        tbl_upv_111 (copy, index: 4)
        tbl_upv_113 (copy, index: 5)
        PosSelectFrame_upv_1 (copy, index: 6)
    ]]
    if u37 == true then
        return
    end
    local Value_3 = game.ReplicatedStorage.TeamInfo.CurrentHomeTeam.Value
    local HomeTeam_2 = TeamSelectFrame_upv_1.SelectionFrame.HomeTeam
    HomeTeam_2.BackgroundColor3 = tbl_upv_112[Value_3].Color
    HomeTeam_2.Vignette.ImageColor3 = tbl_upv_112[Value_3].Color
    HomeTeam_2.teamName.Text = tbl_upv_111[Value_3]
    HomeTeam_2.Crest.Image = tbl_upv_113[Value_3]
    local Value_4 = game.ReplicatedStorage.TeamInfo.CurrentAwayTeam.Value
    local AwayTeam_2 = TeamSelectFrame_upv_1.SelectionFrame.AwayTeam
    AwayTeam_2.BackgroundColor3 = tbl_upv_112[Value_4].Color
    AwayTeam_2.Vignette.ImageColor3 = tbl_upv_112[Value_4].Color
    AwayTeam_2.teamName.Text = tbl_upv_111[Value_4]
    AwayTeam_2.Crest.Image = tbl_upv_113[Value_4]
    u37 = true
    TeamSelectFrame_upv_1.Visible = true
    TeamSelectFrame_upv_1.Position = UDim2.new(0.5, 0, 1, 200)
    TeamSelectFrame_upv_1.CancelButton.Position = UDim2.new(0.5, 0, 1, 35)
    PosSelectFrame_upv_1.Position = UDim2.new(0.5, 0, 0.5, 0)
    PosSelectFrame_upv_1.CancelButton.Position = UDim2.new(0.5, 0, 1, 35)
    local TweenService_79 = game:GetService("TweenService")
    local v174 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_116 = {}
    tbl_116.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService_79:Create(TeamSelectFrame_upv_1, v174, tbl_116):Play()
end
local u39 = "N/A"
function closeTeamSelect()
    --[[
      name: closeTeamSelect
      line: 2146
      upvalues:
        u37 (ref,  index: 1)
        u39 (ref,  index: 2)
        TeamSelectFrame_upv_1 (copy, index: 3)
        PosSelectFrame_upv_1 (copy, index: 4)
    ]]
    if u37 == false then
        return
    end
    u39 = "N/A"
    local TweenService_80 = game:GetService("TweenService")
    local v175 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    local tbl_117 = {}
    tbl_117.Position = UDim2.new(0.5, 0, 1, 200)
    TweenService_80:Create(TeamSelectFrame_upv_1, v175, tbl_117):Play()
    local TweenService_81 = game:GetService("TweenService")
    local v176 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_118 = {}
    tbl_118.Position = UDim2.new(0.5, 0, 1, 750)
    TweenService_81:Create(TeamSelectFrame_upv_1.CancelButton, v176, tbl_118):Play()
    local TweenService_82 = game:GetService("TweenService")
    local v177 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    local tbl_119 = {}
    tbl_119.Position = UDim2.new(0.5, 0, 1, 250)
    TweenService_82:Create(PosSelectFrame_upv_1, v177, tbl_119):Play()
    local TweenService_83 = game:GetService("TweenService")
    local v178 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_120 = {}
    tbl_120.Position = UDim2.new(0.5, 0, 1, 750)
    TweenService_83:Create(PosSelectFrame_upv_1.CancelButton, v178, tbl_120):Play()
    task.delay(
        0.5,
        function()
            --[[
              line: 2163
              upvalues:
                u37 (ref,  index: 1)
                TeamSelectFrame_upv_1 (copy, index: 2)
                PosSelectFrame_upv_1 (copy, index: 3)
            ]]
            u37 = false
            TeamSelectFrame_upv_1.Visible = false
            PosSelectFrame_upv_1.Visible = false
        end
    )
end
function openModeSelect()
    --[[
      name: openModeSelect
      line: 2170
      upvalues:
        u38 (ref,  index: 1)
        ModeSelectFrame_upv_1 (copy, index: 2)
    ]]
    if u38 == true then
        return
    end
    u38 = true
    ModeSelectFrame_upv_1.Visible = true
    ModeSelectFrame_upv_1.Position = UDim2.new(0.5, 0, 1, 200)
    ModeSelectFrame_upv_1.CancelButton.Position = UDim2.new(0.5, 0, 1, 35)
    local TweenService_84 = game:GetService("TweenService")
    local v179 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_121 = {}
    tbl_121.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService_84:Create(ModeSelectFrame_upv_1, v179, tbl_121):Play()
end
function closeModeSelect()
    --[[
      name: closeModeSelect
      line: 2184
      upvalues:
        u38 (ref,  index: 1)
        ModeSelectFrame_upv_1 (copy, index: 2)
    ]]
    if u38 == false then
        return
    end
    local TweenService_85 = game:GetService("TweenService")
    local v180 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    local tbl_122 = {}
    tbl_122.Position = UDim2.new(0.5, 0, 1, 200)
    TweenService_85:Create(ModeSelectFrame_upv_1, v180, tbl_122):Play()
    local TweenService_86 = game:GetService("TweenService")
    local v181 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_123 = {}
    tbl_123.Position = UDim2.new(0.5, 0, 1, 750)
    TweenService_86:Create(ModeSelectFrame_upv_1.CancelButton, v181, tbl_123):Play()
    task.delay(
        0.5,
        function()
            --[[
              line: 2195
              upvalues:
                u38 (ref,  index: 1)
                ModeSelectFrame_upv_1 (copy, index: 2)
            ]]
            u38 = false
            ModeSelectFrame_upv_1.Visible = false
        end
    )
end
local ModeButton_1 = script.Parent:WaitForChild("PlayButton"):WaitForChild("ModeButton")
PlayButton_upv_1.PlayButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 2203
          upvalues:
            StatsFrame_upv_1 (copy, index: 1)
            SkillFrame_upv_1 (copy, index: 2)
            CustomizationFrame_upv_1 (copy, index: 3)
        ]]
        local TweenService_87 = game:GetService("TweenService")
        local v182 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_124 = {}
        tbl_124.Position = UDim2.new(0.5, 0, 1, 170)
        TweenService_87:Create(StatsFrame_upv_1, v182, tbl_124):Play()
        task.delay(
            0.35,
            function()
                --[[
                  line: 2208
                  upvalues:
                    StatsFrame_upv_1 (copy, index: 1)
                ]]
                StatsFrame_upv_1.Visible = false
            end
        )
        script.Parent.SettingsFrame.Visible = false
        local TweenService_88 = game:GetService("TweenService")
        local v183 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_125 = {}
        tbl_125.Position = UDim2.new(0.5, 0, 1, 230)
        TweenService_88:Create(SkillFrame_upv_1, v183, tbl_125):Play()
        task.delay(
            0.35,
            function()
                --[[
                  line: 2215
                  upvalues:
                    SkillFrame_upv_1 (copy, index: 1)
                ]]
                SkillFrame_upv_1.Visible = false
            end
        )
        local TweenService_89 = game:GetService("TweenService")
        local v184 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_126 = {}
        tbl_126.Position = UDim2.new(0.5, 0, 1.5, 0)
        TweenService_89:Create(script.Parent.ClubFrame, v184, tbl_126):Play()
        task.delay(
            0.35,
            function()
                --[[
                  line: 2221
                ]]
                script.Parent.ClubFrame.Visible = false
            end
        )
        CustomizationFrame_upv_1:SetAttribute("vis", false)
        openTeamSelect()
    end
)
ModeButton_1.MouseButton1Click:Connect(
    function()
        --[[
          line: 2228
          upvalues:
            StatsFrame_upv_1 (copy, index: 1)
            SkillFrame_upv_1 (copy, index: 2)
        ]]
        local TweenService_90 = game:GetService("TweenService")
        local v185 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_127 = {}
        tbl_127.Position = UDim2.new(0.5, 0, 1, 170)
        TweenService_90:Create(StatsFrame_upv_1, v185, tbl_127):Play()
        task.delay(
            0.35,
            function()
                --[[
                  line: 2232
                  upvalues:
                    StatsFrame_upv_1 (copy, index: 1)
                ]]
                StatsFrame_upv_1.Visible = false
            end
        )
        script.Parent.SettingsFrame.Visible = false
        local TweenService_91 = game:GetService("TweenService")
        local v186 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_128 = {}
        tbl_128.Position = UDim2.new(0.5, 0, 1, 230)
        TweenService_91:Create(SkillFrame_upv_1, v186, tbl_128):Play()
        task.delay(
            0.35,
            function()
                --[[
                  line: 2239
                  upvalues:
                    SkillFrame_upv_1 (copy, index: 1)
                ]]
                SkillFrame_upv_1.Visible = false
            end
        )
        local TweenService_92 = game:GetService("TweenService")
        local v187 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_129 = {}
        tbl_129.Position = UDim2.new(0.5, 0, 1.5, 0)
        TweenService_92:Create(script.Parent.ClubFrame, v187, tbl_129):Play()
        task.delay(
            0.35,
            function()
                --[[
                  line: 2245
                ]]
                script.Parent.ClubFrame.Visible = false
            end
        )
        closeTeamSelect()
        openModeSelect()
    end
)
ModeSelectFrame_upv_1.CancelButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 2252
        ]]
        closeModeSelect()
    end
)
PosSelectFrame_upv_1.CancelButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 2256
        ]]
        closeTeamSelect()
    end
)
TeamSelectFrame_upv_1.CancelButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 2260
        ]]
        closeTeamSelect()
    end
)
local SelectionFrame_upv_2 = PosSelectFrame_upv_1.SelectionFrame
function handlePosSelect(a1)
    --[[
      name: handlePosSelect
      line: 2265
      upvalues:
        u39 (ref,  index: 1)
        SelectionFrame_upv_2 (copy, index: 2)
        tbl_upv_114 (ref,  index: 3)
        tbl_upv_115 (ref,  index: 4)
    ]]
    updatePositionPlayers()
    u39 = a1
    if a1 == "Home" then
        SelectionFrame_upv_2.LWButton.CurrentPlayer.Text = tbl_upv_114.LW or ""
        SelectionFrame_upv_2.CFButton.CurrentPlayer.Text = tbl_upv_114.CF or ""
        SelectionFrame_upv_2.RWButton.CurrentPlayer.Text = tbl_upv_114.RW or ""
        SelectionFrame_upv_2.CAMButtonL.CurrentPlayer.Text = tbl_upv_114.LAM or ""
        SelectionFrame_upv_2.CAMButtonR.CurrentPlayer.Text = tbl_upv_114.RAM or ""
        SelectionFrame_upv_2.CDMButton.CurrentPlayer.Text = tbl_upv_114.CDM or ""
        SelectionFrame_upv_2.CBButtonL.CurrentPlayer.Text = tbl_upv_114.LCB or ""
        SelectionFrame_upv_2.CBButtonR.CurrentPlayer.Text = tbl_upv_114.RCB or ""
        SelectionFrame_upv_2.LWBButton.CurrentPlayer.Text = tbl_upv_114.LWB or ""
        SelectionFrame_upv_2.RWBButton.CurrentPlayer.Text = tbl_upv_114.RWB or ""
        SelectionFrame_upv_2.GKButton.CurrentPlayer.Text = tbl_upv_114.GK or ""
    elseif a1 == "Away" then
        SelectionFrame_upv_2.LWButton.CurrentPlayer.Text = tbl_upv_115.LW or ""
        SelectionFrame_upv_2.CFButton.CurrentPlayer.Text = tbl_upv_115.CF or ""
        SelectionFrame_upv_2.RWButton.CurrentPlayer.Text = tbl_upv_115.RW or ""
        SelectionFrame_upv_2.CAMButtonL.CurrentPlayer.Text = tbl_upv_115.LAM or ""
        SelectionFrame_upv_2.CAMButtonR.CurrentPlayer.Text = tbl_upv_115.RAM or ""
        SelectionFrame_upv_2.CDMButton.CurrentPlayer.Text = tbl_upv_115.CDM or ""
        SelectionFrame_upv_2.CBButtonL.CurrentPlayer.Text = tbl_upv_115.LCB or ""
        SelectionFrame_upv_2.CBButtonR.CurrentPlayer.Text = tbl_upv_115.RCB or ""
        SelectionFrame_upv_2.LWBButton.CurrentPlayer.Text = tbl_upv_115.LWB or ""
        SelectionFrame_upv_2.RWBButton.CurrentPlayer.Text = tbl_upv_115.RWB or ""
        SelectionFrame_upv_2.GKButton.CurrentPlayer.Text = tbl_upv_115.GK or ""
    end
end
function selectPosition(a1)
    --[[
      name: selectPosition
      line: 2295
      upvalues:
        u39 (ref,  index: 1)
        tbl_upv_114 (ref,  index: 2)
        u12 (copy, index: 3)
        tbl_upv_115 (ref,  index: 4)
    ]]
    if u39 ~= "Home" then
        if u39 == "Away" then
            local v188 = nil
            if tbl_upv_115[a1] ~= nil then
                notification("POSITION TAKEN. PLEASE SELECT A DIFFERENT POSITION.")
            else
                closeTeamSelect()
                v188 = u12:InvokeServer(a1, "Away")
                if v188 == "TeamFull" then
                    notification("TEAM FULL. SELECT A DIFFERENT TEAM.")
                elseif v188 == "PositionFull" then
                    notification("POSITION TAKEN. PLEASE SELECT A DIFFERENT POSITION.")
                elseif v188 == nil then
                    notification("AN UNKNOWN ERROR OCCURED. PLEASE TRY AGAIN.")
                end
            end
        end
    elseif tbl_upv_114[a1] ~= nil then
        notification("POSITION TAKEN. PLEASE SELECT A DIFFERENT POSITION.")
    else
        closeTeamSelect()
        local v189 = u12:InvokeServer(a1, "Home")
        if v189 == "TeamFull" then
            notification("TEAM FULL. SELECT A DIFFERENT TEAM.")
        elseif v189 == "PositionFull" then
            notification("POSITION TAKEN. PLEASE SELECT A DIFFERENT POSITION.")
        elseif v189 == nil then
            notification("AN UNKNOWN ERROR OCCURED. PLEASE TRY AGAIN.")
        end
    end
end
TeamSelectFrame_upv_1.SelectionFrame.HomeTeam.MouseButton1Click:Connect(
    function()
        --[[
          line: 2327
          upvalues:
            TeamInfo_upv_1 (copy, index: 1)
            LocalPlayer_upv_2 (copy, index: 2)
            TeamSelectFrame_upv_1 (copy, index: 3)
            PosSelectFrame_upv_1 (copy, index: 4)
        ]]
        if (TeamInfo_upv_1.HomeTeamPlayers.Value >= 11 or TeamInfo_upv_1.AwayTeamPlayers.Value < TeamInfo_upv_1.HomeTeamPlayers.Value) and LocalPlayer_upv_2.SelectedTeam.Value ~= "Home" then
            local NoTeamLimits_1 = game.ReplicatedStorage:FindFirstChild("NoTeamLimits")
            if not (NoTeamLimits_1) then
                notification("TEAM FULL. SELECT A DIFFERENT TEAM.")
                return
            end
        end
        TeamSelectFrame_upv_1.Visible = false
        PosSelectFrame_upv_1.Visible = true
        handlePosSelect("Home")
        while PosSelectFrame_upv_1.Visible == true do
            task.wait()
            handlePosSelect("Home")
        end
    end
)
TeamSelectFrame_upv_1.SelectionFrame.AwayTeam.MouseButton1Click:Connect(
    function()
        --[[
          line: 2341
          upvalues:
            TeamInfo_upv_1 (copy, index: 1)
            LocalPlayer_upv_2 (copy, index: 2)
            TeamSelectFrame_upv_1 (copy, index: 3)
            PosSelectFrame_upv_1 (copy, index: 4)
        ]]
        if (TeamInfo_upv_1.AwayTeamPlayers.Value >= 11 or TeamInfo_upv_1.HomeTeamPlayers.Value < TeamInfo_upv_1.AwayTeamPlayers.Value) and LocalPlayer_upv_2.SelectedTeam.Value ~= "Away" then
            local NoTeamLimits_2 = game.ReplicatedStorage:FindFirstChild("NoTeamLimits")
            if not (NoTeamLimits_2) then
                notification("TEAM FULL. SELECT A DIFFERENT TEAM.")
                return
            end
        end
        TeamSelectFrame_upv_1.Visible = false
        PosSelectFrame_upv_1.Visible = true
        handlePosSelect("Away")
        while PosSelectFrame_upv_1.Visible == true do
            task.wait()
            handlePosSelect("Away")
        end
    end
)
SelectionFrame_upv_2.LWButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 2355
        ]]
        selectPosition("LW")
    end
)
SelectionFrame_upv_2.CFButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 2360
        ]]
        selectPosition("CF")
    end
)
SelectionFrame_upv_2.RWButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 2364
        ]]
        selectPosition("RW")
    end
)
SelectionFrame_upv_2.CAMButtonL.MouseButton1Click:Connect(
    function()
        --[[
          line: 2369
        ]]
        selectPosition("LAM")
    end
)
SelectionFrame_upv_2.CAMButtonR.MouseButton1Click:Connect(
    function()
        --[[
          line: 2373
        ]]
        selectPosition("RAM")
    end
)
SelectionFrame_upv_2.CDMButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 2377
        ]]
        selectPosition("CDM")
    end
)
SelectionFrame_upv_2.LWBButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 2381
        ]]
        selectPosition("LWB")
    end
)
SelectionFrame_upv_2.CBButtonL.MouseButton1Click:Connect(
    function()
        --[[
          line: 2385
        ]]
        selectPosition("LCB")
    end
)
SelectionFrame_upv_2.CBButtonR.MouseButton1Click:Connect(
    function()
        --[[
          line: 2389
        ]]
        selectPosition("RCB")
    end
)
SelectionFrame_upv_2.RWBButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 2393
        ]]
        selectPosition("RWB")
    end
)
SelectionFrame_upv_2.GKButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 2398
        ]]
        selectPosition("GK")
    end
)
LocalPlayer_upv_2:WaitForChild("dataLoaded")
local SettingsFrame_upv_1 = script.Parent.SettingsFrame
local MiscFrame_upv_1 = SettingsFrame_upv_1.MiscFrame
local ControlsFrame_upv_1 = SettingsFrame_upv_1.ControlsFrame
local PickCategoryFrame_upv_1 = SettingsFrame_upv_1.PickCategoryFrame
local Misc_upv_1 = LocalPlayer_upv_2.Settings.Misc
local Controls_upv_1 = LocalPlayer_upv_2.Settings.Controls
if Misc_upv_1.CrowdNoise.Value == false then
    for _, value_49 in pairs(game.Workspace.miscFX:GetDescendants()) do
        if value_49:IsA("Sound") then
            value_49.Volume = 0
        end
    end
end
if Misc_upv_1.FootstepSounds.Value == false then
    u36.WalkingSoundsClient.Enabled = false
    if game.SoundService:FindFirstChild("CurrentSound") then
        game.SoundService:FindFirstChild("CurrentSound"):Stop()
    end
end
function toggle(a1, a2)
    --[[
      name: toggle
      line: 2427
    ]]
    local TweenService_93 = game:GetService("TweenService")
    local Toggle_1 = a1.Toggle
    local v190 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local tbl_130 = {BackgroundColor3 = 0}
    tbl_130.BackgroundColor3 = a2 == true and Color3.new(0, 0.666667, 0) or Color3.new(0.666667, 0, 0)
    TweenService_93:Create(Toggle_1, v190, tbl_130):Play()
    local TweenService_94 = game:GetService("TweenService")
    local Slider_1 = a1.Toggle.Slider
    local v192 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local tbl_131 = {Position = 0}
    tbl_131.Position = a2 == true and UDim2.new(0.5, 1, 0.5, 0) or UDim2.new(0, -1, 0.5, 0)
    TweenService_94:Create(Slider_1, v192, tbl_131):Play()
end
local u40 = false
toggle(MiscFrame_upv_1.CROWDNOISE, Misc_upv_1.CrowdNoise.Value)
toggle(MiscFrame_upv_1.MOVETOGGLE, u40)
toggle(MiscFrame_upv_1.AURAEFFECTS, Misc_upv_1.AuraEffects.Value)
toggle(MiscFrame_upv_1.ROBLOXSHIRT, Misc_upv_1.UseRobloxShirt.Value)
toggle(MiscFrame_upv_1.RAIN, Misc_upv_1.RainEnabled.Value)
toggle(MiscFrame_upv_1.SNOW, Misc_upv_1.SnowEnabled.Value)
toggle(MiscFrame_upv_1.STORMY, Misc_upv_1.StormEnabled.Value)
toggle(MiscFrame_upv_1.NIGHT, Misc_upv_1.Night.Value)
toggle(MiscFrame_upv_1.FOOTSTEPS, Misc_upv_1.FootstepSounds.Value)
toggle(MiscFrame_upv_1.SUNFLARE, Misc_upv_1.SunFlare.Value)
toggle(MiscFrame_upv_1.GRASSVISUALS, Misc_upv_1.GrassVisuals.Value)
toggle(MiscFrame_upv_1.CURVEVISUAL, Misc_upv_1.CurveVisual.Value)
toggle(MiscFrame_upv_1.HIGHLIGHTS, Misc_upv_1.Highlights.Value)
toggle(MiscFrame_upv_1.CINEMATIC, Misc_upv_1.CinematicMode.Value)
toggle(MiscFrame_upv_1.SEASONAL, Misc_upv_1.Seasonal.Value)
toggle(ControlsFrame_upv_1.FLIP, Controls_upv_1.Flipped.Value)
toggle(ControlsFrame_upv_1.ToggleSpin, Controls_upv_1.SpinToggle.Value)
toggle(MiscFrame_upv_1.CHARACTERROTATION, Misc_upv_1.CharacterRotation.Value)
MiscFrame_upv_1.CROWDNOISE.Toggle.MouseButton1Click:Connect(
    function()
        --[[
          line: 2457
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
            u5 (copy, index: 3)
        ]]
        toggle(MiscFrame_upv_1.CROWDNOISE, not Misc_upv_1.CrowdNoise.Value)
        for _, value_50 in pairs(game.Workspace.miscFX:GetDescendants()) do
            if value_50:IsA("Sound") then
                value_50.Volume = Misc_upv_1.CrowdNoise.Value == true and 0 or value_50:GetAttribute("Volume")
            end
        end
        u5:FireServer("CrowdNoise", not Misc_upv_1.CrowdNoise.Value)
    end
)
MiscFrame_upv_1.MOVETOGGLE.Toggle.MouseButton1Click:Connect(
    function()
        --[[
          line: 2467
          upvalues:
            u40 (ref,  index: 1)
            MiscFrame_upv_1 (copy, index: 2)
        ]]
        u40 = not u40
        script.Parent:SetAttribute("MovingUi", u40)
        if script.Parent:GetAttribute("MovingUi", true) then
            for _, value_51 in pairs(script.Parent.Parent.Buttons.Frame:QueryDescendants("UIDragDetector")) do
                value_51.Enabled = true
            end
        else
            for _, value_52 in pairs(script.Parent.Parent.Buttons.Frame:QueryDescendants("UIDragDetector")) do
                value_52.Enabled = false
            end
        end
        toggle(MiscFrame_upv_1.MOVETOGGLE, u40)
    end
)
MiscFrame_upv_1.AURAEFFECTS.Toggle.MouseButton1Click:Connect(
    function()
        --[[
          line: 2484
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
            u5 (copy, index: 3)
        ]]
        toggle(MiscFrame_upv_1.AURAEFFECTS, not Misc_upv_1.AuraEffects.Value)
        u5:FireServer("AuraEffects", not Misc_upv_1.AuraEffects.Value)
    end
)
MiscFrame_upv_1.FOOTSTEPS.Toggle.MouseButton1Click:Connect(
    function()
        --[[
          line: 2489
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
            u36 (copy, index: 3)
            u5 (copy, index: 4)
        ]]
        toggle(MiscFrame_upv_1.FOOTSTEPS, not Misc_upv_1.FootstepSounds.Value)
        if Misc_upv_1.FootstepSounds.Value ~= true then
            u36.WalkingSoundsClient.Enabled = false
        else
            u36.WalkingSoundsClient.Enabled = true
            if game.SoundService:FindFirstChild("CurrentSound") then
                game.SoundService:FindFirstChild("CurrentSound"):Stop()
            end
        end
        u5:FireServer("FootstepSounds", not Misc_upv_1.FootstepSounds.Value)
    end
)
MiscFrame_upv_1.SUNFLARE.Toggle.MouseButton1Click:Connect(
    function()
        --[[
          line: 2502
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
            u5 (copy, index: 3)
        ]]
        toggle(MiscFrame_upv_1.SUNFLARE, not Misc_upv_1.SunFlare.Value)
        u5:FireServer("SunFlare", not Misc_upv_1.SunFlare.Value)
    end
)
MiscFrame_upv_1.ROBLOXSHIRT.Toggle.MouseButton1Click:Connect(
    function()
        --[[
          line: 2507
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
            u5 (copy, index: 3)
        ]]
        toggle(MiscFrame_upv_1.ROBLOXSHIRT, not Misc_upv_1.UseRobloxShirt.Value)
        u5:FireServer("UseRobloxShirt", not Misc_upv_1.UseRobloxShirt.Value)
    end
)
MiscFrame_upv_1.HIGHLIGHTS.Toggle.MouseButton1Click:Connect(
    function()
        --[[
          line: 2512
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
            u5 (copy, index: 3)
        ]]
        toggle(MiscFrame_upv_1.HIGHLIGHTS, not Misc_upv_1.Highlights.Value)
        u5:FireServer("Highlights", not Misc_upv_1.Highlights.Value)
    end
)
MiscFrame_upv_1.CHARACTERROTATION.Toggle.MouseButton1Click:Connect(
    function()
        --[[
          line: 2517
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
            u5 (copy, index: 3)
        ]]
        toggle(MiscFrame_upv_1.CHARACTERROTATION, not Misc_upv_1.CharacterRotation.Value)
        u5:FireServer("CharacterRotation", not Misc_upv_1.CharacterRotation.Value)
    end
)
MiscFrame_upv_1.RAIN.Toggle.MouseButton1Click:Connect(
    function()
        --[[
          line: 2523
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
            u5 (copy, index: 3)
        ]]
        toggle(MiscFrame_upv_1.RAIN, not Misc_upv_1.RainEnabled.Value)
        toggle(MiscFrame_upv_1.SNOW, false)
        toggle(MiscFrame_upv_1.STORMY, false)
        u5:FireServer("SnowEnabled", false)
        u5:FireServer("StormEnabled", false)
        u5:FireServer("RainEnabled", not Misc_upv_1.RainEnabled.Value)
    end
)
MiscFrame_upv_1.SNOW.Toggle.MouseButton1Click:Connect(
    function()
        --[[
          line: 2532
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
            u5 (copy, index: 3)
        ]]
        toggle(MiscFrame_upv_1.SNOW, not Misc_upv_1.SnowEnabled.Value)
        toggle(MiscFrame_upv_1.RAIN, false)
        toggle(MiscFrame_upv_1.STORMY, false)
        u5:FireServer("RainEnabled", false)
        u5:FireServer("StormEnabled", false)
        u5:FireServer("SnowEnabled", not Misc_upv_1.SnowEnabled.Value)
    end
)
MiscFrame_upv_1.STORMY.Toggle.MouseButton1Click:Connect(
    function()
        --[[
          line: 2541
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
            u5 (copy, index: 3)
        ]]
        toggle(MiscFrame_upv_1.STORMY, not Misc_upv_1.StormEnabled.Value)
        toggle(MiscFrame_upv_1.RAIN, false)
        toggle(MiscFrame_upv_1.SNOW, false)
        u5:FireServer("SnowEnabled", false)
        u5:FireServer("RainEnabled", false)
        u5:FireServer("StormEnabled", not Misc_upv_1.StormEnabled.Value)
    end
)
MiscFrame_upv_1.GRASSVISUALS.Toggle.MouseButton1Click:Connect(
    function()
        --[[
          line: 2550
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
            u5 (copy, index: 3)
        ]]
        toggle(MiscFrame_upv_1.GRASSVISUALS, not Misc_upv_1.GrassVisuals.Value)
        u5:FireServer("GrassVisuals", not Misc_upv_1.GrassVisuals.Value)
    end
)
MiscFrame_upv_1.NIGHT.Toggle.MouseButton1Click:Connect(
    function()
        --[[
          line: 2555
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
            u5 (copy, index: 3)
        ]]
        toggle(MiscFrame_upv_1.NIGHT, not Misc_upv_1.Night.Value)
        u5:FireServer("Night", not Misc_upv_1.Night.Value)
    end
)
MiscFrame_upv_1.CURVEVISUAL.Toggle.MouseButton1Click:Connect(
    function()
        --[[
          line: 2560
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
            u5 (copy, index: 3)
        ]]
        toggle(MiscFrame_upv_1.CURVEVISUAL, not Misc_upv_1.CurveVisual.Value)
        u5:FireServer("CurveVisual", not Misc_upv_1.CurveVisual.Value)
    end
)
MiscFrame_upv_1.CINEMATIC.Toggle.MouseButton1Click:Connect(
    function()
        --[[
          line: 2566
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
            u5 (copy, index: 3)
        ]]
        toggle(MiscFrame_upv_1.CINEMATIC, not Misc_upv_1.CinematicMode.Value)
        u5:FireServer("CinematicMode", not Misc_upv_1.CinematicMode.Value)
    end
)
MiscFrame_upv_1.SEASONAL.Toggle.MouseButton1Click:Connect(
    function()
        --[[
          line: 2571
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
            u5 (copy, index: 3)
        ]]
        toggle(MiscFrame_upv_1.SEASONAL, not Misc_upv_1.Seasonal.Value)
        u5:FireServer("Seasonal", not Misc_upv_1.Seasonal.Value)
    end
)
MiscFrame_upv_1.CONTRAST.TextBox.FocusLost:Connect(
    function()
        --[[
          line: 2576
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
        ]]
        local _, v195 = pcall(
            function()
                --[[
                  line: 2577
                  upvalues:
                    MiscFrame_upv_1 (copy, index: 1)
                ]]
                return (tonumber(MiscFrame_upv_1.CONTRAST.TextBox.Text))
            end
        )
        if v195 then
            if not (v195 > 1) and not (v195 < 0) then
                Misc_upv_1.Contrast.Value = MiscFrame_upv_1.CONTRAST.TextBox.Text
                game.Lighting.ColorCorrection.Contrast = Misc_upv_1.Contrast.Value
            else
                MiscFrame_upv_1.CONTRAST.TextBox.Text = "0"
                notification("CONTRAST MUST BE BETWEEN 1 AND 0")
            end
        else
            MiscFrame_upv_1.CONTRAST.TextBox.Text = "0"
            notification("INVALID INPUT.")
        end
    end
)
Misc_upv_1.Contrast.Changed:Connect(
    function()
        --[[
          line: 2594
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
            u5 (copy, index: 3)
        ]]
        MiscFrame_upv_1.CONTRAST.TextBox.Text = Misc_upv_1.Contrast.Value
        game.Lighting.ColorCorrection.Contrast = Misc_upv_1.Contrast.Value
        u5:FireServer("Contrast", Misc_upv_1.Contrast.Value)
    end
)
MiscFrame_upv_1.CONTRAST.TextBox.Text = Misc_upv_1.Contrast.Value
game.Lighting.ColorCorrection.Contrast = Misc_upv_1.Contrast.Value
MiscFrame_upv_1.BRIGHTNESS.TextBox.FocusLost:Connect(
    function()
        --[[
          line: 2603
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
        ]]
        local _, v196 = pcall(
            function()
                --[[
                  line: 2604
                  upvalues:
                    MiscFrame_upv_1 (copy, index: 1)
                ]]
                return (tonumber(MiscFrame_upv_1.BRIGHTNESS.TextBox.Text))
            end
        )
        if v196 then
            if not (v196 > 15) and not (v196 < 0) then
                Misc_upv_1.Brightness.Value = MiscFrame_upv_1.BRIGHTNESS.TextBox.Text
                game.Lighting.Brightness = Misc_upv_1.Brightness.Value
            else
                MiscFrame_upv_1.BRIGHTNESS.TextBox.Text = "0"
                notification("BRIGHTNESS MUST BE BETWEEN 15 AND 0.")
            end
        else
            MiscFrame_upv_1.BRIGHTNESS.TextBox.Text = "0"
            notification("INVALID INPUT.")
        end
    end
)
Misc_upv_1.Brightness.Changed:Connect(
    function()
        --[[
          line: 2621
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
            u5 (copy, index: 3)
        ]]
        MiscFrame_upv_1.BRIGHTNESS.TextBox.Text = Misc_upv_1.Brightness.Value
        game.Lighting.Brightness = Misc_upv_1.Brightness.Value
        u5:FireServer("Brightness", Misc_upv_1.Brightness.Value)
        for _, value_53 in ipairs(game.Workspace.miscFX.NightLights:GetDescendants()) do
            if value_53:IsA("Light") then
                value_53.Brightness = Misc_upv_1.Brightness.Value * 0.8
            end
        end
    end
)
MiscFrame_upv_1.BRIGHTNESS.TextBox.Text = Misc_upv_1.Brightness.Value
game.Lighting.Brightness = Misc_upv_1.Brightness.Value
for _, value_54 in ipairs(game.Workspace.miscFX.NightLights:GetDescendants()) do
    if value_54:IsA("Light") then
        value_54.Brightness = Misc_upv_1.Brightness.Value * 0.8
    end
end
MiscFrame_upv_1.NUMBER.TextBox.FocusLost:Connect(
    function()
        --[[
          line: 2641
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            u13 (copy, index: 2)
        ]]
        local _, v197 = pcall(
            function()
                --[[
                  line: 2642
                  upvalues:
                    MiscFrame_upv_1 (copy, index: 1)
                ]]
                return (tonumber(MiscFrame_upv_1.NUMBER.TextBox.Text))
            end
        )
        if v197 then
            if not (v197 > 99) and not (v197 < 0) then
                if u13:InvokeServer(MiscFrame_upv_1.NUMBER.TextBox.Text, "Number") ~= true then
                    notification("AN ERROR HAS OCCURRED.")
                    MiscFrame_upv_1.NUMBER.TextBox.Text = "0"
                end
                return
            end
            MiscFrame_upv_1.NUMBER.TextBox.Text = "0"
            notification("JERSEY NUMBERS MUST BE BETWEEN 1 AND 99. USE 0 TO DISABLE.")
        else
            MiscFrame_upv_1.NUMBER.TextBox.Text = "0"
            notification("INVALID INPUT.")
        end
    end
)
MiscFrame_upv_1.SPONSER.TextBox.FocusLost:Connect(
    function()
        --[[
          line: 2663
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            u13 (copy, index: 2)
        ]]
        local _, v198 = pcall(
            function()
                --[[
                  line: 2664
                  upvalues:
                    MiscFrame_upv_1 (copy, index: 1)
                ]]
                return (tostring(MiscFrame_upv_1.SPONSER.TextBox.Text))
            end
        )
        if v198 then
            if u13:InvokeServer(MiscFrame_upv_1.SPONSER.TextBox.Text, "Sponser") == true then
                return
            end
            notification("AN ERROR HAS OCCURRED.")
            MiscFrame_upv_1.SPONSER.TextBox.Text = "0"
        else
            MiscFrame_upv_1.SPONSER.TextBox.Text = "0"
            notification("SPONSER ID CANNOT BE NIL. IF YOU WISH FOR IT TO BE NOTHING SET IT TO 0")
        end
    end
)
MiscFrame_upv_1.CURSOR.TextBox.FocusLost:Connect(
    function()
        --[[
          line: 2681
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            u13 (copy, index: 2)
        ]]
        local _, v199 = pcall(
            function()
                --[[
                  line: 2682
                  upvalues:
                    MiscFrame_upv_1 (copy, index: 1)
                ]]
                return (tostring(MiscFrame_upv_1.CURSOR.TextBox.Text))
            end
        )
        if v199 then
            if u13:InvokeServer(MiscFrame_upv_1.CURSOR.TextBox.Text, "Cursor") == true then
                return
            end
            notification("AN ERROR HAS OCCURRED.")
            MiscFrame_upv_1.CURSOR.TextBox.Text = "0"
        else
            MiscFrame_upv_1.CURSOR.TextBox.Text = "0"
            notification("CURSOR ID CANNOT BE NIL. IF YOU WISH FOR IT TO BE NOTHING SET IT TO 0")
        end
    end
)
Misc_upv_1.JerseyNumber.Changed:Connect(
    function()
        --[[
          line: 2699
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
        ]]
        MiscFrame_upv_1.NUMBER.TextBox.Text = Misc_upv_1.JerseyNumber.Value
    end
)
Misc_upv_1.SponserID.Changed:Connect(
    function()
        --[[
          line: 2703
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
        ]]
        MiscFrame_upv_1.SPONSER.TextBox.Text = Misc_upv_1.SponserID.Value
    end
)
Misc_upv_1.CustomCursor.Changed:Connect(
    function()
        --[[
          line: 2707
          upvalues:
            MiscFrame_upv_1 (copy, index: 1)
            Misc_upv_1 (copy, index: 2)
        ]]
        MiscFrame_upv_1.CURSOR.TextBox.Text = Misc_upv_1.CustomCursor.Value
    end
)
MiscFrame_upv_1.SPONSER.TextBox.Text = Misc_upv_1.SponserID.Value
MiscFrame_upv_1.NUMBER.TextBox.Text = Misc_upv_1.JerseyNumber.Value
LeftFrame_1.SettingsButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 2714
          upvalues:
            SettingsFrame_upv_1 (copy, index: 1)
            StatsFrame_upv_1 (copy, index: 2)
            SkillFrame_upv_1 (copy, index: 3)
        ]]
        if SettingsFrame_upv_1.Visible == false then
            local TweenService_95 = game:GetService("TweenService")
            local v200 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_132 = {}
            tbl_132.Position = UDim2.new(0.5, 0, 1, 170)
            TweenService_95:Create(StatsFrame_upv_1, v200, tbl_132):Play()
            task.delay(
                0.35,
                function()
                    --[[
                      line: 2719
                      upvalues:
                        StatsFrame_upv_1 (copy, index: 1)
                    ]]
                    StatsFrame_upv_1.Visible = false
                end
            )
            closeTeamSelect()
            closeModeSelect()
            local TweenService_96 = game:GetService("TweenService")
            local v201 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_133 = {}
            tbl_133.Position = UDim2.new(0.5, 0, 1, 230)
            TweenService_96:Create(SkillFrame_upv_1, v201, tbl_133):Play()
            task.delay(
                0.35,
                function()
                    --[[
                      line: 2727
                      upvalues:
                        SkillFrame_upv_1 (copy, index: 1)
                    ]]
                    SkillFrame_upv_1.Visible = false
                end
            )
        end
        SettingsFrame_upv_1.Visible = not SettingsFrame_upv_1.Visible
    end
)
PickCategoryFrame_upv_1.MiscButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 2735
          upvalues:
            PickCategoryFrame_upv_1 (copy, index: 1)
            SettingsFrame_upv_1 (copy, index: 2)
        ]]
        local tbl_134 = {TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_1.MiscButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_134):Play()
        local tbl_135 = {TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_1.ControlsButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_135):Play()
        SettingsFrame_upv_1.MiscFrame.Visible = true
        SettingsFrame_upv_1.ControlsFrame.Visible = false
    end
)
PickCategoryFrame_upv_1.ControlsButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 2746
          upvalues:
            PickCategoryFrame_upv_1 (copy, index: 1)
            SettingsFrame_upv_1 (copy, index: 2)
        ]]
        local tbl_136 = {TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_1.ControlsButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_136):Play()
        local tbl_137 = {TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_1.MiscButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_137):Play()
        SettingsFrame_upv_1.ControlsFrame.Visible = true
        SettingsFrame_upv_1.MiscFrame.Visible = false
    end
)
SettingsFrame_upv_1.TitleFrame.CancelButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 2758
          upvalues:
            SettingsFrame_upv_1 (copy, index: 1)
        ]]
        SettingsFrame_upv_1.Visible = false
    end
)
local UserInputService_upv_1 = game:GetService("UserInputService")
function getTextForKey(a1)
    --[[
      name: getTextForKey
      line: 2763
      upvalues:
        UserInputService_upv_1 (copy, index: 1)
    ]]
    if a1 ~= Enum.KeyCode.LeftShift then
        if a1 ~= Enum.KeyCode.LeftControl then
            if a1 ~= Enum.KeyCode.LeftAlt then
                if a1 ~= Enum.KeyCode.RightShift then
                    if a1 ~= Enum.KeyCode.RightControl then
                        if a1 ~= Enum.KeyCode.RightAlt then
                            return UserInputService_upv_1:GetStringForKeyCode(a1)
                        end
                        return "R-ALT"
                    end
                    return "RCTRL"
                end
                return "RSHIFT"
            end
            return "L-ALT"
        end
        return "LCTRL"
    end
    return "LSHIFT"
end
ControlsFrame_upv_1.SkillBind.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.Skill.Value])
ControlsFrame_upv_1.TackleBind.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.SlideTackle.Value])
ControlsFrame_upv_1.ShoveBind.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.Shove.Value])
ControlsFrame_upv_1.MarkPassBind.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.MarkPass.Value])
ControlsFrame_upv_1.SprintBind.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.Sprint.Value])
ControlsFrame_upv_1.EmoteBind.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.Emote.Value])
ControlsFrame_upv_1.CurveLeft.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.CurveLeft.Value])
ControlsFrame_upv_1.CurveRight.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.CurveRight.Value])
ControlsFrame_upv_1.Topspin.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.Topspin.Value])
ControlsFrame_upv_1.DribbleLeft.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.DribbleLeft.Value])
ControlsFrame_upv_1.DribbleRight.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.DribbleRight.Value])
ControlsFrame_upv_1.controlledSprint.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.ControlSprint.Value])
local tbl_upv_138 = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.KeypadEnter, Enum.KeyCode.Return, Enum.KeyCode.Tab, Enum.KeyCode.CapsLock, Enum.KeyCode.Space, Enum.KeyCode.Backspace, Enum.KeyCode.BackSlash, Enum.KeyCode.LeftControl}
function handleBind(a1, a2)
    --[[
      name: handleBind
      line: 2808
      upvalues:
        SettingsFrame_upv_1 (copy, index: 1)
        UserInputService_upv_1 (copy, index: 2)
        tbl_upv_138 (copy, index: 3)
        u6 (copy, index: 4)
        Controls_upv_1 (copy, index: 5)
    ]]
    a1.Text = ""
    local tbl_139 = {TextTransparency = 0, TextStrokeTransparency = 0.65}
    game:GetService("TweenService"):Create(SettingsFrame_upv_1.BindLabel, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_139):Play()
    local u41 = false
    local u42 = nil
    local v202 = UserInputService_upv_1.InputBegan:Connect(
        function(a3)
            --[[
              line: 2815
              upvalues:
                tbl_upv_138 (copy, index: 1)
                a2 (copy, index: 2)
                u6 (copy, index: 3)
                u41 (ref,  index: 4)
                u42 (ref,  index: 5)
                SettingsFrame_upv_1 (copy, index: 6)
                a1 (copy, index: 7)
            ]]
            if a3.UserInputType ~= Enum.UserInputType.Keyboard then
                return
            end
            if table.find(tbl_upv_138, a3.KeyCode) then
                if a3.KeyCode ~= Enum.KeyCode.W and a3.KeyCode ~= Enum.KeyCode.D and a3.KeyCode ~= Enum.KeyCode.A and a3.KeyCode ~= Enum.KeyCode.S or a2 ~= "CurveLeft" and a2 ~= "CurveRight" and a2 ~= "Topspin" then
                    local tbl_140 = {TextTransparency = 0, TextStrokeTransparency = 0.65}
                    game:GetService("TweenService"):Create(SettingsFrame_upv_1.InvalidKeybindLabel, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_140):Play()
                    local v203 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
                    v203.Parent = game.Workspace
                    v203:Play()
                    game.Debris:AddItem(v203, 3)
                    task.delay(
                        0.85,
                        function()
                            --[[
                              line: 2837
                              upvalues:
                                SettingsFrame_upv_1 (copy, index: 1)
                            ]]
                            local tbl_141 = {TextTransparency = 1, TextStrokeTransparency = 1}
                            game:GetService("TweenService"):Create(SettingsFrame_upv_1.InvalidKeybindLabel, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_141):Play()
                        end
                    )
                    return
                end
                u6:FireServer(a2, a3.KeyCode)
                u41 = true
                u42:Disconnect()
                local tbl_142 = {TextTransparency = 1, TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(SettingsFrame_upv_1.BindLabel, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_142):Play()
            else
                u6:FireServer(a2, a3.KeyCode)
                u41 = true
                u42:Disconnect()
                local tbl_143 = {TextTransparency = 1, TextStrokeTransparency = 1}
                game:GetService("TweenService"):Create(SettingsFrame_upv_1.BindLabel, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_143):Play()
            end
            a1.Text = getTextForKey(a3.KeyCode)
        end
    )
    u42 = v202
    task.delay(
        4,
        function()
            --[[
              line: 2855
              upvalues:
                u41 (ref,  index: 1)
                a1 (copy, index: 2)
                Controls_upv_1 (copy, index: 3)
                a2 (copy, index: 4)
                u42 (ref,  index: 5)
                SettingsFrame_upv_1 (copy, index: 6)
            ]]
            if u41 == true then
                return
            end
            a1.Text = getTextForKey(Enum.KeyCode[Controls_upv_1:FindFirstChild(a2).Value])
            u42:Disconnect()
            local tbl_144 = {TextTransparency = 1, TextStrokeTransparency = 1}
            game:GetService("TweenService"):Create(SettingsFrame_upv_1.BindLabel, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_144):Play()
        end
    )
end
Controls_upv_1.Skill.Changed:Connect(
    function()
        --[[
          line: 2869
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
            Controls_upv_1 (copy, index: 2)
        ]]
        ControlsFrame_upv_1.SkillBind.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.Skill.Value])
    end
)
Controls_upv_1.SlideTackle.Changed:Connect(
    function()
        --[[
          line: 2873
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
            Controls_upv_1 (copy, index: 2)
        ]]
        ControlsFrame_upv_1.TackleBind.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.SlideTackle.Value])
    end
)
Controls_upv_1.Shove.Changed:Connect(
    function()
        --[[
          line: 2877
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
            Controls_upv_1 (copy, index: 2)
        ]]
        ControlsFrame_upv_1.ShoveBind.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.Shove.Value])
    end
)
Controls_upv_1.MarkPass.Changed:Connect(
    function()
        --[[
          line: 2881
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
            Controls_upv_1 (copy, index: 2)
        ]]
        ControlsFrame_upv_1.MarkPassBind.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.MarkPass.Value])
    end
)
Controls_upv_1.Sprint.Changed:Connect(
    function()
        --[[
          line: 2885
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
            Controls_upv_1 (copy, index: 2)
        ]]
        ControlsFrame_upv_1.SprintBind.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.Sprint.Value])
    end
)
Controls_upv_1.Emote.Changed:Connect(
    function()
        --[[
          line: 2889
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
            Controls_upv_1 (copy, index: 2)
        ]]
        ControlsFrame_upv_1.EmoteBind.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.Emote.Value])
    end
)
Controls_upv_1.CurveLeft.Changed:Connect(
    function()
        --[[
          line: 2893
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
            Controls_upv_1 (copy, index: 2)
        ]]
        ControlsFrame_upv_1.CurveLeft.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.CurveLeft.Value])
    end
)
Controls_upv_1.CurveRight.Changed:Connect(
    function()
        --[[
          line: 2897
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
            Controls_upv_1 (copy, index: 2)
        ]]
        ControlsFrame_upv_1.CurveRight.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.CurveRight.Value])
    end
)
Controls_upv_1.Topspin.Changed:Connect(
    function()
        --[[
          line: 2901
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
            Controls_upv_1 (copy, index: 2)
        ]]
        ControlsFrame_upv_1.Topspin.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.Topspin.Value])
    end
)
Controls_upv_1.DribbleLeft.Changed:Connect(
    function()
        --[[
          line: 2905
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
            Controls_upv_1 (copy, index: 2)
        ]]
        ControlsFrame_upv_1.DribbleLeft.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.DribbleLeft.Value])
    end
)
Controls_upv_1.DribbleRight.Changed:Connect(
    function()
        --[[
          line: 2909
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
            Controls_upv_1 (copy, index: 2)
        ]]
        ControlsFrame_upv_1.DribbleRight.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.DribbleRight.Value])
    end
)
Controls_upv_1.ControlSprint.Changed:Connect(
    function()
        --[[
          line: 2913
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
            Controls_upv_1 (copy, index: 2)
        ]]
        ControlsFrame_upv_1.controlledSprint.Key.Text = getTextForKey(Enum.KeyCode[Controls_upv_1.ControlSprint.Value])
    end
)
ControlsFrame_upv_1.SkillBind.Key.MouseButton1Click:Connect(
    function()
        --[[
          line: 2917
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
        ]]
        handleBind(ControlsFrame_upv_1.SkillBind.Key, "Skill")
    end
)
ControlsFrame_upv_1.TackleBind.Key.MouseButton1Click:Connect(
    function()
        --[[
          line: 2921
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
        ]]
        handleBind(ControlsFrame_upv_1.TackleBind.Key, "SlideTackle")
    end
)
ControlsFrame_upv_1.ShoveBind.Key.MouseButton1Click:Connect(
    function()
        --[[
          line: 2925
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
        ]]
        handleBind(ControlsFrame_upv_1.ShoveBind.Key, "Shove")
    end
)
ControlsFrame_upv_1.MarkPassBind.Key.MouseButton1Click:Connect(
    function()
        --[[
          line: 2929
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
        ]]
        handleBind(ControlsFrame_upv_1.MarkPassBind.Key, "MarkPass")
    end
)
ControlsFrame_upv_1.SprintBind.Key.MouseButton1Click:Connect(
    function()
        --[[
          line: 2933
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
        ]]
        handleBind(ControlsFrame_upv_1.SprintBind.Key, "Sprint")
    end
)
ControlsFrame_upv_1.EmoteBind.Key.MouseButton1Click:Connect(
    function()
        --[[
          line: 2937
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
        ]]
        handleBind(ControlsFrame_upv_1.EmoteBind.Key, "Emote")
    end
)
ControlsFrame_upv_1.CurveLeft.Key.MouseButton1Click:Connect(
    function()
        --[[
          line: 2941
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
        ]]
        handleBind(ControlsFrame_upv_1.CurveLeft.Key, "CurveLeft")
    end
)
ControlsFrame_upv_1.CurveRight.Key.MouseButton1Click:Connect(
    function()
        --[[
          line: 2945
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
        ]]
        handleBind(ControlsFrame_upv_1.CurveRight.Key, "CurveRight")
    end
)
ControlsFrame_upv_1.Topspin.Key.MouseButton1Click:Connect(
    function()
        --[[
          line: 2949
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
        ]]
        handleBind(ControlsFrame_upv_1.Topspin.Key, "Topspin")
    end
)
ControlsFrame_upv_1.DribbleLeft.Key.MouseButton1Click:Connect(
    function()
        --[[
          line: 2953
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
        ]]
        handleBind(ControlsFrame_upv_1.DribbleLeft.Key, "DribbleLeft")
    end
)
ControlsFrame_upv_1.DribbleRight.Key.MouseButton1Click:Connect(
    function()
        --[[
          line: 2957
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
        ]]
        handleBind(ControlsFrame_upv_1.DribbleRight.Key, "DribbleRight")
    end
)
ControlsFrame_upv_1.controlledSprint.Key.MouseButton1Click:Connect(
    function()
        --[[
          line: 2961
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
        ]]
        handleBind(ControlsFrame_upv_1.controlledSprint.Key, "ControlSprint")
    end
)
ControlsFrame_upv_1.RELEASE.Toggle.MouseButton1Click:Connect(
    function()
        --[[
          line: 2965
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
            Controls_upv_1 (copy, index: 2)
            u5 (copy, index: 3)
        ]]
        toggle(ControlsFrame_upv_1.RELEASE, not Controls_upv_1.ReleaseDive.Value)
        u5:FireServer("ReleaseDive", not Controls_upv_1.ReleaseDive.Value)
    end
)
ControlsFrame_upv_1.FLIP.Toggle.MouseButton1Click:Connect(
    function()
        --[[
          line: 2970
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
            Controls_upv_1 (copy, index: 2)
            u5 (copy, index: 3)
        ]]
        toggle(ControlsFrame_upv_1.FLIP, not Controls_upv_1.Flipped.Value)
        u5:FireServer("Flipped", not Controls_upv_1.Flipped.Value)
    end
)
ControlsFrame_upv_1.ToggleSpin.Toggle.MouseButton1Click:Connect(
    function()
        --[[
          line: 2975
          upvalues:
            ControlsFrame_upv_1 (copy, index: 1)
            Controls_upv_1 (copy, index: 2)
            u5 (copy, index: 3)
        ]]
        toggle(ControlsFrame_upv_1.ToggleSpin, not Controls_upv_1.SpinToggle.Value)
        u5:FireServer("SpinToggle", not Controls_upv_1.SpinToggle.Value)
    end
)
local MAP_1 = MiscFrame_upv_1.MAP
local Map_upv_1 = MAP_1.Map
local DropdownArrow_upv_1 = Map_upv_1.DropdownArrow
local Dropdown_upv_1 = MAP_1.Dropdown
for _, value_upv_55 in pairs(game.ReplicatedStorage.SelectableMaps:GetChildren()) do
    local v204 = script.mapButtonTemplate:Clone()
    v204.Text = string.upper(value_upv_55.Name)
    v204.Parent = Dropdown_upv_1
    v204.MouseButton1Click:Connect(
        function()
            --[[
              line: 2994
              upvalues:
                u5 (copy, index: 1)
                value_upv_55 (copy, index: 2)
                Map_upv_1 (copy, index: 3)
                Dropdown_upv_1 (copy, index: 4)
                DropdownArrow_upv_1 (copy, index: 5)
            ]]
            u5:FireServer("MapSelection", value_upv_55.Name)
            Map_upv_1.Text = string.upper(value_upv_55.Name)
            Dropdown_upv_1.Visible = false
            DropdownArrow_upv_1.Rotation = 180
        end
    )
end
Map_upv_1.Text = string.upper(Misc_upv_1.MapSelection.Value)
Map_upv_1.MouseButton1Click:Connect(
    function()
        --[[
          line: 3004
          upvalues:
            Dropdown_upv_1 (copy, index: 1)
            DropdownArrow_upv_1 (copy, index: 2)
        ]]
        if Dropdown_upv_1.Visible ~= true then
            DropdownArrow_upv_1.Rotation = 0
            Dropdown_upv_1.Visible = true
        else
            Dropdown_upv_1.Visible = false
            DropdownArrow_upv_1.Rotation = 180
        end
    end
)
local GRASS_1 = MiscFrame_upv_1.GRASS
local Grass_upv_1 = GRASS_1.Grass
local DropdownArrow_upv_2 = Grass_upv_1.DropdownArrow
local Dropdown_upv_2 = GRASS_1.Dropdown
for _, value_upv_56 in pairs(game.ReplicatedStorage.SelectableGrass:GetChildren()) do
    local v205 = script.mapButtonTemplate:Clone()
    v205.Text = string.upper(value_upv_56.Name)
    v205.Parent = Dropdown_upv_2
    v205.MouseButton1Click:Connect(
        function()
            --[[
              line: 3026
              upvalues:
                u5 (copy, index: 1)
                value_upv_56 (copy, index: 2)
                Grass_upv_1 (copy, index: 3)
                Dropdown_upv_2 (copy, index: 4)
                DropdownArrow_upv_2 (copy, index: 5)
            ]]
            u5:FireServer("GrassSelection", value_upv_56.Name)
            Grass_upv_1.Text = string.upper(value_upv_56.Name)
            Dropdown_upv_2.Visible = false
            DropdownArrow_upv_2.Rotation = 180
        end
    )
end
Grass_upv_1.Text = string.upper(Misc_upv_1.GrassSelection.Value)
Grass_upv_1.MouseButton1Click:Connect(
    function()
        --[[
          line: 3036
          upvalues:
            Dropdown_upv_2 (copy, index: 1)
            DropdownArrow_upv_2 (copy, index: 2)
        ]]
        if Dropdown_upv_2.Visible ~= true then
            DropdownArrow_upv_2.Rotation = 0
            Dropdown_upv_2.Visible = true
        else
            Dropdown_upv_2.Visible = false
            DropdownArrow_upv_2.Rotation = 180
        end
    end
)
local POV_1 = MiscFrame_upv_1.POV
local POV_upv_2 = POV_1.POV
local DropdownArrow_upv_3 = POV_upv_2.DropdownArrow
local Dropdown_upv_3 = POV_1.Dropdown
for _, value_upv_57 in pairs(Dropdown_upv_3:GetChildren()) do
    if value_upv_57:IsA("TextButton") then
        value_upv_57.MouseButton1Click:Connect(
            function()
                --[[
                  line: 3054
                  upvalues:
                    u5 (copy, index: 1)
                    value_upv_57 (copy, index: 2)
                    POV_upv_2 (copy, index: 3)
                    Dropdown_upv_3 (copy, index: 4)
                    DropdownArrow_upv_3 (copy, index: 5)
                ]]
                u5:FireServer("POV", value_upv_57.Name)
                POV_upv_2.Text = string.upper(value_upv_57.Name)
                Dropdown_upv_3.Visible = false
                DropdownArrow_upv_3.Rotation = 180
            end
        )
    end
end
POV_upv_2.Text = string.upper(Misc_upv_1.POV.Value)
POV_upv_2.MouseButton1Click:Connect(
    function()
        --[[
          line: 3066
          upvalues:
            Dropdown_upv_3 (copy, index: 1)
            DropdownArrow_upv_3 (copy, index: 2)
        ]]
        if Dropdown_upv_3.Visible ~= true then
            DropdownArrow_upv_3.Rotation = 0
            Dropdown_upv_3.Visible = true
        else
            Dropdown_upv_3.Visible = false
            DropdownArrow_upv_3.Rotation = 180
        end
    end
)
local StoreFrame_upv_1 = script.Parent.StoreFrame
local DailyShopFrame_upv_1 = StoreFrame_upv_1.DailyShopFrame
local AnimationsFrame_upv_1 = StoreFrame_upv_1.AnimationsFrame
local CosmeticsFrame_upv_1 = StoreFrame_upv_1.CosmeticsFrame
local RobuxShopFrame_upv_1 = StoreFrame_upv_1.RobuxShopFrame
local PickCategoryFrame_upv_2 = StoreFrame_upv_1.PickCategoryFrame
local PopupContainer_upv_1 = StoreFrame_upv_1.PopupContainer
MenuButtons_upv_1.StoreButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 3086
          upvalues:
            StoreFrame_upv_1 (copy, index: 1)
        ]]
        StoreFrame_upv_1.Visible = not StoreFrame_upv_1.Visible
    end
)
StoreFrame_upv_1.TitleFrame.CancelButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 3090
          upvalues:
            StoreFrame_upv_1 (copy, index: 1)
        ]]
        StoreFrame_upv_1.Visible = false
    end
)
PickCategoryFrame_upv_2.CosmeticsButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 3094
          upvalues:
            PickCategoryFrame_upv_2 (copy, index: 1)
            AnimationsFrame_upv_1 (copy, index: 2)
            CosmeticsFrame_upv_1 (copy, index: 3)
            RobuxShopFrame_upv_1 (copy, index: 4)
            StoreFrame_upv_1 (copy, index: 5)
            DailyShopFrame_upv_1 (copy, index: 6)
        ]]
        local tbl_145 = {TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_2.CosmeticsButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_145):Play()
        local tbl_146 = {TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_2.AnimationsButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_146):Play()
        local tbl_147 = {TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_2.DailyShopButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_147):Play()
        local tbl_148 = {TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_2.RobuxShopButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_148):Play()
        AnimationsFrame_upv_1.Visible = false
        CosmeticsFrame_upv_1.Visible = true
        RobuxShopFrame_upv_1.Visible = false
        StoreFrame_upv_1.GiftRecipient.Visible = false
        DailyShopFrame_upv_1.Visible = false
        StoreFrame_upv_1.CrateInfo.Visible = true
    end
)
PickCategoryFrame_upv_2.AnimationsButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 3115
          upvalues:
            PickCategoryFrame_upv_2 (copy, index: 1)
            AnimationsFrame_upv_1 (copy, index: 2)
            CosmeticsFrame_upv_1 (copy, index: 3)
            RobuxShopFrame_upv_1 (copy, index: 4)
            StoreFrame_upv_1 (copy, index: 5)
            DailyShopFrame_upv_1 (copy, index: 6)
        ]]
        local tbl_149 = {TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_2.AnimationsButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_149):Play()
        local tbl_150 = {TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_2.CosmeticsButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_150):Play()
        local tbl_151 = {TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_2.DailyShopButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_151):Play()
        local tbl_152 = {TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_2.RobuxShopButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_152):Play()
        AnimationsFrame_upv_1.Visible = true
        CosmeticsFrame_upv_1.Visible = false
        RobuxShopFrame_upv_1.Visible = false
        StoreFrame_upv_1.GiftRecipient.Visible = false
        DailyShopFrame_upv_1.Visible = false
        StoreFrame_upv_1.CrateInfo.Visible = true
    end
)
PickCategoryFrame_upv_2.DailyShopButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 3136
          upvalues:
            PickCategoryFrame_upv_2 (copy, index: 1)
            AnimationsFrame_upv_1 (copy, index: 2)
            CosmeticsFrame_upv_1 (copy, index: 3)
            RobuxShopFrame_upv_1 (copy, index: 4)
            StoreFrame_upv_1 (copy, index: 5)
            DailyShopFrame_upv_1 (copy, index: 6)
        ]]
        local tbl_153 = {TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_2.CosmeticsButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_153):Play()
        local tbl_154 = {TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_2.AnimationsButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_154):Play()
        local tbl_155 = {TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_2.DailyShopButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_155):Play()
        local tbl_156 = {TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_2.RobuxShopButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_156):Play()
        AnimationsFrame_upv_1.Visible = false
        CosmeticsFrame_upv_1.Visible = false
        RobuxShopFrame_upv_1.Visible = false
        StoreFrame_upv_1.GiftRecipient.Visible = false
        DailyShopFrame_upv_1.Visible = true
        StoreFrame_upv_1.CrateInfo.Visible = false
    end
)
PickCategoryFrame_upv_2.RobuxShopButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 3157
          upvalues:
            PickCategoryFrame_upv_2 (copy, index: 1)
            AnimationsFrame_upv_1 (copy, index: 2)
            CosmeticsFrame_upv_1 (copy, index: 3)
            RobuxShopFrame_upv_1 (copy, index: 4)
            StoreFrame_upv_1 (copy, index: 5)
            DailyShopFrame_upv_1 (copy, index: 6)
        ]]
        local tbl_157 = {TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_2.CosmeticsButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_157):Play()
        local tbl_158 = {TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_2.AnimationsButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_158):Play()
        local tbl_159 = {TextStrokeTransparency = 1}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_2.DailyShopButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_159):Play()
        local tbl_160 = {TextStrokeTransparency = 0.5}
        game:GetService("TweenService"):Create(PickCategoryFrame_upv_2.RobuxShopButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_160):Play()
        AnimationsFrame_upv_1.Visible = false
        CosmeticsFrame_upv_1.Visible = false
        RobuxShopFrame_upv_1.Visible = true
        StoreFrame_upv_1.GiftRecipient.Visible = true
        DailyShopFrame_upv_1.Visible = false
        StoreFrame_upv_1.CrateInfo.Visible = false
    end
)
function getDailyShop()
    --[[
      name: getDailyShop
      line: 3177
      upvalues:
        u14 (copy, index: 1)
        ItemInfo_upv_1 (copy, index: 2)
        DailyShopFrame_upv_1 (copy, index: 3)
    ]]
    local v206 = u14:InvokeServer()
    local v207 = ItemInfo_upv_1:FindFirstChild(v206.Legendary)
    DailyShopFrame_upv_1.Legendary.itemNameVal.Value = v207.Name
    DailyShopFrame_upv_1.Legendary.itemIcon.Image = v207.itemIcon.Texture
    DailyShopFrame_upv_1.Legendary.ItemName.Text = string.upper(v207.Name)
    local v208 = ItemInfo_upv_1:FindFirstChild(v206.Epic1)
    DailyShopFrame_upv_1.Epic1.itemNameVal.Value = v208.Name
    DailyShopFrame_upv_1.Epic1.itemIcon.Image = v208.itemIcon.Texture
    DailyShopFrame_upv_1.Epic1.ItemName.Text = string.upper(v208.Name)
    local v209 = ItemInfo_upv_1:FindFirstChild(v206.Epic2)
    DailyShopFrame_upv_1.Epic2.itemNameVal.Value = v209.Name
    DailyShopFrame_upv_1.Epic2.itemIcon.Image = v209.itemIcon.Texture
    DailyShopFrame_upv_1.Epic2.ItemName.Text = string.upper(v209.Name)
    local v210 = ItemInfo_upv_1:FindFirstChild(v206.Rare1)
    DailyShopFrame_upv_1.Rare1.itemNameVal.Value = v210.Name
    DailyShopFrame_upv_1.Rare1.itemIcon.Image = v210.itemIcon.Texture
    DailyShopFrame_upv_1.Rare1.ItemName.Text = string.upper(v210.Name)
    local v211 = ItemInfo_upv_1:FindFirstChild(v206.Rare2)
    DailyShopFrame_upv_1.Rare2.itemNameVal.Value = v211.Name
    DailyShopFrame_upv_1.Rare2.itemIcon.Image = v211.itemIcon.Texture
    DailyShopFrame_upv_1.Rare2.ItemName.Text = string.upper(v211.Name)
    local v212 = ItemInfo_upv_1:FindFirstChild(v206.Rare3)
    DailyShopFrame_upv_1.Rare3.itemNameVal.Value = v212.Name
    DailyShopFrame_upv_1.Rare3.itemIcon.Image = v212.itemIcon.Texture
    DailyShopFrame_upv_1.Rare3.ItemName.Text = string.upper(v212.Name)
end
getDailyShop()
v1:GetKey("UpdateDailyShop").OnClientEvent:Connect(getDailyShop)
local u43 = ""
PopupContainer_upv_1.YesButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 3216
          upvalues:
            u43 (ref,  index: 1)
            u15 (copy, index: 2)
            PopupContainer_upv_1 (copy, index: 3)
        ]]
        if u43 ~= "" then
            local v213 = u15:InvokeServer(u43)
            PopupContainer_upv_1.Visible = false
            if v213 == "AlreadyOwned" then
                notification("ITEM ALREADY OWNED.")
            elseif v213 == "NotEnoughCoins" then
                notification("NOT ENOUGH COINS.")
            elseif v213 ~= "Failed" then
                local v214 = game.ReplicatedStorage.UISounds.mvm_money_pickup:Clone()
                v214.Parent = game.Workspace
                v214:Play()
                game.Debris:AddItem(v214, 3)
                if u43 ~= "A RANDOM AURA" and u43 ~= "A RANDOM EYE" and u43 ~= "A RANDOM CELEBRATION" then
                    local v215 = game.ReplicatedStorage.UISounds.Item_Box_Get2:Clone()
                    v215.Parent = game.Workspace
                    v215:Play()
                    game.Debris:AddItem(v215, 3)
                end
            else
                notification("AN UNEXPECTED ERROR HAS OCCURED.")
            end
            u43 = ""
        end
    end
)
PopupContainer_upv_1.NoButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 3243
          upvalues:
            u43 (ref,  index: 1)
            PopupContainer_upv_1 (copy, index: 2)
        ]]
        if u43 == "" then
            return
        end
        u43 = ""
        PopupContainer_upv_1.Visible = false
    end
)
function popup(a1, a2)
    --[[
      name: popup
      line: 3250
      upvalues:
        u43 (ref,  index: 1)
        PopupContainer_upv_1 (copy, index: 2)
    ]]
    u43 = a1
    PopupContainer_upv_1.PurchaseText.Text = "WOULD YOU LIKE TO PURCHASE [" .. string.upper(u43) .. "] FOR " .. a2 .. " COINS?"
    PopupContainer_upv_1.Visible = true
end
AnimationsFrame_upv_1.Barou.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3256
        ]]
        popup("Determined  Striker Animations", "100.0K")
    end
)
AnimationsFrame_upv_1.Rin.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3260
        ]]
        popup("Destructive Striker Animations", "100.0K")
    end
)
AnimationsFrame_upv_1.Shidou.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3264
        ]]
        popup("Sporadic Striker Animations", "100.0K")
    end
)
AnimationsFrame_upv_1.Isagi.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3268
        ]]
        popup("Ordinary Striker Animations", "50.0K")
    end
)
AnimationsFrame_upv_1.Bachira.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3272
        ]]
        popup("Freestyle Striker Animations", "100.0K")
    end
)
AnimationsFrame_upv_1.Gagamaru.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3276
        ]]
        popup("Athletic Keeper Animations", "80.0K")
    end
)
AnimationsFrame_upv_1.Nagi.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3280
        ]]
        popup("Lazy Genius Animations", "80.0K")
    end
)
AnimationsFrame_upv_1.PolishStriker.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3284
        ]]
        popup("Polish Striker Animations", "100.0K")
    end
)
AnimationsFrame_upv_1.BrazillianWizard.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3288
        ]]
        popup("Brazillian Wizard Animations", "100.0K")
    end
)
AnimationsFrame_upv_1.ArgentinaKeeper.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3292
        ]]
        popup("Argentina Keeper Animations", "75.0K")
    end
)
DailyShopFrame_upv_1.Legendary.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3296
          upvalues:
            DailyShopFrame_upv_1 (copy, index: 1)
        ]]
        popup(DailyShopFrame_upv_1.Legendary.itemNameVal.Value, "50.0K")
    end
)
DailyShopFrame_upv_1.Epic1.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3300
          upvalues:
            DailyShopFrame_upv_1 (copy, index: 1)
        ]]
        popup(DailyShopFrame_upv_1.Epic1.itemNameVal.Value, "20.0K")
    end
)
DailyShopFrame_upv_1.Epic2.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3304
          upvalues:
            DailyShopFrame_upv_1 (copy, index: 1)
        ]]
        popup(DailyShopFrame_upv_1.Epic2.itemNameVal.Value, "20.0K")
    end
)
DailyShopFrame_upv_1.Rare1.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3308
          upvalues:
            DailyShopFrame_upv_1 (copy, index: 1)
        ]]
        popup(DailyShopFrame_upv_1.Rare1.itemNameVal.Value, "5.0K")
    end
)
DailyShopFrame_upv_1.Rare2.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3312
          upvalues:
            DailyShopFrame_upv_1 (copy, index: 1)
        ]]
        popup(DailyShopFrame_upv_1.Rare2.itemNameVal.Value, "5.0K")
    end
)
DailyShopFrame_upv_1.Rare3.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3316
          upvalues:
            DailyShopFrame_upv_1 (copy, index: 1)
        ]]
        popup(DailyShopFrame_upv_1.Rare3.itemNameVal.Value, "5.0K")
    end
)
CosmeticsFrame_upv_1.ScoreAuras.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3320
        ]]
        popup("A RANDOM AURA", "3.0K")
    end
)
CosmeticsFrame_upv_1.MVPEyes.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3324
        ]]
        popup("A RANDOM EYE", "3.0K")
    end
)
CosmeticsFrame_upv_1.Celebrations.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3328
        ]]
        popup("A RANDOM CELEBRATION", "3.0K")
    end
)
CosmeticsFrame_upv_1.GoalieGloves.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3332
        ]]
        popup("A RANDOM GLOVE", "3.0K")
    end
)
u7.OnClientEvent:Connect(
    function()
        --[[
          line: 3336
        ]]
        local v216 = game.ReplicatedStorage.UISounds.mvm_money_pickup:Clone()
        v216.Parent = game.Workspace
        v216:Play()
        game.Debris:AddItem(v216, 3)
        local v217 = game.ReplicatedStorage.UISounds.Item_Box_Get2:Clone()
        v217.Parent = game.Workspace
        v217:Play()
        game.Debris:AddItem(v217, 3)
    end
)
StoreFrame_upv_1.GiftRecipient.FocusLost:Connect(
    function()
        --[[
          line: 3347
          upvalues:
            StoreFrame_upv_1 (copy, index: 1)
        ]]
        local Text_1 = StoreFrame_upv_1.GiftRecipient.Text
        for _, value_58 in pairs(game.Players:GetPlayers()) do
            if string.sub(value_58.Name, 0, #Text_1) ~= Text_1 then
                continue
            end
            StoreFrame_upv_1.GiftRecipient.Text = value_58.Name
            return
        end
        StoreFrame_upv_1.GiftRecipient.Text = ""
    end
)
RobuxShopFrame_upv_1.Coins1.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3358
          upvalues:
            u7 (copy, index: 1)
            StoreFrame_upv_1 (copy, index: 2)
        ]]
        u7:FireServer("Coin1", StoreFrame_upv_1.GiftRecipient.Text)
    end
)
RobuxShopFrame_upv_1["Jersey Sponsers"].Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3362
          upvalues:
            u7 (copy, index: 1)
            StoreFrame_upv_1 (copy, index: 2)
        ]]
        u7:FireServer("Jersery Sponsers", StoreFrame_upv_1.GiftRecipient.Text)
    end
)
RobuxShopFrame_upv_1.Coins2.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3366
          upvalues:
            u7 (copy, index: 1)
            StoreFrame_upv_1 (copy, index: 2)
        ]]
        u7:FireServer("Coin2", StoreFrame_upv_1.GiftRecipient.Text)
    end
)
RobuxShopFrame_upv_1.Coins3.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3370
          upvalues:
            u7 (copy, index: 1)
            StoreFrame_upv_1 (copy, index: 2)
        ]]
        u7:FireServer("Coin3", StoreFrame_upv_1.GiftRecipient.Text)
    end
)
RobuxShopFrame_upv_1.Coins4.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3374
          upvalues:
            u7 (copy, index: 1)
            StoreFrame_upv_1 (copy, index: 2)
        ]]
        u7:FireServer("Coin4", StoreFrame_upv_1.GiftRecipient.Text)
    end
)
RobuxShopFrame_upv_1.SkipRolls.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3378
          upvalues:
            u7 (copy, index: 1)
            StoreFrame_upv_1 (copy, index: 2)
        ]]
        u7:FireServer("skipRolls", StoreFrame_upv_1.GiftRecipient.Text)
    end
)
RobuxShopFrame_upv_1.FilmMaker.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3382
          upvalues:
            u7 (copy, index: 1)
            StoreFrame_upv_1 (copy, index: 2)
        ]]
        u7:FireServer("filmMaker", StoreFrame_upv_1.GiftRecipient.Text)
    end
)
RobuxShopFrame_upv_1.PreferredJerseyNumber.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3386
          upvalues:
            u7 (copy, index: 1)
            StoreFrame_upv_1 (copy, index: 2)
        ]]
        u7:FireServer("prefNumber", StoreFrame_upv_1.GiftRecipient.Text)
    end
)
RobuxShopFrame_upv_1.AccessoryColor.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3390
          upvalues:
            u7 (copy, index: 1)
            StoreFrame_upv_1 (copy, index: 2)
        ]]
        u7:FireServer("customAccessoryColor", StoreFrame_upv_1.GiftRecipient.Text)
    end
)
RobuxShopFrame_upv_1.PSPlus.Purchase.MouseButton1Click:Connect(
    function()
        --[[
          line: 3394
          upvalues:
            u7 (copy, index: 1)
            StoreFrame_upv_1 (copy, index: 2)
        ]]
        u7:FireServer("PS+", StoreFrame_upv_1.GiftRecipient.Text)
    end
)
local CodesFrame_upv_1 = script.Parent.CodesFrame
MenuButtons_upv_1.CodesButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 3402
          upvalues:
            CodesFrame_upv_1 (copy, index: 1)
        ]]
        CodesFrame_upv_1.Visible = not CodesFrame_upv_1.Visible
    end
)
CodesFrame_upv_1.CancelButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 3406
          upvalues:
            CodesFrame_upv_1 (copy, index: 1)
        ]]
        CodesFrame_upv_1.Visible = false
    end
)
local CodeBox_upv_1 = CodesFrame_upv_1.CodeBox
function showMessage(a1)
    --[[
      name: showMessage
      line: 3413
      upvalues:
        CodeBox_upv_1 (copy, index: 1)
    ]]
    CodeBox_upv_1.PlaceholderText = a1
    task.delay(
        1,
        function()
            --[[
              line: 3415
              upvalues:
                CodeBox_upv_1 (copy, index: 1)
            ]]
            CodeBox_upv_1.PlaceholderText = "ENTER CODE"
        end
    )
end
local u44 = false
CodeBox_upv_1.FocusLost:Connect(
    function()
        --[[
          line: 3420
          upvalues:
            CodeBox_upv_1 (copy, index: 1)
            u44 (ref,  index: 2)
            u16 (copy, index: 3)
        ]]
        if not (#CodeBox_upv_1.Text > 0) then
            return
        end
        if u44 == false then
            u44 = true
            task.delay(
                0.5,
                function()
                    --[[
                      line: 3423
                      upvalues:
                        u44 (ref, index: 1)
                    ]]
                    u44 = false
                end
            )
            local v218 = u16:InvokeServer(CodeBox_upv_1.Text)
            CodeBox_upv_1.Text = ""
            if v218 == "codeExpired" then
                showMessage("CODE HAS EXPIRED.")
                local v219 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
                v219.Parent = game.Workspace
                v219:Play()
                game.Debris:AddItem(v219, 3)
            elseif v218 == "codeSubmitted" then
                showMessage("CODE SUBMITTED. ENJOY!")
                local v220 = game.ReplicatedStorage.UISounds.mvm_money_pickup:Clone()
                v220.Parent = game.Workspace
                v220:Play()
                game.Debris:AddItem(v220, 3)
            elseif v218 == "codeInUse" then
                showMessage("CODE HAS ALREADY BEEN USED.")
                local v221 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
                v221.Parent = game.Workspace
                v221:Play()
                game.Debris:AddItem(v221, 3)
            elseif v218 ~= "promptGroup" then
                showMessage("CODE NOT FOUND.")
                local v222 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
                v222.Parent = game.Workspace
                v222:Play()
                game.Debris:AddItem(v222, 3)
            else
                showMessage("JOIN THE GROUP TO USE CODES!!")
                local v223 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
                v223.Parent = game.Workspace
                v223:Play()
                game.Debris:AddItem(v223, 3)
                game.GroupService:PromptJoinAsync(33283788)
            end
        end
    end
)
local function checkIsWeekend()
    --[[
      name: checkIsWeekend
      line: 3465
    ]]
    local wday_1 = os.date("!*t").wday
    if wday_1 ~= 1 and wday_1 ~= 6 and wday_1 ~= 7 then
        return false
    end
    return true
end
local wday_2 = os.date("!*t").wday
local v224
if wday_2 ~= 1 and wday_2 ~= 6 and wday_2 ~= 7 then
    v224 = false
else
    v224 = true
end
if v224 then
    script.Parent["2xcoins"].Visible = true
else
    script.Parent["2xcoins"].Visible = false
end
task.spawn(
    function()
        --[[
          line: 3480
        ]]
        while wait(30) do
            local wday_3 = os.date("!*t").wday
            local v225
            if wday_3 ~= 1 and wday_3 ~= 6 and wday_3 ~= 7 then
                v225 = false
            else
                v225 = true
            end
            if v225 then
                script.Parent["2xcoins"].Visible = true
            else
                script.Parent["2xcoins"].Visible = false
            end
        end
    end
)
LeftFrame_1.HelpButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 3490
        ]]
        script.Parent.HelpFrame.Visible = not script.Parent.HelpFrame.Visible
    end
)
LeftFrame_1.UpdateLogButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 3494
        ]]
        script.Parent.UpdateLog.Visible = not script.Parent.UpdateLog.Visible
    end
)