--[[
    Script Path: Game/StarterGui/ScoreAndTimer/ScoreAndTimerHandler
    Class: LocalScript
    Time: 2026-10-03 12:27:09
--]]

local tbl_upv_1 = {}
tbl_upv_1.AstonVilla = Color3.fromRGB(103, 14, 54)
tbl_upv_1.Flamengo = Color3.fromRGB(161, 0, 0)
tbl_upv_1.Argentina = Color3.fromRGB(25, 94, 222)
tbl_upv_1.Munich = Color3.fromRGB(185, 0, 0)
tbl_upv_1.Dortmund = Color3.fromRGB(255, 225, 0)
tbl_upv_1.Brazil = Color3.fromRGB(255, 213, 0)
tbl_upv_1.ParisSaints = Color3.fromRGB(2, 28, 97)
tbl_upv_1.ManchesterU = Color3.fromRGB(161, 0, 0)
tbl_upv_1.Barcelona = Color3.fromRGB(0, 43, 136)
tbl_upv_1.InterMiami = Color3.fromRGB(0, 0, 0)
tbl_upv_1.Japan = Color3.fromRGB(236, 236, 236)
tbl_upv_1.Italy = Color3.fromRGB(0, 98, 255)
tbl_upv_1.Croatia = Color3.fromRGB(4, 87, 162)
tbl_upv_1.Morocco = Color3.fromRGB(200, 12, 12)
tbl_upv_1.Canada = Color3.fromRGB(255, 255, 255)
tbl_upv_1.Portugal = Color3.fromRGB(195, 29, 21)
tbl_upv_1.Mexico = Color3.fromRGB(20, 25, 39)
tbl_upv_1.Netherlands = Color3.fromRGB(255, 128, 0)
tbl_upv_1.RealMadrid = Color3.fromRGB(227, 227, 227)
tbl_upv_1.LiverpoolFC = Color3.fromRGB(208, 0, 0)
tbl_upv_1.SeattleSoundersFC = Color3.fromRGB(59, 155, 68)
tbl_upv_1.JuventusFC = Color3.fromRGB(0, 0, 0)
tbl_upv_1.Newcastle = Color3.fromRGB(255, 255, 255)
tbl_upv_1.ManchesterCity = Color3.fromRGB(125, 199, 255)
tbl_upv_1.Germany = Color3.fromRGB(170, 37, 11)
tbl_upv_1.Arsenal = Color3.fromRGB(197, 0, 0)
tbl_upv_1.InterMilan = Color3.fromRGB(28, 107, 255)
tbl_upv_1.USA = Color3.fromRGB(170, 33, 33)
tbl_upv_1.Chelsea = Color3.fromRGB(51, 55, 170)
tbl_upv_1.Napoli = Color3.fromRGB(81, 134, 232)
tbl_upv_1.France = Color3.fromRGB(1, 56, 157)
tbl_upv_1.Uruguay = Color3.fromRGB(69, 155, 235)
tbl_upv_1.Roma = Color3.fromRGB(208, 38, 8)
tbl_upv_1.Lazio = Color3.fromRGB(84, 138, 208)
tbl_upv_1.England = Color3.fromRGB(196, 210, 243)
tbl_upv_1.SouthKorea = Color3.fromRGB(243, 243, 243)
tbl_upv_1.VascoDaGama = Color3.fromRGB(243, 243, 243)
tbl_upv_1.Ajax = Color3.fromRGB(255, 99, 99)
tbl_upv_1.Atletico = Color3.fromRGB(172, 4, 4)
tbl_upv_1.Leverkusen = Color3.fromRGB(143, 12, 12)
tbl_upv_1.Wales = Color3.fromRGB(77, 182, 77)
tbl_upv_1.Fiorentina = Color3.fromRGB(124, 64, 208)
tbl_upv_1.Spurs = Color3.fromRGB(208, 208, 208)
tbl_upv_1.ACMilan = Color3.fromRGB(197, 20, 20)
tbl_upv_1.Belgium = Color3.new(0.980392, 0.654902, 0)
tbl_upv_1.Spain = Color3.fromRGB(213, 14, 0)
tbl_upv_1.Scotland = Color3.fromRGB(56, 80, 136)
tbl_upv_1.Poland = Color3.new(1, 0, 0.0156863)
tbl_upv_1.Sweden = Color3.new(0.192157, 0.501961, 1)
tbl_upv_1.Bosnia = Color3.new(0.172549, 0.211765, 0.772549)
tbl_upv_1.Denmark = Color3.new(0.819608, 0, 0.0117647)
tbl_upv_1.Romania = Color3.new(1, 0.819608, 0.0980392)
tbl_upv_1.Switzerland = Color3.new(0.827451, 0, 0)
local tbl_upv_2 = {}
tbl_upv_2.Flamengo = Color3.fromRGB(25, 0, 0)
tbl_upv_2.AstonVilla = Color3.fromRGB(149, 191, 229)
tbl_upv_2.Argentina = Color3.fromRGB(204, 180, 60)
tbl_upv_2.Munich = Color3.fromRGB(0, 170, 255)
tbl_upv_2.Dortmund = Color3.fromRGB(0, 0, 0)
tbl_upv_2.Brazil = Color3.fromRGB(0, 94, 0)
tbl_upv_2.ParisSaints = Color3.fromRGB(255, 255, 255)
tbl_upv_2.ManchesterU = Color3.fromRGB(255, 217, 0)
tbl_upv_2.Barcelona = Color3.fromRGB(170, 0, 0)
tbl_upv_2.InterMiami = Color3.fromRGB(255, 139, 205)
tbl_upv_2.Japan = Color3.fromRGB(161, 0, 0)
tbl_upv_2.Italy = Color3.fromRGB(236, 236, 236)
tbl_upv_2.Croatia = Color3.fromRGB(185, 0, 0)
tbl_upv_2.Morocco = Color3.fromRGB(10, 148, 30)
tbl_upv_2.Canada = Color3.fromRGB(229, 13, 13)
tbl_upv_2.Portugal = Color3.fromRGB(13, 105, 56)
tbl_upv_2.Mexico = Color3.fromRGB(0, 238, 0)
tbl_upv_2.Netherlands = Color3.fromRGB(217, 217, 217)
tbl_upv_2.RealMadrid = Color3.fromRGB(204, 180, 60)
tbl_upv_2.LiverpoolFC = Color3.fromRGB(227, 227, 227)
tbl_upv_2.SeattleSoundersFC = Color3.fromRGB(10, 95, 170)
tbl_upv_2.JuventusFC = Color3.fromRGB(255, 255, 255)
tbl_upv_2.Newcastle = Color3.fromRGB(0, 0, 0)
tbl_upv_2.ManchesterCity = Color3.fromRGB(255, 255, 255)
tbl_upv_2.Germany = Color3.fromRGB(0, 0, 0)
tbl_upv_2.Arsenal = Color3.fromRGB(255, 255, 255)
tbl_upv_2.InterMilan = Color3.fromRGB(235, 235, 235)
tbl_upv_2.USA = Color3.fromRGB(26, 87, 255)
tbl_upv_2.Chelsea = Color3.fromRGB(180, 169, 44)
tbl_upv_2.Napoli = Color3.fromRGB(45, 104, 243)
tbl_upv_2.France = Color3.fromRGB(193, 193, 193)
tbl_upv_2.Uruguay = Color3.fromRGB(182, 172, 92)
tbl_upv_2.Roma = Color3.fromRGB(208, 147, 24)
tbl_upv_2.Lazio = Color3.fromRGB(208, 208, 208)
tbl_upv_2.England = Color3.fromRGB(15, 49, 162)
tbl_upv_2.SouthKorea = Color3.fromRGB(168, 38, 40)
tbl_upv_2.VascoDaGama = Color3.fromRGB(121, 21, 23)
tbl_upv_2.Ajax = Color3.fromRGB(255, 255, 255)
tbl_upv_2.Atletico = Color3.fromRGB(29, 60, 172)
tbl_upv_2.Leverkusen = Color3.fromRGB(0, 0, 0)
tbl_upv_2.Wales = Color3.fromRGB(39, 39, 39)
tbl_upv_2.Fiorentina = Color3.fromRGB(182, 172, 92)
tbl_upv_2.Spurs = Color3.fromRGB(57, 57, 57)
tbl_upv_2.ACMilan = Color3.fromRGB(57, 6, 6)
tbl_upv_2.Belgium = Color3.new(0.0784314, 0.0509804, 0)
tbl_upv_2.Spain = Color3.fromRGB(147, 123, 35)
tbl_upv_2.Scotland = Color3.fromRGB(225, 216, 210)
tbl_upv_2.Poland = Color3.new(1, 1, 1)
tbl_upv_2.Sweden = Color3.new(1, 0.819608, 0.0980392)
tbl_upv_2.Bosnia = Color3.new(0.203922, 0.47451, 0.909804)
tbl_upv_2.Denmark = Color3.new(1, 1, 1)
tbl_upv_2.Romania = Color3.new(0, 0.517647, 1)
tbl_upv_2.Switzerland = Color3.new(0.827451, 0.827451, 0.827451)
local tbl_upv_3 = {}
tbl_upv_3.AstonVilla = "rbxassetid://81835506871297"
tbl_upv_3.Flamengo = "rbxassetid://110918350569178"
tbl_upv_3.Argentina = "rbxassetid://15068029862"
tbl_upv_3.Munich = "rbxassetid://15068635815"
tbl_upv_3.Dortmund = "rbxassetid://13460575423"
tbl_upv_3.Brazil = "rbxassetid://15068649812"
tbl_upv_3.ParisSaints = "rbxassetid://13552953245"
tbl_upv_3.ManchesterU = "rbxassetid://14540294821"
tbl_upv_3.Barcelona = "rbxassetid://316144192"
tbl_upv_3.InterMiami = "rbxassetid://15081749904"
tbl_upv_3.Japan = "rbxassetid://15098627666"
tbl_upv_3.Italy = "rbxassetid://15107657423"
tbl_upv_3.Croatia = "rbxassetid://15107652254"
tbl_upv_3.Morocco = "rbxassetid://15107668354"
tbl_upv_3.Canada = "rbxassetid://15107670722"
tbl_upv_3.Portugal = "rbxassetid://15148310170"
tbl_upv_3.Mexico = "rbxassetid://15107685948"
tbl_upv_3.Netherlands = "rbxassetid://15107690732"
tbl_upv_3.RealMadrid = "rbxassetid://15107692601"
tbl_upv_3.LiverpoolFC = "rbxassetid://5525377475"
tbl_upv_3.SeattleSoundersFC = "rbxassetid://15155280087"
tbl_upv_3.JuventusFC = "rbxassetid://15238497443"
tbl_upv_3.Newcastle = "rbxassetid://18897627545"
tbl_upv_3.ManchesterCity = "rbxassetid://14243657473"
tbl_upv_3.Germany = "rbxassetid://18640980135"
tbl_upv_3.England = "rbxassetid://18641004985"
tbl_upv_3.Arsenal = "rbxassetid://18652402819"
tbl_upv_3.InterMilan = "rbxassetid://18816070754"
tbl_upv_3.USA = "rbxassetid://18641031024"
tbl_upv_3.Chelsea = "rbxassetid://18641029244"
tbl_upv_3.Napoli = "rbxassetid://18641026783"
tbl_upv_3.France = "rbxassetid://18641023325"
tbl_upv_3.Uruguay = "rbxassetid://18641021338"
tbl_upv_3.Roma = "rbxassetid://18641019719"
tbl_upv_3.Lazio = "rbxassetid://18641016564"
tbl_upv_3.SouthKorea = "rbxassetid://18641001856"
tbl_upv_3.VascoDaGama = "rbxassetid://18640997828"
tbl_upv_3.Ajax = "rbxassetid://18640996176"
tbl_upv_3.Atletico = "rbxassetid://18640993960"
tbl_upv_3.Leverkusen = "rbxassetid://18640992087"
tbl_upv_3.Wales = "rbxassetid://18640989958"
tbl_upv_3.Fiorentina = "rbxassetid://18640988644"
tbl_upv_3.Spurs = "rbxassetid://18640987300"
tbl_upv_3.ACMilan = "rbxassetid://18640984312"
tbl_upv_3.Belgium = "rbxassetid://18641190960"
tbl_upv_3.Spain = "rbxassetid://18672737980"
tbl_upv_3.Scotland = "rbxassetid://18672741584"
tbl_upv_3.Poland = "rbxassetid://18816097298"
tbl_upv_3.Sweden = "rbxassetid://18897774513"
tbl_upv_3.Bosnia = "rbxassetid://18897785797"
tbl_upv_3.Denmark = "rbxassetid://18897980982"
tbl_upv_3.Romania = "rbxassetid://18897982581"
tbl_upv_3.Switzerland = "rbxassetid://18897984306"
local tbl_upv_4 = {}
tbl_upv_4.Argentina = "ARG"
tbl_upv_4.AstonVilla = "ASV"
tbl_upv_4.Flamengo = "FLA"
tbl_upv_4.Munich = "BAY"
tbl_upv_4.Dortmund = "DOR"
tbl_upv_4.Brazil = "BRA"
tbl_upv_4.ParisSaints = "PSG"
tbl_upv_4.ManchesterU = "MUN"
tbl_upv_4.Barcelona = "FCB"
tbl_upv_4.InterMiami = "MIA"
tbl_upv_4.Japan = "JPN"
tbl_upv_4.Italy = "ITA"
tbl_upv_4.Croatia = "CRO"
tbl_upv_4.Morocco = "MAR"
tbl_upv_4.Canada = "CAN"
tbl_upv_4.Portugal = "POR"
tbl_upv_4.Mexico = "MEX"
tbl_upv_4.Netherlands = "NED"
tbl_upv_4.RealMadrid = "RMA"
tbl_upv_4.LiverpoolFC = "LFC"
tbl_upv_4.SeattleSoundersFC = "SEA"
tbl_upv_4.JuventusFC = "JUV"
tbl_upv_4.Newcastle = "NEW"
tbl_upv_4.ManchesterCity = "MCI"
tbl_upv_4.Germany = "GER"
tbl_upv_4.England = "ENG"
tbl_upv_4.Arsenal = "ASL"
tbl_upv_4.InterMilan = "INT"
tbl_upv_4.USA = "USA"
tbl_upv_4.Chelsea = "CHE"
tbl_upv_4.Napoli = "NAP"
tbl_upv_4.France = "FRA"
tbl_upv_4.Uruguay = "URU"
tbl_upv_4.Roma = "ROM"
tbl_upv_4.Lazio = "LAZ"
tbl_upv_4.SouthKorea = "KOR"
tbl_upv_4.VascoDaGama = "VAS"
tbl_upv_4.Ajax = "AFC"
tbl_upv_4.Atletico = "AMA"
tbl_upv_4.Leverkusen = "B04"
tbl_upv_4.Wales = "WAL"
tbl_upv_4.Fiorentina = "FIO"
tbl_upv_4.Spurs = "TOT"
tbl_upv_4.ACMilan = "MIL"
tbl_upv_4.Belgium = "BEL"
tbl_upv_4.Spain = "ESP"
tbl_upv_4.Scotland = "SCO"
tbl_upv_4.Poland = "POL"
tbl_upv_4.Sweden = "SWE"
tbl_upv_4.Bosnia = "BIH"
tbl_upv_4.Denmark = "DEN"
tbl_upv_4.Romania = "ROU"
tbl_upv_4.Switzerland = "SUI"
local tbl_upv_5 = {}
tbl_upv_5.Argentina = "ARGENTINA"
tbl_upv_5.Munich = "F.C. BAYERN"
tbl_upv_5.Dortmund = "BORUSSIA DORTMUND"
tbl_upv_5.Brazil = "BRAZIL"
tbl_upv_5.ParisSaints = "P.S.G"
tbl_upv_5.Flamengo = "FLAMENGO"
tbl_upv_5.AstonVilla = "ASTON VILLA"
tbl_upv_5.ManchesterU = "MANCHESTER UNITED"
tbl_upv_5.Barcelona = "F.C. BARCELONA"
tbl_upv_5.InterMiami = "INTER MIAMI"
tbl_upv_5.Japan = "JAPAN"
tbl_upv_5.Italy = "ITALY"
tbl_upv_5.Croatia = "CROATIA"
tbl_upv_5.Morocco = "MOROCCO"
tbl_upv_5.Canada = "CANADA"
tbl_upv_5.Portugal = "PORTUGAL"
tbl_upv_5.Mexico = "MEXICO"
tbl_upv_5.Netherlands = "NETHERLANDS"
tbl_upv_5.RealMadrid = "REAL MADRID"
tbl_upv_5.LiverpoolFC = "LIVERPOOL F.C."
tbl_upv_5.SeattleSoundersFC = "SEATTLE SOUNDERS F.C."
tbl_upv_5.JuventusFC = "JUVENTUS F.C."
tbl_upv_5.Newcastle = "NEWCASTLE UNITED"
tbl_upv_5.ManchesterCity = "MANCHESTER CITY"
tbl_upv_5.Germany = "GERMANY"
tbl_upv_5.England = "ENGLAND"
tbl_upv_5.Arsenal = "ARSENAL F.C."
tbl_upv_5.InterMilan = "INTER MILAN"
tbl_upv_5.USA = "USA"
tbl_upv_5.Chelsea = "CHELSEA F.C."
tbl_upv_5.Napoli = "F.C. NAPOLI"
tbl_upv_5.France = "FRANCE"
tbl_upv_5.Uruguay = "URUGUAY"
tbl_upv_5.Roma = "ROMANIA"
tbl_upv_5.Lazio = "LAZIO"
tbl_upv_5.SouthKorea = "SOUTH KOREA"
tbl_upv_5.VascoDaGama = "CR VASCO DA GAMA"
tbl_upv_5.Ajax = "A.F.C. AJAX"
tbl_upv_5.Atletico = "ATLETICO MADRID"
tbl_upv_5.Leverkusen = "BAYER 04 LEVERKUSEN"
tbl_upv_5.Wales = "WALES"
tbl_upv_5.Fiorentina = "A.C.F. FIORENTINA"
tbl_upv_5.Spurs = "TOTTENHAM HOTSPURS"
tbl_upv_5.ACMilan = "A.C. MILAN"
tbl_upv_5.Belgium = "BELGIUM"
tbl_upv_5.Spain = "SPAIN"
tbl_upv_5.Scotland = "SCOTLAND"
tbl_upv_5.Poland = "POLAND"
tbl_upv_5.Sweden = "SWEDEN"
tbl_upv_5.Bosnia = "BOSNIA AND HERZEGOVINA"
tbl_upv_5.Denmark = "DENMARK"
tbl_upv_5.Romania = "ROMANIA"
tbl_upv_5.Switzerland = "SWITZERLAND"
repeat
    repeat
        task.wait()
    until game.ReplicatedStorage.TeamInfo.CurrentAwayTeam.Value ~= ""
