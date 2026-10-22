--[[
    Script Path: Game/ReplicatedStorage/Modules/ColorPicker/PickerModes/Circle
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
local function toPolar(a1)
    --[[
      name: toPolar
      line: 4
    ]]
    return math.atan2(a1.Y, a1.X), a1.Magnitude
end
function tbl_upv_1.new(a1)
    --[[
      name: new
      line: 8
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
      line: 16
    ]]
    local v2 = Instance.new("ImageLabel")
    v2.Size = UDim2.fromScale(1, 1)
    v2.BackgroundTransparency = 1
    v2.Image = "rbxassetid://117857197662540"
    v2.Parent = a1.ColorPicker.Instance:WaitForChild("Picker")
    a1.Instance = v2
end
function tbl_upv_1.SetVisible(a1, a2)
    --[[
      name: SetVisible
      line: 26
    ]]
    a1.Instance.Visible = a2
end
function tbl_upv_1.GetColor(a1, a2)
    --[[
      name: GetColor
      line: 30
    ]]
    local v3 = (a2 - Vector2.new(0.5, 0.5)) * Vector2.new(1, -1)
    return math.clamp((math.atan2(v3.Y, v3.X) + math.pi) / math.tau, 0, 1), math.clamp(v3.Magnitude * 2, 0, 1), a1.ColorPicker.Color.Value
end
function tbl_upv_1.GetPointerPositionFromColor(a1, a2, a3, a4)
    --[[
      name: GetPointerPositionFromColor
      line: 39
    ]]
    local v4 = a2 * math.pi * 2
    return UDim2.fromScale(0.5 - ((math.cos(v4) / 2) * a3), 0.5 + ((math.sin(v4) / 2) * a3))
end
return tbl_upv_1