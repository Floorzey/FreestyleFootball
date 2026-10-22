--[[
    Script Path: Game/StarterGui/Menu/PSCommandHandler
    Class: LocalScript
    Time: 2026-10-03 12:27:08
--]]

local v1 = game.ReplicatedStorage:FindFirstChild("PSOwnerID") or (game.ReplicatedStorage:WaitForChild("PSOwnerID", 30))
if not v1 or game.Players.LocalPlayer.UserId ~= v1.Value then
    return
end
local tbl_upv_1 = {}
tbl_upv_1.AstonVilla = "rbxassetid://81835506871297"
tbl_upv_1.Flamengo = "rbxassetid://110918350569178"
tbl_upv_1.Argentina = "rbxassetid://15068029862"
tbl_upv_1.Munich = "rbxassetid://15068635815"
tbl_upv_1.Dortmund = "rbxassetid://13460575423"
tbl_upv_1.Brazil = "rbxassetid://15068649812"
tbl_upv_1.ParisSaints = "rbxassetid://13552953245"
tbl_upv_1.ManchesterU = "rbxassetid://14540294821"
tbl_upv_1.Barcelona = "rbxassetid://316144192"
tbl_upv_1.InterMiami = "rbxassetid://15081749904"
tbl_upv_1.Japan = "rbxassetid://15098627666"
tbl_upv_1.Italy = "rbxassetid://15107657423"
tbl_upv_1.Croatia = "rbxassetid://15107652254"
tbl_upv_1.Morocco = "rbxassetid://15107668354"
tbl_upv_1.Canada = "rbxassetid://15107670722"
tbl_upv_1.Portugal = "rbxassetid://15148310170"
tbl_upv_1.Mexico = "rbxassetid://15107685948"
tbl_upv_1.Netherlands = "rbxassetid://15107690732"
tbl_upv_1.RealMadrid = "rbxassetid://15107692601"
tbl_upv_1.LiverpoolFC = "rbxassetid://5525377475"
tbl_upv_1.SeattleSoundersFC = "rbxassetid://15155280087"
tbl_upv_1.JuventusFC = "rbxassetid://15238497443"
tbl_upv_1.Newcastle = "rbxassetid://18897627545"
tbl_upv_1.ManchesterCity = "rbxassetid://14243657473"
tbl_upv_1.Germany = "rbxassetid://18640980135"
tbl_upv_1.England = "rbxassetid://18641004985"
tbl_upv_1.Arsenal = "rbxassetid://18652402819"
tbl_upv_1.InterMilan = "rbxassetid://18816070754"
tbl_upv_1.USA = "rbxassetid://18641031024"
tbl_upv_1.Chelsea = "rbxassetid://18641029244"
tbl_upv_1.Napoli = "rbxassetid://18641026783"
tbl_upv_1.France = "rbxassetid://18641023325"
tbl_upv_1.Uruguay = "rbxassetid://18641021338"
tbl_upv_1.Roma = "rbxassetid://18641019719"
tbl_upv_1.Lazio = "rbxassetid://18641016564"
tbl_upv_1.SouthKorea = "rbxassetid://18641001856"
tbl_upv_1.VascoDaGama = "rbxassetid://18640997828"
tbl_upv_1.Ajax = "rbxassetid://18640996176"
tbl_upv_1.Atletico = "rbxassetid://18640993960"
tbl_upv_1.Leverkusen = "rbxassetid://18640992087"
tbl_upv_1.Wales = "rbxassetid://18640989958"
tbl_upv_1.Fiorentina = "rbxassetid://18640988644"
tbl_upv_1.Spurs = "rbxassetid://18640987300"
tbl_upv_1.ACMilan = "rbxassetid://18640984312"
tbl_upv_1.Belgium = "rbxassetid://18641190960"
tbl_upv_1.Spain = "rbxassetid://18672737980"
tbl_upv_1.Scotland = "rbxassetid://18672741584"
tbl_upv_1.Poland = "rbxassetid://18816097298"
tbl_upv_1.Sweden = "rbxassetid://18897774513"
tbl_upv_1.Bosnia = "rbxassetid://18897785797"
tbl_upv_1.Denmark = "rbxassetid://18897980982"
tbl_upv_1.Romania = "rbxassetid://18897982581"
tbl_upv_1.Switzerland = "rbxassetid://18897984306"
local tbl_upv_2 = {}
tbl_upv_2.Argentina = "ARG"
tbl_upv_2.AstonVilla = "ASV"
tbl_upv_2.Flamengo = "FLA"
tbl_upv_2.Munich = "BAY"
tbl_upv_2.Dortmund = "DOR"
tbl_upv_2.Brazil = "BRA"
tbl_upv_2.ParisSaints = "PSG"
tbl_upv_2.ManchesterU = "MUN"
tbl_upv_2.Barcelona = "FCB"
tbl_upv_2.InterMiami = "MIA"
tbl_upv_2.Japan = "JPN"
tbl_upv_2.Italy = "ITA"
tbl_upv_2.Croatia = "CRO"
tbl_upv_2.Morocco = "MAR"
tbl_upv_2.Canada = "CAN"
tbl_upv_2.Portugal = "POR"
tbl_upv_2.Mexico = "MEX"
tbl_upv_2.Netherlands = "NED"
tbl_upv_2.RealMadrid = "RMA"
tbl_upv_2.LiverpoolFC = "LFC"
tbl_upv_2.SeattleSoundersFC = "SEA"
tbl_upv_2.JuventusFC = "JUV"
tbl_upv_2.Newcastle = "NEW"
tbl_upv_2.ManchesterCity = "MCI"
tbl_upv_2.Germany = "GER"
tbl_upv_2.England = "ENG"
tbl_upv_2.Arsenal = "ASL"
tbl_upv_2.InterMilan = "INT"
tbl_upv_2.USA = "USA"
tbl_upv_2.Chelsea = "CHE"
tbl_upv_2.Napoli = "NAP"
tbl_upv_2.France = "FRA"
tbl_upv_2.Uruguay = "URU"
tbl_upv_2.Roma = "ROM"
tbl_upv_2.Lazio = "LAZ"
tbl_upv_2.SouthKorea = "KOR"
tbl_upv_2.VascoDaGama = "VAS"
tbl_upv_2.Ajax = "AFC"
tbl_upv_2.Atletico = "AMA"
tbl_upv_2.Leverkusen = "B04"
tbl_upv_2.Wales = "WAL"
tbl_upv_2.Fiorentina = "FIO"
tbl_upv_2.Spurs = "TOT"
tbl_upv_2.ACMilan = "MIL"
tbl_upv_2.Belgium = "BEL"
tbl_upv_2.Spain = "ESP"
tbl_upv_2.Scotland = "SCO"
tbl_upv_2.Poland = "POL"
tbl_upv_2.Sweden = "SWE"
tbl_upv_2.Bosnia = "BIH"
tbl_upv_2.Denmark = "DEN"
tbl_upv_2.Romania = "ROU"
tbl_upv_2.Switzerland = "SUI"
local teamPicker_upv_1 = script.Parent.teamPicker
local PSCommandsFrame_upv_1 = script.Parent.PSCommandsFrame
script.Parent.LeftFrame.PSCommandsButton.Visible = true
local ReplicatedStorage_upv_1 = game.ReplicatedStorage
local u1 = game.Players.LocalPlayer:GetMouse()
local Slider_upv_1 = script:WaitForChild("Slider")
local u2 = false
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
local u3 = Knit_1.GetService("KeyHandlerService"):GetKey("PSCommand")
local UserInputService_upv_1 = game:GetService("UserInputService")
UserInputService_upv_1.InputChanged:Connect(
    function()
        --[[
          line: 133
          upvalues:
            UserInputService_upv_1 (copy, index: 1)
            PSCommandsFrame_upv_1 (copy, index: 2)
        ]]
        if UserInputService_upv_1:GetLastInputType() ~= Enum.UserInputType.Touch then
            PSCommandsFrame_upv_1.Position = UDim2.new(0.23, 0, 0.5, 0)
        else
            PSCommandsFrame_upv_1.Position = UDim2.new(0.5, 0, 0.5, 0)
        end
    end
)
local function makeSlider(a1, a2)
    --[[
      name: makeSlider
      line: 141
      upvalues:
        Slider_upv_1 (copy, index: 1)
        u2 (ref,  index: 2)
        u1 (copy, index: 3)
    ]]
    local u4 = Slider_upv_1:clone()
    u4.Parent = a1
    u4.Position = UDim2.new(a2, 0, 0.5, 0)
    local X_upv_1 = a1.AbsolutePosition.X
    local X_upv_2 = a1.AbsoluteSize.X
    u4.MouseButton1Down:connect(
        function()
            --[[
              line: 147
              upvalues:
                u2 (ref,  index: 1)
                u1 (copy, index: 2)
                X_upv_1 (copy, index: 3)
                X_upv_2 (copy, index: 4)
                u4 (copy, index: 5)
            ]]
            if u2 then
                return
            end
            u2 = true
            repeat
                u4.Position = UDim2.new(math.round(Snap(math.clamp((u1.X - X_upv_1) / X_upv_2, 0, 1), 0.02) * 100) / 100, 0, 0.5, 0)
                game:GetService("RunService").RenderStepped:wait()
            until not (u2)
        end
    )
    return u4
