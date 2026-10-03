--[[
    Script Path: Game/ReplicatedStorage/Modules/ColorPicker/WindowResize
    Class: ModuleScript
    Time: 2026-10-03 12:27:10
--]]

local MouseMovement_upv_1 = require(script.Parent:WaitForChild("MouseMovement"))
local TweenService_upv_1 = game:GetService("TweenService")
local tbl_upv_1 = {}
tbl_upv_1.__index = tbl_upv_1
function tbl_upv_1.new(a1)
    --[[
      name: new
      line: 7
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    local v1 = setmetatable({}, tbl_upv_1)
    v1.ColorPicker = a1
    v1.ScaleElement = a1.Instance:WaitForChild("UIScale")
    v1.Window = a1.Instance
    v1.InfoMenu = v1.Window:WaitForChild("Info")
    v1.InputBox = v1.InfoMenu:WaitForChild("Scale"):WaitForChild("Input")
    v1:Init()
    return v1
end
function tbl_upv_1.GetScaleBounds(a1)
    --[[
      name: GetScaleBounds
      line: 20
    ]]
    return 1, (math.max(math.floor(a1.ColorPicker.UI.AbsoluteSize.Y / 250), 2))
end
function tbl_upv_1.SetScale(a1, a2)
    --[[
      name: SetScale
      line: 24
    ]]
    local v2 = math.round(math.clamp(a2, a1:GetScaleBounds()) * 100) / 100
    a1.ScaleElement.Scale = v2
    a1.InputBox.Text = tostring(v2)
end
function tbl_upv_1.Init(a1)
    --[[
      name: Init
      line: 31
    ]]
    a1.InputBox.FocusLost:Connect(
        function()
            --[[
              line: 32
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1:SetScale(tonumber(a1.InputBox.Text) or 1)
        end
    )
end
function tbl_upv_1.Create(a1)
    --[[
      name: Create
      line: 37
      upvalues:
        TweenService_upv_1 (copy, index: 1)
        MouseMovement_upv_1 (copy, index: 2)
    ]]
    local u1 = script.Parent:WaitForChild("Samples"):WaitForChild("ResizeFrame"):Clone()
    u1.Frame.BackgroundTransparency = 1
    u1.Parent = a1.ColorPicker.Instance
    u1.MouseEnter:Connect(
        function()
            --[[
              line: 43
              upvalues:
                TweenService_upv_1 (copy, index: 1)
                u1 (copy, index: 2)
            ]]
            local tbl_2 = {BackgroundTransparency = 0.5}
            TweenService_upv_1:Create(u1.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), tbl_2):Play()
        end
    )
    u1.MouseLeave:Connect(
        function()
            --[[
              line: 51
              upvalues:
                TweenService_upv_1 (copy, index: 1)
                u1 (copy, index: 2)
            ]]
            local tbl_3 = {BackgroundTransparency = 1}
            TweenService_upv_1:Create(u1.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), tbl_3):Play()
        end
    )
    a1._mouseMovement = MouseMovement_upv_1.new(
        function(a2, a3)
            --[[
              line: 59
              upvalues:
                a1 (copy, index: 1)
            ]]
            local v3 = a3 + (a1.ColorPicker:GetMousePos().X - a2.X) / a1.Window.Size.X.Offset
            if math.abs(a3 - v3) <= 0.05 then
                v3 = a3
            elseif math.abs(math.round(v3) - v3) <= 0.075 then
                v3 = math.round(v3)
            end
            a1:SetScale(v3)
        end
    )
    local UIScale_upv_1 = a1.ColorPicker.Instance:WaitForChild("UIScale")
    u1.Button.MouseButton1Down:Connect(
        function()
            --[[
              line: 71
              upvalues:
                a1 (copy, index: 1)
                UIScale_upv_1 (copy, index: 2)
            ]]
            a1._mouseMovement:Connect(a1.ColorPicker:GetMousePos(), UIScale_upv_1.Scale)
        end
    )
    a1.Instance = u1
end
function tbl_upv_1.Destroy(a1)
    --[[
      name: Destroy
      line: 80
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