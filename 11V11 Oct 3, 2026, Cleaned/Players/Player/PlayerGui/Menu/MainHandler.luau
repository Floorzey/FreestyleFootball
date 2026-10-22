local menu_buttons = script.Parent.MenuButtons
local left_frame = script.Parent.LeftFrame
local play_button = script.Parent.PlayButton
local pos_select_frame = script.Parent.PosSelectFrame
local team_select_frame = script.Parent.TeamSelectFrame
local skill_frame = script.Parent.SkillFrame
local notification_label = script.Parent.NotificationLabel
local stats_frame = script.Parent.StatsFrame
local holder = script.Parent.Coins.Holder
local holder_2 = script.Parent.EXP.Holder
local customization_frame = script.Parent.CustomizationFrame
local color_selector = customization_frame.ColorSelector
local local_player = game.Players.LocalPlayer
local values = {}
values.N0tRady = true
values.AnhTuanPro123456 = true
values.rolevote = true
values.Magikk3333 = true
values.FluffyAstral = true
values.supermanjack2419 = true
values.max2847621 = true
values.Flxtraw = true
values["101extreme566"] = true
values.DaytonHD1 = true
values.denfertt = true
values.PatrickPepe_alt2 = true
values.zambrotta_z = true
values.ska5te = true
values.PAPAPATRATATA6 = true
values.noobieman_official = true
values.kaitoudono = true
local values_2 = {}
values_2.Argentina = "rbxassetid://8131230537"
values_2.Brazil = "rbxassetid://11705710978"
values_2.Germany = "rbxassetid://8120346775"
values_2.France = "rbxassetid://13539436075"
values_2.England = "rbxassetid://4807448"
values_2.Scotland = "rbxassetid://12261193582"
values_2.Wales = "rbxassetid://4460818460"
values_2.Spain = "rbxassetid://13397364163"
values_2.USA = "rbxassetid://60169251"
values_2.Japan = "rbxassetid://8131128121"
values_2.Italy = "rbxassetid://11919934085"
values_2.Croatia = "rbxassetid://12220234274"
values_2.Morocco = "rbxassetid://12598544754"
values_2.Canada = "rbxassetid://12300382903"
values_2.Portugal = "rbxassetid://13707539058"
values_2.Mexico = "rbxassetid://713432113"
values_2.Netherlands = "rbxassetid://198692974"
values_2[""] = "rbxassetid://10201001615"
repeat
    task.wait()
until local_player:FindFirstChild("dataLoaded")
repeat
    repeat
        task.wait()
    until game.ReplicatedStorage.TeamInfo.CurrentAwayTeam.Value ~= ""
