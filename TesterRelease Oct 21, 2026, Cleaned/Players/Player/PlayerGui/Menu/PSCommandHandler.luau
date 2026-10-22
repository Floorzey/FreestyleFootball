local ps_owner_id = game.ReplicatedStorage:FindFirstChild("PSOwnerID")
    or game.ReplicatedStorage:WaitForChild("PSOwnerID", 30)

if not ps_owner_id then
    return
end

if game.Players.LocalPlayer.UserId ~= ps_owner_id.Value then
    return
end

local values = {
    AstonVilla = "rbxassetid://81835506871297",
    Flamengo = "rbxassetid://110918350569178",
    Argentina = "rbxassetid://15068029862",
    Munich = "rbxassetid://15068635815",
    Dortmund = "rbxassetid://13460575423",
    Brazil = "rbxassetid://15068649812",
    ParisSaints = "rbxassetid://13552953245",
    ManchesterU = "rbxassetid://14540294821",
    Barcelona = "rbxassetid://316144192",
    InterMiami = "rbxassetid://15081749904",
    Japan = "rbxassetid://15098627666",
    Italy = "rbxassetid://15107657423",
    Croatia = "rbxassetid://15107652254",
    Morocco = "rbxassetid://15107668354",
    Canada = "rbxassetid://15107670722",
    Portugal = "rbxassetid://15148310170",
    Mexico = "rbxassetid://15107685948",
    Netherlands = "rbxassetid://15107690732",
    RealMadrid = "rbxassetid://15107692601",
    LiverpoolFC = "rbxassetid://5525377475",
    SeattleSoundersFC = "rbxassetid://15155280087",
    JuventusFC = "rbxassetid://15238497443",
    Newcastle = "rbxassetid://18897627545",
    ManchesterCity = "rbxassetid://14243657473",
    Germany = "rbxassetid://18640980135",
    England = "rbxassetid://18641004985",
    Arsenal = "rbxassetid://18652402819",
    InterMilan = "rbxassetid://18816070754",
    USA = "rbxassetid://18641031024",
    Chelsea = "rbxassetid://18641029244",
    Napoli = "rbxassetid://18641026783",
    France = "rbxassetid://18641023325",
    Uruguay = "rbxassetid://18641021338",
    Roma = "rbxassetid://18641019719",
    Lazio = "rbxassetid://18641016564",
    SouthKorea = "rbxassetid://18641001856",
    VascoDaGama = "rbxassetid://18640997828",
    Ajax = "rbxassetid://18640996176",
    Atletico = "rbxassetid://18640993960",
    Leverkusen = "rbxassetid://18640992087",
    Wales = "rbxassetid://18640989958",
    Fiorentina = "rbxassetid://18640988644",
    Spurs = "rbxassetid://18640987300",
    ACMilan = "rbxassetid://18640984312",
    Belgium = "rbxassetid://18641190960",
    Spain = "rbxassetid://18672737980",
    Scotland = "rbxassetid://18672741584",
    Poland = "rbxassetid://18816097298",
    Sweden = "rbxassetid://18897774513",
    Bosnia = "rbxassetid://18897785797",
    Denmark = "rbxassetid://18897980982",
    Romania = "rbxassetid://18897982581",
    Switzerland = "rbxassetid://18897984306",
}
local values_2 = {
    Argentina = "ARG",
    AstonVilla = "ASV",
    Flamengo = "FLA",
    Munich = "BAY",
    Dortmund = "DOR",
    Brazil = "BRA",
    ParisSaints = "PSG",
    ManchesterU = "MUN",
    Barcelona = "FCB",
    InterMiami = "MIA",
    Japan = "JPN",
    Italy = "ITA",
    Croatia = "CRO",
    Morocco = "MAR",
    Canada = "CAN",
    Portugal = "POR",
    Mexico = "MEX",
    Netherlands = "NED",
    RealMadrid = "RMA",
    LiverpoolFC = "LFC",
    SeattleSoundersFC = "SEA",
    JuventusFC = "JUV",
    Newcastle = "NEW",
    ManchesterCity = "MCI",
    Germany = "GER",
    England = "ENG",
    Arsenal = "ASL",
    InterMilan = "INT",
    USA = "USA",
    Chelsea = "CHE",
    Napoli = "NAP",
    France = "FRA",
    Uruguay = "URU",
    Roma = "ROM",
    Lazio = "LAZ",
    SouthKorea = "KOR",
    VascoDaGama = "VAS",
    Ajax = "AFC",
    Atletico = "AMA",
    Leverkusen = "B04",
    Wales = "WAL",
    Fiorentina = "FIO",
    Spurs = "TOT",
    ACMilan = "MIL",
    Belgium = "BEL",
    Spain = "ESP",
    Scotland = "SCO",
    Poland = "POL",
    Sweden = "SWE",
    Bosnia = "BIH",
    Denmark = "DEN",
    Romania = "ROU",
    Switzerland = "SUI",
}
local team_picker = script.Parent.teamPicker
local ps_commands_frame = script.Parent.PSCommandsFrame
script.Parent.LeftFrame.PSCommandsButton.Visible = true
local game_replicated_storage = game.ReplicatedStorage
local mouse = game.Players.LocalPlayer:GetMouse()
local slider = script:WaitForChild("Slider")
local enabled = false
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key = knit.GetService("KeyHandlerService"):GetKey("PSCommand")
local user_input_service = game:GetService("UserInputService")

