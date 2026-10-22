local club = {}
repeat
    task.wait()
until game:IsLoaded()
local local_player = game.Players.LocalPlayer
local player_gui = local_player.PlayerGui
local character = local_player.Character or (local_player.CharacterAdded:Wait())
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key_handler_service = knit.GetService("KeyHandlerService")
local remote_function = key_handler_service:GetKey("clubCreate")
local remote_function_2 = key_handler_service:GetKey("getAttributePoints")
local _ = key_handler_service:GetKey("getPosStats")
local_player.CharacterAdded:Connect(function(character_2)
    character = character_2
end)
local value = nil
local enabled = false
local values = {}
local items = {}
local values_2 = {}

function getRank(argument)
    if argument <= 20 then
        return "E"
    end
    if argument <= 35 then
        return "D"
    end
    if argument <= 50 then
        return "C"
    end
    if argument <= 65 then
        return "B"
    end
    if argument <= 80 then
        return "A"
    elseif argument <= 95 then
        return "S"
    else
        return "SS"
    end
end

function getMedian(argument)
    local items_2 = {}
    for _, item in pairs(argument) do
        table.insert(items_2, item)
    end
    table.sort(items_2)
    if #items_2 % 2 ~= 0 then
        return items_2[math.ceil(#items_2 / 2)]
    end
    return (items_2[#items_2 / 2] + items_2[(#items_2 / 2) + 1]) / 2
end

function comma_value(argument)
    local argument_2 = argument
    local value_2
    repeat
        local replaced_text
        replaced_text, value_2 = string.gsub(argument_2, "^(-?%d+)(%d%d%d)", "%1,%2")
        argument_2 = replaced_text
    until value_2 == 0
    return argument_2
end

local function get_highest(argument)
    local number = 0
    for _, item in ipairs(argument) do
        if number < item then
            number = item
        end
    end
    return number
end

function pointsLogorithmicToRating(computed_value_offset)
    local number = 0
    number = nil
    repeat
        computed_value_offset -= number * 2.5
        number += 1
    until computed_value_offset - number < 0
    number -= 1
    number = ((number > 99) and 99) or number
    if number < 0 then
        number = 0
    end
    return number
end

local function calc_player_value(argument)
    local invoke_server_result = remote_function_2:InvokeServer("Overall")
    local items_2 = {}
    for _, computed_value_offset in pairs(invoke_server_result.STR) do
        table.insert(items_2, pointsLogorithmicToRating(computed_value_offset))
    end
    local get_median_result = getMedian(items_2)
    local items_3 = {}
    for _, computed_value_offset_2 in pairs(invoke_server_result.MID) do
        table.insert(items_3, pointsLogorithmicToRating(computed_value_offset_2))
    end
    local get_median_result_2 = getMedian(items_3)
    local items_4 = {}
    for _, computed_value_offset_3 in pairs(invoke_server_result.DEF) do
        table.insert(items_4, pointsLogorithmicToRating(computed_value_offset_3))
    end
    local get_median_result_3 = getMedian(items_4)
    local items_5 = {}
    for _, computed_value_offset_4 in pairs(invoke_server_result.KPR) do
        table.insert(items_5, pointsLogorithmicToRating(computed_value_offset_4))
    end
    local values_3 = { get_median_result, get_median_result_2, get_median_result_3, getMedian(items_5) }
    local number = 0
    for _, item in ipairs(values_3) do
        if number < item then
            number = item
        end
    end
    local get_rank_result = getRank(number)
    values_3 = 1
    if get_rank_result == "D" then
        values_3 = 4
    elseif get_rank_result == "C" then
        values_3 = 12
    elseif get_rank_result == "B" then
        values_3 = 36
    elseif get_rank_result == "A" then
        values_3 = 108
    elseif get_rank_result == "S" then
        values_3 = 216
    elseif get_rank_result == "SS" then
        values_3 = 324
    end
    return "$"
        .. comma_value(
            math.floor(
                (
                    (
                        (
                            (
                                (0 + ((argument.Data.Wins.Value * 100) * values_3))
                                + ((argument.Data.Goals.Value * 50) * values_3)
                            )
                            + ((argument.Data.Assists.Value * 40) * values_3)
                        ) + ((argument.Data.Passes.Value * 20) * values_3)
                    ) + ((argument.Data.Tackles.Value * 25) * values_3)
                ) + ((argument.Data.Saves.Value * 75) * values_3)
            )
        )
end

function displayPlayerStats(argument, text)
    if value ~= argument and value ~= nil then
        for key in values_2 do
            key:Disconnect()
        end
    end
    value = argument
    local left_frame = player_gui.Menu.ClubFrame.container.ClubRosterFrame.LeftFrame
    left_frame.plrName.Text = string.upper(argument)
    left_frame.plrIcon.Image = game.Players:GetUserThumbnailAsync(
        values[argument].UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size100x100
    )
    left_frame.Description.Text = text or ""
end

local function display_players_and_rank()
    if enabled then
        return
    end
    enabled = true
    print("Maybe?")
    local club_frame = player_gui:WaitForChild("Menu"):WaitForChild("ClubFrame")
    print("Maybe2?")
    local container = club_frame:WaitForChild("container")
    local club_roster_frame = container:WaitForChild("ClubRosterFrame")
    container.ClubCreateFrame.Visible = false
    club_frame.CreateClubButton.Visible = false
    club_frame.JoinClubButton.Visible = false
    print(values)
    for attribute_value, player in values do
        print("should do it")
        local clone = club_roster_frame.ScrollFrame.ScrollingFrame.Template:Clone()
        clone.Parent = club_roster_frame.ScrollFrame.ScrollingFrame
        clone.Visible = true
        clone.Name = attribute_value
        clone.plrName.Text = attribute_value
        clone.Rank.Text = player.Rank
        clone.plrIcon.Image = game.Players:GetUserThumbnailAsync(
            player.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size100x100
        )
        clone:SetAttribute("name", attribute_value)
        if player.Rank == "Owner" then
            clone.Name = ("1%*"):format(attribute_value)
        end
    end
    print("Maybe3?")
    for _, value_2 in club_roster_frame.ScrollFrame.ScrollingFrame:GetChildren() do
        if value_2:IsA("ImageButton") then
            table.insert(items, (value_2.MouseButton1Down:Connect(function()
                displayPlayerStats(value_2:GetAttribute("name"), values[value_2:GetAttribute("name")].Description)
            end)))
        end
    end
end

local function in_club(argument)
    local club_frame = player_gui:WaitForChild("Menu"):WaitForChild("ClubFrame")
    local container = club_frame:WaitForChild("container")
    local club_create_frame = container:WaitForChild("ClubCreateFrame")
    local _ = club_create_frame:WaitForChild("container"):WaitForChild("ClubName")
    local banner_id = club_create_frame:WaitForChild("container"):WaitForChild("BannerID")
    local logo_id = club_create_frame:WaitForChild("container"):WaitForChild("LogoID")
    local create = club_create_frame:WaitForChild("container"):WaitForChild("Create")
    local description = club_create_frame:WaitForChild("desc"):WaitForChild("description")
    if local_player:WaitForChild("Data"):WaitForChild("ClubRank").Value == "Owner" then
        club_frame.container.ClubRosterFrame.Disband.Text = "Disband"
    else
        club_frame.container.ClubRosterFrame.Disband.Text = "Leave"
    end
    container.ClubCreateFrame.Visible = false
    club_frame.CreateClubButton.Visible = false
    club_frame.JoinClubButton.Visible = false
    container.ClubStatsFrame.Visible = true
    local argument_2
    if argument ~= nil then
        argument_2 = argument
    else
        print("data is nil")
        argument_2 = remote_function:InvokeServer({ Action = "getClubData" })
        task.wait(0.25)
    end
    repeat
        task.wait()
    until argument_2
    task.wait(0.2)
    local value_2 = nil
    if argument_2.Members then
        for key, item in argument_2.Members do
            values[key] = item
        end
        print(values)
    else
        task.wait(1)
        repeat
            task.wait(1)
        until remote_function:InvokeServer({ Action = "getClubData" }).Members
        print(remote_function:InvokeServer({ Action = "getClubData" }).Members)
        value_2 = remote_function:InvokeServer({ Action = "getClubData" })
        task.wait(2)
        if value_2.Members then
            for key_2, item_2 in value_2.Members do
                values[key_2] = item_2
            end
        end
        argument_2 = value_2
    end
    print(argument_2)
    container.ClubStatsFrame.clubIcon.Image = argument_2.Logo or ""
    container.ClubStatsFrame.clubBanner.Image = argument_2.Banner or ""
    container.ClubStatsFrame.clubName.Text = local_player.Data.Club.Value
    container.ClubStatsFrame.WINS.Amount.Text = argument_2.Wins
    container.ClubStatsFrame.LOSSES.Amount.Text = argument_2.Losses
    container.ClubStatsFrame.GOALS.Amount.Text = argument_2.Goals
    container.ClubStatsFrame.ASSISTS.Amount.Text = argument_2.Assists
    local pick_category_frame = container.PickCategoryFrame
    container.ClubRosterFrame.desc.TextLabel.Text = "PASS : " .. argument_2.password
    pick_category_frame.TeamRoster.MouseButton1Down:Connect(function()
        if local_player.Data.Club.Value == "None" or local_player.Data.Club.Value == "" then
            return
        end
        container.ClubStatsFrame.Visible = false
        container.ClubRosterFrame.Visible = true
        display_players_and_rank()
    end)
    pick_category_frame.ClubStats.MouseButton1Down:Connect(function()
        if local_player.Data.Club.Value == "None" or local_player.Data.Club.Value == "" then
            return
        end
        container.ClubStatsFrame.Visible = true
        container.ClubRosterFrame.Visible = false
    end)
end

function club.init()
    local club_frame = player_gui:WaitForChild("Menu"):WaitForChild("ClubFrame")
    local container = club_frame:WaitForChild("container")
    local club_create_frame = container:WaitForChild("ClubCreateFrame")
    local club_name = club_create_frame:WaitForChild("container"):WaitForChild("ClubName")
    local banner_id = club_create_frame:WaitForChild("container"):WaitForChild("BannerID")
    local logo_id = club_create_frame:WaitForChild("container"):WaitForChild("LogoID")
    local create = club_create_frame:WaitForChild("container"):WaitForChild("Create")
    local club_join_frame = club_frame:WaitForChild("container"):WaitForChild("ClubJoinFrame")
    local join_club_button = club_frame:WaitForChild("JoinClubButton")
    local description = club_create_frame:WaitForChild("desc"):WaitForChild("description")
    local function reset_club_ui()
        enabled = false
        container.ClubRosterFrame.Visible = false
        container.ClubStatsFrame.Visible = false
        container.ClubCreateFrame.Visible = false
        container.ClubJoinFrame.Visible = false
        club_frame.JoinClubButton.Visible = true
        club_frame.CreateClubButton.Visible = true
        container.ClubStatsFrame.clubIcon.Image = ""
        container.ClubStatsFrame.clubBanner.Image = ""
        container.ClubStatsFrame.clubName.Text = ""
        container.ClubStatsFrame.WINS.Amount.Text = "0"
        container.ClubStatsFrame.LOSSES.Amount.Text = "0"
        container.ClubStatsFrame.GOALS.Amount.Text = "0"
        container.ClubStatsFrame.ASSISTS.Amount.Text = "0"
        container.ClubRosterFrame.desc.TextLabel.Text = "PASS : ----"
        table.clear(values)
    end
    local function close_team_select()
        local tween_service = game:GetService("TweenService")
        local tween_info = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local tween_properties = {}
        tween_properties.Position = UDim2.new(0.5, 0, 1, 200)
        tween_service:Create(club_frame.Parent.TeamSelectFrame, tween_info, tween_properties):Play()
        local tween_service_2 = game:GetService("TweenService")
        local tween_info_2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_2 = {}
        tween_properties_2.Position = UDim2.new(0.5, 0, 1, 750)
        tween_service_2:Create(club_frame.Parent.TeamSelectFrame.CancelButton, tween_info_2, tween_properties_2):Play()
        local tween_service_3 = game:GetService("TweenService")
        local tween_info_3 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local tween_properties_3 = {}
        tween_properties_3.Position = UDim2.new(0.5, 0, 1, 250)
        tween_service_3:Create(club_frame.Parent.PosSelectFrame, tween_info_3, tween_properties_3):Play()
        local tween_service_4 = game:GetService("TweenService")
        local tween_info_4 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_4 = {}
        tween_properties_4.Position = UDim2.new(0.5, 0, 1, 750)
        tween_service_4:Create(club_frame.Parent.PosSelectFrame.CancelButton, tween_info_4, tween_properties_4):Play()
        task.delay(0.5, function()
            club_frame.Parent.TeamSelectFrame.Visible = false
            club_frame.Parent.PosSelectFrame.Visible = false
        end)
    end
    local cancel_button = club_frame.CancelButton
    club_frame:WaitForChild("CreateClubButton").MouseButton1Down:Connect(function()
        container.ClubRosterFrame.Visible = false
        container.ClubStatsFrame.Visible = false
        container.ClubCreateFrame.Visible = true
        container.ClubJoinFrame.Visible = false
        club_frame.JoinClubButton.Visible = false
        club_frame.CreateClubButton.Visible = false
    end)
    join_club_button.MouseButton1Down:Connect(function()
        container.ClubRosterFrame.Visible = false
        container.ClubStatsFrame.Visible = false
        container.ClubCreateFrame.Visible = false
        container.ClubJoinFrame.Visible = true
        club_frame.JoinClubButton.Visible = false
        club_frame.CreateClubButton.Visible = false
    end)
    club_join_frame.container.Create.MouseButton1Click:Connect(function()
        local invoke_server_result_2 = remote_function:InvokeServer({
            Action = "Join",
            password = club_join_frame.container.Password.Text,
            clubName = club_join_frame.container.ClubName.Text,
        })
        if invoke_server_result_2.answer ~= false then
            in_club()
        else
            game.ReplicatedStorage.UISounds["ui-error4"]:Play()
            club_join_frame.container.ClubName.Text = invoke_server_result_2.say
        end
    end)
    if local_player:WaitForChild("Data"):WaitForChild("ClubRank").Value == "Owner" then
        club_frame.container.ClubRosterFrame.Disband.Text = "Disband"
    else
        club_frame.container.ClubRosterFrame.Disband.Text = "Leave"
    end
    cancel_button.MouseButton1Down:Connect(function()
        local tween_info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties = {}
        tween_properties.Position = UDim2.new(0.5, 0, 1.5, 0)
        game.TweenService:Create(club_frame, tween_info, tween_properties):Play()
    end)
    club_frame.container.ClubRosterFrame.Disband.MouseButton1Click:Connect(function()
        if not remote_function:InvokeServer({ Action = "Disband" }).answer then
            return
        end
        reset_club_ui()
    end)
    club_frame.Parent.MenuButtons.ClubsButton.MouseButton1Down:Connect(function()
        club_frame.Visible = true
        local value_3 = local_player:WaitForChild("Data"):WaitForChild("Club").Value
        if value_3 == "" or value_3 == "None" then
            container.ClubRosterFrame.Visible = false
            container.ClubStatsFrame.Visible = false
            container.ClubCreateFrame.Visible = false
            container.ClubJoinFrame.Visible = false
            club_frame.JoinClubButton.Visible = true
            club_frame.CreateClubButton.Visible = true
        else
            container.ClubRosterFrame.Visible = false
            container.ClubStatsFrame.Visible = true
            container.ClubCreateFrame.Visible = false
            container.ClubJoinFrame.Visible = false
            club_frame.JoinClubButton.Visible = false
            club_frame.CreateClubButton.Visible = false
            in_club()
        end
        local tween_info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties = {}
        tween_properties.Position = UDim2.new(0.5, 0, 0.5, 0)
        game.TweenService:Create(club_frame, tween_info, tween_properties):Play()
        local tween_service = game:GetService("TweenService")
        local tween_info_2 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_2 = {}
        tween_properties_2.Position = UDim2.new(0.5, 0, 1, 170)
        tween_service:Create(club_frame.Parent.StatsFrame, tween_info_2, tween_properties_2):Play()
        task.delay(0.35, function()
            club_frame.Parent.StatsFrame.Visible = false
        end)
        local tween_service_2 = game:GetService("TweenService")
        local tween_info_3 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_3 = {}
        tween_properties_3.Position = UDim2.new(0.5, 0, 1, 230)
        tween_service_2:Create(club_frame.Parent.SkillFrame, tween_info_3, tween_properties_3):Play()
        task.delay(0.35, function()
            club_frame.Parent.SkillFrame.Visible = false
        end)
    end)
    local value_2 = local_player:WaitForChild("Data"):WaitForChild("Club").Value
    if value_2 == "" or value_2 == "None" then
        container.ClubRosterFrame.Visible = false
        container.ClubStatsFrame.Visible = false
        container.ClubCreateFrame.Visible = false
        container.ClubJoinFrame.Visible = false
        club_frame.JoinClubButton.Visible = true
        club_frame.CreateClubButton.Visible = true
        club_name.FocusLost:Connect(function()
            print(club_name.Text)
        end)
        description.FocusLost:Connect(function()
            print(description.Text)
        end)
        logo_id.FocusLost:Connect(function()
            local icon_display = club_create_frame:WaitForChild("container"):WaitForChild("IconDisplay")
            icon_display.Image = ("rbxassetid://%*"):format(logo_id.Text)
        end)
        banner_id.FocusLost:Connect(function()
            local banner_display = club_create_frame:WaitForChild("container"):WaitForChild("BannerDisplay")
            banner_display.Image = ("rbxassetid://%*"):format(banner_id.Text)
        end)
        create.MouseButton1Down:Connect(function()
            local invoke_server_result_2 = remote_function:InvokeServer({
                Action = "Create",
                clubName = club_name.Text,
                clubLogo = club_create_frame:WaitForChild("container"):WaitForChild("IconDisplay").Image,
                clubBanner = club_create_frame:WaitForChild("container"):WaitForChild("BannerDisplay").Image,
                plrDesc = description.Text,
            })
            if invoke_server_result_2.answer ~= false then
                game.ReplicatedStorage.UISounds["ui-confirm2"]:Play()
                in_club(invoke_server_result_2.data)
            else
                game.ReplicatedStorage.UISounds["ui-error4"]:Play()
                club_name.Text = invoke_server_result_2.say
            end
        end)
        task.wait(1)
        if local_player.Data.Club.Value ~= "" and local_player.Data.Club.Value ~= "None" then
            local invoke_server_result = remote_function:InvokeServer({ Action = "getClubData" })
            if invoke_server_result then
                container.ClubStatsFrame.WINS.Amount.Text = invoke_server_result.Wins or "0"
                container.ClubStatsFrame.LOSSES.Amount.Text = invoke_server_result.Losses or "0"
                container.ClubStatsFrame.GOALS.Amount.Text = invoke_server_result.Goals or "0"
                container.ClubStatsFrame.ASSISTS.Amount.Text = invoke_server_result.Assists or "0"
                values = invoke_server_result.Members
            end
            task.wait(30)
        else
            task.wait(1)
        end
    end
    container.ClubRosterFrame.Visible = false
    container.ClubStatsFrame.Visible = true
    container.ClubCreateFrame.Visible = false
    container.ClubJoinFrame.Visible = false
    club_frame.JoinClubButton.Visible = false
    club_frame.CreateClubButton.Visible = false
    in_club()
end

club.init()

return club
