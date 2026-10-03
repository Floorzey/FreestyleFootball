--[[
    Script Path: Game/ReplicatedStorage/Modules/ColorPicker/Slider
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local _ = game:GetService("UserInputService")
local v1 = game:GetService("RunService")
local Samples_upv_1 = script.Parent:WaitForChild("Samples")
local MouseMovement_upv_1 = require(script.Parent:WaitForChild("MouseMovement"))
local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
local function lerp(a1, a2, a3)
    --[[
      name: lerp
      line: 10
    ]]
    return a1 + ((a2 - a1) * a3)
end
function tbl_upv_1.new(a1, a2, a3, a4)
    --[[
      name: new
      line: 14
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v1 = setmetatable({}, tbl_upv_1)
    v1.ColorPicker = a1
    v1.TextLabel = a2
    v1.Priority = a3
    v1.MaxValue = a4
    v1.Visible = true
    v1.Value = 0
    v1:Init()
    return v1
end
function tbl_upv_1.Create(a1)
    --[[
      name: Create
      line: 27
      upvalues:
        Samples_upv_1 (copy, index: 1)
    ]]
    local Sliders_1 = a1.ColorPicker.Instance:WaitForChild("Sliders")
    local v2 = Samples_upv_1:WaitForChild("SliderSample"):Clone()
    v2.Name = string.format("%02d", a1.Priority)
    v2.Text.Text = a1.TextLabel
    v2.Parent = Sliders_1
    a1.Instance = v2
end
function tbl_upv_1.SetValue(a1, a2)
    --[[
      name: SetValue
      line: 38
    ]]
    a1.Value = math.clamp(a2, 0, 1)
    if a1.OnManualChange then
        a1.OnManualChange(a1.Value)
    end
    a1:UpdateVisual()
end
function tbl_upv_1.SetVisible(a1, a2)
    --[[
      name: SetVisible
      line: 49
    ]]
    a1.Visible = a2
    a1.Instance.Visible = a1.Visible
end
function tbl_upv_1.UpdateVisual(a1)
    --[[
      name: UpdateVisual
      line: 54
    ]]
    local Slider_1 = a1.Instance:WaitForChild("Slider")
    local Select_1 = Slider_1:WaitForChild("Select")
    local Input_1 = a1.Instance:WaitForChild("Input")
    Select_1.Position = UDim2.new(0, -3 + (((Slider_1.Size.X.Offset - 14) - -3) * a1.Value), 0.5, 0)
    Input_1.Text = math.round(a1.Value * a1.MaxValue)
    if not a1.OnValueChanged then
        return
    end
    a1.OnValueChanged()
end
function tbl_upv_1.ColorAdjusted(a1)
    --[[
      name: ColorAdjusted
      line: 67
    ]]
    if not a1.GetValue then
        return
    end
    a1.Value = a1.GetValue()
    a1:UpdateVisual()
end
function tbl_upv_1.Init(a1)
    --[[
      name: Init
      line: 74
      upvalues:
        MouseMovement_upv_1 (copy, index: 1)
    ]]
    a1:Create()
    a1:SetVisible(false)
    local SliderButton_1 = a1.Instance:WaitForChild("SliderButton")
    local Slider_upv_2 = a1.Instance:WaitForChild("Slider")
    a1._mouseMovement = MouseMovement_upv_1.new(
        function()
            --[[
              line: 81
              upvalues:
                a1 (copy, index: 1)
                Slider_upv_2 (copy, index: 2)
            ]]
            local v3 = math.clamp(((a1.ColorPicker:GetMousePos() - Vector2.new(4, 0)).X - Slider_upv_2.AbsolutePosition.X) / (Slider_upv_2.AbsoluteSize.X - 10), 0, 1)
            if a1.Value == v3 then
                return
            end
            a1:SetValue(v3)
            if not a1.ColorPicker.Params.RealTimeEventCalling then
                return
            end
            a1.ColorPicker:_fireColorChanged()
        end
    )
    a1._mouseMovement:OnDisconnect(
        function()
            --[[
              line: 93
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1.ColorPicker:_fireColorChanged()
            a1.ColorPicker:WriteHistory()
        end
    )
    SliderButton_1.MouseButton1Down:Connect(
        function()
            --[[
              line: 98
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1._mouseMovement:Connect()
        end
    )
    local Input_upv_2 = a1.Instance:WaitForChild("Input")
    Input_upv_2.FocusLost:Connect(
        function()
            --[[
              line: 103
              upvalues:
                Input_upv_2 (copy, index: 1)
                a1 (copy, index: 2)
            ]]
            a1:SetValue((tonumber(Input_upv_2.Text) or 0) / a1.MaxValue)
            a1.ColorPicker:WriteHistory()
            a1.ColorPicker:_fireColorChanged()
        end
    )
end
function tbl_upv_1.Destroy(a1)
    --[[
      name: Destroy
      line: 112
    ]]
    if a1._mouseMovement then
        a1._mouseMovement:Destroy()
        a1._mouseMovement = nil
    end
    if not a1.Instance then
        return
    end
    a1.Instance:Destroy()
    a1.Instance = nil
end
return tbl_upv_1