user_input_service.InputChanged:Connect(function()
    if user_input_service:GetLastInputType() == Enum.UserInputType.Touch then
        ps_commands_frame.Position = UDim2.new(0.5, 0, 0.5, 0)

        return
    end

    ps_commands_frame.Position = UDim2.new(0.23, 0, 0.5, 0)
end)

local function make_slider(parent, argument)
    local clone_result = slider:clone()
    clone_result.Parent = parent
    clone_result.Position = UDim2.new(argument, 0, 0.5, 0)
    local x = parent.AbsolutePosition.X
    local x2 = parent.AbsoluteSize.X

    clone_result.MouseButton1Down:connect(function()
        if enabled then
            return
        end

        enabled = true

        repeat
            local product = Snap(math.clamp((mouse.X - x) / x2, 0, 1), 0.02) * 100
            local quotient = math.round(product) / 100
            clone_result.Position = UDim2.new(quotient, 0, 0.5, 0)
            game:GetService("RunService").RenderStepped:wait()
        until not enabled
    end)

    return clone_result
end

local result = make_slider(ps_commands_frame.ShotPower, 0)
local result_2 = make_slider(ps_commands_frame.RunSpeed, 0)

local function update()
    if game_replicated_storage:FindFirstChild("NoSkillUsage") then
        ps_commands_frame.noSkillsButton.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.noSkillsButton.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end

    if game_replicated_storage:FindFirstChild("noLevelRequirement") then
        ps_commands_frame.noSkillReqsButton.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.noSkillReqsButton.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end

    if game_replicated_storage:FindFirstChild("timerPaused") then
        ps_commands_frame.PauseTimerButton.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.PauseTimerButton.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end

    if game_replicated_storage:FindFirstChild("NoSkillCD") then
        ps_commands_frame.NoSkillCDButton.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.NoSkillCDButton.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end

    if game_replicated_storage:FindFirstChild("firstPersonLock") then
        ps_commands_frame.lockFirstPerson.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.lockFirstPerson.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end

    if game_replicated_storage:FindFirstChild("noPlayReset") then
        ps_commands_frame.noPlayResetButton.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.noPlayResetButton.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end

    if game_replicated_storage:FindFirstChild("InfiniteStamina") then
        ps_commands_frame.InfiniteStamina.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.InfiniteStamina.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end

    if game_replicated_storage:FindFirstChild("NoFullSprint") then
        ps_commands_frame.FullSprintOff.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    else
        ps_commands_frame.FullSprintOff.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    end

    if game_replicated_storage:FindFirstChild("gkReplacement") then
        ps_commands_frame.GKReplacer.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.GKReplacer.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end

    if game_replicated_storage:FindFirstChild("lockedHitbox") then
        ps_commands_frame.LockedHitbox.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)
    else
        ps_commands_frame.LockedHitbox.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
    end

    if game_replicated_storage:FindFirstChild("NoTeamLimits") then
        ps_commands_frame.DisableTeamLimits.toggle.BackgroundColor3 = Color3.new(0, 0.666667, 0)

        return
    end

    ps_commands_frame.DisableTeamLimits.toggle.BackgroundColor3 = Color3.new(0.666667, 0, 0)
end

game_replicated_storage.ChildAdded:Connect(update)
game_replicated_storage.ChildRemoved:Connect(update)

function Snap(argument, argument_2)
    return argument - argument % argument_2
end

function sliderValToMult1(argument)
    return argument < 0.1 and 1
        or (
            argument < 0.2 and 1.2
            or (
                argument < 0.3 and 1.4
                or (
                    argument < 0.4 and 1.6
                    or (
                        argument < 0.5 and 1.8
                        or (
                            argument < 0.6 and 2
                            or (argument < 0.7 and 3 or (argument < 0.8 and 4 or (argument < 0.9 and 5 or 5)))
                        )
                    )
                )
            )
        )
end

function sliderValToMult2(argument)
    return argument < 0.1 and 1
        or (
            argument < 0.2 and 1.2
            or (
                argument < 0.3 and 1.4
                or (
                    argument < 0.4 and 1.6
                    or (
                        argument < 0.5 and 1.8
                        or (
                            argument < 0.6 and 2
                            or (argument < 0.7 and 2.2 or (argument < 0.8 and 2.4 or (argument < 0.9 and 2.6 or 3)))
                        )
                    )
                )
            )
        )
