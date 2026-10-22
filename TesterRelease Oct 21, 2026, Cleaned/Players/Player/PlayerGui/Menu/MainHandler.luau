local menu_buttons = script.Parent.MenuButtons
local left_frame = script.Parent.LeftFrame
local play_button = script.Parent.PlayButton
local pos_select_frame = script.Parent.PosSelectFrame
local team_select_frame = script.Parent.TeamSelectFrame
local skill_frame = script.Parent.SkillFrame
local notification_label = script.Parent.NotificationLabel
local stats_frame = script.Parent.StatsFrame
local holder = script.Parent.Coins.Holder
local holder2 = script.Parent.EXP.Holder
local customization_frame = script.Parent.CustomizationFrame
local color_selector = customization_frame.ColorSelector
local replicated_storage = game:GetService("ReplicatedStorage")
local skill_info = require(replicated_storage.Modules.wiki).skill_info
local condition = game.PlaceId == 105475221999506
local local_player = game.Players.LocalPlayer

local function is_egoist()
    local character_2 = local_player.Character

    if character_2 then
        character_2 = character_2:GetAttribute("Egoist")
    end

    return character_2
end

local values = {
    Argentina = "rbxassetid://8131230537",
    Brazil = "rbxassetid://11705710978",
    Germany = "rbxassetid://8120346775",
    France = "rbxassetid://13539436075",
    England = "rbxassetid://4807448",
    Scotland = "rbxassetid://12261193582",
    Wales = "rbxassetid://4460818460",
    Spain = "rbxassetid://13397364163",
    USA = "rbxassetid://60169251",
    Japan = "rbxassetid://8131128121",
    Italy = "rbxassetid://11919934085",
    Croatia = "rbxassetid://12220234274",
    Morocco = "rbxassetid://12598544754",
    Canada = "rbxassetid://12300382903",
    Portugal = "rbxassetid://13707539058",
    Mexico = "rbxassetid://713432113",
    Netherlands = "rbxassetid://198692974",
    [""] = "rbxassetid://10201001615",
}

repeat
    task.wait()
until local_player:FindFirstChild("dataLoaded")

repeat
    task.wait()
until game.ReplicatedStorage.TeamInfo.CurrentAwayTeam.Value ~= ""
    and game.ReplicatedStorage.TeamInfo.CurrentHomeTeam.Value ~= ""

local accomplishments = stats_frame.PickCategoryFrame.Accomplishments
local personal_stats = stats_frame.PickCategoryFrame.PersonalStats
local personal_stats_frame = stats_frame.PersonalStatsFrame
require(game.ReplicatedStorage.Modules.client)

accomplishments.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(accomplishments, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextStrokeTransparency = 0.5,
        })
        :Play()
    game:GetService("TweenService")
        :Create(personal_stats, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextStrokeTransparency = 1,
        })
        :Play()
    stats_frame.LeftFrame.Visible = true
    stats_frame.SelectionFrame.Visible = true
    personal_stats_frame.Visible = false
end)

personal_stats.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(personal_stats, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextStrokeTransparency = 0.5,
        })
        :Play()
    game:GetService("TweenService")
        :Create(accomplishments, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextStrokeTransparency = 1,
        })
        :Play()
    stats_frame.LeftFrame.Visible = false
    stats_frame.SelectionFrame.Visible = false
    personal_stats_frame.Visible = true
end)

local stat_spread = personal_stats_frame.RadarFrame.StatSpread
local vector = Vector2.new(106, 106)
local vector_2 = Vector2.new(0.5, 0.5)
local image_label = Instance.new("ImageLabel")
image_label.BackgroundTransparency = 1
image_label.AnchorPoint = vector_2
image_label.BorderSizePixel = 0

local function draw2d_triangle(argument, argument_2, argument_3, parent, argument_4, argument_5)
    local difference = argument_2 - argument
    local difference_2 = argument_3 - argument
    local difference_3 = argument_3 - argument_2
    local dot_product = difference:Dot(difference)
    local dot_product_2 = difference_2:Dot(difference_2)
    local dot_product_3 = difference_3:Dot(difference_3)

    if dot_product_2 < dot_product and dot_product_3 < dot_product then
        local argument_6 = argument_3
        argument_3 = argument
        argument = argument_2
        argument_2 = argument_6
    elseif dot_product_3 < dot_product_2 then
        if dot_product >= dot_product_2 then
            local argument_7 = argument_2
            argument_2 = argument
            argument = argument_7
        end
    else
        local argument_8 = argument_2
        argument_2 = argument
        argument = argument_8
    end

    local difference_4 = argument - argument_2
    local unit = (argument_3 - argument).unit
    local cross_product = unit:Cross(difference_4)
    local condition_3 = cross_product >= 0
    local angle = math.atan2(unit.y, unit.x)
    local rotation = math.deg(angle) + (condition_3 and 0 or 180)
    local quotient = (argument_2 + argument) / 2
    local quotient_2 = (argument_2 + argument_3) / 2
    local parent_2 = argument_4 or image_label:Clone()
    parent_2.Image = condition_3 and "rbxassetid://15444411230" or "rbxassetid://15444410184"
    parent_2.AnchorPoint = vector_2
    local u_dim2_new = UDim2.new
    local dot_product_4 = unit:Dot(difference_4)
    parent_2.Size = u_dim2_new(0, math.abs(dot_product_4), 0, cross_product)
    parent_2.Position = UDim2.new(0, quotient.x, 0, quotient.y)
    parent_2.Rotation = rotation
    parent_2.Parent = parent
    local parent_3 = argument_5 or image_label:Clone()
    parent_3.Image = condition_3 and "rbxassetid://15444410184" or "rbxassetid://15444411230"
    parent_3.AnchorPoint = vector_2
    local u_dim2_new2 = UDim2.new
    local dot_product_5 = unit:Dot(argument_3 - argument_2)
    parent_3.Size = u_dim2_new2(0, math.abs(dot_product_5), 0, cross_product)
    parent_3.Position = UDim2.new(0, quotient_2.x, 0, quotient_2.y)
    parent_3.Rotation = rotation
    parent_3.Parent = parent
    local ui_gradient = Instance.new("UIGradient")
    ui_gradient.Transparency =
        NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 1) })
    ui_gradient.Parent = condition_3 and parent_2 and parent_2 or parent_3
    local ui_gradient2 = Instance.new("UIGradient")
    ui_gradient2.Transparency =
        NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.4) })
    ui_gradient2.Parent = condition_3 and parent_3 and parent_3 or parent_2

    return parent_2, parent_3
end

local values_2 = { "DRB", "SHO", "OFF", "DEF", "SPD", "PAS" }

local function draw_line(argument, argument_2, argument_3)
    local sum = math.pow(argument.X - argument_2.X, 2) + math.pow(argument.Y - argument_2.Y, 2)
    local sqrt_result = math.sqrt(sum)
    local vector_3 = Vector2.new((argument.X + argument_2.X) / 2, (argument.Y + argument_2.Y) / 2)
    local angle = math.atan2(argument.Y - argument_2.Y, argument.X - argument_2.X)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, sqrt_result + 1, 0, argument_3)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0, vector_3.X, 0, vector_3.Y)
    frame.Rotation = math.deg(angle)
    local ui_gradient = Instance.new("UIGradient")
    ui_gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.2, 0),
        NumberSequenceKeypoint.new(0.5, 0.8),
        NumberSequenceKeypoint.new(0.8, 0),
        NumberSequenceKeypoint.new(1, 0),
    })
    ui_gradient.Parent = frame
    local ui_corner_2 = Instance.new("UICorner")
    ui_corner_2.CornerRadius = UDim.new(0.5, 0)
    ui_corner_2.Parent = frame

    return frame
end

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
    local items = {}

    for _, item_3 in pairs(argument) do
        table.insert(items, item_3)
    end

    table.sort(items)

    if #items % 2 == 0 then
        return (items[#items / 2] + items[#items / 2 + 1]) / 2
    end

    return items[math.ceil(#items / 2)]
end

local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key_handler_service = knit.GetService("KeyHandlerService")
local key = key_handler_service:GetKey("EquipCosmetic")
local key2 = key_handler_service:GetKey("UpdateSetting")
local key3 = key_handler_service:GetKey("UpdateInputSetting")
local key4 = key_handler_service:GetKey("RobuxPurchase")
local key5 = key_handler_service:GetKey("getAttributePoints")
local key6 = key_handler_service:GetKey("getPosStats")
local key7 = key_handler_service:GetKey("SelectSkill")
local key8 = key_handler_service:GetKey("BuyCheck")
local key9 = key_handler_service:GetKey("SelectPosition")
local key10 = key_handler_service:GetKey("updateJerseyNumber")
local key11 = key_handler_service:GetKey("getDailyShop")
local key12 = key_handler_service:GetKey("Purchase")
local key13 = key_handler_service:GetKey("EnterCode")

function drawStatBackground()
    for index = 1, 6 do
        local radians = math.rad(index * 360 / 6 + 30)
        local difference = radians - 1.0471975511965976
        local sum = vector + Vector2.new(math.sin(difference) * 1, math.cos(difference) * 1) * 105
        local sum_2 = vector + Vector2.new(math.sin(radians) * 1, math.cos(radians) * 1) * 105
        local background = draw_line(vector, sum, 2)
        background.BorderSizePixel = 0
        background.ZIndex = 4
        background.Parent = stat_spread
        background.BackgroundColor3 = Color3.new(0.509804, 0.509804, 0.509804)
        background.Name = "Background"
        local background_2 = draw_line(sum, sum_2, 2)
        background_2.BorderSizePixel = 0
        background_2.ZIndex = 4
        background_2.Parent = stat_spread
        background_2.BackgroundColor3 = Color3.new(0.509804, 0.509804, 0.509804)
        background_2.Name = "Background"
        local _ = index
    end
end

function comma_value(replaced_text)
    local value_3

    repeat
        replaced_text, value_3 = string.gsub(replaced_text, "^(-?%d+)(%d%d%d)", "%1,%2")
    until value_3 == 0

    return replaced_text
end

local function get_highest(argument)
    local number_4 = 0

    for _, item_3 in ipairs(argument) do
        if number_4 < item_3 then
            number_4 = item_3
        end
    end

    return number_4
end

function getPlayerValue()
    local invoke_server_result = key5:InvokeServer("Overall")
    local items = {}

    for _, difference in pairs(invoke_server_result.STR) do
        table.insert(items, pointsLogorithmicToRating(difference))
    end

    local get_median_result = getMedian(items)
    local items_2 = {}

    for _, difference_2 in pairs(invoke_server_result.MID) do
        table.insert(items_2, pointsLogorithmicToRating(difference_2))
    end

    local get_median_result_2 = getMedian(items_2)
    local items_3 = {}

    for _, difference_3 in pairs(invoke_server_result.DEF) do
        table.insert(items_3, pointsLogorithmicToRating(difference_3))
    end

    local get_median_result_3 = getMedian(items_3)
    local items_4 = {}

    for _, difference_4 in pairs(invoke_server_result.KPR) do
        table.insert(items_4, pointsLogorithmicToRating(difference_4))
    end

    local values_15 = {
        get_median_result,
        get_median_result_2,
        get_median_result_3,
        (getMedian(items_4)),
    }
    local number_4 = 0

    for _, item_3 in ipairs(values_15) do
        if number_4 < item_3 then
            number_4 = item_3
        end
    end

    local get_rank_result = getRank(number_4)
    local number_5 = get_rank_result == "D" and 4
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
                        + local_player.Data.Wins.Value * 100 * number_5
                        + local_player.Data.Goals.Value * 50 * number_5
                        + local_player.Data.Assists.Value * 40 * number_5
                        + local_player.Data.Passes.Value * 20 * number_5
                        + local_player.Data.Tackles.Value * 25 * number_5
                        + local_player.Data.Saves.Value * 75 * number_5
                )
            )
        )
end

function pointsLogorithmicToRating(difference)
    local number_4 = 0

    repeat
        difference = difference - number_4 * 2.5
        number_4 = number_4 + 1
    until difference - number_4 < 0

    local difference_2 = number_4 - 1
    local difference_3 = difference_2 > 99 and 99 or difference_2

    return difference_3 < 0 and 0 or difference_3
end

local radar_frame = personal_stats_frame.RadarFrame
local left_frame2 = personal_stats_frame.LeftFrame
left_frame2.plrName.Text = string.upper(local_player.DisplayName)
left_frame2.plrIcon.Image =
    game.Players:GetUserThumbnailAsync(local_player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
left_frame2.Origin.Image = values[local_player.Data.Origin.Value]

local_player.Data.Origin.Changed:Connect(function()
    left_frame2.Origin.Image = values[local_player.Data.Origin.Value]
end)

local selection_frame = personal_stats_frame.SelectionFrame
local text = "STR"

function updateStatSpread(argument)
    text = argument
    local invoke_server_result = key5:InvokeServer(argument)

    if text ~= argument then
        return
    end

    local values_15

    if argument == "KPR" then
        values_15 = {
            invoke_server_result.DIVPoints,
            invoke_server_result.HANPoints,
            invoke_server_result.KICPoints,
            invoke_server_result.REFPoints,
            invoke_server_result.SPDPoints,
            invoke_server_result.POSPoints,
        }
        radar_frame.DRB.Text = "DIV"
        radar_frame.SHO.Text = "HAN"
        radar_frame.OFF.Text = "KIC"
        radar_frame.DEF.Text = "REF"
        radar_frame.SPD.Text = "SPD"
        radar_frame.PAS.Text = "POS"
        left_frame2.DRB.Text = "DIV"
        left_frame2.SHO.Text = "HAN"
        left_frame2.OFF.Text = "KIC"
        left_frame2.DEF.Text = "REF"
        left_frame2.SPD.Text = "SPD"
        left_frame2.PAS.Text = "POS"
    else
        values_15 = {
            invoke_server_result.DRBPoints,
            invoke_server_result.SHOPoints,
            invoke_server_result.OFFPoints,
            invoke_server_result.DEFPoints,
            invoke_server_result.SPDPoints,
            invoke_server_result.PASPoints,
        }
        radar_frame.DRB.Text = "DRB"
        radar_frame.SHO.Text = "SHO"
        radar_frame.OFF.Text = "OFF"
        radar_frame.DEF.Text = "DEF"
        radar_frame.SPD.Text = "SPD"
        radar_frame.PAS.Text = "PAS"
        left_frame2.DRB.Text = "DRB"
        left_frame2.SHO.Text = "SHO"
        left_frame2.OFF.Text = "OFF"
        left_frame2.DEF.Text = "DEF"
        left_frame2.SPD.Text = "SPD"
        left_frame2.PAS.Text = "PAS"
    end

    left_frame2.Pos.Text = argument == "Overall" and "OVERALL"
        or (
            argument == "STR" and "FWD"
            or (argument == "MID" and "MD" or (argument == "DEF" and "DE" or (argument == "KPR" and "GK" or false)))
        )

    for _, child_5 in pairs(stat_spread:GetChildren()) do
        if child_5:IsA("ImageLabel") or child_5:IsA("Frame") and child_5.Name ~= "Background" then
            child_5:Destroy()
        end
    end

    local items = {}

    for key_3, _ in pairs(values_15) do
        local text_7 = pointsLogorithmicToRating(values_15[key_3])
        table.insert(items, text_7)
        local value_entry = values_2[key_3] or values_2[#values_2]
        local points_logorithmic_to_rating_result =
            pointsLogorithmicToRating(values_15[key_3 - 1] or values_15[#values_15])
        local radians = math.rad(key_3 * 360 / 6 + 30)
        local difference = radians - 1.0471975511965976
        local sum = vector
            + Vector2.new(math.sin(difference), (math.cos(difference)))
                * (105 * points_logorithmic_to_rating_result / 100)
        local sum_2 = vector + Vector2.new(math.sin(radians), (math.cos(radians))) * (105 * text_7 / 100)
        local result = draw_line(vector, sum, 2)
        result.BorderSizePixel = 0
        result.ZIndex = 5
        result.Parent = stat_spread
        result.BackgroundColor3 = Color3.new(0.666667, 1, 1)
        result.BackgroundTransparency = 0.5
        result.Name = "LineLength " .. 105 * text_7 / 100
        left_frame2[value_entry].Amount.Text = text_7
        personal_stats_frame.RadarFrame:FindFirstChild(value_entry .. "Rating").Text = text_7
        personal_stats_frame.RadarFrame:FindFirstChild(value_entry .. "Rank").Text = getRank(text_7)
        local result_2 = draw_line(sum, sum_2, 3)
        result_2.BorderSizePixel = 0
        result_2.ZIndex = 5
        result_2.Parent = stat_spread
        result_2.BackgroundColor3 = Color3.new(0.666667, 1, 1)
        result_2.BackgroundTransparency = 0.5
        local result_3, value_3 = draw2d_triangle(vector, sum, sum_2, stat_spread)
        result_3.ImageColor3 = Color3.new(0.666667, 1, 1)
        value_3.ImageColor3 = Color3.new(0.666667, 1, 1)
        result_3.ZIndex = 4
        value_3.ZIndex = 4
        result_3.ImageTransparency = 0.75
        value_3.ImageTransparency = 0.75
    end

    local get_median_result = getMedian(items)
    left_frame2.OverallRating.Text = math.floor(get_median_result)
    left_frame2.OverallRating.OverallRank.Text = getRank((math.floor(get_median_result)))
end

updateStatSpread("STR")
drawStatBackground()

selection_frame.STRButton.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(selection_frame.STRButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextStrokeColor3 = Color3.new(1, 1, 1),
        })
        :Play()

    for _, child_5 in pairs(selection_frame:GetChildren()) do
        if child_5:IsA("TextButton") and child_5 ~= selection_frame.STRButton then
            game:GetService("TweenService")
                :Create(child_5, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextStrokeColor3 = Color3.new(0, 0, 0),
                })
                :Play()
        end
    end

    local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    updateStatSpread("STR")
end)

selection_frame.MIDButton.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(selection_frame.MIDButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextStrokeColor3 = Color3.new(1, 1, 1),
        })
        :Play()

    for _, child_5 in pairs(selection_frame:GetChildren()) do
        if child_5:IsA("TextButton") and child_5 ~= selection_frame.MIDButton then
            game:GetService("TweenService")
                :Create(child_5, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextStrokeColor3 = Color3.new(0, 0, 0),
                })
                :Play()
        end
    end

    local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    updateStatSpread("MID")
