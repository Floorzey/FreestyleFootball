local ps_owner_id = game.ReplicatedStorage:FindFirstChild("PSOwnerID")
    or (game.ReplicatedStorage:WaitForChild("PSOwnerID", 30))
if not ps_owner_id or game.Players.LocalPlayer.UserId ~= ps_owner_id.Value then
    return
end
local values = {}
values.AstonVilla = "rbxassetid://81835506871297"
values.Flamengo = "rbxassetid://110918350569178"
values.Argentina = "rbxassetid://15068029862"
values.Munich = "rbxassetid://15068635815"
values.Dortmund = "rbxassetid://13460575423"
values.Brazil = "rbxassetid://15068649812"
values.ParisSaints = "rbxassetid://13552953245"
values.ManchesterU = "rbxassetid://14540294821"
values.Barcelona = "rbxassetid://316144192"
values.InterMiami = "rbxassetid://15081749904"
values.Japan = "rbxassetid://15098627666"
values.Italy = "rbxassetid://15107657423"
values.Croatia = "rbxassetid://15107652254"
values.Morocco = "rbxassetid://15107668354"
values.Canada = "rbxassetid://15107670722"
values.Portugal = "rbxassetid://15148310170"
values.Mexico = "rbxassetid://15107685948"
values.Netherlands = "rbxassetid://15107690732"
values.RealMadrid = "rbxassetid://15107692601"
values.LiverpoolFC = "rbxassetid://5525377475"
values.SeattleSoundersFC = "rbxassetid://15155280087"
values.JuventusFC = "rbxassetid://15238497443"
values.Newcastle = "rbxassetid://18897627545"
values.ManchesterCity = "rbxassetid://14243657473"
values.Germany = "rbxassetid://18640980135"
values.England = "rbxassetid://18641004985"
values.Arsenal = "rbxassetid://18652402819"
values.InterMilan = "rbxassetid://18816070754"
values.USA = "rbxassetid://18641031024"
values.Chelsea = "rbxassetid://18641029244"
values.Napoli = "rbxassetid://18641026783"
values.France = "rbxassetid://18641023325"
values.Uruguay = "rbxassetid://18641021338"
values.Roma = "rbxassetid://18641019719"
values.Lazio = "rbxassetid://18641016564"
values.SouthKorea = "rbxassetid://18641001856"
values.VascoDaGama = "rbxassetid://18640997828"
values.Ajax = "rbxassetid://18640996176"
values.Atletico = "rbxassetid://18640993960"
values.Leverkusen = "rbxassetid://18640992087"
values.Wales = "rbxassetid://18640989958"
values.Fiorentina = "rbxassetid://18640988644"
values.Spurs = "rbxassetid://18640987300"
values.ACMilan = "rbxassetid://18640984312"
values.Belgium = "rbxassetid://18641190960"
values.Spain = "rbxassetid://18672737980"
values.Scotland = "rbxassetid://18672741584"
values.Poland = "rbxassetid://18816097298"
values.Sweden = "rbxassetid://18897774513"
values.Bosnia = "rbxassetid://18897785797"
values.Denmark = "rbxassetid://18897980982"
values.Romania = "rbxassetid://18897982581"
values.Switzerland = "rbxassetid://18897984306"
local values_2 = {}
values_2.Argentina = "ARG"
values_2.AstonVilla = "ASV"
values_2.Flamengo = "FLA"
values_2.Munich = "BAY"
values_2.Dortmund = "DOR"
values_2.Brazil = "BRA"
values_2.ParisSaints = "PSG"
values_2.ManchesterU = "MUN"
values_2.Barcelona = "FCB"
values_2.InterMiami = "MIA"
values_2.Japan = "JPN"
values_2.Italy = "ITA"
values_2.Croatia = "CRO"
values_2.Morocco = "MAR"
values_2.Canada = "CAN"
values_2.Portugal = "POR"
values_2.Mexico = "MEX"
values_2.Netherlands = "NED"
values_2.RealMadrid = "RMA"
values_2.LiverpoolFC = "LFC"
values_2.SeattleSoundersFC = "SEA"
values_2.JuventusFC = "JUV"
values_2.Newcastle = "NEW"
values_2.ManchesterCity = "MCI"
values_2.Germany = "GER"
values_2.England = "ENG"
values_2.Arsenal = "ASL"
values_2.InterMilan = "INT"
values_2.USA = "USA"
values_2.Chelsea = "CHE"
values_2.Napoli = "NAP"
values_2.France = "FRA"
values_2.Uruguay = "URU"
values_2.Roma = "ROM"
values_2.Lazio = "LAZ"
values_2.SouthKorea = "KOR"
values_2.VascoDaGama = "VAS"
values_2.Ajax = "AFC"
values_2.Atletico = "AMA"
values_2.Leverkusen = "B04"
values_2.Wales = "WAL"
values_2.Fiorentina = "FIO"
values_2.Spurs = "TOT"
values_2.ACMilan = "MIL"
values_2.Belgium = "BEL"
values_2.Spain = "ESP"
values_2.Scotland = "SCO"
values_2.Poland = "POL"
values_2.Sweden = "SWE"
values_2.Bosnia = "BIH"
values_2.Denmark = "DEN"
values_2.Romania = "ROU"
values_2.Switzerland = "SUI"
local team_picker = script.Parent.teamPicker
local ps_commands_frame = script.Parent.PSCommandsFrame
script.Parent.LeftFrame.PSCommandsButton.Visible = true
local replicated_storage = game.ReplicatedStorage
local mouse = game.Players.LocalPlayer:GetMouse()
local slider = script:WaitForChild("Slider")
local enabled = false
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local remote_event = knit.GetService("KeyHandlerService"):GetKey("PSCommand")
local user_input_service = game:GetService("UserInputService")
user_input_service.InputChanged:Connect(function()
    if user_input_service:GetLastInputType() ~= Enum.UserInputType.Touch then
        ps_commands_frame.Position = UDim2.new(0.23, 0, 0.5, 0)
    else
        ps_commands_frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    end
end)