end

game:GetService("UserInputService").InputEnded:connect(function(input)
    if not (input.UserInputType == Enum.UserInputType.MouseButton1 and enabled == true) then
        return
    end

    enabled = false
    key:FireServer("setShotPower", {
        val = sliderValToMult1(result.Position.X.Scale),
    })
    key:FireServer("setRunSpeed", {
        val = sliderValToMult2(result_2.Position.X.Scale),
    })
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
    key:FireServer("PauseTimer")
end)

ps_commands_frame.EndMatchButton.MouseButton1Click:Connect(function()
    key:FireServer("EndGame")
end)

ps_commands_frame.GKReplacer.MouseButton1Click:Connect(function()
    key:FireServer("ToggleGKReplacement")
end)

ps_commands_frame.lockFirstPerson.MouseButton1Click:Connect(function()
    key:FireServer("ToggleFirstPersonLock")
end)

ps_commands_frame.NoSkillCDButton.MouseButton1Click:Connect(function()
    key:FireServer("NoSkillCooldown")
end)

ps_commands_frame.noSkillsButton.MouseButton1Click:Connect(function()
    key:FireServer("NoSkillUsage")
end)

ps_commands_frame.noSkillReqsButton.MouseButton1Click:Connect(function()
    key:FireServer("NoSkillReqs")
end)

ps_commands_frame.noPlayResetButton.MouseButton1Click:Connect(function()
    key:FireServer("DisablePlayReset")
end)

ps_commands_frame.InfiniteStamina.MouseButton1Click:Connect(function()
    key:FireServer("InfiniteStamina")
end)

ps_commands_frame.FullSprintOff.MouseButton1Click:Connect(function()
    key:FireServer("FullSprintOff")
end)

ps_commands_frame.DisableTeamLimits.MouseButton1Click:Connect(function()
    key:FireServer("NoTeamLimit")
end)

ps_commands_frame.LockedHitbox.MouseButton1Click:Connect(function()
    key:FireServer("LockedHitbox")
end)

ps_commands_frame.penShootoutButton.MouseButton1Click:Connect(function()
    key:FireServer("StartShootout")
end)

ps_commands_frame.PlaceDefender.MouseButton1Click:Connect(function()
    key:FireServer("PlaceDefender")
end)

ps_commands_frame.ClearDefenders.MouseButton1Click:Connect(function()
    key:FireServer("ClearDefenders")
end)

ps_commands_frame.SetAutomaticKick.MouseButton1Click:Connect(function()
    key:FireServer("SetAutoKick")
end)

ps_commands_frame.ClearAutoKicks.MouseButton1Click:Connect(function()
    key:FireServer("ClearAutoKick")
end)

ps_commands_frame.BringBallButton.MouseButton1Click:Connect(function()
    key:FireServer("BringBall")
end)

ps_commands_frame.FreeKick.MouseButton1Click:Connect(function()
    key:FireServer("FreeKick")
end)

ps_commands_frame.KickPlayer.FocusLost:Connect(function()
    key:FireServer("Kick", {
        User = ps_commands_frame.KickPlayer.Text,
    })
end)

ps_commands_frame.BanPlayer.FocusLost:Connect(function()
    key:FireServer("Ban", {
        User = ps_commands_frame.BanPlayer.Text,
    })
end)

ps_commands_frame.SetHalfLength.FocusLost:Connect(function()
    key:FireServer("SetHalfLength", {
        t = ps_commands_frame.SetHalfLength.Text,
    })
end)

ps_commands_frame.HomeTeamShirt.FocusLost:Connect(function()
    key:FireServer("SetHomeShirt", {
        id = ps_commands_frame.HomeTeamShirt.Text,
    })
end)

ps_commands_frame.AwayTeamShirt.FocusLost:Connect(function()
    key:FireServer("SetAwayShirt", {
        id = ps_commands_frame.AwayTeamShirt.Text,
    })
end)

ps_commands_frame.HomeTeamPants.FocusLost:Connect(function()
    key:FireServer("SetHomePants", {
        id = ps_commands_frame.HomeTeamPants.Text,
    })
end)

ps_commands_frame.AwayTeamPants.FocusLost:Connect(function()
    key:FireServer("SetAwayPants", {
        id = ps_commands_frame.AwayTeamPants.Text,
    })
end)

local text = "nil"

function setupteamframe()
    for team, text_2 in pairs(values_2) do
        local clone = script.TeamTemplate:Clone()
        clone.Text = text_2
        clone.Icon.Image = values[team]

        clone.MouseButton1Click:Connect(function()
            team_picker.Visible = false
            key:FireServer("Set" .. text .. "Team", {
                Team = team,
            })
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
