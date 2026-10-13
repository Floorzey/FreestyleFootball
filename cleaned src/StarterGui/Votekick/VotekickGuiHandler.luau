local _ = game.ReplicatedStorage:WaitForChild("Remotes")
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key_handler_service = knit.GetService("KeyHandlerService")
local remote_event = key_handler_service:GetKey("StartVotekick")
local key_2 = key_handler_service:GetKey("VotekickStarted")
local remote_event_2 = key_handler_service:GetKey("PlayerVoted")
local key_3 = key_handler_service:GetKey("VotekickEnded")
local parent = script.Parent
local votekick_button = script.Parent.Parent.Menu.LeftFrame:WaitForChild("VotekickButton")
local select_reason = parent:WaitForChild("SelectReason")
local player_list_container = parent:WaitForChild("PlayerListContainer")
player_list_container.Visible = false
local close_button = player_list_container:WaitForChild("CloseButton")
local player_list_scroller = player_list_container:WaitForChild("PlayerListScroller")
local popup_container = parent:WaitForChild("PopupContainer")
local votekick_message = popup_container:WaitForChild("VotekickMessage")
local reason = popup_container:WaitForChild("Reason")
local vote_yes_button = popup_container:WaitForChild("VoteYesButton")
local vote_no_button = popup_container:WaitForChild("VoteNoButton")
local player_frame_template = script:WaitForChild("PlayerFrameTemplate")
game.Players.LocalPlayer:WaitForChild("SelectedTeam")
local enabled = false
local notification_label = script.Parent.NotificationLabel