local function make_slider(parent, argument)
    local clone_result = slider:clone()
    clone_result.Parent = parent
    clone_result.Position = UDim2.new(argument, 0, 0.5, 0)
    local x = parent.AbsolutePosition.X
    local x_2 = parent.AbsoluteSize.X
    clone_result.MouseButton1Down:connect(function()
        if enabled then
            return
        end
        enabled = true
        repeat
            clone_result.Position =
                UDim2.new(math.round(Snap(math.clamp((mouse.X - x) / x_2, 0, 1), 0.02) * 100) / 100, 0, 0.5, 0)
            game:GetService("RunService").RenderStepped:wait()
        until not enabled
    end)
    return clone_result
end

local result = make_slider(ps_commands_frame.ShotPower, 0)
local result_2 = make_slider(ps_commands_frame.RunSpeed, 0)

local function update()
    if replicated_storage:FindFirstChild("NoSkillUsage") then
        ps_commands_frame.noSkillsButton.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.noSkillsButton.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
    if replicated_storage:FindFirstChild("noLevelRequirement") then
        ps_commands_frame.noSkillReqsButton.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.noSkillReqsButton.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
    if replicated_storage:FindFirstChild("timerPaused") then
        ps_commands_frame.PauseTimerButton.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.PauseTimerButton.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
    if replicated_storage:FindFirstChild("NoSkillCD") then
        ps_commands_frame.NoSkillCDButton.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.NoSkillCDButton.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
    if replicated_storage:FindFirstChild("firstPersonLock") then
        ps_commands_frame.lockFirstPerson.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.lockFirstPerson.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
    if replicated_storage:FindFirstChild("noPlayReset") then
        ps_commands_frame.noPlayResetButton.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.noPlayResetButton.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
    if replicated_storage:FindFirstChild("InfiniteStamina") then
        ps_commands_frame.InfiniteStamina.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.InfiniteStamina.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
    if replicated_storage:FindFirstChild("NoFullSprint") then
        ps_commands_frame.FullSprintOff.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    else
        ps_commands_frame.FullSprintOff.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    end
    if replicated_storage:FindFirstChild("gkReplacement") then
        ps_commands_frame.GKReplacer.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.GKReplacer.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
    if replicated_storage:FindFirstChild("lockedHitbox") then
        ps_commands_frame.LockedHitbox.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.LockedHitbox.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
    if replicated_storage:FindFirstChild("NoTeamLimits") then
        ps_commands_frame.DisableTeamLimits.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.DisableTeamLimits.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end