end
local u5 = makeSlider(PSCommandsFrame_upv_1.ShotPower, 0)
local u6 = makeSlider(PSCommandsFrame_upv_1.RunSpeed, 0)
local function update()
    --[[
      name: update
      line: 167
      upvalues:
        ReplicatedStorage_upv_1 (copy, index: 1)
        PSCommandsFrame_upv_1 (copy, index: 2)
    ]]
    if ReplicatedStorage_upv_1:FindFirstChild("NoSkillUsage") then
        PSCommandsFrame_upv_1.noSkillsButton.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        PSCommandsFrame_upv_1.noSkillsButton.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
    if ReplicatedStorage_upv_1:FindFirstChild("noLevelRequirement") then
        PSCommandsFrame_upv_1.noSkillReqsButton.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        PSCommandsFrame_upv_1.noSkillReqsButton.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
    if ReplicatedStorage_upv_1:FindFirstChild("timerPaused") then
        PSCommandsFrame_upv_1.PauseTimerButton.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        PSCommandsFrame_upv_1.PauseTimerButton.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
    if ReplicatedStorage_upv_1:FindFirstChild("NoSkillCD") then
        PSCommandsFrame_upv_1.NoSkillCDButton.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        PSCommandsFrame_upv_1.NoSkillCDButton.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
    if ReplicatedStorage_upv_1:FindFirstChild("firstPersonLock") then
        PSCommandsFrame_upv_1.lockFirstPerson.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        PSCommandsFrame_upv_1.lockFirstPerson.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
    if ReplicatedStorage_upv_1:FindFirstChild("noPlayReset") then
        PSCommandsFrame_upv_1.noPlayResetButton.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        PSCommandsFrame_upv_1.noPlayResetButton.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
    if ReplicatedStorage_upv_1:FindFirstChild("InfiniteStamina") then
        PSCommandsFrame_upv_1.InfiniteStamina.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        PSCommandsFrame_upv_1.InfiniteStamina.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
    if ReplicatedStorage_upv_1:FindFirstChild("NoFullSprint") then
        PSCommandsFrame_upv_1.FullSprintOff.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    else
        PSCommandsFrame_upv_1.FullSprintOff.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    end
    if ReplicatedStorage_upv_1:FindFirstChild("gkReplacement") then
        PSCommandsFrame_upv_1.GKReplacer.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        PSCommandsFrame_upv_1.GKReplacer.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
    if ReplicatedStorage_upv_1:FindFirstChild("lockedHitbox") then
        PSCommandsFrame_upv_1.LockedHitbox.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        PSCommandsFrame_upv_1.LockedHitbox.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
    if ReplicatedStorage_upv_1:FindFirstChild("NoTeamLimits") then
        PSCommandsFrame_upv_1.DisableTeamLimits.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        PSCommandsFrame_upv_1.DisableTeamLimits.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