end)

selection_frame.DEFButton.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(selection_frame.DEFButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextStrokeColor3 = Color3.new(1, 1, 1),
        })
        :Play()

    for _, child_5 in pairs(selection_frame:GetChildren()) do
        if child_5:IsA("TextButton") and child_5 ~= selection_frame.DEFButton then
            game:GetService("TweenService")
                :Create(child_5, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextStrokeColor3 = Color3.new(0, 0, 0),
                })
                :Play()
        end
    end

    local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    updateStatSpread("DEF")
end)

selection_frame.KPRButton.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(selection_frame.KPRButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextStrokeColor3 = Color3.new(1, 1, 1),
        })
        :Play()

    for _, child_5 in pairs(selection_frame:GetChildren()) do
        if child_5:IsA("TextButton") and child_5 ~= selection_frame.KPRButton then
            game:GetService("TweenService")
                :Create(child_5, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextStrokeColor3 = Color3.new(0, 0, 0),
                })
                :Play()
        end
    end

    local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    updateStatSpread("KPR")
end)

local left_frame3 = stats_frame.LeftFrame
left_frame3.plrName.Text = string.upper(local_player.DisplayName)
left_frame3.plrIcon.Image =
    game.Players:GetUserThumbnailAsync(local_player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)

function setStatsForSelection(argument)
    if argument == "Overall" then
        left_frame3.WINS.Amount.Text = local_player.Data.Wins.Value
        left_frame3.LOSSES.Amount.Text = local_player.Data.Losses.Value
        left_frame3.GOALS.Amount.Text = local_player.Data.Goals.Value
        left_frame3.ASSISTS.Amount.Text = local_player.Data.Assists.Value
        left_frame3.PASSES.Amount.Text = local_player.Data.Passes.Value
        left_frame3.TACKLES.Amount.Text = local_player.Data.Tackles.Value
        left_frame3.SAVES.Amount.Text = local_player.Data.Saves.Value
        left_frame3.OOB.Amount.Text = local_player.Data.Penalties.Value

        return
    end

    local invoke_server_result = key6:InvokeServer(argument)
    left_frame3.WINS.Amount.Text = invoke_server_result.Wins
    left_frame3.LOSSES.Amount.Text = invoke_server_result.Losses
    left_frame3.GOALS.Amount.Text = invoke_server_result.Goals
    left_frame3.ASSISTS.Amount.Text = invoke_server_result.Assists
    left_frame3.PASSES.Amount.Text = invoke_server_result.Passes
    left_frame3.TACKLES.Amount.Text = invoke_server_result.Tackles
    left_frame3.SAVES.Amount.Text = invoke_server_result.Saves
    left_frame3.OOB.Amount.Text = invoke_server_result.OOB
end

stats_frame.SelectionFrame.STRButton.MouseButton1Click:Connect(function()
    local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    left_frame3.posLabel.Text = "FORWARD"
    setStatsForSelection("STR")
end)

stats_frame.SelectionFrame.MIDButton.MouseButton1Click:Connect(function()
    local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    left_frame3.posLabel.Text = "MIDFIELDER"
    setStatsForSelection("MID")
end)

stats_frame.SelectionFrame.DEFButton.MouseButton1Click:Connect(function()
    local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    left_frame3.posLabel.Text = "DEFENDER"
    setStatsForSelection("DEF")
end)

stats_frame.SelectionFrame.KPRButton.MouseButton1Click:Connect(function()
    local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    left_frame3.posLabel.Text = "GOALKEEPER"
    setStatsForSelection("KPR")
end)

stats_frame.SelectionFrame.OVRButton.MouseButton1Click:Connect(function()
    local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    left_frame3.posLabel.Text = "OVERALL"
    setStatsForSelection("Overall")
end)

setStatsForSelection("Overall")

local_player.Data.EXP.Changed:Connect(function()
    holder2.Bar.Bar.Size = UDim2.new(local_player.Data.EXP.Value / (local_player.Data.Level.Value * 500), 0, 1, 0)
end)

local_player.Data.Level.Changed:Connect(function()
    holder2.Level.Text = local_player.Data.Level.Value
end)

holder2.Bar.Bar.Size = UDim2.new(local_player.Data.EXP.Value / (local_player.Data.Level.Value * 500), 0, 1, 0)
holder2.Level.Text = local_player.Data.Level.Value

local_player.Data.Coins.Changed:Connect(function()
    holder.Amount.Text = local_player.Data.Coins.Value
end)

local_player.Data.Candies.Changed:Connect(function()
    holder.Parent.Parent.Candies.Holder.Amount.Text = local_player.Data.Candies.Value
end)

holder.Parent.Parent.Candies.Holder.Amount.Text = local_player.Data.Candies.Value
holder.Amount.Text = local_player.Data.Coins.Value

function notification(text_7)
    local clone_3 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    notification_label.Text = text_7
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

local text_2 = "Field"

local function get_skill_display_name(display_name)
    local skill_info_entry = skill_info[display_name]

    if skill_info_entry then
        display_name = skill_info_entry.display_name or display_name
    end

    return display_name
end

function setupSkillsFrame(argument)
    text_2 = argument

    for _, child_5 in pairs(skill_frame.SkillList:GetChildren()) do
        if child_5:IsA("TextButton") then
            child_5:Destroy()
        end
    end

    local condition_3 = argument == "Goalie"
    local condition_4 = argument == "Passive"
    local items = {}

    for name_3, info_3 in pairs(skill_info) do
        if info_3.goalie == true == condition_3 and info_3.passive == true == condition_4 then
            if info_3.dev_spec then
                local character_2 = local_player.Character

                if character_2 then
                    character_2 = character_2:GetAttribute("Egoist")
                end

                if character_2 then
                    table.insert(items, {
                        name = name_3,
                        info = info_3,
                    })
                end
            else
                table.insert(items, {
                    name = name_3,
                    info = info_3,
                })
            end
        end
    end

    table.sort(items, function(argument_2, argument_3)
        if argument_2.info.level == argument_3.info.level then
            return argument_2.info.display_name < argument_3.info.display_name
        end

        return argument_2.info.level < argument_3.info.level
    end)

    for _, item_3 in ipairs(items) do
        local name_2 = item_3.name
        local info_2 = item_3.info
        local condition_5 = not (condition or info_2.dev_spec)

        if condition_5 then
            if info_2.level > local_player.Data.Level.Value then
                condition_5 = not replicated_storage:FindFirstChild("noLevelRequirement")
            else
                condition_5 = false
            end
        end

        local clone_3 = script.skillTemplate:Clone()
        clone_3.Parent = skill_frame.SkillList
        local skill_info_entry = skill_info[name_2]
        local display_name

        if skill_info_entry then
            display_name = skill_info_entry.display_name or name_2
        else
            display_name = name_2
        end

        clone_3.Text = string.upper(display_name)
        clone_3.skillIcon.Image = info_2.skill_icon
        clone_3.Type.Value = info_2.skill_type

        if name_2 == local_player.Data.SelectedSkill.Value or name_2 == local_player.Data.GoalieSkill.Value then
            clone_3.UIStroke.Color = Color3.new(1, 1, 1)
        end

        if condition_5 then
            clone_3.Locked.Visible = true
            clone_3.LockedBG.Visible = true
            clone_3.LevelReq.Visible = true
            clone_3.LevelReq.Text = "LEVEL " .. info_2.level
        end

        local connection = clone_3.MouseButton1Click:Connect(function()
            if condition_5 then
                local clone_4 = replicated_storage.UISounds["ui-error4"]:Clone()
                clone_4.Parent = workspace
                clone_4:Play()
                game.Debris:AddItem(clone_4, 3)

                task.spawn(function()
                    game:GetService("TweenService")
                        :Create(clone_3.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Rotation = 45,
                        })
                        :Play()
                    task.wait(0.1)
                    game:GetService("TweenService")
                        :Create(clone_3.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Rotation = -45,
                        })
                        :Play()
                    task.wait(0.1)
                    game:GetService("TweenService")
                        :Create(clone_3.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Rotation = 0,
                        })
                        :Play()
                end)

                return
            end

            game:GetService("TweenService")
                :Create(clone_3.UIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Color = Color3.new(1, 1, 1),
                })
                :Play()

            for _, child_6 in pairs(skill_frame.SkillList:GetChildren()) do
                if child_6:IsA("TextButton") and child_6 ~= clone_3 then
                    game:GetService("TweenService")
                        :Create(child_6.UIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Color = Color3.fromRGB(108, 115, 122),
                        })
                        :Play()
                end
            end

            local right_frame_2 = skill_frame.RightFrame
            right_frame_2.skillIcon.Image = info_2.skill_icon
            local name_4 = name_2
            local skill_info_entry_4 = skill_info[name_4]

            if skill_info_entry_4 then
                name_4 = skill_info_entry_4.display_name or name_4
            end

            right_frame_2.skillName.Text = string.upper(name_4)
            right_frame_2.skillDescription.Text = info_2.description
            right_frame_2.skillType.Text = string.upper(info_2.skill_type) .. " TYPE"

            if name_2 == local_player.Data.SelectedSkill.Value or name_2 == local_player.Data.GoalieSkill.Value then
                right_frame_2.selectButton.Text = "SELECTED"

                return
            end

            right_frame_2.selectButton.Text = "SELECT"
        end)

        clone_3.Destroying:Once(function()
            connection:Disconnect()
        end)
    end

    local selected_skill_value

    if argument == "Field" then
        selected_skill_value = local_player.Data.SelectedSkill.Value
    elseif argument == "Passive" then
        selected_skill_value = local_player.Data.PassiveSkill.Value
    else
        selected_skill_value = local_player.Data.GoalieSkill.Value
    end

    local skill_info_entry_2 = skill_info[selected_skill_value]

    if not skill_info_entry_2 then
        return
    end

    local right_frame = skill_frame.RightFrame
    right_frame.skillIcon.Image = skill_info_entry_2.skill_icon
    local skill_info_entry_3 = skill_info[selected_skill_value]

    if skill_info_entry_3 then
        selected_skill_value = skill_info_entry_3.display_name or selected_skill_value
    end

    right_frame.skillName.Text = string.upper(selected_skill_value)
    right_frame.skillDescription.Text = skill_info_entry_2.description
    right_frame.skillType.Text = string.upper(skill_info_entry_2.skill_type) .. " TYPE"
    right_frame.selectButton.Text = "SELECTED"
end

task.spawn(function()
    repeat
        task.wait()
    until local_player.Data.SelectedSkill.Value ~= ""

    setupSkillsFrame("Field")
end)

skill_frame.PickCategoryFrame.FieldSkillsButton.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(
            skill_frame.PickCategoryFrame.FieldSkillsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 0.5,
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            skill_frame.PickCategoryFrame.GoalieSkillsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 1,
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            skill_frame.PickCategoryFrame.PassiveSkillsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 1,
            }
        )
        :Play()
    setupSkillsFrame("Field")
end)

skill_frame.PickCategoryFrame.GoalieSkillsButton.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(
            skill_frame.PickCategoryFrame.GoalieSkillsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 0.5,
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            skill_frame.PickCategoryFrame.FieldSkillsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 1,
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            skill_frame.PickCategoryFrame.PassiveSkillsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 1,
            }
        )
        :Play()
    setupSkillsFrame("Goalie")
end)

skill_frame.PickCategoryFrame.PassiveSkillsButton.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(
            skill_frame.PickCategoryFrame.PassiveSkillsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 0.5,
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            skill_frame.PickCategoryFrame.PassiveSkillsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 1,
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            skill_frame.PickCategoryFrame.GoalieSkillsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 1,
            }
        )
        :Play()
    setupSkillsFrame("Passive")
end)

function updateSkillResults(argument: string)
    for _, child_5 in pairs(skill_frame.SkillList:GetChildren()) do
        if child_5:IsA("TextButton") then
            if argument == "" then
                child_5.Visible = true
            else
                local lower_result = string.lower(child_5.Text)

                if string.sub(lower_result, 1, #argument) == string.sub(argument, 1, #argument) then
                    child_5.Visible = true
                else
                    child_5.Visible = false
                end

                if child_5.Visible == false then
                    local lower_result_2 = string.lower(child_5.Type.Value)

                    if string.sub(lower_result_2, 1, #argument) == string.sub(argument, 1, #argument) then
                        child_5.Visible = true
                    end
                end
            end
        end
    end
end

skill_frame.searchBar:GetPropertyChangedSignal("Text"):Connect(function()
    updateSkillResults(skill_frame.searchBar.Text)
end)

skill_frame.RightFrame.selectButton.MouseButton1Click:Connect(function()
    local lower_result = string.lower(skill_frame.RightFrame.skillName.Text)
    local text_7 = ""

    for key_3, item_3 in pairs(skill_info) do
        if string.lower(item_3.display_name) == lower_result then
            text_7 = key_3
            break
        end
    end

    local invoke_server_result = key7:InvokeServer(text_7)

    if invoke_server_result == "MissingLevel" then
        local clone_3 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
        clone_3.Parent = game.Workspace
        clone_3:Play()
        game.Debris:AddItem(clone_3, 3)

        return
    end

    if invoke_server_result ~= "Success" then
        if invoke_server_result == nil then
            local clone_4 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
            clone_4.Parent = game.Workspace
            clone_4:Play()
            game.Debris:AddItem(clone_4, 3)
        end

        return
    end

    local clone_5 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_5.Parent = game.Workspace
    clone_5:Play()
    game.Debris:AddItem(clone_5, 3)
    skill_frame.RightFrame.selectButton.Text = "SELECTED"
end)

local achievements_frame = script.Parent.AchievementsFrame
local achievement_database = require(replicated_storage.Modules.AchievementDatabase)
local scroller = achievements_frame.container.container.Scroller
local achv_claims = achievements_frame.container.container.AchvClaims
local team_roster = achievements_frame.container.PickCategoryFrame.TeamRoster
local total_achv = achievements_frame.TitleFrame.TotalAchv
local tween_service = game:GetService("TweenService")
local user_input_service = game:GetService("UserInputService")
local badge_service = game:GetService("BadgeService")
local condition_2 = game.PlaceId == 105475221999506
local udim2 = UDim2.new(0.5, 0, 1, 200)
local udim2_2 = UDim2.new(0.5, 0, 0.5, 0)
local template = achv_claims.Template
template.Parent = script
achievements_frame.Position = udim2
achievements_frame.Visible = false
local values_3 = {}
local number = 0

for name, info in pairs(achievement_database) do
    values_3[info.Type] = values_3[info.Type] or {}
    table.insert(values_3[info.Type], {
        name = name,
        info = info,
    })
    number = number + 1
end

for _, item in pairs(values_3) do
    table.sort(item, function(argument, argument_2)
        if argument.info.Requirement == argument_2.info.Requirement then
            return argument.name < argument_2.name
        end

        return argument.info.Requirement < argument_2.info.Requirement
    end)
end

local values_4 = {}
local text_3 = "Goals"
local enabled_5 = false
local number_2 = 0

local function play_sound(argument)
    local clone_3 = replicated_storage.UISounds[argument]:Clone()
    clone_3.Parent = workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
end

local function get_stat(argument)
    local first_child_2 = local_player.Data:FindFirstChild(argument.Type)

    return first_child_2 and first_child_2.Value or 0
end

local achievement_tooltip = Instance.new("TextLabel")
achievement_tooltip.Name = "AchievementTooltip"
achievement_tooltip.AutomaticSize = Enum.AutomaticSize.XY
achievement_tooltip.Size = UDim2.new(0, 0, 0, 0)
achievement_tooltip.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
achievement_tooltip.BorderSizePixel = 0
achievement_tooltip.FontFace = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Bold)
achievement_tooltip.TextColor3 = Color3.new(1, 1, 1)
achievement_tooltip.TextSize = 14
achievement_tooltip.TextXAlignment = Enum.TextXAlignment.Left
achievement_tooltip.Text = ""
achievement_tooltip.ZIndex = 50
achievement_tooltip.Active = false
achievement_tooltip.Visible = false
local ui_corner = Instance.new("UICorner")
ui_corner.CornerRadius = UDim.new(0, 3)
ui_corner.Parent = achievement_tooltip
local ui_stroke = Instance.new("UIStroke")
ui_stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ui_stroke.Color = Color3.fromRGB(108, 115, 122)
ui_stroke.Thickness = 1.5
ui_stroke.Transparency = 0.25
ui_stroke.Parent = achievement_tooltip
local ui_padding = Instance.new("UIPadding")
ui_padding.PaddingTop = UDim.new(0, 6)
ui_padding.PaddingBottom = UDim.new(0, 6)
ui_padding.PaddingLeft = UDim.new(0, 8)
ui_padding.PaddingRight = UDim.new(0, 8)
ui_padding.Parent = achievement_tooltip
achievement_tooltip.Parent = script.Parent
local value = nil

local function position_tooltip()
    local mouse_location = user_input_service:GetMouseLocation()
    local absolute_size = script.Parent.AbsoluteSize
    local absolute_size2 = achievement_tooltip.AbsoluteSize
    local sum = mouse_location.X + 15
    local sum_2 = mouse_location.Y + 15

    if sum + absolute_size2.X > absolute_size.X then
        sum = mouse_location.X - absolute_size2.X - 15
    end

    if sum_2 + absolute_size2.Y > absolute_size.Y then
        sum_2 = mouse_location.Y - absolute_size2.Y - 15
    end

    achievement_tooltip.Position = UDim2.fromOffset(sum, sum_2)
end

local function hide_tooltip()
    value = nil
    achievement_tooltip.Visible = false
end

user_input_service.InputChanged:Connect(function(input)
    if value and input.UserInputType == Enum.UserInputType.MouseMovement then
        position_tooltip()
    end
end)

local function get_reward_text(argument, argument_2)
    if argument_2.Reward then
        return "REWARD: " .. string.upper((tostring(argument_2.Reward)))
    end

    return "REWARD: " .. string.upper(argument) .. " BADGE"
end

local function update_total()
    local number_4 = 0

    for key_3 in pairs(achievement_database) do
        if values_4[key_3] then
            number_4 = number_4 + 1
        end
    end

    total_achv.Text = number_4 .. "/" .. number
end

local function fit_canvas(argument)
    local ui_list_layout = argument:FindFirstChildOfClass("UIListLayout")
    local ui_padding_2 = argument:FindFirstChildOfClass("UIPadding")
    argument.CanvasSize = UDim2.new(
        0,
        0,
        0,
        ui_list_layout.AbsoluteContentSize.Y
            + (not ui_padding_2 and 0 or ui_padding_2.PaddingTop.Offset + ui_padding_2.PaddingBottom.Offset)
    )
end

achv_claims.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    fit_canvas(achv_claims)
end)