until game.ReplicatedStorage.TeamInfo.CurrentHomeTeam.Value ~= ""
local accomplishments = stats_frame.PickCategoryFrame.Accomplishments
local personal_stats = stats_frame.PickCategoryFrame.PersonalStats
local personal_stats_frame = stats_frame.PersonalStatsFrame
require(game.ReplicatedStorage.Modules.client)
accomplishments.MouseButton1Click:Connect(function()
    local tween_properties = { TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(accomplishments, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties)
        :Play()
    local tween_properties_2 = { TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(
            personal_stats,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_2
        )
        :Play()
    stats_frame.LeftFrame.Visible = true
    stats_frame.SelectionFrame.Visible = true
    personal_stats_frame.Visible = false
end)
personal_stats.MouseButton1Click:Connect(function()
    local tween_properties = { TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(personal_stats, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tween_properties)
        :Play()
    local tween_properties_2 = { TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(
            accomplishments,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_2
        )
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
local values_3 = { "DRB", "SHO", "OFF", "DEF", "SPD", "PAS" }

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
    local items = {}
    for _, item in pairs(argument) do
        table.insert(items, item)
    end
    table.sort(items)
    if #items % 2 ~= 0 then
        return items[math.ceil(#items / 2)]
    end
    return (items[#items / 2] + items[(#items / 2) + 1]) / 2
end

local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key_handler_service = knit.GetService("KeyHandlerService")
local remote_event = key_handler_service:GetKey("EquipCosmetic")
local remote_event_2 = key_handler_service:GetKey("UpdateSetting")
local remote_event_3 = key_handler_service:GetKey("UpdateInputSetting")
local remote_event_4 = key_handler_service:GetKey("RobuxPurchase")
local remote_function = key_handler_service:GetKey("getAttributePoints")
local remote_function_2 = key_handler_service:GetKey("getPosStats")
local remote_function_3 = key_handler_service:GetKey("SelectSkill")
local remote_function_4 = key_handler_service:GetKey("BuyCheck")
local remote_function_5 = key_handler_service:GetKey("SelectPosition")
local remote_function_6 = key_handler_service:GetKey("updateJerseyNumber")
local remote_function_7 = key_handler_service:GetKey("getDailyShop")
local remote_function_8 = key_handler_service:GetKey("Purchase")
local remote_function_9 = key_handler_service:GetKey("EnterCode")

local function draw_line(argument, argument_2, argument_3)
    local sqrt_result = math.sqrt(math.pow(argument.X - argument_2.X, 2) + math.pow(argument.Y - argument_2.Y, 2))
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
    local ui_corner = Instance.new("UICorner")
    ui_corner.CornerRadius = UDim.new(0.5, 0)
    ui_corner.Parent = frame
    return frame
end

function drawStatBackground()
    for n = 1, 6 do
        local radians = math.rad(((n * 360) / 6) + 30)
        local radians_offset = radians - 1.0471975511965976
        local vector_offset = vector + Vector2.new(math.sin(radians_offset) * 1, math.cos(radians_offset) * 1) * 105
        local vector_offset_2 = vector + Vector2.new(math.sin(radians) * 1, math.cos(radians) * 1) * 105
        local result = draw_line(vector, vector_offset, 2)
        result.BorderSizePixel = 0
        result.ZIndex = 4
        result.Parent = stat_spread
        result.BackgroundColor3 = Color3.new(0.509804, 0.509804, 0.509804)
        result.Name = "Background"
        local result_2 = draw_line(vector_offset, vector_offset_2, 2)
        result_2.BorderSizePixel = 0
        result_2.ZIndex = 4
        result_2.Parent = stat_spread
        result_2.BackgroundColor3 = Color3.new(0.509804, 0.509804, 0.509804)
        result_2.Name = "Background"
    end
end

function comma_value(argument)
    local argument_2 = argument
    local value_5
    repeat
        local replaced_text
        replaced_text, value_5 = string.gsub(argument_2, "^(-?%d+)(%d%d%d)", "%1,%2")
        argument_2 = replaced_text
    until value_5 == 0
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

function getPlayerValue()
    local invoke_server_result = remote_function:InvokeServer("Overall")
    local items = {}
    for _, computed_value_offset in pairs(invoke_server_result.STR) do
        table.insert(items, pointsLogorithmicToRating(computed_value_offset))
    end
    local get_median_result = getMedian(items)
    local items_2 = {}
    for _, computed_value_offset_2 in pairs(invoke_server_result.MID) do
        table.insert(items_2, pointsLogorithmicToRating(computed_value_offset_2))
    end
    local get_median_result_2 = getMedian(items_2)
    local items_3 = {}
    for _, computed_value_offset_3 in pairs(invoke_server_result.DEF) do
        table.insert(items_3, pointsLogorithmicToRating(computed_value_offset_3))
    end
    local get_median_result_3 = getMedian(items_3)
    local items_4 = {}
    for _, computed_value_offset_4 in pairs(invoke_server_result.KPR) do
        table.insert(items_4, pointsLogorithmicToRating(computed_value_offset_4))
    end
    local values_13 = { get_median_result, get_median_result_2, get_median_result_3, getMedian(items_4) }
    local number = 0
    for _, item in ipairs(values_13) do
        if number < item then
            number = item
        end
    end
    local get_rank_result = getRank(number)
    values_13 = 1
    if get_rank_result == "D" then
        values_13 = 4
    elseif get_rank_result == "C" then
        values_13 = 12
    elseif get_rank_result == "B" then
        values_13 = 36
    elseif get_rank_result == "A" then
        values_13 = 108
    elseif get_rank_result == "S" then
        values_13 = 216
    elseif get_rank_result == "SS" then
        values_13 = 324
    end
    return "$"
        .. comma_value(
            math.floor(
                (
                    (
                        (
                            (
                                (0 + ((local_player.Data.Wins.Value * 100) * values_13))
                                + ((local_player.Data.Goals.Value * 50) * values_13)
                            ) + ((local_player.Data.Assists.Value * 40) * values_13)
                        ) + ((local_player.Data.Passes.Value * 20) * values_13)
                    ) + ((local_player.Data.Tackles.Value * 25) * values_13)
                ) + ((local_player.Data.Saves.Value * 75) * values_13)
            )
        )
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

local radar_frame = personal_stats_frame.RadarFrame
local left_frame_2 = personal_stats_frame.LeftFrame
left_frame_2.plrName.Text = string.upper(local_player.DisplayName)
left_frame_2.plrIcon.Image =
    game.Players:GetUserThumbnailAsync(local_player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
left_frame_2.Origin.Image = values_2[local_player.Data.Origin.Value]
local_player.Data.Origin.Changed:Connect(function()
    left_frame_2.Origin.Image = values_2[local_player.Data.Origin.Value]
end)
local selection_frame = personal_stats_frame.SelectionFrame
local text = "STR"

local function draw2d_triangle(argument, argument_2, argument_3, parent, argument_4, argument_5)
    local argument_offset = argument_2 - argument
    local argument_offset_2 = argument_3 - argument
    local argument_offset_3 = argument_3 - argument_2
    local dot_product = argument_offset:Dot(argument_offset)
    local dot_product_2 = argument_offset_2:Dot(argument_offset_2)
    local dot_product_3 = argument_offset_3:Dot(argument_offset_3)
    if (dot_product_2 < dot_product) and (dot_product_3 < dot_product) then
        argument, argument_3 = argument_3, argument
    elseif dot_product_3 < dot_product_2 and dot_product < dot_product_2 then
        argument_2, argument = argument, argument_2
    end
    local argument_offset_4 = argument_2 - argument
    local unit = (argument_3 - argument_2).unit
    local cross_product = unit:Cross(argument_offset_4)
    local is_cross_product = cross_product >= 0
    local degrees = math.deg(math.atan2(unit.y, unit.x))
    local number
    if is_cross_product then
        number = 0
    else
        number = 180
    end
    local rotation = degrees + number
    local argument_offset_offset = (argument + argument_2) / 2
    local argument_offset_offset_2 = (argument + argument_3) / 2
    local parent_2 = argument_4 or (image_label:Clone())
    parent_2.Image = (is_cross_product and "rbxassetid://15444411230") or "rbxassetid://15444410184"
    parent_2.AnchorPoint = vector_2
    parent_2.Size = UDim2.new(0, math.abs(unit:Dot(argument_offset_4)), 0, cross_product)
    parent_2.Position = UDim2.new(0, argument_offset_offset.x, 0, argument_offset_offset.y)
    parent_2.Rotation = rotation
    parent_2.Parent = parent
    local parent_3 = argument_5 or (image_label:Clone())
    parent_3.Image = (is_cross_product and "rbxassetid://15444410184") or "rbxassetid://15444411230"
    parent_3.AnchorPoint = vector_2
    parent_3.Size = UDim2.new(0, math.abs(unit:Dot(argument_3 - argument)), 0, cross_product)
    parent_3.Position = UDim2.new(0, argument_offset_offset_2.x, 0, argument_offset_offset_2.y)
    parent_3.Rotation = rotation
    parent_3.Parent = parent
    local ui_gradient = Instance.new("UIGradient")
    ui_gradient.Transparency =
        NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 1) })
    ui_gradient.Parent = is_cross_product and parent_2 or parent_3
    local ui_gradient_2 = Instance.new("UIGradient")
    ui_gradient_2.Transparency =
        NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.4) })
    ui_gradient_2.Parent = is_cross_product and parent_3 or parent_2
    return parent_2, parent_3
end

function updateStatSpread(argument)
    text = argument
    local invoke_server_result = remote_function:InvokeServer(argument)
    if text ~= argument then
        return
    end
    local values_13
    if argument ~= "KPR" then
        local values_14 = {
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
        left_frame_2.DRB.Text = "DRB"
        left_frame_2.SHO.Text = "SHO"
        left_frame_2.OFF.Text = "OFF"
        left_frame_2.DEF.Text = "DEF"
        left_frame_2.SPD.Text = "SPD"
        left_frame_2.PAS.Text = "PAS"
        values_13 = values_14
    else
        local values_15 = {
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
        left_frame_2.DRB.Text = "DIV"
        left_frame_2.SHO.Text = "HAN"
        left_frame_2.OFF.Text = "KIC"
        left_frame_2.DEF.Text = "REF"
        left_frame_2.SPD.Text = "SPD"
        left_frame_2.PAS.Text = "POS"
        values_13 = values_15
    end
    left_frame_2.Pos.Text = ((argument == "Overall") and "OVERALL")
        or (
            ((argument == "STR") and "FWD")
            or (((argument == "MID") and "MD") or (((argument == "DEF") and "DE") or ((argument == "KPR") and "GK")))
        )
    for _, child in pairs(stat_spread:GetChildren()) do
        if child:IsA("ImageLabel") or child:IsA("Frame") and child.Name ~= "Background" then
            child:Destroy()
        end
    end
    local items = {}
    for key, _ in pairs(values_13) do
        local text_6 = pointsLogorithmicToRating(values_13[key])
        table.insert(items, text_6)
        local value_entry = values_3[key] or values_3[#values_3]
        local points_logorithmic_to_rating_result =
            pointsLogorithmicToRating(values_13[key - 1] or values_13[#values_13])
        local radians = math.rad(((key * 360) / 6) + 30)
        local radians_offset = radians - 1.0471975511965976
        local vector_offset = vector
            + Vector2.new(math.sin(radians_offset), math.cos(radians_offset))
                * ((105 * points_logorithmic_to_rating_result) / 100)
        local vector_offset_2 = vector + Vector2.new(math.sin(radians), math.cos(radians)) * ((105 * text_6) / 100)
        local result = draw_line(vector, vector_offset, 2)
        result.BorderSizePixel = 0
        result.ZIndex = 5
        result.Parent = stat_spread
        result.BackgroundColor3 = Color3.new(0.666667, 1, 1)
        result.BackgroundTransparency = 0.5
        result.Name = "LineLength " .. (105 * text_6) / 100
        left_frame_2[value_entry].Amount.Text = text_6
        personal_stats_frame.RadarFrame:FindFirstChild(value_entry .. "Rating").Text = text_6
        local first_child = personal_stats_frame.RadarFrame:FindFirstChild(value_entry .. "Rank")
        first_child.Text = getRank(text_6)
        local result_2 = draw_line(vector_offset, vector_offset_2, 3)
        result_2.BorderSizePixel = 0
        result_2.ZIndex = 5
        result_2.Parent = stat_spread
        result_2.BackgroundColor3 = Color3.new(0.666667, 1, 1)
        result_2.BackgroundTransparency = 0.5
        local result_3, value_5 = draw2d_triangle(vector, vector_offset, vector_offset_2, stat_spread)
        result_3.ImageColor3 = Color3.new(0.666667, 1, 1)
        value_5.ImageColor3 = Color3.new(0.666667, 1, 1)
        result_3.ZIndex = 4
        value_5.ZIndex = 4
        result_3.ImageTransparency = 0.75
        value_5.ImageTransparency = 0.75
    end
    local get_median_result = getMedian(items)
    left_frame_2.OverallRating.Text = math.floor(get_median_result)
    left_frame_2.OverallRating.OverallRank.Text = getRank(math.floor(get_median_result))
end

updateStatSpread("STR")
drawStatBackground()
selection_frame.STRButton.MouseButton1Click:Connect(function()
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.TextStrokeColor3 = Color3.new(1, 1, 1)
    tween_service:Create(selection_frame.STRButton, tween_info, tween_properties):Play()
    for _, child in pairs(selection_frame:GetChildren()) do
        if not (child:IsA("TextButton")) then
            continue
        end
        if child ~= selection_frame.STRButton then
            local tween_service_2 = game:GetService("TweenService")
            local tween_info_2 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_2 = {}
            tween_properties_2.TextStrokeColor3 = Color3.new(0, 0, 0)
            tween_service_2:Create(child, tween_info_2, tween_properties_2):Play()
        end
    end
    local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    updateStatSpread("STR")
end)
selection_frame.MIDButton.MouseButton1Click:Connect(function()
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.TextStrokeColor3 = Color3.new(1, 1, 1)
    tween_service:Create(selection_frame.MIDButton, tween_info, tween_properties):Play()
    for _, child in pairs(selection_frame:GetChildren()) do
        if not (child:IsA("TextButton")) then
            continue
        end
        if child ~= selection_frame.MIDButton then
            local tween_service_2 = game:GetService("TweenService")
            local tween_info_2 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_2 = {}
            tween_properties_2.TextStrokeColor3 = Color3.new(0, 0, 0)
            tween_service_2:Create(child, tween_info_2, tween_properties_2):Play()
        end
    end
    local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    updateStatSpread("MID")
end)
selection_frame.DEFButton.MouseButton1Click:Connect(function()
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.TextStrokeColor3 = Color3.new(1, 1, 1)
    tween_service:Create(selection_frame.DEFButton, tween_info, tween_properties):Play()
    for _, child in pairs(selection_frame:GetChildren()) do
        if not (child:IsA("TextButton")) then
            continue
        end
        if child ~= selection_frame.DEFButton then
            local tween_service_2 = game:GetService("TweenService")
            local tween_info_2 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_2 = {}
            tween_properties_2.TextStrokeColor3 = Color3.new(0, 0, 0)
            tween_service_2:Create(child, tween_info_2, tween_properties_2):Play()
        end
    end
    local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    updateStatSpread("DEF")
end)
selection_frame.KPRButton.MouseButton1Click:Connect(function()
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.TextStrokeColor3 = Color3.new(1, 1, 1)
    tween_service:Create(selection_frame.KPRButton, tween_info, tween_properties):Play()
    for _, child in pairs(selection_frame:GetChildren()) do
        if not (child:IsA("TextButton")) then
            continue
        end
        if child ~= selection_frame.KPRButton then
            local tween_service_2 = game:GetService("TweenService")
            local tween_info_2 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_2 = {}
            tween_properties_2.TextStrokeColor3 = Color3.new(0, 0, 0)
            tween_service_2:Create(child, tween_info_2, tween_properties_2):Play()
        end
    end
    local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    updateStatSpread("KPR")
end)
local left_frame_3 = stats_frame.LeftFrame
left_frame_3.plrName.Text = string.upper(local_player.DisplayName)
left_frame_3.plrIcon.Image =
    game.Players:GetUserThumbnailAsync(local_player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)

function setStatsForSelection(argument)
    if argument ~= "Overall" then
        local invoke_server_result = remote_function_2:InvokeServer(argument)
        left_frame_3.WINS.Amount.Text = invoke_server_result.Wins
        left_frame_3.LOSSES.Amount.Text = invoke_server_result.Losses
        left_frame_3.GOALS.Amount.Text = invoke_server_result.Goals
        left_frame_3.ASSISTS.Amount.Text = invoke_server_result.Assists
        left_frame_3.PASSES.Amount.Text = invoke_server_result.Passes
        left_frame_3.TACKLES.Amount.Text = invoke_server_result.Tackles
        left_frame_3.SAVES.Amount.Text = invoke_server_result.Saves
        left_frame_3.OOB.Amount.Text = invoke_server_result.OOB
    else
        left_frame_3.WINS.Amount.Text = local_player.Data.Wins.Value
        left_frame_3.LOSSES.Amount.Text = local_player.Data.Losses.Value
        left_frame_3.GOALS.Amount.Text = local_player.Data.Goals.Value
        left_frame_3.ASSISTS.Amount.Text = local_player.Data.Assists.Value
        left_frame_3.PASSES.Amount.Text = local_player.Data.Passes.Value
        left_frame_3.TACKLES.Amount.Text = local_player.Data.Tackles.Value
        left_frame_3.SAVES.Amount.Text = local_player.Data.Saves.Value
        left_frame_3.OOB.Amount.Text = local_player.Data.Penalties.Value
    end
end

stats_frame.SelectionFrame.STRButton.MouseButton1Click:Connect(function()
    local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    left_frame_3.posLabel.Text = "FORWARD"
    setStatsForSelection("STR")
end)
stats_frame.SelectionFrame.MIDButton.MouseButton1Click:Connect(function()
    local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    left_frame_3.posLabel.Text = "MIDFIELDER"
    setStatsForSelection("MID")
end)
stats_frame.SelectionFrame.DEFButton.MouseButton1Click:Connect(function()
    local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    left_frame_3.posLabel.Text = "DEFENDER"
    setStatsForSelection("DEF")
end)
stats_frame.SelectionFrame.KPRButton.MouseButton1Click:Connect(function()
    local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    left_frame_3.posLabel.Text = "GOALKEEPER"
    setStatsForSelection("KPR")
end)
stats_frame.SelectionFrame.OVRButton.MouseButton1Click:Connect(function()
    local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    left_frame_3.posLabel.Text = "OVERALL"
    setStatsForSelection("Overall")
end)
setStatsForSelection("Overall")
local_player.Data.EXP.Changed:Connect(function()
    holder_2.Bar.Bar.Size = UDim2.new(local_player.Data.EXP.Value / (local_player.Data.Level.Value * 500), 0, 1, 0)
end)
local_player.Data.Level.Changed:Connect(function()
    holder_2.Level.Text = local_player.Data.Level.Value
end)
holder_2.Bar.Bar.Size = UDim2.new(local_player.Data.EXP.Value / (local_player.Data.Level.Value * 500), 0, 1, 0)
holder_2.Level.Text = local_player.Data.Level.Value
local_player.Data.Coins.Changed:Connect(function()
    holder.Amount.Text = local_player.Data.Coins.Value
end)
holder.Amount.Text = local_player.Data.Coins.Value

function notification(text_6)
    local clone_3 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
    clone_3.Parent = game.Workspace
    clone_3:Play()
    game.Debris:AddItem(clone_3, 3)
    notification_label.Text = text_6
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

local text_2 = "Field"

function setupSkillsFrame(argument)
    text_2 = argument
    for _, child in pairs(skill_frame.SkillList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    local items = {}
    for _, child_2 in pairs(game.ReplicatedStorage.SkillInfo:GetChildren()) do
        if
            (argument ~= "Goalie" or child_2:FindFirstChild("Goalie"))
            and (argument ~= "Field" or not (child_2:FindFirstChild("Goalie")))
            and child_2:IsA("Folder")
            and (not (child_2:FindFirstChild("DevSpec")) or values[local_player.Name])
        then
            table.insert(items, { Level = child_2.Level.Value, skillName = child_2.Name })
        end
    end
    table.sort(items, function(argument_2, argument_3)
        return argument_2.Level < argument_3.Level
    end)
    for _, item in pairs(items) do
        local first_child = game.ReplicatedStorage.SkillInfo:FindFirstChild(item.skillName)
        if not first_child then
            continue
        end
        local enabled_6 = false
        local clone_3 = script.skillTemplate:Clone()
        clone_3.Parent = skill_frame.SkillList
        clone_3.Text = string.upper(first_child.Name)
        clone_3.skillIcon.Image = first_child:FindFirstChild("skillIcon").Value
        clone_3.Type.Value = first_child.Type.Value
        if
            first_child.Name == local_player.Data.SelectedSkill.Value
            or first_child.Name == local_player.Data.GoalieSkill.Value
        then
            clone_3.UIStroke.Color = Color3.new(1, 1, 1)
        end
        if not (local_player.Data.Level.Value < first_child.Level.Value) then
            local connection = clone_3.MouseButton1Click:Connect(function()
                if enabled_6 ~= true then
                    local tween_service = game:GetService("TweenService")
                    local tween_info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local tween_properties = {}
                    tween_properties.Color = Color3.new(1, 1, 1)
                    tween_service:Create(clone_3.UIStroke, tween_info, tween_properties):Play()
                    for _, child_3 in pairs(skill_frame.SkillList:GetChildren()) do
                        if not (child_3:IsA("TextButton")) then
                            continue
                        end
                        if child_3 ~= clone_3 then
                            local tween_service_2 = game:GetService("TweenService")
                            local tween_info_2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                            local tween_properties_2 = {}
                            tween_properties_2.Color = Color3.fromRGB(108, 115, 122)
                            tween_service_2:Create(child_3.UIStroke, tween_info_2, tween_properties_2):Play()
                        end
                    end
                    local right_frame_5 = skill_frame.RightFrame
                    right_frame_5.skillIcon.Image = first_child.skillIcon.Value
                    right_frame_5.skillName.Text = string.upper(first_child.Name)
                    right_frame_5.skillDescription.Text = first_child.Description.Value
                    right_frame_5.skillType.Text = string.upper(first_child.Type.Value) .. " TYPE"
                    if
                        first_child.Name ~= local_player.Data.SelectedSkill.Value
                        and first_child.Name ~= local_player.Data.GoalieSkill.Value
                    then
                        right_frame_5.selectButton.Text = "SELECT"
                    else
                        right_frame_5.selectButton.Text = "SELECTED"
                    end
                else
                    local clone_7 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
                    clone_7.Parent = game.Workspace
                    clone_7:Play()
                    game.Debris:AddItem(clone_7, 3)
                    task.spawn(function()
                        local tween_properties_3 = { Rotation = 45 }
                        game:GetService("TweenService")
                            :Create(
                                clone_3.Locked,
                                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                tween_properties_3
                            )
                            :Play()
                        task.wait(0.1)
                        local tween_properties_4 = { Rotation = -45 }
                        game:GetService("TweenService")
                            :Create(
                                clone_3.Locked,
                                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                tween_properties_4
                            )
                            :Play()
                        task.wait(0.1)
                        local tween_properties_5 = { Rotation = 0 }
                        game:GetService("TweenService")
                            :Create(
                                clone_3.Locked,
                                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                tween_properties_5
                            )
                            :Play()
                    end)
                end
            end)
            clone_3.Destroying:Once(function()
                connection:Disconnect()
            end)
            continue
        end
        local no_level_requirement = game.ReplicatedStorage:FindFirstChild("noLevelRequirement")
        if not no_level_requirement then
            local enabled_7 = true
            clone_3.Locked.Visible = true
            clone_3.LockedBG.Visible = true
            clone_3.LevelReq.Visible = true
            clone_3.LevelReq.Text = "LEVEL " .. first_child.Level.Value
            enabled_6 = enabled_7
        end
        local connection_2 = clone_3.MouseButton1Click:Connect(function()
            if enabled_6 ~= true then
                local tween_service = game:GetService("TweenService")
                local tween_info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tween_properties = {}
                tween_properties.Color = Color3.new(1, 1, 1)
                tween_service:Create(clone_3.UIStroke, tween_info, tween_properties):Play()
                for _, child_3 in pairs(skill_frame.SkillList:GetChildren()) do
                    if not (child_3:IsA("TextButton")) then
                        continue
                    end
                    if child_3 ~= clone_3 then
                        local tween_service_2 = game:GetService("TweenService")
                        local tween_info_2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        local tween_properties_2 = {}
                        tween_properties_2.Color = Color3.fromRGB(108, 115, 122)
                        tween_service_2:Create(child_3.UIStroke, tween_info_2, tween_properties_2):Play()
                    end
                end
                local right_frame_5 = skill_frame.RightFrame
                right_frame_5.skillIcon.Image = first_child.skillIcon.Value
                right_frame_5.skillName.Text = string.upper(first_child.Name)
                right_frame_5.skillDescription.Text = first_child.Description.Value
                right_frame_5.skillType.Text = string.upper(first_child.Type.Value) .. " TYPE"
                if
                    first_child.Name ~= local_player.Data.SelectedSkill.Value
                    and first_child.Name ~= local_player.Data.GoalieSkill.Value
                then
                    right_frame_5.selectButton.Text = "SELECT"
                else
                    right_frame_5.selectButton.Text = "SELECTED"
                end
            else
                local clone_7 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
                clone_7.Parent = game.Workspace
                clone_7:Play()
                game.Debris:AddItem(clone_7, 3)
                task.spawn(function()
                    local tween_properties_3 = { Rotation = 45 }
                    game:GetService("TweenService")
                        :Create(
                            clone_3.Locked,
                            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            tween_properties_3
                        )
                        :Play()
                    task.wait(0.1)
                    local tween_properties_4 = { Rotation = -45 }
                    game:GetService("TweenService")
                        :Create(
                            clone_3.Locked,
                            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            tween_properties_4
                        )
                        :Play()
                    task.wait(0.1)
                    local tween_properties_5 = { Rotation = 0 }
                    game:GetService("TweenService")
                        :Create(
                            clone_3.Locked,
                            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            tween_properties_5
                        )
                        :Play()
                end)
            end
        end)
        clone_3.Destroying:Once(function()
            connection_2:Disconnect()
        end)
    end
    if values[local_player.Name] and argument == "Field" then
        local clone_4 = script.skillTemplate:Clone()
        clone_4.Parent = skill_frame.SkillList
        clone_4.Text = "GODSPEED"
        clone_4.skillIcon.Image = "http://www.roblox.com/asset/?id=5902417546"
        if local_player.Data.SelectedSkill.Value == "Godspeed" then
            clone_4.UIStroke.Color = Color3.new(1, 1, 1)
        end
        local connection_3 = clone_4.MouseButton1Click:Connect(function()
            local tween_service = game:GetService("TweenService")
            local tween_info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties = {}
            tween_properties.Color = Color3.new(1, 1, 1)
            tween_service:Create(clone_4.UIStroke, tween_info, tween_properties):Play()
            for _, child_3 in pairs(skill_frame.SkillList:GetChildren()) do
                if not (child_3:IsA("TextButton")) then
                    continue
                end
                if child_3 ~= clone_4 then
                    local tween_service_2 = game:GetService("TweenService")
                    local tween_info_2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local tween_properties_2 = {}
                    tween_properties_2.Color = Color3.fromRGB(108, 115, 122)
                    tween_service_2:Create(child_3.UIStroke, tween_info_2, tween_properties_2):Play()
                end
            end
            local right_frame_5 = skill_frame.RightFrame
            right_frame_5.skillIcon.Image = "http://www.roblox.com/asset/?id=5902417546"
            right_frame_5.skillName.Text = "GODSPEED"
            right_frame_5.skillDescription.Text = "godspeed godspeed godspeed"
            right_frame_5.skillType.Text = "SPEED TYPE"
            if local_player.Data.SelectedSkill.Value ~= "Godspeed" then
                right_frame_5.selectButton.Text = "SELECT"
            else
                right_frame_5.selectButton.Text = "SELECTED"
            end
        end)
        clone_4.Destroying:Once(function()
            connection_3:Disconnect()
        end)
    end
    if local_player.Data.SelectedSkill.Value ~= "Godspeed" then
        local first_child_2
        if argument ~= "Field" then
            first_child_2 = game.ReplicatedStorage.SkillInfo:FindFirstChild(local_player.Data.GoalieSkill.Value)
        else
            first_child_2 = game.ReplicatedStorage.SkillInfo:FindFirstChild(local_player.Data.SelectedSkill.Value)
        end
        local right_frame = skill_frame.RightFrame
        right_frame.skillIcon.Image = first_child_2.skillIcon.Value
        right_frame.skillName.Text = string.upper(first_child_2.Name)
        right_frame.skillDescription.Text = first_child_2.Description.Value
        right_frame.skillType.Text = string.upper(first_child_2.Type.Value) .. " TYPE"
        right_frame.selectButton.Text = "SELECTED"
    else
        local right_frame_4 = skill_frame.RightFrame
        right_frame_4.skillIcon.Image = "http://www.roblox.com/asset/?id=5902417546"
        right_frame_4.skillName.Text = "GODSPEED"
        right_frame_4.skillDescription.Text = "godspeed godspeed godspeed"
        right_frame_4.skillType.Text = "SPEED TYPE"
        right_frame_4.selectButton.Text = "SELECTED"
    end
    if values[local_player.Name] and argument == "Field" then
        local clone_5 = script.skillTemplate:Clone()
        clone_5.Parent = skill_frame.SkillList
        clone_5.Text = "STREET DRIBBLE"
        clone_5.skillIcon.Image = "rbxassetid://90759096829751"
        if local_player.Data.SelectedSkill.Value == "Street Dribble" then
            clone_5.UIStroke.Color = Color3.new(1, 0.74902, 0)
        end
        local connection_4 = clone_5.MouseButton1Click:Connect(function()
            local tween_service = game:GetService("TweenService")
            local tween_info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties = {}
            tween_properties.Color = Color3.new(1, 1, 1)
            tween_service:Create(clone_5.UIStroke, tween_info, tween_properties):Play()
            for _, child_3 in pairs(skill_frame.SkillList:GetChildren()) do
                if not (child_3:IsA("TextButton")) then
                    continue
                end
                if child_3 ~= clone_5 then
                    local tween_service_2 = game:GetService("TweenService")
                    local tween_info_2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local tween_properties_2 = {}
                    tween_properties_2.Color = Color3.fromRGB(108, 115, 122)
                    tween_service_2:Create(child_3.UIStroke, tween_info_2, tween_properties_2):Play()
                end
            end
            local right_frame_5 = skill_frame.RightFrame
            right_frame_5.skillIcon.Image = "rbxassetid://90759096829751"
            right_frame_5.skillName.Text = "STREET DRIBBLE"
            right_frame_5.skillDescription.Text = "Street Football Dribble Style!"
            right_frame_5.skillType.Text = "DRIBBLE TYPE"
            right_frame_5.selectButton.Text = "SELECTED"
            if local_player.Data.SelectedSkill.Value ~= "Street Dribble" then
                right_frame_5.selectButton.Text = "SELECT"
            else
                right_frame_5.selectButton.Text = "SELECTED"
            end
        end)
        clone_5.Destroying:Once(function()
            connection_4:Disconnect()
        end)
    end
    if values[local_player.Name] and argument == "Field" then
        local clone_6 = script.skillTemplate:Clone()
        clone_6.Parent = skill_frame.SkillList
        clone_6.Text = "EXPLOSIVE RUSH"
        clone_6.skillIcon.Image = "http://www.roblox.com/asset/?id=15485263286"
        if local_player.Data.SelectedSkill.Value == "Explosive Rush" then
            clone_6.UIStroke.Color = Color3.new(1, 1, 1)
        end
        local connection_5 = clone_6.MouseButton1Click:Connect(function()
            local tween_service = game:GetService("TweenService")
            local tween_info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties = {}
            tween_properties.Color = Color3.new(1, 1, 1)
            tween_service:Create(clone_6.UIStroke, tween_info, tween_properties):Play()
            for _, child_3 in pairs(skill_frame.SkillList:GetChildren()) do
                if not (child_3:IsA("TextButton")) then
                    continue
                end
                if child_3 ~= clone_6 then
                    local tween_service_2 = game:GetService("TweenService")
                    local tween_info_2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local tween_properties_2 = {}
                    tween_properties_2.Color = Color3.fromRGB(108, 115, 122)
                    tween_service_2:Create(child_3.UIStroke, tween_info_2, tween_properties_2):Play()
                end
            end
            local right_frame_5 = skill_frame.RightFrame
            right_frame_5.skillIcon.Image = "http://www.roblox.com/asset/?id=15485263286"
            right_frame_5.skillName.Text = "EXPLOSIVE RUSH"
            right_frame_5.skillDescription.Text = "Catch up."
            right_frame_5.skillType.Text = "SPEED TYPE"
            if local_player.Data.SelectedSkill.Value ~= "Explosive Rush" then
                right_frame_5.selectButton.Text = "SELECT"
            else
                right_frame_5.selectButton.Text = "SELECTED"
            end
        end)
        clone_6.Destroying:Once(function()
            connection_5:Disconnect()
        end)
    end
    if local_player.Data.SelectedSkill.Value ~= "Explosive Rush" then
        local first_child_3
        if argument ~= "Field" then
            first_child_3 = game.ReplicatedStorage.SkillInfo:FindFirstChild(local_player.Data.GoalieSkill.Value)
        else
            first_child_3 = game.ReplicatedStorage.SkillInfo:FindFirstChild(local_player.Data.SelectedSkill.Value)
        end
        local right_frame_2 = skill_frame.RightFrame
        right_frame_2.skillIcon.Image = first_child_3.skillIcon.Value
        right_frame_2.skillName.Text = string.upper(first_child_3.Name)
        right_frame_2.skillDescription.Text = first_child_3.Description.Value
        right_frame_2.skillType.Text = string.upper(first_child_3.Type.Value) .. " TYPE"
        right_frame_2.selectButton.Text = "SELECTED"
    else
        local right_frame_3 = skill_frame.RightFrame
        right_frame_3.skillIcon.Image = "http://www.roblox.com/asset/?id=5902417546"
        right_frame_3.skillName.Text = "EXPLOSIVE RUSH"
        right_frame_3.skillDescription.Text = "Catch up."
        right_frame_3.skillType.Text = "SPEED TYPE"
        right_frame_3.selectButton.Text = "SELECTED"
    end
end

task.spawn(function()
    repeat
        task.wait()
    until local_player.Data.SelectedSkill.Value ~= ""
    setupSkillsFrame("Field")
end)
skill_frame.PickCategoryFrame.FieldSkillsButton.MouseButton1Click:Connect(function()
    local tween_properties = { TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            skill_frame.PickCategoryFrame.FieldSkillsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    local tween_properties_2 = { TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(
            skill_frame.PickCategoryFrame.GoalieSkillsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_2
        )
        :Play()
    setupSkillsFrame("Field")
end)
skill_frame.PickCategoryFrame.GoalieSkillsButton.MouseButton1Click:Connect(function()
    local tween_properties = { TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            skill_frame.PickCategoryFrame.GoalieSkillsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    local tween_properties_2 = { TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(
            skill_frame.PickCategoryFrame.FieldSkillsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_2
        )
        :Play()
    setupSkillsFrame("Goalie")
end)

function updateSkillResults(argument)
    for _, child in pairs(skill_frame.SkillList:GetChildren()) do
        if not (child:IsA("TextButton")) then
            continue
        end
        if argument == "" then
            child.Visible = true
            continue
        end
        if string.sub(string.lower(child.Text), 1, #argument) ~= string.sub(argument, 1, #argument) then
            child.Visible = false
        else
            child.Visible = true
        end
        if child.Visible ~= false then
            continue
        end
        if string.sub(string.lower(child.Type.Value), 1, #argument) == string.sub(argument, 1, #argument) then
            child.Visible = true
        end
    end
end

skill_frame.searchBar:GetPropertyChangedSignal("Text"):Connect(function()
    updateSkillResults(skill_frame.searchBar.Text)
end)
skill_frame.RightFrame.selectButton.MouseButton1Click:Connect(function()
    local text_6 = ""
    for _, child in pairs(game.ReplicatedStorage.SkillInfo:GetChildren()) do
        if string.lower(child.Name) == string.lower(skill_frame.RightFrame.skillName.Text) then
            text_6 = child.Name
        end
    end
    if skill_frame.RightFrame.skillName.Text == "GODSPEED" then
        text_6 = "Godspeed"
    end
    if skill_frame.RightFrame.skillName.Text == "EXPLOSIVE RUSH" then
        text_6 = "Explosive Rush"
    end
    local invoke_server_result = remote_function_3:InvokeServer(text_6)
    local value_5 = nil
    if invoke_server_result == "MissingLevel" then
        value_5 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
        value_5.Parent = game.Workspace
        value_5:Play()
        game.Debris:AddItem(value_5, 3)
    elseif invoke_server_result == "Success" then
        value_5 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
        value_5.Parent = game.Workspace
        value_5:Play()
        game.Debris:AddItem(value_5, 3)
        skill_frame.RightFrame.selectButton.Text = "SELECTED"
    elseif invoke_server_result == nil then
        local clone_3 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
        clone_3.Parent = game.Workspace
        clone_3:Play()
        game.Debris:AddItem(clone_3, 3)
    end
end)
menu_buttons.SkillsButton.MouseButton1Click:Connect(function()
    if skill_frame.Visible ~= false then
        local tween_service = game:GetService("TweenService")
        local tween_info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties = {}
        tween_properties.Position = UDim2.new(0.5, 0, 1, 230)
        tween_service:Create(skill_frame, tween_info, tween_properties):Play()
        task.delay(0.35, function()
            skill_frame.Visible = false
        end)
    else
        closeTeamSelect()
        closeModeSelect()
        script.Parent.SettingsFrame.Visible = false
        setupSkillsFrame(text_2)
        local tween_service_2 = game:GetService("TweenService")
        local tween_info_2 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_2 = {}
        tween_properties_2.Position = UDim2.new(0.5, 0, 1, 170)
        tween_service_2:Create(stats_frame, tween_info_2, tween_properties_2):Play()
        task.delay(0.35, function()
            stats_frame.Visible = false
        end)
        skill_frame.Visible = true
        local tween_service_3 = game:GetService("TweenService")
        local tween_info_3 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_3 = {}
        tween_properties_3.Position = UDim2.new(0.5, 0, 0.5, 0)
        tween_service_3:Create(skill_frame, tween_info_3, tween_properties_3):Play()
        local tween_service_4 = game:GetService("TweenService")
        local tween_info_4 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_4 = {}
        tween_properties_4.Position = UDim2.new(0.5, 0, 1.5, 0)
        tween_service_4:Create(script.Parent.ClubFrame, tween_info_4, tween_properties_4):Play()
        task.delay(0.35, function()
            script.Parent.ClubFrame.Visible = false
        end)
    end
end)
menu_buttons.StatsButton.MouseButton1Click:Connect(function()
    if stats_frame.Visible ~= false then
        local tween_service = game:GetService("TweenService")
        local tween_info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties = {}
        tween_properties.Position = UDim2.new(0.5, 0, 1, 170)
        tween_service:Create(stats_frame, tween_info, tween_properties):Play()
        task.delay(0.35, function()
            stats_frame.Visible = false
        end)
    else
        closeTeamSelect()
        closeModeSelect()
        script.Parent.SettingsFrame.Visible = false
        local tween_service_2 = game:GetService("TweenService")
        local tween_info_2 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_2 = {}
        tween_properties_2.Position = UDim2.new(0.5, 0, 1, 230)
        tween_service_2:Create(skill_frame, tween_info_2, tween_properties_2):Play()
        task.delay(0.35, function()
            skill_frame.Visible = false
        end)
        task.spawn(function()
            stats_frame.TitleFrame.MoneyValue.Text = getPlayerValue()
        end)
        stats_frame.Visible = true
        local tween_service_3 = game:GetService("TweenService")
        local tween_info_3 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_3 = {}
        tween_properties_3.Position = UDim2.new(0.5, 0, 0.5, 0)
        tween_service_3:Create(stats_frame, tween_info_3, tween_properties_3):Play()
    end
end)
skill_frame.TitleFrame.CancelButton.MouseButton1Click:Connect(function()
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0.5, 0, 1, 230)
    tween_service:Create(skill_frame, tween_info, tween_properties):Play()
    task.delay(0.35, function()
        skill_frame.Visible = false
    end)
end)
stats_frame.TitleFrame.CancelButton.MouseButton1Click:Connect(function()
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0.5, 0, 1, 170)
    tween_service:Create(stats_frame, tween_info, tween_properties):Play()
    task.delay(0.35, function()
        stats_frame.Visible = false
    end)
end)
local equip_frame = customization_frame.EquipFrame
local items_frame = customization_frame.ItemsFrame
local select_frame = customization_frame.SelectFrame
local values_4 = {}
values_4.Default = "http://www.roblox.com/asset/?id=8215214363"
values_4.LongSleeve = "rbxassetid://16728126739"
values_4.Tracksuit = "rbxassetid://16728138036"
values_4.HandWrap = "rbxassetid://72720706206318"
values_4.Undershirt = "rbxassetid://18565763187"
values_4.None = "rbxassetid://18295163188"
values_4.BlackGloves = "rbxassetid://18566362734"
values_4.WhiteGloves = "rbxassetid://104532564191542"
values_4.BlackFacemask = "rbxassetid://122170710702541"
values_4.WhiteFacemask = "rbxassetid://96362968821852"
values_4.BlackWristband = "rbxassetid://134371080571386"
values_4.WhiteWristband = "rbxassetid://72720706206318"
local values_5 = {}
values_5.Default = "DEFAULT"
values_5.LongSleeve = "LONG SLEEVE"
values_5.Undershirt = "JERSEY W/ UNDERSHIRT"
values_5.Tracksuit = "TRACKSUIT"
values_5.None = "NONE"
values_5.BlackGloves = "BLACK GLOVES"
values_5.WhiteGloves = "WHITE GLOVES"
values_5.BlackFacemask = "BLACK FACEMASK"
values_5.WhiteFacemask = "WHITE FACEMASK"
values_5.HandWrap = "HAND WRAP"
values_5.BlackWristband = "BLACK WRISTBAND"
values_5.WhiteWristband = "WHITE WRISTBAND"
local values_6 = {}
values_6.Common = Color3.new(1, 1, 1)
values_6.Rare = Color3.new(0.262745, 0.462745, 0.792157)
values_6.Epic = Color3.new(0.792157, 0, 0.862745)
values_6.Legendary = Color3.new(1, 0, 0)
values_6.Exclusive = Color3.new(1, 0.968627, 0)

function updateShirtType()
    select_frame.ShirtsButton.CurrentlyEquipped.Text = (
        (values_5[local_player.Data.shirtType.Value] ~= nil) and values_5[local_player.Data.shirtType.Value]
    ) or "DEFAULT"
    if values_4[local_player.Data.shirtType.Value] == nil then
        return
    end
    select_frame.ShirtsButton.Icon.Image = (
        (values_4[local_player.Data.shirtType.Value] ~= nil) and values_4[local_player.Data.shirtType.Value]
    ) or "http://www.roblox.com/asset/?id=8215214363"
end

updateShirtType()
local_player.Data.shirtType.Changed:Connect(updateShirtType)

function updateAnimationType()
    local first_child = game.ReplicatedStorage.ItemInfo:FindFirstChild(local_player.Data.animationType.Value)
    if not first_child then
        return
    end
    select_frame.AnimationsButton.CurrentlyEquipped.TextColor3 = values_6[first_child.Rarity.Value]
    select_frame.AnimationsButton.CurrentlyEquipped.Text = string.upper(first_child.Name)
    select_frame.AnimationsButton.Icon.Image = first_child.itemIcon.Texture
end

updateAnimationType()
local_player.Data.animationType.Changed:Connect(updateAnimationType)

function updateGloveType()
    local first_child = game.ReplicatedStorage.ItemInfo:FindFirstChild(local_player.Data.GoalieGloves.Value)
    if not first_child then
        return
    end
    select_frame.GoalieGlovesButton.CurrentlyEquipped.TextColor3 = values_6[first_child.Rarity.Value]
    select_frame.GoalieGlovesButton.CurrentlyEquipped.Text = string.upper(first_child.Name)
    select_frame.GoalieGlovesButton.Icon.Image = first_child.itemIcon.Texture
end

updateGloveType()
local_player.Data.GoalieGloves.Changed:Connect(updateGloveType)

function updateAccessory()
    select_frame.AccessoriesButton.CurrentlyEquipped.Text = (
        (values_5[local_player.Data.Accessory.Value] ~= nil) and values_5[local_player.Data.Accessory.Value]
    ) or "NONE"
    if values_4[local_player.Data.Accessory.Value] == nil then
        return
    end
    select_frame.AccessoriesButton.Icon.Image = (
        (values_4[local_player.Data.Accessory.Value] ~= nil) and values_4[local_player.Data.Accessory.Value]
    ) or "http://www.roblox.com/asset/?id=18295163188"
end

updateAccessory()
local_player.Data.Accessory.Changed:Connect(updateAccessory)

function updateScoreAura()
    local first_child = game.ReplicatedStorage.ItemInfo:FindFirstChild(local_player.Data.ScoreAura.Value)
    if not first_child then
        return
    end
    select_frame.AuraButton.CurrentlyEquipped.TextColor3 = values_6[first_child.Rarity.Value]
    select_frame.AuraButton.CurrentlyEquipped.Text = string.upper(first_child.Name)
    select_frame.AuraButton.Icon.Image = first_child.itemIcon.Texture
end

updateScoreAura()
local_player.Data.ScoreAura.Changed:Connect(updateScoreAura)

function updateMVPEyes()
    local first_child = game.ReplicatedStorage.ItemInfo:FindFirstChild(local_player.Data.MVPEyes.Value)
    if not first_child then
        return
    end
    select_frame.EyesButton.CurrentlyEquipped.TextColor3 = values_6[first_child.Rarity.Value]
    select_frame.EyesButton.CurrentlyEquipped.Text = string.upper(first_child.Name)
    select_frame.EyesButton.Icon.Image = first_child.itemIcon.Texture
end

updateMVPEyes()
local_player.Data.MVPEyes.Changed:Connect(updateMVPEyes)

function updateGoalCeleb()
    local first_child = game.ReplicatedStorage.ItemInfo:FindFirstChild(local_player.Data.GoalCelebration.Value)
    if not first_child then
        return
    end
    select_frame.GoalCelebButton.CurrentlyEquipped.TextColor3 = values_6[first_child.Rarity.Value]
    select_frame.GoalCelebButton.CurrentlyEquipped.Text = string.upper(first_child.Name)
    select_frame.GoalCelebButton.Icon.Image = first_child.itemIcon.Texture
end

updateGoalCeleb()
local_player.Data.GoalCelebration.Changed:Connect(updateGoalCeleb)

function updateWinCeleb()
    local first_child = game.ReplicatedStorage.ItemInfo:FindFirstChild(local_player.Data.WinCelebration.Value)
    if not first_child then
        return
    end
    select_frame.WinCelebButton.CurrentlyEquipped.TextColor3 = values_6[first_child.Rarity.Value]
    select_frame.WinCelebButton.CurrentlyEquipped.Text = string.upper(first_child.Name)
    select_frame.WinCelebButton.Icon.Image = first_child.itemIcon.Texture
end

updateWinCeleb()
local_player.Data.WinCelebration.Changed:Connect(updateWinCeleb)
local item_info = game.ReplicatedStorage.ItemInfo

function runCustomizationSetup()
    for _, child in pairs(items_frame.AurasFrame:GetChildren()) do
        if child:IsA("ImageButton") then
            child:Destroy()
        end
    end
    for _, child_2 in pairs(items_frame.AnimationFrame:GetChildren()) do
        if child_2:IsA("ImageButton") then
            child_2:Destroy()
        end
    end
    for _, child_3 in pairs(items_frame.GoalieGlovesFrame:GetChildren()) do
        if child_3:IsA("ImageButton") then
            child_3:Destroy()
        end
    end
    for _, child_4 in pairs(items_frame.EyesFrame:GetChildren()) do
        if child_4:IsA("ImageButton") then
            child_4:Destroy()
        end
    end
    for _, child_5 in pairs(items_frame.GoalCelebFrame:GetChildren()) do
        if child_5:IsA("ImageButton") then
            child_5:Destroy()
        end
    end
    for _, child_6 in pairs(items_frame.WinCelebFrame:GetChildren()) do
        if child_6:IsA("ImageButton") then
            child_6:Destroy()
        end
    end
    local parts = string.split(local_player.Data.Inventory.Value)
    for _, descendant_3 in pairs(items_frame:GetDescendants()) do
        if not (descendant_3:IsA("ImageButton")) then
            continue
        end
        if table.find(parts, descendant_3.Name) then
            if not (descendant_3:FindFirstChild("Locked")) then
                continue
            end
            descendant_3.Locked.Visible = false
            descendant_3.LockedBG.Visible = false
            if descendant_3:FindFirstChild("Price") then
                descendant_3.Price.Visible = false
            end
        else
            descendant_3.Locked.Visible = true
            descendant_3.LockedBG.Visible = true
            if descendant_3:FindFirstChild("Price") then
                descendant_3.Price.Visible = true
            end
        end
    end
    for _, child_name in pairs(parts) do
        local first_child = item_info:FindFirstChild(child_name)
        if not first_child then
            continue
        end
        local instance = script.itemTemplate:Clone()
        instance.Name = first_child.Name
        instance.itemName.Text = string.upper(first_child.Name)
        instance.itemName.TextColor3 = values_6[first_child.Rarity.Value]
        instance.Icon.Image = first_child.itemIcon.Texture
        if first_child.Type.Value == "Aura" then
            instance.Parent = items_frame.AurasFrame
            instance.MouseButton1Click:Connect(function()
                doSelection(instance)
            end)
            continue
        end
        if first_child.Type.Value == "AnimationPack" then
            instance.Parent = items_frame.AnimationFrame
            instance.MouseButton1Click:Connect(function()
                doSelection(instance)
            end)
            continue
        end
        if first_child.Type.Value == "Eyes" then
            instance.Parent = items_frame.EyesFrame
            instance.MouseButton1Click:Connect(function()
                doSelection(instance)
            end)
            continue
        end
        if first_child.Type.Value == "Glove" then
            instance.Parent = items_frame.GoalieGlovesFrame
            instance.MouseButton1Click:Connect(function()
                doSelection(instance)
            end)
            continue
        end
        if first_child.Type.Value ~= "GoalCeleb" then
            if first_child.Type.Value ~= "WinCeleb" then
                instance.MouseButton1Click:Connect(function()
                    doSelection(instance)
                end)
                continue
            end
            instance.Parent = items_frame.WinCelebFrame
            if first_child:FindFirstChild("AlsoGoalCeleb") then
                local instance_2 = script.itemTemplate:Clone()
                instance_2.Name = first_child.Name
                instance_2.itemName.Text = string.upper(first_child.Name)
                instance_2.itemName.TextColor3 = values_6[first_child.Rarity.Value]
                instance_2.Icon.Image = first_child.itemIcon.Texture
                instance_2.Parent = items_frame.GoalCelebFrame
                instance_2.MouseButton1Click:Connect(function()
                    doSelection(instance_2)
                end)
            end
        else
            instance.Parent = items_frame.GoalCelebFrame
            if first_child:FindFirstChild("AlsoWinCeleb") then
                local instance_3 = script.itemTemplate:Clone()
                instance_3.Name = first_child.Name
                instance_3.itemName.Text = string.upper(first_child.Name)
                instance_3.itemName.TextColor3 = values_6[first_child.Rarity.Value]
                instance_3.Icon.Image = first_child.itemIcon.Texture
                instance_3.Parent = items_frame.WinCelebFrame
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

runCustomizationSetup()
menu_buttons.CustomizeButton.MouseButton1Click:Connect(function()
    color_selector.Visible = false
    customization_frame:SetAttribute("vis", true)
    runCustomizationSetup()
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0, 0, 0.5, 0)
    tween_service:Create(customization_frame.ItemsFrame, tween_info, tween_properties):Play()
    local tween_service_2 = game:GetService("TweenService")
    local tween_info_2 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = {}
    tween_properties_2.Position = UDim2.new(1, 0, 1, 0)
    tween_service_2:Create(customization_frame.SelectFrame, tween_info_2, tween_properties_2):Play()
    local tween_service_3 = game:GetService("TweenService")
    local tween_info_3 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_3 = {}
    tween_properties_3.Position = UDim2.new(0.5, 0, 0.95, 0)
    tween_service_3:Create(customization_frame.CancelButton, tween_info_3, tween_properties_3):Play()
    local tween_service_4 = game:GetService("TweenService")
    local tween_info_4 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_4 = {}
    tween_properties_4.Position = UDim2.new(0.5, 0, 1.5, 0)
    tween_service_4:Create(script.Parent.ClubFrame, tween_info_4, tween_properties_4):Play()
    task.delay(0.35, function()
        script.Parent.ClubFrame.Visible = false
    end)
    menu_buttons.Visible = false
    play_button.Visible = false
end)
customization_frame.CancelButton.MouseButton1Click:Connect(function()
    customization_frame:SetAttribute("vis", false)
    color_selector.Visible = false
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0, -350, 0.5, 0)
    tween_service:Create(customization_frame.ItemsFrame, tween_info, tween_properties):Play()
    local tween_service_2 = game:GetService("TweenService")
    local tween_info_2 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = {}
    tween_properties_2.Position = UDim2.new(1, 800, 1, 0)
    tween_service_2:Create(customization_frame.SelectFrame, tween_info_2, tween_properties_2):Play()
    local tween_service_3 = game:GetService("TweenService")
    local tween_info_3 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_3 = {}
    tween_properties_3.Position = UDim2.new(0.5, 0, 0.95, 200)
    tween_service_3:Create(customization_frame.CancelButton, tween_info_3, tween_properties_3):Play()
    local tween_service_4 = game:GetService("TweenService")
    local tween_info_4 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_4 = {}
    tween_properties_4.Position = UDim2.new(0.5, 0, 1, 150)
    tween_service_4:Create(equip_frame, tween_info_4, tween_properties_4):Play()
    menu_buttons.Visible = true
    play_button.Visible = true
end)
local shirts_frame = items_frame.ShirtsFrame
local accessories_frame = items_frame.AccessoriesFrame
local value_4 = nil
local text_3 = "shirtType"
select_frame.AnimationsButton.MouseButton1Click:Connect(function()
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0.5, 0, 1, 150)
    tween_service:Create(equip_frame, tween_info, tween_properties):Play()
    value_4 = nil
    text_3 = "animationType"
    items_frame.AnimationFrame.Visible = true
    color_selector.Visible = false
    local tween_service_2 = game:GetService("TweenService")
    local tween_info_2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = { Thickness = 4, Transparency = 0 }
    tween_properties_2.Color = Color3.new(1, 1, 1)
    tween_service_2:Create(select_frame.AnimationsButton.UIStroke, tween_info_2, tween_properties_2):Play()
    local tween_service_3 = game:GetService("TweenService")
    local tween_info_3 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_3 = {}
    tween_properties_3.Size = UDim2.new(0, 105, 0, 90)
    tween_service_3:Create(select_frame.AnimationsButton.Icon, tween_info_3, tween_properties_3):Play()
    for _, child in pairs(items_frame:GetChildren()) do
        if (child:IsA("Frame") or child:IsA("ScrollingFrame")) and child ~= items_frame.AnimationFrame then
            child.Visible = false
        end
    end
    for _, child_2 in pairs(select_frame:GetChildren()) do
        if not (child_2:IsA("ImageButton")) then
            continue
        end
        if child_2 ~= select_frame.AnimationsButton then
            local tween_service_4 = game:GetService("TweenService")
            local tween_info_4 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_4 = { Thickness = 2, Transparency = 0.25 }
            tween_properties_4.Color = Color3.new(0.498039, 0.529412, 0.560784)
            tween_service_4:Create(child_2.UIStroke, tween_info_4, tween_properties_4):Play()
            local tween_service_5 = game:GetService("TweenService")
            local tween_info_5 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_5 = {}
            tween_properties_5.Size = UDim2.new(0, 97, 0, 85)
            tween_service_5:Create(child_2.Icon, tween_info_5, tween_properties_5):Play()
        end
    end
end)
select_frame.GoalieGlovesButton.MouseButton1Click:Connect(function()
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0.5, 0, 1, 150)
    tween_service:Create(equip_frame, tween_info, tween_properties):Play()
    value_4 = nil
    text_3 = "GoalieGloves"
    items_frame.GoalieGlovesFrame.Visible = true
    color_selector.Visible = false
    local tween_service_2 = game:GetService("TweenService")
    local tween_info_2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = { Thickness = 4, Transparency = 0 }
    tween_properties_2.Color = Color3.new(1, 1, 1)
    tween_service_2:Create(select_frame.GoalieGlovesButton.UIStroke, tween_info_2, tween_properties_2):Play()
    local tween_service_3 = game:GetService("TweenService")
    local tween_info_3 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_3 = {}
    tween_properties_3.Size = UDim2.new(0, 105, 0, 90)
    tween_service_3:Create(select_frame.GoalieGlovesButton.Icon, tween_info_3, tween_properties_3):Play()
    for _, child in pairs(items_frame:GetChildren()) do
        if (child:IsA("Frame") or child:IsA("ScrollingFrame")) and child ~= items_frame.GoalieGlovesFrame then
            child.Visible = false
        end
    end
    for _, child_2 in pairs(select_frame:GetChildren()) do
        if not (child_2:IsA("ImageButton")) then
            continue
        end
        if child_2 ~= select_frame.GoalieGlovesButton then
            local tween_service_4 = game:GetService("TweenService")
            local tween_info_4 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_4 = { Thickness = 2, Transparency = 0.25 }
            tween_properties_4.Color = Color3.new(0.498039, 0.529412, 0.560784)
            tween_service_4:Create(child_2.UIStroke, tween_info_4, tween_properties_4):Play()
            local tween_service_5 = game:GetService("TweenService")
            local tween_info_5 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_5 = {}
            tween_properties_5.Size = UDim2.new(0, 97, 0, 85)
            tween_service_5:Create(child_2.Icon, tween_info_5, tween_properties_5):Play()
        end
    end
end)
select_frame.ShirtsButton.MouseButton1Click:Connect(function()
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0.5, 0, 1, 150)
    tween_service:Create(equip_frame, tween_info, tween_properties):Play()
    value_4 = nil
    text_3 = "shirtType"
    items_frame.ShirtsFrame.Visible = true
    color_selector.Visible = false
    local tween_service_2 = game:GetService("TweenService")
    local tween_info_2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = { Thickness = 4, Transparency = 0 }
    tween_properties_2.Color = Color3.new(1, 1, 1)
    tween_service_2:Create(select_frame.ShirtsButton.UIStroke, tween_info_2, tween_properties_2):Play()
    local tween_service_3 = game:GetService("TweenService")
    local tween_info_3 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_3 = {}
    tween_properties_3.Size = UDim2.new(0, 105, 0, 90)
    tween_service_3:Create(select_frame.ShirtsButton.Icon, tween_info_3, tween_properties_3):Play()
    for _, child in pairs(items_frame:GetChildren()) do
        if (child:IsA("Frame") or child:IsA("ScrollingFrame")) and child ~= items_frame.ShirtsFrame then
            child.Visible = false
        end
    end
    for _, child_2 in pairs(select_frame:GetChildren()) do
        if not (child_2:IsA("ImageButton")) then
            continue
        end
        if child_2 ~= select_frame.ShirtsButton then
            local tween_service_4 = game:GetService("TweenService")
            local tween_info_4 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_4 = { Thickness = 2, Transparency = 0.25 }
            tween_properties_4.Color = Color3.new(0.498039, 0.529412, 0.560784)
            tween_service_4:Create(child_2.UIStroke, tween_info_4, tween_properties_4):Play()
            local tween_service_5 = game:GetService("TweenService")
            local tween_info_5 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_5 = {}
            tween_properties_5.Size = UDim2.new(0, 97, 0, 85)
            tween_service_5:Create(child_2.Icon, tween_info_5, tween_properties_5):Play()
        end
    end
end)
select_frame.AccessoriesButton.MouseButton1Click:Connect(function()
    color_selector.Color.BackgroundColor3 = local_player.Data.AccessoryColor.Value
    color_selector.Visible = true
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0.5, 0, 1, 150)
    tween_service:Create(equip_frame, tween_info, tween_properties):Play()
    value_4 = nil
    text_3 = "Accessory"
    items_frame.AccessoriesFrame.Visible = true
    local tween_service_2 = game:GetService("TweenService")
    local tween_info_2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = { Thickness = 4, Transparency = 0 }
    tween_properties_2.Color = Color3.new(1, 1, 1)
    tween_service_2:Create(select_frame.AccessoriesButton.UIStroke, tween_info_2, tween_properties_2):Play()
    local tween_service_3 = game:GetService("TweenService")
    local tween_info_3 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_3 = {}
    tween_properties_3.Size = UDim2.new(0, 105, 0, 90)
    tween_service_3:Create(select_frame.AccessoriesButton.Icon, tween_info_3, tween_properties_3):Play()
    for _, child in pairs(items_frame:GetChildren()) do
        if (child:IsA("Frame") or child:IsA("ScrollingFrame")) and child ~= items_frame.AccessoriesFrame then
            child.Visible = false
        end
    end
    for _, child_2 in pairs(select_frame:GetChildren()) do
        if not (child_2:IsA("ImageButton")) then
            continue
        end
        if child_2 ~= select_frame.AccessoriesButton then
            local tween_service_4 = game:GetService("TweenService")
            local tween_info_4 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_4 = { Thickness = 2, Transparency = 0.25 }
            tween_properties_4.Color = Color3.new(0.498039, 0.529412, 0.560784)
            tween_service_4:Create(child_2.UIStroke, tween_info_4, tween_properties_4):Play()
            local tween_service_5 = game:GetService("TweenService")
            local tween_info_5 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_5 = {}
            tween_properties_5.Size = UDim2.new(0, 97, 0, 85)
            tween_service_5:Create(child_2.Icon, tween_info_5, tween_properties_5):Play()
        end
    end
end)
select_frame.AuraButton.MouseButton1Click:Connect(function()
    color_selector.Visible = false
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0.5, 0, 1, 150)
    tween_service:Create(equip_frame, tween_info, tween_properties):Play()
    value_4 = nil
    text_3 = "ScoreAura"
    items_frame.AurasFrame.Visible = true
    local tween_service_2 = game:GetService("TweenService")
    local tween_info_2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = { Thickness = 4, Transparency = 0 }
    tween_properties_2.Color = Color3.new(1, 1, 1)
    tween_service_2:Create(select_frame.AuraButton.UIStroke, tween_info_2, tween_properties_2):Play()
    local tween_service_3 = game:GetService("TweenService")
    local tween_info_3 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_3 = {}
    tween_properties_3.Size = UDim2.new(0, 105, 0, 90)
    tween_service_3:Create(select_frame.AuraButton.Icon, tween_info_3, tween_properties_3):Play()
    for _, child in pairs(items_frame:GetChildren()) do
        if (child:IsA("Frame") or child:IsA("ScrollingFrame")) and child ~= items_frame.AurasFrame then
            child.Visible = false
        end
    end
    for _, child_2 in pairs(select_frame:GetChildren()) do
        if not (child_2:IsA("ImageButton")) then
            continue
        end
        if child_2 ~= select_frame.AuraButton then
            local tween_service_4 = game:GetService("TweenService")
            local tween_info_4 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_4 = { Thickness = 2, Transparency = 0.25 }
            tween_properties_4.Color = Color3.new(0.498039, 0.529412, 0.560784)
            tween_service_4:Create(child_2.UIStroke, tween_info_4, tween_properties_4):Play()
            local tween_service_5 = game:GetService("TweenService")
            local tween_info_5 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_5 = {}
            tween_properties_5.Size = UDim2.new(0, 97, 0, 85)
            tween_service_5:Create(child_2.Icon, tween_info_5, tween_properties_5):Play()
        end
    end
end)
select_frame.EyesButton.MouseButton1Click:Connect(function()
    color_selector.Visible = false
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0.5, 0, 1, 150)
    tween_service:Create(equip_frame, tween_info, tween_properties):Play()
    value_4 = nil
    text_3 = "MVPEyes"
    items_frame.EyesFrame.Visible = true
    local tween_service_2 = game:GetService("TweenService")
    local tween_info_2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = { Thickness = 4, Transparency = 0 }
    tween_properties_2.Color = Color3.new(1, 1, 1)
    tween_service_2:Create(select_frame.EyesButton.UIStroke, tween_info_2, tween_properties_2):Play()
    local tween_service_3 = game:GetService("TweenService")
    local tween_info_3 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_3 = {}
    tween_properties_3.Size = UDim2.new(0, 105, 0, 90)
    tween_service_3:Create(select_frame.EyesButton.Icon, tween_info_3, tween_properties_3):Play()
    for _, child in pairs(items_frame:GetChildren()) do
        if (child:IsA("Frame") or child:IsA("ScrollingFrame")) and child ~= items_frame.EyesFrame then
            child.Visible = false
        end
    end
    for _, child_2 in pairs(select_frame:GetChildren()) do
        if not (child_2:IsA("ImageButton")) then
            continue
        end
        if child_2 ~= select_frame.EyesButton then
            local tween_service_4 = game:GetService("TweenService")
            local tween_info_4 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_4 = { Thickness = 2, Transparency = 0.25 }
            tween_properties_4.Color = Color3.new(0.498039, 0.529412, 0.560784)
            tween_service_4:Create(child_2.UIStroke, tween_info_4, tween_properties_4):Play()
            local tween_service_5 = game:GetService("TweenService")
            local tween_info_5 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_5 = {}
            tween_properties_5.Size = UDim2.new(0, 97, 0, 85)
            tween_service_5:Create(child_2.Icon, tween_info_5, tween_properties_5):Play()
        end
    end
end)
select_frame.GoalCelebButton.MouseButton1Click:Connect(function()
    color_selector.Visible = false
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0.5, 0, 1, 150)
    tween_service:Create(equip_frame, tween_info, tween_properties):Play()
    value_4 = nil
    text_3 = "GoalCelebration"
    items_frame.GoalCelebFrame.Visible = true
    local tween_service_2 = game:GetService("TweenService")
    local tween_info_2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = { Thickness = 4, Transparency = 0 }
    tween_properties_2.Color = Color3.new(1, 1, 1)
    tween_service_2:Create(select_frame.GoalCelebButton.UIStroke, tween_info_2, tween_properties_2):Play()
    local tween_service_3 = game:GetService("TweenService")
    local tween_info_3 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_3 = {}
    tween_properties_3.Size = UDim2.new(0, 105, 0, 90)
    tween_service_3:Create(select_frame.GoalCelebButton.Icon, tween_info_3, tween_properties_3):Play()
    for _, child in pairs(items_frame:GetChildren()) do
        if (child:IsA("Frame") or child:IsA("ScrollingFrame")) and child ~= items_frame.GoalCelebFrame then
            child.Visible = false
        end
    end
    for _, child_2 in pairs(select_frame:GetChildren()) do
        if not (child_2:IsA("ImageButton")) then
            continue
        end
        if child_2 ~= select_frame.GoalCelebButton then
            local tween_service_4 = game:GetService("TweenService")
            local tween_info_4 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_4 = { Thickness = 2, Transparency = 0.25 }
            tween_properties_4.Color = Color3.new(0.498039, 0.529412, 0.560784)
            tween_service_4:Create(child_2.UIStroke, tween_info_4, tween_properties_4):Play()
            local tween_service_5 = game:GetService("TweenService")
            local tween_info_5 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_5 = {}
            tween_properties_5.Size = UDim2.new(0, 97, 0, 85)
            tween_service_5:Create(child_2.Icon, tween_info_5, tween_properties_5):Play()
        end
    end
end)
select_frame.WinCelebButton.MouseButton1Click:Connect(function()
    color_selector.Visible = false
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0.5, 0, 1, 150)
    tween_service:Create(equip_frame, tween_info, tween_properties):Play()
    value_4 = nil
    text_3 = "WinCelebration"
    items_frame.WinCelebFrame.Visible = true
    local tween_service_2 = game:GetService("TweenService")
    local tween_info_2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = { Thickness = 4, Transparency = 0 }
    tween_properties_2.Color = Color3.new(1, 1, 1)
    tween_service_2:Create(select_frame.WinCelebButton.UIStroke, tween_info_2, tween_properties_2):Play()
    local tween_service_3 = game:GetService("TweenService")
    local tween_info_3 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_3 = {}
    tween_properties_3.Size = UDim2.new(0, 105, 0, 90)
    tween_service_3:Create(select_frame.WinCelebButton.Icon, tween_info_3, tween_properties_3):Play()
    for _, child in pairs(items_frame:GetChildren()) do
        if (child:IsA("Frame") or child:IsA("ScrollingFrame")) and child ~= items_frame.WinCelebFrame then
            child.Visible = false
        end
    end
    for _, child_2 in pairs(select_frame:GetChildren()) do
        if not (child_2:IsA("ImageButton")) then
            continue
        end
        if child_2 ~= select_frame.WinCelebButton then
            local tween_service_4 = game:GetService("TweenService")
            local tween_info_4 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_4 = { Thickness = 2, Transparency = 0.25 }
            tween_properties_4.Color = Color3.new(0.498039, 0.529412, 0.560784)
            tween_service_4:Create(child_2.UIStroke, tween_info_4, tween_properties_4):Play()
            local tween_service_5 = game:GetService("TweenService")
            local tween_info_5 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween_properties_5 = {}
            tween_properties_5.Size = UDim2.new(0, 97, 0, 85)
            tween_service_5:Create(child_2.Icon, tween_info_5, tween_properties_5):Play()
        end
    end
end)
equip_frame.EquipButton.MouseButton1Click:Connect(function()
    if value_4 ~= nil then
        remote_event:FireServer(text_3, value_4)
        local clone_3 = game.ReplicatedStorage.UISounds["ui-confirm1"]:Clone()
        clone_3.Parent = game.Workspace
        clone_3:Play()
        game.Debris:AddItem(clone_3, 2)
        equip_frame.EquipButton.Text = "EQUIPPED"
    end
end)

function showConfirmation(instance)
    customization_frame.PopupContainer.Visible = true
    customization_frame.PopupContainer.PurchaseText.Text = "WOULD YOU LIKE TO PURCHASE <"
        .. instance.Type.Text
        .. "> for "
        .. instance.Price.Text
        .. "?"
    local connection_3 = nil
    local connection_4 = nil
    local connection = customization_frame.PopupContainer.YesButton.MouseButton1Click:Connect(function()
        if remote_function_4:InvokeServer(instance.Name) ~= nil then
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
            connection_4:Disconnect()
            customization_frame.PopupContainer.Visible = false
        else
            local clone_4 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
            clone_4.Parent = game.Workspace
            clone_4:Play()
            game.Debris:AddItem(clone_4, 3)
            task.spawn(function()
                local tween_properties = { Rotation = 45 }
                game:GetService("TweenService")
                    :Create(
                        instance.Locked,
                        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        tween_properties
                    )
                    :Play()
                task.wait(0.1)
                local tween_properties_2 = { Rotation = -45 }
                game:GetService("TweenService")
                    :Create(
                        instance.Locked,
                        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        tween_properties_2
                    )
                    :Play()
                task.wait(0.1)
                local tween_properties_3 = { Rotation = 0 }
                game:GetService("TweenService")
                    :Create(
                        instance.Locked,
                        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        tween_properties_3
                    )
                    :Play()
            end)
        end
    end)
    connection_4 = connection
    local connection_2 = customization_frame.PopupContainer.NoButton.MouseButton1Click:Connect(function()
        connection_4:Disconnect()
        connection_3:Disconnect()
        customization_frame.PopupContainer.Visible = false
    end)
    connection_3 = connection_2
end

function doSelection(instance)
    if
        not (table.find(string.split(local_player.Data.Inventory.Value), instance.Name))
        and instance:FindFirstChild("Price")
    then
        local tween_service = game:GetService("TweenService")
        local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties = {}
        tween_properties.Position = UDim2.new(0.5, 0, 1, 150)
        tween_service:Create(equip_frame, tween_info, tween_properties):Play()
        showConfirmation(instance)
        return
    end
    if value_4 ~= instance.Name then
        for _, child in pairs(instance.Parent:GetChildren()) do
            if child == instance then
                continue
            end
            if child:IsA("ImageButton") then
                local tween_service_2 = game:GetService("TweenService")
                local tween_info_2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tween_properties_2 = { Transparency = 0.25, Thickness = 2 }
                tween_properties_2.Color = Color3.new(0.498039, 0.529412, 0.560784)
                tween_service_2:Create(child.UIStroke, tween_info_2, tween_properties_2):Play()
            end
        end
        value_4 = instance.Name
        local tween_service_3 = game:GetService("TweenService")
        local tween_info_3 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_3 = {}
        tween_properties_3.Position = UDim2.new(0.5, 0, 1, -125)
        tween_service_3:Create(equip_frame, tween_info_3, tween_properties_3):Play()
        tween_service_3 = game:GetService("TweenService")
        local tween_info_4 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_4 = { Transparency = 0, Thickness = 3 }
        tween_properties_4.Color = Color3.new(1, 1, 1)
        tween_service_3:Create(instance.UIStroke, tween_info_4, tween_properties_4):Play()
        equip_frame.EquipButton.Text = "EQUIP"
        for _, child_2 in pairs(local_player.Data:GetChildren()) do
            if not (child_2:IsA("StringValue")) or child_2.Value ~= instance.Name then
                continue
            end
            equip_frame.EquipButton.Text = "EQUIPPED"
            return
        end
    else
        value_4 = nil
        local tween_service_4 = game:GetService("TweenService")
        local tween_info_5 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_5 = {}
        tween_properties_5.Position = UDim2.new(0.5, 0, 1, 150)
        tween_service_4:Create(equip_frame, tween_info_5, tween_properties_5):Play()
        local tween_service_5 = game:GetService("TweenService")
        local tween_info_6 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_6 = { Transparency = 0.25, Thickness = 2 }
        tween_properties_6.Color = Color3.new(0.498039, 0.529412, 0.560784)
        tween_service_5:Create(instance.UIStroke, tween_info_6, tween_properties_6):Play()
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
local values_7 = {}
values_7.Argentina = "Argentina"
values_7.AstonVilla = "Aston Vila"
values_7.Munich = "Munich"
values_7.Dortmund = "Dortmund"
values_7.Brazil = "Brazil"
values_7.ParisSaints = "Paris"
values_7.ManchesterU = "Manchester Utd."
values_7.Barcelona = "Barcelona"
values_7.Flamengo = "Flamengo"
values_7.InterMiami = "Inter Miami"
values_7.Japan = "Japan"
values_7.Italy = "Italy"
values_7.Croatia = "Croatia"
values_7.Morocco = "Morocco"
values_7.Canada = "Canada"
values_7.Portugal = "Portugal"
values_7.Mexico = "Mexico"
values_7.Netherlands = "Netherlands"
values_7.RealMadrid = "Real Madrid"
values_7.LiverpoolFC = "Liverpool FC"
values_7.SeattleSoundersFC = "Sounders FC"
values_7.JuventusFC = "Juventus FC"
values_7.Newcastle = "Newcastle Utd."
values_7.ManchesterCity = "Man. City"
values_7.Germany = "Germany"
values_7.England = "England"
values_7.Arsenal = "Arsenal"
values_7.InterMilan = "Inter Milan"
values_7.USA = "USA"
values_7.Chelsea = "Chelsea"
values_7.Napoli = "Napoli"
values_7.France = "France"
values_7.Uruguay = "Uruguay"
values_7.Roma = "Roma"
values_7.Lazio = "Lazio"
values_7.SouthKorea = "South Korea"
values_7.VascoDaGama = "Vasco da Gama"
values_7.Ajax = "AFC Ajax"
values_7.Atletico = "Atletico Madrid"
values_7.Leverkusen = "B04 Leverkusen"
values_7.Wales = "Wales"
values_7.Fiorentina = "Fiorentina"
values_7.Spurs = "Tottenham Hotspurs"
values_7.ACMilan = "AC Milan"
values_7.Belgium = "Belgium"
values_7.Spain = "Spain"
values_7.Scotland = "Scotland"
values_7.Poland = "Poland"
values_7.Sweden = "Sweden"
values_7.Bosnia = "Bosnia & Herzegovina"
values_7.Denmark = "Denmark"
values_7.Romania = "Romania"
values_7.Switzerland = "Switzerland"
local values_8 = {}
values_8.AstonVilla = BrickColor.new("Baby blue")
values_8.Flamengo = BrickColor.new("Dark red")
values_8.Argentina = BrickColor.new("Cyan")
values_8.Munich = BrickColor.new("Dusty Rose")
values_8.Dortmund = BrickColor.new("Bright yellow")
values_8.Brazil = BrickColor.new("Dark green")
values_8.ParisSaints = BrickColor.new("Dark blue")
values_8.ManchesterU = BrickColor.new("Bright red")
values_8.Barcelona = BrickColor.new("Deep blue")
values_8.InterMiami = BrickColor.new("Carnation pink")
values_8.Japan = BrickColor.new("Navy blue")
values_8.Italy = BrickColor.new("Lapis")
values_8.Croatia = BrickColor.new("Pastel Blue")
values_8.Morocco = BrickColor.new("Crimson")
values_8.Canada = BrickColor.new("Ghost grey")
values_8.Portugal = BrickColor.new("Bright red")
values_8.Mexico = BrickColor.new("Black")
values_8.Netherlands = BrickColor.new("Neon orange")
values_8.RealMadrid = BrickColor.new("Ghost grey")
values_8.LiverpoolFC = BrickColor.new("Really red")
values_8.SeattleSoundersFC = BrickColor.new("Bright green")
values_8.JuventusFC = BrickColor.new("Really black")
values_8.Newcastle = BrickColor.new("Smoky grey")
values_8.ManchesterCity = BrickColor.new("Electric blue")
values_8.Germany = BrickColor.new("Maroon")
values_8.Arsenal = BrickColor.new("Really red")
values_8.InterMilan = BrickColor.new("Navy blue")
values_8.USA = BrickColor.new("Deep blue")
values_8.Chelsea = BrickColor.new("Lapis")
values_8.Napoli = BrickColor.new("Steel blue")
values_8.France = BrickColor.new("Dark blue")
values_8.Uruguay = BrickColor.new("Medium blue")
values_8.Roma = BrickColor.new("Persimmon")
values_8.Lazio = BrickColor.new("Medium blue")
values_8.England = BrickColor.new("Fossil")
values_8.SouthKorea = BrickColor.new("Mid gray")
values_8.VascoDaGama = BrickColor.new("Mid gray")
values_8.Ajax = BrickColor.new("Salmon")
values_8.Atletico = BrickColor.new("Crimson")
values_8.Leverkusen = BrickColor.new("Cocoa")
values_8.Wales = BrickColor.new("Sea green")
values_8.Fiorentina = BrickColor.new("Royal purple")
values_8.Spurs = BrickColor.new("Quill grey")
values_8.ACMilan = BrickColor.new("Maroon")
values_8.Belgium = BrickColor.new("Deep orange")
values_8.Spain = BrickColor.new("Bright orange")
values_8.Scotland = BrickColor.new("Electric blue")
values_8.Poland = BrickColor.new("Terra Cotta")
values_8.Sweden = BrickColor.new("Storm blue")
values_8.Bosnia = BrickColor.new("Dark indigo")
values_8.Denmark = BrickColor.new("Really red")
values_8.Romania = BrickColor.new("Bright yellow")
values_8.Switzerland = BrickColor.new("Persimmon")
local values_9 = {}
values_9.AstonVilla = "rbxassetid://81835506871297"
values_9.Flamengo = "rbxassetid://110918350569178"
values_9.Argentina = "rbxassetid://15068029862"
values_9.Munich = "rbxassetid://15068635815"
values_9.Dortmund = "rbxassetid://13460575423"
values_9.Brazil = "rbxassetid://15068649812"
values_9.ParisSaints = "rbxassetid://13552953245"
values_9.ManchesterU = "rbxassetid://14540294821"
values_9.Barcelona = "rbxassetid://316144192"
values_9.InterMiami = "rbxassetid://15081749904"
values_9.Japan = "rbxassetid://15098627666"
values_9.Italy = "rbxassetid://15107657423"
values_9.Croatia = "rbxassetid://15107652254"
values_9.Morocco = "rbxassetid://15107668354"
values_9.Canada = "rbxassetid://15107670722"
values_9.Portugal = "rbxassetid://15148310170"
values_9.Mexico = "rbxassetid://15107685948"
values_9.Netherlands = "rbxassetid://15107690732"
values_9.RealMadrid = "rbxassetid://15107692601"
values_9.LiverpoolFC = "rbxassetid://5525377475"
values_9.SeattleSoundersFC = "rbxassetid://15155280087"
values_9.JuventusFC = "rbxassetid://15238497443"
values_9.Newcastle = "rbxassetid://18897627545"
values_9.ManchesterCity = "rbxassetid://14243657473"
values_9.Germany = "rbxassetid://18640980135"
values_9.England = "rbxassetid://18641004985"
values_9.Arsenal = "rbxassetid://18652402819"
values_9.InterMilan = "rbxassetid://18816070754"
values_9.USA = "rbxassetid://18641031024"
values_9.Chelsea = "rbxassetid://18641029244"
values_9.Napoli = "rbxassetid://18641026783"
values_9.France = "rbxassetid://18641023325"
values_9.Uruguay = "rbxassetid://18641021338"
values_9.Roma = "rbxassetid://18641019719"
values_9.Lazio = "rbxassetid://18641016564"
values_9.SouthKorea = "rbxassetid://18641001856"
values_9.VascoDaGama = "rbxassetid://18640997828"
values_9.Ajax = "rbxassetid://18640996176"
values_9.Atletico = "rbxassetid://18640993960"
values_9.Leverkusen = "rbxassetid://18640992087"
values_9.Wales = "rbxassetid://18640989958"
values_9.Fiorentina = "rbxassetid://18640988644"
values_9.Spurs = "rbxassetid://18640987300"
values_9.ACMilan = "rbxassetid://18640984312"
values_9.Belgium = "rbxassetid://18641190960"
values_9.Spain = "rbxassetid://18672737980"
values_9.Scotland = "rbxassetid://18672741584"
values_9.Poland = "rbxassetid://18816097298"
values_9.Sweden = "rbxassetid://18897774513"
values_9.Bosnia = "rbxassetid://18897785797"
values_9.Denmark = "rbxassetid://18897980982"
values_9.Romania = "rbxassetid://18897982581"
values_9.Switzerland = "rbxassetid://18897984306"
local local_player_2 = game.Players.LocalPlayer
local character = local_player_2.Character or (local_player_2.CharacterAdded:Wait())
if local_player_2:FindFirstChild("InPlay") then
    play_button.Visible = false
    menu_buttons.Visible = false
end
local_player_2.ChildAdded:Connect(function(child)
    if child.Name ~= "InPlay" then
        return
    end
    holder.Parent.Visible = false
    holder_2.Parent.Visible = false
    skill_frame.Position = UDim2.new(0.5, 0, 1, 230)
    skill_frame.Visible = false
    play_button.Visible = false
    menu_buttons.Visible = false
    customization_frame:SetAttribute("vis", false)
    customization_frame.ItemsFrame.Position = UDim2.new(0, -350, 0.5, 0)
    customization_frame.SelectFrame.Position = UDim2.new(1, 800, 1, 0)
    customization_frame.CancelButton.Position = UDim2.new(0.5, 0, 0.95, 200)
    color_selector.Visible = false
    equip_frame.Position = UDim2.new(0, -125, 0.5, 150)
end)
local_player_2.ChildRemoved:Connect(function(child)
    if child.Name == "InPlay" then
        holder.Parent.Visible = true
        holder_2.Parent.Visible = true
        local end_screen = game.ReplicatedStorage:FindFirstChild("EndScreen")
        if end_screen then
            local end_screen_2
            repeat
                task.wait()
                end_screen_2 = game.ReplicatedStorage:FindFirstChild("EndScreen")
            until not end_screen_2
        end
        play_button.Visible = true
        menu_buttons.Visible = true
    end
end)
local enabled_2 = false
team_info.CurrentHomeTeam.Changed:Connect(function()
    local value_5 = game.ReplicatedStorage.TeamInfo.CurrentHomeTeam.Value
    local home_team = team_select_frame.SelectionFrame.HomeTeam
    home_team.BackgroundColor3 = values_8[value_5].Color
    home_team.Vignette.ImageColor3 = values_8[value_5].Color
    home_team.teamName.Text = values_7[value_5]
    home_team.Crest.Image = values_9[value_5]
end)
team_info.CurrentAwayTeam.Changed:Connect(function()
    local value_5 = game.ReplicatedStorage.TeamInfo.CurrentAwayTeam.Value
    local away_team = team_select_frame.SelectionFrame.AwayTeam
    away_team.BackgroundColor3 = values_8[value_5].Color
    away_team.Vignette.ImageColor3 = values_8[value_5].Color
    away_team.teamName.Text = values_7[value_5]
    away_team.Crest.Image = values_9[value_5]
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
local values_10 = {}
values_10.LW = nil
values_10.CF = nil
values_10.RW = nil
values_10.LAM = nil
values_10.RAM = nil
values_10.CDM = nil
values_10.LCB = nil
values_10.RCB = nil
values_10.LWB = nil
values_10.RWB = nil
values_10.GK = nil
local values_11 = {}
values_11.LW = nil
values_11.CF = nil
values_11.RW = nil
values_11.LAM = nil
values_11.RAM = nil
values_11.CDM = nil
values_11.LCB = nil
values_11.RCB = nil
values_11.LWB = nil
values_11.RWB = nil
values_11.GK = nil

function updatePositionPlayers()
    values_10 = {
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
    values_11 = {
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
        if not (player:FindFirstChild("dataLoaded")) then
            continue
        end
        if player.SelectedTeam.Value == "Home" then
            local values_13 = values_10
            values_13[player.SelectedPosition.Value] = string.upper(player.DisplayName)
            continue
        end
        if player.SelectedTeam.Value == "Away" then
            local values_14 = values_11
            values_14[player.SelectedPosition.Value] = string.upper(player.DisplayName)
        end
    end
end

local enabled_3 = false

function openTeamSelect()
    if enabled_2 == true then
        return
    end
    local value_5 = game.ReplicatedStorage.TeamInfo.CurrentHomeTeam.Value
    local home_team = team_select_frame.SelectionFrame.HomeTeam
    home_team.BackgroundColor3 = values_8[value_5].Color
    home_team.Vignette.ImageColor3 = values_8[value_5].Color
    home_team.teamName.Text = values_7[value_5]
    home_team.Crest.Image = values_9[value_5]
    local value_6 = game.ReplicatedStorage.TeamInfo.CurrentAwayTeam.Value
    local away_team = team_select_frame.SelectionFrame.AwayTeam
    away_team.BackgroundColor3 = values_8[value_6].Color
    away_team.Vignette.ImageColor3 = values_8[value_6].Color
    away_team.teamName.Text = values_7[value_6]
    away_team.Crest.Image = values_9[value_6]
    enabled_2 = true
    team_select_frame.Visible = true
    team_select_frame.Position = UDim2.new(0.5, 0, 1, 200)
    team_select_frame.CancelButton.Position = UDim2.new(0.5, 0, 1, 35)
    pos_select_frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    pos_select_frame.CancelButton.Position = UDim2.new(0.5, 0, 1, 35)
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0.5, 0, 0.5, 0)
    tween_service:Create(team_select_frame, tween_info, tween_properties):Play()
end

local text_4 = "N/A"

function closeTeamSelect()
    if enabled_2 == false then
        return
    end
    text_4 = "N/A"
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0.5, 0, 1, 200)
    tween_service:Create(team_select_frame, tween_info, tween_properties):Play()
    local tween_service_2 = game:GetService("TweenService")
    local tween_info_2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = {}
    tween_properties_2.Position = UDim2.new(0.5, 0, 1, 750)
    tween_service_2:Create(team_select_frame.CancelButton, tween_info_2, tween_properties_2):Play()
    local tween_service_3 = game:GetService("TweenService")
    local tween_info_3 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    local tween_properties_3 = {}
    tween_properties_3.Position = UDim2.new(0.5, 0, 1, 250)
    tween_service_3:Create(pos_select_frame, tween_info_3, tween_properties_3):Play()
    local tween_service_4 = game:GetService("TweenService")
    local tween_info_4 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_4 = {}
    tween_properties_4.Position = UDim2.new(0.5, 0, 1, 750)
    tween_service_4:Create(pos_select_frame.CancelButton, tween_info_4, tween_properties_4):Play()
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
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0.5, 0, 0.5, 0)
    tween_service:Create(mode_select_frame, tween_info, tween_properties):Play()
end

function closeModeSelect()
    if enabled_3 == false then
        return
    end
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0.5, 0, 1, 200)
    tween_service:Create(mode_select_frame, tween_info, tween_properties):Play()
    local tween_service_2 = game:GetService("TweenService")
    local tween_info_2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = {}
    tween_properties_2.Position = UDim2.new(0.5, 0, 1, 750)
    tween_service_2:Create(mode_select_frame.CancelButton, tween_info_2, tween_properties_2):Play()
    task.delay(0.5, function()
        enabled_3 = false
        mode_select_frame.Visible = false
    end)
end

local mode_button = script.Parent:WaitForChild("PlayButton"):WaitForChild("ModeButton")
play_button.PlayButton.MouseButton1Click:Connect(function()
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0.5, 0, 1, 170)
    tween_service:Create(stats_frame, tween_info, tween_properties):Play()
    task.delay(0.35, function()
        stats_frame.Visible = false
    end)
    script.Parent.SettingsFrame.Visible = false
    local tween_service_2 = game:GetService("TweenService")
    local tween_info_2 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = {}
    tween_properties_2.Position = UDim2.new(0.5, 0, 1, 230)
    tween_service_2:Create(skill_frame, tween_info_2, tween_properties_2):Play()
    task.delay(0.35, function()
        skill_frame.Visible = false
    end)
    local tween_service_3 = game:GetService("TweenService")
    local tween_info_3 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_3 = {}
    tween_properties_3.Position = UDim2.new(0.5, 0, 1.5, 0)
    tween_service_3:Create(script.Parent.ClubFrame, tween_info_3, tween_properties_3):Play()
    task.delay(0.35, function()
        script.Parent.ClubFrame.Visible = false
    end)
    customization_frame:SetAttribute("vis", false)
    openTeamSelect()
end)
mode_button.MouseButton1Click:Connect(function()
    local tween_service = game:GetService("TweenService")
    local tween_info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties = {}
    tween_properties.Position = UDim2.new(0.5, 0, 1, 170)
    tween_service:Create(stats_frame, tween_info, tween_properties):Play()
    task.delay(0.35, function()
        stats_frame.Visible = false
    end)
    script.Parent.SettingsFrame.Visible = false
    local tween_service_2 = game:GetService("TweenService")
    local tween_info_2 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_2 = {}
    tween_properties_2.Position = UDim2.new(0.5, 0, 1, 230)
    tween_service_2:Create(skill_frame, tween_info_2, tween_properties_2):Play()
    task.delay(0.35, function()
        skill_frame.Visible = false
    end)
    local tween_service_3 = game:GetService("TweenService")
    local tween_info_3 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween_properties_3 = {}
    tween_properties_3.Position = UDim2.new(0.5, 0, 1.5, 0)
    tween_service_3:Create(script.Parent.ClubFrame, tween_info_3, tween_properties_3):Play()
    task.delay(0.35, function()
        script.Parent.ClubFrame.Visible = false
    end)
    closeTeamSelect()
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
local selection_frame_2 = pos_select_frame.SelectionFrame

function handlePosSelect(argument)
    updatePositionPlayers()
    text_4 = argument
    if argument == "Home" then
        selection_frame_2.LWButton.CurrentPlayer.Text = values_10.LW or ""
        selection_frame_2.CFButton.CurrentPlayer.Text = values_10.CF or ""
        selection_frame_2.RWButton.CurrentPlayer.Text = values_10.RW or ""
        selection_frame_2.CAMButtonL.CurrentPlayer.Text = values_10.LAM or ""
        selection_frame_2.CAMButtonR.CurrentPlayer.Text = values_10.RAM or ""
        selection_frame_2.CDMButton.CurrentPlayer.Text = values_10.CDM or ""
        selection_frame_2.CBButtonL.CurrentPlayer.Text = values_10.LCB or ""
        selection_frame_2.CBButtonR.CurrentPlayer.Text = values_10.RCB or ""
        selection_frame_2.LWBButton.CurrentPlayer.Text = values_10.LWB or ""
        selection_frame_2.RWBButton.CurrentPlayer.Text = values_10.RWB or ""
        selection_frame_2.GKButton.CurrentPlayer.Text = values_10.GK or ""
    elseif argument == "Away" then
        selection_frame_2.LWButton.CurrentPlayer.Text = values_11.LW or ""
        selection_frame_2.CFButton.CurrentPlayer.Text = values_11.CF or ""
        selection_frame_2.RWButton.CurrentPlayer.Text = values_11.RW or ""
        selection_frame_2.CAMButtonL.CurrentPlayer.Text = values_11.LAM or ""
        selection_frame_2.CAMButtonR.CurrentPlayer.Text = values_11.RAM or ""
        selection_frame_2.CDMButton.CurrentPlayer.Text = values_11.CDM or ""
        selection_frame_2.CBButtonL.CurrentPlayer.Text = values_11.LCB or ""
        selection_frame_2.CBButtonR.CurrentPlayer.Text = values_11.RCB or ""
        selection_frame_2.LWBButton.CurrentPlayer.Text = values_11.LWB or ""
        selection_frame_2.RWBButton.CurrentPlayer.Text = values_11.RWB or ""
        selection_frame_2.GKButton.CurrentPlayer.Text = values_11.GK or ""
    end
end

function selectPosition(argument)
    if text_4 ~= "Home" then
        if text_4 == "Away" then
            local value_5 = nil
            if values_11[argument] ~= nil then
                notification("POSITION TAKEN. PLEASE SELECT A DIFFERENT POSITION.")
            else
                closeTeamSelect()
                value_5 = remote_function_5:InvokeServer(argument, "Away")
                if value_5 == "TeamFull" then
                    notification("TEAM FULL. SELECT A DIFFERENT TEAM.")
                elseif value_5 == "PositionFull" then
                    notification("POSITION TAKEN. PLEASE SELECT A DIFFERENT POSITION.")
                elseif value_5 == nil then
                    notification("AN UNKNOWN ERROR OCCURED. PLEASE TRY AGAIN.")
                end
            end
        end
    elseif values_10[argument] ~= nil then
        notification("POSITION TAKEN. PLEASE SELECT A DIFFERENT POSITION.")
    else
        closeTeamSelect()
        local invoke_server_result = remote_function_5:InvokeServer(argument, "Home")
        if invoke_server_result == "TeamFull" then
            notification("TEAM FULL. SELECT A DIFFERENT TEAM.")
        elseif invoke_server_result == "PositionFull" then
            notification("POSITION TAKEN. PLEASE SELECT A DIFFERENT POSITION.")
        elseif invoke_server_result == nil then
            notification("AN UNKNOWN ERROR OCCURED. PLEASE TRY AGAIN.")
        end
    end
end

team_select_frame.SelectionFrame.HomeTeam.MouseButton1Click:Connect(function()
    if
        (team_info.HomeTeamPlayers.Value >= 11 or team_info.AwayTeamPlayers.Value < team_info.HomeTeamPlayers.Value)
        and local_player_2.SelectedTeam.Value ~= "Home"
    then
        local no_team_limits = game.ReplicatedStorage:FindFirstChild("NoTeamLimits")
        if not no_team_limits then
            notification("TEAM FULL. SELECT A DIFFERENT TEAM.")
            return
        end
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
        (team_info.AwayTeamPlayers.Value >= 11 or team_info.HomeTeamPlayers.Value < team_info.AwayTeamPlayers.Value)
        and local_player_2.SelectedTeam.Value ~= "Away"
    then
        local no_team_limits = game.ReplicatedStorage:FindFirstChild("NoTeamLimits")
        if not no_team_limits then
            notification("TEAM FULL. SELECT A DIFFERENT TEAM.")
            return
        end
    end
    team_select_frame.Visible = false
    pos_select_frame.Visible = true
    handlePosSelect("Away")
    while pos_select_frame.Visible == true do
        task.wait()
        handlePosSelect("Away")
    end
end)
selection_frame_2.LWButton.MouseButton1Click:Connect(function()
    selectPosition("LW")
end)
selection_frame_2.CFButton.MouseButton1Click:Connect(function()
    selectPosition("CF")
end)
selection_frame_2.RWButton.MouseButton1Click:Connect(function()
    selectPosition("RW")
end)
selection_frame_2.CAMButtonL.MouseButton1Click:Connect(function()
    selectPosition("LAM")
end)
selection_frame_2.CAMButtonR.MouseButton1Click:Connect(function()
    selectPosition("RAM")
end)
selection_frame_2.CDMButton.MouseButton1Click:Connect(function()
    selectPosition("CDM")
end)
selection_frame_2.LWBButton.MouseButton1Click:Connect(function()
    selectPosition("LWB")
end)
selection_frame_2.CBButtonL.MouseButton1Click:Connect(function()
    selectPosition("LCB")
end)
selection_frame_2.CBButtonR.MouseButton1Click:Connect(function()
    selectPosition("RCB")
end)
selection_frame_2.RWBButton.MouseButton1Click:Connect(function()
    selectPosition("RWB")
end)
selection_frame_2.GKButton.MouseButton1Click:Connect(function()
    selectPosition("GK")
end)
local_player_2:WaitForChild("dataLoaded")
local settings_frame = script.Parent.SettingsFrame
local misc_frame = settings_frame.MiscFrame
local controls_frame = settings_frame.ControlsFrame
local pick_category_frame = settings_frame.PickCategoryFrame
local misc = local_player_2.Settings.Misc
local controls = local_player_2.Settings.Controls
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
    local tween_service = game:GetService("TweenService")
    local toggle_2 = argument.Toggle
    local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local tween_properties = { BackgroundColor3 = 0 }
    tween_properties.BackgroundColor3 = enabled_6 == true and Color3.new(0, 0.666667, 0) or Color3.new(0.666667, 0, 0)
    tween_service:Create(toggle_2, tween_info, tween_properties):Play()
    local tween_service_2 = game:GetService("TweenService")
    local slider = argument.Toggle.Slider
    local tween_info_2 = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local tween_properties_2 = { Position = 0 }
    tween_properties_2.Position = enabled_6 == true and UDim2.new(0.5, 1, 0.5, 0) or UDim2.new(0, -1, 0.5, 0)
    tween_service_2:Create(slider, tween_info_2, tween_properties_2):Play()
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
    remote_event_2:FireServer("CrowdNoise", not misc.CrowdNoise.Value)
end)
misc_frame.MOVETOGGLE.Toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    script.Parent:SetAttribute("MovingUi", enabled)
    if script.Parent:GetAttribute("MovingUi", true) then
        for _, item in pairs(script.Parent.Parent.Buttons.Frame:QueryDescendants("UIDragDetector")) do
            item.Enabled = true
        end
    else
        for _, item_2 in pairs(script.Parent.Parent.Buttons.Frame:QueryDescendants("UIDragDetector")) do
            item_2.Enabled = false
        end
    end
    toggle(misc_frame.MOVETOGGLE, enabled)
end)
misc_frame.AURAEFFECTS.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.AURAEFFECTS, not misc.AuraEffects.Value)
    remote_event_2:FireServer("AuraEffects", not misc.AuraEffects.Value)
