--[[
    Script Path: Game/Players/Player/PlayerGui/Menu/CustomizationFrame/ColorSelectorHandler
    Class: LocalScript
    Time: 2026-10-03 12:27:03
--]]

local LocalPlayer_upv_1 = game.Players.LocalPlayer
local u1 = LocalPlayer_upv_1:GetMouse()
local UserInputService_1 = game:GetService("UserInputService")
local ColorSelector_1 = script.Parent:WaitForChild("ColorSelector")
local Submit_1 = ColorSelector_1:WaitForChild("Submit")
local Slider_upv_1 = script:WaitForChild("Slider")
local Color_upv_1 = ColorSelector_1:FindFirstChild("Color")
LocalPlayer_upv_1:WaitForChild("dataLoaded")
local u2 = false
local function makeSlider(a1, a2)
    --[[
      name: makeSlider
      line: 17
      upvalues:
        Slider_upv_1 (copy, index: 1)
        u2 (ref,  index: 2)
        u1 (copy, index: 3)
    ]]
    local u3 = Slider_upv_1:clone()
    u3.Parent = a1
    u3.Position = UDim2.new(a2, 0, 0.5, 0)
    local X_upv_1 = a1.AbsolutePosition.X
    local X_upv_2 = a1.AbsoluteSize.X
    u3.MouseButton1Down:connect(
        function()
            --[[
              line: 23
              upvalues:
                u2 (ref,  index: 1)
                u1 (copy, index: 2)
                X_upv_1 (copy, index: 3)
                X_upv_2 (copy, index: 4)
                u3 (copy, index: 5)
            ]]
            if u2 then
                return
            end
            u2 = true
            repeat
                u3.Position = UDim2.new(math.round(Snap(math.clamp((u1.X - X_upv_1) / X_upv_2, 0, 1), 0.02) * 100) / 100, 0, 0.5, 0)
                game:GetService("RunService").RenderStepped:wait()
            until not (u2)
        end
    )
    return u3
end
function Snap(a1, a2)
    --[[
      name: Snap
      line: 41
    ]]
    return a1 - (a1 % a2)
end
UserInputService_1.InputEnded:connect(
    function(a1)
        --[[
          line: 44
          upvalues:
            u2 (ref, index: 1)
        ]]
        if a1.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end
        u2 = false
    end
)
local u4 = LocalPlayer_upv_1.Data.AccessoryColor.Value
local Scale_upv_1, u5, u6 = u4:ToHSV()
local u7 = makeSlider(ColorSelector_1.Hue, Scale_upv_1)
local u8 = makeSlider(ColorSelector_1.Saturation, u5 / 0.95)
local u9 = makeSlider(ColorSelector_1.Value, (u6 - 0.05) / 0.9)
local _ = Color3.new(1, 1, 1)
local function updateColor()
    --[[
      name: updateColor
      line: 58
      upvalues:
        Color_upv_1 (copy, index: 1)
        u4 (ref,  index: 2)
    ]]
    Color_upv_1.BackgroundColor3 = u4