scroller.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    fit_canvas(scroller)
end)

fit_canvas(scroller)
local callback = nil

function setupAchievementsFrame(argument)
    text_3 = argument
    value = nil
    achievement_tooltip.Visible = false

    for _, child_5 in pairs(achv_claims:GetChildren()) do
        if child_5:IsA("ImageLabel") then
            child_5:Destroy()
        end
    end

    for _, child_6 in pairs(scroller:GetChildren()) do
        if child_6:IsA("ImageLabel") and child_6:FindFirstChild("UIStroke") then
            tween_service
                :Create(child_6.UIStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Color = child_6.Name == argument and Color3.new(1, 1, 1) or Color3.fromRGB(108, 115, 122),
                })
                :Play()
        end
    end

    for index, item_3 in ipairs(values_3[argument] or {}) do
        local name_2 = item_3.name
        local info_2 = item_3.info
        local first_child_2 = local_player.Data:FindFirstChild(info_2.Type)
        local first_child_value = first_child_2 and first_child_2.Value or 0
        local clone_3 = template:Clone()
        clone_3.Name = string.format("%02d", index)
        clone_3.AchvName.Text = name_2
        clone_3.ImageLabel.Image = info_2.Icon
        clone_3.Progress.Text = math.min(first_child_value, info_2.Requirement) .. "/" .. info_2.Requirement

        if values_4[name_2] then
            clone_3.Claim.TextLabel.Text = "Claimed"
            clone_3.Claim.TextLabel.TextTransparency = 0.5
        elseif first_child_value < info_2.Requirement then
            clone_3.Claim.TextLabel.TextTransparency = 0.5
        end

        clone_3.Parent = achv_claims

        clone_3.MouseEnter:Connect(function()
            value = clone_3
            local name_3 = name_2
            local info_3 = info_2
            local text_7

            if info_3.Reward then
                text_7 = "REWARD: " .. string.upper((tostring(info_3.Reward)))
            else
                text_7 = "REWARD: " .. string.upper(name_3) .. " BADGE"
            end

            achievement_tooltip.Text = text_7
            achievement_tooltip.Visible = true
            position_tooltip()
        end)

        clone_3.MouseLeave:Connect(function()
            if value == clone_3 then
                value = nil
                achievement_tooltip.Visible = false
            end
        end)

        clone_3.Claim.MouseButton1Click:Connect(function()
            callback(name_2)
        end)
    end

    local number_4 = 0

    for key_3 in pairs(achievement_database) do
        if values_4[key_3] then
            number_4 = number_4 + 1
        end
    end

    total_achv.Text = number_4 .. "/" .. number
    fit_canvas(achv_claims)
end

local function try_claim(argument, argument_2)
    local achievement_database_entry = achievement_database[argument]

    if not achievement_database_entry or values_4[argument] then
        return false
    end

    local first_child_2 = local_player.Data:FindFirstChild(achievement_database_entry.Type)

    if (first_child_2 and first_child_2.Value or 0) < achievement_database_entry.Requirement then
        if not argument_2 then
            local clone_3 = replicated_storage.UISounds["ui-error4"]:Clone()
            clone_3.Parent = workspace
            clone_3:Play()
            game.Debris:AddItem(clone_3, 3)
        end

        return false
    end

    if not replicated_storage.Remotes:FindFirstChild("ClaimAchievement") then
        if not argument_2 then
            notification("CLAIMING IS NOT AVAILABLE YET.")
        end

        return false
    end

    local success, result = pcall(function()
        return key_handler_service:GetKey("ClaimAchievement"):InvokeServer(argument)
    end)

    if success and result == true then
        values_4[argument] = true

        return true
    end

    if not argument_2 then
        notification("AN UNKNOWN ERROR OCCURED. PLEASE TRY AGAIN.")
    end

    return false
end

callback = function(argument)
    if enabled_5 then
        return
    end

    if condition_2 then
        notification("ACHIEVEMENTS CAN'T BE CLAIMED IN THE TESTING PLACE.")

        return
    end

    enabled_5 = true

    if try_claim(argument, false) then
        local clone_3 = replicated_storage.UISounds["ui-confirm1"]:Clone()
        clone_3.Parent = workspace
        clone_3:Play()
        game.Debris:AddItem(clone_3, 3)
        setupAchievementsFrame(text_3)
    end

    enabled_5 = false
end

team_roster.MouseButton1Click:Connect(function()
    if enabled_5 then
        return
    end

    if condition_2 then
        notification("ACHIEVEMENTS CAN'T BE CLAIMED IN THE TESTING PLACE.")

        return
    end

    enabled_5 = true
    local items = {}

    for key_3, item_3 in pairs(achievement_database) do
        if not values_4[key_3] then
            local first_child_2 = local_player.Data:FindFirstChild(item_3.Type)

            if (first_child_2 and first_child_2.Value or 0) >= item_3.Requirement then
                table.insert(items, key_3)
            end
        end
    end

    if #items == 0 then
        enabled_5 = false
        notification("NOTHING TO CLAIM.")

        return
    end

    local number_4 = 0

    for _, item_4 in ipairs(items) do
        local achievement_database_entry = achievement_database[item_4]
        local enabled_6

        if achievement_database_entry and not values_4[item_4] then
            local first_child_3 = local_player.Data:FindFirstChild(achievement_database_entry.Type)

            if
                (first_child_3 and first_child_3.Value or 0) < achievement_database_entry.Requirement
                or not replicated_storage.Remotes:FindFirstChild("ClaimAchievement")
            then
                enabled_6 = false
            else
                local success, result = pcall(function()
                    return key_handler_service:GetKey("ClaimAchievement"):InvokeServer(item_4)
                end)

                if success and result == true then
                    values_4[item_4] = true
                    enabled_6 = true
                else
                    enabled_6 = false
                end
            end
        else
            enabled_6 = false
        end

        if enabled_6 then
            number_4 = number_4 + 1
        end
    end

    if number_4 > 0 then
        local clone_3 = replicated_storage.UISounds["ui-confirm1"]:Clone()
        clone_3.Parent = workspace
        clone_3:Play()
        game.Debris:AddItem(clone_3, 3)
    elseif replicated_storage.Remotes:FindFirstChild("ClaimAchievement") then
        notification("AN UNKNOWN ERROR OCCURED. PLEASE TRY AGAIN.")
    else
        notification("CLAIMING IS NOT AVAILABLE YET.")
    end

    setupAchievementsFrame(text_3)
    enabled_5 = false
end)

for _, child in pairs(scroller:GetChildren()) do
    if child:IsA("ImageLabel") and child:FindFirstChild("Button") then
        child.Button.MouseButton1Click:Connect(function()
            local clone_3 = replicated_storage.UISounds["ui-confirm1"]:Clone()
            clone_3.Parent = workspace
            clone_3:Play()
            game.Debris:AddItem(clone_3, 3)
            setupAchievementsFrame(child.Name)
        end)
    end
end

local values_5 = {}

for _, item_2 in pairs(achievement_database) do
    if not values_5[item_2.Type] then
        values_5[item_2.Type] = true
        local first_child = local_player.Data:FindFirstChild(item_2.Type)

        if first_child then
            first_child.Changed:Connect(function()
                if achievements_frame.Visible then
                    setupAchievementsFrame(text_3)
                end
            end)
        end
    end
end

task.spawn(function()
    local values_15 = {}
    local items = {}

    for key_3, item_3 in pairs(achievement_database) do
        values_15[item_3.BadgeID] = key_3
        table.insert(items, item_3.BadgeID)
    end

    for index = 1, #items, 10 do
        local _ = index
        local items_2 = {}

        for index_2 = index, math.min(index + 9, #items) do
            table.insert(items_2, items[index_2])
            local _ = index_2
        end

        local success, result = pcall(function()
            return badge_service:CheckUserBadgesAsync(local_player.UserId, items_2)
        end)

        if success and result then
            for _, item_4 in ipairs(result) do
                if values_15[item_4] then
                    values_4[values_15[item_4]] = true
                end
            end
        end
    end

    if achievements_frame.Visible then
        setupAchievementsFrame(text_3)

        return
    end

    local number_4 = 0

    for key_4 in pairs(achievement_database) do
        if values_4[key_4] then
            number_4 = number_4 + 1
        end
    end

    total_achv.Text = number_4 .. "/" .. number
end)

local number_3 = 0

for key_2 in pairs(achievement_database) do
    if values_4[key_2] then
        number_3 = number_3 + 1
    end
end

total_achv.Text = number_3 .. "/" .. number

function closeAchievements()
    value = nil
    achievement_tooltip.Visible = false

    if achievements_frame.Visible == false then
        return
    end

    number_2 = number_2 + 1
    local number_4 = number_2
    tween_service
        :Create(achievements_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = udim2,
        })
        :Play()

    task.delay(0.35, function()
        if number_2 == number_4 then
            achievements_frame.Visible = false
        end
    end)
end

function hideAchievementsInstant()
    value = nil
    achievement_tooltip.Visible = false
    number_2 = number_2 + 1
    achievements_frame.Position = udim2
    achievements_frame.Visible = false
end

menu_buttons.AchievementsButton.MouseButton1Click:Connect(function()
    if achievements_frame.Visible ~= false then
        closeAchievements()

        return
    end

    closeTeamSelect()
    closeModeSelect()
    script.Parent.SettingsFrame.Visible = false
    setupAchievementsFrame(text_3)
    tween_service
        :Create(stats_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 170),
        })
        :Play()

    task.delay(0.35, function()
        stats_frame.Visible = false
    end)

    tween_service
        :Create(skill_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 230),
        })
        :Play()

    task.delay(0.35, function()
        skill_frame.Visible = false
    end)

    tween_service
        :Create(script.Parent.ClubFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1.5, 0),
        })
        :Play()

    task.delay(0.35, function()
        script.Parent.ClubFrame.Visible = false
    end)

    number_2 = number_2 + 1
    achievements_frame.Visible = true
    tween_service
        :Create(achievements_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = udim2_2,
        })
        :Play()
end)

achievements_frame.CancelButton.MouseButton1Click:Connect(function()
    closeAchievements()
end)

menu_buttons.ClubsButton.MouseButton1Down:Connect(function()
    closeAchievements()
end)

menu_buttons.SkillsButton.MouseButton1Click:Connect(function()
    if skill_frame.Visible ~= false then
        game:GetService("TweenService")
            :Create(skill_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 1, 230),
            })
            :Play()

        task.delay(0.35, function()
            skill_frame.Visible = false
        end)

        return
    end

    closeTeamSelect()
    closeModeSelect()
    closeAchievements()
    script.Parent.SettingsFrame.Visible = false
    setupSkillsFrame(text_2)
    game:GetService("TweenService")
        :Create(stats_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 170),
        })
        :Play()

    task.delay(0.35, function()
        stats_frame.Visible = false
    end)

    skill_frame.Visible = true
    game:GetService("TweenService")
        :Create(skill_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0.5, 0),
        })
        :Play()
    game:GetService("TweenService")
        :Create(script.Parent.ClubFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1.5, 0),
        })
        :Play()

    task.delay(0.35, function()
        script.Parent.ClubFrame.Visible = false
    end)
end)

menu_buttons.StatsButton.MouseButton1Click:Connect(function()
    if stats_frame.Visible ~= false then
        game:GetService("TweenService")
            :Create(stats_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 1, 170),
            })
            :Play()

        task.delay(0.35, function()
            stats_frame.Visible = false
        end)

        return
    end

    closeTeamSelect()
    closeModeSelect()
    closeAchievements()
    script.Parent.SettingsFrame.Visible = false
    game:GetService("TweenService")
        :Create(skill_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 230),
        })
        :Play()

    task.delay(0.35, function()
        skill_frame.Visible = false
    end)

    task.spawn(function()
        stats_frame.TitleFrame.MoneyValue.Text = getPlayerValue()
    end)

    stats_frame.Visible = true
    game:GetService("TweenService")
        :Create(stats_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0.5, 0),
        })
        :Play()
end)

skill_frame.TitleFrame.CancelButton.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(skill_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 230),
        })
        :Play()

    task.delay(0.35, function()
        skill_frame.Visible = false
    end)
end)

stats_frame.TitleFrame.CancelButton.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(stats_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 170),
        })
        :Play()

    task.delay(0.35, function()
        stats_frame.Visible = false
    end)
end)

local customize_button = menu_buttons.CustomizeButton
local equip_frame = customization_frame.EquipFrame
local items_frame = customization_frame.ItemsFrame
local select_frame = customization_frame.SelectFrame
local values_6 = {
    Default = "http://www.roblox.com/asset/?id=8215214363",
    LongSleeve = "rbxassetid://16728126739",
    Tracksuit = "rbxassetid://16728138036",
    HandWrap = "rbxassetid://72720706206318",
    Undershirt = "rbxassetid://18565763187",
    None = "rbxassetid://18295163188",
    BlackGloves = "rbxassetid://18566362734",
    WhiteGloves = "rbxassetid://104532564191542",
    BlackFacemask = "rbxassetid://122170710702541",
    WhiteFacemask = "rbxassetid://96362968821852",
    BlackWristband = "rbxassetid://134371080571386",
    WhiteWristband = "rbxassetid://72720706206318",
}
local values_7 = {
    Default = "DEFAULT",
    LongSleeve = "LONG SLEEVE",
    Undershirt = "JERSEY W/ UNDERSHIRT",
    Tracksuit = "TRACKSUIT",
    None = "NONE",
    BlackGloves = "BLACK GLOVES",
    WhiteGloves = "WHITE GLOVES",
    BlackFacemask = "BLACK FACEMASK",
    WhiteFacemask = "WHITE FACEMASK",
    HandWrap = "HAND WRAP",
    BlackWristband = "BLACK WRISTBAND",
    WhiteWristband = "WHITE WRISTBAND",
}
local values_8 = {
    Common = Color3.new(1, 1, 1),
    Rare = Color3.new(0.262745, 0.462745, 0.792157),
    Epic = Color3.new(0.792157, 0, 0.862745),
    Legendary = Color3.new(1, 0, 0),
    Exclusive = Color3.new(1, 0.968627, 0),
}

function updateShirtType()
    select_frame.ShirtsButton.CurrentlyEquipped.Text = values_7[local_player.Data.shirtType.Value] == nil and "DEFAULT"
        or (values_7[local_player.Data.shirtType.Value] or "DEFAULT")

    if values_6[local_player.Data.shirtType.Value] ~= nil then
        select_frame.ShirtsButton.Icon.Image = values_6[local_player.Data.shirtType.Value] == nil
                and "http://www.roblox.com/asset/?id=8215214363"
            or (values_6[local_player.Data.shirtType.Value] or "http://www.roblox.com/asset/?id=8215214363")
    end
end

updateShirtType()
local_player.Data.shirtType.Changed:Connect(updateShirtType)

function updateAnimationType()
    local first_child_2 = game.ReplicatedStorage.ItemInfo:FindFirstChild(local_player.Data.animationType.Value)

    if not first_child_2 then
        return
    end

    select_frame.AnimationsButton.CurrentlyEquipped.TextColor3 = values_8[first_child_2.Rarity.Value]
    select_frame.AnimationsButton.CurrentlyEquipped.Text = string.upper(first_child_2.Name)
    select_frame.AnimationsButton.Icon.Image = first_child_2.itemIcon.Texture
end

updateAnimationType()
local_player.Data.animationType.Changed:Connect(updateAnimationType)

function updateGloveType()
    local first_child_2 = game.ReplicatedStorage.ItemInfo:FindFirstChild(local_player.Data.GoalieGloves.Value)

    if not first_child_2 then
        return
    end

    select_frame.GoalieGlovesButton.CurrentlyEquipped.TextColor3 = values_8[first_child_2.Rarity.Value]
    select_frame.GoalieGlovesButton.CurrentlyEquipped.Text = string.upper(first_child_2.Name)
    select_frame.GoalieGlovesButton.Icon.Image = first_child_2.itemIcon.Texture