end

replicated_storage.ChildAdded:Connect(update)
replicated_storage.ChildRemoved:Connect(update)

function Snap(argument, argument_2)
    return argument - (argument % argument_2)
end

function sliderValToMult1(argument)
    if argument < 0.1 then
        return 1
    end
    if argument < 0.2 then
        return 1.2
    end
    if argument < 0.3 then
        return 1.4
    end
    if argument < 0.4 then
        return 1.6
    end
    if argument < 0.5 then
        return 1.8
    end
    if argument < 0.6 then
        return 2
    end
    if argument < 0.7 then
        return 3
    elseif argument < 0.8 then
        return 4
    else
        return 5
    end
end

function sliderValToMult2(argument)
    if argument < 0.1 then
        return 1
    end
    if argument < 0.2 then
        return 1.2
    end
    if argument < 0.3 then
        return 1.4
    end
    if argument < 0.4 then
        return 1.6
    end
    if argument < 0.5 then
        return 1.8
    end
    if argument < 0.6 then
        return 2
    end
    if argument < 0.7 then
        return 2.2
    end
    if argument < 0.8 then
        return 2.4
    elseif argument < 0.9 then
        return 2.6
    else
        return 3
    end
end

game:GetService("UserInputService").InputEnded:connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 or enabled ~= true then
        return
    end
    enabled = false
    remote_event:FireServer("setShotPower", { val = sliderValToMult1(result.Position.X.Scale) })
    remote_event:FireServer("setRunSpeed", { val = sliderValToMult2(result_2.Position.X.Scale) })
