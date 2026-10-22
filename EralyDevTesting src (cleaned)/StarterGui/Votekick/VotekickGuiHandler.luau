game.ReplicatedStorage:WaitForChild("Remotes")
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key_handler_service = knit.GetService("KeyHandlerService")
local key = key_handler_service:GetKey("StartVotekick")
local key2 = key_handler_service:GetKey("VotekickStarted")
local key3 = key_handler_service:GetKey("PlayerVoted")
local key4 = key_handler_service:GetKey("VotekickEnded")
local local_player = game.Players.LocalPlayer
local script_parent = script.Parent
local votekick_button = script.Parent.Parent.Menu.LeftFrame:WaitForChild("VotekickButton")
local select_reason = script_parent:WaitForChild("SelectReason")
local player_list_container = script_parent:WaitForChild("PlayerListContainer")
player_list_container.Visible = false
local close_button = player_list_container:WaitForChild("CloseButton")
local player_list_scroller = player_list_container:WaitForChild("PlayerListScroller")
local popup_container = script_parent:WaitForChild("PopupContainer")
local votekick_message = popup_container:WaitForChild("VotekickMessage")
local reason = popup_container:WaitForChild("Reason")
local vote_yes_button = popup_container:WaitForChild("VoteYesButton")
local vote_no_button = popup_container:WaitForChild("VoteNoButton")
local player_frame_template = script:WaitForChild("PlayerFrameTemplate")
local_player:WaitForChild("SelectedTeam")
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
    game:GetService("TweenService")
        :Create(notification_label, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0,
            TextStrokeTransparency = 0.75,
        })
        :Play()

    task.delay(1, function()
        game:GetService("TweenService")
            :Create(notification_label, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 1,
                TextStrokeTransparency = 1,
            })
            :Play()
    end)
end

function onVotekickStarted(player_2: userdata, player_3: userdata, argument: string)
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

    if enabled_2 == "CHILLY" or enabled_2 == "RYO" then
        notification("<" .. argument .. "> CANNOT BE KICKED. DO NOT DO THAT AGAIN.")

        return
    end

    if enabled_2 == true then
        notification("<" .. argument .. "> WAS KICKED DUE TO POPULAR VOTE.")

        return
    end

    if enabled_2 == false then
        notification("<" .. argument .. "> WAS NOT KICKED.")
    end
end

key2.OnClientEvent:Connect(onVotekickStarted)
key4.OnClientEvent:Connect(onVotekickEnded)

function yesClicked()
    if enabled then
        key3:FireServer(true)
        popup_container.Visible = false
    end
end

function noClicked()
    if enabled then
        key3:FireServer(false)
        popup_container.Visible = false
    end
end

vote_yes_button.MouseButton1Click:Connect(yesClicked)
vote_no_button.MouseButton1Click:Connect(noClicked)

function removePlayerFrame(argument: userdata)
    local first_child = player_list_scroller:FindFirstChild(argument.Name)

    if first_child then
        first_child:Destroy()
    end
end

function createPlayerFrame(player_2: userdata)
    local name = player_2.Name
    local user_thumbnail_async =
        game.Players:GetUserThumbnailAsync(player_2.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60)
    local clone = player_frame_template:Clone()
    clone.Name = name
    clone.PlayerName.Text = player_2.DisplayName
    clone.PlayerImage.Image = user_thumbnail_async

    clone.VotekickButton.MouseButton1Click:Connect(function()
        if player_2.SelectedTeam.Value == game.Players.LocalPlayer.SelectedTeam.Value then
            getReason(player_2)

            return
        end

        notification("CANNOT VOTE TO KICK A PLAYER WHO IS NOT ON YOUR TEAM.")
        player_list_container.Visible = false
    end)

    clone.Parent = player_list_scroller
end

function getReason(argument: userdata)
    player_list_container.Visible = false
    select_reason.Visible = true

    for _, child in pairs(select_reason:GetChildren()) do
        if child.Name ~= "CloseButton" and child:IsA("TextButton") then
            local connection = child.MouseButton1Click:Connect(function()
                if not enabled then
                    key:FireServer(argument, (tonumber(child.Name)))
                    select_reason.Visible = false
                end
            end)

            key.OnClientEvent:Once(function()
                connection:Disconnect()
            end)

            select_reason.CloseButton.MouseButton1Click:Once(function()
                connection:Disconnect()
            end)
        end
    end
end

select_reason.CloseButton.MouseButton1Click:Connect(function()
    select_reason.Visible = false
end)

function createCurrentPlayerFrames()
    for _, player_2 in pairs(game.Players:GetPlayers()) do
        if
            player_2 ~= game.Players.LocalPlayer
            and player_2.SelectedTeam.Value == game.Players.LocalPlayer.SelectedTeam.Value
        then
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

game.Players.PlayerAdded:Connect(function(player_2: userdata)
    createPlayerFrame(player_2)

    player_2:WaitForChild("SelectedTeam").Changed:Connect(function()
        doPlayerFrame()
    end)
end)

for _, player in pairs(game.Players:GetPlayers()) do
    if player:FindFirstChild("SelectedTeam") and player ~= game.Players.LocalPlayer then
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

        return
    end

    if game.Players.LocalPlayer.SelectedTeam.Value == "N/A" then
        notification("MUST BE ON A TEAM TO VOTEKICK")

        return
    end

    if game.ReplicatedStorage:FindFirstChild("VotekickCD") then
        notification("VOTEKICKING IS ON COOLDOWN.")

        return
    end

    if game.ReplicatedStorage.hasGameStarted.Value == false then
        notification("CANNOT VOTEKICK DURING INTERMISSION.")

        return
    end

    if enabled then
        notification("THERE IS A VOTEKICK IN PROGRESS.")

        return
    end

    player_list_container.Visible = not player_list_container.Visible
end

votekick_button.MouseButton1Click:Connect(togglePlayerListVisibility)

close_button.MouseButton1Click:Connect(function()
    player_list_container.Visible = false
end)