end

updateGloveType()
local_player.Data.GoalieGloves.Changed:Connect(updateGloveType)

function updateAccessory()
    select_frame.AccessoriesButton.CurrentlyEquipped.Text = values_7[local_player.Data.Accessory.Value] == nil
            and "NONE"
        or (values_7[local_player.Data.Accessory.Value] or "NONE")

    if values_6[local_player.Data.Accessory.Value] ~= nil then
        select_frame.AccessoriesButton.Icon.Image = values_6[local_player.Data.Accessory.Value] == nil
                and "http://www.roblox.com/asset/?id=18295163188"
            or (values_6[local_player.Data.Accessory.Value] or "http://www.roblox.com/asset/?id=18295163188")
    end
end

updateAccessory()
local_player.Data.Accessory.Changed:Connect(updateAccessory)

function updateScoreAura()
    local first_child_2 = game.ReplicatedStorage.ItemInfo:FindFirstChild(local_player.Data.ScoreAura.Value)

    if not first_child_2 then
        return
    end

    select_frame.AuraButton.CurrentlyEquipped.TextColor3 = values_8[first_child_2.Rarity.Value]
    select_frame.AuraButton.CurrentlyEquipped.Text = string.upper(first_child_2.Name)
    select_frame.AuraButton.Icon.Image = first_child_2.itemIcon.Texture
end

updateScoreAura()
local_player.Data.ScoreAura.Changed:Connect(updateScoreAura)

function updateMVPEyes()
    local first_child_2 = game.ReplicatedStorage.ItemInfo:FindFirstChild(local_player.Data.MVPEyes.Value)

    if not first_child_2 then
        return
    end

    select_frame.EyesButton.CurrentlyEquipped.TextColor3 = values_8[first_child_2.Rarity.Value]
    select_frame.EyesButton.CurrentlyEquipped.Text = string.upper(first_child_2.Name)
    select_frame.EyesButton.Icon.Image = first_child_2.itemIcon.Texture
end

updateMVPEyes()
local_player.Data.MVPEyes.Changed:Connect(updateMVPEyes)

function updateGoalCeleb()
    local first_child_2 = game.ReplicatedStorage.ItemInfo:FindFirstChild(local_player.Data.GoalCelebration.Value)

    if not first_child_2 then
        return
    end

    select_frame.GoalCelebButton.CurrentlyEquipped.TextColor3 = values_8[first_child_2.Rarity.Value]
    select_frame.GoalCelebButton.CurrentlyEquipped.Text = string.upper(first_child_2.Name)
    select_frame.GoalCelebButton.Icon.Image = first_child_2.itemIcon.Texture
end

updateGoalCeleb()
local_player.Data.GoalCelebration.Changed:Connect(updateGoalCeleb)

function updateWinCeleb()
    local first_child_2 = game.ReplicatedStorage.ItemInfo:FindFirstChild(local_player.Data.WinCelebration.Value)

    if not first_child_2 then
        return
    end

    select_frame.WinCelebButton.CurrentlyEquipped.TextColor3 = values_8[first_child_2.Rarity.Value]
    select_frame.WinCelebButton.CurrentlyEquipped.Text = string.upper(first_child_2.Name)
    select_frame.WinCelebButton.Icon.Image = first_child_2.itemIcon.Texture
end

updateWinCeleb()
local_player.Data.WinCelebration.Changed:Connect(updateWinCeleb)
local item_info = game.ReplicatedStorage.ItemInfo

function runCustomizationSetup()
    for _, child_5 in pairs(items_frame.AurasFrame:GetChildren()) do
        if child_5:IsA("ImageButton") then
            child_5:Destroy()
        end
    end

    for _, child_6 in pairs(items_frame.AnimationFrame:GetChildren()) do
        if child_6:IsA("ImageButton") then
            child_6:Destroy()
        end
    end

    for _, child_7 in pairs(items_frame.GoalieGlovesFrame:GetChildren()) do
        if child_7:IsA("ImageButton") then
            child_7:Destroy()
        end
    end

    for _, child_8 in pairs(items_frame.EyesFrame:GetChildren()) do
        if child_8:IsA("ImageButton") then
            child_8:Destroy()
        end
    end

    for _, child_9 in pairs(items_frame.GoalCelebFrame:GetChildren()) do
        if child_9:IsA("ImageButton") then
            child_9:Destroy()
        end
    end

    for _, child_10 in pairs(items_frame.WinCelebFrame:GetChildren()) do
        if child_10:IsA("ImageButton") then
            child_10:Destroy()
        end
    end

    local parts = string.split(local_player.Data.Inventory.Value)

    for _, descendant_3 in pairs(items_frame:GetDescendants()) do
        if descendant_3:IsA("ImageButton") then
            if table.find(parts, descendant_3.Name) then
                if descendant_3:FindFirstChild("Locked") then
                    descendant_3.Locked.Visible = false
                    descendant_3.LockedBG.Visible = false

                    if descendant_3:FindFirstChild("Price") then
                        descendant_3.Price.Visible = false
                    end
                end
            else
                descendant_3.Locked.Visible = true
                descendant_3.LockedBG.Visible = true

                if descendant_3:FindFirstChild("Price") then
                    descendant_3.Price.Visible = true
                end
            end
        end
    end

    for _, child_name in pairs(parts) do
        local first_child_2 = item_info:FindFirstChild(child_name)

        if first_child_2 then
            local instance = script.itemTemplate:Clone()
            instance.Name = first_child_2.Name
            instance.itemName.Text = string.upper(first_child_2.Name)
            instance.itemName.TextColor3 = values_8[first_child_2.Rarity.Value]
            instance.Icon.Image = first_child_2.itemIcon.Texture

            if first_child_2.Type.Value == "Aura" then
                instance.Parent = items_frame.AurasFrame
            elseif first_child_2.Type.Value == "AnimationPack" then
                instance.Parent = items_frame.AnimationFrame
            elseif first_child_2.Type.Value == "Eyes" then
                instance.Parent = items_frame.EyesFrame
            elseif first_child_2.Type.Value == "Glove" then
                instance.Parent = items_frame.GoalieGlovesFrame
            elseif first_child_2.Type.Value == "GoalCeleb" then
                instance.Parent = items_frame.GoalCelebFrame

                if first_child_2:FindFirstChild("AlsoWinCeleb") then
                    local instance_2 = script.itemTemplate:Clone()
                    instance_2.Name = first_child_2.Name
                    instance_2.itemName.Text = string.upper(first_child_2.Name)
                    instance_2.itemName.TextColor3 = values_8[first_child_2.Rarity.Value]
                    instance_2.Icon.Image = first_child_2.itemIcon.Texture
                    instance_2.Parent = items_frame.WinCelebFrame

                    instance_2.MouseButton1Click:Connect(function()
                        doSelection(instance_2)
                    end)
                end
            elseif first_child_2.Type.Value == "WinCeleb" then
                instance.Parent = items_frame.WinCelebFrame

                if first_child_2:FindFirstChild("AlsoGoalCeleb") then
                    local instance_3 = script.itemTemplate:Clone()
                    instance_3.Name = first_child_2.Name
                    instance_3.itemName.Text = string.upper(first_child_2.Name)
                    instance_3.itemName.TextColor3 = values_8[first_child_2.Rarity.Value]
                    instance_3.Icon.Image = first_child_2.itemIcon.Texture
                    instance_3.Parent = items_frame.GoalCelebFrame

                    instance_3.MouseButton1Click:Connect(function()
                        doSelection(instance_3)
                    end)
                end
            end

            instance.MouseButton1Click:Connect(function()
                doSelection(instance)
            end)
        end
    end
end

runCustomizationSetup()

customize_button.MouseButton1Click:Connect(function()
    color_selector.Visible = false
    customization_frame:SetAttribute("vis", true)
    runCustomizationSetup()
    game:GetService("TweenService")
        :Create(customization_frame.ItemsFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0.5, 0),
        })
        :Play()
    game:GetService("TweenService")
        :Create(customization_frame.SelectFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, 0, 1, 0),
        })
        :Play()
    game:GetService("TweenService")
        :Create(
            customization_frame.CancelButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Position = UDim2.new(0.5, 0, 0.95, 0),
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(script.Parent.ClubFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1.5, 0),
        })
        :Play()

    task.delay(0.35, function()
        script.Parent.ClubFrame.Visible = false
    end)

    closeAchievements()
    menu_buttons.Visible = false
    play_button.Visible = false
end)

customization_frame.CancelButton.MouseButton1Click:Connect(function()
    customization_frame:SetAttribute("vis", false)
    color_selector.Visible = false
    game:GetService("TweenService")
        :Create(customization_frame.ItemsFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, -350, 0.5, 0),
        })
        :Play()
    game:GetService("TweenService")
        :Create(customization_frame.SelectFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, 800, 1, 0),
        })
        :Play()
    game:GetService("TweenService")
        :Create(
            customization_frame.CancelButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Position = UDim2.new(0.5, 0, 0.95, 200),
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(equip_frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 150),
        })
        :Play()
    menu_buttons.Visible = true
    play_button.Visible = true
end)

local shirts_frame = items_frame.ShirtsFrame
local accessories_frame = items_frame.AccessoriesFrame
local value_2 = nil
local text_4 = "shirtType"

select_frame.AnimationsButton.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(equip_frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 150),
        })
        :Play()
    value_2 = nil
    text_4 = "animationType"
    items_frame.AnimationFrame.Visible = true
    color_selector.Visible = false
    game:GetService("TweenService")
        :Create(
            select_frame.AnimationsButton.UIStroke,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Thickness = 4,
                Transparency = 0,
                Color = Color3.new(1, 1, 1),
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            select_frame.AnimationsButton.Icon,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Size = UDim2.new(0, 105, 0, 90),
            }
        )
        :Play()

    for _, child_5 in pairs(items_frame:GetChildren()) do
        if (child_5:IsA("Frame") or child_5:IsA("ScrollingFrame")) and child_5 ~= items_frame.AnimationFrame then
            child_5.Visible = false
        end
    end

    for _, child_6 in pairs(select_frame:GetChildren()) do
        if child_6:IsA("ImageButton") and child_6 ~= select_frame.AnimationsButton then
            game:GetService("TweenService")
                :Create(child_6.UIStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Thickness = 2,
                    Transparency = 0.25,
                    Color = Color3.new(0.498039, 0.529412, 0.560784),
                })
                :Play()
            game:GetService("TweenService")
                :Create(child_6.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 97, 0, 85),
                })
                :Play()
        end
    end
end)

select_frame.GoalieGlovesButton.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(equip_frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 150),
        })
        :Play()
    value_2 = nil
    text_4 = "GoalieGloves"
    items_frame.GoalieGlovesFrame.Visible = true
    color_selector.Visible = false
    game:GetService("TweenService")
        :Create(
            select_frame.GoalieGlovesButton.UIStroke,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Thickness = 4,
                Transparency = 0,
                Color = Color3.new(1, 1, 1),
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            select_frame.GoalieGlovesButton.Icon,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Size = UDim2.new(0, 105, 0, 90),
            }
        )
        :Play()

    for _, child_5 in pairs(items_frame:GetChildren()) do
        if (child_5:IsA("Frame") or child_5:IsA("ScrollingFrame")) and child_5 ~= items_frame.GoalieGlovesFrame then
            child_5.Visible = false
        end
    end

    for _, child_6 in pairs(select_frame:GetChildren()) do
        if child_6:IsA("ImageButton") and child_6 ~= select_frame.GoalieGlovesButton then
            game:GetService("TweenService")
                :Create(child_6.UIStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Thickness = 2,
                    Transparency = 0.25,
                    Color = Color3.new(0.498039, 0.529412, 0.560784),
                })
                :Play()
            game:GetService("TweenService")
                :Create(child_6.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 97, 0, 85),
                })
                :Play()
        end
    end
end)

select_frame.ShirtsButton.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(equip_frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 150),
        })
        :Play()
    value_2 = nil
    text_4 = "shirtType"
    items_frame.ShirtsFrame.Visible = true
    color_selector.Visible = false
    game:GetService("TweenService")
        :Create(
            select_frame.ShirtsButton.UIStroke,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Thickness = 4,
                Transparency = 0,
                Color = Color3.new(1, 1, 1),
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(select_frame.ShirtsButton.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 105, 0, 90),
        })
        :Play()

    for _, child_5 in pairs(items_frame:GetChildren()) do
        if (child_5:IsA("Frame") or child_5:IsA("ScrollingFrame")) and child_5 ~= items_frame.ShirtsFrame then
            child_5.Visible = false
        end
    end

    for _, child_6 in pairs(select_frame:GetChildren()) do
        if child_6:IsA("ImageButton") and child_6 ~= select_frame.ShirtsButton then
            game:GetService("TweenService")
                :Create(child_6.UIStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Thickness = 2,
                    Transparency = 0.25,
                    Color = Color3.new(0.498039, 0.529412, 0.560784),
                })
                :Play()
            game:GetService("TweenService")
                :Create(child_6.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 97, 0, 85),
                })
                :Play()
        end
    end
end)

select_frame.AccessoriesButton.MouseButton1Click:Connect(function()
    color_selector.Color.BackgroundColor3 = local_player.Data.AccessoryColor.Value
    color_selector.Visible = true
    game:GetService("TweenService")
        :Create(equip_frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 150),
        })
        :Play()
    value_2 = nil
    text_4 = "Accessory"
    items_frame.AccessoriesFrame.Visible = true
    game:GetService("TweenService")
        :Create(
            select_frame.AccessoriesButton.UIStroke,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Thickness = 4,
                Transparency = 0,
                Color = Color3.new(1, 1, 1),
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            select_frame.AccessoriesButton.Icon,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Size = UDim2.new(0, 105, 0, 90),
            }
        )
        :Play()

    for _, child_5 in pairs(items_frame:GetChildren()) do
        if (child_5:IsA("Frame") or child_5:IsA("ScrollingFrame")) and child_5 ~= items_frame.AccessoriesFrame then
            child_5.Visible = false
        end
    end

    for _, child_6 in pairs(select_frame:GetChildren()) do
        if child_6:IsA("ImageButton") and child_6 ~= select_frame.AccessoriesButton then
            game:GetService("TweenService")
                :Create(child_6.UIStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Thickness = 2,
                    Transparency = 0.25,
                    Color = Color3.new(0.498039, 0.529412, 0.560784),
                })
                :Play()
            game:GetService("TweenService")
                :Create(child_6.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 97, 0, 85),
                })
                :Play()
        end
    end
end)

select_frame.AuraButton.MouseButton1Click:Connect(function()
    color_selector.Visible = false
    game:GetService("TweenService")
        :Create(equip_frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 150),
        })
        :Play()
    value_2 = nil
    text_4 = "ScoreAura"
    items_frame.AurasFrame.Visible = true
    game:GetService("TweenService")
        :Create(
            select_frame.AuraButton.UIStroke,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Thickness = 4,
                Transparency = 0,
                Color = Color3.new(1, 1, 1),
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(select_frame.AuraButton.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 105, 0, 90),
        })
        :Play()

    for _, child_5 in pairs(items_frame:GetChildren()) do
        if (child_5:IsA("Frame") or child_5:IsA("ScrollingFrame")) and child_5 ~= items_frame.AurasFrame then
            child_5.Visible = false
        end
    end

    for _, child_6 in pairs(select_frame:GetChildren()) do
        if child_6:IsA("ImageButton") and child_6 ~= select_frame.AuraButton then
            game:GetService("TweenService")
                :Create(child_6.UIStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Thickness = 2,
                    Transparency = 0.25,
                    Color = Color3.new(0.498039, 0.529412, 0.560784),
                })
                :Play()
            game:GetService("TweenService")
                :Create(child_6.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 97, 0, 85),
                })
                :Play()
        end
    end
end)

select_frame.EyesButton.MouseButton1Click:Connect(function()
    color_selector.Visible = false
    game:GetService("TweenService")
        :Create(equip_frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 150),
        })
        :Play()
    value_2 = nil
    text_4 = "MVPEyes"
    items_frame.EyesFrame.Visible = true
    game:GetService("TweenService")
        :Create(
            select_frame.EyesButton.UIStroke,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Thickness = 4,
                Transparency = 0,
                Color = Color3.new(1, 1, 1),
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(select_frame.EyesButton.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 105, 0, 90),
        })
        :Play()

    for _, child_5 in pairs(items_frame:GetChildren()) do
        if (child_5:IsA("Frame") or child_5:IsA("ScrollingFrame")) and child_5 ~= items_frame.EyesFrame then
            child_5.Visible = false
        end
    end

    for _, child_6 in pairs(select_frame:GetChildren()) do
        if child_6:IsA("ImageButton") and child_6 ~= select_frame.EyesButton then
            game:GetService("TweenService")
                :Create(child_6.UIStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Thickness = 2,
                    Transparency = 0.25,
                    Color = Color3.new(0.498039, 0.529412, 0.560784),
                })
                :Play()
            game:GetService("TweenService")
                :Create(child_6.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 97, 0, 85),
                })
                :Play()
        end
    end
end)