until game.ReplicatedStorage.TeamInfo.CurrentHomeTeam.Value ~= ""
local TeamInfo_upv_1 = game.ReplicatedStorage.TeamInfo
local gameTime_upv_1 = game.ReplicatedStorage.gameTime
local ScoreAndTimerFrame_upv_1 = script.Parent.ScoreAndTimerFrame
local AwayTeam_upv_1 = ScoreAndTimerFrame_upv_1.AwayTeam
local HomeTeam_upv_1 = ScoreAndTimerFrame_upv_1.HomeTeam
local Score_upv_1 = ScoreAndTimerFrame_upv_1.Score
local Timer_upv_1 = ScoreAndTimerFrame_upv_1.Timer
local TabFrame_upv_1 = script.Parent.TabFrame
local Container_upv_1 = TabFrame_upv_1.HomeFrame.Container
local Container_upv_2 = TabFrame_upv_1.AwayFrame.Container
local UserInputService_upv_1 = game:GetService("UserInputService")
repeat
    wait(0.2)
until game.Workspace.gameArea.SelectedMap:FindFirstChild("Scoreboard")
UserInputService_upv_1.InputChanged:Connect(
    function()
        --[[
          line: 299
          upvalues:
            UserInputService_upv_1 (copy, index: 1)
            ScoreAndTimerFrame_upv_1 (copy, index: 2)
            AwayTeam_upv_1 (copy, index: 3)
            HomeTeam_upv_1 (copy, index: 4)
            Score_upv_1 (copy, index: 5)
            Timer_upv_1 (copy, index: 6)
        ]]
        if UserInputService_upv_1:GetLastInputType() ~= Enum.UserInputType.Touch then
            ScoreAndTimerFrame_upv_1.Size = UDim2.new(0, 400, 0, 100)
            AwayTeam_upv_1.Size = UDim2.new(0, 85, 0, 43)
            AwayTeam_upv_1.Position = UDim2.new(0.75, 0, 0.69, 0)
            HomeTeam_upv_1.Size = UDim2.new(0, 85, 0, 43)
            HomeTeam_upv_1.Position = UDim2.new(0.25, 0, 0.69, 0)
            Score_upv_1.Size = UDim2.new(0, 102, 0, 43)
            Timer_upv_1.Size = UDim2.new(0, 102, 0, 43)
        else
            ScoreAndTimerFrame_upv_1.Size = UDim2.new(0, 400, 0, 38)
            AwayTeam_upv_1.Size = UDim2.new(0, 40, 0, 22)
            AwayTeam_upv_1.Position = UDim2.new(0.625, 0, 0.69, 0)
            HomeTeam_upv_1.Size = UDim2.new(0, 40, 0, 22)
            HomeTeam_upv_1.Position = UDim2.new(0.375, 0, 0.69, 0)
            Score_upv_1.Size = UDim2.new(0, 40, 0, 22)
            Timer_upv_1.Size = UDim2.new(0, 40, 0, 22)
        end
    end
)
game.ReplicatedStorage.ChildAdded:Connect(
    function(a1)
        --[[
          line: 319
          upvalues:
            Timer_upv_1 (copy, index: 1)
        ]]
        if a1.Name ~= "overtime" then
            return
        end
        Timer_upv_1.Time.Text = "OVERTIME"
    end
)
game.ReplicatedStorage.ChildRemoved:Connect(
    function(a1)
        --[[
          line: 325
          upvalues:
            Timer_upv_1 (copy, index: 1)
        ]]
        if a1.Name ~= "overtime" then
            return
        end
        Timer_upv_1.Time.Text = "0:00"
    end
)
if game.ReplicatedStorage.hasGameStarted.Value == true then
    if UserInputService_upv_1:GetLastInputType() ~= Enum.UserInputType.Touch then
        local TweenService_1 = game:GetService("TweenService")
        local v1 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tbl_6 = {}
        tbl_6.Position = UDim2.new(0.5, 0, 0, 80)
        TweenService_1:Create(ScoreAndTimerFrame_upv_1, v1, tbl_6):Play()
    else
        local TweenService_2 = game:GetService("TweenService")
        local v2 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tbl_7 = {}
        tbl_7.Position = UDim2.new(0.5, 0, 0, 55)
        TweenService_2:Create(ScoreAndTimerFrame_upv_1, v2, tbl_7):Play()
    end
