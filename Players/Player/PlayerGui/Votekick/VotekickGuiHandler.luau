--[[
    Script Path: Game/Players/Player/PlayerGui/Votekick/VotekickGuiHandler
    Class: LocalScript
    Time: 2026-10-03 12:27:03
--]]

local _ = game.ReplicatedStorage:WaitForChild("Remotes")
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
local v1 = Knit_1.GetService("KeyHandlerService")
local u1 = v1:GetKey("StartVotekick")
local v2 = v1:GetKey("VotekickStarted")
local u2 = v1:GetKey("PlayerVoted")
local v3 = v1:GetKey("VotekickEnded")
local Parent_1 = script.Parent
local VotekickButton_1 = script.Parent.Parent.Menu.LeftFrame:WaitForChild("VotekickButton")
local SelectReason_upv_1 = Parent_1:WaitForChild("SelectReason")
local PlayerListContainer_upv_1 = Parent_1:WaitForChild("PlayerListContainer")
PlayerListContainer_upv_1.Visible = false
local CloseButton_1 = PlayerListContainer_upv_1:WaitForChild("CloseButton")
local PlayerListScroller_upv_1 = PlayerListContainer_upv_1:WaitForChild("PlayerListScroller")
local PopupContainer_upv_1 = Parent_1:WaitForChild("PopupContainer")
local VotekickMessage_upv_1 = PopupContainer_upv_1:WaitForChild("VotekickMessage")
local Reason_upv_1 = PopupContainer_upv_1:WaitForChild("Reason")
local VoteYesButton_1 = PopupContainer_upv_1:WaitForChild("VoteYesButton")
local VoteNoButton_1 = PopupContainer_upv_1:WaitForChild("VoteNoButton")
local PlayerFrameTemplate_upv_1 = script:WaitForChild("PlayerFrameTemplate")
game.Players.LocalPlayer:WaitForChild("SelectedTeam")
local u3 = false
local NotificationLabel_upv_1 = script.Parent.NotificationLabel
function notification(a1)
    --[[
      name: notification
      line: 34
      upvalues:
        NotificationLabel_upv_1 (copy, index: 1)
    ]]
    local v4 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
    v4.Parent = game.Workspace
    v4:Play()
    game.Debris:AddItem(v4, 3)
    NotificationLabel_upv_1.Text = a1
    NotificationLabel_upv_1.TextTransparency = 1
    NotificationLabel_upv_1.TextStrokeTransparency = 1
    local tbl_1 = {TextTransparency = 0, TextStrokeTransparency = 0.75}
    game:GetService("TweenService"):Create(NotificationLabel_upv_1, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_1):Play()
    task.delay(
        1,
        function()
            --[[
              line: 46
              upvalues:
                NotificationLabel_upv_1 (copy, index: 1)
            ]]
            local tbl_2 = {TextTransparency = 1, TextStrokeTransparency = 1}
            game:GetService("TweenService"):Create(NotificationLabel_upv_1, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_2):Play()
        end
    )
end
function onVotekickStarted(a1, a2, a3)
    --[[
      name: onVotekickStarted
      line: 54
      upvalues:
        u3 (ref,  index: 1)
        PlayerListContainer_upv_1 (copy, index: 2)
        VotekickMessage_upv_1 (copy, index: 3)
        Reason_upv_1 (copy, index: 4)
        PopupContainer_upv_1 (copy, index: 5)
    ]]
    local v5 = game.ReplicatedStorage.UISounds["ui-opened1"]:Clone()
    v5.Parent = game.Workspace
    v5:Play()
    game.Debris:AddItem(v5, 2)
    u3 = true
    PlayerListContainer_upv_1.Visible = false
    VotekickMessage_upv_1.Text = "<" .. a2.DisplayName .. "> HAS INITIATED A VOTEKICK ON <" .. a1.DisplayName .. ">"
    Reason_upv_1.Text = "REASON: <" .. a3 .. ">"
    PopupContainer_upv_1.Visible = true