end)
result:GetPropertyChangedSignal("Position"):Connect(function()
    ps_commands_frame.ShotPower.AMOUNT.Text = "x" .. sliderValToMult1(result.Position.X.Scale)
end)
result_2:GetPropertyChangedSignal("Position"):Connect(function()
    ps_commands_frame.RunSpeed.AMOUNT.Text = "x" .. sliderValToMult2(result_2.Position.X.Scale)
end)
script.Parent.LeftFrame.PSCommandsButton.MouseButton1Click:Connect(function()
    ps_commands_frame.Visible = not ps_commands_frame.Visible
    team_picker.Visible = false
end)
ps_commands_frame.CloseButton.MouseButton1Click:Connect(function()
    ps_commands_frame.Visible = not ps_commands_frame.Visible
    team_picker.Visible = false
end)
ps_commands_frame.PauseTimerButton.MouseButton1Click:Connect(function()
    remote_event:FireServer("PauseTimer")
end)
ps_commands_frame.EndMatchButton.MouseButton1Click:Connect(function()
    remote_event:FireServer("EndGame")
end)
ps_commands_frame.GKReplacer.MouseButton1Click:Connect(function()
    remote_event:FireServer("ToggleGKReplacement")
end)
ps_commands_frame.lockFirstPerson.MouseButton1Click:Connect(function()
    remote_event:FireServer("ToggleFirstPersonLock")
end)
ps_commands_frame.NoSkillCDButton.MouseButton1Click:Connect(function()
    remote_event:FireServer("NoSkillCooldown")
end)
ps_commands_frame.noSkillsButton.MouseButton1Click:Connect(function()
    remote_event:FireServer("NoSkillUsage")
end)
ps_commands_frame.noSkillReqsButton.MouseButton1Click:Connect(function()
    remote_event:FireServer("NoSkillReqs")
end)
ps_commands_frame.noPlayResetButton.MouseButton1Click:Connect(function()
    remote_event:FireServer("DisablePlayReset")
end)
ps_commands_frame.InfiniteStamina.MouseButton1Click:Connect(function()
    remote_event:FireServer("InfiniteStamina")
end)
ps_commands_frame.FullSprintOff.MouseButton1Click:Connect(function()
    remote_event:FireServer("FullSprintOff")
end)
ps_commands_frame.DisableTeamLimits.MouseButton1Click:Connect(function()
    remote_event:FireServer("NoTeamLimit")
end)
ps_commands_frame.LockedHitbox.MouseButton1Click:Connect(function()
    remote_event:FireServer("LockedHitbox")
end)
ps_commands_frame.penShootoutButton.MouseButton1Click:Connect(function()
    remote_event:FireServer("StartShootout")
end)
ps_commands_frame.PlaceDefender.MouseButton1Click:Connect(function()
    remote_event:FireServer("PlaceDefender")
end)
ps_commands_frame.ClearDefenders.MouseButton1Click:Connect(function()
    remote_event:FireServer("ClearDefenders")
end)
ps_commands_frame.SetAutomaticKick.MouseButton1Click:Connect(function()
    remote_event:FireServer("SetAutoKick")
end)
ps_commands_frame.ClearAutoKicks.MouseButton1Click:Connect(function()
    remote_event:FireServer("ClearAutoKick")
end)
ps_commands_frame.BringBallButton.MouseButton1Click:Connect(function()
    remote_event:FireServer("BringBall")
end)
ps_commands_frame.FreeKick.MouseButton1Click:Connect(function()
    remote_event:FireServer("FreeKick")
end)
ps_commands_frame.KickPlayer.FocusLost:Connect(function()
    remote_event:FireServer("Kick", { User = ps_commands_frame.KickPlayer.Text })
end)
ps_commands_frame.BanPlayer.FocusLost:Connect(function()
    remote_event:FireServer("Ban", { User = ps_commands_frame.BanPlayer.Text })
end)
ps_commands_frame.SetHalfLength.FocusLost:Connect(function()
    remote_event:FireServer("SetHalfLength", { t = ps_commands_frame.SetHalfLength.Text })
end)
ps_commands_frame.HomeTeamShirt.FocusLost:Connect(function()
    remote_event:FireServer("SetHomeShirt", { id = ps_commands_frame.HomeTeamShirt.Text })
end)
ps_commands_frame.AwayTeamShirt.FocusLost:Connect(function()
    remote_event:FireServer("SetAwayShirt", { id = ps_commands_frame.AwayTeamShirt.Text })
end)
ps_commands_frame.HomeTeamPants.FocusLost:Connect(function()
    remote_event:FireServer("SetHomePants", { id = ps_commands_frame.HomeTeamPants.Text })
end)
ps_commands_frame.AwayTeamPants.FocusLost:Connect(function()
    remote_event:FireServer("SetAwayPants", { id = ps_commands_frame.AwayTeamPants.Text })
end)
local text = "nil"

function setupteamframe()
    for key, text_2 in pairs(values_2) do
        local clone = script.TeamTemplate:Clone()
        clone.Text = text_2
        clone.Icon.Image = values[key]
        clone.MouseButton1Click:Connect(function()
            team_picker.Visible = false
            remote_event:FireServer("Set" .. text .. "Team", { Team = key })
        end)
        clone.Parent = team_picker
    end
end

setupteamframe()
ps_commands_frame.SelectHomeTeam.MouseButton1Click:Connect(function()
    text = "Home"
    team_picker.Visible = not team_picker.Visible
end)
ps_commands_frame.SelectAwayTeam.MouseButton1Click:Connect(function()
    text = "Away"
    team_picker.Visible = not team_picker.Visible
end)
