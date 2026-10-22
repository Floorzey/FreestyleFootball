--[[
    Script Path: Game/ReplicatedStorage/Modules/client/cutscene
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local tbl_1 = {}
local RunService_upv_1 = game:GetService("RunService")
local LocalPlayer_upv_1 = game.Players.LocalPlayer
local u1 = LocalPlayer_upv_1.Character or (LocalPlayer_upv_1.CharacterAdded:Wait())
local CurrentCamera_upv_1 = workspace.CurrentCamera
local CamRigWithLetterBox_upv_1 = script:WaitForChild("CamRigWithLetterBox")
local u2 = nil
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
local u3 = Knit_1.GetService("KeyHandlerService"):GetKey("cutscene")
LocalPlayer_upv_1.CharacterAdded:Connect(
    function(a1)
        --[[
          line: 17
          upvalues:
            u1 (ref, index: 1)
        ]]
        u1 = a1
    end
)
local tbl_upv_2 = {}
tbl_upv_2.NagiU20 = function(a1)
    --[[
      line: 24
      upvalues:
        CamRigWithLetterBox_upv_1 (copy, index: 1)
        LocalPlayer_upv_1 (copy, index: 2)
        CurrentCamera_upv_1 (copy, index: 3)
        u2 (ref,  index: 4)
        u1 (ref,  index: 5)
        RunService_upv_1 (copy, index: 6)
    ]]
    local u4 = CamRigWithLetterBox_upv_1:Clone()
    u4.Parent = workspace
    u4.RootPart.RootPart.Part0 = a1.HumanoidRootPart
    u4.letterboxbot.Transparency = 1
    u4.letterboxtop.Transparency = 1
    script:SetAttribute("StopHead", true)
    local tbl_upv_3 = {}
    local u5 = script.VFX.NagiU20.breath:Clone()
    u5.Parent = a1.Head
    local u6 = script.VFX.NagiU20.Vignette:Clone()
    u6.Parent = LocalPlayer_upv_1.PlayerGui.HUD
    for _, value_1 in script.VFX.NagiU20.HumanoidRootPart:GetChildren() do
        local v1 = value_1:Clone()
        v1.Parent = a1.HumanoidRootPart
        v1[v1.Name].Part0 = a1.HumanoidRootPart
        tbl_upv_3[v1.Name] = v1
    end
    local v2 = a1.Humanoid.Animator:LoadAnimation(script.Animations.NagiU20.Player)
    local v3 = u4.AnimationController.Animator:LoadAnimation(script.Animations.NagiU20.Camera)
    v3:Play()
    v2.Priority = Enum.AnimationPriority.Action4
    v2:Play()
    CurrentCamera_upv_1.CameraType = Enum.CameraType.Scriptable
    CurrentCamera_upv_1.CameraSubject = nil
    task.delay(
        0.333,
        function()
            --[[
              line: 58
              upvalues:
                tbl_upv_3 (copy, index: 1)
            ]]
            tbl_upv_3.Sweat.SweatP:Emit(6)
        end
    )
    task.delay(
        0.983,
        function()
            --[[
              line: 64
              upvalues:
                tbl_upv_3 (copy, index: 1)
            ]]
            for _, value_2 in ipairs(tbl_upv_3.NagiVFX:GetDescendants()) do
                if value_2:IsA("ParticleEmitter") then
                    value_2.Enabled = true
                end
            end
        end
    )
    task.delay(
        4.65,
        function()
            --[[
              line: 74
              upvalues:
                tbl_upv_3 (copy, index: 1)
            ]]
            for _, value_3 in ipairs(tbl_upv_3.NagiVFX:GetDescendants()) do
                if value_3:IsA("ParticleEmitter") then
                    value_3.Enabled = false
                end
            end
        end
    )
    task.delay(
        4.7,
        function()
            --[[
              line: 84
              upvalues:
                tbl_upv_3 (copy, index: 1)
            ]]
            for _, value_4 in ipairs(tbl_upv_3.NagiVFXBeam:GetDescendants()) do
                if value_4:IsA("Beam") then
                    value_4.Enabled = true
                end
            end
        end
    )
    task.delay(
        7.333,
        function()
            --[[
              line: 94
              upvalues:
                u5 (copy, index: 1)
            ]]
            for _, value_5 in pairs(u5:GetDescendants()) do
                if value_5:IsA("ParticleEmitter") then
                    value_5:Emit(value_5:GetAttribute("EmitCount"))
                end
            end
        end
    )
    task.delay(
        10,
        function()
            --[[
              line: 102
              upvalues:
                tbl_upv_3 (copy, index: 1)
            ]]
            for _, value_6 in ipairs(tbl_upv_3.NagiVFXBeam:GetDescendants()) do
                if value_6:IsA("Beam") then
                    value_6.Enabled = false
                end
            end
        end
    )
    v3.Stopped:Once(
        function()
            --[[
              line: 112
              upvalues:
                u2 (ref,  index: 1)
                u1 (ref,  index: 2)
                u6 (copy, index: 3)
                u5 (copy, index: 4)
                tbl_upv_3 (copy, index: 5)
                CurrentCamera_upv_1 (copy, index: 6)
                u4 (copy, index: 7)
                a1 (copy, index: 8)
                LocalPlayer_upv_1 (copy, index: 9)
            ]]
            if u2 then
                u2:Disconnect()
                u2 = nil
            end
            script:SetAttribute("StopHead", false)
            u1.Humanoid.AutoRotate = true
            u6:Destroy()
            u5:Destroy()
            for _, value_7 in tbl_upv_3 do
                value_7:Destroy()
            end
            CurrentCamera_upv_1.CameraType = Enum.CameraType.Custom
            u4:Destroy()
            CurrentCamera_upv_1.FieldOfView = 70
            if a1 == LocalPlayer_upv_1.Character then
                CurrentCamera_upv_1.CameraSubject = a1.Neck_CameraSubject
            else
                CurrentCamera_upv_1.CameraSubject = a1.Humanoid
            end
        end
    )
    local u7 = 0
    local v4 = RunService_upv_1.RenderStepped:Connect(
        function()
            --[[
              line: 141
              upvalues:
                u1 (ref,  index: 1)
                a1 (copy, index: 2)
                CurrentCamera_upv_1 (copy, index: 3)
                u4 (copy, index: 4)
                u7 (ref,  index: 5)
            ]]
            u1.Humanoid.AutoRotate = false
            a1.Torso.Neck.C1 = script.Neck.C1
            if CurrentCamera_upv_1.CameraSubject ~= nil then
                CurrentCamera_upv_1.CameraSubject = nil
            end
            CurrentCamera_upv_1.CFrame = u4.camera.CFrame
            if script.VFX.NagiU20.FOV:FindFirstChild(tostring(u7)) then
                CurrentCamera_upv_1.FieldOfView = script.VFX.NagiU20.FOV:FindFirstChild(tostring(u7)).Value
            end
            u7 = u7 + 1
        end
    )
    u2 = v4
end
tbl_upv_2.NagiNEL = function(a1)
    --[[
      line: 160
      upvalues:
        CamRigWithLetterBox_upv_1 (copy, index: 1)
        CurrentCamera_upv_1 (copy, index: 2)
        u2 (ref,  index: 3)
        u1 (ref,  index: 4)
        RunService_upv_1 (copy, index: 5)
    ]]
    local u8 = CamRigWithLetterBox_upv_1:Clone()
    u8.Parent = workspace
    u8.RootPart.RootPart.Part0 = a1.HumanoidRootPart
    u8.letterboxbot.Transparency = 1
    u8.letterboxtop.Transparency = 1
    script:SetAttribute("StopHead", true)
    local u9 = script.VFX.NagiNEL.NagiVFX:Clone()
    u9.Parent = a1.HumanoidRootPart
    u9.HumanoidRootPart.Part1 = u9.Parent
    local v5 = a1.Humanoid.Animator:LoadAnimation(script.Animations.NagiNEL.Player)
    local v6 = u8.AnimationController.Animator:LoadAnimation(script.Animations.NagiNEL.Camera)
    v6:Play()
    v5.Priority = Enum.AnimationPriority.Action4
    v5:Play()
    CurrentCamera_upv_1.CameraType = Enum.CameraType.Scriptable
    CurrentCamera_upv_1.CameraSubject = nil
    task.delay(
        1.25,
        function()
            --[[
              line: 182
              upvalues:
                a1 (copy, index: 1)
            ]]
            for _, value_8 in pairs(a1.HumanoidRootPart.NagiVFX:GetDescendants()) do
                if value_8.ClassName == "ParticleEmitter" or value_8.ClassName == "Beam" then
                    value_8.Enabled = true
                end
            end
        end
    )
    v6.Stopped:Once(
        function()
            --[[
              line: 192
              upvalues:
                u2 (ref,  index: 1)
                u1 (ref,  index: 2)
                u9 (copy, index: 3)
                CurrentCamera_upv_1 (copy, index: 4)
                u8 (copy, index: 5)
                a1 (copy, index: 6)
            ]]
            if u2 then
                u2:Disconnect()
                u2 = nil
            end
            script:SetAttribute("StopHead", false)
            u1.Humanoid.AutoRotate = true
            u9:Destroy()
            CurrentCamera_upv_1.CameraType = Enum.CameraType.Custom
            u8:Destroy()
            CurrentCamera_upv_1.CameraSubject = a1.Humanoid
        end
    )
    local v7 = RunService_upv_1.RenderStepped:Connect(
        function()
            --[[
              line: 205
              upvalues:
                u1 (ref,  index: 1)
                a1 (copy, index: 2)
                CurrentCamera_upv_1 (copy, index: 3)
                u8 (copy, index: 4)
            ]]
            u1.Humanoid.AutoRotate = false
            a1.Torso.Neck.C1 = script.Neck.C1
            CurrentCamera_upv_1.CFrame = u8.camera.CFrame
        end
    )
    u2 = v7
end
function tbl_1.init()
    --[[
      name: init
      line: 216
      upvalues:
        u3 (copy, index: 1)
        tbl_upv_2 (copy, index: 2)
    ]]
    u3.OnClientEvent:Connect(
        function(a1, a2)
            --[[
              line: 217
              upvalues:
                tbl_upv_2 (copy, index: 1)
            ]]
            if not tbl_upv_2[a2] then
                return
            end
            tbl_upv_2[a2](a1)
        end
    )
end
tbl_1.init()
return tbl_1