end
Color_upv_1.BackgroundColor3 = u4
u7:GetPropertyChangedSignal("Position"):connect(
    function()
        --[[
          line: 62
          upvalues:
            Scale_upv_1 (ref,  index: 1)
            u7 (copy, index: 2)
            u4 (ref,  index: 3)
            u5 (ref,  index: 4)
            u6 (ref,  index: 5)
            Color_upv_1 (copy, index: 6)
        ]]
        Scale_upv_1 = u7.Position.X.Scale
        u4 = Color3.fromHSV(Scale_upv_1, u5, u6)
        Color_upv_1.BackgroundColor3 = u4
    end
)
u8:GetPropertyChangedSignal("Position"):connect(
    function()
        --[[
          line: 68
          upvalues:
            u5 (ref,  index: 1)
            u8 (copy, index: 2)
            u4 (ref,  index: 3)
            Scale_upv_1 (ref,  index: 4)
            u6 (ref,  index: 5)
            Color_upv_1 (copy, index: 6)
        ]]
        u5 = u8.Position.X.Scale * 0.95
        u4 = Color3.fromHSV(Scale_upv_1, u5, u6)
        Color_upv_1.BackgroundColor3 = u4
    end
)
u9:GetPropertyChangedSignal("Position"):connect(
    function()
        --[[
          line: 75
          upvalues:
            u6 (ref,  index: 1)
            u9 (copy, index: 2)
            u4 (ref,  index: 3)
            Scale_upv_1 (ref,  index: 4)
            u5 (ref,  index: 5)
            Color_upv_1 (copy, index: 6)
        ]]
        u6 = u9.Position.X.Scale * 0.95
        u4 = Color3.fromHSV(Scale_upv_1, u5, u6)
        Color_upv_1.BackgroundColor3 = u4
    end
)
local u10 = 0
local u11 = 0
local u12 = 0
local Red_upv_1 = ColorSelector_1.Red
local Green_upv_1 = ColorSelector_1.Green
local Blue_upv_1 = ColorSelector_1.Blue
Red_upv_1.FocusLost:Connect(
    function()
        --[[
          line: 88
          upvalues:
            Red_upv_1 (copy, index: 1)
            u10 (ref,  index: 2)
            u4 (ref,  index: 3)
            u11 (ref,  index: 4)
            u12 (ref,  index: 5)
            Color_upv_1 (copy, index: 6)
        ]]
        local num_1 = tonumber(Red_upv_1.Text)
        if type(num_1) == "number" then
            u10 = ((num_1 < 0) and 0) or (((num_1 > 255) and 255) or num_1)
            Red_upv_1.Text = u10
            u4 = Color3.fromRGB(u10, u11, u12)
            Color_upv_1.BackgroundColor3 = u4
        else
            Red_upv_1.Text = ""
        end
    end
)
Green_upv_1.FocusLost:Connect(
    function()
        --[[
          line: 105
          upvalues:
            Green_upv_1 (copy, index: 1)
            u11 (ref,  index: 2)
            u4 (ref,  index: 3)
            u10 (ref,  index: 4)
            u12 (ref,  index: 5)
            Color_upv_1 (copy, index: 6)
        ]]
        local num_2 = tonumber(Green_upv_1.Text)
        if type(num_2) == "number" then
            u11 = ((num_2 < 0) and 0) or (((num_2 > 255) and 255) or num_2)
            Green_upv_1.Text = u11
            u4 = Color3.fromRGB(u10, u11, u12)
            Color_upv_1.BackgroundColor3 = u4
        else
            Green_upv_1.Text = ""
        end
    end
)
Blue_upv_1.FocusLost:Connect(
    function()
        --[[
          line: 122
          upvalues:
            Blue_upv_1 (copy, index: 1)
            u12 (ref,  index: 2)
            u4 (ref,  index: 3)
            u10 (ref,  index: 4)
            u11 (ref,  index: 5)
            Color_upv_1 (copy, index: 6)
        ]]
        local num_3 = tonumber(Blue_upv_1.Text)
        if type(num_3) == "number" then
            u12 = ((num_3 < 0) and 0) or (((num_3 > 255) and 255) or num_3)
            Blue_upv_1.Text = u12
            u4 = Color3.fromRGB(u10, u11, u12)
            Color_upv_1.BackgroundColor3 = u4
        else
            Blue_upv_1.Text = ""
        end
    end
)
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
local u13 = Knit_1.GetService("KeyHandlerService"):GetKey("UpdateAccessoryColor")
Submit_1.MouseButton1Click:connect(
    function()
        --[[
          line: 145
          upvalues:
            u13 (copy, index: 1)
            u4 (ref,  index: 2)
            LocalPlayer_upv_1 (copy, index: 3)
        ]]
        u13:FireServer(u4)
        local u14 = LocalPlayer_upv_1.Data.AccessoryColor.Changed:Once(
            function()
                --[[
                  line: 147
                ]]
                local v1 = game.ReplicatedStorage.UISounds.ui_achieve:Clone()
                v1.Parent = game.Workspace
                v1:Play()
                game.Debris:AddItem(v1, 3)
            end
        )
        task.delay(
            0.4,
            function()
                --[[
                  line: 153
                  upvalues:
                    u14 (copy, index: 1)
                ]]
                u14:Disconnect()
            end
        )
    end
)