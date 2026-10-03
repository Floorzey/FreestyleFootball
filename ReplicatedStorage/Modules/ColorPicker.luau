--[[
    Script Path: Game/ReplicatedStorage/Modules/ColorPicker
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local UserInputService_upv_1 = game:GetService("UserInputService")
local _ = game:GetService("TweenService")
local RunService_upv_1 = game:GetService("RunService")
local GuiService_upv_1 = game:GetService("GuiService")
local LocalPlayer_upv_1 = game.Players.LocalPlayer
local PickerModes_1 = script:WaitForChild("PickerModes")
local Samples_upv_1 = script:WaitForChild("Samples")
local tbl_upv_1 = {}
tbl_upv_1.Circle = require(PickerModes_1:WaitForChild("Circle"))
tbl_upv_1.Square = require(PickerModes_1:WaitForChild("Square"))
tbl_upv_1.Triangle = require(PickerModes_1:WaitForChild("Triangle"))
local BuiltinSliders_upv_1 = require(script:WaitForChild("BuiltinSliders"))
local MouseMovement_upv_1 = require(script:WaitForChild("MouseMovement"))
local WindowResize_upv_1 = require(script:WaitForChild("WindowResize"))
local History_upv_1 = require(script:WaitForChild("History"))
local tbl_upv_2 = {}
tbl_upv_2.__index = tbl_upv_2
tbl_upv_2.COLOR_SPACE = {HSV = 1, RGB = 2}
tbl_upv_2.PICKER_MODE = {TRIANGLE = "Triangle", CIRCLE = "Circle", SQUARE = "Square"}
local function template(a1, a2)
    --[[
      name: template
      line: 72
      upvalues:
        template (copy, index: 1)
    ]]
    local tbl_3 = {}
    local v1, v2 = nil, nil
    for key_1, value_1 in pairs(a2) do
        v1 = a1[key_1]
        if v1 == nil then
            v1 = value_1
        end
        if typeof(v1) ~= "table" then
            v2 = v1
            tbl_3[key_1] = v2
            continue
        end
        v2 = template(v1, value_1) or v1
        tbl_3[key_1] = v2
    end
    return tbl_3
end
function tbl_upv_2.new(a1)
    --[[
      name: new
      line: 89
      upvalues:
        tbl_upv_2 (copy, index: 1)
        template (copy, index: 2)
        History_upv_1 (copy, index: 3)
    ]]
    local v3 = setmetatable({}, tbl_upv_2)
    local v4 = v3:GetMousePos() + Vector2.new(20, 20)
    v3.Params = template(a1 or {}, {RealTimeEventCalling = false, EnableTransparency = false, Scale = 1, Parent = "new", ZIndex = 1, Position = UDim2.fromOffset(v4.X, v4.Y), PickerMode = tbl_upv_2.PICKER_MODE.CIRCLE, ColorSpace = tbl_upv_2.COLOR_SPACE.HSV})
    v3.History = History_upv_1.new()
    v3.PickerModes = {}
    v3.Sliders = {}
    v3.Color = {Hue = 0, Saturation = 1, Value = 1}
    v3:_init()
    return v3
end
function tbl_upv_2.GetHSV(a1)
    --[[
      name: GetHSV
      line: 122
    ]]
    return a1.Color.Hue, a1.Color.Saturation, a1.Color.Value
end
function tbl_upv_2.GetColor(a1)
    --[[
      name: GetColor
      line: 126
    ]]
    return Color3.fromHSV(a1:GetHSV())
end
function tbl_upv_2.SetColor(a1, a2)
    --[[
      name: SetColor
      line: 130
    ]]
    local v5, v6, v7 = a2:ToHSV()
    a1.Color.Hue = v5
    a1.Color.Saturation = v6
    a1.Color.Value = v7
    a1:_updateColorVisuals()
    a1:WriteHistory()
    a1:_fireColorChanged()
end
function tbl_upv_2.GetTransparency(a1)
    --[[
      name: GetTransparency
      line: 138
    ]]
    if not (a1.Params.EnableTransparency) then
        print("ColorPicker:GetTransparency - Transparency isn't enabled")
    end
    return a1.Color.Transparency
end
function tbl_upv_2.SetTransparency(a1, a2)
    --[[
      name: SetTransparency
      line: 143
    ]]
    if a1.Params.EnableTransparency then
        a1.Color.Transparency = math.clamp(a2, 0, 1)
        a1:_updateColorVisuals()
    else
        print("ColorPicker:SetTransparency - Transparency isn't enabled")
    end
end
function tbl_upv_2._setSliderVisible(a1, a2, a3)
    --[[
      name: _setSliderVisible
      line: 150
    ]]
    if a3 and a2.GetValue then
        a2.Value = a2.GetValue()
        a2:UpdateVisual()
    end
    a2:SetVisible(a3)
end
function tbl_upv_2._updateColorSpace(a1)
    --[[
      name: _updateColorSpace
      line: 159
      upvalues:
        tbl_upv_2 (copy, index: 1)
    ]]
    local TextLabel_1 = a1.Instance:WaitForChild("Middle"):WaitForChild("Right"):WaitForChild("ColorSpace"):WaitForChild("TextLabel")
    local v8 = a1.ColorSpace == tbl_upv_2.COLOR_SPACE.HSV
    local v9
    if v8 then
        v9 = "HSV"
    else
        v9 = "RGB"
    end
    TextLabel_1.Text = v9
    a1:_setSliderVisible(a1.Sliders.Hue, v8)
    a1:_setSliderVisible(a1.Sliders.Saturation, v8)
    a1:_setSliderVisible(a1.Sliders.Value, v8)
    a1:_setSliderVisible(a1.Sliders.Red, not v8)
    a1:_setSliderVisible(a1.Sliders.Green, not v8)
    a1:_setSliderVisible(a1.Sliders.Blue, not v8)
    a1:_updateSize()
end
function tbl_upv_2.SetColorSpace(a1, a2)
    --[[
      name: SetColorSpace
      line: 181
    ]]
    a1.ColorSpace = a2
    a1:_updateColorSpace()
end
function tbl_upv_2._updatePickerMode(a1)
    --[[
      name: _updatePickerMode
      line: 186
    ]]
    for key_2, value_2 in pairs(a1.PickerModes) do
        value_2:SetVisible(key_2 == a1.PickerMode)
    end
    local v10 = nil
    for _, value_3 in pairs(a1.Instance:WaitForChild("Options"):WaitForChild("PickerMode"):GetChildren()) do
        if not (value_3:IsA("Frame")) then
            continue
        end
        local v11 = value_3.Name == a1.PickerMode
        local Icon_1 = value_3.Icon
        if v11 then
            v10 = 0
        else
            v10 = 0.5
        end
        Icon_1.ImageTransparency = v10
        value_3.Selected.Visible = v11
    end
    a1:_updateColorVisuals()
end
function tbl_upv_2.SetPickerMode(a1, a2)
    --[[
      name: SetPickerMode
      line: 203
    ]]
    a1.PickerMode = a2
    a1:_updatePickerMode()
end
function tbl_upv_2._getPickerMode(a1, a2)
    --[[
      name: _getPickerMode
      line: 208
      upvalues:
        tbl_upv_1 (copy, index: 1)
    ]]
    if not (a1.PickerModes[a2]) then
        a1.PickerModes[a2] = tbl_upv_1[a2].new(a1)
    end
    return a1.PickerModes[a2]
end
function tbl_upv_2._fireColorChanged(a1)
    --[[
      name: _fireColorChanged
      line: 216
    ]]
    a1._colorChangedEvent:Fire(a1:GetColor(), a1.Color.Transparency or 0)
end
function tbl_upv_2.GetMousePos(a1)
    --[[
      name: GetMousePos
      line: 220
      upvalues:
        GuiService_upv_1 (copy, index: 1)
        UserInputService_upv_1 (copy, index: 2)
    ]]
    return UserInputService_upv_1:GetMouseLocation() - Vector2.new(0, GuiService_upv_1.TopbarInset.Height)
end
function tbl_upv_2._updateColorVisuals(a1)
    --[[
      name: _updateColorVisuals
      line: 225
      upvalues:
        tbl_upv_2 (copy, index: 1)
    ]]
    local v12 = a1:_getPickerMode(a1.PickerMode)
    local v13, v14, v15 = a1:GetHSV()
    local Select_1 = a1.Instance:WaitForChild("Picker"):WaitForChild("Select")
    Select_1.ImageColor3 = Color3.fromHSV(0, 0, ((a1.PickerMode == tbl_upv_2.PICKER_MODE.CIRCLE) and (0.4 + v15 * 0.6)) or 1)
    Select_1.Position = v12:GetPointerPositionFromColor(v13, v14, v15)
    if v12.ColorChanged then
        v12:ColorChanged()
    end
    local Middle_1 = a1.Instance:WaitForChild("Middle")
    local Color_1 = Middle_1:WaitForChild("Right"):WaitForChild("Color")
    Color_1.BackgroundColor3 = a1:GetColor()
    Color_1.BackgroundTransparency = a1.Color.Transparency or 0
    local Input_1 = Middle_1:WaitForChild("Hex"):WaitForChild("Input")
    Input_1.Text = string.format("#%s", a1:GetColor():ToHex())
    for _, value_4 in pairs(a1.Sliders) do
        if not (value_4.Visible) then
            continue
        end
        if value_4.GetValue then
            value_4:ColorAdjusted()
        end
    end
end
function tbl_upv_2._updateSize(a1)
    --[[
      name: _updateSize
      line: 256
    ]]
    local v16 = 0
    for _, value_5 in pairs(a1.Sliders) do
        v16 = ((value_5.Visible) and (v16 + 1)) or v16
    end
    local Instance_1 = a1.Instance
    Instance_1.Size = UDim2.fromOffset(238, 256 + (((v16 > 0) and (v16 * 26)) or 0))
end
function tbl_upv_2._updateHistoryVisuals(a1)
    --[[
      name: _updateHistoryVisuals
      line: 267
    ]]
    local History_2 = a1.Instance:WaitForChild("Options"):WaitForChild("History")
    local Button_1 = History_2:WaitForChild("Undo"):WaitForChild("Button")
    local Button_2 = History_2:WaitForChild("Redo"):WaitForChild("Button")
    Button_1.ImageTransparency = ((a1.History._currentIndex <= 1) and 0.5) or 0
    Button_2.ImageTransparency = ((a1.History._currentIndex ~= #a1.History.Records) and 0) or 0.5
end
function tbl_upv_2.WriteHistory(a1)
    --[[
      name: WriteHistory
      line: 276
    ]]
    a1.History:WriteHistory(table.clone(a1.Color))
    a1:_updateHistoryVisuals()
end
function tbl_upv_2.IncrementHistory(a1, a2)
    --[[
      name: IncrementHistory
      line: 281
    ]]
    local v17 = a1.History:IncrementHistory(a2)
    if not v17 then
        return
    end
    a1.Color = table.clone(v17)
    a1:_updateHistoryVisuals()
    a1:_updateColorVisuals()
    a1:_fireColorChanged()
end
function tbl_upv_2._create(a1)
    --[[
      name: _create
      line: 292
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        Samples_upv_1 (copy, index: 2)
        MouseMovement_upv_1 (copy, index: 3)
        tbl_upv_2 (copy, index: 4)
        WindowResize_upv_1 (copy, index: 5)
        UserInputService_upv_1 (copy, index: 6)
        RunService_upv_1 (copy, index: 7)
    ]]
    a1.UI = a1.Params.Parent
    if (a1.UI) and a1.UI ~= "new" then
        assert(a1.UI.ZIndexBehavior == Enum.ZIndexBehavior.Sibling, "ColorPicker - ZIndexBehavior needs to be 'Sibling'")
    else
        local v18 = Instance.new("ScreenGui")
        v18.Name = "COLOR_PICKER_UI"
        v18.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        v18.Parent = LocalPlayer_upv_1:WaitForChild("PlayerGui")
        a1.UI = v18
        a1._deleteUIOnClose = true
    end
    local v19 = Samples_upv_1:WaitForChild("ColorPickerSample"):Clone()
    v19.Position = a1.Params.Position
    v19.ZIndex = a1.Params.ZIndex
    v19.Parent = a1.UI
    a1.Instance = v19
    local Picker_upv_1 = a1.Instance:WaitForChild("Picker")
    a1._pickerMouseMovement = MouseMovement_upv_1.new(
        function()
            --[[
              line: 315
              upvalues:
                a1 (copy, index: 1)
                Picker_upv_1 (copy, index: 2)
            ]]
            local v20 = a1:GetMousePos()
            local Color_2 = a1.Color
            local Color_3 = a1.Color
            local Color_4 = a1.Color
            local v21, v22, v23 = a1:_getPickerMode(a1.PickerMode):GetColor((v20 - Picker_upv_1.AbsolutePosition) / Picker_upv_1.AbsoluteSize)
            Color_2.Hue = v21
            Color_3.Saturation = v22
            Color_4.Value = v23
            a1:_updateColorVisuals()
            if not a1.Params.RealTimeEventCalling then
                return
            end
            a1:_fireColorChanged()
        end
    )
    a1._pickerMouseMovement:OnDisconnect(
        function()
            --[[
              line: 325
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1:_fireColorChanged()
            a1:WriteHistory()
        end
    )
    Picker_upv_1:WaitForChild("Button").MouseButton1Down:Connect(
        function()
            --[[
              line: 330
              upvalues:
                a1 (copy, index: 1)
            ]]
            a1._pickerMouseMovement:Connect()
        end
    )
    local Middle_2 = a1.Instance:WaitForChild("Middle")
    local Input_upv_2 = Middle_2:WaitForChild("Hex"):WaitForChild("Input")
    Input_upv_2.FocusLost:Connect(
        function()
            --[[
              line: 337
              upvalues:
                Input_upv_2 (copy, index: 1)
                a1 (copy, index: 2)
            ]]
            local success_1, v24 = pcall(
                function()
                    --[[
                      line: 338
                      upvalues:
                        Input_upv_2 (copy, index: 1)
                    ]]
                    return Color3.fromHex(Input_upv_2.Text)
                end
            )
            local v25 = (success_1 and v24) or (Color3.new(1, 1, 1))
            a1:SetColor(v25)
        end
    )
    Middle_2:WaitForChild("Right"):WaitForChild("ColorSpace"):WaitForChild("Button").MouseButton1Down:Connect(
        function()
            --[[
              line: 345
              upvalues:
                a1 (copy, index: 1)
                tbl_upv_2 (copy, index: 2)
            ]]
            a1:SetColorSpace(((a1.ColorSpace == tbl_upv_2.COLOR_SPACE.HSV) and (tbl_upv_2.COLOR_SPACE.RGB)) or (tbl_upv_2.COLOR_SPACE.HSV))
        end
    )
    a1._windowAdjust = MouseMovement_upv_1.new(
        function(a2, a3)
            --[[
              line: 351
              upvalues:
                a1 (copy, index: 1)
            ]]
            local v26 = a1:GetMousePos() or (Vector2.zero)
            local v27 = v26 - a2
            a1.Instance.Position = a3 + UDim2.fromOffset(v27.X, v27.Y)
        end
    )
    a1.Instance:WaitForChild("Topbar"):WaitForChild("Button").MouseButton1Down:Connect(
        function()
            --[[
              line: 358
              upvalues:
                a1 (copy, index: 1)
            ]]
            local _windowAdjust_1 = a1._windowAdjust
            local v28 = a1:GetMousePos() or (Vector2.zero)
            _windowAdjust_1:Connect(v28, a1.Instance.Position)
        end
    )
    a1.WindowResize = WindowResize_upv_1.new(a1)
    if not (UserInputService_upv_1.TouchEnabled) and UserInputService_upv_1.KeyboardEnabled and UserInputService_upv_1.MouseEnabled then
        a1.WindowResize:Create()
    end
    a1.WindowResize:SetScale(a1.Params.Scale)
    for _, value_upv_6 in pairs(a1.Instance:WaitForChild("Options"):WaitForChild("PickerMode"):GetChildren()) do
        if value_upv_6:IsA("Frame") then
            value_upv_6.Button.MouseButton1Down:Connect(
                function()
                    --[[
                      line: 384
                      upvalues:
                        a1 (copy, index: 1)
                        value_upv_6 (copy, index: 2)
                    ]]
                    a1:SetPickerMode(value_upv_6.Name)
                end
            )
        end
    end
    local History_3 = a1.Instance:WaitForChild("Options"):WaitForChild("History")
    local Button_3 = History_3:WaitForChild("Undo"):WaitForChild("Button")
    local v29 = History_3:WaitForChild("Redo"):WaitForChild("Button")
    local function _historyActionMouseDown(a4)
        --[[
          name: _historyActionMouseDown
          line: 396
          upvalues:
            a1 (copy, index: 1)
            RunService_upv_1 (copy, index: 2)
        ]]
        a1:IncrementHistory(a4)
        local _ = nil
        local v30 = os.clock()
        local v32 = v30 + 0.5
        local v31 = RunService_upv_1.Heartbeat:Connect(function() end)
        _ = v31
    end
    Button_3.MouseButton1Down:Connect(
        function()
            --[[
              line: 416
              upvalues:
                a1 (copy, index: 1)
                RunService_upv_1 (copy, index: 2)
            ]]
            a1:IncrementHistory(-1)
            local _ = nil
            local v32 = os.clock()
            local v34 = v32 + 0.5
            local v35 = -1
            local v33 = RunService_upv_1.Heartbeat:Connect(function() end)
            _ = v33
        end
    )
    v29.MouseButton1Down:Connect(
        function()
            --[[
              line: 417
              upvalues:
                a1 (copy, index: 1)
                RunService_upv_1 (copy, index: 2)
                UserInputService_upv_1 (copy, index: 3)
            ]]
            a1:IncrementHistory(1)
            local u1 = nil
            local v34 = os.clock()
            local u2 = v34 + 0.5
            local u3 = 1
            local v35 = RunService_upv_1.Heartbeat:Connect(
                function()
                    --[[
                      line: 401
                      upvalues:
                        UserInputService_upv_1 (copy, index: 1)
                        u1 (ref,  index: 2)
                        u2 (ref,  index: 3)
                        a1 (copy, index: 4)
                        u3 (copy, index: 5)
                    ]]
                    if UserInputService_upv_1:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                        local v36 = os.clock()
                        if u2 <= v36 then
                            a1:IncrementHistory(u3)
                            u2 = os.clock() + 0.1
                        end
                    else
                        u1:Disconnect()
                        u1 = nil
                    end
                end
            )
            u1 = v35
        end
    )
    if a1.Params.EnableTransparency then
        local Color_5 = a1.Instance:WaitForChild("Middle"):WaitForChild("Right"):WaitForChild("Color")
        local v37 = Instance.new("ImageLabel")
        v37.Image = "rbxassetid://111137375763311"
        v37.ImageColor3 = Color3.new(1, 1, 1)
        v37.ImageTransparency = 0.5
        v37.ScaleType = Enum.ScaleType.Tile
        v37.TileSize = UDim2.fromOffset(14, 14)
        v37.ZIndex = -1
        v37.BackgroundTransparency = 1
        v37.Position = Color_5.Position
        v37.Size = Color_5.Size
        v37.Parent = Color_5.Parent
        local v38 = Instance.new("UICorner")
        v38.CornerRadius = UDim.new(0, 4)
        v38.Parent = v37
    end
end
function tbl_upv_2._init(a1)
    --[[
      name: _init
      line: 449
      upvalues:
        BuiltinSliders_upv_1 (copy, index: 1)
    ]]
    a1:_create()
    a1._colorChangedEvent = Instance.new("BindableEvent")
    a1.ColorChanged = a1._colorChangedEvent.Event
    a1._windowClosedEvent = Instance.new("BindableEvent")
    a1.WindowClosed = a1._windowClosedEvent.Event
    a1.Sliders.Hue = BuiltinSliders_upv_1.Hue(a1)
    a1.Sliders.Saturation = BuiltinSliders_upv_1.Saturation(a1)
    a1.Sliders.Value = BuiltinSliders_upv_1.Value(a1)
    a1.Sliders.Red = BuiltinSliders_upv_1.Red(a1)
    a1.Sliders.Green = BuiltinSliders_upv_1.Green(a1)
    a1.Sliders.Blue = BuiltinSliders_upv_1.Blue(a1)
    if a1.Params.EnableTransparency then
        a1.Sliders.Transparency = BuiltinSliders_upv_1.Transparency(a1)
        a1.Sliders.Transparency:SetVisible(true)
    end
    a1:SetPickerMode(a1.Params.PickerMode)
    a1:SetColorSpace(a1.Params.ColorSpace)
    a1.Color.Hue = 0
    a1.Color.Saturation = 0
    a1.Color.Value = 1
    a1:_updateColorVisuals()
    a1:_updateSize()
    a1.Instance.Visible = true
end
function tbl_upv_2.Destroy(a1)
    --[[
      name: Destroy
      line: 486
    ]]
    for _, value_7 in pairs(a1.Sliders) do
        value_7:Destroy()
    end
    for _, value_8 in pairs({"_colorChangedEvent", "_windowClosedEvent", "History", "_windowAdjust", "_pickerMouseMovement", "Instance", "WindowResize"}) do
        if value_8 then
            a1[value_8]:Destroy()
            a1[value_8] = nil
        end
    end
    if not a1.UI or not a1._deleteUIOnClose then
        return
    end
    a1.UI:Destroy()
    a1.UI = nil
end
return tbl_upv_2