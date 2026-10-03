--[[
    Script Path: Game/StarterGui/GambaUI/GambaHandler
    Class: LocalScript
    Time: 2026-10-03 12:27:08
--]]

local LocalPlayer_upv_1 = game.Players.LocalPlayer
local UpperShutter_upv_1 = script.Parent.UpperShutter
local LowerShutter_upv_1 = script.Parent.LowerShutter
local SpecialVignette_upv_1 = script.Parent.SpecialVignette
local Vignette_upv_1 = script.Parent.Vignette
local Flashbang_upv_1 = script.Parent.Flashbang
local MiddleFrame_upv_1 = script.Parent.MiddleFrame
local ItemName_upv_1 = MiddleFrame_upv_1.ItemName
local Icon_upv_1 = MiddleFrame_upv_1.Icon
local Duplicate_upv_1 = MiddleFrame_upv_1.Duplicate
function shutter()
    --[[
      name: shutter
      line: 16
      upvalues:
        UpperShutter_upv_1 (copy, index: 1)
        LowerShutter_upv_1 (copy, index: 2)
    ]]
    UpperShutter_upv_1.Visible = true
    LowerShutter_upv_1.Visible = true
    local TweenService_1 = game:GetService("TweenService")
    local v1 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_1 = {}
    tbl_1.Size = UDim2.new(1, 0, 0.7, 0)
    TweenService_1:Create(LowerShutter_upv_1, v1, tbl_1):Play()
    local TweenService_2 = game:GetService("TweenService")
    local v2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tbl_2 = {}
    tbl_2.Size = UDim2.new(1, 0, 0.7, 0)
    TweenService_2:Create(UpperShutter_upv_1, v2, tbl_2):Play()
end
function unshutter()
    --[[
      name: unshutter
      line: 27
      upvalues:
        LowerShutter_upv_1 (copy, index: 1)
        UpperShutter_upv_1 (copy, index: 2)
    ]]
    task.spawn(
        function()
            --[[
              line: 28
              upvalues:
                LowerShutter_upv_1 (copy, index: 1)
                UpperShutter_upv_1 (copy, index: 2)
            ]]
            local TweenService_3 = game:GetService("TweenService")
            local v3 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_3 = {}
            tbl_3.Size = UDim2.new(1, 0, 0, 0)
            TweenService_3:Create(LowerShutter_upv_1, v3, tbl_3):Play()
            local TweenService_4 = game:GetService("TweenService")
            local v4 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_4 = {}
            tbl_4.Size = UDim2.new(1, 0, 0, 0)
            TweenService_4:Create(UpperShutter_upv_1, v4, tbl_4):Play()
            task.wait(0.5)
            UpperShutter_upv_1.Visible = false
            LowerShutter_upv_1.Visible = false
        end
    )
