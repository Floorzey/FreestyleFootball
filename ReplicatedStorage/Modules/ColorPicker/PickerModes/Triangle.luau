--[[
    Script Path: Game/ReplicatedStorage/Modules/ColorPicker/PickerModes/Triangle
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
local function heightToTriangleHeight(a1)
    --[[
      name: heightToTriangleHeight
      line: 5
    ]]
    return (a1 / 0.8660254037844386) - 0.0669872981077807
end
local tbl_upv_2 = {}
tbl_upv_2[1] = Vector2.new(0.5, 0)
tbl_upv_2[2] = Vector2.new(0, 1)
tbl_upv_2[3] = Vector2.new(1, 1)
function tbl_upv_1.new(a1)
    --[[
      name: new
      line: 16
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
      line: 24
    ]]
    local v2 = Instance.new("Frame")
    v2.BackgroundTransparency = 1
    v2.Size = UDim2.fromScale(1, 1)
    v2.Parent = a1.ColorPicker.Instance:WaitForChild("Picker")
    local v3 = Instance.new("ImageLabel")
    v3.BackgroundTransparency = 1
    v3.Size = UDim2.fromScale(1, 1)
    v3.Image = "rbxassetid://119614645478849"
    v3.ImageColor3 = Color3.new(1, 0, 0)
    v3.ZIndex = 1
    v3.Parent = v2
    local v4 = Instance.new("ImageLabel")
    v4.BackgroundTransparency = 1
    v4.Size = UDim2.fromScale(1, 1)
    v4.Image = "rbxassetid://114393129271758"
    v4.ImageColor3 = Color3.new(1, 1, 1)
    v4.ZIndex = 2
    v4.Parent = v2
    local v5 = Instance.new("ImageLabel")
    v5.BackgroundTransparency = 1
    v5.Size = UDim2.fromScale(1, 1)
    v5.Image = "rbxassetid://90395096352510"
    v5.ImageColor3 = Color3.new(1, 1, 1)
    v5.ZIndex = 3
    v5.Parent = v2
    a1.Instance = v2
    a1.ColorImage = v3
end
function tbl_upv_1.SetVisible(a1, a2)
    --[[
      name: SetVisible
      line: 58
    ]]
    a1.Instance.Visible = a2
end
function tbl_upv_1.GetColor(a1, a2)
    --[[
      name: GetColor
      line: 62
      upvalues:
        tbl_upv_2 (copy, index: 1)
    ]]
    local v6 = math.clamp((a2.Y / 0.8660254037844386) - 0.0669872981077807, 0, 1)
    local v7 = math.clamp(a2.X, 0.5 - (v6 / 2), (v6 / 2) + 0.5)
    local v8 = tbl_upv_2[1]
    local v9 = tbl_upv_2[2]
    local v10 = tbl_upv_2[3]
    local v11 = (((v9.Y - v10.Y) * (v7 - v10.X)) + ((v10.X - v9.X) * (v6 - v10.Y))) / (((v9.Y - v10.Y) * (v8.X - v10.X)) + ((v10.X - v9.X) * (v8.Y - v10.Y)))
    local v12 = (((v10.Y - v8.Y) * (v7 - v10.X)) + ((v8.X - v10.X) * (v6 - v10.Y))) / (((v9.Y - v10.Y) * (v8.X - v10.X)) + ((v10.X - v9.X) * (v8.Y - v10.Y)))
    local v13 = math.clamp(v11, 0, 1)
    local v14 = math.clamp(v12, 0, 1)
    local v15 = math.clamp((1 - v11) - v12, 0, 1)
    local v16 = Color3.fromHSV(a1.ColorPicker.Color.Hue, 1, 1)
    local _, v17, v18 = Color3.new(((v13 * v16.R) + (v14 * 0)) + (v15 * 1), ((v13 * v16.G) + (v14 * 0)) + (v15 * 1), ((v13 * v16.B) + (v14 * 0)) + (v15 * 1)):ToHSV()
    return a1.ColorPicker.Color.Hue, v17, v18
end
function tbl_upv_1.GetPointerPositionFromColor(a1, a2, a3, a4)
    --[[
      name: GetPointerPositionFromColor
      line: 107
    ]]
    local v19 = Vector2.new(0.5, 0):Lerp(Vector2.new(1, 1), 1 - a3):Lerp(Vector2.new(0, 1), 1 - a4)
    return UDim2.fromScale(v19.X, 0.0669872981077807 + (v19.Y * 0.8660254037844386))
end
function tbl_upv_1.ColorChanged(a1)
    --[[
      name: ColorChanged
      line: 112
    ]]
    a1.ColorImage.ImageColor3 = Color3.fromHSV(a1.ColorPicker.Color.Hue, 1, 1)
end
return tbl_upv_1