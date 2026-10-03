--[[
    Script Path: Game/StarterPlayer/StarterCharacterScripts/ClientCamera
    Class: LocalScript
    Time: 2026-10-03 12:27:04
--]]

local u1 = game:GetService("Players").LocalPlayer.Character or (game:GetService("Players").LocalPlayer.CharacterAdded:Wait())
local UserInputService_upv_1 = game:GetService("UserInputService")
local RunService_1 = game:GetService("RunService")
local CurrentCamera_upv_1 = workspace.CurrentCamera
CurrentCamera_upv_1.CameraSubject = u1:WaitForChild("Neck_CameraSubject")
if CurrentCamera_upv_1.CameraType ~= Enum.CameraType.Custom then
    CurrentCamera_upv_1.CameraType = Enum.CameraType.Custom
end
local Status_upv_1 = u1.Status
local _ = game.Players.LocalPlayer:GetMouse()
local CameraShaker_1 = require(game:GetService("ReplicatedStorage").Modules.CameraShaker)
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
local v1 = Knit_1.GetService("KeyHandlerService")
local u2 = false
UserSettings().GameSettings.RotationType = Enum.RotationType.MovementRelative
for v10, value_1 in u1:GetDescendants() do
    local v2 = value_1:IsA("BasePart")
    if v2 then
        value_1.LocalTransparencyModifier = 0
    end
end
local function camShakeHandler(a1)
    --[[
      name: camShakeHandler
      line: 21
      upvalues:
        CurrentCamera_upv_1 (copy, index: 1)
    ]]
    if a1 == CFrame.new(0, 0, 0) then
        return
    end
    CurrentCamera_upv_1.CFrame = CurrentCamera_upv_1.CFrame * a1
end
local u3 = CameraShaker_1.new(Enum.RenderPriority.Camera.Value + 1, camShakeHandler)
local tbl_upv_1 = {}
tbl_upv_1["Right Shoulder"] = Vector3.new(2, 0, 0)
tbl_upv_1["Left Shoulder"] = Vector3.new(-2, 0, 0)
tbl_upv_1["Above Head"] = Vector3.new(0, 2, 0)
u3:Start()
function input_Began(a1, a2)
    --[[
      name: input_Began
      line: 39
      upvalues:
        u2 (ref,  index: 1)
        UserInputService_upv_1 (copy, index: 2)
        u1 (ref,  index: 3)
        tbl_upv_1 (copy, index: 4)
    ]]
    if a2 == true then
        return
    end
    if a1.KeyCode == Enum.KeyCode.LeftControl or a1.KeyCode == Enum.KeyCode.DPadDown then
        u2 = not u2
        if u2 ~= true then
            UserInputService_upv_1.MouseBehavior = Enum.MouseBehavior.Default
            if u1.Humanoid ~= nil then
                local tbl_2 = {CameraOffset = Vector3.new(0, 0, 0)}
                game:GetService("TweenService"):Create(u1.Humanoid, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), tbl_2):Play()
            end
        else
            UserInputService_upv_1.MouseBehavior = Enum.MouseBehavior.LockCenter
            if u1.Humanoid ~= nil then
                local TweenService_1 = game:GetService("TweenService")
                local Humanoid_1 = u1.Humanoid
                local v3 = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                local tbl_3 = {}
                tbl_3.CameraOffset = tbl_upv_1[game.Players.LocalPlayer.Settings.Misc.POV.Value]
                TweenService_1:Create(Humanoid_1, v3, tbl_3):Play()
                return
            end
        end
    end