select_frame.GoalCelebButton.MouseButton1Click:Connect(function()
    color_selector.Visible = false
    game:GetService("TweenService")
        :Create(equip_frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 150),
        })
        :Play()
    value_2 = nil
    text_4 = "GoalCelebration"
    items_frame.GoalCelebFrame.Visible = true
    game:GetService("TweenService")
        :Create(
            select_frame.GoalCelebButton.UIStroke,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Thickness = 4,
                Transparency = 0,
                Color = Color3.new(1, 1, 1),
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            select_frame.GoalCelebButton.Icon,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Size = UDim2.new(0, 105, 0, 90),
            }
        )
        :Play()

    for _, child_5 in pairs(items_frame:GetChildren()) do
        if (child_5:IsA("Frame") or child_5:IsA("ScrollingFrame")) and child_5 ~= items_frame.GoalCelebFrame then
            child_5.Visible = false
        end
    end

    for _, child_6 in pairs(select_frame:GetChildren()) do
        if child_6:IsA("ImageButton") and child_6 ~= select_frame.GoalCelebButton then
            game:GetService("TweenService")
                :Create(child_6.UIStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Thickness = 2,
                    Transparency = 0.25,
                    Color = Color3.new(0.498039, 0.529412, 0.560784),
                })
                :Play()
            game:GetService("TweenService")
                :Create(child_6.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 97, 0, 85),
                })
                :Play()
        end
    end
end)

select_frame.WinCelebButton.MouseButton1Click:Connect(function()
    color_selector.Visible = false
    game:GetService("TweenService")
        :Create(equip_frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 150),
        })
        :Play()
    value_2 = nil
    text_4 = "WinCelebration"
    items_frame.WinCelebFrame.Visible = true
    game:GetService("TweenService")
        :Create(
            select_frame.WinCelebButton.UIStroke,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Thickness = 4,
                Transparency = 0,
                Color = Color3.new(1, 1, 1),
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            select_frame.WinCelebButton.Icon,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Size = UDim2.new(0, 105, 0, 90),
            }
        )
        :Play()

    for _, child_5 in pairs(items_frame:GetChildren()) do
        if (child_5:IsA("Frame") or child_5:IsA("ScrollingFrame")) and child_5 ~= items_frame.WinCelebFrame then
            child_5.Visible = false
        end
    end

    for _, child_6 in pairs(select_frame:GetChildren()) do
        if child_6:IsA("ImageButton") and child_6 ~= select_frame.WinCelebButton then
            game:GetService("TweenService")
                :Create(child_6.UIStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Thickness = 2,
                    Transparency = 0.25,
                    Color = Color3.new(0.498039, 0.529412, 0.560784),
                })
                :Play()
            game:GetService("TweenService")
                :Create(child_6.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 97, 0, 85),
                })
                :Play()
        end
    end
end)

equip_frame.EquipButton.MouseButton1Click:Connect(function()
    if value_2 == nil then
        return
    end

    key:FireServer(text_4, value_2)
    local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 2)
    equip_frame.EquipButton.Text = "EQUIPPED"
end)

function showConfirmation(instance)
    customization_frame.PopupContainer.Visible = true
    customization_frame.PopupContainer.PurchaseText.Text = "WOULD YOU LIKE TO PURCHASE <"
        .. instance.Type.Text
        .. "> for "
        .. instance.Price.Text
        .. "?"
    local connection = nil
    local connection_2 = nil
    connection_2 = customization_frame.PopupContainer.YesButton.MouseButton1Click:Connect(function()
        if key8:InvokeServer(instance.Name) ~= nil then
            if instance:FindFirstChild("Locked") then
                instance.Locked.Visible = false
                instance.LockedBG.Visible = false

                if instance:FindFirstChild("Price") then
                    instance.Price.Visible = false
                end

                local clone_3 = game.ReplicatedStorage.UISounds.Item_Box_Get2:Clone()
                clone_3.Parent = game.Workspace
                clone_3:Play()
                game.Debris:AddItem(clone_3, 2)
            end

            connection_2:Disconnect()
            customization_frame.PopupContainer.Visible = false

            return
        end

        local clone_4 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
        clone_4.Parent = game.Workspace
        clone_4:Play()
        game.Debris:AddItem(clone_4, 3)

        task.spawn(function()
            game:GetService("TweenService")
                :Create(instance.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Rotation = 45,
                })
                :Play()
            task.wait(0.1)
            game:GetService("TweenService")
                :Create(instance.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Rotation = -45,
                })
                :Play()
            task.wait(0.1)
            game:GetService("TweenService")
                :Create(instance.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Rotation = 0,
                })
                :Play()
        end)
    end)
    connection = customization_frame.PopupContainer.NoButton.MouseButton1Click:Connect(function()
        connection_2:Disconnect()
        connection:Disconnect()
        customization_frame.PopupContainer.Visible = false
    end)
end

function doSelection(instance: userdata)
    local parts = string.split(local_player.Data.Inventory.Value)

    if not table.find(parts, instance.Name) and instance:FindFirstChild("Price") then
        game:GetService("TweenService")
            :Create(equip_frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 1, 150),
            })
            :Play()
        showConfirmation(instance)

        return
    end

    if value_2 == instance.Name then
        value_2 = nil
        game:GetService("TweenService")
            :Create(equip_frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 1, 150),
            })
            :Play()
        game:GetService("TweenService")
            :Create(instance.UIStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Thickness = 2,
                Transparency = 0.25,
                Color = Color3.new(0.498039, 0.529412, 0.560784),
            })
            :Play()

        return
    end

    for _, child_5 in pairs(instance.Parent:GetChildren()) do
        if child_5 ~= instance and child_5:IsA("ImageButton") then
            game:GetService("TweenService")
                :Create(child_5.UIStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Thickness = 2,
                    Transparency = 0.25,
                    Color = Color3.new(0.498039, 0.529412, 0.560784),
                })
                :Play()
        end
    end

    value_2 = instance.Name
    game:GetService("TweenService")
        :Create(equip_frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, -125),
        })
        :Play()
    game:GetService("TweenService")
        :Create(instance.UIStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Thickness = 3,
            Transparency = 0,
            Color = Color3.new(1, 1, 1),
        })
        :Play()
    equip_frame.EquipButton.Text = "EQUIP"

    for _, child_6 in pairs(local_player.Data:GetChildren()) do
        if child_6:IsA("StringValue") and child_6.Value == instance.Name then
            equip_frame.EquipButton.Text = "EQUIPPED"

            return
        end
    end
end

shirts_frame.Default.MouseButton1Click:Connect(function()
    doSelection(shirts_frame.Default)
end)

shirts_frame.LongSleeve.MouseButton1Click:Connect(function()
    doSelection(shirts_frame.LongSleeve)
end)

shirts_frame.Undershirt.MouseButton1Click:Connect(function()
    doSelection(shirts_frame.Undershirt)
end)

shirts_frame.Tracksuit.MouseButton1Click:Connect(function()
    doSelection(shirts_frame.Tracksuit)
end)

accessories_frame.None.MouseButton1Click:Connect(function()
    doSelection(accessories_frame.None)
end)

accessories_frame.BlackGloves.MouseButton1Click:Connect(function()
    doSelection(accessories_frame.BlackGloves)
end)

accessories_frame.WhiteGloves.MouseButton1Click:Connect(function()
    doSelection(accessories_frame.WhiteGloves)
end)

accessories_frame.BlackFaceMask.MouseButton1Click:Connect(function()
    doSelection(accessories_frame.BlackFaceMask)
end)

accessories_frame.HandWrap.MouseButton1Click:Connect(function()
    doSelection(accessories_frame.HandWrap)
end)

accessories_frame.WhiteFaceMask.MouseButton1Click:Connect(function()
    doSelection(accessories_frame.WhiteFaceMask)
end)

accessories_frame.WhiteWristband.MouseButton1Click:Connect(function()
    doSelection(accessories_frame.WhiteWristband)
end)

accessories_frame.BlackWristband.MouseButton1Click:Connect(function()
    doSelection(accessories_frame.BlackWristband)
end)

local team_info = game.ReplicatedStorage.TeamInfo
local values_9 = {
    Argentina = "Argentina",
    AstonVilla = "Aston Vila",
    Munich = "Munich",
    Dortmund = "Dortmund",
    Brazil = "Brazil",
    ParisSaints = "Paris",
    ManchesterU = "Manchester Utd.",
    Barcelona = "Barcelona",
    Flamengo = "Flamengo",
    InterMiami = "Inter Miami",
    Japan = "Japan",
    Italy = "Italy",
    Croatia = "Croatia",
    Morocco = "Morocco",
    Canada = "Canada",
    Portugal = "Portugal",
    Mexico = "Mexico",
    Netherlands = "Netherlands",
    RealMadrid = "Real Madrid",
    LiverpoolFC = "Liverpool FC",
    SeattleSoundersFC = "Sounders FC",
    JuventusFC = "Juventus FC",
    Newcastle = "Newcastle Utd.",
    ManchesterCity = "Man. City",
    Germany = "Germany",
    England = "England",
    Arsenal = "Arsenal",
    InterMilan = "Inter Milan",
    USA = "USA",
    Chelsea = "Chelsea",
    Napoli = "Napoli",
    France = "France",
    Uruguay = "Uruguay",
    Roma = "Roma",
    Lazio = "Lazio",
    SouthKorea = "South Korea",
    VascoDaGama = "Vasco da Gama",
    Ajax = "AFC Ajax",
    Atletico = "Atletico Madrid",
    Leverkusen = "B04 Leverkusen",
    Wales = "Wales",
    Fiorentina = "Fiorentina",
    Spurs = "Tottenham Hotspurs",
    ACMilan = "AC Milan",
    Belgium = "Belgium",
    Spain = "Spain",
    Scotland = "Scotland",
    Poland = "Poland",
    Sweden = "Sweden",
    Bosnia = "Bosnia & Herzegovina",
    Denmark = "Denmark",
    Romania = "Romania",
    Switzerland = "Switzerland",
}
local values_10 = {
    AstonVilla = BrickColor.new("Baby blue"),
    Flamengo = BrickColor.new("Dark red"),
    Argentina = BrickColor.new("Cyan"),
    Munich = BrickColor.new("Dusty Rose"),
    Dortmund = BrickColor.new("Bright yellow"),
    Brazil = BrickColor.new("Dark green"),
    ParisSaints = BrickColor.new("Dark blue"),
    ManchesterU = BrickColor.new("Bright red"),
    Barcelona = BrickColor.new("Deep blue"),
    InterMiami = BrickColor.new("Carnation pink"),
    Japan = BrickColor.new("Navy blue"),
    Italy = BrickColor.new("Lapis"),
    Croatia = BrickColor.new("Pastel Blue"),
    Morocco = BrickColor.new("Crimson"),
    Canada = BrickColor.new("Ghost grey"),
    Portugal = BrickColor.new("Bright red"),
    Mexico = BrickColor.new("Black"),
    Netherlands = BrickColor.new("Neon orange"),
    RealMadrid = BrickColor.new("Ghost grey"),
    LiverpoolFC = BrickColor.new("Really red"),
    SeattleSoundersFC = BrickColor.new("Bright green"),
    JuventusFC = BrickColor.new("Really black"),
    Newcastle = BrickColor.new("Smoky grey"),
    ManchesterCity = BrickColor.new("Electric blue"),
    Germany = BrickColor.new("Maroon"),
    Arsenal = BrickColor.new("Really red"),
    InterMilan = BrickColor.new("Navy blue"),
    USA = BrickColor.new("Deep blue"),
    Chelsea = BrickColor.new("Lapis"),
    Napoli = BrickColor.new("Steel blue"),
    France = BrickColor.new("Dark blue"),
    Uruguay = BrickColor.new("Medium blue"),
    Roma = BrickColor.new("Persimmon"),
    Lazio = BrickColor.new("Medium blue"),
    England = BrickColor.new("Fossil"),
    SouthKorea = BrickColor.new("Mid gray"),
    VascoDaGama = BrickColor.new("Mid gray"),
    Ajax = BrickColor.new("Salmon"),
    Atletico = BrickColor.new("Crimson"),
    Leverkusen = BrickColor.new("Cocoa"),
    Wales = BrickColor.new("Sea green"),
    Fiorentina = BrickColor.new("Royal purple"),
    Spurs = BrickColor.new("Quill grey"),
    ACMilan = BrickColor.new("Maroon"),
    Belgium = BrickColor.new("Deep orange"),
    Spain = BrickColor.new("Bright orange"),
    Scotland = BrickColor.new("Electric blue"),
    Poland = BrickColor.new("Terra Cotta"),
    Sweden = BrickColor.new("Storm blue"),
    Bosnia = BrickColor.new("Dark indigo"),
    Denmark = BrickColor.new("Really red"),
    Romania = BrickColor.new("Bright yellow"),
    Switzerland = BrickColor.new("Persimmon"),
}
local values_11 = {
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
local local_player2 = game.Players.LocalPlayer
local character = local_player2.Character or local_player2.CharacterAdded:Wait()

if local_player2:FindFirstChild("InPlay") then
    play_button.Visible = false
    menu_buttons.Visible = false
end

local_player2.ChildAdded:Connect(function(child_5)
    if child_5.Name ~= "InPlay" then
        return
    end

    holder.Parent.Visible = false
    holder.Parent.Parent.Candies.Visible = false
    holder2.Parent.Visible = false
    skill_frame.Position = UDim2.new(0.5, 0, 1, 230)
    skill_frame.Visible = false
    hideAchievementsInstant()
    play_button.Visible = false
    menu_buttons.Visible = false
    customization_frame:SetAttribute("vis", false)
    customization_frame.ItemsFrame.Position = UDim2.new(0, -350, 0.5, 0)
    customization_frame.SelectFrame.Position = UDim2.new(1, 800, 1, 0)
    customization_frame.CancelButton.Position = UDim2.new(0.5, 0, 0.95, 200)
    color_selector.Visible = false
    equip_frame.Position = UDim2.new(0, -125, 0.5, 150)
end)

local_player2.ChildRemoved:Connect(function(child_5)
    if child_5.Name ~= "InPlay" then
        return
    end

    holder.Parent.Visible = true
    holder.Parent.Parent.Candies.Visible = true
    holder2.Parent.Visible = true

    if game.ReplicatedStorage:FindFirstChild("EndScreen") then
        repeat
            task.wait()
        until not game.ReplicatedStorage:FindFirstChild("EndScreen")
    end

    play_button.Visible = true
    menu_buttons.Visible = true
end)

local enabled_2 = false

team_info.CurrentHomeTeam.Changed:Connect(function()
    local value_3 = game.ReplicatedStorage.TeamInfo.CurrentHomeTeam.Value
    local home_team = team_select_frame.SelectionFrame.HomeTeam
    home_team.BackgroundColor3 = values_10[value_3].Color
    home_team.Vignette.ImageColor3 = values_10[value_3].Color
    home_team.teamName.Text = values_9[value_3]
    home_team.Crest.Image = values_11[value_3]
end)

team_info.CurrentAwayTeam.Changed:Connect(function()
    local value_3 = game.ReplicatedStorage.TeamInfo.CurrentAwayTeam.Value
    local away_team = team_select_frame.SelectionFrame.AwayTeam
    away_team.BackgroundColor3 = values_10[value_3].Color
    away_team.Vignette.ImageColor3 = values_10[value_3].Color
    away_team.teamName.Text = values_9[value_3]
    away_team.Crest.Image = values_11[value_3]
end)

team_info.HomeTeamPlayers.Changed:Connect(function()
    updatePositionPlayers()
    team_select_frame.SelectionFrame.HomeTeam.plrCount.Text = team_info.HomeTeamPlayers.Value .. "/11"
end)

team_info.AwayTeamPlayers.Changed:Connect(function()
    updatePositionPlayers()
    team_select_frame.SelectionFrame.AwayTeam.plrCount.Text = team_info.AwayTeamPlayers.Value .. "/11"
end)

team_select_frame.SelectionFrame.HomeTeam.plrCount.Text = team_info.HomeTeamPlayers.Value .. "/11"
team_select_frame.SelectionFrame.AwayTeam.plrCount.Text = team_info.AwayTeamPlayers.Value .. "/11"
local mode_select_frame = script.Parent:WaitForChild("ModeSelectFrame")
local values_12 = {
    LW = nil,
    CF = nil,
    RW = nil,
    LAM = nil,
    RAM = nil,
    CDM = nil,
    LCB = nil,
    RCB = nil,
    LWB = nil,
    RWB = nil,
    GK = nil,
}
local values_13 = {
    LW = nil,
    CF = nil,
    RW = nil,
    LAM = nil,
    RAM = nil,
    CDM = nil,
    LCB = nil,
    RCB = nil,
    LWB = nil,
    RWB = nil,
    GK = nil,
}

function updatePositionPlayers()
    values_12 = {
        LW = nil,
        CF = nil,
        RW = nil,
        LAM = nil,
        RAM = nil,
        CDM = nil,
        LCB = nil,
        RCB = nil,
        LWB = nil,
        RWB = nil,
        GK = nil,
    }
    values_13 = {
        LW = nil,
        CF = nil,
        RW = nil,
        LAM = nil,
        RAM = nil,
        CDM = nil,
        LCB = nil,
        RCB = nil,
        LWB = nil,
        RWB = nil,
        GK = nil,
    }

    for _, player in pairs(game.Players:GetPlayers()) do
        if player:FindFirstChild("dataLoaded") then
            if player.SelectedTeam.Value == "Home" then
                values_12[player.SelectedPosition.Value] = string.upper(player.DisplayName)
            elseif player.SelectedTeam.Value == "Away" then
                values_13[player.SelectedPosition.Value] = string.upper(player.DisplayName)
            end
        end
    end
end

local enabled_3 = false

function openTeamSelect()
    if enabled_2 == true then
        return
    end

    local value_3 = game.ReplicatedStorage.TeamInfo.CurrentHomeTeam.Value
    local home_team = team_select_frame.SelectionFrame.HomeTeam
    home_team.BackgroundColor3 = values_10[value_3].Color
    home_team.Vignette.ImageColor3 = values_10[value_3].Color
    home_team.teamName.Text = values_9[value_3]
    home_team.Crest.Image = values_11[value_3]
    local value2 = game.ReplicatedStorage.TeamInfo.CurrentAwayTeam.Value
    local away_team = team_select_frame.SelectionFrame.AwayTeam
    away_team.BackgroundColor3 = values_10[value2].Color
    away_team.Vignette.ImageColor3 = values_10[value2].Color
    away_team.teamName.Text = values_9[value2]
    away_team.Crest.Image = values_11[value2]
    enabled_2 = true
    team_select_frame.Visible = true
    team_select_frame.Position = UDim2.new(0.5, 0, 1, 200)
    team_select_frame.CancelButton.Position = UDim2.new(0.5, 0, 1, 35)
    pos_select_frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    pos_select_frame.CancelButton.Position = UDim2.new(0.5, 0, 1, 35)
    game:GetService("TweenService")
        :Create(team_select_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0.5, 0),
        })
        :Play()
