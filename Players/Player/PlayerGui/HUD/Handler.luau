--[[
    Script Path: Game/Players/Player/PlayerGui/HUD/Handler
    Class: LocalScript
    Time: 2026-10-03 12:27:03
--]]

local LocalPlayer_upv_1 = game.Players.LocalPlayer
local v1 = LocalPlayer_upv_1.Character or (LocalPlayer_upv_1.CharacterAdded:Wait())
local StaminaFrame_upv_1 = script.Parent.StaminaFrame
local SkillCD_upv_1 = script.Parent.SkillCD
local UserInputService_upv_1 = game:GetService("UserInputService")
LocalPlayer_upv_1:WaitForChild("Settings"):WaitForChild("Controls")
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
local v2 = Knit_1.GetService("KeyHandlerService")
local Stamina_upv_1 = v1:WaitForChild("Stats"):WaitForChild("Stamina")
local MaxStamina_upv_1 = v1:WaitForChild("Stats"):WaitForChild("MaxStamina")
local SelectedSkill_upv_1 = LocalPlayer_upv_1:WaitForChild("Data"):WaitForChild("SelectedSkill")
local MainBar_upv_1 = script.Parent.StaminaFrame.Stamina.MainBar
local GreyBar_upv_1 = script.Parent.StaminaFrame.Stamina.GreyBar
Stamina_upv_1.Changed:Connect(
    function()
        --[[
          line: 18
          upvalues:
            MainBar_upv_1 (copy, index: 1)
            Stamina_upv_1 (copy, index: 2)
        ]]
        local TweenService_1 = game:GetService("TweenService")
        local v3 = TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local tbl_1 = {}
        tbl_1.Size = UDim2.new(Stamina_upv_1.Value / 100, 0, 1, 0)
        TweenService_1:Create(MainBar_upv_1, v3, tbl_1):Play()
    end
)
local u1 = v2:GetKey("UpdateMaxStaminaRejoin")
local u2 = tick()
MaxStamina_upv_1.Changed:Connect(
    function()
        --[[
          line: 28
          upvalues:
            GreyBar_upv_1 (copy, index: 1)
            MaxStamina_upv_1 (copy, index: 2)
            u2 (ref,  index: 3)
            u1 (copy, index: 4)
        ]]
        local TweenService_2 = game:GetService("TweenService")
        local v4 = TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local tbl_2 = {}
        tbl_2.Size = UDim2.new(math.abs(MaxStamina_upv_1.Value - 100) / 100, 0, 1, 0)
        TweenService_2:Create(GreyBar_upv_1, v4, tbl_2):Play()
        if not (tick() - u2 > 0.5) then
            return
        end
        u2 = tick()
        u1:FireServer(MaxStamina_upv_1.Value)
    end
)
LocalPlayer_upv_1.ChildAdded:Connect(
    function(a1)
        --[[
          line: 38
          upvalues:
            StaminaFrame_upv_1 (copy, index: 1)
            SkillCD_upv_1 (copy, index: 2)
        ]]
        if a1.Name ~= "InPlay" then
            return
        end
        StaminaFrame_upv_1.Visible = true
        SkillCD_upv_1.Visible = true
    end
)
LocalPlayer_upv_1.ChildRemoved:Connect(
    function(a1)
        --[[
          line: 45
          upvalues:
            StaminaFrame_upv_1 (copy, index: 1)
            SkillCD_upv_1 (copy, index: 2)
        ]]
        if a1.Name ~= "InPlay" then
            return
        end
        StaminaFrame_upv_1.Visible = false
        SkillCD_upv_1.Visible = false
    end
)
game.ReplicatedStorage.ChildAdded:Connect(
    function(a1)
        --[[
          line: 52
          upvalues:
            StaminaFrame_upv_1 (copy, index: 1)
            SkillCD_upv_1 (copy, index: 2)
        ]]
        if a1.Name ~= "EndScreen" then
            return
        end
        StaminaFrame_upv_1.Visible = false
        SkillCD_upv_1.Visible = false
    end
)
local function trunc(a1)
    --[[
      name: trunc
      line: 59
    ]]
    local str_1 = tostring(a1)
    local v5 = string.find(a1, ".", 1, true)
    if v5 then
        return (string.sub(str_1, 1, v5 + 1))
    end
    return str_1 .. ".0"
