local local_player = game.Players.LocalPlayer
local mouse = local_player:GetMouse()
local user_input_service = game:GetService("UserInputService")
local color_selector = script.Parent:WaitForChild("ColorSelector")
local submit = color_selector:WaitForChild("Submit")
local slider = script:WaitForChild("Slider")
local color = color_selector:FindFirstChild("Color")
local_player:WaitForChild("dataLoaded")
local enabled = false

local function make_slider(parent, argument)
    local clone_result = slider:clone()
    clone_result.Parent = parent
    clone_result.Position = UDim2.new(argument, 0, 0.5, 0)
    local x = parent.AbsolutePosition.X
    local x_2 = parent.AbsoluteSize.X
    clone_result.MouseButton1Down:connect(function()
        if enabled then
            return
        end
        enabled = true
        repeat
            clone_result.Position =
                UDim2.new(math.round(Snap(math.clamp((mouse.X - x) / x_2, 0, 1), 0.02) * 100) / 100, 0, 0.5, 0)
            game:GetService("RunService").RenderStepped:wait()
        until not enabled
    end)
    return clone_result
end

function Snap(argument, argument_2)
    return argument - (argument % argument_2)
end

user_input_service.InputEnded:connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
        return
    end
    enabled = false
end)
local background_color3 = local_player.Data.AccessoryColor.Value
local scale, scale_offset, scale_offset_2 = background_color3:ToHSV()
local result = make_slider(color_selector.Hue, scale)
local result_2 = make_slider(color_selector.Saturation, scale_offset / 0.95)
local result_3 = make_slider(color_selector.Value, (scale_offset_2 - 0.05) / 0.9)
local _ = Color3.new(1, 1, 1)

local function update_color()
    color.BackgroundColor3 = background_color3
end

color.BackgroundColor3 = background_color3
result:GetPropertyChangedSignal("Position"):connect(function()
    scale = result.Position.X.Scale
    background_color3 = Color3.fromHSV(scale, scale_offset, scale_offset_2)
    color.BackgroundColor3 = background_color3
end)
result_2:GetPropertyChangedSignal("Position"):connect(function()
    scale_offset = result_2.Position.X.Scale * 0.95
    background_color3 = Color3.fromHSV(scale, scale_offset, scale_offset_2)
    color.BackgroundColor3 = background_color3
end)
result_3:GetPropertyChangedSignal("Position"):connect(function()
    scale_offset_2 = result_3.Position.X.Scale * 0.95
    background_color3 = Color3.fromHSV(scale, scale_offset, scale_offset_2)
    color.BackgroundColor3 = background_color3
end)
local text = 0
local text_2 = 0
local text_3 = 0
local red = color_selector.Red
local green = color_selector.Green
local blue = color_selector.Blue
red.FocusLost:Connect(function()
    local num = tonumber(red.Text)
    if type(num) == "number" then
        text = ((num < 0) and 0) or (((num > 255) and 255) or num)
        red.Text = text
        background_color3 = Color3.fromRGB(text, text_2, text_3)
        color.BackgroundColor3 = background_color3
    else
        red.Text = ""
    end
end)
green.FocusLost:Connect(function()
    local num = tonumber(green.Text)
    if type(num) == "number" then
        text_2 = ((num < 0) and 0) or (((num > 255) and 255) or num)
        green.Text = text_2
        background_color3 = Color3.fromRGB(text, text_2, text_3)
        color.BackgroundColor3 = background_color3
    else
        green.Text = ""
    end
end)
blue.FocusLost:Connect(function()
    local num = tonumber(blue.Text)
    if type(num) == "number" then
        text_3 = ((num < 0) and 0) or (((num > 255) and 255) or num)
        blue.Text = text_3
        background_color3 = Color3.fromRGB(text, text_2, text_3)
        color.BackgroundColor3 = background_color3
    else
        blue.Text = ""
    end
end)
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local remote_event = knit.GetService("KeyHandlerService"):GetKey("UpdateAccessoryColor")
submit.MouseButton1Click:connect(function()
    remote_event:FireServer(background_color3)
    local connection = local_player.Data.AccessoryColor.Changed:Once(function()
        local clone = game.ReplicatedStorage.UISounds.ui_achieve:Clone()
        clone.Parent = game.Workspace
        clone:Play()
        game.Debris:AddItem(clone, 3)
    end)
    task.delay(0.4, function()
        connection:Disconnect()
    end)
end)
