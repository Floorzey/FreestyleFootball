--[[
    Script Path: Game/ReplicatedStorage/Modules/ColorPicker/BuiltinSliders
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local Slider_upv_1 = require(script.Parent:WaitForChild("Slider"))
local u1 = ColorSequence.new(
    {ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.16666666666666666, Color3.fromRGB(255, 255, 0)), ColorSequenceKeypoint.new(0.3333333333333333, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.6666666666666666, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(0.8333333333333334, Color3.fromRGB(255, 0, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))}
)
local tbl_1 = {}
function tbl_1.Transparency(a1)
    --[[
      name: Transparency
      line: 14
      upvalues:
        Slider_upv_1 (copy, index: 1)
    ]]
    local v1 = Slider_upv_1.new(a1, "T", 4, 100)
    local Gradient_upv_1 = v1.Instance:WaitForChild("Slider"):WaitForChild("Gradient")
    Gradient_upv_1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
    local v2 = Instance.new("ImageLabel")
    v2.BackgroundTransparency = 1
    v2.Position = UDim2.fromOffset(4, 4)
    v2.Size = UDim2.new(0, 165, 1, -8)
    v2.Image = "rbxassetid://111137375763311"
    v2.ImageTransparency = 0.5
    v2.ScaleType = Enum.ScaleType.Tile
    v2.TileSize = UDim2.fromOffset(10, 10)
    v2.ZIndex = -1
    local v3 = Instance.new("UICorner")
    v3.CornerRadius = UDim.new(0.5, 0)
    v3.Parent = v2
    v2.Parent = v1.Instance
    v1.OnManualChange = function(a2)
        --[[
          line: 38
          upvalues:
            a1 (copy, index: 1)
        ]]
        a1.Color.Transparency = a2
        a1:_updateColorVisuals()
    end
    v1.GetValue = function()
        --[[
          line: 43
          upvalues:
            a1 (copy, index: 1)
        ]]
        return a1.Color.Transparency or 0
    end
    v1.OnValueChanged = function()
        --[[
          line: 47
          upvalues:
            Gradient_upv_1 (copy, index: 1)
            a1 (copy, index: 2)
        ]]
        Gradient_upv_1.Color = ColorSequence.new(a1:GetColor())
    end
    return v1
end
function tbl_1.Hue(a1)
    --[[
      name: Hue
      line: 55
      upvalues:
        Slider_upv_1 (copy, index: 1)
        u1 (copy, index: 2)
    ]]
    local v4 = Slider_upv_1.new(a1, "H", 1, 360)
    v4.Instance:WaitForChild("Slider"):WaitForChild("Gradient").Color = u1
    v4.OnManualChange = function(a2)
        --[[
          line: 60
          upvalues:
            a1 (copy, index: 1)
        ]]
        a1.Color.Hue = a2
        a1:_updateColorVisuals()
    end
    v4.GetValue = function()
        --[[
          line: 65
          upvalues:
            a1 (copy, index: 1)
        ]]
        return a1.Color.Hue or 0
    end
    return v4
end
function tbl_1.Saturation(a1)
    --[[
      name: Saturation
      line: 72
      upvalues:
        Slider_upv_1 (copy, index: 1)
    ]]
    local u2 = Slider_upv_1.new(a1, "S", 2, 100)
    u2.OnManualChange = function(a2)
        --[[
          line: 74
          upvalues:
            a1 (copy, index: 1)
        ]]
        a1.Color.Saturation = a2
        a1:_updateColorVisuals()
    end
    u2.GetValue = function()
        --[[
          line: 79
          upvalues:
            a1 (copy, index: 1)
        ]]
        return a1.Color.Saturation or 0
    end
    u2.OnValueChanged = function()
        --[[
          line: 83
          upvalues:
            a1 (copy, index: 1)
            u2 (copy, index: 2)
        ]]
        local Gradient_2 = u2.Instance:WaitForChild("Slider"):WaitForChild("Gradient")
        Gradient_2.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromHSV(a1.Color.Hue, 1, a1.Color.Value))})
    end
    return u2
end
function tbl_1.Value(a1)
    --[[
      name: Value
      line: 98
      upvalues:
        Slider_upv_1 (copy, index: 1)
    ]]
    local u3 = Slider_upv_1.new(a1, "V", 3, 100)
    u3.OnManualChange = function(a2)
        --[[
          line: 100
          upvalues:
            a1 (copy, index: 1)
        ]]
        a1.Color.Value = a2
        a1:_updateColorVisuals()
    end
    u3.GetValue = function()
        --[[
          line: 105
          upvalues:
            a1 (copy, index: 1)
        ]]
        return a1.Color.Value or 0
    end
    u3.OnValueChanged = function()
        --[[
          line: 109
          upvalues:
            a1 (copy, index: 1)
            u3 (copy, index: 2)
        ]]
        local Gradient_3 = u3.Instance:WaitForChild("Slider"):WaitForChild("Gradient")
        Gradient_3.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromHSV(a1.Color.Hue, a1.Color.Saturation, 1))})
    end
    return u3