end
function onVotekickEnded(a1, a2)
    --[[
      name: onVotekickEnded
      line: 68
      upvalues:
        u3 (ref,  index: 1)
        PopupContainer_upv_1 (copy, index: 2)
    ]]
    u3 = false
    PopupContainer_upv_1.Visible = false
    if a1 ~= "CHILLY" and a1 ~= "RYO" then
        if a1 == true then
            notification("<" .. a2 .. "> WAS KICKED DUE TO POPULAR VOTE.")
        elseif a1 == false then
            notification("<" .. a2 .. "> WAS NOT KICKED.")
        end
        return
    end
    notification("<" .. a2 .. "> CANNOT BE KICKED. DO NOT DO THAT AGAIN.")
end
v2.OnClientEvent:Connect(onVotekickStarted)
v3.OnClientEvent:Connect(onVotekickEnded)
function yesClicked()
    --[[
      name: yesClicked
      line: 87
      upvalues:
        u3 (ref,  index: 1)
        u2 (copy, index: 2)
        PopupContainer_upv_1 (copy, index: 3)
    ]]
    if not u3 then
        return
    end
    u2:FireServer(true)
    PopupContainer_upv_1.Visible = false
end
function noClicked()
    --[[
      name: noClicked
      line: 95
      upvalues:
        u3 (ref,  index: 1)
        u2 (copy, index: 2)
        PopupContainer_upv_1 (copy, index: 3)
    ]]
    if not u3 then
        return
    end
    u2:FireServer(false)
    PopupContainer_upv_1.Visible = false
end
VoteYesButton_1.MouseButton1Click:Connect(yesClicked)
VoteNoButton_1.MouseButton1Click:Connect(noClicked)
function removePlayerFrame(a1)
    --[[
      name: removePlayerFrame
      line: 108
      upvalues:
        PlayerListScroller_upv_1 (copy, index: 1)
    ]]
    local v6 = PlayerListScroller_upv_1:FindFirstChild(a1.Name)
    if not v6 then
        return
    end
    v6:Destroy()
end
function createPlayerFrame(a1)
    --[[
      name: createPlayerFrame
      line: 118
      upvalues:
        PlayerFrameTemplate_upv_1 (copy, index: 1)
        PlayerListContainer_upv_1 (copy, index: 2)
        PlayerListScroller_upv_1 (copy, index: 3)
    ]]
    local v7 = game.Players:GetUserThumbnailAsync(a1.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60)
    local v8 = PlayerFrameTemplate_upv_1:Clone()
    v8.Name = a1.Name
    v8.PlayerName.Text = a1.DisplayName
    v8.PlayerImage.Image = v7
    v8.VotekickButton.MouseButton1Click:Connect(
        function()
            --[[
              line: 128
              upvalues:
                a1 (copy, index: 1)
                PlayerListContainer_upv_1 (copy, index: 2)
            ]]
            if a1.SelectedTeam.Value ~= game.Players.LocalPlayer.SelectedTeam.Value then
                notification("CANNOT VOTE TO KICK A PLAYER WHO IS NOT ON YOUR TEAM.")
                PlayerListContainer_upv_1.Visible = false
            else
                getReason(a1)
            end
        end
    )
    v8.Parent = PlayerListScroller_upv_1
end
function getReason(a1)
    --[[
      name: getReason
      line: 141
      upvalues:
        PlayerListContainer_upv_1 (copy, index: 1)
        SelectReason_upv_1 (copy, index: 2)
        u3 (ref,  index: 3)
        u1 (copy, index: 4)
    ]]
    PlayerListContainer_upv_1.Visible = false
    SelectReason_upv_1.Visible = true
    for _, value_upv_1 in pairs(SelectReason_upv_1:GetChildren()) do
        if value_upv_1.Name == "CloseButton" then
            continue
        end
        if value_upv_1:IsA("TextButton") then
            local v9 = value_upv_1.MouseButton1Click:Connect(
                function()
                    --[[
                      line: 146
                      upvalues:
                        u3 (ref,  index: 1)
                        u1 (copy, index: 2)
                        a1 (copy, index: 3)
                        value_upv_1 (copy, index: 4)
                        SelectReason_upv_1 (copy, index: 5)
                    ]]
                    if (u3) then
                        return
                    end
                    u1:FireServer(a1, (tonumber(value_upv_1.Name)))
                    SelectReason_upv_1.Visible = false
                end
            )
            local u4 = v9
            u1.OnClientEvent:Once(
                function()
                    --[[
                      line: 152
                      upvalues:
                        u4 (ref, index: 1)
                    ]]
                    u4:Disconnect()
                end
            )
            SelectReason_upv_1.CloseButton.MouseButton1Click:Once(
                function()
                    --[[
                      line: 155
                      upvalues:
                        u4 (ref, index: 1)
                    ]]
                    u4:Disconnect()
                end
            )
        end
    end