end
local u4 = tick()
game.ReplicatedStorage.MobileControlEvents.shiftLock.Event:Connect(
    function()
        --[[
          line: 60
        ]]
        input_Began({KeyCode = Enum.KeyCode.LeftControl}, false)
    end
)
UserInputService_upv_1.InputBegan:Connect(input_Began)
UserInputService_upv_1.MouseBehavior = Enum.MouseBehavior.Default
local u5 = false
local u6 = v1:GetKey("ac")
RunService_1.RenderStepped:Connect(
    function()
        --[[
          line: 70
          upvalues:
            CurrentCamera_upv_1 (copy, index: 1)
            u4 (ref,  index: 2)
            Status_upv_1 (ref,  index: 3)
            u6 (copy, index: 4)
            u2 (ref,  index: 5)
            u5 (ref,  index: 6)
            u1 (ref,  index: 7)
            UserInputService_upv_1 (copy, index: 8)
        ]]
        local CameraSubject_1 = CurrentCamera_upv_1.CameraSubject
        local v4 = CameraSubject_1:IsA("Humanoid")
        if v4 then
            CameraSubject_1 = CameraSubject_1.Parent.HumanoidRootPart
        end
        local Magnitude_1 = (CameraSubject_1.Position - CurrentCamera_upv_1.CFrame.Position).Magnitude
        if Magnitude_1 > 80 and tick() - u4 > 10 and not (Status_upv_1:FindFirstChild("CameraOverride")) then
            u4 = tick()
            u6:FireServer()
        end
        if Magnitude_1 < 1 then
            if not (u2) then
                u5 = true
                input_Began({KeyCode = Enum.KeyCode.LeftControl}, false)
            end
            CurrentCamera_upv_1.CFrame = CurrentCamera_upv_1.CFrame * CFrame.new(0, 0.35, -0.6)
            if not (CurrentCamera_upv_1.CameraSubject:IsA("Humanoid")) then
                CurrentCamera_upv_1.CameraSubject = u1.Head
            end
            if u1.Head.Transparency ~= 1 then
                for _, value_2 in pairs(u1:GetDescendants()) do
                    if value_2:IsA("BasePart") and (value_2.Name == "Head" or value_2.Parent:isA("Accessory") or value_2:FindFirstChild("HeadWeld")) then
                        value_2:SetAttribute("OldTransparency", value_2.Transparency)
                        value_2.Transparency = 1
                    end
                end
            end
            for _, value_3 in pairs(u1:GetDescendants()) do
                if value_3:IsA("ParticleEmitter") or value_3:IsA("Trail") then
                    value_3:SetAttribute("wasEnabled", value_3.Enabled)
                    value_3.Enabled = false
                end
            end
            if UserInputService_upv_1:IsKeyDown(Enum.KeyCode.LeftAlt) then
                UserInputService_upv_1.MouseBehavior = Enum.MouseBehavior.Default
                game.Players.LocalPlayer.PlayerGui.MouseIcon.MouseIcon.Visible = false
                UserInputService_upv_1.MouseIconEnabled = true
            else
                UserInputService_upv_1.MouseIconEnabled = false
                if u2 ~= true then
                    UserInputService_upv_1.MouseBehavior = Enum.MouseBehavior.Default
                    game.Players.LocalPlayer.PlayerGui.MouseIcon.MouseIcon.Visible = false
                else
                    game.Players.LocalPlayer.PlayerGui.MouseIcon.MouseIcon.Visible = true
                    UserInputService_upv_1.MouseBehavior = Enum.MouseBehavior.LockCenter
                end
            end
        else
            if game.Players.LocalPlayer.PlayerGui:FindFirstChild("MouseIcon") then
                if u2 == true then
                    game.Players.LocalPlayer.PlayerGui.MouseIcon.MouseIcon.Visible = true
                elseif u2 == false then
                    game.Players.LocalPlayer.PlayerGui.MouseIcon.MouseIcon.Visible = false
                end
            end
            UserInputService_upv_1.MouseIconEnabled = not u2
            if not (CurrentCamera_upv_1.CameraSubject:IsA("Humanoid")) then
                CurrentCamera_upv_1.CameraSubject = u1.Neck_CameraSubject
            end
            if u1.Head.Transparency == 1 then
                if u5 == true then
                    u5 = false
                    input_Began({KeyCode = Enum.KeyCode.LeftControl}, false)
                end
                for _, value_4 in pairs(u1:GetDescendants()) do
                    if value_4:IsA("ParticleEmitter") or value_4:IsA("Trail") then
                        value_4.Enabled = value_4:GetAttribute("wasEnabled") or false
                    end
                    if (value_4.Name == "Head" or value_4.Parent:isA("Accessory") or value_4:FindFirstChild("HeadWeld")) and value_4:IsA("BasePart") then
                        value_4.Transparency = value_4:GetAttribute("OldTransparency")
                    end
                end
            end
        end
        local v5 = u1:FindFirstChildOfClass("Humanoid")
        local HumanoidRootPart_1 = u1:FindFirstChild("HumanoidRootPart")
        if v5 and HumanoidRootPart_1 and not (Status_upv_1:FindFirstChild("CameraOverride")) then
            v5.AutoRotate = not u2
            if Magnitude_1 > 1 then
                CurrentCamera_upv_1.CFrame = CurrentCamera_upv_1.CFrame * CFrame.new(v5.CameraOffset.X, 0.5 + v5.CameraOffset.Y, 0)
            end
        end
        if not u2 or (Status_upv_1:FindFirstChild("CameraLocked")) or (Status_upv_1:FindFirstChild("Ragdoll")) or (Status_upv_1:FindFirstChild("Dead")) or not v5 or not HumanoidRootPart_1 then
            return
        end
        if v5:GetState() ~= Enum.HumanoidStateType.Dead then
            local _, v6 = CurrentCamera_upv_1.CFrame:ToOrientation()
            HumanoidRootPart_1.CFrame = CFrame.new(HumanoidRootPart_1.Position) * CFrame.Angles(0, v6, 0)
        end
    end
)
game.ReplicatedStorage.CameraShake.Event:Connect(
    function(a1)
        --[[
          line: 172
          upvalues:
            u3 (copy, index: 1)
        ]]
        if game.Players.LocalPlayer.Settings.CameraShake.Value == true then
            return
        end
        u3:ShakeOnce(a1.magnitude or 0, a1.roughness or 0, a1.fadeIn or 0, a1.fadeOut or 0, nil, Vector3.new(0, 0, 0))
    end
)
game.Players.LocalPlayer.CharacterAdded:Connect(
    function(a1)
        --[[
          line: 183
          upvalues:
            u1 (ref,  index: 1)
            Status_upv_1 (ref,  index: 2)
            u2 (ref,  index: 3)
            UserInputService_upv_1 (copy, index: 4)
            CurrentCamera_upv_1 (copy, index: 5)
        ]]
        u1 = a1
        Status_upv_1 = u1.Status
        u2 = false
        UserInputService_upv_1.MouseBehavior = Enum.MouseBehavior.Default
        CurrentCamera_upv_1.CameraSubject = a1:WaitForChild("Neck_CameraSubject")
    end
)
local Players_upv_1 = game:GetService("Players")
local TweenService_upv_2 = game:GetService("TweenService")
local LocalPlayer_upv_1 = Players_upv_1.LocalPlayer
local u7 = nil
local u8 = nil
local u9 = nil
function HandleCharacter(a1)
    --[[
      name: HandleCharacter
      line: 197
      upvalues:
        u7 (ref, index: 1)
        u8 (ref, index: 2)
        u9 (ref, index: 3)
    ]]
    local HumanoidRootPart_2 = a1:WaitForChild("HumanoidRootPart")
    local v7 = a1.Torso:FindFirstChild("Neck", true)
    u7 = HumanoidRootPart_2
    u8 = v7
    while not (u8) do
        wait()
        u8 = a1:FindFirstChild("Neck", true)
    end
    while not (a1:FindFirstChildOfClass("Humanoid")) do
        wait()
    end
    local v8 = a1:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6
    u9 = v8