function notification(text)
    local clone = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
    clone.Parent = game.Workspace
    clone:Play()
    game.Debris:AddItem(clone, 3)
    notification_label.Text = text
    notification_label.TextTransparency = 1
    notification_label.TextStrokeTransparency = 1
    local tween_properties = { TextTransparency = 0, TextStrokeTransparency = 0.75 }
    game:GetService("TweenService")
        :Create(
            notification_label,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    task.delay(1, function()
        local tween_properties_2 = { TextTransparency = 1, TextStrokeTransparency = 1 }
        game:GetService("TweenService")
            :Create(
                notification_label,
                TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_2
            )
            :Play()
    end)
end

function onVotekickStarted(player_2, player_3, argument)
    local clone = game.ReplicatedStorage.UISounds["ui-opened1"]:Clone()
    clone.Parent = game.Workspace
    clone:Play()
    game.Debris:AddItem(clone, 2)
    enabled = true
    player_list_container.Visible = false
    votekick_message.Text = "<"
        .. player_3.DisplayName
        .. "> HAS INITIATED A VOTEKICK ON <"
        .. player_2.DisplayName
        .. ">"
    reason.Text = "REASON: <" .. argument .. ">"
    popup_container.Visible = true
end

function onVotekickEnded(enabled_2, argument)
    enabled = false
    popup_container.Visible = false
    if enabled_2 ~= "CHILLY" and enabled_2 ~= "RYO" then
        if enabled_2 == true then
            notification("<" .. argument .. "> WAS KICKED DUE TO POPULAR VOTE.")
        elseif enabled_2 == false then
            notification("<" .. argument .. "> WAS NOT KICKED.")
        end
        return
    end
    notification("<" .. argument .. "> CANNOT BE KICKED. DO NOT DO THAT AGAIN.")
end

key_2.OnClientEvent:Connect(onVotekickStarted)
key_3.OnClientEvent:Connect(onVotekickEnded)

function yesClicked()
    if not enabled then
        return
    end
    remote_event_2:FireServer(true)
    popup_container.Visible = false
end

function noClicked()
    if not enabled then
        return
    end
    remote_event_2:FireServer(false)
    popup_container.Visible = false
end

vote_yes_button.MouseButton1Click:Connect(yesClicked)
vote_no_button.MouseButton1Click:Connect(noClicked)

function removePlayerFrame(argument)
    local first_child = player_list_scroller:FindFirstChild(argument.Name)
    if not first_child then
        return
    end
    first_child:Destroy()
end

function createPlayerFrame(player_2)
    local image =
        game.Players:GetUserThumbnailAsync(player_2.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60)
    local clone = player_frame_template:Clone()
    clone.Name = player_2.Name
    clone.PlayerName.Text = player_2.DisplayName
    clone.PlayerImage.Image = image
    clone.VotekickButton.MouseButton1Click:Connect(function()
        if player_2.SelectedTeam.Value ~= game.Players.LocalPlayer.SelectedTeam.Value then
            notification("CANNOT VOTE TO KICK A PLAYER WHO IS NOT ON YOUR TEAM.")
            player_list_container.Visible = false
        else
            getReason(player_2)
        end
    end)
    clone.Parent = player_list_scroller
end

function getReason(argument)
    player_list_container.Visible = false
    select_reason.Visible = true
    for _, value in pairs(select_reason:GetChildren()) do
        if value.Name == "CloseButton" then
            continue
        end
        if value:IsA("TextButton") then
            local connection = value.MouseButton1Click:Connect(function()
                if enabled then
                    return
                end
                remote_event:FireServer(argument, (tonumber(value.Name)))
                select_reason.Visible = false
            end)
            local connection_2 = connection
            remote_event.OnClientEvent:Once(function()
                connection_2:Disconnect()
            end)
            select_reason.CloseButton.MouseButton1Click:Once(function()
                connection_2:Disconnect()
            end)
        end
    end
end

select_reason.CloseButton.MouseButton1Click:Connect(function()
    select_reason.Visible = false
end)

function createCurrentPlayerFrames()
    for _, player_2 in pairs(game.Players:GetPlayers()) do
        if player_2 == game.Players.LocalPlayer then
            continue
        end
        if player_2.SelectedTeam.Value == game.Players.LocalPlayer.SelectedTeam.Value then
            createPlayerFrame(player_2)
        end
    end
end

function doPlayerFrame()
    for _, child in pairs(player_list_scroller:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    createCurrentPlayerFrames()
end

createCurrentPlayerFrames()
game.Players.PlayerAdded:Connect(function(player_2)
    createPlayerFrame(player_2)
    player_2:WaitForChild("SelectedTeam").Changed:Connect(function()
        doPlayerFrame()
    end)
end)
for key, player in pairs(game.Players:GetPlayers()) do
    if not (player:FindFirstChild("SelectedTeam")) then
        continue
    end
    if player ~= game.Players.LocalPlayer then
        player.SelectedTeam.Changed:Connect(function()
            doPlayerFrame()
        end)
    end
end
game.Players.LocalPlayer:WaitForChild("SelectedTeam").Changed:Connect(function()
    player_list_container.Visible = false
end)
game.Players.PlayerRemoving:Connect(removePlayerFrame)

function togglePlayerListVisibility()
    if game.Players.LocalPlayer.Data.Level.Value < 50 then
        notification("MUST BE LEVEL 50+ TO INITIATE A VOTEKICK")
    elseif game.Players.LocalPlayer.SelectedTeam.Value == "N/A" then
        notification("MUST BE ON A TEAM TO VOTEKICK")
    elseif game.ReplicatedStorage:FindFirstChild("VotekickCD") then
        notification("VOTEKICKING IS ON COOLDOWN.")
    elseif game.ReplicatedStorage.hasGameStarted.Value == false then
        notification("CANNOT VOTEKICK DURING INTERMISSION.")
    elseif enabled then
        notification("THERE IS A VOTEKICK IN PROGRESS.")
    else
        player_list_container.Visible = not player_list_container.Visible
    end
end

votekick_button.MouseButton1Click:Connect(togglePlayerListVisibility)
close_button.MouseButton1Click:Connect(function()
    player_list_container.Visible = false
end)