end
game.ReplicatedStorage.hasGameStarted.Changed:Connect(
    function()
        --[[
          line: 343
          upvalues:
            ScoreAndTimerFrame_upv_1 (copy, index: 1)
            UserInputService_upv_1 (copy, index: 2)
        ]]
        if game.ReplicatedStorage.hasGameStarted.Value == false then
            local TweenService_3 = game:GetService("TweenService")
            local v3 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
            local tbl_8 = {}
            tbl_8.Position = UDim2.new(0.5, 0, 0, -100)
            TweenService_3:Create(ScoreAndTimerFrame_upv_1, v3, tbl_8):Play()
        elseif UserInputService_upv_1:GetLastInputType() ~= Enum.UserInputType.Touch then
            local TweenService_4 = game:GetService("TweenService")
            local v4 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
            local tbl_9 = {}
            tbl_9.Position = UDim2.new(0.5, 0, 0, 80)
            TweenService_4:Create(ScoreAndTimerFrame_upv_1, v4, tbl_9):Play()
        else
            local TweenService_5 = game:GetService("TweenService")
            local v5 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
            local tbl_10 = {}
            tbl_10.Position = UDim2.new(0.5, 0, 0, 55)
            TweenService_5:Create(ScoreAndTimerFrame_upv_1, v5, tbl_10):Play()
        end
    end
)
gameTime_upv_1.Changed:Connect(
    function()
        --[[
          line: 363
          upvalues:
            Timer_upv_1 (copy, index: 1)
            gameTime_upv_1 (copy, index: 2)
        ]]
        if game.ReplicatedStorage:FindFirstChild("overtime") then
            Timer_upv_1.Time.Text = "OVERTIME"
        else
            Timer_upv_1.Time.Text = math.floor(gameTime_upv_1.Value / 60) .. (((gameTime_upv_1.Value % 60 < 10) and ":0") or ":") .. gameTime_upv_1.Value % 60
        end
    end
)
Timer_upv_1.Time.Text = math.floor(gameTime_upv_1.Value / 60) .. (((gameTime_upv_1.Value % 60 < 10) and ":0") or ":") .. gameTime_upv_1.Value % 60
function handleAwayTeam()
    --[[
      name: handleAwayTeam
      line: 375
      upvalues:
        TeamInfo_upv_1 (copy, index: 1)
        AwayTeam_upv_1 (copy, index: 2)
        tbl_upv_1 (copy, index: 3)
        tbl_upv_2 (copy, index: 4)
        tbl_upv_4 (copy, index: 5)
        tbl_upv_3 (copy, index: 6)
        tbl_upv_5 (copy, index: 7)
    ]]
    local Value_1 = TeamInfo_upv_1.CurrentAwayTeam.Value
    AwayTeam_upv_1.BackgroundColor3 = tbl_upv_1[Value_1]
    AwayTeam_upv_1.UIStroke.Color = tbl_upv_2[Value_1]
    AwayTeam_upv_1.TeamName.TextStrokeColor3 = tbl_upv_2[Value_1]
    AwayTeam_upv_1.TeamName.Text = tbl_upv_4[Value_1]
    AwayTeam_upv_1.ImageLabel.Image = tbl_upv_3[Value_1]
    game.Workspace.gameArea.SelectedMap:WaitForChild("Scoreboard").Team2.TeamName.SurfaceGui.Frame.TextLabel.Text = tbl_upv_5[Value_1]
    game.Workspace.gameArea.SelectedMap:WaitForChild("Scoreboard").Team2.TeamName.SurfaceGui.Frame.TextLabel.TextStrokeColor3 = tbl_upv_2[Value_1]
    game.Workspace.gameArea.SelectedMap:WaitForChild("Scoreboard").Team2.TeamName.SurfaceGui.Frame.TextLabel.TextStrokeTransparency = 1
