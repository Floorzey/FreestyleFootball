--[[
    Script Path: Game/ReplicatedStorage/Modules/ColorPicker/PickerModes/Square
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.new(a1)
    --[[
      name: new
      line: 4
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v1 = setmetatable({}, tbl_upv_1)
    v1.ColorPicker = a1
    v1:Init()
    return v1
end
function tbl_upv_1.Init(a1)
    --[[
      name: Init
      line: 12
    ]]
    local v2 = Instance.new("CanvasGroup")
    v2.BackgroundTransparency = 0
    v2.BackgroundColor3 = Color3.new(1, 1, 1)
    v2.Size = UDim2.fromScale(1, 1)
    v2.Parent = a1.ColorPicker.Instance:WaitForChild("Picker")
    local v3 = Instance.new("UICorner")
    v3.CornerRadius = UDim.new(0, 6)
    v3.Parent = v2
    local v4 = Instance.new("UIGradient")
    v4.Color = ColorSequence.new(Color3.new(1, 1, 1))
    v4.Parent = v2
    local v5 = Instance.new("Frame")
    v5.BackgroundColor3 = Color3.new(0, 0, 0)
    v5.BackgroundTransparency = 0
    v5.Size = UDim2.fromScale(1, 1)
    v5.Parent = v2
    local v6 = Instance.new("UIGradient")
    v6.Color = ColorSequence.new(Color3.new(0, 0, 0))
    v6.Rotation = -90
    v6.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
    v6.Parent = v5
    a1.Instance = v2
    a1.Gradient = v4
end
function tbl_upv_1.SetVisible(a1, a2)
    --[[
      name: SetVisible
      line: 43
    ]]
    a1.Instance.Visible = a2
end
function tbl_upv_1.GetColor(a1, a2)
    --[[
      name: GetColor
      line: 47
    ]]
    return a1.ColorPicker.Color.Hue, math.clamp(a2.X, 0, 1), (math.clamp(1 - a2.Y, 0, 1))
end
function tbl_upv_1.GetPointerPositionFromColor(a1, a2, a3, a4)
    --[[
      name: GetPointerPositionFromColor
      line: 51
    ]]
    return UDim2.fromScale(a3, 1 - a4)
end
function tbl_upv_1.ColorChanged(a1)
    --[[
      name: ColorChanged
      line: 55
    ]]
    a1.Gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(a1.ColorPicker.Color.Hue, 1, 1))})
end
return tbl_upv_1