end)
misc_frame.FOOTSTEPS.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.FOOTSTEPS, not misc.FootstepSounds.Value)
    if misc.FootstepSounds.Value ~= true then
        character.WalkingSoundsClient.Enabled = false
    else
        character.WalkingSoundsClient.Enabled = true
        if game.SoundService:FindFirstChild("CurrentSound") then
            game.SoundService:FindFirstChild("CurrentSound"):Stop()
        end
    end
    remote_event_2:FireServer("FootstepSounds", not misc.FootstepSounds.Value)
end)
misc_frame.SUNFLARE.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.SUNFLARE, not misc.SunFlare.Value)
    remote_event_2:FireServer("SunFlare", not misc.SunFlare.Value)
end)
misc_frame.ROBLOXSHIRT.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.ROBLOXSHIRT, not misc.UseRobloxShirt.Value)
    remote_event_2:FireServer("UseRobloxShirt", not misc.UseRobloxShirt.Value)
end)
misc_frame.HIGHLIGHTS.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.HIGHLIGHTS, not misc.Highlights.Value)
    remote_event_2:FireServer("Highlights", not misc.Highlights.Value)
end)
misc_frame.CHARACTERROTATION.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.CHARACTERROTATION, not misc.CharacterRotation.Value)
    remote_event_2:FireServer("CharacterRotation", not misc.CharacterRotation.Value)