end
function handleHomeTeam()
    --[[
      name: handleHomeTeam
      line: 387
      upvalues:
        TeamInfo_upv_1 (copy, index: 1)
        HomeTeam_upv_1 (copy, index: 2)
        tbl_upv_1 (copy, index: 3)
        tbl_upv_2 (copy, index: 4)
        tbl_upv_4 (copy, index: 5)
        tbl_upv_3 (copy, index: 6)
        tbl_upv_5 (copy, index: 7)
    ]]
    local Value_2 = TeamInfo_upv_1.CurrentHomeTeam.Value
    HomeTeam_upv_1.BackgroundColor3 = tbl_upv_1[Value_2]
    HomeTeam_upv_1.UIStroke.Color = tbl_upv_2[Value_2]
    HomeTeam_upv_1.TeamName.TextStrokeColor3 = tbl_upv_2[Value_2]
    HomeTeam_upv_1.TeamName.Text = tbl_upv_4[Value_2]
    HomeTeam_upv_1.ImageLabel.Image = tbl_upv_3[Value_2]
    game.Workspace.gameArea.SelectedMap:WaitForChild("Scoreboard").Team1.TeamName.SurfaceGui.Frame.TextLabel.Text = tbl_upv_5[Value_2]
    game.Workspace.gameArea.SelectedMap:WaitForChild("Scoreboard").Team1.TeamName.SurfaceGui.Frame.TextLabel.TextStrokeColor3 = tbl_upv_2[Value_2]
    game.Workspace.gameArea.SelectedMap:WaitForChild("Scoreboard").Team1.TeamName.SurfaceGui.Frame.TextLabel.TextStrokeTransparency = 1
end
TeamInfo_upv_1.CurrentAwayTeam.Changed:Connect(
    function()
        --[[
          line: 399
        ]]
        handleAwayTeam()
    end
)
handleAwayTeam()
TeamInfo_upv_1.CurrentHomeTeam.Changed:Connect(
    function()
        --[[
          line: 404
        ]]
        handleHomeTeam()
    end
)
handleHomeTeam()
function handleScoreColor()
    --[[
      name: handleScoreColor
      line: 409
      upvalues:
        TeamInfo_upv_1 (copy, index: 1)
        Score_upv_1 (copy, index: 2)
        tbl_upv_1 (copy, index: 3)
        tbl_upv_2 (copy, index: 4)
    ]]
    local Value_3 = TeamInfo_upv_1.AwayTeamPoints.Value
    local Value_4 = TeamInfo_upv_1.HomeTeamPoints.Value
    if Value_4 < Value_3 then
        local Value_5 = TeamInfo_upv_1.CurrentAwayTeam.Value
        local TweenService_6 = game:GetService("TweenService")
        local v6 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tbl_11 = {}
        tbl_11.BackgroundColor3 = tbl_upv_1[Value_5]
        TweenService_6:Create(Score_upv_1, v6, tbl_11):Play()
        local TweenService_7 = game:GetService("TweenService")
        local v7 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tbl_12 = {Thickness = 2}
        tbl_12.Color = tbl_upv_2[Value_5]
        TweenService_7:Create(Score_upv_1.UIStroke, v7, tbl_12):Play()
        local TweenService_8 = game:GetService("TweenService")
        local v8 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tbl_13 = {}
        tbl_13.TextStrokeColor3 = tbl_upv_2[Value_5]
        TweenService_8:Create(Score_upv_1.Score, v8, tbl_13):Play()
    elseif Value_3 < Value_4 then
        local Value_6 = TeamInfo_upv_1.CurrentHomeTeam.Value
        local TweenService_9 = game:GetService("TweenService")
        local v9 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tbl_14 = {}
        tbl_14.BackgroundColor3 = tbl_upv_1[Value_6]
        TweenService_9:Create(Score_upv_1, v9, tbl_14):Play()
        local TweenService_10 = game:GetService("TweenService")
        local v10 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tbl_15 = {Thickness = 2}
        tbl_15.Color = tbl_upv_2[Value_6]
        TweenService_10:Create(Score_upv_1.UIStroke, v10, tbl_15):Play()
        local TweenService_11 = game:GetService("TweenService")
        local v11 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tbl_16 = {}
        tbl_16.TextStrokeColor3 = tbl_upv_2[Value_6]
        TweenService_11:Create(Score_upv_1.Score, v11, tbl_16):Play()
    elseif Value_4 == Value_3 then
        local TweenService_12 = game:GetService("TweenService")
        local v12 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tbl_17 = {}
        tbl_17.BackgroundColor3 = Color3.new(0, 0, 0)
        TweenService_12:Create(Score_upv_1, v12, tbl_17):Play()
        local TweenService_13 = game:GetService("TweenService")
        local v13 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tbl_18 = {Thickness = 1}
        tbl_18.Color = Color3.new(1, 1, 1)
        TweenService_13:Create(Score_upv_1.UIStroke, v13, tbl_18):Play()
        local TweenService_14 = game:GetService("TweenService")
        local v14 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        local tbl_19 = {}
        tbl_19.TextStrokeColor3 = Color3.new(0, 0, 0)
        TweenService_14:Create(Score_upv_1.Score, v14, tbl_19):Play()
    end