end
raritycolors = {Common = Color3.new(0, 0.666667, 0.156863), Rare = Color3.new(0.262745, 0.462745, 0.792157), Epic = Color3.new(0.792157, 0, 0.862745), Legendary = Color3.new(1, 0, 0), Exclusive = Color3.new(1, 1, 0)}
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
Knit_1.GetService("KeyHandlerService"):GetKey("Gamba").OnClientEvent:Connect(
    function(a1, a2)
        --[[
          line: 53
          upvalues:
            LocalPlayer_upv_1 (copy, index: 1)
            SpecialVignette_upv_1 (copy, index: 2)
            Vignette_upv_1 (copy, index: 3)
            Flashbang_upv_1 (copy, index: 4)
            ItemName_upv_1 (copy, index: 5)
            Icon_upv_1 (copy, index: 6)
            Duplicate_upv_1 (copy, index: 7)
            MiddleFrame_upv_1 (copy, index: 8)
        ]]
        local v5 = game.ReplicatedStorage.ItemInfo:FindFirstChild(a1)
        if not v5 then
            return
        end
        local Value_1 = v5.Rarity.Value
        if game.MarketplaceService:UserOwnsGamePassAsync(LocalPlayer_upv_1.UserId, 1213278715) or string.find(LocalPlayer_upv_1.Data.Inventory.Value, "SkipRolls") then
            SpecialVignette_upv_1.ImageColor3 = raritycolors[Value_1]
            Vignette_upv_1.ImageColor3 = Color3.new(1, 1, 1)
            Flashbang_upv_1.ImageColor3 = raritycolors[Value_1]
            ItemName_upv_1.TextColor3 = raritycolors[Value_1]
            ItemName_upv_1.Text = string.upper(a1)
            Icon_upv_1.Image = v5.itemIcon.Texture
            ItemName_upv_1.TextTransparency = 0
            Icon_upv_1.ImageTransparency = 0
            Duplicate_upv_1.TextTransparency = 0
            local v6 = game.ReplicatedStorage.UISounds.caseOpen:Clone()
            v6.Parent = game.Workspace
            v6:Play()
            game.Debris:AddItem(v6, 3)
            shutter()
            task.wait(0.1)
            local TweenService_5 = game:GetService("TweenService")
            local v7 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            local tbl_5 = {ImageTransparency = 0}
            tbl_5.ImageColor3 = raritycolors[Value_1]
            TweenService_5:Create(Vignette_upv_1, v7, tbl_5):Play()
            task.wait(0.1)
            local tbl_6 = {ImageTransparency = 1}
            game:GetService("TweenService"):Create(Vignette_upv_1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_6):Play()
            local tbl_7 = {ImageTransparency = 0}
            game:GetService("TweenService"):Create(Flashbang_upv_1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_7):Play()
        else
            SpecialVignette_upv_1.ImageColor3 = raritycolors[Value_1]
            Vignette_upv_1.ImageColor3 = Color3.new(1, 1, 1)
            Flashbang_upv_1.ImageColor3 = raritycolors[Value_1]
            ItemName_upv_1.TextColor3 = raritycolors[Value_1]
            ItemName_upv_1.Text = string.upper(a1)
            Icon_upv_1.Image = v5.itemIcon.Texture
            ItemName_upv_1.TextTransparency = 0
            Icon_upv_1.ImageTransparency = 0
            Duplicate_upv_1.TextTransparency = 0
            local v8 = game.ReplicatedStorage.UISounds.caseOpen:Clone()
            v8.Parent = game.Workspace
            v8:Play()
            game.Debris:AddItem(v8, 3)
            shutter()
            task.wait(1)
            local v9 = game.ReplicatedStorage.UISounds.PullSFX:Clone()
            v9.Parent = game.Workspace
            v9:Play()
            local tbl_8 = {Volume = 1}
            game:GetService("TweenService"):Create(v9, TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.In), tbl_8):Play()
            game.Debris:AddItem(v9, 3)
            if Value_1 == "Legendary" then
                local v10 = game.ReplicatedStorage.UISounds.PullSFXSpecial:Clone()
                v10.Parent = game.Workspace
                v10:Play()
                local tbl_9 = {Volume = 0.8}
                game:GetService("TweenService"):Create(v10, TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.In), tbl_9):Play()
                game.Debris:AddItem(v10, 3)
            end
            local TweenService_6 = game:GetService("TweenService")
            local v11 = TweenInfo.new(2.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            local tbl_10 = {ImageTransparency = 0}
            tbl_10.ImageColor3 = raritycolors[Value_1]
            TweenService_6:Create(Vignette_upv_1, v11, tbl_10):Play()
            task.wait(2.8)
            local tbl_11 = {ImageTransparency = 1}
            game:GetService("TweenService"):Create(Vignette_upv_1, TweenInfo.new(2.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_11):Play()
            local tbl_12 = {ImageTransparency = 0}
            game:GetService("TweenService"):Create(Flashbang_upv_1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_12):Play()
        end
        task.delay(
            0.1,
            function()
                --[[
                  line: 130
                  upvalues:
                    MiddleFrame_upv_1 (copy, index: 1)
                    a2 (copy, index: 2)
                    Duplicate_upv_1 (copy, index: 3)
                    Flashbang_upv_1 (copy, index: 4)
                ]]
                MiddleFrame_upv_1.Visible = true
                if a2 ~= nil then
                    Duplicate_upv_1.Visible = true
                    Duplicate_upv_1.Text = "+" .. a2 .. " COINS (DUPLICATE)"
                end
                local tbl_13 = {ImageTransparency = 1}
                game:GetService("TweenService"):Create(Flashbang_upv_1, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), tbl_13):Play()
            end
        )
        if Value_1 == "Legendary" then
            local v12 = game.ReplicatedStorage.UISounds.Unlock_ra:Clone()
            v12.Parent = game.Workspace
            v12:Play()
            game.Debris:AddItem(v12, 3)
            local tbl_14 = {ImageTransparency = 0}
            game:GetService("TweenService"):Create(SpecialVignette_upv_1, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_14):Play()
            task.delay(
                0.1,
                function()
                    --[[
                      line: 148
                      upvalues:
                        SpecialVignette_upv_1 (copy, index: 1)
                    ]]
                    local tbl_15 = {ImageTransparency = 1}
                    game:GetService("TweenService"):Create(SpecialVignette_upv_1, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), tbl_15):Play()
                end
            )
        elseif Value_1 == "Rare" or Value_1 == "Epic" then
            local v13 = game.ReplicatedStorage.UISounds.ui_count_complete:Clone()
            v13.Parent = game.Workspace
            v13:Play()
            game.Debris:AddItem(v13, 3)
        else
            local v14 = game.ReplicatedStorage.UISounds.Item_Box_Get2:Clone()
            v14.Parent = game.Workspace
            v14:Play()
            game.Debris:AddItem(v14, 3)
        end
        task.delay(
            2.3,
            function()
                --[[
                  line: 164
                  upvalues:
                    ItemName_upv_1 (copy, index: 1)
                    Duplicate_upv_1 (copy, index: 2)
                    Icon_upv_1 (copy, index: 3)
                ]]
                local tbl_16 = {TextTransparency = 1}
                game:GetService("TweenService"):Create(ItemName_upv_1, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), tbl_16):Play()
                local tbl_17 = {TextTransparency = 1}
                game:GetService("TweenService"):Create(Duplicate_upv_1, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), tbl_17):Play()
                local tbl_18 = {ImageTransparency = 1}
                game:GetService("TweenService"):Create(Icon_upv_1, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), tbl_18):Play()
            end
        )
        task.wait(2.5)
        MiddleFrame_upv_1.Visible = false
        Duplicate_upv_1.Visible = false
        unshutter()
    end
)