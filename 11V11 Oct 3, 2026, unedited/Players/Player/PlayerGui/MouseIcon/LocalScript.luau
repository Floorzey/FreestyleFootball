--[[
    Script Path: Game/Players/Player/PlayerGui/MouseIcon/LocalScript
    Class: LocalScript
    Time: 2026-10-03 12:27:03
--]]

local UserInputService_upv_1 = game:GetService("UserInputService")
local LocalPlayer_upv_1 = game.Players.LocalPlayer
local Controls_upv_1 = LocalPlayer_upv_1:WaitForChild("Settings"):WaitForChild("Controls")
local MouseIcon_1 = script.Parent.MouseIcon
local CurveLeft_upv_1 = MouseIcon_1.CurveLeft
local CurveRight_upv_1 = MouseIcon_1.CurveRight
local Topspin_upv_1 = MouseIcon_1.Topspin
local u1 = false
local u2 = 0
LocalPlayer_upv_1:FindFirstChild("Settings"):FindFirstChild("Misc"):FindFirstChild("CustomCursor").Changed:Connect(
    function()
        --[[
          line: 17
          upvalues:
            LocalPlayer_upv_1 (copy, index: 1)
        ]]
        script.Parent.MouseIcon.Image = LocalPlayer_upv_1:FindFirstChild("Settings"):FindFirstChild("Misc"):FindFirstChild("CustomCursor").Value
    end
)
script.Parent.MouseIcon.Image = LocalPlayer_upv_1:FindFirstChild("Settings"):FindFirstChild("Misc"):FindFirstChild("CustomCursor").Value
UserInputService_upv_1.InputBegan:Connect(
    function(a1)
        --[[
          line: 23
          upvalues:
            Controls_upv_1 (copy, index: 1)
            LocalPlayer_upv_1 (copy, index: 2)
            u1 (ref,  index: 3)
            UserInputService_upv_1 (copy, index: 4)
            CurveRight_upv_1 (copy, index: 5)
            CurveLeft_upv_1 (copy, index: 6)
            Topspin_upv_1 (copy, index: 7)
        ]]
        if Controls_upv_1.SpinToggle.Value ~= false or LocalPlayer_upv_1.Settings.Misc.CurveVisual.Value ~= true then
            return
        end
        if a1.UserInputType == (((Controls_upv_1.Flipped.Value == true) and (Enum.UserInputType.MouseButton2)) or (Enum.UserInputType.MouseButton1)) then
            u1 = true
            if UserInputService_upv_1:IsKeyDown(Enum.KeyCode[Controls_upv_1.CurveRight.Value]) then
                CurveRight_upv_1.Visible = true
            elseif UserInputService_upv_1:IsKeyDown(Enum.KeyCode[Controls_upv_1.CurveLeft.Value]) then
                CurveLeft_upv_1.Visible = true
            elseif UserInputService_upv_1:IsKeyDown(Enum.KeyCode[Controls_upv_1.Topspin.Value]) then
                Topspin_upv_1.Visible = true
            end
        end
        if u1 ~= true then
            return
        end
        if a1.KeyCode == Enum.KeyCode[Controls_upv_1.CurveRight.Value] then
            CurveRight_upv_1.Visible = true
        elseif a1.KeyCode == Enum.KeyCode[Controls_upv_1.CurveLeft.Value] then
            CurveLeft_upv_1.Visible = true
        elseif a1.KeyCode == Enum.KeyCode[Controls_upv_1.Topspin.Value] then
            Topspin_upv_1.Visible = true
        end
    end
)
UserInputService_upv_1.InputEnded:Connect(
    function(a1)
        --[[
          line: 48
          upvalues:
            Controls_upv_1 (copy, index: 1)
            LocalPlayer_upv_1 (copy, index: 2)
            u1 (ref,  index: 3)
            CurveRight_upv_1 (copy, index: 4)
            CurveLeft_upv_1 (copy, index: 5)
            Topspin_upv_1 (copy, index: 6)
        ]]
        if Controls_upv_1.SpinToggle.Value ~= false or LocalPlayer_upv_1.Settings.Misc.CurveVisual.Value ~= true then
            return
        end
        if a1.UserInputType == (((Controls_upv_1.Flipped.Value == true) and (Enum.UserInputType.MouseButton2)) or (Enum.UserInputType.MouseButton1)) then
            u1 = false
            CurveRight_upv_1.Visible = false
            CurveLeft_upv_1.Visible = false
            Topspin_upv_1.Visible = false
        end
        if u1 ~= true then
            return
        end
        if a1.KeyCode == Enum.KeyCode[Controls_upv_1.CurveRight.Value] then
            CurveRight_upv_1.Visible = false
        elseif a1.KeyCode == Enum.KeyCode[Controls_upv_1.CurveLeft.Value] then
            CurveLeft_upv_1.Visible = false
        elseif a1.KeyCode == Enum.KeyCode[Controls_upv_1.Topspin.Value] then
            Topspin_upv_1.Visible = false
        end
    end
)
local v1 = LocalPlayer_upv_1.Character or (LocalPlayer_upv_1.CharacterAdded:Wait())
local SelectedCurve_upv_1 = v1:WaitForChild("Stats"):WaitForChild("SelectedCurve")
SelectedCurve_upv_1.Changed:Connect(
    function()
        --[[
          line: 71
          upvalues:
            LocalPlayer_upv_1 (copy, index: 1)
            CurveLeft_upv_1 (copy, index: 2)
            CurveRight_upv_1 (copy, index: 3)
            Topspin_upv_1 (copy, index: 4)
            Controls_upv_1 (copy, index: 5)
            SelectedCurve_upv_1 (copy, index: 6)
        ]]
        if LocalPlayer_upv_1.Settings.Misc.CurveVisual.Value == false then
            CurveLeft_upv_1.Visible = false
            CurveRight_upv_1.Visible = false
            Topspin_upv_1.Visible = false
        elseif Controls_upv_1.SpinToggle.Value ~= false then
            if SelectedCurve_upv_1.Value == "Left" then
                CurveLeft_upv_1.Visible = true
                CurveRight_upv_1.Visible = false
                Topspin_upv_1.Visible = false
            elseif SelectedCurve_upv_1.Value == "Right" then
                CurveLeft_upv_1.Visible = false
                CurveRight_upv_1.Visible = true
                Topspin_upv_1.Visible = false
            elseif SelectedCurve_upv_1.Value ~= "Top" then
                CurveLeft_upv_1.Visible = false
                CurveRight_upv_1.Visible = false
                Topspin_upv_1.Visible = false
            else
                CurveLeft_upv_1.Visible = false
                CurveRight_upv_1.Visible = false
                Topspin_upv_1.Visible = true
            end
        end
    end
)
UserInputService_upv_1.InputChanged:Connect(
    function(a1, a2)
        --[[
          line: 100
          upvalues:
            LocalPlayer_upv_1 (copy, index: 1)
            CurveLeft_upv_1 (copy, index: 2)
            CurveRight_upv_1 (copy, index: 3)
            Topspin_upv_1 (copy, index: 4)
            u2 (ref,  index: 5)
        ]]
        if LocalPlayer_upv_1.Settings.Misc.CurveVisual.Value ~= true or a1.UserInputType ~= Enum.UserInputType.Gamepad1 or a1.KeyCode ~= Enum.KeyCode.Thumbstick1 then
            return
        end
        if a1.Position.X >= 0.75 then
            CurveLeft_upv_1.Visible = false
            CurveRight_upv_1.Visible = true
            Topspin_upv_1.Visible = false
            u2 = 3
        elseif a1.Position.X <= -0.75 then
            CurveLeft_upv_1.Visible = true
            CurveRight_upv_1.Visible = false
            Topspin_upv_1.Visible = false
            u2 = 2
        elseif a1.Position.Y >= 0.75 then
            CurveLeft_upv_1.Visible = false
            CurveRight_upv_1.Visible = false
            Topspin_upv_1.Visible = false
            u2 = 4
        elseif a1.Position.Y <= -0.75 then
            CurveLeft_upv_1.Visible = false
            CurveRight_upv_1.Visible = false
            Topspin_upv_1.Visible = true
            u2 = 1
        else
            u2 = 4
        end
        if not (a1.Position.Magnitude < 0.4) then
            return
        end
        CurveLeft_upv_1.Visible = false
        CurveRight_upv_1.Visible = false
        Topspin_upv_1.Visible = false
    end
)