end
game.Players.LocalPlayer:WaitForChild("Settings"):WaitForChild("Misc").MapSelection.Changed:Connect(
    function()
        --[[
          line: 454
          upvalues:
            TeamInfo_upv_1 (copy, index: 1)
            tbl_upv_5 (copy, index: 2)
            tbl_upv_1 (copy, index: 3)
        ]]
        print("Map selection changed")
        local SelectedMap_1 = game.Workspace.gameArea:WaitForChild("SelectedMap")
        local u1 = nil
        SelectedMap_1.ChildAdded:Connect(
            function(a1)
                --[[
                  line: 459
                  upvalues:
                    u1 (ref, index: 1)
                ]]
                if a1.Name ~= "Scoreboard" then
                    return
                end
                u1 = a1
            end
        )
        while not (u1) do
            task.wait()
        end
        local v15 = u1:WaitForChild("Team1", 5)
        local v16 = u1:WaitForChild("Team2", 5)
        local v17 = ((TeamInfo_upv_1.HomeTeamPoints) and (TeamInfo_upv_1.HomeTeamPoints.Value)) or "?"
        local v18 = ((TeamInfo_upv_1.AwayTeamPoints) and (TeamInfo_upv_1.AwayTeamPoints.Value)) or "?"
        v15.Score.SurfaceGui.Frame.TextLabel.Text = v17
        v16.Score.SurfaceGui.Frame.TextLabel.Text = v18
        v15.TeamName.SurfaceGui.Frame.TextLabel.Text = tbl_upv_5[TeamInfo_upv_1.CurrentHomeTeam.Value]
        local TextLabel_1 = v15.TeamName.SurfaceGui.Frame.TextLabel
        TextLabel_1.TextStrokeColor3 = tbl_upv_1[TeamInfo_upv_1.CurrentHomeTeam.Value] or Color3.new(0, 0.0509804, 1)
        v15.TeamName.SurfaceGui.Frame.TextLabel.TextStrokeTransparency = 1
        v16.TeamName.SurfaceGui.Frame.TextLabel.Text = tbl_upv_5[TeamInfo_upv_1.CurrentAwayTeam.Value]
        local TextLabel_2 = v16.TeamName.SurfaceGui.Frame.TextLabel
        TextLabel_2.TextStrokeColor3 = tbl_upv_1[TeamInfo_upv_1.CurrentAwayTeam.Value] or Color3.new(1, 0.00784314, 0.00784314)
        v16.TeamName.SurfaceGui.Frame.TextLabel.TextStrokeTransparency = 1
        handleScoreColor()
    end
)
TeamInfo_upv_1.AwayTeamPoints.Changed:Connect(
    function()
        --[[
          line: 488
          upvalues:
            TeamInfo_upv_1 (copy, index: 1)
            Score_upv_1 (copy, index: 2)
        ]]
        game.Workspace.gameArea.SelectedMap:WaitForChild("Scoreboard").Team1.Score.SurfaceGui.Frame.TextLabel.Text = TeamInfo_upv_1.HomeTeamPoints.Value
        game.Workspace.gameArea.SelectedMap:WaitForChild("Scoreboard").Team2.Score.SurfaceGui.Frame.TextLabel.Text = TeamInfo_upv_1.AwayTeamPoints.Value
        Score_upv_1.Score.Text = TeamInfo_upv_1.HomeTeamPoints.Value .. "  -  " .. TeamInfo_upv_1.AwayTeamPoints.Value
        handleScoreColor()
    end
)
game.Workspace.gameArea.SelectedMap:WaitForChild("Scoreboard").Team1.Score.SurfaceGui.Frame.TextLabel.Text = TeamInfo_upv_1.HomeTeamPoints.Value
game.Workspace.gameArea.SelectedMap:WaitForChild("Scoreboard").Team2.Score.SurfaceGui.Frame.TextLabel.Text = TeamInfo_upv_1.AwayTeamPoints.Value
Score_upv_1.Score.Text = TeamInfo_upv_1.HomeTeamPoints.Value .. "  -  " .. TeamInfo_upv_1.AwayTeamPoints.Value
handleScoreColor()
TeamInfo_upv_1.HomeTeamPoints.Changed:Connect(
    function()
        --[[
          line: 499
          upvalues:
            TeamInfo_upv_1 (copy, index: 1)
            Score_upv_1 (copy, index: 2)
        ]]
        game.Workspace.gameArea.SelectedMap:WaitForChild("Scoreboard").Team1.Score.SurfaceGui.Frame.TextLabel.Text = TeamInfo_upv_1.HomeTeamPoints.Value
        game.Workspace.gameArea.SelectedMap:WaitForChild("Scoreboard").Team2.Score.SurfaceGui.Frame.TextLabel.Text = TeamInfo_upv_1.AwayTeamPoints.Value
        Score_upv_1.Score.Text = TeamInfo_upv_1.HomeTeamPoints.Value .. "  -  " .. TeamInfo_upv_1.AwayTeamPoints.Value
        handleScoreColor()
    end
)
game.Workspace.gameArea.SelectedMap:WaitForChild("Scoreboard").Team1.Score.SurfaceGui.Frame.TextLabel.Text = TeamInfo_upv_1.HomeTeamPoints.Value
game.Workspace.gameArea.SelectedMap:WaitForChild("Scoreboard").Team2.Score.SurfaceGui.Frame.TextLabel.Text = TeamInfo_upv_1.AwayTeamPoints.Value
Score_upv_1.Score.Text = TeamInfo_upv_1.HomeTeamPoints.Value .. "  -  " .. TeamInfo_upv_1.AwayTeamPoints.Value
handleScoreColor()
function setupTabFrame()
    --[[
      name: setupTabFrame
      line: 510
      upvalues:
        Container_upv_2 (copy, index: 1)
        Container_upv_1 (copy, index: 2)
        TeamInfo_upv_1 (copy, index: 3)
        tbl_upv_1 (copy, index: 4)
        tbl_upv_2 (copy, index: 5)
    ]]
    for _, value_upv_1 in pairs(game.Players:GetPlayers()) do
        if not (value_upv_1:FindFirstChild("dataLoaded")) or value_upv_1.SelectedTeam.Value == "N/A" then
            continue
        end
        if not ((((value_upv_1.SelectedTeam.Value == "Away") and Container_upv_2) or Container_upv_1):FindFirstChild(value_upv_1.Name)) then
            local v21 = ((value_upv_1.SelectedTeam.Value == "Away") and (TeamInfo_upv_1.CurrentAwayTeam.Value)) or (TeamInfo_upv_1.CurrentHomeTeam.Value)
            local u2 = script.plrInfoTemplate:Clone()
            u2.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, tbl_upv_1[v21]), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))})
            u2.UIStroke.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, tbl_upv_2[v21]), ColorSequenceKeypoint.new(1, Color3.new(0.294118, 0.294118, 0.294118))})
            u2.plrName.Text = string.upper(value_upv_1.DisplayName)
            u2.POSITION.Text = value_upv_1.SelectedPosition.Value
            u2.GOALS.Text = value_upv_1.GoalsThisGame.Value
            u2.OOB.Text = value_upv_1.PenaltyCount.Value
            u2.ASSISTS.Text = value_upv_1.AssistsThisGame.Value
            u2.POINTS.Text = value_upv_1.Points.Value
            u2.Name = value_upv_1.Name
            u2.Parent = ((value_upv_1.SelectedTeam.Value == "Away") and Container_upv_2) or Container_upv_1
            local u3 = value_upv_1.SelectedPosition.Changed:Connect(
                function()
                    --[[
                      line: 530
                      upvalues:
                        u2 (copy, index: 1)
                        value_upv_1 (copy, index: 2)
                    ]]
                    if not u2:FindFirstChild("POSITION") then
                        return
                    end
                    u2.POSITION.Text = value_upv_1.SelectedPosition.Value
                end
            )
            local u4 = value_upv_1.GoalsThisGame.Changed:Connect(
                function()
                    --[[
                      line: 534
                      upvalues:
                        u2 (copy, index: 1)
                        value_upv_1 (copy, index: 2)
                    ]]
                    if not u2:FindFirstChild("GOALS") then
                        return
                    end
                    u2.GOALS.Text = value_upv_1.GoalsThisGame.Value
                end
            )
            local u5 = value_upv_1.PenaltyCount.Changed:Connect(
                function()
                    --[[
                      line: 538
                      upvalues:
                        u2 (copy, index: 1)
                        value_upv_1 (copy, index: 2)
                    ]]
                    if not u2:FindFirstChild("OOB") then
                        return
                    end
                    u2.OOB.Text = value_upv_1.PenaltyCount.Value
                end
            )
            local u6 = value_upv_1.AssistsThisGame.Changed:Connect(
                function()
                    --[[
                      line: 542
                      upvalues:
                        u2 (copy, index: 1)
                        value_upv_1 (copy, index: 2)
                    ]]
                    if not u2:FindFirstChild("ASSISTS") then
                        return
                    end
                    u2.ASSISTS.Text = value_upv_1.AssistsThisGame.Value
                end
            )
            local u7 = value_upv_1.Points.Changed:Connect(
                function()
                    --[[
                      line: 546
                      upvalues:
                        u2 (copy, index: 1)
                        value_upv_1 (copy, index: 2)
                    ]]
                    if not u2:FindFirstChild("POINTS") then
                        return
                    end
                    u2.POINTS.Text = value_upv_1.Points.Value
                end
            )
            local u8 = value_upv_1.OffsideCount.Changed:Connect(
                function()
                    --[[
                      line: 550
                      upvalues:
                        u2 (copy, index: 1)
                        value_upv_1 (copy, index: 2)
                    ]]
                    if not u2:FindFirstChild("OFFSIDES") then
                        return
                    end
                    u2.OFFSIDES.Text = value_upv_1.OffsideCount.Value
                end
            )
            value_upv_1.SelectedTeam.Changed:Once(
                function()
                    --[[
                      line: 554
                      upvalues:
                        u2 (copy, index: 1)
                    ]]
                    u2:Destroy()
                end
            )
            u2.Destroying:Once(
                function()
                    --[[
                      line: 557
                      upvalues:
                        u3 (copy, index: 1)
                        u4 (copy, index: 2)
                        u5 (copy, index: 3)
                        u6 (copy, index: 4)
                        u7 (copy, index: 5)
                        u8 (copy, index: 6)
                    ]]
                    u3:Disconnect()
                    u4:Disconnect()
                    u5:Disconnect()
                    u6:Disconnect()
                    u7:Disconnect()
                    u8:Disconnect()
                end
            )
            local u9 = nil
            local v22 = value_upv_1.AncestryChanged:Connect(
                function()
                    --[[
                      line: 566
                      upvalues:
                        value_upv_1 (copy, index: 1)
                        u2 (copy, index: 2)
                        u9 (ref,  index: 3)
                    ]]
                    if (value_upv_1:IsDescendantOf(game)) then
                        return
                    end
                    u2:Destroy()
                    u9:Disconnect()
                end
            )
            u9 = v22
        end
    end