end
function tbl_1.Red(a1)
    --[[
      name: Red
      line: 125
      upvalues:
        Slider_upv_1 (copy, index: 1)
    ]]
    local u4 = Slider_upv_1.new(a1, "R", 1, 255)
    u4.OnManualChange = function(a2)
        --[[
          line: 127
          upvalues:
            a1 (copy, index: 1)
        ]]
        local v5 = a1:GetColor()
        local v6, v7, v8 = Color3.new(a2, v5.G, v5.B):ToHSV()
        a1.Color.Hue = v6
        a1.Color.Saturation = v7
        a1.Color.Value = v8
        a1:_updateColorVisuals()
    end
    u4.GetValue = function()
        --[[
          line: 135
          upvalues:
            a1 (copy, index: 1)
        ]]
        return a1:GetColor().R or 0
    end
    u4.OnValueChanged = function()
        --[[
          line: 139
          upvalues:
            a1 (copy, index: 1)
            u4 (copy, index: 2)
        ]]
        local v9 = a1:GetColor()
        local G_1 = v9.G
        local B_1 = v9.B
        local Gradient_4 = u4.Instance:WaitForChild("Slider"):WaitForChild("Gradient")
        Gradient_4.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0, G_1, B_1)), ColorSequenceKeypoint.new(1, Color3.new(1, G_1, B_1))})
    end
    return u4
end
function tbl_1.Green(a1)
    --[[
      name: Green
      line: 153
      upvalues:
        Slider_upv_1 (copy, index: 1)
    ]]
    local u5 = Slider_upv_1.new(a1, "G", 2, 255)
    u5.OnManualChange = function(a2)
        --[[
          line: 155
          upvalues:
            a1 (copy, index: 1)
        ]]
        local v10 = a1:GetColor()
        local v11, v12, v13 = Color3.new(v10.R, a2, v10.B):ToHSV()
        a1.Color.Hue = v11
        a1.Color.Saturation = v12
        a1.Color.Value = v13
        a1:_updateColorVisuals()
    end
    u5.GetValue = function()
        --[[
          line: 163
          upvalues:
            a1 (copy, index: 1)
        ]]
        return a1:GetColor().G or 0
    end
    u5.OnValueChanged = function()
        --[[
          line: 167
          upvalues:
            a1 (copy, index: 1)
            u5 (copy, index: 2)
        ]]
        local v14 = a1:GetColor()
        local R_1 = v14.R
        local B_2 = v14.B
        local Gradient_5 = u5.Instance:WaitForChild("Slider"):WaitForChild("Gradient")
        Gradient_5.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(R_1, 0, B_2)), ColorSequenceKeypoint.new(1, Color3.new(R_1, 1, B_2))})
    end
    return u5
end
function tbl_1.Blue(a1)
    --[[
      name: Blue
      line: 181
      upvalues:
        Slider_upv_1 (copy, index: 1)
    ]]
    local u6 = Slider_upv_1.new(a1, "B", 3, 255)
    u6.OnManualChange = function(a2)
        --[[
          line: 183
          upvalues:
            a1 (copy, index: 1)
        ]]
        local v15 = a1:GetColor()
        local v16, v17, v18 = Color3.new(v15.R, v15.G, a2):ToHSV()
        a1.Color.Hue = v16
        a1.Color.Saturation = v17
        a1.Color.Value = v18
        a1:_updateColorVisuals()
    end
    u6.GetValue = function()
        --[[
          line: 191
          upvalues:
            a1 (copy, index: 1)
        ]]
        return a1:GetColor().B or 0
    end
    u6.OnValueChanged = function()
        --[[
          line: 195
          upvalues:
            a1 (copy, index: 1)
            u6 (copy, index: 2)
        ]]
        local v19 = a1:GetColor()
        local R_2 = v19.R
        local G_2 = v19.G
        local Gradient_6 = u6.Instance:WaitForChild("Slider"):WaitForChild("Gradient")
        Gradient_6.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(R_2, G_2, 0)), ColorSequenceKeypoint.new(1, Color3.new(R_2, G_2, 1))})
    end
    return u6
end
return tbl_1