end
ReplicatedStorage_upv_1.ChildAdded:Connect(update)
ReplicatedStorage_upv_1.ChildRemoved:Connect(update)
function Snap(a1, a2)
    --[[
      name: Snap
      line: 228
    ]]
    return a1 - (a1 % a2)
end
function sliderValToMult1(a1)
    --[[
      name: sliderValToMult1
      line: 232
    ]]
    if a1 < 0.1 then
        return 1
    end
    if a1 < 0.2 then
        return 1.2
    end
    if a1 < 0.3 then
        return 1.4
    end
    if a1 < 0.4 then
        return 1.6
    end
    if a1 < 0.5 then
        return 1.8
    end
    if a1 < 0.6 then
        return 2
    end
    if a1 < 0.7 then
        return 3
    elseif a1 < 0.8 then
        return 4
    else
        return 5
    end
end
function sliderValToMult2(a1)
    --[[
      name: sliderValToMult2
      line: 263
    ]]
    if a1 < 0.1 then
        return 1
    end
    if a1 < 0.2 then
        return 1.2
    end
    if a1 < 0.3 then
        return 1.4
    end
    if a1 < 0.4 then
        return 1.6
    end
    if a1 < 0.5 then
        return 1.8
    end
    if a1 < 0.6 then
        return 2
    end
    if a1 < 0.7 then
        return 2.2
    end
    if a1 < 0.8 then
        return 2.4
    elseif a1 < 0.9 then
        return 2.6
    else
        return 3
    end