end
SelectedSkill_upv_1.Changed:Connect(
    function()
        --[[
          line: 69
          upvalues:
            SkillCD_upv_1 (copy, index: 1)
            SelectedSkill_upv_1 (copy, index: 2)
        ]]
        SkillCD_upv_1.SkillName.Text = string.upper(SelectedSkill_upv_1.Value)
    end
)
LocalPlayer_upv_1.Settings.Controls.Skill.Changed:Connect(
    function()
        --[[
          line: 73
          upvalues:
            SkillCD_upv_1 (copy, index: 1)
            LocalPlayer_upv_1 (copy, index: 2)
        ]]
        SkillCD_upv_1.Keybind.Text = "[" .. string.upper(LocalPlayer_upv_1.Settings.Controls.Skill.Value) .. "]"
    end
)
SkillCD_upv_1.Keybind.Text = "[" .. string.upper(LocalPlayer_upv_1.Settings.Controls.Skill.Value) .. "]"
LocalPlayer_upv_1.SelectedPosition.Changed:Connect(
    function()
        --[[
          line: 78
          upvalues:
            LocalPlayer_upv_1 (copy, index: 1)
            SkillCD_upv_1 (copy, index: 2)
        ]]
        if LocalPlayer_upv_1.SelectedPosition.Value ~= "GK" then
            SkillCD_upv_1.SkillName.Text = string.upper(LocalPlayer_upv_1.Data.SelectedSkill.Value)
        else
            SkillCD_upv_1.SkillName.Text = string.upper(LocalPlayer_upv_1.Data.GoalieSkill.Value)
        end
    end
)
SkillCD_upv_1.SkillName.Text = string.upper(SelectedSkill_upv_1.Value)
v2:GetKey("skillCD").OnClientEvent:Connect(
    function(a1)
        --[[
          line: 88
          upvalues:
            SkillCD_upv_1 (copy, index: 1)
            LocalPlayer_upv_1 (copy, index: 2)
            SelectedSkill_upv_1 (copy, index: 3)
        ]]
        if game.ReplicatedStorage:FindFirstChild("NoSkillCD") then
            return
        end
        local u3 = tick() + a1
        local TweenService_3 = game:GetService("TweenService")
        local v6 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_3 = {}
        tbl_3.BackgroundColor3 = Color3.new(0.95, 0, 0)
        TweenService_3:Create(SkillCD_upv_1, v6, tbl_3):Play()
        local TweenService_4 = game:GetService("TweenService")
        local v7 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_4 = {}
        tbl_4.TextColor3 = Color3.new(0.95, 0, 0)
        TweenService_4:Create(SkillCD_upv_1.SkillName, v7, tbl_4):Play()
        local TweenService_5 = game:GetService("TweenService")
        local v8 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_5 = {}
        tbl_5.TextColor3 = Color3.new(0.95, 0, 0)
        TweenService_5:Create(SkillCD_upv_1.Keybind, v8, tbl_5):Play()
        local TweenService_6 = game:GetService("TweenService")
        local v9 = TweenInfo.new(a1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local tbl_6 = {}
        tbl_6.Size = UDim2.new(0, 0, 0, 2)
        TweenService_6:Create(SkillCD_upv_1, v9, tbl_6):Play()
        task.delay(
            a1 - 0.25,
            function()
                --[[
                  line: 103
                  upvalues:
                    SkillCD_upv_1 (copy, index: 1)
                ]]
                local TweenService_7 = game:GetService("TweenService")
                local v10 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_7 = {}
                tbl_7.BackgroundColor3 = Color3.new(1, 1, 1)
                TweenService_7:Create(SkillCD_upv_1, v10, tbl_7):Play()
                local TweenService_8 = game:GetService("TweenService")
                local v11 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_8 = {}
                tbl_8.TextColor3 = Color3.new(1, 1, 1)
                TweenService_8:Create(SkillCD_upv_1.SkillName, v11, tbl_8):Play()
                local TweenService_9 = game:GetService("TweenService")
                local v12 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_9 = {}
                tbl_9.TextColor3 = Color3.new(1, 1, 1)
                TweenService_9:Create(SkillCD_upv_1.Keybind, v12, tbl_9):Play()
                local TweenService_10 = game:GetService("TweenService")
                local v13 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_10 = {}
                tbl_10.Size = UDim2.new(0, 300, 0, 2)
                TweenService_10:Create(SkillCD_upv_1, v13, tbl_10):Play()
            end
        )
        local u4 = game:GetService("RunService").RenderStepped:Connect(
            function()
                --[[
                  line: 117
                  upvalues:
                    SkillCD_upv_1 (copy, index: 1)
                    u3 (copy, index: 2)
                ]]
                local SkillName_1 = SkillCD_upv_1.SkillName
                local v14 = u3 - tick()
                local str_2 = tostring(v14)
                local v15 = string.find(v14, ".", 1, true)
                local v16 = ((not v15) and (str_2 .. ".0")) or (string.sub(str_2, 1, v15 + 1))
                SkillName_1.Text = v16 .. "s"
            end
        )
        task.delay(
            a1,
            function()
                --[[
                  line: 120
                  upvalues:
                    u4 (copy, index: 1)
                    LocalPlayer_upv_1 (copy, index: 2)
                    SkillCD_upv_1 (copy, index: 3)
                    SelectedSkill_upv_1 (copy, index: 4)
                ]]
                u4:Disconnect()
                if LocalPlayer_upv_1.SelectedPosition.Value ~= "GK" then
                    SkillCD_upv_1.SkillName.Text = string.upper(SelectedSkill_upv_1.Value)
                else
                    SkillCD_upv_1.SkillName.Text = string.upper(LocalPlayer_upv_1.Data.GoalieSkill.Value)
                end
            end
        )
    end
)
UserInputService_upv_1.InputChanged:Connect(
    function()
        --[[
          line: 131
          upvalues:
            UserInputService_upv_1 (copy, index: 1)
            SkillCD_upv_1 (copy, index: 2)
            LocalPlayer_upv_1 (copy, index: 3)
        ]]
        if UserInputService_upv_1.GamepadEnabled ~= true then
            SkillCD_upv_1.Keybind.Text = "[" .. string.upper(LocalPlayer_upv_1.Settings.Controls.Skill.Value) .. "]"
        else
            SkillCD_upv_1.Keybind.Text = "[X]"
        end
    end
)
if UserInputService_upv_1.GamepadEnabled ~= true then
    SkillCD_upv_1.Keybind.Text = "[" .. string.upper(LocalPlayer_upv_1.Settings.Controls.Skill.Value) .. "]"
else
    SkillCD_upv_1.Keybind.Text = "[X]"
end