end

local text_5 = "N/A"

function closeTeamSelect()
    if enabled_2 == false then
        return
    end

    text_5 = "N/A"
    game:GetService("TweenService")
        :Create(team_select_frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, 0, 1, 200),
        })
        :Play()
    game:GetService("TweenService")
        :Create(team_select_frame.CancelButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 750),
        })
        :Play()
    game:GetService("TweenService")
        :Create(pos_select_frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, 0, 1, 250),
        })
        :Play()
    game:GetService("TweenService")
        :Create(pos_select_frame.CancelButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 750),
        })
        :Play()

    task.delay(0.5, function()
        enabled_2 = false
        team_select_frame.Visible = false
        pos_select_frame.Visible = false
    end)
end

function openModeSelect()
    if enabled_3 == true then
        return
    end

    enabled_3 = true
    mode_select_frame.Visible = true
    mode_select_frame.Position = UDim2.new(0.5, 0, 1, 200)
    mode_select_frame.CancelButton.Position = UDim2.new(0.5, 0, 1, 35)
    game:GetService("TweenService")
        :Create(mode_select_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0.5, 0),
        })
        :Play()
end

function closeModeSelect()
    if enabled_3 == false then
        return
    end

    game:GetService("TweenService")
        :Create(mode_select_frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, 0, 1, 200),
        })
        :Play()
    game:GetService("TweenService")
        :Create(mode_select_frame.CancelButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 750),
        })
        :Play()

    task.delay(0.5, function()
        enabled_3 = false
        mode_select_frame.Visible = false
    end)
end

local mode_button = script.Parent:WaitForChild("PlayButton"):WaitForChild("ModeButton")

play_button.PlayButton.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(stats_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 170),
        })
        :Play()

    task.delay(0.35, function()
        stats_frame.Visible = false
    end)

    script.Parent.SettingsFrame.Visible = false
    game:GetService("TweenService")
        :Create(skill_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 230),
        })
        :Play()

    task.delay(0.35, function()
        skill_frame.Visible = false
    end)

    game:GetService("TweenService")
        :Create(script.Parent.ClubFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1.5, 0),
        })
        :Play()

    task.delay(0.35, function()
        script.Parent.ClubFrame.Visible = false
    end)

    customization_frame:SetAttribute("vis", false)
    closeAchievements()
    openTeamSelect()
end)

mode_button.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(stats_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 170),
        })
        :Play()

    task.delay(0.35, function()
        stats_frame.Visible = false
    end)

    script.Parent.SettingsFrame.Visible = false
    game:GetService("TweenService")
        :Create(skill_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, 230),
        })
        :Play()

    task.delay(0.35, function()
        skill_frame.Visible = false
    end)

    game:GetService("TweenService")
        :Create(script.Parent.ClubFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1.5, 0),
        })
        :Play()

    task.delay(0.35, function()
        script.Parent.ClubFrame.Visible = false
    end)

    closeTeamSelect()
    closeAchievements()
    openModeSelect()
end)

mode_select_frame.CancelButton.MouseButton1Click:Connect(function()
    closeModeSelect()
end)

pos_select_frame.CancelButton.MouseButton1Click:Connect(function()
    closeTeamSelect()
end)

team_select_frame.CancelButton.MouseButton1Click:Connect(function()
    closeTeamSelect()
end)

local selection_frame2 = pos_select_frame.SelectionFrame

function handlePosSelect(argument)
    updatePositionPlayers()
    text_5 = argument

    if argument ~= "Home" then
        if argument == "Away" then
            selection_frame2.LWButton.CurrentPlayer.Text = values_13.LW or ""
            selection_frame2.CFButton.CurrentPlayer.Text = values_13.CF or ""
            selection_frame2.RWButton.CurrentPlayer.Text = values_13.RW or ""
            selection_frame2.CAMButtonL.CurrentPlayer.Text = values_13.LAM or ""
            selection_frame2.CAMButtonR.CurrentPlayer.Text = values_13.RAM or ""
            selection_frame2.CDMButton.CurrentPlayer.Text = values_13.CDM or ""
            selection_frame2.CBButtonL.CurrentPlayer.Text = values_13.LCB or ""
            selection_frame2.CBButtonR.CurrentPlayer.Text = values_13.RCB or ""
            selection_frame2.LWBButton.CurrentPlayer.Text = values_13.LWB or ""
            selection_frame2.RWBButton.CurrentPlayer.Text = values_13.RWB or ""
            selection_frame2.GKButton.CurrentPlayer.Text = values_13.GK or ""
        end

        return
    end

    selection_frame2.LWButton.CurrentPlayer.Text = values_12.LW or ""
    selection_frame2.CFButton.CurrentPlayer.Text = values_12.CF or ""
    selection_frame2.RWButton.CurrentPlayer.Text = values_12.RW or ""
    selection_frame2.CAMButtonL.CurrentPlayer.Text = values_12.LAM or ""
    selection_frame2.CAMButtonR.CurrentPlayer.Text = values_12.RAM or ""
    selection_frame2.CDMButton.CurrentPlayer.Text = values_12.CDM or ""
    selection_frame2.CBButtonL.CurrentPlayer.Text = values_12.LCB or ""
    selection_frame2.CBButtonR.CurrentPlayer.Text = values_12.RCB or ""
    selection_frame2.LWBButton.CurrentPlayer.Text = values_12.LWB or ""
    selection_frame2.RWBButton.CurrentPlayer.Text = values_12.RWB or ""
    selection_frame2.GKButton.CurrentPlayer.Text = values_12.GK or ""
end

function selectPosition(argument)
    if text_5 == "Home" then
        if values_12[argument] ~= nil then
            notification("POSITION TAKEN. PLEASE SELECT A DIFFERENT POSITION.")

            return
        end

        closeTeamSelect()
        local invoke_server_result = key9:InvokeServer(argument, "Home")

        if invoke_server_result == "TeamFull" then
            notification("TEAM FULL. SELECT A DIFFERENT TEAM.")

            return
        end

        if invoke_server_result == "PositionFull" then
            notification("POSITION TAKEN. PLEASE SELECT A DIFFERENT POSITION.")

            return
        end

        if invoke_server_result == nil then
            notification("AN UNKNOWN ERROR OCCURED. PLEASE TRY AGAIN.")
        end
    elseif text_5 == "Away" then
        if values_13[argument] == nil then
            closeTeamSelect()
            local invoke_server_result_2 = key9:InvokeServer(argument, "Away")

            if invoke_server_result_2 == "TeamFull" then
                notification("TEAM FULL. SELECT A DIFFERENT TEAM.")

                return
            end

            if invoke_server_result_2 == "PositionFull" then
                notification("POSITION TAKEN. PLEASE SELECT A DIFFERENT POSITION.")

                return
            end

            if invoke_server_result_2 == nil then
                notification("AN UNKNOWN ERROR OCCURED. PLEASE TRY AGAIN.")
            end
        else
            notification("POSITION TAKEN. PLEASE SELECT A DIFFERENT POSITION.")
        end
    end
end

team_select_frame.SelectionFrame.HomeTeam.MouseButton1Click:Connect(function()
    if
        not (
            team_info.HomeTeamPlayers.Value < 11
                and team_info.HomeTeamPlayers.Value <= team_info.AwayTeamPlayers.Value
            or (local_player2.SelectedTeam.Value == "Home" or game.ReplicatedStorage:FindFirstChild("NoTeamLimits"))
        )
    then
        notification("TEAM FULL. SELECT A DIFFERENT TEAM.")

        return
    end

    team_select_frame.Visible = false
    pos_select_frame.Visible = true
    handlePosSelect("Home")

    while pos_select_frame.Visible == true do
        task.wait()
        handlePosSelect("Home")
    end
end)

team_select_frame.SelectionFrame.AwayTeam.MouseButton1Click:Connect(function()
    if
        not (
            team_info.AwayTeamPlayers.Value < 11
                and team_info.AwayTeamPlayers.Value <= team_info.HomeTeamPlayers.Value
            or (local_player2.SelectedTeam.Value == "Away" or game.ReplicatedStorage:FindFirstChild("NoTeamLimits"))
        )
    then
        notification("TEAM FULL. SELECT A DIFFERENT TEAM.")

        return
    end

    team_select_frame.Visible = false
    pos_select_frame.Visible = true
    handlePosSelect("Away")

    while pos_select_frame.Visible == true do
        task.wait()
        handlePosSelect("Away")
    end
end)

selection_frame2.LWButton.MouseButton1Click:Connect(function()
    selectPosition("LW")
end)

selection_frame2.CFButton.MouseButton1Click:Connect(function()
    selectPosition("CF")
end)

selection_frame2.RWButton.MouseButton1Click:Connect(function()
    selectPosition("RW")
end)

selection_frame2.CAMButtonL.MouseButton1Click:Connect(function()
    selectPosition("LAM")
end)

selection_frame2.CAMButtonR.MouseButton1Click:Connect(function()
    selectPosition("RAM")
end)

selection_frame2.CDMButton.MouseButton1Click:Connect(function()
    selectPosition("CDM")
end)

selection_frame2.LWBButton.MouseButton1Click:Connect(function()
    selectPosition("LWB")
end)

selection_frame2.CBButtonL.MouseButton1Click:Connect(function()
    selectPosition("LCB")
end)

selection_frame2.CBButtonR.MouseButton1Click:Connect(function()
    selectPosition("RCB")
end)

selection_frame2.RWBButton.MouseButton1Click:Connect(function()
    selectPosition("RWB")
end)

selection_frame2.GKButton.MouseButton1Click:Connect(function()
    selectPosition("GK")
end)

local_player2:WaitForChild("dataLoaded")
local settings_frame = script.Parent.SettingsFrame
local misc_frame = settings_frame.MiscFrame
local controls_frame = settings_frame.ControlsFrame
local pick_category_frame = settings_frame.PickCategoryFrame
local misc = local_player2.Settings.Misc
local controls = local_player2.Settings.Controls

if misc.CrowdNoise.Value == false then
    for _, descendant in pairs(game.Workspace.miscFX:GetDescendants()) do
        if descendant:IsA("Sound") then
            descendant.Volume = 0
        end
    end
end

if misc.FootstepSounds.Value == false then
    character.WalkingSoundsClient.Enabled = false

    if game.SoundService:FindFirstChild("CurrentSound") then
        game.SoundService:FindFirstChild("CurrentSound"):Stop()
    end
end

function toggle(argument, enabled_6)
    game:GetService("TweenService")
        :Create(argument.Toggle, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundColor3 = enabled_6 == true and Color3.new(0, 0.666667, 0) or Color3.new(0.666667, 0, 0),
        })
        :Play()
    game:GetService("TweenService")
        :Create(argument.Toggle.Slider, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = enabled_6 == true and UDim2.new(0.5, 1, 0.5, 0) or UDim2.new(0, -1, 0.5, 0),
        })
        :Play()
end

local enabled = false
toggle(misc_frame.CROWDNOISE, misc.CrowdNoise.Value)
toggle(misc_frame.MOVETOGGLE, enabled)
toggle(misc_frame.AURAEFFECTS, misc.AuraEffects.Value)
toggle(misc_frame.ROBLOXSHIRT, misc.UseRobloxShirt.Value)
toggle(misc_frame.RAIN, misc.RainEnabled.Value)
toggle(misc_frame.SNOW, misc.SnowEnabled.Value)
toggle(misc_frame.STORMY, misc.StormEnabled.Value)
toggle(misc_frame.NIGHT, misc.Night.Value)
toggle(misc_frame.FOOTSTEPS, misc.FootstepSounds.Value)
toggle(misc_frame.SUNFLARE, misc.SunFlare.Value)
toggle(misc_frame.GRASSVISUALS, misc.GrassVisuals.Value)
toggle(misc_frame.CURVEVISUAL, misc.CurveVisual.Value)
toggle(misc_frame.HIGHLIGHTS, misc.Highlights.Value)
toggle(misc_frame.CINEMATIC, misc.CinematicMode.Value)
toggle(misc_frame.SEASONAL, misc.Seasonal.Value)
toggle(controls_frame.FLIP, controls.Flipped.Value)
toggle(controls_frame.ToggleSpin, controls.SpinToggle.Value)
toggle(misc_frame.CHARACTERROTATION, misc.CharacterRotation.Value)

misc_frame.CROWDNOISE.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.CROWDNOISE, not misc.CrowdNoise.Value)

    for _, descendant_3 in pairs(game.Workspace.miscFX:GetDescendants()) do
        if descendant_3:IsA("Sound") then
            descendant_3.Volume = misc.CrowdNoise.Value == true and 0 or descendant_3:GetAttribute("Volume")
        end
    end

    key2:FireServer("CrowdNoise", not misc.CrowdNoise.Value)
end)

misc_frame.MOVETOGGLE.Toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    script.Parent:SetAttribute("MovingUi", enabled)

    if script.Parent:GetAttribute("MovingUi", true) then
        for _, item_3 in pairs(script.Parent.Parent.Buttons.Frame:QueryDescendants("UIDragDetector")) do
            item_3.Enabled = true
        end
    else
        for _, item_4 in pairs(script.Parent.Parent.Buttons.Frame:QueryDescendants("UIDragDetector")) do
            item_4.Enabled = false
        end
    end

    toggle(misc_frame.MOVETOGGLE, enabled)
end)

misc_frame.AURAEFFECTS.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.AURAEFFECTS, not misc.AuraEffects.Value)
    key2:FireServer("AuraEffects", not misc.AuraEffects.Value)
end)

misc_frame.FOOTSTEPS.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.FOOTSTEPS, not misc.FootstepSounds.Value)

    if misc.FootstepSounds.Value == true then
        character.WalkingSoundsClient.Enabled = true

        if game.SoundService:FindFirstChild("CurrentSound") then
            game.SoundService:FindFirstChild("CurrentSound"):Stop()
        end
    else
        character.WalkingSoundsClient.Enabled = false
    end

    key2:FireServer("FootstepSounds", not misc.FootstepSounds.Value)
end)

misc_frame.SUNFLARE.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.SUNFLARE, not misc.SunFlare.Value)
    key2:FireServer("SunFlare", not misc.SunFlare.Value)
end)

misc_frame.ROBLOXSHIRT.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.ROBLOXSHIRT, not misc.UseRobloxShirt.Value)
    key2:FireServer("UseRobloxShirt", not misc.UseRobloxShirt.Value)
end)

misc_frame.HIGHLIGHTS.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.HIGHLIGHTS, not misc.Highlights.Value)
    key2:FireServer("Highlights", not misc.Highlights.Value)
end)

misc_frame.CHARACTERROTATION.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.CHARACTERROTATION, not misc.CharacterRotation.Value)
    key2:FireServer("CharacterRotation", not misc.CharacterRotation.Value)
end)

misc_frame.RAIN.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.RAIN, not misc.RainEnabled.Value)
    toggle(misc_frame.SNOW, false)
    toggle(misc_frame.STORMY, false)
    key2:FireServer("SnowEnabled", false)
    key2:FireServer("StormEnabled", false)
    key2:FireServer("RainEnabled", not misc.RainEnabled.Value)
end)

misc_frame.SNOW.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.SNOW, not misc.SnowEnabled.Value)
    toggle(misc_frame.RAIN, false)
    toggle(misc_frame.STORMY, false)
    key2:FireServer("RainEnabled", false)
    key2:FireServer("StormEnabled", false)
    key2:FireServer("SnowEnabled", not misc.SnowEnabled.Value)
end)

misc_frame.STORMY.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.STORMY, not misc.StormEnabled.Value)
    toggle(misc_frame.RAIN, false)
    toggle(misc_frame.SNOW, false)
    key2:FireServer("SnowEnabled", false)
    key2:FireServer("RainEnabled", false)
    key2:FireServer("StormEnabled", not misc.StormEnabled.Value)
end)

misc_frame.GRASSVISUALS.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.GRASSVISUALS, not misc.GrassVisuals.Value)
    key2:FireServer("GrassVisuals", not misc.GrassVisuals.Value)
end)

misc_frame.NIGHT.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.NIGHT, not misc.Night.Value)
    key2:FireServer("Night", not misc.Night.Value)
end)

misc_frame.CURVEVISUAL.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.CURVEVISUAL, not misc.CurveVisual.Value)
    key2:FireServer("CurveVisual", not misc.CurveVisual.Value)
end)

misc_frame.CINEMATIC.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.CINEMATIC, not misc.CinematicMode.Value)
    key2:FireServer("CinematicMode", not misc.CinematicMode.Value)
end)

