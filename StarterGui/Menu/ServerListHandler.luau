--[[
    Script Path: Game/StarterGui/Menu/ServerListHandler
    Class: LocalScript
    Time: 2026-10-03 12:27:08
--]]

local ServerFrame_upv_1 = script.Parent.ServerFrame
local ServerList_upv_1 = ServerFrame_upv_1.ServerList
local searchBar_upv_1 = ServerFrame_upv_1.searchBar
local RegionSortButton_upv_1 = ServerFrame_upv_1.RegionSortButton
local RegionsSelection_upv_1 = RegionSortButton_upv_1.RegionsSelection
local u1 = ServerFrame_upv_1["4v4Button"]
local u2 = ServerFrame_upv_1["7v7Button"]
local u3 = ServerFrame_upv_1["11v11Button"]
local PrivateServerFrame_upv_1 = ServerFrame_upv_1.PrivateServerFrame
function updateServerResults(a1)
    --[[
      name: updateServerResults
      line: 23
      upvalues:
        ServerList_upv_1 (copy, index: 1)
    ]]
    for _, value_1 in pairs(ServerList_upv_1:GetChildren()) do
        if not (value_1:IsA("Frame")) then
            continue
        end
        if a1 == "" then
            value_1.Visible = true
            continue
        end
        if string.sub(string.lower(value_1.ServerName.Text), 1, #a1) ~= string.sub(a1, 1, #a1) then
            value_1.Visible = false
        else
            value_1.Visible = true
        end
    end
end
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
local v1 = Knit_1.GetService("KeyHandlerService")
local u4 = v1:GetKey("getServerList")
local u5 = v1:GetKey("JoinPS")
local u6 = v1:GetKey("MakePS")
searchBar_upv_1:GetPropertyChangedSignal("Text"):Connect(
    function()
        --[[
          line: 47
          upvalues:
            searchBar_upv_1 (copy, index: 1)
        ]]
        updateServerResults(searchBar_upv_1.Text)
    end
)
local tbl_upv_1 = {}
tbl_upv_1["7v7"] = 18972674759
tbl_upv_1["4v4"] = 18124732355
tbl_upv_1["11v11"] = 18935841239
local u7 = "11v11"
local function getFriendsInServer(a1, a2)
    --[[
      name: getFriendsInServer
      line: 60
    ]]
    local success_1, v2 = pcall(
        function()
            --[[
              line: 61
            ]]
            return game.Players.LocalPlayer:GetFriendsOnline(200)
        end
    )
    if success_1 and v2 then
        local v3 = 0
        for _, value_2 in pairs(v2) do
            if v3 > 3 then
                return
            end
            if not (value_2.IsOnline) then
                continue
            end
            if value_2.GameId == a1 then
                local v4 = Instance.new("ImageLabel")
                v4.Image = game.Players:GetUserThumbnailAsync(value_2.VisitorId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                v4.Parent = a2
                v4.BackgroundTransparency = 1
                v3 = v3 + 1
            end
        end
    else
        warn(v2)
    end
end
local function getServers()
    --[[
      name: getServers
      line: 83
      upvalues:
        u4 (copy, index: 1)
        ServerList_upv_1 (copy, index: 2)
        u7 (ref,  index: 3)
        tbl_upv_1 (copy, index: 4)
        getFriendsInServer (copy, index: 5)
    ]]
    local v5 = u4:InvokeServer()
    for _, value_3 in pairs(ServerList_upv_1:GetChildren()) do
        if value_3:IsA("Frame") then
            value_3:Destroy()
        end
    end
    local v6 = nil
    for _, value_upv_4 in pairs(v5) do
        if value_upv_4.serverType ~= u7 then
            continue
        end
        local serverName_1 = value_upv_4.serverName
        local serverId_upv_1 = value_upv_4.serverId
        local players_1 = value_upv_4.players
        local region_1 = value_upv_4.region
        local serverAge_1 = value_upv_4.serverAge
        if region_1 == "" then
            region_1 = "UNKNOWN REGION"
        end
        local v7 = script.ServerTemplate:Clone()
        v7:WaitForChild("JoinButton")
        v6 = "14"
        if u7 == "4v4" then
            v6 = "8"
            v7.ServerName.Text = serverName_1
            v7.Players.Text = players_1 .. "/" .. v6
            v7.ServerRegion.Text = region_1
            v7.serverID.Text = serverId_upv_1
            v7.serverTime.Text = serverAge_1
            v7.JoinButton.MouseButton1Click:Connect(
                function()
                    --[[
                      line: 115
                      upvalues:
                        tbl_upv_1 (copy, index: 1)
                        value_upv_4 (copy, index: 2)
                        serverId_upv_1 (copy, index: 3)
                    ]]
                    game:GetService("TeleportService"):TeleportToPlaceInstance(tbl_upv_1[value_upv_4.serverType], serverId_upv_1)
                end
            )
            getFriendsInServer(serverId_upv_1, v7.friendsInServer)
            v7.Parent = ServerList_upv_1
            continue
        end
        if u7 == "11v11" then
            v6 = "22"
        end
        v7.ServerName.Text = serverName_1
        v7.Players.Text = players_1 .. "/" .. v6
        v7.ServerRegion.Text = region_1
        v7.serverID.Text = serverId_upv_1
        v7.serverTime.Text = serverAge_1
        v7.JoinButton.MouseButton1Click:Connect(
            function()
                --[[
                  line: 115
                  upvalues:
                    tbl_upv_1 (copy, index: 1)
                    value_upv_4 (copy, index: 2)
                    serverId_upv_1 (copy, index: 3)
                ]]
                game:GetService("TeleportService"):TeleportToPlaceInstance(tbl_upv_1[value_upv_4.serverType], serverId_upv_1)
            end
        )
        getFriendsInServer(serverId_upv_1, v7.friendsInServer)
        v7.Parent = ServerList_upv_1
    end
    sortServers()
    getRegions()
end
function sortServers()
    --[[
      name: sortServers
      line: 129
      upvalues:
        ServerList_upv_1 (copy, index: 1)
    ]]
    local tbl_2 = {}
    for _, value_5 in pairs(ServerList_upv_1:GetChildren()) do
        if value_5:IsA("Frame") then
            table.insert(tbl_2, {serverObj = value_5, Players = tonumber(string.sub(value_5.Players.Text, 1, string.find(value_5.Players.Text, "/") - 1))})
        end
    end
    table.sort(
        tbl_2,
        function(a1, a2)
            --[[
              line: 136
            ]]
            return a2.Players < a1.Players
        end
    )
    for key_1, value_6 in ipairs(tbl_2) do
        print(key_1 .. " | " .. value_6.Players)
        value_6.serverObj.LayoutOrder = key_1
    end
end
function getRegions()
    --[[
      name: getRegions
      line: 145
      upvalues:
        RegionsSelection_upv_1 (copy, index: 1)
        ServerList_upv_1 (copy, index: 2)
        RegionSortButton_upv_1 (copy, index: 3)
    ]]
    for _, value_7 in pairs(RegionsSelection_upv_1:GetChildren()) do
        if value_7:IsA("TextButton") then
            value_7:Destroy()
        end
    end
    local v8 = script.Region:Clone()
    v8.Text = "Any (" .. #ServerList_upv_1:GetChildren() - 1 .. ")"
    v8.MouseButton1Click:Connect(
        function()
            --[[
              line: 154
              upvalues:
                RegionSortButton_upv_1 (copy, index: 1)
                ServerList_upv_1 (copy, index: 2)
            ]]
            RegionSortButton_upv_1.Text = "Any (" .. #ServerList_upv_1:GetChildren() - 1 .. ")"
            for _, value_8 in pairs(ServerList_upv_1:GetChildren()) do
                if value_8:IsA("Frame") then
                    value_8.Visible = true
                end
            end
        end
    )
    v8.Parent = RegionsSelection_upv_1
    local tbl_3 = {}
    local v9 = nil
    for _, value_9 in pairs(ServerList_upv_1:GetChildren()) do
        if not (value_9:IsA("Frame")) then
            continue
        end
        v9 = false
        for key_2, v12 in pairs(tbl_3) do
            if key_2 == value_9.ServerRegion.Text then
                v9 = true
            end
        end
        if v9 then
            local v10 = value_9.ServerRegion.Text
            tbl_3[v10] = tbl_3[v10] + 1
        else
            tbl_3[value_9.ServerRegion.Text] = 1
        end
    end
    for key_upv_3, value_upv_10 in pairs(tbl_3) do
        local v11 = script.Region:Clone()
        v11.Text = key_upv_3 .. " (" .. value_upv_10 .. ")"
        v11.MouseButton1Click:Connect(
            function()
                --[[
                  line: 181
                  upvalues:
                    RegionSortButton_upv_1 (copy, index: 1)
                    key_upv_3 (copy, index: 2)
                    value_upv_10 (copy, index: 3)
                    ServerList_upv_1 (copy, index: 4)
                ]]
                RegionSortButton_upv_1.Text = key_upv_3 .. " (" .. value_upv_10 .. ")"
                for _, value_11 in pairs(ServerList_upv_1:GetChildren()) do
                    if (value_11:IsA("Frame")) and value_11.ServerRegion.Text == key_upv_3 then
                        value_11.Visible = true
                    elseif value_11:IsA("Frame") then
                        value_11.Visible = false
                    end
                end
            end
        )
        v11.Parent = RegionsSelection_upv_1
    end
end
script.Parent.LeftFrame.ServerListButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 196
          upvalues:
            ServerFrame_upv_1 (copy, index: 1)
            getServers (copy, index: 2)
            RegionSortButton_upv_1 (copy, index: 3)
            RegionsSelection_upv_1 (copy, index: 4)
        ]]
        ServerFrame_upv_1.Visible = not ServerFrame_upv_1.Visible
        getServers()
        RegionSortButton_upv_1.Text = "REGION SORT"
        RegionsSelection_upv_1.Visible = false
    end
)
ServerFrame_upv_1.CloseButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 203
          upvalues:
            ServerFrame_upv_1 (copy, index: 1)
        ]]
        ServerFrame_upv_1.Visible = not ServerFrame_upv_1.Visible
    end
)
RegionSortButton_upv_1.MouseButton1Click:Connect(
    function()
        --[[
          line: 207
          upvalues:
            RegionsSelection_upv_1 (copy, index: 1)
        ]]
        RegionsSelection_upv_1.Visible = not RegionsSelection_upv_1.Visible
    end
)
u1.MouseButton1Click:Connect(
    function()
        --[[
          line: 211
          upvalues:
            u7 (ref,  index: 1)
            u1 (copy, index: 2)
            u2 (copy, index: 3)
            u3 (copy, index: 4)
            getServers (copy, index: 5)
        ]]
        u7 = "4v4"
        local tbl_4 = {Thickness = 2, Transparency = 0}
        game:GetService("TweenService"):Create(u1.UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_4):Play()
        local tbl_5 = {Thickness = 1, Transparency = 0.5}
        game:GetService("TweenService"):Create(u2.UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_5):Play()
        local tbl_6 = {Thickness = 1, Transparency = 0.5}
        game:GetService("TweenService"):Create(u3.UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_6):Play()
        getServers()
    end
)
u2.MouseButton1Click:Connect(
    function()
        --[[
          line: 228
          upvalues:
            u7 (ref,  index: 1)
            u2 (copy, index: 2)
            u1 (copy, index: 3)
            u3 (copy, index: 4)
            getServers (copy, index: 5)
        ]]
        u7 = "7v7"
        local tbl_7 = {Thickness = 2, Transparency = 0}
        game:GetService("TweenService"):Create(u2.UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_7):Play()
        local tbl_8 = {Thickness = 1, Transparency = 0.5}
        game:GetService("TweenService"):Create(u1.UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_8):Play()
        local tbl_9 = {Thickness = 1, Transparency = 0.5}
        game:GetService("TweenService"):Create(u3.UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_9):Play()
        getServers()
    end
)
u3.MouseButton1Click:Connect(
    function()
        --[[
          line: 245
          upvalues:
            u7 (ref,  index: 1)
            u3 (copy, index: 2)
            u1 (copy, index: 3)
            u2 (copy, index: 4)
            getServers (copy, index: 5)
        ]]
        u7 = "11v11"
        local tbl_10 = {Thickness = 2, Transparency = 0}
        game:GetService("TweenService"):Create(u3.UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_10):Play()
        local tbl_11 = {Thickness = 1, Transparency = 0.5}
        game:GetService("TweenService"):Create(u1.UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_11):Play()
        local tbl_12 = {Thickness = 1, Transparency = 0.5}
        game:GetService("TweenService"):Create(u2.UIStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_12):Play()
        getServers()
    end
)
ServerFrame_upv_1.JoinRandomButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 262
          upvalues:
            tbl_upv_1 (copy, index: 1)
            u7 (ref,  index: 2)
        ]]
        game:GetService("TeleportService"):Teleport(tbl_upv_1[u7], game.Players.LocalPlayer)
    end
)
getServers()
ServerFrame_upv_1.RefreshButton.MouseButton1Click:Connect(getServers)
ServerFrame_upv_1.PrivateServerButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 270
          upvalues:
            PrivateServerFrame_upv_1 (copy, index: 1)
        ]]
        PrivateServerFrame_upv_1.Visible = not PrivateServerFrame_upv_1.Visible
    end
)
PrivateServerFrame_upv_1.CodeJoinButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 274
          upvalues:
            u5 (copy, index: 1)
            PrivateServerFrame_upv_1 (copy, index: 2)
        ]]
        u5:FireServer(PrivateServerFrame_upv_1.codeEnter.Text)
        PrivateServerFrame_upv_1.codeEnter.Text = ""
    end
)
PrivateServerFrame_upv_1.GenerateServerButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 279
          upvalues:
            u6 (copy, index: 1)
            tbl_upv_1 (copy, index: 2)
            u7 (ref,  index: 3)
            PrivateServerFrame_upv_1 (copy, index: 4)
        ]]
        u6:FireServer(tbl_upv_1[u7])
        PrivateServerFrame_upv_1.codeEnter.Text = ""
    end
)
PrivateServerFrame_upv_1.CloseButton.MouseButton1Click:Connect(
    function()
        --[[
          line: 284
          upvalues:
            PrivateServerFrame_upv_1 (copy, index: 1)
        ]]
        PrivateServerFrame_upv_1.Visible = not PrivateServerFrame_upv_1.Visible
    end
)