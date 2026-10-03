--[[
    Script Path: Game/ReplicatedStorage/Modules/client/mode
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local tbl_upv_1 = {}
local LocalPlayer_upv_1 = game:GetService("Players").LocalPlayer
local u1 = LocalPlayer_upv_1:GetMouse()
local Size420x420_upv_1 = Enum.ThumbnailSize.Size420x420
local HeadShot_upv_1 = Enum.ThumbnailType.HeadShot
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
local v1 = Knit_1.GetService("KeyHandlerService")
local u2 = v1:GetKey("Vote")
local u3 = v1:GetKey("VoteClient")
local function getMousePos()
    --[[
      name: getMousePos
      line: 20
      upvalues:
        u1 (copy, index: 1)
    ]]
    return UDim2.fromOffset(u1.X, u1.Y)
end
local function divUdim2(a1, a2)
    --[[
      name: divUdim2
      line: 24
    ]]
    return (UDim2.new(a1.X.Scale / a2, a1.X.Offset / a2, a1.Y.Scale / a2, a1.Y.Offset / a2))
end
function tbl_upv_1.Load(a1, a2, a3, a4)
    --[[
      name: Load
      line: 37
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        HeadShot_upv_1 (copy, index: 2)
        Size420x420_upv_1 (copy, index: 3)
        u2 (copy, index: 4)
    ]]
    print("load")
    if LocalPlayer_upv_1.PlayerGui.Menu:WaitForChild("ModeSelectFrame"):WaitForChild("SelectionFrame"):WaitForChild("Folder"):FindFirstChild(a2.Name) then
        LocalPlayer_upv_1.PlayerGui.Menu:WaitForChild("ModeSelectFrame"):WaitForChild("SelectionFrame"):WaitForChild("Folder"):FindFirstChild(a2.Name):Destroy()
    end
    local v2 = LocalPlayer_upv_1.PlayerGui.Menu:WaitForChild("ModeSelectFrame"):WaitForChild("SelectionFrame"):WaitForChild("Folder"):WaitForChild("Template"):Clone()
    v2.Parent = LocalPlayer_upv_1.PlayerGui.Menu:FindFirstChild("Folder", true)
    v2.Name = a2.Name
    v2.Image = game.Players:GetUserThumbnailAsync(a2.UserId, HeadShot_upv_1, Size420x420_upv_1)
    local v3 = game:GetService("UserInputService"):GetMouseLocation() - v2.Parent.Parent.AbsolutePosition
    if a4 ~= nil then
        v2.Position = a4
    else
        v2.Position = UDim2.fromOffset(v3.X, v3.Y - 50)
    end
    v2.Rotation = math.random(0, 360)
    if a2 == LocalPlayer_upv_1 then
        u2:FireServer({VoteName = a3, Pos = UDim2.fromOffset(v3.X, v3.Y - 50)})
    end
    v2.Visible = true
    v2.UIStroke.Color = Color3.new(Random.new():NextNumber(0, 1), Random.new():NextNumber(0, 1), Random.new():NextNumber(0, 1))
    local v4 = TweenInfo.new(0.1, Enum.EasingStyle.Exponential)
    local tbl_2 = {}
    tbl_2.Size = UDim2.new(0, 25, 0, 25)
    game.TweenService:Create(v2, v4, tbl_2):Play()
    task.wait(0.1)
    local v5 = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tbl_3 = {}
    tbl_3.Size = UDim2.new(0, 50, 0, 50)
    game.TweenService:Create(v2, v5, tbl_3):Play()
end
function tbl_upv_1.init()
    --[[
      name: init
      line: 79
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        tbl_upv_1 (copy, index: 2)
        u3 (copy, index: 3)
    ]]
    local SelectionFrame_upv_1 = LocalPlayer_upv_1.PlayerGui.Menu:WaitForChild("ModeSelectFrame"):WaitForChild("SelectionFrame")
    SelectionFrame_upv_1.GoldenGoal.MouseButton1Click:Connect(
        function()
            --[[
              line: 82
              upvalues:
                tbl_upv_1 (copy, index: 1)
                LocalPlayer_upv_1 (copy, index: 2)
            ]]
            if game.ReplicatedStorage.hasGameStarted.Value then
                return
            end
            tbl_upv_1:Load(LocalPlayer_upv_1, "GoldenGoal")
        end
    )
    SelectionFrame_upv_1.Penalties.MouseButton1Click:Connect(
        function()
            --[[
              line: 89
              upvalues:
                tbl_upv_1 (copy, index: 1)
                LocalPlayer_upv_1 (copy, index: 2)
            ]]
            if game.ReplicatedStorage.hasGameStarted.Value then
                return
            end
            tbl_upv_1:Load(LocalPlayer_upv_1, "Penalties")
        end
    )
    u3.OnClientEvent:Connect(
        function(a1, a2)
            --[[
              line: 96
              upvalues:
                tbl_upv_1 (copy, index: 1)
            ]]
            print("recv on client")
            if not a2.VoteName or not a2.Pos then
                return
            end
            tbl_upv_1:Load(a1, a2.VoteName, a2.Pos)
        end
    )
    game.ReplicatedStorage:WaitForChild("extraData"):GetAttributeChangedSignal("PenVotes"):Connect(
        function()
            --[[
              line: 104
              upvalues:
                SelectionFrame_upv_1 (copy, index: 1)
            ]]
            SelectionFrame_upv_1.Penalties.plrCount.Text = game.ReplicatedStorage:WaitForChild("extraData"):GetAttribute("PenVotes")
        end
    )
    game.ReplicatedStorage:WaitForChild("extraData"):GetAttributeChangedSignal("GolGoalVotes"):Connect(
        function()
            --[[
              line: 108
              upvalues:
                SelectionFrame_upv_1 (copy, index: 1)
            ]]
            SelectionFrame_upv_1.GoldenGoal.plrCount.Text = game.ReplicatedStorage:WaitForChild("extraData"):GetAttribute("GolGoalVotes")
        end
    )
    game.ReplicatedStorage.hasGameStarted.Changed:Connect(
        function()
            --[[
              line: 112
              upvalues:
                LocalPlayer_upv_1 (copy, index: 1)
            ]]
            if not game.ReplicatedStorage.hasGameStarted.Value then
                return
            end
            for _, value_1 in LocalPlayer_upv_1.PlayerGui.Menu:WaitForChild("ModeSelectFrame"):WaitForChild("SelectionFrame"):WaitForChild("Folder"):GetChildren() do
                if value_1.Name ~= "Template" then
                    value_1:Destroy()
                end
            end
        end
    )
end
tbl_upv_1.init()
return tbl_upv_1