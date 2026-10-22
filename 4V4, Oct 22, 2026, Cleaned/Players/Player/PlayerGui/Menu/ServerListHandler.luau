local server_frame = script.Parent.ServerFrame
local server_list = server_frame.ServerList
local search_bar = server_frame.searchBar
local region_sort_button = server_frame.RegionSortButton
local regions_selection = region_sort_button.RegionsSelection
local server_frame_entry = server_frame["4v4Button"]
local server_frame_entry_2 = server_frame["7v7Button"]
local server_frame_entry_3 = server_frame["11v11Button"]
local private_server_frame = server_frame.PrivateServerFrame

function updateServerResults(argument)
    for _, child in pairs(server_list:GetChildren()) do
        if not (child:IsA("Frame")) then
            continue
        end

        if argument == "" then
            child.Visible = true
            continue
        end

        if string.sub(string.lower(child.ServerName.Text), 1, #argument) ~= string.sub(argument, 1, #argument) then
            child.Visible = false
        else
            child.Visible = true
        end
    end
end

search_bar:GetPropertyChangedSignal("Text"):Connect(function()
    updateServerResults(search_bar.Text)
end)

local values = {}
values["7v7"] = 18972674759
values["4v4"] = 18124732355
values["11v11"] = 18935841239
local text = "4v4"

local function get_friends_in_server(argument, parent)
    local success, value = pcall(function()
        return game.Players.LocalPlayer:GetFriendsOnline(200)
    end)

    if success and value then
        local number = 0

        for _, item in pairs(value) do
            if number > 3 then
                return
            end

            if not item.IsOnline then
                continue
            end

            if item.GameId == argument then
                local image_label = Instance.new("ImageLabel")
                image_label.Image = game.Players:GetUserThumbnailAsync(
                    item.VisitorId,
                    Enum.ThumbnailType.HeadShot,
                    Enum.ThumbnailSize.Size48x48
                )
                image_label.Parent = parent
                image_label.BackgroundTransparency = 1
                number += 1
            end
        end
    else
        warn(value)
    end
end

local function get_servers()
    local invoke_server_result = game.ReplicatedStorage.Remotes.getServerList:InvokeServer()

    for _, child in pairs(server_list:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    local value_2 = nil

    for _, value in pairs(invoke_server_result) do
        if value.serverType ~= text then
            continue
        end

        local server_name = value.serverName
        local server_id = value.serverId
        local players = value.players
        local region = value.region
        local server_age = value.serverAge

        if region == "" then
            region = "UNKNOWN REGION"
        end

        local clone = script.ServerTemplate:Clone()
        clone:WaitForChild("JoinButton")
        value_2 = "14"

        if text == "4v4" then
            value_2 = "8"
            clone.ServerName.Text = server_name
            clone.Players.Text = players .. "/" .. value_2
            clone.ServerRegion.Text = region
            clone.serverID.Text = server_id
            clone.serverTime.Text = server_age

            clone.JoinButton.MouseButton1Click:Connect(function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(values[value.serverType], server_id)
            end)

            get_friends_in_server(server_id, clone.friendsInServer)
            clone.Parent = server_list
            continue
        end

        if text == "11v11" then
            value_2 = "22"
        end

        clone.ServerName.Text = server_name
        clone.Players.Text = players .. "/" .. value_2
        clone.ServerRegion.Text = region
        clone.serverID.Text = server_id
        clone.serverTime.Text = server_age

        clone.JoinButton.MouseButton1Click:Connect(function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(values[value.serverType], server_id)
        end)

        get_friends_in_server(server_id, clone.friendsInServer)
        clone.Parent = server_list
    end

    sortServers()
    getRegions()
end

function sortServers()
    local items = {}

    for _, server_obj in pairs(server_list:GetChildren()) do
        if server_obj:IsA("Frame") then
            table.insert(items, {
                serverObj = server_obj,
                Players = tonumber(
                    string.sub(server_obj.Players.Text, 1, string.find(server_obj.Players.Text, "/") - 1)
                ),
            })
        end
    end

    table.sort(items, function(argument, argument_2)
        return argument_2.Players < argument.Players
    end)

    for layout_order, item in ipairs(items) do
        print(layout_order .. " | " .. item.Players)
        item.serverObj.LayoutOrder = layout_order
    end
end

function getRegions()
    for _, child in pairs(regions_selection:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local clone = script.Region:Clone()
    clone.Text = "Any (" .. #server_list:GetChildren() - 1 .. ")"

    clone.MouseButton1Click:Connect(function()
        region_sort_button.Text = "Any (" .. #server_list:GetChildren() - 1 .. ")"

        for _, child_3 in pairs(server_list:GetChildren()) do
            if child_3:IsA("Frame") then
                child_3.Visible = true
            end
        end
    end)

    clone.Parent = regions_selection
    clone = {}
    local value_2 = nil

    for _, child_2 in pairs(server_list:GetChildren()) do
        if not (child_2:IsA("Frame")) then
            continue
        end

        value_2 = false

        for key_2, item in pairs(clone) do
            if key_2 == child_2.ServerRegion.Text then
                value_2 = true
            end
        end

        if value_2 then
            local text_2 = child_2.ServerRegion.Text
            clone[text_2] = clone[text_2] + 1
        else
            clone[child_2.ServerRegion.Text] = 1
        end
    end

    for key, value in pairs(clone) do
        local clone_2 = script.Region:Clone()
        clone_2.Text = key .. " (" .. value .. ")"

        clone_2.MouseButton1Click:Connect(function()
            region_sort_button.Text = key .. " (" .. value .. ")"

            for _, child_3 in pairs(server_list:GetChildren()) do
                if child_3:IsA("Frame") and child_3.ServerRegion.Text == key then
                    child_3.Visible = true
                elseif child_3:IsA("Frame") then
                    child_3.Visible = false
                end
            end
        end)

        clone_2.Parent = regions_selection
    end
end

script.Parent.LeftFrame.ServerListButton.MouseButton1Click:Connect(function()
    server_frame.Visible = not server_frame.Visible
    get_servers()
    region_sort_button.Text = "REGION SORT"
    regions_selection.Visible = false
end)

server_frame.CloseButton.MouseButton1Click:Connect(function()
    server_frame.Visible = not server_frame.Visible
end)

region_sort_button.MouseButton1Click:Connect(function()
    regions_selection.Visible = not regions_selection.Visible
end)

server_frame_entry.MouseButton1Click:Connect(function()
    text = "4v4"
    local tween_properties = { Thickness = 2, Transparency = 0 }
    game:GetService("TweenService")
        :Create(
            server_frame_entry.UIStroke,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    local tween_properties_2 = { Thickness = 1, Transparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            server_frame_entry_2.UIStroke,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_2
        )
        :Play()
    local tween_properties_3 = { Thickness = 1, Transparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            server_frame_entry_3.UIStroke,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_3
        )
        :Play()
    get_servers()
end)

server_frame_entry_2.MouseButton1Click:Connect(function()
    text = "7v7"
    local tween_properties = { Thickness = 2, Transparency = 0 }
    game:GetService("TweenService")
        :Create(
            server_frame_entry_2.UIStroke,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    local tween_properties_2 = { Thickness = 1, Transparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            server_frame_entry.UIStroke,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_2
        )
        :Play()
    local tween_properties_3 = { Thickness = 1, Transparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            server_frame_entry_3.UIStroke,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_3
        )
        :Play()
    get_servers()
end)

server_frame_entry_3.MouseButton1Click:Connect(function()
    text = "11v11"
    local tween_properties = { Thickness = 2, Transparency = 0 }
    game:GetService("TweenService")
        :Create(
            server_frame_entry_3.UIStroke,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    local tween_properties_2 = { Thickness = 1, Transparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            server_frame_entry.UIStroke,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_2
        )
        :Play()
    local tween_properties_3 = { Thickness = 1, Transparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            server_frame_entry_2.UIStroke,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_3
        )
        :Play()
    get_servers()
end)

server_frame.JoinRandomButton.MouseButton1Click:Connect(function()
    game:GetService("TeleportService"):Teleport(values[text], game.Players.LocalPlayer)
end)

get_servers()
server_frame.RefreshButton.MouseButton1Click:Connect(get_servers)

server_frame.PrivateServerButton.MouseButton1Click:Connect(function()
    private_server_frame.Visible = not private_server_frame.Visible
end)

private_server_frame.CodeJoinButton.MouseButton1Click:Connect(function()
    game.ReplicatedStorage.Remotes.JoinPS:FireServer(private_server_frame.codeEnter.Text)
    private_server_frame.codeEnter.Text = ""
end)

private_server_frame.GenerateServerButton.MouseButton1Click:Connect(function()
    game.ReplicatedStorage.Remotes.MakePS:FireServer(values[text])
    private_server_frame.codeEnter.Text = ""
end)

private_server_frame.CloseButton.MouseButton1Click:Connect(function()
    private_server_frame.Visible = not private_server_frame.Visible
end)