end
function updateHomeColorsTab()
    --[[
      name: updateHomeColorsTab
      line: 578
      upvalues:
        TabFrame_upv_1 (copy, index: 1)
        tbl_upv_1 (copy, index: 2)
        TeamInfo_upv_1 (copy, index: 3)
        tbl_upv_2 (copy, index: 4)
        Container_upv_1 (copy, index: 5)
        tbl_upv_3 (copy, index: 6)
    ]]
    TabFrame_upv_1.HomeFrame.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, tbl_upv_1[TeamInfo_upv_1.CurrentHomeTeam.Value]), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))})
    TabFrame_upv_1.HomeFrame.UIStroke.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, tbl_upv_2[TeamInfo_upv_1.CurrentHomeTeam.Value]), ColorSequenceKeypoint.new(1, Color3.new(0.294118, 0.294118, 0.294118))})
    Container_upv_1.TitleFrame.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, tbl_upv_1[TeamInfo_upv_1.CurrentHomeTeam.Value]), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))})
    Container_upv_1.TitleFrame.UIStroke.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, tbl_upv_2[TeamInfo_upv_1.CurrentHomeTeam.Value]), ColorSequenceKeypoint.new(1, Color3.new(0.294118, 0.294118, 0.294118))})
    Container_upv_1.TitleFrame.TeamCrest.Image = tbl_upv_3[TeamInfo_upv_1.CurrentHomeTeam.Value]
end
TeamInfo_upv_1.CurrentHomeTeam.Changed:Connect(
    function()
        --[[
          line: 586
        ]]
        updateHomeColorsTab()
    end
)
updateHomeColorsTab()
function updateAwayColorsTab()
    --[[
      name: updateAwayColorsTab
      line: 591
      upvalues:
        TabFrame_upv_1 (copy, index: 1)
        tbl_upv_1 (copy, index: 2)
        TeamInfo_upv_1 (copy, index: 3)
        tbl_upv_2 (copy, index: 4)
        Container_upv_2 (copy, index: 5)
        tbl_upv_3 (copy, index: 6)
    ]]
    TabFrame_upv_1.AwayFrame.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, tbl_upv_1[TeamInfo_upv_1.CurrentAwayTeam.Value]), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))})
    TabFrame_upv_1.AwayFrame.UIStroke.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, tbl_upv_2[TeamInfo_upv_1.CurrentAwayTeam.Value]), ColorSequenceKeypoint.new(1, Color3.new(0.294118, 0.294118, 0.294118))})
    Container_upv_2.TitleFrame.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, tbl_upv_1[TeamInfo_upv_1.CurrentAwayTeam.Value]), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))})
    Container_upv_2.TitleFrame.UIStroke.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, tbl_upv_2[TeamInfo_upv_1.CurrentAwayTeam.Value]), ColorSequenceKeypoint.new(1, Color3.new(0.294118, 0.294118, 0.294118))})
    Container_upv_2.TitleFrame.TeamCrest.Image = tbl_upv_3[TeamInfo_upv_1.CurrentAwayTeam.Value]
