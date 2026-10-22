local user_input_service = game:GetService("UserInputService")
local local_player = game.Players.LocalPlayer
local controls = local_player:WaitForChild("Settings"):WaitForChild("Controls")
local mouse_icon = script.Parent.MouseIcon
local curve_left = mouse_icon.CurveLeft
local curve_right = mouse_icon.CurveRight
local topspin = mouse_icon.Topspin
local enabled = false
local number = 0
local_player:FindFirstChild("Settings"):FindFirstChild("Misc"):FindFirstChild("CustomCursor").Changed:Connect(function()
    script.Parent.MouseIcon.Image =
        local_player:FindFirstChild("Settings"):FindFirstChild("Misc"):FindFirstChild("CustomCursor").Value
end)
script.Parent.MouseIcon.Image =
    local_player:FindFirstChild("Settings"):FindFirstChild("Misc"):FindFirstChild("CustomCursor").Value
user_input_service.InputBegan:Connect(function(input)
    if controls.SpinToggle.Value ~= false or local_player.Settings.Misc.CurveVisual.Value ~= true then
        return
    end
    if
        input.UserInputType
        == (((controls.Flipped.Value == true) and Enum.UserInputType.MouseButton2) or Enum.UserInputType.MouseButton1)
    then
        enabled = true
        if user_input_service:IsKeyDown(Enum.KeyCode[controls.CurveRight.Value]) then
            curve_right.Visible = true
        elseif user_input_service:IsKeyDown(Enum.KeyCode[controls.CurveLeft.Value]) then
            curve_left.Visible = true
        elseif user_input_service:IsKeyDown(Enum.KeyCode[controls.Topspin.Value]) then
            topspin.Visible = true
        end
    end
    if enabled ~= true then
        return
    end
    if input.KeyCode == Enum.KeyCode[controls.CurveRight.Value] then
        curve_right.Visible = true
    elseif input.KeyCode == Enum.KeyCode[controls.CurveLeft.Value] then
        curve_left.Visible = true
    elseif input.KeyCode == Enum.KeyCode[controls.Topspin.Value] then
        topspin.Visible = true
    end
end)
user_input_service.InputEnded:Connect(function(input)
    if controls.SpinToggle.Value ~= false or local_player.Settings.Misc.CurveVisual.Value ~= true then
        return
    end
    if
        input.UserInputType
        == (((controls.Flipped.Value == true) and Enum.UserInputType.MouseButton2) or Enum.UserInputType.MouseButton1)
    then
        enabled = false
        curve_right.Visible = false
        curve_left.Visible = false
        topspin.Visible = false
    end
    if enabled ~= true then
        return
    end
    if input.KeyCode == Enum.KeyCode[controls.CurveRight.Value] then
        curve_right.Visible = false
    elseif input.KeyCode == Enum.KeyCode[controls.CurveLeft.Value] then
        curve_left.Visible = false
    elseif input.KeyCode == Enum.KeyCode[controls.Topspin.Value] then
        topspin.Visible = false
    end
end)
local character = local_player.Character or (local_player.CharacterAdded:Wait())
local selected_curve = character:WaitForChild("Stats"):WaitForChild("SelectedCurve")
selected_curve.Changed:Connect(function()
    if local_player.Settings.Misc.CurveVisual.Value == false then
        curve_left.Visible = false
        curve_right.Visible = false
        topspin.Visible = false
    elseif controls.SpinToggle.Value ~= false then
        if selected_curve.Value == "Left" then
            curve_left.Visible = true
            curve_right.Visible = false
            topspin.Visible = false
        elseif selected_curve.Value == "Right" then
            curve_left.Visible = false
            curve_right.Visible = true
            topspin.Visible = false
        elseif selected_curve.Value ~= "Top" then
            curve_left.Visible = false
            curve_right.Visible = false
            topspin.Visible = false
        else
            curve_left.Visible = false
            curve_right.Visible = false
            topspin.Visible = true
        end
    end
end)
user_input_service.InputChanged:Connect(function(input, game_processed)
    if
        local_player.Settings.Misc.CurveVisual.Value ~= true
        or input.UserInputType ~= Enum.UserInputType.Gamepad1
        or input.KeyCode ~= Enum.KeyCode.Thumbstick1
    then
        return
    end
    if input.Position.X >= 0.75 then
        curve_left.Visible = false
        curve_right.Visible = true
        topspin.Visible = false
        number = 3
    elseif input.Position.X <= -0.75 then
        curve_left.Visible = true
        curve_right.Visible = false
        topspin.Visible = false
        number = 2
    elseif input.Position.Y >= 0.75 then
        curve_left.Visible = false
        curve_right.Visible = false
        topspin.Visible = false
        number = 4
    elseif input.Position.Y <= -0.75 then
        curve_left.Visible = false
        curve_right.Visible = false
        topspin.Visible = true
        number = 1
    else
        number = 4
    end
    if not (input.Position.Magnitude < 0.4) then
        return
    end
    curve_left.Visible = false
    curve_right.Visible = false
    topspin.Visible = false
end)