end
local v9 = LocalPlayer_upv_1.Character or (LocalPlayer_upv_1.CharacterAdded:Wait())
HandleCharacter(v9)
LocalPlayer_upv_1.CharacterAdded:Connect(HandleCharacter)
local HeadLookRemote_1 = game.ReplicatedStorage:WaitForChild("HeadLookRemote")
HeadLookRemote_1.OnClientEvent:Connect(
    function(a1)
        --[[
          line: 215
          upvalues:
            TweenService_upv_2 (copy, index: 1)
        ]]
        for _, value_5 in ipairs(a1) do
            if not (value_5[1].Character:FindFirstChild("Torso")) then
                continue
            end
            local v10 = value_5[1].Character and (value_5[1].Character.Torso:FindFirstChild("Neck", true))
            if v10 then
                local v11 = TweenInfo.new(0.05, Enum.EasingStyle.Linear)
                local tbl_4 = {}
                tbl_4.C1 = value_5[2]
                TweenService_upv_2:Create(v10, v11, tbl_4):Play()
            end
        end
    end
)
game:GetService("RunService").Stepped:Connect(
    function()
        --[[
          line: 225
          upvalues:
            u7 (ref,  index: 1)
            u8 (ref,  index: 2)
            LocalPlayer_upv_1 (copy, index: 3)
            Players_upv_1 (copy, index: 4)
        ]]
        if u7 and u8 and workspace.CurrentCamera.CameraSubject and workspace.CurrentCamera.CameraSubject.Parent == LocalPlayer_upv_1.Character then
            local unit_1 = u7.CFrame:toObjectSpace(workspace.CurrentCamera.CFrame).lookVector.unit
            u8.C1 = CFrame.new(u8.C1.p) * CFrame.Angles(0, math.asin(unit_1.x), 0) * CFrame.Angles(-1.5707963267948966 + -math.asin(unit_1.y), 0, math.pi)
        end
        for _, value_6 in ipairs(Players_upv_1:GetPlayers()) do
            if not (value_6.Character) or not (value_6.Character:FindFirstChild("Head")) then
                continue
            end
            local v12 = value_6.Character:FindFirstChildOfClass("Humanoid")
            if not (v12) then
                continue
            end
            if v12.Health ~= 0 then
                value_6.Character.Head.CanCollide = false
            end
        end
    end
)
while wait(0.05) do
    if not (u8) or Last == u8.C1 then
        continue
    end
    if not (game.ReplicatedStorage.Modules.client.cutscene:GetAttribute("StopHead")) then
        HeadLookRemote_1:FireServer(u8.C1)
        Last = u8.C1
    end
end