end)
misc_frame.RAIN.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.RAIN, not misc.RainEnabled.Value)
    toggle(misc_frame.SNOW, false)
    toggle(misc_frame.STORMY, false)
    remote_event_2:FireServer("SnowEnabled", false)
    remote_event_2:FireServer("StormEnabled", false)
    remote_event_2:FireServer("RainEnabled", not misc.RainEnabled.Value)
end)
misc_frame.SNOW.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.SNOW, not misc.SnowEnabled.Value)
    toggle(misc_frame.RAIN, false)
    toggle(misc_frame.STORMY, false)
    remote_event_2:FireServer("RainEnabled", false)
    remote_event_2:FireServer("StormEnabled", false)
    remote_event_2:FireServer("SnowEnabled", not misc.SnowEnabled.Value)
end)
misc_frame.STORMY.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.STORMY, not misc.StormEnabled.Value)
    toggle(misc_frame.RAIN, false)
    toggle(misc_frame.SNOW, false)
    remote_event_2:FireServer("SnowEnabled", false)
    remote_event_2:FireServer("RainEnabled", false)
    remote_event_2:FireServer("StormEnabled", not misc.StormEnabled.Value)
end)
misc_frame.GRASSVISUALS.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.GRASSVISUALS, not misc.GrassVisuals.Value)
    remote_event_2:FireServer("GrassVisuals", not misc.GrassVisuals.Value)
