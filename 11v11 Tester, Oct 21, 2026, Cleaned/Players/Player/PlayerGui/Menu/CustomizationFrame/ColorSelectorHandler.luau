local local_player = game.Players.LocalPlayer
local mouse = local_player:GetMouse()
local user_input_service = game:GetService("UserInputService")
local color_selector = script.Parent:WaitForChild("ColorSelector")
local submit = color_selector:WaitForChild("Submit")
local slider = script:WaitForChild("Slider")
local color = color_selector:FindFirstChild("Color")
local _ = local_player.UserId
local_player:WaitForChild("dataLoaded")
local enabled = false

local function make_slider(parent, argument)
    local clone_result = slider:clone()
    clone_result.Parent = parent
    clone_result.Position = UDim2.new(argument, 0, 0.5, 0)
    local x = parent.AbsolutePosition.X
    local x2 = parent.AbsoluteSize.X

    clone_result.MouseButton1Down:connect(function()
        if enabled then
            return
        end

        enabled = true

        repeat
            local product_3 = Snap(math.clamp((mouse.X - x) / x2, 0, 1), 0.02) * 100
            local quotient = math.round(product_3) / 100
            clone_result.Position = UDim2.new(quotient, 0, 0.5, 0)
            game:GetService("RunService").RenderStepped:wait()
        until not enabled
    end)

    return clone_result
end

function Snap(argument, argument_2)
    return argument - argument % argument_2
end

user_input_service.InputEnded:connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        enabled = false
    end
end)

local value = local_player.Data.AccessoryColor.Value
local to_hsv_result, product, product_2 = value:ToHSV()
local result = make_slider(color_selector.Hue, to_hsv_result)
local result_2 = make_slider(color_selector.Saturation, product / 0.95)
local result_3 = make_slider(color_selector.Value, (product_2 - 0.05) / 0.9)
Color3.new(1, 1, 1)

local function update_color()
    color.BackgroundColor3 = value
end

color.BackgroundColor3 = value

result:GetPropertyChangedSignal("Position"):connect(function()
    to_hsv_result = result.Position.X.Scale
    value = Color3.fromHSV(to_hsv_result, product, product_2)
    color.BackgroundColor3 = value
end)

result_2:GetPropertyChangedSignal("Position"):connect(function()
    product = result_2.Position.X.Scale * 0.95
    value = Color3.fromHSV(to_hsv_result, product, product_2)
    color.BackgroundColor3 = value
end)

result_3:GetPropertyChangedSignal("Position"):connect(function()
    product_2 = result_3.Position.X.Scale * 0.95
    value = Color3.fromHSV(to_hsv_result, product, product_2)
    color.BackgroundColor3 = value
end)

local text = 0
local text_2 = 0
local text_3 = 0
local red = color_selector.Red
local green = color_selector.Green
local blue = color_selector.Blue

red.FocusLost:Connect(function()
    local tonumber_result = tonumber(red.Text)

    if type(tonumber_result) ~= "number" then
        red.Text = ""

        return
    end

    text = tonumber_result < 0 and 0 or (tonumber_result > 255 and 255 or tonumber_result)
    red.Text = text
    value = Color3.fromRGB(text, text_2, text_3)
    color.BackgroundColor3 = value
end)

green.FocusLost:Connect(function()
    local tonumber_result = tonumber(green.Text)

    if type(tonumber_result) ~= "number" then
        green.Text = ""

        return
    end

    text_2 = tonumber_result < 0 and 0 or (tonumber_result > 255 and 255 or tonumber_result)
    green.Text = text_2
    value = Color3.fromRGB(text, text_2, text_3)
    color.BackgroundColor3 = value
end)

blue.FocusLost:Connect(function()
    local tonumber_result = tonumber(blue.Text)

    if type(tonumber_result) ~= "number" then
        blue.Text = ""

        return
    end

    text_3 = tonumber_result < 0 and 0 or (tonumber_result > 255 and 255 or tonumber_result)
    blue.Text = text_3
    value = Color3.fromRGB(text, text_2, text_3)
    color.BackgroundColor3 = value
end)

local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key = knit.GetService("KeyHandlerService"):GetKey("UpdateAccessoryColor")

submit.MouseButton1Click:connect(function()
    key:FireServer(value)
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