misc_frame.SEASONAL.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.SEASONAL, not misc.Seasonal.Value)
    key2:FireServer("Seasonal", not misc.Seasonal.Value)
end)

misc_frame.CONTRAST.TextBox.FocusLost:Connect(function()
    local _, result = pcall(function()
        return tonumber(misc_frame.CONTRAST.TextBox.Text)
    end)

    if not result then
        misc_frame.CONTRAST.TextBox.Text = "0"
        notification("INVALID INPUT.")

        return
    end

    if result > 1 or result < 0 then
        misc_frame.CONTRAST.TextBox.Text = "0"
        notification("CONTRAST MUST BE BETWEEN 1 AND 0")

        return
    end

    misc.Contrast.Value = misc_frame.CONTRAST.TextBox.Text
    game.Lighting.ColorCorrection.Contrast = misc.Contrast.Value
end)

misc.Contrast.Changed:Connect(function()
    misc_frame.CONTRAST.TextBox.Text = misc.Contrast.Value
    game.Lighting.ColorCorrection.Contrast = misc.Contrast.Value
    key2:FireServer("Contrast", misc.Contrast.Value)
end)

misc_frame.CONTRAST.TextBox.Text = misc.Contrast.Value
game.Lighting.ColorCorrection.Contrast = misc.Contrast.Value

misc_frame.BRIGHTNESS.TextBox.FocusLost:Connect(function()
    local _, result = pcall(function()
        return tonumber(misc_frame.BRIGHTNESS.TextBox.Text)
    end)

    if not result then
        misc_frame.BRIGHTNESS.TextBox.Text = "0"
        notification("INVALID INPUT.")

        return
    end

    if result > 15 or result < 0 then
        misc_frame.BRIGHTNESS.TextBox.Text = "0"
        notification("BRIGHTNESS MUST BE BETWEEN 15 AND 0.")

        return
    end

    misc.Brightness.Value = misc_frame.BRIGHTNESS.TextBox.Text
    game.Lighting.Brightness = misc.Brightness.Value
end)

misc.Brightness.Changed:Connect(function()
    misc_frame.BRIGHTNESS.TextBox.Text = misc.Brightness.Value
    game.Lighting.Brightness = misc.Brightness.Value
    key2:FireServer("Brightness", misc.Brightness.Value)

    for _, descendant_3 in ipairs(game.Workspace.miscFX.NightLights:GetDescendants()) do
        if descendant_3:IsA("Light") then
            descendant_3.Brightness = misc.Brightness.Value * 0.8
        end
    end
end)

misc_frame.BRIGHTNESS.TextBox.Text = misc.Brightness.Value
game.Lighting.Brightness = misc.Brightness.Value

for _, descendant_2 in ipairs(game.Workspace.miscFX.NightLights:GetDescendants()) do
    if descendant_2:IsA("Light") then
        descendant_2.Brightness = misc.Brightness.Value * 0.8
    end
end

misc_frame.NUMBER.TextBox.FocusLost:Connect(function()
    local _, result = pcall(function()
        return tonumber(misc_frame.NUMBER.TextBox.Text)
    end)

    if not result then
        misc_frame.NUMBER.TextBox.Text = "0"
        notification("INVALID INPUT.")

        return
    end

    if result > 99 or result < 0 then
        misc_frame.NUMBER.TextBox.Text = "0"
        notification("JERSEY NUMBERS MUST BE BETWEEN 1 AND 99. USE 0 TO DISABLE.")

        return
    end

    if key10:InvokeServer(misc_frame.NUMBER.TextBox.Text, "Number") == true then
        return
    end

    notification("AN ERROR HAS OCCURRED.")
    misc_frame.NUMBER.TextBox.Text = "0"
end)

misc_frame.SPONSER.TextBox.FocusLost:Connect(function()
    local _, result = pcall(function()
        return tostring(misc_frame.SPONSER.TextBox.Text)
    end)

    if not result then
        misc_frame.SPONSER.TextBox.Text = "0"
        notification("SPONSER ID CANNOT BE NIL. IF YOU WISH FOR IT TO BE NOTHING SET IT TO 0")

        return
    end

    if key10:InvokeServer(misc_frame.SPONSER.TextBox.Text, "Sponser") == true then
        return
    end

    notification("AN ERROR HAS OCCURRED.")
    misc_frame.SPONSER.TextBox.Text = "0"
end)

misc_frame.CURSOR.TextBox.FocusLost:Connect(function()
    local _, result = pcall(function()
        return tostring(misc_frame.CURSOR.TextBox.Text)
    end)

    if not result then
        misc_frame.CURSOR.TextBox.Text = "0"
        notification("CURSOR ID CANNOT BE NIL. IF YOU WISH FOR IT TO BE NOTHING SET IT TO 0")

        return
    end

    if key10:InvokeServer(misc_frame.CURSOR.TextBox.Text, "Cursor") == true then
        return
    end

    notification("AN ERROR HAS OCCURRED.")
    misc_frame.CURSOR.TextBox.Text = "0"
end)

misc.JerseyNumber.Changed:Connect(function()
    misc_frame.NUMBER.TextBox.Text = misc.JerseyNumber.Value
end)

misc.SponserID.Changed:Connect(function()
    misc_frame.SPONSER.TextBox.Text = misc.SponserID.Value
end)

misc.CustomCursor.Changed:Connect(function()
    misc_frame.CURSOR.TextBox.Text = misc.CustomCursor.Value
end)

misc_frame.SPONSER.TextBox.Text = misc.SponserID.Value
misc_frame.NUMBER.TextBox.Text = misc.JerseyNumber.Value

left_frame.SettingsButton.MouseButton1Click:Connect(function()
    if settings_frame.Visible == false then
        game:GetService("TweenService")
            :Create(stats_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 1, 170),
            })
            :Play()

        task.delay(0.35, function()
            stats_frame.Visible = false
        end)

        closeTeamSelect()
        closeModeSelect()
        closeAchievements()
        game:GetService("TweenService")
            :Create(skill_frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 1, 230),
            })
            :Play()

        task.delay(0.35, function()
            skill_frame.Visible = false
        end)
    end

    settings_frame.Visible = not settings_frame.Visible
end)

pick_category_frame.MiscButton.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(pick_category_frame.MiscButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextStrokeTransparency = 0.5,
        })
        :Play()
    game:GetService("TweenService")
        :Create(
            pick_category_frame.ControlsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 1,
            }
        )
        :Play()
    settings_frame.MiscFrame.Visible = true
    settings_frame.ControlsFrame.Visible = false
end)

pick_category_frame.ControlsButton.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(
            pick_category_frame.ControlsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 0.5,
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(pick_category_frame.MiscButton, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextStrokeTransparency = 1,
        })
        :Play()
    settings_frame.ControlsFrame.Visible = true
    settings_frame.MiscFrame.Visible = false
end)

settings_frame.TitleFrame.CancelButton.MouseButton1Click:Connect(function()
    settings_frame.Visible = false
end)

local user_input_service2 = game:GetService("UserInputService")

function getTextForKey(argument)
    return argument == Enum.KeyCode.LeftShift and "LSHIFT"
        or (
            argument == Enum.KeyCode.LeftControl and "LCTRL"
            or (
                argument == Enum.KeyCode.LeftAlt and "L-ALT"
                or (
                    argument == Enum.KeyCode.RightShift and "RSHIFT"
                    or (
                        argument == Enum.KeyCode.RightControl and "RCTRL"
                        or (
                            argument == Enum.KeyCode.RightAlt and "R-ALT"
                            or user_input_service2:GetStringForKeyCode(argument)
                        )
                    )
                )
            )
        )
end

controls_frame.SkillBind.Key.Text = getTextForKey(Enum.KeyCode[controls.Skill.Value])
controls_frame.TackleBind.Key.Text = getTextForKey(Enum.KeyCode[controls.SlideTackle.Value])
controls_frame.ShoveBind.Key.Text = getTextForKey(Enum.KeyCode[controls.Shove.Value])
controls_frame.MarkPassBind.Key.Text = getTextForKey(Enum.KeyCode[controls.MarkPass.Value])
controls_frame.SprintBind.Key.Text = getTextForKey(Enum.KeyCode[controls.Sprint.Value])
controls_frame.EmoteBind.Key.Text = getTextForKey(Enum.KeyCode[controls.Emote.Value])
controls_frame.CurveLeft.Key.Text = getTextForKey(Enum.KeyCode[controls.CurveLeft.Value])
controls_frame.CurveRight.Key.Text = getTextForKey(Enum.KeyCode[controls.CurveRight.Value])
controls_frame.Topspin.Key.Text = getTextForKey(Enum.KeyCode[controls.Topspin.Value])
controls_frame.DribbleLeft.Key.Text = getTextForKey(Enum.KeyCode[controls.DribbleLeft.Value])
controls_frame.DribbleRight.Key.Text = getTextForKey(Enum.KeyCode[controls.DribbleRight.Value])
controls_frame.controlledSprint.Key.Text = getTextForKey(Enum.KeyCode[controls.ControlSprint.Value])
local values_14 = {
    Enum.KeyCode.W,
    Enum.KeyCode.A,
    Enum.KeyCode.S,
    Enum.KeyCode.D,
    Enum.KeyCode.KeypadEnter,
    Enum.KeyCode.Return,
    Enum.KeyCode.Tab,
    Enum.KeyCode.CapsLock,
    Enum.KeyCode.Space,
    Enum.KeyCode.Backspace,
    Enum.KeyCode.BackSlash,
    Enum.KeyCode.LeftControl,
}

function handleBind(argument: userdata, child_name: string)
    argument.Text = ""
    game:GetService("TweenService")
        :Create(settings_frame.BindLabel, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextStrokeTransparency = 0.65,
            TextTransparency = 0,
        })
        :Play()
    local enabled_6 = false
    local connection = nil
    connection = user_input_service2.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then
            return
        end

        if table.find(values_14, input.KeyCode) then
            if
                (
                    input.KeyCode == Enum.KeyCode.W
                    or (
                        input.KeyCode == Enum.KeyCode.D
                        or (input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.S)
                    )
                )
                and (child_name == "CurveLeft" or (child_name == "CurveRight" or child_name == "Topspin"))
            then
                key3:FireServer(child_name, input.KeyCode)
                enabled_6 = true
                connection:Disconnect()
                game:GetService("TweenService")
                    :Create(
                        settings_frame.BindLabel,
                        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {
                            TextStrokeTransparency = 1,
                            TextTransparency = 1,
                        }
                    )
                    :Play()
                argument.Text = getTextForKey(input.KeyCode)

                return
            end

            game:GetService("TweenService")
                :Create(
                    settings_frame.InvalidKeybindLabel,
                    TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {
                        TextStrokeTransparency = 0.65,
                        TextTransparency = 0,
                    }
                )
                :Play()
            local clone_3 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
            clone_3.Parent = game.Workspace
            clone_3:Play()
            game.Debris:AddItem(clone_3, 3)

            task.delay(0.85, function()
                game:GetService("TweenService")
                    :Create(
                        settings_frame.InvalidKeybindLabel,
                        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {
                            TextStrokeTransparency = 1,
                            TextTransparency = 1,
                        }
                    )
                    :Play()
            end)

            return
        end

        key3:FireServer(child_name, input.KeyCode)
        enabled_6 = true
        connection:Disconnect()
        game:GetService("TweenService")
            :Create(settings_frame.BindLabel, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextStrokeTransparency = 1,
                TextTransparency = 1,
            })
            :Play()
        argument.Text = getTextForKey(input.KeyCode)
    end)

    task.delay(4, function()
        if enabled_6 == true then
            return
        end

        argument.Text = getTextForKey(Enum.KeyCode[controls:FindFirstChild(child_name).Value])
        connection:Disconnect()
        game:GetService("TweenService")
            :Create(settings_frame.BindLabel, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextStrokeTransparency = 1,
                TextTransparency = 1,
            })
            :Play()
    end)
end

controls.Skill.Changed:Connect(function()
    controls_frame.SkillBind.Key.Text = getTextForKey(Enum.KeyCode[controls.Skill.Value])
end)

controls.SlideTackle.Changed:Connect(function()
    controls_frame.TackleBind.Key.Text = getTextForKey(Enum.KeyCode[controls.SlideTackle.Value])
end)

controls.Shove.Changed:Connect(function()
    controls_frame.ShoveBind.Key.Text = getTextForKey(Enum.KeyCode[controls.Shove.Value])
end)

controls.MarkPass.Changed:Connect(function()
    controls_frame.MarkPassBind.Key.Text = getTextForKey(Enum.KeyCode[controls.MarkPass.Value])
end)

controls.Sprint.Changed:Connect(function()
    controls_frame.SprintBind.Key.Text = getTextForKey(Enum.KeyCode[controls.Sprint.Value])
end)

controls.Emote.Changed:Connect(function()
    controls_frame.EmoteBind.Key.Text = getTextForKey(Enum.KeyCode[controls.Emote.Value])
end)

controls.CurveLeft.Changed:Connect(function()
    controls_frame.CurveLeft.Key.Text = getTextForKey(Enum.KeyCode[controls.CurveLeft.Value])
end)

controls.CurveRight.Changed:Connect(function()
    controls_frame.CurveRight.Key.Text = getTextForKey(Enum.KeyCode[controls.CurveRight.Value])
end)

controls.Topspin.Changed:Connect(function()
    controls_frame.Topspin.Key.Text = getTextForKey(Enum.KeyCode[controls.Topspin.Value])
end)

controls.DribbleLeft.Changed:Connect(function()
    controls_frame.DribbleLeft.Key.Text = getTextForKey(Enum.KeyCode[controls.DribbleLeft.Value])
end)

controls.DribbleRight.Changed:Connect(function()
    controls_frame.DribbleRight.Key.Text = getTextForKey(Enum.KeyCode[controls.DribbleRight.Value])
end)

controls.ControlSprint.Changed:Connect(function()
    controls_frame.controlledSprint.Key.Text = getTextForKey(Enum.KeyCode[controls.ControlSprint.Value])
end)

controls_frame.SkillBind.Key.MouseButton1Click:Connect(function()
    handleBind(controls_frame.SkillBind.Key, "Skill")
end)

controls_frame.TackleBind.Key.MouseButton1Click:Connect(function()
    handleBind(controls_frame.TackleBind.Key, "SlideTackle")
end)

controls_frame.ShoveBind.Key.MouseButton1Click:Connect(function()
    handleBind(controls_frame.ShoveBind.Key, "Shove")
end)

controls_frame.MarkPassBind.Key.MouseButton1Click:Connect(function()
    handleBind(controls_frame.MarkPassBind.Key, "MarkPass")
end)

controls_frame.SprintBind.Key.MouseButton1Click:Connect(function()
    handleBind(controls_frame.SprintBind.Key, "Sprint")
end)

controls_frame.EmoteBind.Key.MouseButton1Click:Connect(function()
    handleBind(controls_frame.EmoteBind.Key, "Emote")
end)

controls_frame.CurveLeft.Key.MouseButton1Click:Connect(function()
    handleBind(controls_frame.CurveLeft.Key, "CurveLeft")
end)

controls_frame.CurveRight.Key.MouseButton1Click:Connect(function()
    handleBind(controls_frame.CurveRight.Key, "CurveRight")
end)

controls_frame.Topspin.Key.MouseButton1Click:Connect(function()
    handleBind(controls_frame.Topspin.Key, "Topspin")
end)

controls_frame.DribbleLeft.Key.MouseButton1Click:Connect(function()
    handleBind(controls_frame.DribbleLeft.Key, "DribbleLeft")
end)

controls_frame.DribbleRight.Key.MouseButton1Click:Connect(function()
    handleBind(controls_frame.DribbleRight.Key, "DribbleRight")
end)

controls_frame.controlledSprint.Key.MouseButton1Click:Connect(function()
    handleBind(controls_frame.controlledSprint.Key, "ControlSprint")
end)

controls_frame.RELEASE.Toggle.MouseButton1Click:Connect(function()
    toggle(controls_frame.RELEASE, not controls.ReleaseDive.Value)
    key2:FireServer("ReleaseDive", not controls.ReleaseDive.Value)
end)

controls_frame.FLIP.Toggle.MouseButton1Click:Connect(function()
    toggle(controls_frame.FLIP, not controls.Flipped.Value)
    key2:FireServer("Flipped", not controls.Flipped.Value)
end)

controls_frame.ToggleSpin.Toggle.MouseButton1Click:Connect(function()
    toggle(controls_frame.ToggleSpin, not controls.SpinToggle.Value)
    key2:FireServer("SpinToggle", not controls.SpinToggle.Value)
end)

local map = misc_frame.MAP
local map_2 = map.Map
local dropdown_arrow = map_2.DropdownArrow
local dropdown = map.Dropdown

for _, child_2 in pairs(game.ReplicatedStorage.SelectableMaps:GetChildren()) do
    local clone = script.mapButtonTemplate:Clone()
    clone.Text = string.upper(child_2.Name)
    clone.Parent = dropdown

    clone.MouseButton1Click:Connect(function()
        key2:FireServer("MapSelection", child_2.Name)
        map_2.Text = string.upper(child_2.Name)
        dropdown.Visible = false
        dropdown_arrow.Rotation = 180
    end)
end

map_2.Text = string.upper(misc.MapSelection.Value)

map_2.MouseButton1Click:Connect(function()
    if dropdown.Visible == true then
        dropdown.Visible = false
        dropdown_arrow.Rotation = 180

        return
    end

    dropdown_arrow.Rotation = 0
    dropdown.Visible = true
end)

local grass = misc_frame.GRASS
local grass_2 = grass.Grass
local dropdown_arrow2 = grass_2.DropdownArrow
local dropdown2 = grass.Dropdown