end)
misc_frame.NIGHT.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.NIGHT, not misc.Night.Value)
    remote_event_2:FireServer("Night", not misc.Night.Value)
end)
misc_frame.CURVEVISUAL.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.CURVEVISUAL, not misc.CurveVisual.Value)
    remote_event_2:FireServer("CurveVisual", not misc.CurveVisual.Value)
end)
misc_frame.CINEMATIC.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.CINEMATIC, not misc.CinematicMode.Value)
    remote_event_2:FireServer("CinematicMode", not misc.CinematicMode.Value)
end)
misc_frame.SEASONAL.Toggle.MouseButton1Click:Connect(function()
    toggle(misc_frame.SEASONAL, not misc.Seasonal.Value)
    remote_event_2:FireServer("Seasonal", not misc.Seasonal.Value)
end)
misc_frame.CONTRAST.TextBox.FocusLost:Connect(function()
    local _, value_5 = pcall(function()
        return (tonumber(misc_frame.CONTRAST.TextBox.Text))
    end)
    if value_5 then
        if not (value_5 > 1) and not (value_5 < 0) then
            misc.Contrast.Value = misc_frame.CONTRAST.TextBox.Text
            game.Lighting.ColorCorrection.Contrast = misc.Contrast.Value
        else
            misc_frame.CONTRAST.TextBox.Text = "0"
            notification("CONTRAST MUST BE BETWEEN 1 AND 0")
        end
    else
        misc_frame.CONTRAST.TextBox.Text = "0"
        notification("INVALID INPUT.")
    end
end)
misc.Contrast.Changed:Connect(function()
    misc_frame.CONTRAST.TextBox.Text = misc.Contrast.Value
    game.Lighting.ColorCorrection.Contrast = misc.Contrast.Value
    remote_event_2:FireServer("Contrast", misc.Contrast.Value)
end)
misc_frame.CONTRAST.TextBox.Text = misc.Contrast.Value
game.Lighting.ColorCorrection.Contrast = misc.Contrast.Value
misc_frame.BRIGHTNESS.TextBox.FocusLost:Connect(function()
    local _, value_5 = pcall(function()
        return (tonumber(misc_frame.BRIGHTNESS.TextBox.Text))
    end)
    if value_5 then
        if not (value_5 > 15) and not (value_5 < 0) then
            misc.Brightness.Value = misc_frame.BRIGHTNESS.TextBox.Text
            game.Lighting.Brightness = misc.Brightness.Value
        else
            misc_frame.BRIGHTNESS.TextBox.Text = "0"
            notification("BRIGHTNESS MUST BE BETWEEN 15 AND 0.")
        end
    else
        misc_frame.BRIGHTNESS.TextBox.Text = "0"
        notification("INVALID INPUT.")
    end
end)
misc.Brightness.Changed:Connect(function()
    misc_frame.BRIGHTNESS.TextBox.Text = misc.Brightness.Value
    game.Lighting.Brightness = misc.Brightness.Value
    remote_event_2:FireServer("Brightness", misc.Brightness.Value)
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
    local _, value_5 = pcall(function()
        return (tonumber(misc_frame.NUMBER.TextBox.Text))
    end)
    if value_5 then
        if not (value_5 > 99) and not (value_5 < 0) then
            if remote_function_6:InvokeServer(misc_frame.NUMBER.TextBox.Text, "Number") ~= true then
                notification("AN ERROR HAS OCCURRED.")
                misc_frame.NUMBER.TextBox.Text = "0"
            end
            return
        end
        misc_frame.NUMBER.TextBox.Text = "0"
        notification("JERSEY NUMBERS MUST BE BETWEEN 1 AND 99. USE 0 TO DISABLE.")
    else
        misc_frame.NUMBER.TextBox.Text = "0"
        notification("INVALID INPUT.")
    end
end)
misc_frame.SPONSER.TextBox.FocusLost:Connect(function()
    local _, value_5 = pcall(function()
        return (tostring(misc_frame.SPONSER.TextBox.Text))
    end)
    if value_5 then
        if remote_function_6:InvokeServer(misc_frame.SPONSER.TextBox.Text, "Sponser") == true then
            return
        end
        notification("AN ERROR HAS OCCURRED.")
        misc_frame.SPONSER.TextBox.Text = "0"
    else
        misc_frame.SPONSER.TextBox.Text = "0"
        notification("SPONSER ID CANNOT BE NIL. IF YOU WISH FOR IT TO BE NOTHING SET IT TO 0")
    end
end)
misc_frame.CURSOR.TextBox.FocusLost:Connect(function()
    local _, value_5 = pcall(function()
        return (tostring(misc_frame.CURSOR.TextBox.Text))
    end)
    if value_5 then
        if remote_function_6:InvokeServer(misc_frame.CURSOR.TextBox.Text, "Cursor") == true then
            return
        end
        notification("AN ERROR HAS OCCURRED.")
        misc_frame.CURSOR.TextBox.Text = "0"
    else
        misc_frame.CURSOR.TextBox.Text = "0"
        notification("CURSOR ID CANNOT BE NIL. IF YOU WISH FOR IT TO BE NOTHING SET IT TO 0")
    end
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
        local tween_service = game:GetService("TweenService")
        local tween_info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties = {}
        tween_properties.Position = UDim2.new(0.5, 0, 1, 170)
        tween_service:Create(stats_frame, tween_info, tween_properties):Play()
        task.delay(0.35, function()
            stats_frame.Visible = false
        end)
        closeTeamSelect()
        closeModeSelect()
        local tween_service_2 = game:GetService("TweenService")
        local tween_info_2 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_2 = {}
        tween_properties_2.Position = UDim2.new(0.5, 0, 1, 230)
        tween_service_2:Create(skill_frame, tween_info_2, tween_properties_2):Play()
        task.delay(0.35, function()
            skill_frame.Visible = false
        end)
    end
    settings_frame.Visible = not settings_frame.Visible
end)
pick_category_frame.MiscButton.MouseButton1Click:Connect(function()
    local tween_properties = { TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame.MiscButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    local tween_properties_2 = { TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame.ControlsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_2
        )
        :Play()
    settings_frame.MiscFrame.Visible = true
    settings_frame.ControlsFrame.Visible = false
end)
pick_category_frame.ControlsButton.MouseButton1Click:Connect(function()
    local tween_properties = { TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame.ControlsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    local tween_properties_2 = { TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame.MiscButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_2
        )
        :Play()
    settings_frame.ControlsFrame.Visible = true
    settings_frame.MiscFrame.Visible = false
end)
settings_frame.TitleFrame.CancelButton.MouseButton1Click:Connect(function()
    settings_frame.Visible = false
end)
local user_input_service = game:GetService("UserInputService")

function getTextForKey(argument)
    if argument ~= Enum.KeyCode.LeftShift then
        if argument ~= Enum.KeyCode.LeftControl then
            if argument ~= Enum.KeyCode.LeftAlt then
                if argument ~= Enum.KeyCode.RightShift then
                    if argument ~= Enum.KeyCode.RightControl then
                        if argument ~= Enum.KeyCode.RightAlt then
                            return user_input_service:GetStringForKeyCode(argument)
                        end
                        return "R-ALT"
                    end
                    return "RCTRL"
                end
                return "RSHIFT"
            end
            return "L-ALT"
        end
        return "LCTRL"
    end
    return "LSHIFT"
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
local values_12 = {
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

function handleBind(argument, child_name)
    argument.Text = ""
    local tween_properties = { TextTransparency = 0, TextStrokeTransparency = 0.65 }
    game:GetService("TweenService")
        :Create(
            settings_frame.BindLabel,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    local enabled_6 = false
    local connection_2 = nil
    local connection = user_input_service.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then
            return
        end
        if table.find(values_12, input.KeyCode) then
            if
                input.KeyCode ~= Enum.KeyCode.W
                    and input.KeyCode ~= Enum.KeyCode.D
                    and input.KeyCode ~= Enum.KeyCode.A
                    and input.KeyCode ~= Enum.KeyCode.S
                or child_name ~= "CurveLeft" and child_name ~= "CurveRight" and child_name ~= "Topspin"
            then
                local tween_properties_2 = { TextTransparency = 0, TextStrokeTransparency = 0.65 }
                game:GetService("TweenService")
                    :Create(
                        settings_frame.InvalidKeybindLabel,
                        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        tween_properties_2
                    )
                    :Play()
                local clone_3 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
                clone_3.Parent = game.Workspace
                clone_3:Play()
                game.Debris:AddItem(clone_3, 3)
                task.delay(0.85, function()
                    local tween_properties_5 = { TextTransparency = 1, TextStrokeTransparency = 1 }
                    game:GetService("TweenService")
                        :Create(
                            settings_frame.InvalidKeybindLabel,
                            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            tween_properties_5
                        )
                        :Play()
                end)
                return
            end
            remote_event_3:FireServer(child_name, input.KeyCode)
            enabled_6 = true
            connection_2:Disconnect()
            local tween_properties_3 = { TextTransparency = 1, TextStrokeTransparency = 1 }
            game:GetService("TweenService")
                :Create(
                    settings_frame.BindLabel,
                    TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties_3
                )
                :Play()
        else
            remote_event_3:FireServer(child_name, input.KeyCode)
            enabled_6 = true
            connection_2:Disconnect()
            local tween_properties_4 = { TextTransparency = 1, TextStrokeTransparency = 1 }
            game:GetService("TweenService")
                :Create(
                    settings_frame.BindLabel,
                    TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    tween_properties_4
                )
                :Play()
        end
        argument.Text = getTextForKey(input.KeyCode)
    end)
    connection_2 = connection
    task.delay(4, function()
        if enabled_6 == true then
            return
        end
        argument.Text = getTextForKey(Enum.KeyCode[controls:FindFirstChild(child_name).Value])
        connection_2:Disconnect()
        local tween_properties_2 = { TextTransparency = 1, TextStrokeTransparency = 1 }
        game:GetService("TweenService")
            :Create(
                settings_frame.BindLabel,
                TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                tween_properties_2
            )
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
    remote_event_2:FireServer("ReleaseDive", not controls.ReleaseDive.Value)
end)
controls_frame.FLIP.Toggle.MouseButton1Click:Connect(function()
    toggle(controls_frame.FLIP, not controls.Flipped.Value)
    remote_event_2:FireServer("Flipped", not controls.Flipped.Value)
end)
controls_frame.ToggleSpin.Toggle.MouseButton1Click:Connect(function()
    toggle(controls_frame.ToggleSpin, not controls.SpinToggle.Value)
    remote_event_2:FireServer("SpinToggle", not controls.SpinToggle.Value)
end)
local map = misc_frame.MAP
local map_2 = map.Map
local dropdown_arrow = map_2.DropdownArrow
local dropdown = map.Dropdown
for _, value in pairs(game.ReplicatedStorage.SelectableMaps:GetChildren()) do
    local clone = script.mapButtonTemplate:Clone()
    clone.Text = string.upper(value.Name)
    clone.Parent = dropdown
    clone.MouseButton1Click:Connect(function()
        remote_event_2:FireServer("MapSelection", value.Name)
        map_2.Text = string.upper(value.Name)
        dropdown.Visible = false
        dropdown_arrow.Rotation = 180
    end)
end
map_2.Text = string.upper(misc.MapSelection.Value)
map_2.MouseButton1Click:Connect(function()
    if dropdown.Visible ~= true then
        dropdown_arrow.Rotation = 0
        dropdown.Visible = true
    else
        dropdown.Visible = false
        dropdown_arrow.Rotation = 180
    end
end)
local grass = misc_frame.GRASS
local grass_2 = grass.Grass
local dropdown_arrow_2 = grass_2.DropdownArrow
local dropdown_2 = grass.Dropdown
for _, value_2 in pairs(game.ReplicatedStorage.SelectableGrass:GetChildren()) do
    local clone_2 = script.mapButtonTemplate:Clone()
    clone_2.Text = string.upper(value_2.Name)
    clone_2.Parent = dropdown_2
    clone_2.MouseButton1Click:Connect(function()
        remote_event_2:FireServer("GrassSelection", value_2.Name)
        grass_2.Text = string.upper(value_2.Name)
        dropdown_2.Visible = false
        dropdown_arrow_2.Rotation = 180
    end)
end
grass_2.Text = string.upper(misc.GrassSelection.Value)
grass_2.MouseButton1Click:Connect(function()
    if dropdown_2.Visible ~= true then
        dropdown_arrow_2.Rotation = 0
        dropdown_2.Visible = true
    else
        dropdown_2.Visible = false
        dropdown_arrow_2.Rotation = 180
    end
end)
local pov = misc_frame.POV
local pov_2 = pov.POV
local dropdown_arrow_3 = pov_2.DropdownArrow
local dropdown_3 = pov.Dropdown
for _, value_3 in pairs(dropdown_3:GetChildren()) do
    if value_3:IsA("TextButton") then
        value_3.MouseButton1Click:Connect(function()
            remote_event_2:FireServer("POV", value_3.Name)
            pov_2.Text = string.upper(value_3.Name)
            dropdown_3.Visible = false
            dropdown_arrow_3.Rotation = 180
        end)
    end
end
pov_2.Text = string.upper(misc.POV.Value)
pov_2.MouseButton1Click:Connect(function()
    if dropdown_3.Visible ~= true then
        dropdown_arrow_3.Rotation = 0
        dropdown_3.Visible = true
    else
        dropdown_3.Visible = false
        dropdown_arrow_3.Rotation = 180
    end
end)
local store_frame = script.Parent.StoreFrame
local daily_shop_frame = store_frame.DailyShopFrame
local animations_frame = store_frame.AnimationsFrame
local cosmetics_frame = store_frame.CosmeticsFrame
local robux_shop_frame = store_frame.RobuxShopFrame
local pick_category_frame_2 = store_frame.PickCategoryFrame
local popup_container = store_frame.PopupContainer
menu_buttons.StoreButton.MouseButton1Click:Connect(function()
    store_frame.Visible = not store_frame.Visible
end)
store_frame.TitleFrame.CancelButton.MouseButton1Click:Connect(function()
    store_frame.Visible = false
end)
pick_category_frame_2.CosmeticsButton.MouseButton1Click:Connect(function()
    local tween_properties = { TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame_2.CosmeticsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    local tween_properties_2 = { TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame_2.AnimationsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_2
        )
        :Play()
    local tween_properties_3 = { TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame_2.DailyShopButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_3
        )
        :Play()
    local tween_properties_4 = { TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame_2.RobuxShopButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_4
        )
        :Play()
    animations_frame.Visible = false
    cosmetics_frame.Visible = true
    robux_shop_frame.Visible = false
    store_frame.GiftRecipient.Visible = false
    daily_shop_frame.Visible = false
    store_frame.CrateInfo.Visible = true
end)
pick_category_frame_2.AnimationsButton.MouseButton1Click:Connect(function()
    local tween_properties = { TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame_2.AnimationsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    local tween_properties_2 = { TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame_2.CosmeticsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_2
        )
        :Play()
    local tween_properties_3 = { TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame_2.DailyShopButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_3
        )
        :Play()
    local tween_properties_4 = { TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame_2.RobuxShopButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_4
        )
        :Play()
    animations_frame.Visible = true
    cosmetics_frame.Visible = false
    robux_shop_frame.Visible = false
    store_frame.GiftRecipient.Visible = false
    daily_shop_frame.Visible = false
    store_frame.CrateInfo.Visible = true
end)
pick_category_frame_2.DailyShopButton.MouseButton1Click:Connect(function()
    local tween_properties = { TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame_2.CosmeticsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    local tween_properties_2 = { TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame_2.AnimationsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_2
        )
        :Play()
    local tween_properties_3 = { TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame_2.DailyShopButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_3
        )
        :Play()
    local tween_properties_4 = { TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame_2.RobuxShopButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_4
        )
        :Play()
    animations_frame.Visible = false
    cosmetics_frame.Visible = false
    robux_shop_frame.Visible = false
    store_frame.GiftRecipient.Visible = false
    daily_shop_frame.Visible = true
    store_frame.CrateInfo.Visible = false
end)
pick_category_frame_2.RobuxShopButton.MouseButton1Click:Connect(function()
    local tween_properties = { TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame_2.CosmeticsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties
        )
        :Play()
    local tween_properties_2 = { TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame_2.AnimationsButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_2
        )
        :Play()
    local tween_properties_3 = { TextStrokeTransparency = 1 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame_2.DailyShopButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_3
        )
        :Play()
    local tween_properties_4 = { TextStrokeTransparency = 0.5 }
    game:GetService("TweenService")
        :Create(
            pick_category_frame_2.RobuxShopButton,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            tween_properties_4
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
    local invoke_server_result = remote_function_7:InvokeServer()
    local first_child = item_info:FindFirstChild(invoke_server_result.Legendary)
    daily_shop_frame.Legendary.itemNameVal.Value = first_child.Name
    daily_shop_frame.Legendary.itemIcon.Image = first_child.itemIcon.Texture
    daily_shop_frame.Legendary.ItemName.Text = string.upper(first_child.Name)
    local first_child_2 = item_info:FindFirstChild(invoke_server_result.Epic1)
    daily_shop_frame.Epic1.itemNameVal.Value = first_child_2.Name
    daily_shop_frame.Epic1.itemIcon.Image = first_child_2.itemIcon.Texture
    daily_shop_frame.Epic1.ItemName.Text = string.upper(first_child_2.Name)
    local first_child_3 = item_info:FindFirstChild(invoke_server_result.Epic2)
    daily_shop_frame.Epic2.itemNameVal.Value = first_child_3.Name
    daily_shop_frame.Epic2.itemIcon.Image = first_child_3.itemIcon.Texture
    daily_shop_frame.Epic2.ItemName.Text = string.upper(first_child_3.Name)
    local first_child_4 = item_info:FindFirstChild(invoke_server_result.Rare1)
    daily_shop_frame.Rare1.itemNameVal.Value = first_child_4.Name
    daily_shop_frame.Rare1.itemIcon.Image = first_child_4.itemIcon.Texture
    daily_shop_frame.Rare1.ItemName.Text = string.upper(first_child_4.Name)
    local first_child_5 = item_info:FindFirstChild(invoke_server_result.Rare2)
    daily_shop_frame.Rare2.itemNameVal.Value = first_child_5.Name
    daily_shop_frame.Rare2.itemIcon.Image = first_child_5.itemIcon.Texture
    daily_shop_frame.Rare2.ItemName.Text = string.upper(first_child_5.Name)
    local first_child_6 = item_info:FindFirstChild(invoke_server_result.Rare3)
    daily_shop_frame.Rare3.itemNameVal.Value = first_child_6.Name
    daily_shop_frame.Rare3.itemIcon.Image = first_child_6.itemIcon.Texture
    daily_shop_frame.Rare3.ItemName.Text = string.upper(first_child_6.Name)
end

getDailyShop()
key_handler_service:GetKey("UpdateDailyShop").OnClientEvent:Connect(getDailyShop)
local text_5 = ""
popup_container.YesButton.MouseButton1Click:Connect(function()
    if text_5 ~= "" then
        local invoke_server_result = remote_function_8:InvokeServer(text_5)
        popup_container.Visible = false
        if invoke_server_result == "AlreadyOwned" then
            notification("ITEM ALREADY OWNED.")
        elseif invoke_server_result == "NotEnoughCoins" then
            notification("NOT ENOUGH COINS.")
        elseif invoke_server_result ~= "Failed" then
            local clone_3 = game.ReplicatedStorage.UISounds.mvm_money_pickup:Clone()
            clone_3.Parent = game.Workspace
            clone_3:Play()
            game.Debris:AddItem(clone_3, 3)
            if text_5 ~= "A RANDOM AURA" and text_5 ~= "A RANDOM EYE" and text_5 ~= "A RANDOM CELEBRATION" then
                local clone_4 = game.ReplicatedStorage.UISounds.Item_Box_Get2:Clone()
                clone_4.Parent = game.Workspace
                clone_4:Play()
                game.Debris:AddItem(clone_4, 3)
            end
        else
            notification("AN UNEXPECTED ERROR HAS OCCURED.")
        end
        text_5 = ""
    end
end)
popup_container.NoButton.MouseButton1Click:Connect(function()
    if text_5 == "" then
        return
    end
    text_5 = ""
    popup_container.Visible = false
end)

function popup(argument, argument_2)
    text_5 = argument
    popup_container.PurchaseText.Text = "WOULD YOU LIKE TO PURCHASE ["
        .. string.upper(text_5)
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
remote_event_4.OnClientEvent:Connect(function()
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
    local text_6 = store_frame.GiftRecipient.Text
    for _, player in pairs(game.Players:GetPlayers()) do
        if string.sub(player.Name, 0, #text_6) ~= text_6 then
            continue
        end
        store_frame.GiftRecipient.Text = player.Name
        return
    end
    store_frame.GiftRecipient.Text = ""
end)
robux_shop_frame.Coins1.Purchase.MouseButton1Click:Connect(function()
    remote_event_4:FireServer("Coin1", store_frame.GiftRecipient.Text)
end)
robux_shop_frame["Jersey Sponsers"].Purchase.MouseButton1Click:Connect(function()
    remote_event_4:FireServer("Jersery Sponsers", store_frame.GiftRecipient.Text)
end)
robux_shop_frame.Coins2.Purchase.MouseButton1Click:Connect(function()
    remote_event_4:FireServer("Coin2", store_frame.GiftRecipient.Text)
end)
robux_shop_frame.Coins3.Purchase.MouseButton1Click:Connect(function()
    remote_event_4:FireServer("Coin3", store_frame.GiftRecipient.Text)
end)
robux_shop_frame.Coins4.Purchase.MouseButton1Click:Connect(function()
    remote_event_4:FireServer("Coin4", store_frame.GiftRecipient.Text)
end)
robux_shop_frame.SkipRolls.Purchase.MouseButton1Click:Connect(function()
    remote_event_4:FireServer("skipRolls", store_frame.GiftRecipient.Text)
end)
robux_shop_frame.FilmMaker.Purchase.MouseButton1Click:Connect(function()
    remote_event_4:FireServer("filmMaker", store_frame.GiftRecipient.Text)
end)
robux_shop_frame.PreferredJerseyNumber.Purchase.MouseButton1Click:Connect(function()
    remote_event_4:FireServer("prefNumber", store_frame.GiftRecipient.Text)
end)
robux_shop_frame.AccessoryColor.Purchase.MouseButton1Click:Connect(function()
    remote_event_4:FireServer("customAccessoryColor", store_frame.GiftRecipient.Text)
end)
robux_shop_frame.PSPlus.Purchase.MouseButton1Click:Connect(function()
    remote_event_4:FireServer("PS+", store_frame.GiftRecipient.Text)
end)
local codes_frame = script.Parent.CodesFrame
menu_buttons.CodesButton.MouseButton1Click:Connect(function()
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
    if not (#code_box.Text > 0) then
        return
    end
    if enabled_4 == false then
        enabled_4 = true
        task.delay(0.5, function()
            enabled_4 = false
        end)
        local invoke_server_result = remote_function_9:InvokeServer(code_box.Text)
        code_box.Text = ""
        if invoke_server_result == "codeExpired" then
            showMessage("CODE HAS EXPIRED.")
            local clone_3 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
            clone_3.Parent = game.Workspace
            clone_3:Play()
            game.Debris:AddItem(clone_3, 3)
        elseif invoke_server_result == "codeSubmitted" then
            showMessage("CODE SUBMITTED. ENJOY!")
            local clone_4 = game.ReplicatedStorage.UISounds.mvm_money_pickup:Clone()
            clone_4.Parent = game.Workspace
            clone_4:Play()
            game.Debris:AddItem(clone_4, 3)
        elseif invoke_server_result == "codeInUse" then
            showMessage("CODE HAS ALREADY BEEN USED.")
            local clone_5 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
            clone_5.Parent = game.Workspace
            clone_5:Play()
            game.Debris:AddItem(clone_5, 3)
        elseif invoke_server_result ~= "promptGroup" then
            showMessage("CODE NOT FOUND.")
            local clone_6 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
            clone_6.Parent = game.Workspace
            clone_6:Play()
            game.Debris:AddItem(clone_6, 3)
        else
            showMessage("JOIN THE GROUP TO USE CODES!!")
            local clone_7 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
            clone_7.Parent = game.Workspace
            clone_7:Play()
            game.Debris:AddItem(clone_7, 3)
            game.GroupService:PromptJoinAsync(33283788)
        end
    end
end)

local function check_is_weekend()
    local wday_2 = os.date("!*t").wday
    if wday_2 ~= 1 and wday_2 ~= 6 and wday_2 ~= 7 then
        return false
    end
    return true
end

local wday = os.date("!*t").wday
local enabled_5
if wday ~= 1 and wday ~= 6 and wday ~= 7 then
    enabled_5 = false
else
    enabled_5 = true
end
if enabled_5 then
    script.Parent["2xcoins"].Visible = true
else
    script.Parent["2xcoins"].Visible = false
end
task.spawn(function()
    while wait(30) do
        local wday_2 = os.date("!*t").wday
        local enabled_6
        if wday_2 ~= 1 and wday_2 ~= 6 and wday_2 ~= 7 then
            enabled_6 = false
        else
            enabled_6 = true
        end
        if enabled_6 then
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
