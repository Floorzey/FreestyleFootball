local club = {}

repeat
    task.wait()
until game:IsLoaded()

local local_player = game.Players.LocalPlayer
local player_gui = local_player.PlayerGui
local character = local_player.Character or local_player.CharacterAdded:Wait()
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key_handler_service = knit.GetService("KeyHandlerService")
local key = key_handler_service:GetKey("clubCreate")
local key2 = key_handler_service:GetKey("getAttributePoints")
key_handler_service:GetKey("getPosStats")

local_player.CharacterAdded:Connect(function(character_2)
    character = character_2
end)

local value = nil
local enabled = false
local values = {}
local items = {}
local values_2 = {}

function getRank(argument)
    return argument <= 20 and "E"
        or (
            argument <= 35 and "D"
            or (
                argument <= 50 and "C"
                or (argument <= 65 and "B" or (argument <= 80 and "A" or (argument <= 95 and "S" or "SS")))
            )
        )
end

function getMedian(argument)
    local items_2 = {}

    for _, item in pairs(argument) do
        table.insert(items_2, item)
    end

    table.sort(items_2)

    if #items_2 % 2 == 0 then
        return (items_2[#items_2 / 2] + items_2[#items_2 / 2 + 1]) / 2
    end

    return items_2[math.ceil(#items_2 / 2)]
end

function comma_value(replaced_text)
    local value_2

    repeat
        replaced_text, value_2 = string.gsub(replaced_text, "^(-?%d+)(%d%d%d)", "%1,%2")
    until value_2 == 0

    return replaced_text
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

function pointsLogorithmicToRating(difference)
    local number = 0

    repeat
        difference -= number * 2.5
        number += 1
    until difference - number < 0

    local difference_2 = number - 1
    local difference_3 = difference_2 > 99 and 99 or difference_2

    return difference_3 < 0 and 0 or difference_3
end

local function calc_player_value(argument)
    local invoke_server_result = key2:InvokeServer("Overall")
    local items_2 = {}

    for _, difference in pairs(invoke_server_result.STR) do
        table.insert(items_2, pointsLogorithmicToRating(difference))
    end

    local get_median_result = getMedian(items_2)
    local items_3 = {}

    for _, difference_2 in pairs(invoke_server_result.MID) do
        table.insert(items_3, pointsLogorithmicToRating(difference_2))
    end

    local get_median_result_2 = getMedian(items_3)
    local items_4 = {}

    for _, difference_3 in pairs(invoke_server_result.DEF) do
        table.insert(items_4, pointsLogorithmicToRating(difference_3))
    end

    local get_median_result_3 = getMedian(items_4)
    local items_5 = {}

    for _, difference_4 in pairs(invoke_server_result.KPR) do
        table.insert(items_5, pointsLogorithmicToRating(difference_4))
    end

    local values_3 = {
        get_median_result,
        get_median_result_2,
        get_median_result_3,
        (getMedian(items_5)),
    }
    local number = 0

    for _, item in ipairs(values_3) do
        if number < item then
            number = item
        end
    end

    local get_rank_result = getRank(number)
    local number_2 = get_rank_result == "D" and 4
        or (
            get_rank_result == "C" and 12
            or (
                get_rank_result == "B" and 36
                or (
                    get_rank_result == "A" and 108
                    or (get_rank_result == "S" and 216 or (get_rank_result == "SS" and 324 or 1))
                )
            )
        )

    return "$"
        .. comma_value(
            (
                math.floor(
                    0
                        + argument.Data.Wins.Value * 100 * number_2
                        + argument.Data.Goals.Value * 50 * number_2
                        + argument.Data.Assists.Value * 40 * number_2
                        + argument.Data.Passes.Value * 20 * number_2
                        + argument.Data.Tackles.Value * 25 * number_2
                        + argument.Data.Saves.Value * 75 * number_2
                )
            )
        )
end

function displayPlayerStats(argument: string, text: any)
    if value ~= argument and value ~= nil then
        for key_2 in values_2 do
            key_2:Disconnect()
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
    local _ = #items == nil

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
            clone.Name = `1{attribute_value}`
        end
    end

    print("Maybe3?")

    for _, child in club_roster_frame.ScrollFrame.ScrollingFrame:GetChildren() do
        if child:IsA("ImageButton") then
            local connection = child.MouseButton1Down:Connect(function()
                displayPlayerStats(child:GetAttribute("name"), values[child:GetAttribute("name")].Description)
            end)
            table.insert(items, connection)
        end
    end
end

local function in_club(invoke_server_result)
    local club_frame = player_gui:WaitForChild("Menu"):WaitForChild("ClubFrame")
    local container = club_frame:WaitForChild("container")
    local club_create_frame = container:WaitForChild("ClubCreateFrame")
    club_create_frame:WaitForChild("container"):WaitForChild("ClubName")
    club_create_frame:WaitForChild("container"):WaitForChild("BannerID")
    club_create_frame:WaitForChild("container"):WaitForChild("LogoID")
    club_create_frame:WaitForChild("container"):WaitForChild("Create")
    club_create_frame:WaitForChild("desc"):WaitForChild("description")

    if local_player:WaitForChild("Data"):WaitForChild("ClubRank").Value == "Owner" then
        club_frame.container.ClubRosterFrame.Disband.Text = "Disband"
    else
        club_frame.container.ClubRosterFrame.Disband.Text = "Leave"
    end

    container.ClubCreateFrame.Visible = false
    club_frame.CreateClubButton.Visible = false
    club_frame.JoinClubButton.Visible = false
    container.ClubStatsFrame.Visible = true

    if invoke_server_result == nil then
        print("data is nil")
        invoke_server_result = key:InvokeServer({
            Action = "getClubData",
        })
        task.wait(0.25)
    end

    repeat
        task.wait()
    until invoke_server_result

    task.wait(0.2)

    if invoke_server_result.Members then
        for key_2, item in invoke_server_result.Members do
            values[key_2] = item
        end

        print(values)
    else
        task.wait(1)

        repeat
            task.wait(1)
        until key:InvokeServer({
            Action = "getClubData",
        }).Members

        print(key:InvokeServer({
            Action = "getClubData",
        }).Members)
        invoke_server_result = key:InvokeServer({
            Action = "getClubData",
        })
        task.wait(2)

        if invoke_server_result.Members then
            for key_3, item_2 in invoke_server_result.Members do
                values[key_3] = item_2
            end
        end
    end

    print(invoke_server_result)
    container.ClubStatsFrame.clubIcon.Image = invoke_server_result.Logo or ""
    container.ClubStatsFrame.clubBanner.Image = invoke_server_result.Banner or ""
    container.ClubStatsFrame.clubName.Text = local_player.Data.Club.Value
    container.ClubStatsFrame.WINS.Amount.Text = invoke_server_result.Wins
    container.ClubStatsFrame.LOSSES.Amount.Text = invoke_server_result.Losses
    container.ClubStatsFrame.GOALS.Amount.Text = invoke_server_result.Goals
    container.ClubStatsFrame.ASSISTS.Amount.Text = invoke_server_result.Assists
    local pick_category_frame = container.PickCategoryFrame
    local club_stats = pick_category_frame.ClubStats
    local team_roster = pick_category_frame.TeamRoster
    container.ClubRosterFrame.desc.TextLabel.Text = "PASS : " .. invoke_server_result.password

    team_roster.MouseButton1Down:Connect(function()
        if local_player.Data.Club.Value == "None" or local_player.Data.Club.Value == "" then
            return
        end

        container.ClubStatsFrame.Visible = false
        container.ClubRosterFrame.Visible = true
        display_players_and_rank()
    end)

    club_stats.MouseButton1Down:Connect(function()
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
        game:GetService("TweenService")
            :Create(
                club_frame.Parent.TeamSelectFrame,
                TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                {
                    Position = UDim2.new(0.5, 0, 1, 200),
                }
            )
            :Play()
        game:GetService("TweenService")
            :Create(
                club_frame.Parent.TeamSelectFrame.CancelButton,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    Position = UDim2.new(0.5, 0, 1, 750),
                }
            )
            :Play()
        game:GetService("TweenService")
            :Create(
                club_frame.Parent.PosSelectFrame,
                TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                {
                    Position = UDim2.new(0.5, 0, 1, 250),
                }
            )
            :Play()
        game:GetService("TweenService")
            :Create(
                club_frame.Parent.PosSelectFrame.CancelButton,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    Position = UDim2.new(0.5, 0, 1, 750),
                }
            )
            :Play()

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
        local invoke_server_result_2 = key:InvokeServer({
            Action = "Join",
            password = club_join_frame.container.Password.Text,
            clubName = club_join_frame.container.ClubName.Text,
        })

        if invoke_server_result_2.answer ~= false then
            in_club()

            return
        end

        game.ReplicatedStorage.UISounds["ui-error4"]:Play()
        club_join_frame.container.ClubName.Text = invoke_server_result_2.say
    end)

    if local_player:WaitForChild("Data"):WaitForChild("ClubRank").Value == "Owner" then
        club_frame.container.ClubRosterFrame.Disband.Text = "Disband"
    else
        club_frame.container.ClubRosterFrame.Disband.Text = "Leave"
    end

    cancel_button.MouseButton1Down:Connect(function()
        game.TweenService
            :Create(club_frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 1.5, 0),
            })
            :Play()
    end)

    club_frame.container.ClubRosterFrame.Disband.MouseButton1Click:Connect(function()
        if key:InvokeServer({
            Action = "Disband",
        }).answer then
            reset_club_ui()
        end
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

        game.TweenService
            :Create(club_frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0.5, 0),
            })
            :Play()
        game:GetService("TweenService")
            :Create(
                club_frame.Parent.StatsFrame,
                TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    Position = UDim2.new(0.5, 0, 1, 170),
                }
            )
            :Play()

        task.delay(0.35, function()
            club_frame.Parent.StatsFrame.Visible = false
        end)

        game:GetService("TweenService")
            :Create(
                club_frame.Parent.SkillFrame,
                TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    Position = UDim2.new(0.5, 0, 1, 230),
                }
            )
            :Play()

        task.delay(0.35, function()
            club_frame.Parent.SkillFrame.Visible = false
        end)
    end)

    local value_2 = local_player:WaitForChild("Data"):WaitForChild("Club").Value

    if value_2 ~= "" and value_2 ~= "None" then
        container.ClubRosterFrame.Visible = false
        container.ClubStatsFrame.Visible = true
        container.ClubCreateFrame.Visible = false
        container.ClubJoinFrame.Visible = false
        club_frame.JoinClubButton.Visible = false
        club_frame.CreateClubButton.Visible = false
        in_club()

        return
    end

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
        club_create_frame:WaitForChild("container"):WaitForChild("IconDisplay").Image = `rbxassetid://{logo_id.Text}`
    end)

    banner_id.FocusLost:Connect(function()
        club_create_frame:WaitForChild("container"):WaitForChild("BannerDisplay").Image =
            `rbxassetid://{banner_id.Text}`
    end)

    create.MouseButton1Down:Connect(function()
        local invoke_server_result_2 = key:InvokeServer({
            Action = "Create",
            clubName = club_name.Text,
            clubLogo = club_create_frame:WaitForChild("container"):WaitForChild("IconDisplay").Image,
            clubBanner = club_create_frame:WaitForChild("container"):WaitForChild("BannerDisplay").Image,
            plrDesc = description.Text,
        })

        if invoke_server_result_2.answer == false then
            game.ReplicatedStorage.UISounds["ui-error4"]:Play()
            club_name.Text = invoke_server_result_2.say

            return
        end

        game.ReplicatedStorage.UISounds["ui-confirm2"]:Play()
        in_club(invoke_server_result_2.data)
    end)

    while true do
        while true do
            task.wait(1)

            if local_player.Data.Club.Value ~= "" and local_player.Data.Club.Value ~= "None" then
                break
            end

            task.wait(1)
        end

        local invoke_server_result = key:InvokeServer({
            Action = "getClubData",
        })

        if invoke_server_result then
            container.ClubStatsFrame.WINS.Amount.Text = invoke_server_result.Wins or "0"
            container.ClubStatsFrame.LOSSES.Amount.Text = invoke_server_result.Losses or "0"
            container.ClubStatsFrame.GOALS.Amount.Text = invoke_server_result.Goals or "0"
            container.ClubStatsFrame.ASSISTS.Amount.Text = invoke_server_result.Assists or "0"
            values = invoke_server_result.Members
        end

        task.wait(30)
    end
end

club.init()

return club
