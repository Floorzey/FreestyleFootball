--[[
    Script Path: Game/ReplicatedStorage/Modules/client/club
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local tbl_1 = {}
repeat
    task.wait()
until game:IsLoaded()
local LocalPlayer_upv_1 = game.Players.LocalPlayer
local PlayerGui_upv_1 = LocalPlayer_upv_1.PlayerGui
local u1 = LocalPlayer_upv_1.Character or (LocalPlayer_upv_1.CharacterAdded:Wait())
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
local v1 = Knit_1.GetService("KeyHandlerService")
local u2 = v1:GetKey("clubCreate")
local u3 = v1:GetKey("getAttributePoints")
local _ = v1:GetKey("getPosStats")
LocalPlayer_upv_1.CharacterAdded:Connect(
    function(a1)
        --[[
          line: 16
          upvalues:
            u1 (ref, index: 1)
        ]]
        u1 = a1
    end
)
local u4 = nil
local u5 = false
local u6 = {}
local tbl_upv_2 = {}
local tbl_upv_3 = {}
function getRank(a1)
    --[[
      name: getRank
      line: 34
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
      line: 52
    ]]
    local tbl_4 = {}
    for _, value_1 in pairs(a1) do
        table.insert(tbl_4, value_1)
    end
    table.sort(tbl_4)
    if #tbl_4 % 2 ~= 0 then
        return tbl_4[math.ceil(#tbl_4 / 2)]
    end
    return (tbl_4[#tbl_4 / 2] + tbl_4[(#tbl_4 / 2) + 1]) / 2
end
function comma_value(a1)
    --[[
      name: comma_value
      line: 68
    ]]
    local v2 = a1
    local v3
    repeat
        local v4
        v4, v3 = string.gsub(v2, "^(-?%d+)(%d%d%d)", "%1,%2")
        v2 = v4
    until v3 == 0
    return v2
end
local function GetHighest(a1)
    --[[
      name: GetHighest
      line: 80
    ]]
    local v5 = 0
    for _, value_2 in ipairs(a1) do
        if v5 < value_2 then
            v5 = value_2
        end
    end
    return v5
end
function pointsLogorithmicToRating(a1)
    --[[
      name: pointsLogorithmicToRating
      line: 91
    ]]
    local v6 = 0
    v6 = nil
    repeat
        a1 = a1 - v6 * 2.5
        v6 = v6 + 1
    until a1 - v6 < 0
    v6 = v6 - 1
    v6 = ((v6 > 99) and 99) or v6
    if v6 < 0 then
        v6 = 0
    end
    return v6
end
local function calcPlayerValue(a1)
    --[[
      name: calcPlayerValue
      line: 103
      upvalues:
        u3 (copy, index: 1)
    ]]
    local v7 = u3:InvokeServer("Overall")
    local tbl_5 = {}
    for _, value_3 in pairs(v7.STR) do
        table.insert(tbl_5, pointsLogorithmicToRating(value_3))
    end
    local v8 = getMedian(tbl_5)
    local tbl_6 = {}
    for _, value_4 in pairs(v7.MID) do
        table.insert(tbl_6, pointsLogorithmicToRating(value_4))
    end
    local v9 = getMedian(tbl_6)
    local tbl_7 = {}
    for _, value_5 in pairs(v7.DEF) do
        table.insert(tbl_7, pointsLogorithmicToRating(value_5))
    end
    local v10 = getMedian(tbl_7)
    local tbl_8 = {}
    for _, value_6 in pairs(v7.KPR) do
        table.insert(tbl_8, pointsLogorithmicToRating(value_6))
    end
    local v11 = {v8, v9, v10, getMedian(tbl_8)}
    local v13 = 0
    for _, value_7 in ipairs(v11) do
        if v13 < value_7 then
            v13 = value_7
        end
    end
    local v14 = getRank(v13)
    v11 = 1
    if v14 == "D" then
        v11 = 4
    elseif v14 == "C" then
        v11 = 12
    elseif v14 == "B" then
        v11 = 36
    elseif v14 == "A" then
        v11 = 108
    elseif v14 == "S" then
        v11 = 216
    elseif v14 == "SS" then
        v11 = 324
    end
    return "$" .. comma_value(math.floor((((((0 + ((a1.Data.Wins.Value * 100) * v11)) + ((a1.Data.Goals.Value * 50) * v11)) + ((a1.Data.Assists.Value * 40) * v11)) + ((a1.Data.Passes.Value * 20) * v11)) + ((a1.Data.Tackles.Value * 25) * v11)) + ((a1.Data.Saves.Value * 75) * v11)))
end
function displayPlayerStats(a1, a2)
    --[[
      name: displayPlayerStats
      line: 157
      upvalues:
        u4 (ref,  index: 1)
        tbl_upv_3 (copy, index: 2)
        PlayerGui_upv_1 (copy, index: 3)
        u6 (ref,  index: 4)
    ]]
    if u4 ~= a1 and u4 ~= nil then
        for key_1 in tbl_upv_3 do
            key_1:Disconnect()
        end
    end
    u4 = a1
    local LeftFrame_1 = PlayerGui_upv_1.Menu.ClubFrame.container.ClubRosterFrame.LeftFrame
    LeftFrame_1.plrName.Text = string.upper(a1)
    LeftFrame_1.plrIcon.Image = game.Players:GetUserThumbnailAsync(u6[a1].UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    LeftFrame_1.Description.Text = a2 or ""
end
local function displayPlayersAndRank()
    --[[
      name: displayPlayersAndRank
      line: 178
      upvalues:
        u5 (ref,  index: 1)
        PlayerGui_upv_1 (copy, index: 2)
        u6 (ref,  index: 3)
        tbl_upv_2 (copy, index: 4)
    ]]
    if u5 then
        return
    end
    u5 = true
    print("Maybe?")
    local ClubFrame_1 = PlayerGui_upv_1:WaitForChild("Menu"):WaitForChild("ClubFrame")
    print("Maybe2?")
    local container_1 = ClubFrame_1:WaitForChild("container")
    local ClubRosterFrame_1 = container_1:WaitForChild("ClubRosterFrame")
    container_1.ClubCreateFrame.Visible = false
    ClubFrame_1.CreateClubButton.Visible = false
    ClubFrame_1.JoinClubButton.Visible = false
    print(u6)
    for key_2, value_8 in u6 do
        print("should do it")
        local v15 = ClubRosterFrame_1.ScrollFrame.ScrollingFrame.Template:Clone()
        v15.Parent = ClubRosterFrame_1.ScrollFrame.ScrollingFrame
        v15.Visible = true
        v15.Name = key_2
        v15.plrName.Text = key_2
        v15.Rank.Text = value_8.Rank
        v15.plrIcon.Image = game.Players:GetUserThumbnailAsync(value_8.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        v15:SetAttribute("name", key_2)
        if value_8.Rank == "Owner" then
            v15.Name = ("1%*"):format(key_2)
        end
    end
    print("Maybe3?")
    for _, value_upv_9 in ClubRosterFrame_1.ScrollFrame.ScrollingFrame:GetChildren() do
        if value_upv_9:IsA("ImageButton") then
            table.insert(
                tbl_upv_2,
                (value_upv_9.MouseButton1Down:Connect(
                    function()
                        --[[
                          line: 228
                          upvalues:
                            value_upv_9 (copy, index: 1)
                            u6 (ref,  index: 2)
                        ]]
                        displayPlayerStats(value_upv_9:GetAttribute("name"), u6[value_upv_9:GetAttribute("name")].Description)
                    end
                ))
            )
        end
    end
end
local function inClub(a1)
    --[[
      name: inClub
      line: 237
      upvalues:
        PlayerGui_upv_1 (copy, index: 1)
        LocalPlayer_upv_1 (copy, index: 2)
        u2 (copy, index: 3)
        u6 (ref,  index: 4)
        displayPlayersAndRank (copy, index: 5)
    ]]
    local ClubFrame_2 = PlayerGui_upv_1:WaitForChild("Menu"):WaitForChild("ClubFrame")
    local container_upv_2 = ClubFrame_2:WaitForChild("container")
    local ClubCreateFrame_1 = container_upv_2:WaitForChild("ClubCreateFrame")
    local _ = ClubCreateFrame_1:WaitForChild("container"):WaitForChild("ClubName")
    local v18 = ClubCreateFrame_1:WaitForChild("container"):WaitForChild("BannerID")
    local v19 = ClubCreateFrame_1:WaitForChild("container"):WaitForChild("LogoID")
    local v20 = ClubCreateFrame_1:WaitForChild("container"):WaitForChild("Create")
    local v21 = ClubCreateFrame_1:WaitForChild("desc"):WaitForChild("description")
    if LocalPlayer_upv_1:WaitForChild("Data"):WaitForChild("ClubRank").Value == "Owner" then
        ClubFrame_2.container.ClubRosterFrame.Disband.Text = "Disband"
    else
        ClubFrame_2.container.ClubRosterFrame.Disband.Text = "Leave"
    end
    container_upv_2.ClubCreateFrame.Visible = false
    ClubFrame_2.CreateClubButton.Visible = false
    ClubFrame_2.JoinClubButton.Visible = false
    container_upv_2.ClubStatsFrame.Visible = true
    local v16
    if a1 ~= nil then
        v16 = a1
    else
        print("data is nil")
        v16 = u2:InvokeServer({Action = "getClubData"})
        task.wait(0.25)
    end
    repeat
        task.wait()
    until v16
    task.wait(0.2)
    local v17 = nil
    if v16.Members then
        for key_3, value_10 in v16.Members do
            u6[key_3] = value_10
        end
        print(u6)
    else
        task.wait(1)
        repeat
            task.wait(1)
        until u2:InvokeServer({Action = "getClubData"}).Members
        print(u2:InvokeServer({Action = "getClubData"}).Members)
        v17 = u2:InvokeServer({Action = "getClubData"})
        task.wait(2)
        if v17.Members then
            for key_4, value_11 in v17.Members do
                u6[key_4] = value_11
            end
        end
        v16 = v17
    end
    print(v16)
    container_upv_2.ClubStatsFrame.clubIcon.Image = v16.Logo or ""
    container_upv_2.ClubStatsFrame.clubBanner.Image = v16.Banner or ""
    container_upv_2.ClubStatsFrame.clubName.Text = LocalPlayer_upv_1.Data.Club.Value
    container_upv_2.ClubStatsFrame.WINS.Amount.Text = v16.Wins
    container_upv_2.ClubStatsFrame.LOSSES.Amount.Text = v16.Losses
    container_upv_2.ClubStatsFrame.GOALS.Amount.Text = v16.Goals
    container_upv_2.ClubStatsFrame.ASSISTS.Amount.Text = v16.Assists
    local PickCategoryFrame_1 = container_upv_2.PickCategoryFrame
    container_upv_2.ClubRosterFrame.desc.TextLabel.Text = "PASS : " .. v16.password
    PickCategoryFrame_1.TeamRoster.MouseButton1Down:Connect(
        function()
            --[[
              line: 320
              upvalues:
                LocalPlayer_upv_1 (copy, index: 1)
                container_upv_2 (copy, index: 2)
                displayPlayersAndRank (copy, index: 3)
            ]]
            if LocalPlayer_upv_1.Data.Club.Value == "None" or LocalPlayer_upv_1.Data.Club.Value == "" then
                return
            end
            container_upv_2.ClubStatsFrame.Visible = false
            container_upv_2.ClubRosterFrame.Visible = true
            displayPlayersAndRank()
        end
    )
    PickCategoryFrame_1.ClubStats.MouseButton1Down:Connect(
        function()
            --[[
              line: 331
              upvalues:
                LocalPlayer_upv_1 (copy, index: 1)
                container_upv_2 (copy, index: 2)
            ]]
            if LocalPlayer_upv_1.Data.Club.Value == "None" or LocalPlayer_upv_1.Data.Club.Value == "" then
                return
            end
            container_upv_2.ClubStatsFrame.Visible = true
            container_upv_2.ClubRosterFrame.Visible = false
        end
    )
end
function tbl_1.init()
    --[[
      name: init
      line: 342
      upvalues:
        PlayerGui_upv_1 (copy, index: 1)
        u6 (ref,  index: 3)
        u2 (copy, index: 4)
        inClub (copy, index: 5)
        LocalPlayer_upv_1 (copy, index: 6)
    ]]
    local ClubFrame_upv_3 = PlayerGui_upv_1:WaitForChild("Menu"):WaitForChild("ClubFrame")
    local container_upv_3 = ClubFrame_upv_3:WaitForChild("container")
    local ClubCreateFrame_upv_2 = container_upv_3:WaitForChild("ClubCreateFrame")
    local ClubName_upv_1 = ClubCreateFrame_upv_2:WaitForChild("container"):WaitForChild("ClubName")
    local BannerID_upv_1 = ClubCreateFrame_upv_2:WaitForChild("container"):WaitForChild("BannerID")
    local LogoID_upv_1 = ClubCreateFrame_upv_2:WaitForChild("container"):WaitForChild("LogoID")
    local Create_1 = ClubCreateFrame_upv_2:WaitForChild("container"):WaitForChild("Create")
    local ClubJoinFrame_upv_1 = ClubFrame_upv_3:WaitForChild("container"):WaitForChild("ClubJoinFrame")
    local JoinClubButton_1 = ClubFrame_upv_3:WaitForChild("JoinClubButton")
    local description_upv_1 = ClubCreateFrame_upv_2:WaitForChild("desc"):WaitForChild("description")
    local function resetClubUI()
        --[[
          name: resetClubUI
          line: 358
          upvalues:
            container_upv_3 (copy, index: 2)
            ClubFrame_upv_3 (copy, index: 3)
            u6 (ref,  index: 4)
        ]]
        u5 = false
        container_upv_3.ClubRosterFrame.Visible = false
        container_upv_3.ClubStatsFrame.Visible = false
        container_upv_3.ClubCreateFrame.Visible = false
        container_upv_3.ClubJoinFrame.Visible = false
        ClubFrame_upv_3.JoinClubButton.Visible = true
        ClubFrame_upv_3.CreateClubButton.Visible = true
        container_upv_3.ClubStatsFrame.clubIcon.Image = ""
        container_upv_3.ClubStatsFrame.clubBanner.Image = ""
        container_upv_3.ClubStatsFrame.clubName.Text = ""
        container_upv_3.ClubStatsFrame.WINS.Amount.Text = "0"
        container_upv_3.ClubStatsFrame.LOSSES.Amount.Text = "0"
        container_upv_3.ClubStatsFrame.GOALS.Amount.Text = "0"
        container_upv_3.ClubStatsFrame.ASSISTS.Amount.Text = "0"
        container_upv_3.ClubRosterFrame.desc.TextLabel.Text = "PASS : ----"
        table.clear(u6)
    end
    local function closeTeamSelect()
        --[[
          name: closeTeamSelect
          line: 383
          upvalues:
            ClubFrame_upv_3 (copy, index: 1)
        ]]
        local TweenService_1 = game:GetService("TweenService")
        local v18 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local tbl_9 = {}
        tbl_9.Position = UDim2.new(0.5, 0, 1, 200)
        TweenService_1:Create(ClubFrame_upv_3.Parent.TeamSelectFrame, v18, tbl_9):Play()
        local TweenService_2 = game:GetService("TweenService")
        local v19 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_10 = {}
        tbl_10.Position = UDim2.new(0.5, 0, 1, 750)
        TweenService_2:Create(ClubFrame_upv_3.Parent.TeamSelectFrame.CancelButton, v19, tbl_10):Play()
        local TweenService_3 = game:GetService("TweenService")
        local v20 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local tbl_11 = {}
        tbl_11.Position = UDim2.new(0.5, 0, 1, 250)
        TweenService_3:Create(ClubFrame_upv_3.Parent.PosSelectFrame, v20, tbl_11):Play()
        local TweenService_4 = game:GetService("TweenService")
        local v21 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_12 = {}
        tbl_12.Position = UDim2.new(0.5, 0, 1, 750)
        TweenService_4:Create(ClubFrame_upv_3.Parent.PosSelectFrame.CancelButton, v21, tbl_12):Play()
        task.delay(
            0.5,
            function()
                --[[
                  line: 396
                  upvalues:
                    ClubFrame_upv_3 (copy, index: 1)
                ]]
                ClubFrame_upv_3.Parent.TeamSelectFrame.Visible = false
                ClubFrame_upv_3.Parent.PosSelectFrame.Visible = false
            end
        )
    end
    local CancelButton_1 = ClubFrame_upv_3.CancelButton
    ClubFrame_upv_3:WaitForChild("CreateClubButton").MouseButton1Down:Connect(
        function()
            --[[
              line: 405
              upvalues:
                container_upv_3 (copy, index: 1)
                ClubFrame_upv_3 (copy, index: 2)
            ]]
            container_upv_3.ClubRosterFrame.Visible = false
            container_upv_3.ClubStatsFrame.Visible = false
            container_upv_3.ClubCreateFrame.Visible = true
            container_upv_3.ClubJoinFrame.Visible = false
            ClubFrame_upv_3.JoinClubButton.Visible = false
            ClubFrame_upv_3.CreateClubButton.Visible = false
        end
    )
    JoinClubButton_1.MouseButton1Down:Connect(
        function()
            --[[
              line: 414
              upvalues:
                container_upv_3 (copy, index: 1)
                ClubFrame_upv_3 (copy, index: 2)
            ]]
            container_upv_3.ClubRosterFrame.Visible = false
            container_upv_3.ClubStatsFrame.Visible = false
            container_upv_3.ClubCreateFrame.Visible = false
            container_upv_3.ClubJoinFrame.Visible = true
            ClubFrame_upv_3.JoinClubButton.Visible = false
            ClubFrame_upv_3.CreateClubButton.Visible = false
        end
    )
    ClubJoinFrame_upv_1.container.Create.MouseButton1Click:Connect(
        function()
            --[[
              line: 423
              upvalues:
                u2 (copy, index: 1)
                ClubJoinFrame_upv_1 (copy, index: 2)
                inClub (copy, index: 3)
            ]]
            local v22 = u2:InvokeServer({Action = "Join", password = ClubJoinFrame_upv_1.container.Password.Text, clubName = ClubJoinFrame_upv_1.container.ClubName.Text})
            if v22.answer ~= false then
                inClub()
            else
                game.ReplicatedStorage.UISounds["ui-error4"]:Play()
                ClubJoinFrame_upv_1.container.ClubName.Text = v22.say
            end
        end
    )
    if LocalPlayer_upv_1:WaitForChild("Data"):WaitForChild("ClubRank").Value == "Owner" then
        ClubFrame_upv_3.container.ClubRosterFrame.Disband.Text = "Disband"
    else
        ClubFrame_upv_3.container.ClubRosterFrame.Disband.Text = "Leave"
    end
    CancelButton_1.MouseButton1Down:Connect(
        function()
            --[[
              line: 444
              upvalues:
                ClubFrame_upv_3 (copy, index: 1)
            ]]
            local v23 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_13 = {}
            tbl_13.Position = UDim2.new(0.5, 0, 1.5, 0)
            game.TweenService:Create(ClubFrame_upv_3, v23, tbl_13):Play()
        end
    )
    ClubFrame_upv_3.container.ClubRosterFrame.Disband.MouseButton1Click:Connect(
        function()
            --[[
              line: 448
              upvalues:
                u2 (copy, index: 1)
                resetClubUI (copy, index: 2)
            ]]
            if not u2:InvokeServer({Action = "Disband"}).answer then
                return
            end
            resetClubUI()
        end
    )
    ClubFrame_upv_3.Parent.MenuButtons.ClubsButton.MouseButton1Down:Connect(
        function()
            --[[
              line: 458
              upvalues:
                ClubFrame_upv_3 (copy, index: 1)
                LocalPlayer_upv_1 (copy, index: 2)
                container_upv_3 (copy, index: 3)
                inClub (copy, index: 4)
            ]]
            ClubFrame_upv_3.Visible = true
            local Value_1 = LocalPlayer_upv_1:WaitForChild("Data"):WaitForChild("Club").Value
            if Value_1 == "" or Value_1 == "None" then
                container_upv_3.ClubRosterFrame.Visible = false
                container_upv_3.ClubStatsFrame.Visible = false
                container_upv_3.ClubCreateFrame.Visible = false
                container_upv_3.ClubJoinFrame.Visible = false
                ClubFrame_upv_3.JoinClubButton.Visible = true
                ClubFrame_upv_3.CreateClubButton.Visible = true
            else
                container_upv_3.ClubRosterFrame.Visible = false
                container_upv_3.ClubStatsFrame.Visible = true
                container_upv_3.ClubCreateFrame.Visible = false
                container_upv_3.ClubJoinFrame.Visible = false
                ClubFrame_upv_3.JoinClubButton.Visible = false
                ClubFrame_upv_3.CreateClubButton.Visible = false
                inClub()
            end
            local v24 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_14 = {}
            tbl_14.Position = UDim2.new(0.5, 0, 0.5, 0)
            game.TweenService:Create(ClubFrame_upv_3, v24, tbl_14):Play()
            local TweenService_5 = game:GetService("TweenService")
            local v25 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_15 = {}
            tbl_15.Position = UDim2.new(0.5, 0, 1, 170)
            TweenService_5:Create(ClubFrame_upv_3.Parent.StatsFrame, v25, tbl_15):Play()
            task.delay(
                0.35,
                function()
                    --[[
                      line: 488
                      upvalues:
                        ClubFrame_upv_3 (copy, index: 1)
                    ]]
                    ClubFrame_upv_3.Parent.StatsFrame.Visible = false
                end
            )
            local TweenService_6 = game:GetService("TweenService")
            local v26 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_16 = {}
            tbl_16.Position = UDim2.new(0.5, 0, 1, 230)
            TweenService_6:Create(ClubFrame_upv_3.Parent.SkillFrame, v26, tbl_16):Play()
            task.delay(
                0.35,
                function()
                    --[[
                      line: 494
                      upvalues:
                        ClubFrame_upv_3 (copy, index: 1)
                    ]]
                    ClubFrame_upv_3.Parent.SkillFrame.Visible = false
                end
            )
        end
    )
    local Value_2 = LocalPlayer_upv_1:WaitForChild("Data"):WaitForChild("Club").Value
    if Value_2 == "" or Value_2 == "None" then
        container_upv_3.ClubRosterFrame.Visible = false
        container_upv_3.ClubStatsFrame.Visible = false
        container_upv_3.ClubCreateFrame.Visible = false
        container_upv_3.ClubJoinFrame.Visible = false
        ClubFrame_upv_3.JoinClubButton.Visible = true
        ClubFrame_upv_3.CreateClubButton.Visible = true
        ClubName_upv_1.FocusLost:Connect(
            function()
                --[[
                  line: 521
                  upvalues:
                    ClubName_upv_1 (copy, index: 1)
                ]]
                print(ClubName_upv_1.Text)
            end
        )
        description_upv_1.FocusLost:Connect(
            function()
                --[[
                  line: 525
                  upvalues:
                    description_upv_1 (copy, index: 1)
                ]]
                print(description_upv_1.Text)
            end
        )
        LogoID_upv_1.FocusLost:Connect(
            function()
                --[[
                  line: 529
                  upvalues:
                    ClubCreateFrame_upv_2 (copy, index: 1)
                    LogoID_upv_1 (copy, index: 2)
                ]]
                local IconDisplay_1 = ClubCreateFrame_upv_2:WaitForChild("container"):WaitForChild("IconDisplay")
                IconDisplay_1.Image = ("rbxassetid://%*"):format(LogoID_upv_1.Text)
            end
        )
        BannerID_upv_1.FocusLost:Connect(
            function()
                --[[
                  line: 533
                  upvalues:
                    ClubCreateFrame_upv_2 (copy, index: 1)
                    BannerID_upv_1 (copy, index: 2)
                ]]
                local BannerDisplay_1 = ClubCreateFrame_upv_2:WaitForChild("container"):WaitForChild("BannerDisplay")
                BannerDisplay_1.Image = ("rbxassetid://%*"):format(BannerID_upv_1.Text)
            end
        )
        Create_1.MouseButton1Down:Connect(
            function()
                --[[
                  line: 537
                  upvalues:
                    u2 (copy, index: 1)
                    ClubName_upv_1 (copy, index: 2)
                    ClubCreateFrame_upv_2 (copy, index: 3)
                    description_upv_1 (copy, index: 4)
                    inClub (copy, index: 5)
                ]]
                local v27 = u2:InvokeServer({Action = "Create", clubName = ClubName_upv_1.Text, clubLogo = ClubCreateFrame_upv_2:WaitForChild("container"):WaitForChild("IconDisplay").Image, clubBanner = ClubCreateFrame_upv_2:WaitForChild("container"):WaitForChild("BannerDisplay").Image, plrDesc = description_upv_1.Text})
                if v27.answer ~= false then
                    game.ReplicatedStorage.UISounds["ui-confirm2"]:Play()
                    inClub(v27.data)
                else
                    game.ReplicatedStorage.UISounds["ui-error4"]:Play()
                    ClubName_upv_1.Text = v27.say
                end
            end
        )
        task.wait(1)
        if LocalPlayer_upv_1.Data.Club.Value ~= "" and LocalPlayer_upv_1.Data.Club.Value ~= "None" then
            local v28 = u2:InvokeServer({Action = "getClubData"})
            if v28 then
                container_upv_3.ClubStatsFrame.WINS.Amount.Text = v28.Wins or "0"
                container_upv_3.ClubStatsFrame.LOSSES.Amount.Text = v28.Losses or "0"
                container_upv_3.ClubStatsFrame.GOALS.Amount.Text = v28.Goals or "0"
                container_upv_3.ClubStatsFrame.ASSISTS.Amount.Text = v28.Assists or "0"
                u6 = v28.Members
            end
            task.wait(30)
        else
            task.wait(1)
        end
    end
    container_upv_3.ClubRosterFrame.Visible = false
    container_upv_3.ClubStatsFrame.Visible = true
    container_upv_3.ClubCreateFrame.Visible = false
    container_upv_3.ClubJoinFrame.Visible = false
    ClubFrame_upv_3.JoinClubButton.Visible = false
    ClubFrame_upv_3.CreateClubButton.Visible = false
    inClub()
end
tbl_1.init()
return tbl_1