end
game:GetService("UserInputService").InputEnded:connect(
    function(a1)
        --[[
          line: 294
          upvalues:
            u2 (ref,  index: 1)
            u3 (copy, index: 2)
            u5 (copy, index: 3)
            u6 (copy, index: 4)
        ]]
        if a1.UserInputType ~= Enum.UserInputType.MouseButton1 or u2 ~= true then
            return
        end
        u2 = false
        u3:FireServer("setShotPower", {val = sliderValToMult1(u5.Position.X.Scale)})
        u3:FireServer("setRunSpeed", {val = sliderValToMult2(u6.Position.X.Scale)})
    end
)
u5:GetPropertyChangedSignal("Position"):Connect(
    function()
        --[[
          line: 306
          upvalues:
            PSCommandsFrame_upv_1 (copy, index: 1)
            u5 (copy, index: 2)
        ]]
        PSCommandsFrame_upv_1.ShotPower.AMOUNT.Text = "x" .. sliderValToMult1(u5.Position.X.Scale)
    end
)
u6:GetPropertyChangedSignal("Position"):Connect(
    function()
        --[[
          line: 310
          upvalues:
            PSCommandsFrame_upv_1 (copy, index: 1)
            u6 (copy, index: 2)
        ]]
        PSCommandsFrame_upv_1.RunSpeed.AMOUNT.Text = "x" .. sliderValToMult2(u6.Position.X.Scale)
    end
)
script.Parent.LeftFrame.PSCommandsButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 314
          upvalues:
            PSCommandsFrame_upv_1 (copy, index: 1)
            teamPicker_upv_1 (copy, index: 2)
        ]]
        PSCommandsFrame_upv_1.Visible = not PSCommandsFrame_upv_1.Visible
        teamPicker_upv_1.Visible = false
    end
)
PSCommandsFrame_upv_1.CloseButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 319
          upvalues:
            PSCommandsFrame_upv_1 (copy, index: 1)
            teamPicker_upv_1 (copy, index: 2)
        ]]
        PSCommandsFrame_upv_1.Visible = not PSCommandsFrame_upv_1.Visible
        teamPicker_upv_1.Visible = false
    end
)
PSCommandsFrame_upv_1.PauseTimerButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 324
          upvalues:
            u3 (copy, index: 1)
        ]]
        u3:FireServer("PauseTimer")
    end
)
PSCommandsFrame_upv_1.EndMatchButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 328
          upvalues:
            u3 (copy, index: 1)
        ]]
        u3:FireServer("EndGame")
    end
)
PSCommandsFrame_upv_1.GKReplacer.MouseButton1Click:Connect(
    function()
        --[[
          line: 332
          upvalues:
            u3 (copy, index: 1)
        ]]
        u3:FireServer("ToggleGKReplacement")
    end
)
PSCommandsFrame_upv_1.lockFirstPerson.MouseButton1Click:Connect(
    function()
        --[[
          line: 336
          upvalues:
            u3 (copy, index: 1)
        ]]
        u3:FireServer("ToggleFirstPersonLock")
    end
)
PSCommandsFrame_upv_1.NoSkillCDButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 340
          upvalues:
            u3 (copy, index: 1)
        ]]
        u3:FireServer("NoSkillCooldown")
    end
)
PSCommandsFrame_upv_1.noSkillsButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 344
          upvalues:
            u3 (copy, index: 1)
        ]]
        u3:FireServer("NoSkillUsage")
    end
)
PSCommandsFrame_upv_1.noSkillReqsButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 348
          upvalues:
            u3 (copy, index: 1)
        ]]
        u3:FireServer("NoSkillReqs")
    end
)
PSCommandsFrame_upv_1.noPlayResetButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 352
          upvalues:
            u3 (copy, index: 1)
        ]]
        u3:FireServer("DisablePlayReset")
    end
)
PSCommandsFrame_upv_1.InfiniteStamina.MouseButton1Click:Connect(
    function()
        --[[
          line: 356
          upvalues:
            u3 (copy, index: 1)
        ]]
        u3:FireServer("InfiniteStamina")
    end
)
PSCommandsFrame_upv_1.FullSprintOff.MouseButton1Click:Connect(
    function()
        --[[
          line: 360
          upvalues:
            u3 (copy, index: 1)
        ]]
        u3:FireServer("FullSprintOff")
    end
)
PSCommandsFrame_upv_1.DisableTeamLimits.MouseButton1Click:Connect(
    function()
        --[[
          line: 364
          upvalues:
            u3 (copy, index: 1)
        ]]
        u3:FireServer("NoTeamLimit")
    end
)
PSCommandsFrame_upv_1.LockedHitbox.MouseButton1Click:Connect(
    function()
        --[[
          line: 368
          upvalues:
            u3 (copy, index: 1)
        ]]
        u3:FireServer("LockedHitbox")
    end
)
PSCommandsFrame_upv_1.penShootoutButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 372
          upvalues:
            u3 (copy, index: 1)
        ]]
        u3:FireServer("StartShootout")
    end
)
PSCommandsFrame_upv_1.PlaceDefender.MouseButton1Click:Connect(
    function()
        --[[
          line: 376
          upvalues:
            u3 (copy, index: 1)
        ]]
        u3:FireServer("PlaceDefender")
    end
)
PSCommandsFrame_upv_1.ClearDefenders.MouseButton1Click:Connect(
    function()
        --[[
          line: 380
          upvalues:
            u3 (copy, index: 1)
        ]]
        u3:FireServer("ClearDefenders")
    end
)
PSCommandsFrame_upv_1.SetAutomaticKick.MouseButton1Click:Connect(
    function()
        --[[
          line: 384
          upvalues:
            u3 (copy, index: 1)
        ]]
        u3:FireServer("SetAutoKick")
    end
)
PSCommandsFrame_upv_1.ClearAutoKicks.MouseButton1Click:Connect(
    function()
        --[[
          line: 388
          upvalues:
            u3 (copy, index: 1)
        ]]
        u3:FireServer("ClearAutoKick")
    end
)
PSCommandsFrame_upv_1.BringBallButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 392
          upvalues:
            u3 (copy, index: 1)
        ]]
        u3:FireServer("BringBall")
    end
)
PSCommandsFrame_upv_1.FreeKick.MouseButton1Click:Connect(
    function()
        --[[
          line: 396
          upvalues:
            u3 (copy, index: 1)
        ]]
        u3:FireServer("FreeKick")
    end
)
PSCommandsFrame_upv_1.KickPlayer.FocusLost:Connect(
    function()
        --[[
          line: 400
          upvalues:
            u3 (copy, index: 1)
            PSCommandsFrame_upv_1 (copy, index: 2)
        ]]
        u3:FireServer("Kick", {User = PSCommandsFrame_upv_1.KickPlayer.Text})
    end
)
PSCommandsFrame_upv_1.BanPlayer.FocusLost:Connect(
    function()
        --[[
          line: 406
          upvalues:
            u3 (copy, index: 1)
            PSCommandsFrame_upv_1 (copy, index: 2)
        ]]
        u3:FireServer("Ban", {User = PSCommandsFrame_upv_1.BanPlayer.Text})
    end
)
PSCommandsFrame_upv_1.SetHalfLength.FocusLost:Connect(
    function()
        --[[
          line: 412
          upvalues:
            u3 (copy, index: 1)
            PSCommandsFrame_upv_1 (copy, index: 2)
        ]]
        u3:FireServer("SetHalfLength", {t = PSCommandsFrame_upv_1.SetHalfLength.Text})
    end
)
PSCommandsFrame_upv_1.HomeTeamShirt.FocusLost:Connect(
    function()
        --[[
          line: 418
          upvalues:
            u3 (copy, index: 1)
            PSCommandsFrame_upv_1 (copy, index: 2)
        ]]
        u3:FireServer("SetHomeShirt", {id = PSCommandsFrame_upv_1.HomeTeamShirt.Text})
    end
)
PSCommandsFrame_upv_1.AwayTeamShirt.FocusLost:Connect(
    function()
        --[[
          line: 424
          upvalues:
            u3 (copy, index: 1)
            PSCommandsFrame_upv_1 (copy, index: 2)
        ]]
        u3:FireServer("SetAwayShirt", {id = PSCommandsFrame_upv_1.AwayTeamShirt.Text})
    end
)
PSCommandsFrame_upv_1.HomeTeamPants.FocusLost:Connect(
    function()
        --[[
          line: 430
          upvalues:
            u3 (copy, index: 1)
            PSCommandsFrame_upv_1 (copy, index: 2)
        ]]
        u3:FireServer("SetHomePants", {id = PSCommandsFrame_upv_1.HomeTeamPants.Text})
    end
)
PSCommandsFrame_upv_1.AwayTeamPants.FocusLost:Connect(
    function()
        --[[
          line: 436
          upvalues:
            u3 (copy, index: 1)
            PSCommandsFrame_upv_1 (copy, index: 2)
        ]]
        u3:FireServer("SetAwayPants", {id = PSCommandsFrame_upv_1.AwayTeamPants.Text})
    end
)
local u7 = "nil"
function setupteamframe()
    --[[
      name: setupteamframe
      line: 446
      upvalues:
        tbl_upv_2 (copy, index: 1)
        tbl_upv_1 (copy, index: 2)
        teamPicker_upv_1 (copy, index: 3)
        u3 (copy, index: 4)
        u7 (ref,  index: 5)
    ]]
    for key_upv_1, value_1 in pairs(tbl_upv_2) do
        local v2 = script.TeamTemplate:Clone()
        v2.Text = value_1
        v2.Icon.Image = tbl_upv_1[key_upv_1]
        v2.MouseButton1Click:Connect(
            function()
                --[[
                  line: 451
                  upvalues:
                    teamPicker_upv_1 (copy, index: 1)
                    u3 (copy, index: 2)
                    u7 (ref,  index: 3)
                    key_upv_1 (copy, index: 4)
                ]]
                teamPicker_upv_1.Visible = false
                u3:FireServer("Set" .. u7 .. "Team", {Team = key_upv_1})
            end
        )
        v2.Parent = teamPicker_upv_1
    end
end
setupteamframe()
PSCommandsFrame_upv_1.SelectHomeTeam.MouseButton1Click:Connect(
    function()
        --[[
          line: 463
          upvalues:
            u7 (ref,  index: 1)
            teamPicker_upv_1 (copy, index: 2)
        ]]
        u7 = "Home"
        teamPicker_upv_1.Visible = not teamPicker_upv_1.Visible
    end
)
PSCommandsFrame_upv_1.SelectAwayTeam.MouseButton1Click:Connect(
    function()
        --[[
          line: 468
          upvalues:
            u7 (ref,  index: 1)
            teamPicker_upv_1 (copy, index: 2)
        ]]
        u7 = "Away"
        teamPicker_upv_1.Visible = not teamPicker_upv_1.Visible
    end
)