for _, child_3 in pairs(game.ReplicatedStorage.SelectableGrass:GetChildren()) do
    local clone_2 = script.mapButtonTemplate:Clone()
    clone_2.Text = string.upper(child_3.Name)
    clone_2.Parent = dropdown2

    clone_2.MouseButton1Click:Connect(function()
        key2:FireServer("GrassSelection", child_3.Name)
        grass_2.Text = string.upper(child_3.Name)
        dropdown2.Visible = false
        dropdown_arrow2.Rotation = 180
    end)
end

grass_2.Text = string.upper(misc.GrassSelection.Value)

grass_2.MouseButton1Click:Connect(function()
    if dropdown2.Visible == true then
        dropdown2.Visible = false
        dropdown_arrow2.Rotation = 180

        return
    end

    dropdown_arrow2.Rotation = 0
    dropdown2.Visible = true
end)

local pov = misc_frame.POV
local pov2 = pov.POV
local dropdown_arrow3 = pov2.DropdownArrow
local dropdown3 = pov.Dropdown

for _, child_4 in pairs(dropdown3:GetChildren()) do
    if child_4:IsA("TextButton") then
        child_4.MouseButton1Click:Connect(function()
            key2:FireServer("POV", child_4.Name)
            pov2.Text = string.upper(child_4.Name)
            dropdown3.Visible = false
            dropdown_arrow3.Rotation = 180
        end)
    end
end

pov2.Text = string.upper(misc.POV.Value)

pov2.MouseButton1Click:Connect(function()
    if dropdown3.Visible == true then
        dropdown3.Visible = false
        dropdown_arrow3.Rotation = 180

        return
    end

    dropdown_arrow3.Rotation = 0
    dropdown3.Visible = true
end)

local store_frame = script.Parent.StoreFrame
local daily_shop_frame = store_frame.DailyShopFrame
local animations_frame = store_frame.AnimationsFrame
local cosmetics_frame = store_frame.CosmeticsFrame
local robux_shop_frame = store_frame.RobuxShopFrame
local pick_category_frame2 = store_frame.PickCategoryFrame
local title_frame = store_frame.TitleFrame
local popup_container = store_frame.PopupContainer

menu_buttons.StoreButton.MouseButton1Click:Connect(function()
    store_frame.Visible = not store_frame.Visible
end)

title_frame.CancelButton.MouseButton1Click:Connect(function()
    store_frame.Visible = false
end)

pick_category_frame2.CosmeticsButton.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(
            pick_category_frame2.CosmeticsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 0.5,
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            pick_category_frame2.AnimationsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 1,
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            pick_category_frame2.DailyShopButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 1,
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            pick_category_frame2.RobuxShopButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 1,
            }
        )
        :Play()
    animations_frame.Visible = false
    cosmetics_frame.Visible = true
    robux_shop_frame.Visible = false
    store_frame.GiftRecipient.Visible = false
    daily_shop_frame.Visible = false
    store_frame.CrateInfo.Visible = true
end)

pick_category_frame2.AnimationsButton.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(
            pick_category_frame2.AnimationsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 0.5,
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            pick_category_frame2.CosmeticsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 1,
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            pick_category_frame2.DailyShopButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 1,
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            pick_category_frame2.RobuxShopButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 1,
            }
        )
        :Play()
    animations_frame.Visible = true
    cosmetics_frame.Visible = false
    robux_shop_frame.Visible = false
    store_frame.GiftRecipient.Visible = false
    daily_shop_frame.Visible = false
    store_frame.CrateInfo.Visible = true
end)

pick_category_frame2.DailyShopButton.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(
            pick_category_frame2.CosmeticsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 1,
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            pick_category_frame2.AnimationsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 1,
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            pick_category_frame2.DailyShopButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 0.5,
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            pick_category_frame2.RobuxShopButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 1,
            }
        )
        :Play()
    animations_frame.Visible = false
    cosmetics_frame.Visible = false
    robux_shop_frame.Visible = false
    store_frame.GiftRecipient.Visible = false
    daily_shop_frame.Visible = true
    store_frame.CrateInfo.Visible = false
end)

pick_category_frame2.RobuxShopButton.MouseButton1Click:Connect(function()
    game:GetService("TweenService")
        :Create(
            pick_category_frame2.CosmeticsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 1,
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            pick_category_frame2.AnimationsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 1,
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            pick_category_frame2.DailyShopButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 1,
            }
        )
        :Play()
    game:GetService("TweenService")
        :Create(
            pick_category_frame2.RobuxShopButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextStrokeTransparency = 0.5,
            }
        )
        :Play()
    animations_frame.Visible = false
    cosmetics_frame.Visible = false
    robux_shop_frame.Visible = true
    store_frame.GiftRecipient.Visible = true
    daily_shop_frame.Visible = false
    store_frame.CrateInfo.Visible = false
end)

function getDailyShop()
    local invoke_server_result = key11:InvokeServer()
    local first_child_2 = item_info:FindFirstChild(invoke_server_result.Legendary)
    daily_shop_frame.Legendary.itemNameVal.Value = first_child_2.Name
    daily_shop_frame.Legendary.itemIcon.Image = first_child_2.itemIcon.Texture
    daily_shop_frame.Legendary.ItemName.Text = string.upper(first_child_2.Name)
    local first_child_3 = item_info:FindFirstChild(invoke_server_result.Epic1)
    daily_shop_frame.Epic1.itemNameVal.Value = first_child_3.Name
    daily_shop_frame.Epic1.itemIcon.Image = first_child_3.itemIcon.Texture
    daily_shop_frame.Epic1.ItemName.Text = string.upper(first_child_3.Name)
    local first_child_4 = item_info:FindFirstChild(invoke_server_result.Epic2)
    daily_shop_frame.Epic2.itemNameVal.Value = first_child_4.Name
    daily_shop_frame.Epic2.itemIcon.Image = first_child_4.itemIcon.Texture
    daily_shop_frame.Epic2.ItemName.Text = string.upper(first_child_4.Name)
    local first_child_5 = item_info:FindFirstChild(invoke_server_result.Rare1)
    daily_shop_frame.Rare1.itemNameVal.Value = first_child_5.Name
    daily_shop_frame.Rare1.itemIcon.Image = first_child_5.itemIcon.Texture
    daily_shop_frame.Rare1.ItemName.Text = string.upper(first_child_5.Name)
    local first_child_6 = item_info:FindFirstChild(invoke_server_result.Rare2)
    daily_shop_frame.Rare2.itemNameVal.Value = first_child_6.Name
    daily_shop_frame.Rare2.itemIcon.Image = first_child_6.itemIcon.Texture
    daily_shop_frame.Rare2.ItemName.Text = string.upper(first_child_6.Name)
    local first_child_7 = item_info:FindFirstChild(invoke_server_result.Rare3)
    daily_shop_frame.Rare3.itemNameVal.Value = first_child_7.Name
    daily_shop_frame.Rare3.itemIcon.Image = first_child_7.itemIcon.Texture
    daily_shop_frame.Rare3.ItemName.Text = string.upper(first_child_7.Name)
end

getDailyShop()
key_handler_service:GetKey("UpdateDailyShop").OnClientEvent:Connect(getDailyShop)
local text_6 = ""

popup_container.YesButton.MouseButton1Click:Connect(function()
    if text_6 == "" then
        return
    end

    local invoke_server_result = key12:InvokeServer(text_6)
    popup_container.Visible = false

    if invoke_server_result == "AlreadyOwned" then
        notification("ITEM ALREADY OWNED.")
    elseif invoke_server_result == "NotEnoughCoins" then
        notification("NOT ENOUGH COINS.")
    elseif invoke_server_result == "Failed" then
        notification("AN UNEXPECTED ERROR HAS OCCURED.")
    else
        local clone_3 = game.ReplicatedStorage.UISounds.mvm_money_pickup:Clone()
        clone_3.Parent = game.Workspace
        clone_3:Play()
        game.Debris:AddItem(clone_3, 3)

        if text_6 ~= "A RANDOM AURA" and (text_6 ~= "A RANDOM EYE" and text_6 ~= "A RANDOM CELEBRATION") then
            local clone_4 = game.ReplicatedStorage.UISounds.Item_Box_Get2:Clone()
            clone_4.Parent = game.Workspace
            clone_4:Play()
            game.Debris:AddItem(clone_4, 3)
        end
    end

    text_6 = ""
end)

popup_container.NoButton.MouseButton1Click:Connect(function()
    if text_6 ~= "" then
        text_6 = ""
        popup_container.Visible = false
    end
end)

function popup(argument, argument_2)
    text_6 = argument
    popup_container.PurchaseText.Text = "WOULD YOU LIKE TO PURCHASE ["
        .. string.upper(text_6)
        .. "] FOR "
        .. argument_2
        .. " COINS?"
    popup_container.Visible = true
end

animations_frame.Barou.Purchase.MouseButton1Click:Connect(function()
    popup("Determined  Striker Animations", "100.0K")
end)

animations_frame.Rin.Purchase.MouseButton1Click:Connect(function()
    popup("Destructive Striker Animations", "100.0K")
end)

animations_frame.Shidou.Purchase.MouseButton1Click:Connect(function()
    popup("Sporadic Striker Animations", "100.0K")
end)

animations_frame.Isagi.Purchase.MouseButton1Click:Connect(function()
    popup("Ordinary Striker Animations", "50.0K")
end)

animations_frame.Bachira.Purchase.MouseButton1Click:Connect(function()
    popup("Freestyle Striker Animations", "100.0K")
end)

animations_frame.Gagamaru.Purchase.MouseButton1Click:Connect(function()
    popup("Athletic Keeper Animations", "80.0K")
end)

animations_frame.Nagi.Purchase.MouseButton1Click:Connect(function()
    popup("Lazy Genius Animations", "80.0K")
end)

animations_frame.PolishStriker.Purchase.MouseButton1Click:Connect(function()
    popup("Polish Striker Animations", "100.0K")
end)

animations_frame.BrazillianWizard.Purchase.MouseButton1Click:Connect(function()
    popup("Brazillian Wizard Animations", "100.0K")
end)

animations_frame.ArgentinaKeeper.Purchase.MouseButton1Click:Connect(function()
    popup("Argentina Keeper Animations", "75.0K")
end)

daily_shop_frame.Legendary.Purchase.MouseButton1Click:Connect(function()
    popup(daily_shop_frame.Legendary.itemNameVal.Value, "50.0K")
end)

daily_shop_frame.Epic1.Purchase.MouseButton1Click:Connect(function()
    popup(daily_shop_frame.Epic1.itemNameVal.Value, "20.0K")
end)

daily_shop_frame.Epic2.Purchase.MouseButton1Click:Connect(function()
    popup(daily_shop_frame.Epic2.itemNameVal.Value, "20.0K")
end)

daily_shop_frame.Rare1.Purchase.MouseButton1Click:Connect(function()
    popup(daily_shop_frame.Rare1.itemNameVal.Value, "5.0K")
end)

daily_shop_frame.Rare2.Purchase.MouseButton1Click:Connect(function()
    popup(daily_shop_frame.Rare2.itemNameVal.Value, "5.0K")
end)

daily_shop_frame.Rare3.Purchase.MouseButton1Click:Connect(function()
    popup(daily_shop_frame.Rare3.itemNameVal.Value, "5.0K")
end)

cosmetics_frame.ScoreAuras.Purchase.MouseButton1Click:Connect(function()
    popup("A RANDOM AURA", "3.0K")
end)

cosmetics_frame.MVPEyes.Purchase.MouseButton1Click:Connect(function()
    popup("A RANDOM EYE", "3.0K")
end)

cosmetics_frame.Celebrations.Purchase.MouseButton1Click:Connect(function()
    popup("A RANDOM CELEBRATION", "3.0K")
end)

cosmetics_frame.GoalieGloves.Purchase.MouseButton1Click:Connect(function()
    popup("A RANDOM GLOVE", "3.0K")
end)

key4.OnClientEvent:Connect(function()
    local clone_3 = game.ReplicatedStorage.UISounds.mvm_money_pickup:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    local clone_4 = game.ReplicatedStorage.UISounds.Item_Box_Get2:Clone()
    clone_4.Parent = game.Workspace
    clone_4:Play()
    game.Debris:AddItem(clone_4, 3)
end)

store_frame.GiftRecipient.FocusLost:Connect(function()
    local text_7 = store_frame.GiftRecipient.Text

    for _, player in pairs(game.Players:GetPlayers()) do
        if string.sub(player.Name, 0, #text_7) == text_7 then
            store_frame.GiftRecipient.Text = player.Name

            return
        end
    end

    store_frame.GiftRecipient.Text = ""
end)

robux_shop_frame.Coins1.Purchase.MouseButton1Click:Connect(function()
    key4:FireServer("Coin1", store_frame.GiftRecipient.Text)
end)

robux_shop_frame["Jersey Sponsers"].Purchase.MouseButton1Click:Connect(function()
    key4:FireServer("Jersery Sponsers", store_frame.GiftRecipient.Text)
end)

robux_shop_frame.Coins2.Purchase.MouseButton1Click:Connect(function()
    key4:FireServer("Coin2", store_frame.GiftRecipient.Text)
end)

robux_shop_frame.Coins3.Purchase.MouseButton1Click:Connect(function()
    key4:FireServer("Coin3", store_frame.GiftRecipient.Text)
end)

robux_shop_frame.Coins4.Purchase.MouseButton1Click:Connect(function()
    key4:FireServer("Coin4", store_frame.GiftRecipient.Text)
end)

robux_shop_frame.SkipRolls.Purchase.MouseButton1Click:Connect(function()
    key4:FireServer("skipRolls", store_frame.GiftRecipient.Text)
end)

robux_shop_frame.FilmMaker.Purchase.MouseButton1Click:Connect(function()
    key4:FireServer("filmMaker", store_frame.GiftRecipient.Text)
end)

robux_shop_frame.PreferredJerseyNumber.Purchase.MouseButton1Click:Connect(function()
    key4:FireServer("prefNumber", store_frame.GiftRecipient.Text)
end)

robux_shop_frame.AccessoryColor.Purchase.MouseButton1Click:Connect(function()
    key4:FireServer("customAccessoryColor", store_frame.GiftRecipient.Text)
end)

robux_shop_frame.PSPlus.Purchase.MouseButton1Click:Connect(function()
    key4:FireServer("PS+", store_frame.GiftRecipient.Text)
end)

local codes_frame = script.Parent.CodesFrame

left_frame.CodesButton.MouseButton1Click:Connect(function()
    codes_frame.Visible = not codes_frame.Visible
end)

codes_frame.CancelButton.MouseButton1Click:Connect(function()
    codes_frame.Visible = false
end)

local code_box = codes_frame.CodeBox

function showMessage(placeholder_text)
    code_box.PlaceholderText = placeholder_text

    task.delay(1, function()
        code_box.PlaceholderText = "ENTER CODE"
    end)
end

local enabled_4 = false

code_box.FocusLost:Connect(function()
    if not (#code_box.Text > 0 and enabled_4 == false) then
        return
    end

    enabled_4 = true

    task.delay(0.5, function()
        enabled_4 = false
    end)

    local invoke_server_result = key13:InvokeServer(code_box.Text)
    code_box.Text = ""

    if invoke_server_result == "codeExpired" then
        showMessage("CODE HAS EXPIRED.")
        local clone_3 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
        clone_3.Parent = game.Workspace
        clone_3:Play()
        game.Debris:AddItem(clone_3, 3)

        return
    end

    if invoke_server_result == "codeSubmitted" then
        showMessage("CODE SUBMITTED. ENJOY!")
        local clone_4 = game.ReplicatedStorage.UISounds.mvm_money_pickup:Clone()
        clone_4.Parent = game.Workspace
        clone_4:Play()
        game.Debris:AddItem(clone_4, 3)

        return
    end

    if invoke_server_result == "codeInUse" then
        showMessage("CODE HAS ALREADY BEEN USED.")
        local clone_5 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
        clone_5.Parent = game.Workspace
        clone_5:Play()
        game.Debris:AddItem(clone_5, 3)

        return
    end

    if invoke_server_result == "promptGroup" then
        showMessage("JOIN THE GROUP TO USE CODES!!")
        local clone_6 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
        clone_6.Parent = game.Workspace
        clone_6:Play()
        game.Debris:AddItem(clone_6, 3)
        game.GroupService:PromptJoinAsync(33283788)

        return
    end

    showMessage("CODE NOT FOUND.")
    local clone_7 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
    clone_7.Parent = game.Workspace
    clone_7:Play()
    game.Debris:AddItem(clone_7, 3)
end)

local function check_is_weekend()
    local wday_2 = os.date("!*t").wday

    return wday_2 == 1 or (wday_2 == 6 or wday_2 == 7)
end

local wday = os.date("!*t").wday

if wday == 1 or (wday == 6 or wday == 7) then
    script.Parent["2xcoins"].Visible = true
else
    script.Parent["2xcoins"].Visible = false
end

task.spawn(function()
    while wait(30) do
        local wday2 = os.date("!*t").wday

        if wday2 == 1 or (wday2 == 6 or wday2 == 7) then
            script.Parent["2xcoins"].Visible = true
        else
            script.Parent["2xcoins"].Visible = false
        end
    end
end)

left_frame.HelpButton.MouseButton1Click:Connect(function()
    script.Parent.HelpFrame.Visible = not script.Parent.HelpFrame.Visible
end)

left_frame.UpdateLogButton.MouseButton1Click:Connect(function()
    script.Parent.UpdateLog.Visible = not script.Parent.UpdateLog.Visible
end)