end
TeamInfo_upv_1.CurrentAwayTeam.Changed:Connect(
    function()
        --[[
          line: 599
        ]]
        updateAwayColorsTab()
    end
)
updateAwayColorsTab()
game:GetService("UserInputService").InputBegan:Connect(
    function(a1, a2)
        --[[
          line: 604
          upvalues:
            TabFrame_upv_1 (copy, index: 1)
        ]]
        if a1.KeyCode ~= Enum.KeyCode.Tab then
            return
        end
        setupTabFrame()
        TabFrame_upv_1.Visible = true
    end
)
game:GetService("UserInputService").InputEnded:Connect(
    function(a1, a2)
        --[[
          line: 611
          upvalues:
            TabFrame_upv_1 (copy, index: 1)
        ]]
        if a1.KeyCode ~= Enum.KeyCode.Tab then
            return
        end
        TabFrame_upv_1.Visible = false
    end
)
local Shootout_upv_1 = script.Parent.Shootout
local FinalShootout_upv_1 = script.Parent.FinalShootout
game.ReplicatedStorage.ChildAdded:Connect(
    function(a1)
        --[[
          line: 621
          upvalues:
            Shootout_upv_1 (copy, index: 1)
            FinalShootout_upv_1 (copy, index: 2)
        ]]
        if a1.Name == "Shootout" then
            task.wait(0.8)
            local HomeSuccess_upv_1 = a1:WaitForChild("HomeSuccess")
            local HomeTeamFail_upv_1 = a1:WaitForChild("HomeTeamFail")
            local AwaySuccess_upv_1 = a1:WaitForChild("AwaySuccess")
            local AwayTeamFail_upv_1 = a1:WaitForChild("AwayTeamFail")
            local currentShotNum_upv_1 = a1:WaitForChild("currentShotNum")
            local TweenService_15 = game:GetService("TweenService")
            local v23 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
            local tbl_20 = {}
            tbl_20.Position = UDim2.new(0.5, 0, 0, 148)
            TweenService_15:Create(Shootout_upv_1, v23, tbl_20):Play()
            for _, value_2 in pairs(Shootout_upv_1.HomeTeam:GetChildren()) do
                if value_2:IsA("ImageLabel") then
                    local tbl_21 = {BackgroundTransparency = 0.5}
                    game:GetService("TweenService"):Create(value_2, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_21):Play()
                    local tbl_22 = {Transparency = 0.5}
                    game:GetService("TweenService"):Create(value_2.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_22):Play()
                end
            end
            for _, value_3 in pairs(Shootout_upv_1.AwayTeam:GetChildren()) do
                if value_3:IsA("ImageLabel") then
                    local tbl_23 = {BackgroundTransparency = 0.5}
                    game:GetService("TweenService"):Create(value_3, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_23):Play()
                    local tbl_24 = {Transparency = 0.5}
                    game:GetService("TweenService"):Create(value_3.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_24):Play()
                end
            end
            local u10 = HomeSuccess_upv_1.Changed:Connect(
                function()
                    --[[
                      line: 653
                      upvalues:
                        currentShotNum_upv_1 (copy, index: 1)
                        HomeSuccess_upv_1 (copy, index: 2)
                        Shootout_upv_1 (copy, index: 3)
                    ]]
                    if currentShotNum_upv_1.Value ~= 1 then
                        if currentShotNum_upv_1.Value ~= 3 then
                            if currentShotNum_upv_1.Value ~= 5 then
                                return
                            end
                            if HomeSuccess_upv_1.Value >= 1 then
                                Shootout_upv_1.HomeTeam.Shot3.Result.BackgroundColor3 = Color3.new(0, 0.666667, 0)
                                local tbl_25 = {BackgroundTransparency = 0}
                                game:GetService("TweenService"):Create(Shootout_upv_1.HomeTeam.Shot3.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_25):Play()
                            end
                        elseif HomeSuccess_upv_1.Value >= 1 then
                            Shootout_upv_1.HomeTeam.Shot2.Result.BackgroundColor3 = Color3.new(0, 0.666667, 0)
                            local tbl_26 = {BackgroundTransparency = 0}
                            game:GetService("TweenService"):Create(Shootout_upv_1.HomeTeam.Shot2.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_26):Play()
                        end
                    elseif HomeSuccess_upv_1.Value >= 1 then
                        Shootout_upv_1.HomeTeam.Shot1.Result.BackgroundColor3 = Color3.new(0, 0.666667, 0)
                        local tbl_27 = {BackgroundTransparency = 0}
                        game:GetService("TweenService"):Create(Shootout_upv_1.HomeTeam.Shot1.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_27):Play()
                    end
                end
            )
            local u11 = AwaySuccess_upv_1.Changed:Connect(
                function()
                    --[[
                      line: 677
                      upvalues:
                        currentShotNum_upv_1 (copy, index: 1)
                        AwaySuccess_upv_1 (copy, index: 2)
                        Shootout_upv_1 (copy, index: 3)
                    ]]
                    if currentShotNum_upv_1.Value ~= 2 then
                        if currentShotNum_upv_1.Value ~= 4 then
                            if currentShotNum_upv_1.Value ~= 6 then
                                return
                            end
                            if AwaySuccess_upv_1.Value >= 1 then
                                Shootout_upv_1.AwayTeam.Shot3.Result.BackgroundColor3 = Color3.new(0, 0.666667, 0)
                                local tbl_28 = {BackgroundTransparency = 0}
                                game:GetService("TweenService"):Create(Shootout_upv_1.AwayTeam.Shot3.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_28):Play()
                            end
                        elseif AwaySuccess_upv_1.Value >= 1 then
                            Shootout_upv_1.AwayTeam.Shot2.Result.BackgroundColor3 = Color3.new(0, 0.666667, 0)
                            local tbl_29 = {BackgroundTransparency = 0}
                            game:GetService("TweenService"):Create(Shootout_upv_1.AwayTeam.Shot2.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_29):Play()
                        end
                    elseif AwaySuccess_upv_1.Value >= 1 then
                        Shootout_upv_1.AwayTeam.Shot1.Result.BackgroundColor3 = Color3.new(0, 0.666667, 0)
                        local tbl_30 = {BackgroundTransparency = 0}
                        game:GetService("TweenService"):Create(Shootout_upv_1.AwayTeam.Shot1.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_30):Play()
                    end
                end
            )
            local u12 = HomeTeamFail_upv_1.Changed:Connect(
                function()
                    --[[
                      line: 701
                      upvalues:
                        currentShotNum_upv_1 (copy, index: 1)
                        HomeTeamFail_upv_1 (copy, index: 2)
                        Shootout_upv_1 (copy, index: 3)
                    ]]
                    if currentShotNum_upv_1.Value ~= 1 then
                        if currentShotNum_upv_1.Value ~= 3 then
                            if currentShotNum_upv_1.Value ~= 5 then
                                return
                            end
                            if HomeTeamFail_upv_1.Value >= 1 then
                                Shootout_upv_1.HomeTeam.Shot3.Result.BackgroundColor3 = Color3.new(0.666667, 0, 0)
                                local tbl_31 = {BackgroundTransparency = 0}
                                game:GetService("TweenService"):Create(Shootout_upv_1.HomeTeam.Shot3.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_31):Play()
                            end
                        elseif HomeTeamFail_upv_1.Value >= 1 then
                            Shootout_upv_1.HomeTeam.Shot2.Result.BackgroundColor3 = Color3.new(0.666667, 0, 0)
                            local tbl_32 = {BackgroundTransparency = 0}
                            game:GetService("TweenService"):Create(Shootout_upv_1.HomeTeam.Shot2.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_32):Play()
                        end
                    elseif HomeTeamFail_upv_1.Value >= 1 then
                        Shootout_upv_1.HomeTeam.Shot1.Result.BackgroundColor3 = Color3.new(0.666667, 0, 0)
                        local tbl_33 = {BackgroundTransparency = 0}
                        game:GetService("TweenService"):Create(Shootout_upv_1.HomeTeam.Shot1.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_33):Play()
                    end
                end
            )
            local u13 = AwayTeamFail_upv_1.Changed:Connect(
                function()
                    --[[
                      line: 725
                      upvalues:
                        currentShotNum_upv_1 (copy, index: 1)
                        AwayTeamFail_upv_1 (copy, index: 2)
                        Shootout_upv_1 (copy, index: 3)
                    ]]
                    if currentShotNum_upv_1.Value ~= 2 then
                        if currentShotNum_upv_1.Value ~= 4 then
                            if currentShotNum_upv_1.Value ~= 6 then
                                return
                            end
                            if AwayTeamFail_upv_1.Value >= 1 then
                                Shootout_upv_1.AwayTeam.Shot3.Result.BackgroundColor3 = Color3.new(0.666667, 0, 0)
                                local tbl_34 = {BackgroundTransparency = 0}
                                game:GetService("TweenService"):Create(Shootout_upv_1.AwayTeam.Shot3.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_34):Play()
                            end
                        elseif AwayTeamFail_upv_1.Value >= 1 then
                            Shootout_upv_1.AwayTeam.Shot2.Result.BackgroundColor3 = Color3.new(0.666667, 0, 0)
                            local tbl_35 = {BackgroundTransparency = 0}
                            game:GetService("TweenService"):Create(Shootout_upv_1.AwayTeam.Shot2.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_35):Play()
                        end
                    elseif AwayTeamFail_upv_1.Value >= 1 then
                        Shootout_upv_1.AwayTeam.Shot1.Result.BackgroundColor3 = Color3.new(0.666667, 0, 0)
                        local tbl_36 = {BackgroundTransparency = 0}
                        game:GetService("TweenService"):Create(Shootout_upv_1.AwayTeam.Shot1.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_36):Play()
                    end
                end
            )
            a1.Destroying:Once(
                function()
                    --[[
                      line: 749
                      upvalues:
                        u10 (copy, index: 1)
                        u11 (copy, index: 2)
                        u12 (copy, index: 3)
                        u13 (copy, index: 4)
                        Shootout_upv_1 (copy, index: 5)
                    ]]
                    task.wait(0.5)
                    u10:Disconnect()
                    u11:Disconnect()
                    u12:Disconnect()
                    u13:Disconnect()
                    local TweenService_16 = game:GetService("TweenService")
                    local v24 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
                    local tbl_37 = {}
                    tbl_37.Position = UDim2.new(0.5, 0, 0, 100)
                    TweenService_16:Create(Shootout_upv_1, v24, tbl_37):Play()
                    for _, value_4 in pairs(Shootout_upv_1.HomeTeam:GetChildren()) do
                        if value_4:IsA("ImageLabel") then
                            local tbl_38 = {BackgroundTransparency = 1}
                            game:GetService("TweenService"):Create(value_4, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_38):Play()
                            local tbl_39 = {BackgroundTransparency = 1}
                            game:GetService("TweenService"):Create(value_4.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_39):Play()
                            local tbl_40 = {Transparency = 1}
                            game:GetService("TweenService"):Create(value_4.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_40):Play()
                        end
                    end
                    for _, value_5 in pairs(Shootout_upv_1.AwayTeam:GetChildren()) do
                        if value_5:IsA("ImageLabel") then
                            local tbl_41 = {BackgroundTransparency = 1}
                            game:GetService("TweenService"):Create(value_5, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_41):Play()
                            local tbl_42 = {BackgroundTransparency = 1}
                            game:GetService("TweenService"):Create(value_5.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_42):Play()
                            local tbl_43 = {Transparency = 1}
                            game:GetService("TweenService"):Create(value_5.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_43):Play()
                        end
                    end
                end
            )
        elseif a1.Name == "FinalShootout" then
            task.wait(0.8)
            local Shot_upv_1 = FinalShootout_upv_1.HomeTeam.Shot
            local Shot_upv_2 = FinalShootout_upv_1.AwayTeam.Shot
            local TweenService_17 = game:GetService("TweenService")
            local v25 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
            local tbl_44 = {}
            tbl_44.Position = UDim2.new(0.5, 0, 0, 148)
            TweenService_17:Create(FinalShootout_upv_1, v25, tbl_44):Play()
            local tbl_45 = {BackgroundTransparency = 0.5}
            game:GetService("TweenService"):Create(Shot_upv_1, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_45):Play()
            local tbl_46 = {Transparency = 0.5}
            game:GetService("TweenService"):Create(Shot_upv_1.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_46):Play()
            local tbl_47 = {BackgroundTransparency = 0.5}
            game:GetService("TweenService"):Create(Shot_upv_2, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_47):Play()
            local tbl_48 = {Transparency = 0.5}
            game:GetService("TweenService"):Create(Shot_upv_2.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_48):Play()
            local u14 = a1.ChildAdded:Connect(
                function(a2)
                    --[[
                      line: 805
                      upvalues:
                        Shot_upv_1 (copy, index: 1)
                        Shot_upv_2 (copy, index: 2)
                    ]]
                    if a2.Name == "HomeTeamSuccess" then
                        Shot_upv_1.Result.BackgroundColor3 = Color3.new(0, 0.666667, 0)
                        local tbl_49 = {BackgroundTransparency = 0}
                        game:GetService("TweenService"):Create(Shot_upv_1.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_49):Play()
                        a2.Destroying:Connect(
                            function()
                                --[[
                                  line: 811
                                  upvalues:
                                    Shot_upv_1 (copy, index: 1)
                                ]]
                                local tbl_50 = {BackgroundTransparency = 1}
                                game:GetService("TweenService"):Create(Shot_upv_1.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_50):Play()
                            end
                        )
                    elseif a2.Name == "AwayTeamSuccess" then
                        Shot_upv_2.Result.BackgroundColor3 = Color3.new(0, 0.666667, 0)
                        local tbl_51 = {BackgroundTransparency = 0}
                        game:GetService("TweenService"):Create(Shot_upv_2.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_51):Play()
                        a2.Destroying:Connect(
                            function()
                                --[[
                                  line: 821
                                  upvalues:
                                    Shot_upv_2 (copy, index: 1)
                                ]]
                                local tbl_52 = {BackgroundTransparency = 1}
                                game:GetService("TweenService"):Create(Shot_upv_2.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_52):Play()
                            end
                        )
                    elseif a2.Name == "HomeTeamFail" then
                        Shot_upv_1.Result.BackgroundColor3 = Color3.new(0.666667, 0, 0)
                        local tbl_53 = {BackgroundTransparency = 0}
                        game:GetService("TweenService"):Create(Shot_upv_1.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_53):Play()
                        a2.Destroying:Connect(
                            function()
                                --[[
                                  line: 831
                                  upvalues:
                                    Shot_upv_1 (copy, index: 1)
                                ]]
                                local tbl_54 = {BackgroundTransparency = 1}
                                game:GetService("TweenService"):Create(Shot_upv_1.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_54):Play()
                            end
                        )
                    elseif a2.Name == "AwayTeamFail" then
                        Shot_upv_2.Result.BackgroundColor3 = Color3.new(0.666667, 0, 0)
                        local tbl_55 = {BackgroundTransparency = 0}
                        game:GetService("TweenService"):Create(Shot_upv_2.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_55):Play()
                        a2.Destroying:Connect(
                            function()
                                --[[
                                  line: 841
                                  upvalues:
                                    Shot_upv_2 (copy, index: 1)
                                ]]
                                local tbl_56 = {BackgroundTransparency = 1}
                                game:GetService("TweenService"):Create(Shot_upv_2.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_56):Play()
                            end
                        )
                    end
                end
            )
            a1.Destroying:Once(
                function()
                    --[[
                      line: 848
                      upvalues:
                        u14 (copy, index: 1)
                        FinalShootout_upv_1 (copy, index: 2)
                        Shot_upv_1 (copy, index: 3)
                        Shot_upv_2 (copy, index: 4)
                    ]]
                    task.wait(0.5)
                    u14:Disconnect()
                    local TweenService_18 = game:GetService("TweenService")
                    local v26 = TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
                    local tbl_57 = {}
                    tbl_57.Position = UDim2.new(0.5, 0, 0, 100)
                    TweenService_18:Create(FinalShootout_upv_1, v26, tbl_57):Play()
                    local tbl_58 = {BackgroundTransparency = 1}
                    game:GetService("TweenService"):Create(Shot_upv_1, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_58):Play()
                    local tbl_59 = {Transparency = 1}
                    game:GetService("TweenService"):Create(Shot_upv_1.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_59):Play()
                    local tbl_60 = {BackgroundTransparency = 1}
                    game:GetService("TweenService"):Create(Shot_upv_1.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_60):Play()
                    local tbl_61 = {BackgroundTransparency = 1}
                    game:GetService("TweenService"):Create(Shot_upv_2, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_61):Play()
                    local tbl_62 = {Transparency = 1}
                    game:GetService("TweenService"):Create(Shot_upv_2.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_62):Play()
                    local tbl_63 = {BackgroundTransparency = 1}
                    game:GetService("TweenService"):Create(Shot_upv_2.Result, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), tbl_63):Play()
                end
            )
        end
    end
)