end
SelectReason_upv_1.CloseButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 163
          upvalues:
            SelectReason_upv_1 (copy, index: 1)
        ]]
        SelectReason_upv_1.Visible = false
    end
)
function createCurrentPlayerFrames()
    --[[
      name: createCurrentPlayerFrames
      line: 167
    ]]
    for _, value_2 in pairs(game.Players:GetPlayers()) do
        if value_2 == game.Players.LocalPlayer then
            continue
        end
        if value_2.SelectedTeam.Value == game.Players.LocalPlayer.SelectedTeam.Value then
            createPlayerFrame(value_2)
        end
    end
end
function doPlayerFrame()
    --[[
      name: doPlayerFrame
      line: 176
      upvalues:
        PlayerListScroller_upv_1 (copy, index: 1)
    ]]
    for _, value_3 in pairs(PlayerListScroller_upv_1:GetChildren()) do
        if value_3:IsA("Frame") then
            value_3:Destroy()
        end
    end
    createCurrentPlayerFrames()
end
createCurrentPlayerFrames()
game.Players.PlayerAdded:Connect(
    function(a1)
        --[[
          line: 187
        ]]
        createPlayerFrame(a1)
        a1:WaitForChild("SelectedTeam").Changed:Connect(
            function()
                --[[
                  line: 190
                ]]
                doPlayerFrame()
            end
        )
    end
)
for v4, value_4 in pairs(game.Players:GetPlayers()) do
    if not (value_4:FindFirstChild("SelectedTeam")) then
        continue
    end
    if value_4 ~= game.Players.LocalPlayer then
        value_4.SelectedTeam.Changed:Connect(
            function()
                --[[
                  line: 202
                ]]
                doPlayerFrame()
            end
        )
    end
end
game.Players.LocalPlayer:WaitForChild("SelectedTeam").Changed:Connect(
    function()
        --[[
          line: 207
          upvalues:
            PlayerListContainer_upv_1 (copy, index: 1)
        ]]
        PlayerListContainer_upv_1.Visible = false
    end
)
game.Players.PlayerRemoving:Connect(removePlayerFrame)
function togglePlayerListVisibility()
    --[[
      name: togglePlayerListVisibility
      line: 213
      upvalues:
        u3 (ref,  index: 1)
        PlayerListContainer_upv_1 (copy, index: 2)
    ]]
    if game.Players.LocalPlayer.Data.Level.Value < 50 then
        notification("MUST BE LEVEL 50+ TO INITIATE A VOTEKICK")
    elseif game.Players.LocalPlayer.SelectedTeam.Value == "N/A" then
        notification("MUST BE ON A TEAM TO VOTEKICK")
    elseif game.ReplicatedStorage:FindFirstChild("VotekickCD") then
        notification("VOTEKICKING IS ON COOLDOWN.")
    elseif game.ReplicatedStorage.hasGameStarted.Value == false then
        notification("CANNOT VOTEKICK DURING INTERMISSION.")
    elseif u3 then
        notification("THERE IS A VOTEKICK IN PROGRESS.")
    else
        PlayerListContainer_upv_1.Visible = not PlayerListContainer_upv_1.Visible
    end
end
VotekickButton_1.MouseButton1Click:Connect(togglePlayerListVisibility)
CloseButton_1.MouseButton1Click:Connect(
    function()
        --[[
          line: 238
          upvalues:
            PlayerListContainer_upv_1 (copy, index: 1)
        ]]
        PlayerListContainer_upv_1.Visible = false
    end
)