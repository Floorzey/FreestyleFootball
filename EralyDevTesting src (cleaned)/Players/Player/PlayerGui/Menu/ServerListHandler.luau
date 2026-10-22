local server_frame = script.Parent.ServerFrame
local server_list = server_frame.ServerList
local search_bar = server_frame.searchBar
local region_sort_button = server_frame.RegionSortButton
local regions_selection = region_sort_button.RegionsSelection
local server_frame_entry = server_frame["4v4Button"]
local server_frame_entry_2 = server_frame["7v7Button"]
local server_frame_entry_3 = server_frame["11v11Button"]
local join_random_button = server_frame.JoinRandomButton
local private_server_button = server_frame.PrivateServerButton
local private_server_frame = server_frame.PrivateServerFrame

function updateServerResults(argument: string)
    for _, child in pairs(server_list:GetChildren()) do
        if child:IsA("Frame") then
            if argument == "" then
                child.Visible = true
            else
                local lower_result = string.lower(child.ServerName.Text)

                if string.sub(lower_result, 1, #argument) == string.sub(argument, 1, #argument) then
                    child.Visible = true
                else
                    child.Visible = false
                end
            end
        end
    end
end

local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key_handler_service = knit.GetService("KeyHandlerService")
local key = key_handler_service:GetKey("getServerList")
local key2 = key_handler_service:GetKey("JoinPS")
local key3 = key_handler_service:GetKey("MakePS")

search_bar:GetPropertyChangedSignal("Text"):Connect(function()
    updateServerResults(search_bar.Text)
end)

local values = {
    ["7v7"] = 18972674759,
    ["4v4"] = 18124732355,
    ["11v11"] = 18935841239,
}
local text = "11v11"

local function get_friends_in_server(argument: string, parent: userdata)
    local success, result = pcall(function()
        return game.Players.LocalPlayer:GetFriendsOnline(200)
    end)

    if success and result then
        local number = 0

        for _, item in pairs(result) do
            if number > 3 then
                return
            end

            if item.IsOnline and item.GameId == argument then
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

        return
    end

    warn(result)
end

local function get_servers()
    local invoke_server_result = key:InvokeServer()

    for _, child in pairs(server_list:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    for _, item in pairs(invoke_server_result) do
        if item.serverType == text then
            local server_name = item.serverName
            local server_id = item.serverId
            local players = item.players
            local region = item.region
            local server_age = item.serverAge
            local clone = script.ServerTemplate:Clone()
            clone:WaitForChild("JoinButton")
            clone.ServerName.Text = server_name
            clone.Players.Text = players .. "/" .. (text == "4v4" and "8" or (text == "11v11" and "22" or "14"))
            clone.ServerRegion.Text = region == "" and "UNKNOWN REGION" or region
            clone.serverID.Text = server_id
            clone.serverTime.Text = server_age

            clone.JoinButton.MouseButton1Click:Connect(function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(values[item.serverType], server_id)
            end)

            get_friends_in_server(server_id, clone.friendsInServer)
            clone.Parent = server_list
        end
    end

    sortServers()
    getRegions()
end

function sortServers()
    local items = {}

    for _, child in pairs(server_list:GetChildren()) do
        if child:IsA("Frame") then
            local text_2 = child.Players.Text
            local difference = string.find(child.Players.Text, "/") - 1
            local substring = string.sub(text_2, 1, difference)
            local values_2 = {
                serverObj = child,
                Players = tonumber(substring),
            }
            table.insert(items, values_2)
        end
    end

    table.sort(items, function(argument, argument_2)
        return argument.Players > argument_2.Players
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

        for _, child_4 in pairs(server_list:GetChildren()) do
            if child_4:IsA("Frame") then
                child_4.Visible = true
            end
        end
    end)

    clone.Parent = regions_selection
    local values_2 = {}

    for _, child_2 in pairs(server_list:GetChildren()) do
        if child_2:IsA("Frame") then
            local child_3 = child_2
            local enabled = false

            for key_2, _ in pairs(values_2) do
                if key_2 == child_3.ServerRegion.Text then
                    enabled = true
                end
            end

            if enabled then
                local text_2 = child_3.ServerRegion.Text
                values_2[text_2] = values_2[text_2] + 1
            else
                values_2[child_3.ServerRegion.Text] = 1
            end
        end
    end

    for key_3, item in pairs(values_2) do
        local clone_2 = script.Region:Clone()
        clone_2.Text = key_3 .. " (" .. item .. ")"

        clone_2.MouseButton1Click:Connect(function()
            region_sort_button.Text = key_3 .. " (" .. item .. ")"

            for _, child_4 in pairs(server_list:GetChildren()) do
                if child_4:IsA("Frame") and child_4.ServerRegion.Text == key_3 then
                    child_4.Visible = true
                elseif child_4:IsA("Frame") then
                    child_4.Visible = false
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
    game:GetService("TweenService")
        :Create(server_frame_entry.UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Thickness = 2,
            Transparency = 0,
        })
        :Play()
    game:GetService("TweenService")
        :Create(server_frame_entry_2.UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Thickness = 1,
            Transparency = 0.5,
        })
        :Play()
    game:GetService("TweenService")
        :Create(server_frame_entry_3.UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Thickness = 1,
            Transparency = 0.5,
        })
        :Play()
    get_servers()
end)

server_frame_entry_2.MouseButton1Click:Connect(function()
    text = "7v7"
    game:GetService("TweenService")
        :Create(server_frame_entry_2.UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Thickness = 2,
            Transparency = 0,
        })
        :Play()
    game:GetService("TweenService")
        :Create(server_frame_entry.UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Thickness = 1,
            Transparency = 0.5,
        })
        :Play()
    game:GetService("TweenService")
        :Create(server_frame_entry_3.UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Thickness = 1,
            Transparency = 0.5,
        })
        :Play()
    get_servers()
end)

server_frame_entry_3.MouseButton1Click:Connect(function()
    text = "11v11"
    game:GetService("TweenService")
        :Create(server_frame_entry_3.UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Thickness = 2,
            Transparency = 0,
        })
        :Play()
    game:GetService("TweenService")
        :Create(server_frame_entry.UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Thickness = 1,
            Transparency = 0.5,
        })
        :Play()
    game:GetService("TweenService")
        :Create(server_frame_entry_2.UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Thickness = 1,
            Transparency = 0.5,
        })
        :Play()
    get_servers()
end)

join_random_button.MouseButton1Click:Connect(function()
    game:GetService("TeleportService"):Teleport(values[text], game.Players.LocalPlayer)
end)

get_servers()
server_frame.RefreshButton.MouseButton1Click:Connect(get_servers)

private_server_button.MouseButton1Click:Connect(function()
    private_server_frame.Visible = not private_server_frame.Visible
end)

private_server_frame.CodeJoinButton.MouseButton1Click:Connect(function()
    key2:FireServer(private_server_frame.codeEnter.Text)
    private_server_frame.codeEnter.Text = ""
end)

private_server_frame.GenerateServerButton.MouseButton1Click:Connect(function()
    key3:FireServer(values[text])
    private_server_frame.codeEnter.Text = ""
end)

private_server_frame.CloseButton.MouseButton1Click:Connect(function()
    private_server_frame.Visible = not private_server_frame.Visible
end)
