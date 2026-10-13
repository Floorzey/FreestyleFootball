local mode = {}
local local_player = game:GetService("Players").LocalPlayer
local mouse = local_player:GetMouse()
local size420x420 = Enum.ThumbnailSize.Size420x420
local head_shot = Enum.ThumbnailType.HeadShot
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key_handler_service = knit.GetService("KeyHandlerService")
local remote_event = key_handler_service:GetKey("Vote")
local key = key_handler_service:GetKey("VoteClient")

local function get_mouse_pos()
    return UDim2.fromOffset(mouse.X, mouse.Y)
end

local function div_udim2(argument, argument_2)
    return (
        UDim2.new(
            argument.X.Scale / argument_2,
            argument.X.Offset / argument_2,
            argument.Y.Scale / argument_2,
            argument.Y.Offset / argument_2
        )
    )
end

function mode.Load(self, player, vote_name, position)
    print("load")
    if
        local_player.PlayerGui.Menu
            :WaitForChild("ModeSelectFrame")
            :WaitForChild("SelectionFrame")
            :WaitForChild("Folder")
            :FindFirstChild(player.Name)
    then
        local_player.PlayerGui.Menu
            :WaitForChild("ModeSelectFrame")
            :WaitForChild("SelectionFrame")
            :WaitForChild("Folder")
            :FindFirstChild(player.Name)
            :Destroy()
    end
    local clone = local_player.PlayerGui.Menu
        :WaitForChild("ModeSelectFrame")
        :WaitForChild("SelectionFrame")
        :WaitForChild("Folder")
        :WaitForChild("Template")
        :Clone()
    clone.Parent = local_player.PlayerGui.Menu:FindFirstChild("Folder", true)
    clone.Name = player.Name
    clone.Image = game.Players:GetUserThumbnailAsync(player.UserId, head_shot, size420x420)
    local mouse_location_offset = game:GetService("UserInputService"):GetMouseLocation()
        - clone.Parent.Parent.AbsolutePosition
    if position ~= nil then
        clone.Position = position
    else
        clone.Position = UDim2.fromOffset(mouse_location_offset.X, mouse_location_offset.Y - 50)
    end
    clone.Rotation = math.random(0, 360)
    if player == local_player then
        remote_event:FireServer({
            VoteName = vote_name,
            Pos = UDim2.fromOffset(mouse_location_offset.X, mouse_location_offset.Y - 50),
        })
    end
    clone.Visible = true
    clone.UIStroke.Color =
        Color3.new(Random.new():NextNumber(0, 1), Random.new():NextNumber(0, 1), Random.new():NextNumber(0, 1))
    local tween_info = TweenInfo.new(0.1, Enum.EasingStyle.Exponential)
    local tween_properties = {}
    tween_properties.Size = UDim2.new(0, 25, 0, 25)
    game.TweenService:Create(clone, tween_info, tween_properties):Play()
    task.wait(0.1)
    local tween_info_2 = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tween_properties_2 = {}
    tween_properties_2.Size = UDim2.new(0, 50, 0, 50)
    game.TweenService:Create(clone, tween_info_2, tween_properties_2):Play()
end

function mode.init()
    local selection_frame = local_player.PlayerGui.Menu:WaitForChild("ModeSelectFrame"):WaitForChild("SelectionFrame")
    selection_frame.GoldenGoal.MouseButton1Click:Connect(function()
        if game.ReplicatedStorage.hasGameStarted.Value then
            return
        end
        mode:Load(local_player, "GoldenGoal")
    end)
    selection_frame.Penalties.MouseButton1Click:Connect(function()
        if game.ReplicatedStorage.hasGameStarted.Value then
            return
        end
        mode:Load(local_player, "Penalties")
    end)
    key.OnClientEvent:Connect(function(player, argument)
        print("recv on client")
        if not argument.VoteName or not argument.Pos then
            return
        end
        mode:Load(player, argument.VoteName, argument.Pos)
    end)
    game.ReplicatedStorage:WaitForChild("extraData"):GetAttributeChangedSignal("PenVotes"):Connect(function()
        selection_frame.Penalties.plrCount.Text =
            game.ReplicatedStorage:WaitForChild("extraData"):GetAttribute("PenVotes")
    end)
    game.ReplicatedStorage:WaitForChild("extraData"):GetAttributeChangedSignal("GolGoalVotes"):Connect(function()
        selection_frame.GoldenGoal.plrCount.Text =
            game.ReplicatedStorage:WaitForChild("extraData"):GetAttribute("GolGoalVotes")
    end)
    game.ReplicatedStorage.hasGameStarted.Changed:Connect(function()
        if not game.ReplicatedStorage.hasGameStarted.Value then
            return
        end
        for _, instance in
            local_player.PlayerGui.Menu
                :WaitForChild("ModeSelectFrame")
                :WaitForChild("SelectionFrame")
                :WaitForChild("Folder")
                :GetChildren()
        do
            if instance.Name ~= "Template" then
                instance:Destroy()
            end
        end
    end)
end

mode.init()

return mode
