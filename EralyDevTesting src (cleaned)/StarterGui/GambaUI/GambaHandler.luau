local local_player = game.Players.LocalPlayer
local upper_shutter = script.Parent.UpperShutter
local lower_shutter = script.Parent.LowerShutter
local special_vignette = script.Parent.SpecialVignette
local vignette = script.Parent.Vignette
local flashbang = script.Parent.Flashbang
local middle_frame = script.Parent.MiddleFrame
local item_name = middle_frame.ItemName
local icon = middle_frame.Icon
local duplicate = middle_frame.Duplicate

function shutter()
    upper_shutter.Visible = true
    lower_shutter.Visible = true
    game:GetService("TweenService")
        :Create(lower_shutter, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0.7, 0),
        })
        :Play()
    game:GetService("TweenService")
        :Create(upper_shutter, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0.7, 0),
        })
        :Play()
end

function unshutter()
    task.spawn(function()
        game:GetService("TweenService")
            :Create(lower_shutter, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 0),
            })
            :Play()
        game:GetService("TweenService")
            :Create(upper_shutter, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 0),
            })
            :Play()
        task.wait(0.5)
        upper_shutter.Visible = false
        lower_shutter.Visible = false
    end)
end

raritycolors = {
    Common = Color3.new(0, 0.666667, 0.156863),
    Rare = Color3.new(0.262745, 0.462745, 0.792157),
    Epic = Color3.new(0.792157, 0, 0.862745),
    Legendary = Color3.new(1, 0, 0),
    Exclusive = Color3.new(1, 1, 0),
}
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()

knit.GetService("KeyHandlerService"):GetKey("Gamba").OnClientEvent:Connect(function(child_name, argument)
    local first_child = game.ReplicatedStorage.ItemInfo:FindFirstChild(child_name)

    if not first_child then
        return
    end

    local value = first_child.Rarity.Value

    if
        game.MarketplaceService:UserOwnsGamePassAsync(local_player.UserId, 1213278715)
        or string.find(local_player.Data.Inventory.Value, "SkipRolls")
    then
        special_vignette.ImageColor3 = raritycolors[value]
        vignette.ImageColor3 = Color3.new(1, 1, 1)
        flashbang.ImageColor3 = raritycolors[value]
        item_name.TextColor3 = raritycolors[value]
        item_name.Text = string.upper(child_name)
        icon.Image = first_child.itemIcon.Texture
        item_name.TextTransparency = 0
        icon.ImageTransparency = 0
        duplicate.TextTransparency = 0
        local clone = game.ReplicatedStorage.UISounds.caseOpen:Clone()
        clone.Parent = game.Workspace
        clone:Play()
        game.Debris:AddItem(clone, 3)
        shutter()
        task.wait(0.1)
        game:GetService("TweenService")
            :Create(vignette, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                ImageTransparency = 0,
                ImageColor3 = raritycolors[value],
            })
            :Play()
        task.wait(0.1)
        game:GetService("TweenService")
            :Create(vignette, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 1,
            })
            :Play()
        game:GetService("TweenService")
            :Create(flashbang, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 0,
            })
            :Play()
    else
        special_vignette.ImageColor3 = raritycolors[value]
        vignette.ImageColor3 = Color3.new(1, 1, 1)
        flashbang.ImageColor3 = raritycolors[value]
        item_name.TextColor3 = raritycolors[value]
        item_name.Text = string.upper(child_name)
        icon.Image = first_child.itemIcon.Texture
        item_name.TextTransparency = 0
        icon.ImageTransparency = 0
        duplicate.TextTransparency = 0
        local clone_2 = game.ReplicatedStorage.UISounds.caseOpen:Clone()
        clone_2.Parent = game.Workspace
        clone_2:Play()
        game.Debris:AddItem(clone_2, 3)
        shutter()
        task.wait(1)
        local clone_3 = game.ReplicatedStorage.UISounds.PullSFX:Clone()
        clone_3.Parent = game.Workspace
        clone_3:Play()
        game:GetService("TweenService")
            :Create(clone_3, TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                Volume = 1,
            })
            :Play()
        game.Debris:AddItem(clone_3, 3)

        if value == "Legendary" then
            local clone_4 = game.ReplicatedStorage.UISounds.PullSFXSpecial:Clone()
            clone_4.Parent = game.Workspace
            clone_4:Play()
            game:GetService("TweenService")
                :Create(clone_4, TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                    Volume = 0.8,
                })
                :Play()
            game.Debris:AddItem(clone_4, 3)
        end

        game:GetService("TweenService")
            :Create(vignette, TweenInfo.new(2.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                ImageTransparency = 0,
                ImageColor3 = raritycolors[value],
            })
            :Play()
        task.wait(2.8)
        game:GetService("TweenService")
            :Create(vignette, TweenInfo.new(2.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 1,
            })
            :Play()
        game:GetService("TweenService")
            :Create(flashbang, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 0,
            })
            :Play()
    end

    task.delay(0.1, function()
        middle_frame.Visible = true

        if argument ~= nil then
            duplicate.Visible = true
            duplicate.Text = "+" .. argument .. " COINS (DUPLICATE)"
        end

        game:GetService("TweenService")
            :Create(flashbang, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                ImageTransparency = 1,
            })
            :Play()
    end)

    if value == "Legendary" then
        local clone_5 = game.ReplicatedStorage.UISounds.Unlock_ra:Clone()
        clone_5.Parent = game.Workspace
        clone_5:Play()
        game.Debris:AddItem(clone_5, 3)
        game:GetService("TweenService")
            :Create(special_vignette, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 0,
            })
            :Play()

        task.delay(0.1, function()
            game:GetService("TweenService")
                :Create(special_vignette, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    ImageTransparency = 1,
                })
                :Play()
        end)
    elseif value == "Rare" or value == "Epic" then
        local clone_6 = game.ReplicatedStorage.UISounds.ui_count_complete:Clone()
        clone_6.Parent = game.Workspace
        clone_6:Play()
        game.Debris:AddItem(clone_6, 3)
    else
        local clone_7 = game.ReplicatedStorage.UISounds.Item_Box_Get2:Clone()
        clone_7.Parent = game.Workspace
        clone_7:Play()
        game.Debris:AddItem(clone_7, 3)
    end

    task.delay(2.3, function()
        game:GetService("TweenService")
            :Create(item_name, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextTransparency = 1,
            })
            :Play()
        game:GetService("TweenService")
            :Create(duplicate, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextTransparency = 1,
            })
            :Play()
        game:GetService("TweenService")
            :Create(icon, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                ImageTransparency = 1,
            })
            :Play()
    end)

    task.wait(2.5)
    middle_frame.Visible = false
    duplicate.Visible = false
    unshutter()
end)
