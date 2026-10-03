--[[
    Script Path: Game/ReplicatedStorage/Modules/DialogueModule
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local TweenService_upv_1 = game:GetService("TweenService")
local tbl_upv_1 = {}
local u1 = nil
local tbl_upv_2 = {letterPopTime = 0.08, typeSpeed = 0.04}
tbl_upv_2.textColor = Color3.fromRGB(255, 255, 255)
tbl_upv_2.nameColor = Color3.fromRGB(176, 206, 255)
tbl_upv_2.font = Enum.Font.Michroma
tbl_upv_2.dialoguePosition = UDim2.new(0.5, 0, 0.85, 0)
local function create(a1, a2)
    --[[
      name: create
      line: 19
    ]]
    local v1 = Instance.new(a1)
    for key_1, value_1 in pairs(a2) do
        v1[key_1] = value_1
    end
    return v1
end
local function tween(a1, a2, a3, a4, a5)
    --[[
      name: tween
      line: 29
      upvalues:
        TweenService_upv_1 (copy, index: 1)
    ]]
    local v2 = a4 or (Enum.EasingStyle.Quint)
    local v3 = TweenService_upv_1:Create(a1, TweenInfo.new(a3, v2, a5 or (Enum.EasingDirection.Out)), a2)
    v3:Play()
    return v3
end
local function clearDialogue()
    --[[
      name: clearDialogue
      line: 47
      upvalues:
        u1 (ref, index: 1)
    ]]
    if not u1 then
        return
    end
    u1:Destroy()
    u1 = nil
end
function tbl_upv_1.showDialogue(a1, a2, a3, a4, a5)
    --[[
      name: showDialogue
      line: 54
      upvalues:
        u1 (ref,  index: 1)
        tbl_upv_1 (copy, index: 2)
        tbl_upv_2 (copy, index: 3)
        TweenService_upv_1 (copy, index: 4)
    ]]
    if u1 then
        u1:Destroy()
        u1 = nil
    end
    if script:FindFirstChild(a4) then
        script:FindFirstChild(a4):Play()
    end
    if script.Others:FindFirstChild(a4) then
        task.spawn(
            function()
                --[[
                  line: 62
                  upvalues:
                    a4 (ref,  index: 1)
                    tbl_upv_1 (copy, index: 2)
                    a3 (ref,  index: 3)
                    tbl_upv_2 (copy, index: 4)
                    a5 (copy, index: 5)
                    a2 (copy, index: 6)
                    u1 (ref,  index: 7)
                    TweenService_upv_1 (copy, index: 8)
                ]]
                script:FindFirstChild(a4).Ended:Wait()
                tbl_upv_1:hideDialogue()
                task.wait(0.05)
                script.Others:FindFirstChild(a4):Play()
                a3 = game.Players:GetPlayers()[math.random(1, #game.Players:GetPlayers())].Name
                a4 = script.Others:FindFirstChild(a4):GetAttribute("text")
                local v4 = table.clone(tbl_upv_2)
                if a5 then
                    for key_2, value_2 in pairs(a5) do
                        v4[key_2] = value_2
                    end
                end
                local tbl_3 = {ResetOnSpawn = false, IgnoreGuiInset = true, Name = "flexibleDialogueGui"}
                tbl_3.Parent = a2
                local v5 = Instance.new("ScreenGui")
                for key_3, value_3 in pairs(tbl_3) do
                    v5[key_3] = value_3
                end
                u1 = v5
                local tbl_4 = {BackgroundTransparency = 1}
                tbl_4.AnchorPoint = Vector2.new(0.5, 0.5)
                tbl_4.Position = v4.dialoguePosition + UDim2.new(0, 0, 0.04, 0)
                tbl_4.Size = UDim2.new(0.85, 0, 0.18, 0)
                tbl_4.Parent = v5
                local v6 = Instance.new("Frame")
                for key_4, value_4 in pairs(tbl_4) do
                    v6[key_4] = value_4
                end
                local tbl_5 = {Scale = 1}
                tbl_5.Parent = v6
                local v7 = Instance.new("UIScale")
                for key_5, value_5 in pairs(tbl_5) do
                    v7[key_5] = value_5
                end
                v7.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 1080, 0.65, 1.15)
                local tbl_6 = {TextTransparency = 1, TextStrokeTransparency = 0.5, BackgroundTransparency = 1, TextScaled = true}
                tbl_6.AnchorPoint = Vector2.new(0.5, 0)
                tbl_6.Position = UDim2.new(0.5, 0, 0, 0)
                tbl_6.Size = UDim2.new(1, 0, 0.25, 0)
                tbl_6.Text = a3
                tbl_6.Font = v4.font
                tbl_6.TextColor3 = v4.nameColor
                tbl_6.TextXAlignment = Enum.TextXAlignment.Center
                tbl_6.Parent = v6
                local v8 = Instance.new("TextLabel")
                for key_6, value_6 in pairs(tbl_6) do
                    v8[key_6] = value_6
                end
                local tbl_7 = {MaxTextSize = 55, MinTextSize = 8}
                tbl_7.Parent = v8
                local tbl_8 = Instance.new("UITextSizeConstraint")
                for key_7, value_7 in pairs(tbl_7) do
                    tbl_8[key_7] = value_7
                end
                tbl_8 = {BackgroundTransparency = 1}
                tbl_8.AnchorPoint = Vector2.new(0.5, 0)
                tbl_8.Position = UDim2.new(0.5, 0, 0.3, 0)
                tbl_8.Size = UDim2.new(1, 0, 0.7, 0)
                tbl_8.Parent = v6
                local v9 = Instance.new("Frame")
                for key_8, value_8 in pairs(tbl_8) do
                    v9[key_8] = value_8
                end
                local tbl_9 = {Wraps = true}
                tbl_9.FillDirection = Enum.FillDirection.Horizontal
                tbl_9.HorizontalAlignment = Enum.HorizontalAlignment.Center
                tbl_9.VerticalAlignment = Enum.VerticalAlignment.Center
                tbl_9.SortOrder = Enum.SortOrder.LayoutOrder
                tbl_9.Padding = UDim.new(0, 0)
                tbl_9.Parent = v9
                tbl_8 = Instance.new("UIListLayout")
                for key_9, value_9 in pairs(tbl_9) do
                    tbl_8[key_9] = value_9
                end
                local tbl_10 = {}
                tbl_10.Position = v4.dialoguePosition
                TweenService_upv_1:Create(v6, TweenInfo.new(0.45, Enum.EasingStyle.Quint or (Enum.EasingStyle.Quint), Enum.EasingDirection.Out), tbl_10):Play()
                local tbl_11 = {TextTransparency = 0}
                TweenService_upv_1:Create(v8, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), tbl_11):Play()
                for _, value_10 in utf8.codes(a4) do
                    local v10 = utf8.char(value_10)
                    local tbl_12 = {TextTransparency = 0, TextStrokeTransparency = 0.5, BackgroundTransparency = 1, TextScaled = false, TextSize = 8}
                    tbl_12.AutomaticSize = Enum.AutomaticSize.XY
                    tbl_12.Size = UDim2.new(0, 0, 0, 0)
                    tbl_12.Text = v10
                    tbl_12.Font = v4.font
                    tbl_12.TextColor3 = v4.textColor
                    tbl_12.Parent = v9
                    local v11 = Instance.new("TextLabel")
                    for key_10, value_11 in pairs(tbl_12) do
                        v11[key_10] = value_11
                    end
                    local tbl_13 = {}
                    tbl_13.TextSize = math.clamp(workspace.CurrentCamera.ViewportSize.Y * 0.25, 18, 32)
                    TweenService_upv_1:Create(v11, TweenInfo.new(v4.letterPopTime, Enum.EasingStyle.Back or (Enum.EasingStyle.Quint), Enum.EasingDirection.Out), tbl_13):Play()
                    task.wait(v4.typeSpeed)
                end
            end
        )
    end
    local v12 = table.clone(tbl_upv_2)
    if a5 then
        for key_11, value_12 in pairs(a5) do
            v12[key_11] = value_12
        end
    end
    local tbl_14 = {ResetOnSpawn = false, IgnoreGuiInset = true, Name = "flexibleDialogueGui"}
    tbl_14.Parent = a2
    local v13 = Instance.new("ScreenGui")
    for key_12, value_13 in pairs(tbl_14) do
        v13[key_12] = value_13
    end
    u1 = v13
    local tbl_15 = {BackgroundTransparency = 1}
    tbl_15.AnchorPoint = Vector2.new(0.5, 0.5)
    tbl_15.Position = v12.dialoguePosition + UDim2.new(0, 0, 0.04, 0)
    tbl_15.Size = UDim2.new(0.85, 0, 0.18, 0)
    tbl_15.Parent = v13
    local v14 = Instance.new("Frame")
    for key_13, value_14 in pairs(tbl_15) do
        v14[key_13] = value_14
    end
    local tbl_16 = {Scale = 1}
    tbl_16.Parent = v14
    local v15 = Instance.new("UIScale")
    for key_14, value_15 in pairs(tbl_16) do
        v15[key_14] = value_15
    end
    v15.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 1080, 0.65, 1.15)
    local tbl_17 = {TextTransparency = 1, TextStrokeTransparency = 0.5, BackgroundTransparency = 1, TextScaled = true}
    tbl_17.AnchorPoint = Vector2.new(0.5, 0)
    tbl_17.Position = UDim2.new(0.5, 0, 0, 0)
    tbl_17.Size = UDim2.new(1, 0, 0.25, 0)
    tbl_17.Text = a3
    tbl_17.Font = v12.font
    tbl_17.TextColor3 = v12.nameColor
    tbl_17.TextXAlignment = Enum.TextXAlignment.Center
    tbl_17.Parent = v14
    local v16 = Instance.new("TextLabel")
    for key_15, value_16 in pairs(tbl_17) do
        v16[key_15] = value_16
    end
    local tbl_18 = {MaxTextSize = 55, MinTextSize = 8}
    tbl_18.Parent = v16
    local tbl_19 = Instance.new("UITextSizeConstraint")
    for key_16, value_17 in pairs(tbl_18) do
        tbl_19[key_16] = value_17
    end
    tbl_19 = {BackgroundTransparency = 1}
    tbl_19.AnchorPoint = Vector2.new(0.5, 0)
    tbl_19.Position = UDim2.new(0.5, 0, 0.3, 0)
    tbl_19.Size = UDim2.new(1, 0, 0.7, 0)
    tbl_19.Parent = v14
    local v17 = Instance.new("Frame")
    for key_17, value_18 in pairs(tbl_19) do
        v17[key_17] = value_18
    end
    local tbl_20 = {Wraps = true}
    tbl_20.FillDirection = Enum.FillDirection.Horizontal
    tbl_20.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tbl_20.VerticalAlignment = Enum.VerticalAlignment.Center
    tbl_20.SortOrder = Enum.SortOrder.LayoutOrder
    tbl_20.Padding = UDim.new(0, 0)
    tbl_20.Parent = v17
    tbl_19 = Instance.new("UIListLayout")
    for key_18, value_19 in pairs(tbl_20) do
        tbl_19[key_18] = value_19
    end
    local tbl_21 = {}
    tbl_21.Position = v12.dialoguePosition
    TweenService_upv_1:Create(v14, TweenInfo.new(0.45, Enum.EasingStyle.Quint or (Enum.EasingStyle.Quint), Enum.EasingDirection.Out), tbl_21):Play()
    local tbl_22 = {TextTransparency = 0}
    TweenService_upv_1:Create(v16, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), tbl_22):Play()
    for _, value_20 in utf8.codes(a4) do
        local v18 = utf8.char(value_20)
        local tbl_23 = {TextTransparency = 0, TextStrokeTransparency = 0.5, BackgroundTransparency = 1, TextScaled = false, TextSize = 8}
        tbl_23.AutomaticSize = Enum.AutomaticSize.XY
        tbl_23.Size = UDim2.new(0, 0, 0, 0)
        tbl_23.Text = v18
        tbl_23.Font = v12.font
        tbl_23.TextColor3 = v12.textColor
        tbl_23.Parent = v17
        local v19 = Instance.new("TextLabel")
        for key_19, value_21 in pairs(tbl_23) do
            v19[key_19] = value_21
        end
        local tbl_24 = {}
        tbl_24.TextSize = math.clamp(workspace.CurrentCamera.ViewportSize.Y * 0.25, 18, 32)
        TweenService_upv_1:Create(v19, TweenInfo.new(v12.letterPopTime, Enum.EasingStyle.Back or (Enum.EasingStyle.Quint), Enum.EasingDirection.Out), tbl_24):Play()
        task.wait(v12.typeSpeed)
    end
    return v13
end
function tbl_upv_1.hideDialogue(a1)
    --[[
      name: hideDialogue
      line: 394
      upvalues:
        u1 (ref, index: 1)
    ]]
    if not u1 then
        return
    end
    u1:Destroy()
    u1 = nil
end
return tbl_upv_1