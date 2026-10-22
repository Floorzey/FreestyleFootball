local customization = {}

repeat
    task.wait()
until game:IsLoaded()

local local_player = game.Players.LocalPlayer
local player_gui = local_player.PlayerGui
local customization_dummy = workspace:FindFirstChild("CustomizationDummy")
local customization_frame = player_gui.Menu.CustomizationFrame
local items_frame = customization_frame.ItemsFrame
local equip_frame = customization_frame.EquipFrame
local _ = customization_frame.SelectFrame
local _ = customization_frame.PopupContainer
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key_handler_service = knit.GetService("KeyHandlerService")
key_handler_service:GetKey("customize")
local key = key_handler_service:GetKey("BuyCheck")
local values = {
    Aura = items_frame:WaitForChild("AurasFrame"),
    AnimationPack = items_frame:WaitForChild("AnimationFrame"),
    Eyes = items_frame:WaitForChild("EyesFrame"),
    Glove = items_frame:WaitForChild("GoalieGlovesFrame"),
    GoalCeleb = items_frame:WaitForChild("GoalCelebFrame"),
    WinCeleb = items_frame:WaitForChild("WinCelebFrame"),
}
local tween_service = game:GetService("TweenService")
require("@game/ReplicatedStorage/Modules/ColorPicker")
local text = "None"
local text_2 = "None"
local value = nil
local text_3 = ""
local values_2 = {
    Idle = nil,
    LeftFoot = nil,
    RightFoot = nil,
    LeftHand = nil,
    RightHand = nil,
}
local values_3 = {
    Common = Color3.new(1, 1, 1),
    Rare = Color3.new(0.262745, 0.462745, 0.792157),
    Epic = Color3.new(0.792157, 0, 0.862745),
    Legendary = Color3.new(1, 0, 0),
    Exclusive = Color3.new(1, 0.968627, 0),
}
local items_frame2 = player_gui:WaitForChild("Menu"):WaitForChild("CustomizationFrame").ItemsFrame
local item_info = game.ReplicatedStorage:WaitForChild("ItemInfo")
local values_4 = {
    Argentina = Vector3.new(0.588235, 0.772549, 0.886275),
    Brazil = Vector3.new(0.219, 0.67, 0.545),
    Flamengo = Vector3.new(0.0509804, 0.0509804, 0.0509804),
    AstonVilla = Vector3.new(0.533333, 0.686275, 0.827451),
    Barcelona = Vector3.new(0.65, 0.137, 0.192),
    Dortmund = Vector3.new(0.2, 0.2, 0.2),
    Japan = Vector3.new(0.839, 0.156, 0.125),
    InterMiami = Vector3.new(0.1, 0.1, 0.1),
    ManchesterU = Vector3.new(0.472, 0.08, 0.125),
    Munich = Vector3.new(0.043, 0.164, 0.364),
    ParisSaints = Vector3.new(0.086, 0.113, 0.258),
    Italy = Vector3.new(0.12941177, 0.28627452, 0.68235296),
    Croatia = Vector3.new(0.113, 0.207, 0.38),
    Morocco = Vector3.new(0.121, 0.376, 0.29),
    Canada = Vector3.new(0.915, 0.1, 0.1),
    Portugal = Vector3.new(0.623, 0.125, 0.156),
    Mexico = Vector3.new(0.043, 0.478, 0.313),
    Netherlands = Vector3.new(0.913, 0.45, 0.074),
    RealMadrid = Vector3.new(1, 1, 1),
    LiverpoolFC = Vector3.new(0.129412, 0.129412, 0.129412),
    SeattleSoundersFC = Vector3.new(0.341, 0.56, 0.231),
    JuventusFC = Vector3.new(0.12, 0.12, 0.12),
    Newcastle = Vector3.new(1, 1, 1),
    ManchesterCity = Vector3.new(0.53333336, 0.7137255, 0.8784314),
    Germany = Vector3.new(0.99, 0.99, 0.99),
    England = Vector3.new(0.003921569, 0.16862746, 0.7372549),
    Arsenal = Vector3.new(1, 1, 1),
    InterMilan = Vector3.new(0.10980392, 0.29411766, 0.5411765),
    USA = Vector3.new(0.078431375, 0.06666667, 0.6392157),
    Chelsea = Vector3.new(0.2, 0.2, 0.6666667),
    Napoli = Vector3.new(1, 1, 1),
    France = Vector3.new(0.03, 0.03, 0.03),
    Uruguay = Vector3.new(0.05, 0.05, 0.05),
    Roma = Vector3.new(0.45490196, 0.07450981, 0.11764706),
    Lazio = Vector3.new(0.98, 0.98, 0.98),
    SouthKorea = Vector3.new(0.99, 0.99, 0.99),
    VascoDaGama = Vector3.new(0.96, 0.96, 0.96),
    Ajax = Vector3.new(0.05, 0.05, 0.05),
    Atletico = Vector3.new(0.75686276, 0, 0.03137255),
    Leverkusen = Vector3.new(0.05, 0.05, 0.05),
    Wales = Vector3.new(0.18431373, 0.1882353, 0.22352941),
    Fiorentina = Vector3.new(0.2784314, 0.12156863, 0.40392157),
    Spurs = Vector3.new(0.99, 0.99, 0.99),
    ACMilan = Vector3.new(0.04, 0.04, 0.04),
    Belgium = Vector3.new(0.60784316, 0.101960786, 0.16470589),
    Spain = Vector3.new(0.5137255, 0, 0),
    Scotland = Vector3.new(0.14901961, 0.25490198, 0.49019608),
    Poland = Vector3.new(1, 0.0784314, 0.0941176),
    Sweden = Vector3.new(0.105882, 0.180392, 0.388235),
    Bosnia = Vector3.new(0.0392157, 0.109804, 0.388235),
    Denmark = Vector3.new(0.6, 0.109804, 0.12549),
    Romania = Vector3.new(0.968627, 0.815686, 0.12549),
    Switzerland = Vector3.new(0.494118, 0.0862745, 0.12549),
}

local function tween_beam_transparency(
    argument: userdata,
    argument_2: userdata,
    tween_info: userdata,
    enabled_2: boolean
)
    local number_value = Instance.new("NumberValue")
    number_value.Value = enabled_2 == true and 1 or 0
    local items = {}

    for index = 1, #argument_2.Keypoints do
        table.insert(items, index, argument_2.Keypoints[index])
        local _ = index
    end

    number_value.Changed:Connect(function(argument_3)
        local items_2 = {}

        for index_2, item in ipairs(items) do
            table.insert(
                items_2,
                index_2,
                NumberSequenceKeypoint.new(
                    item.Time,
                    item.Value == 1 and 1 or (enabled_2 == true and item.Value + argument_3 or item.Value * argument_3)
                )
            )
        end

        argument.Transparency = NumberSequence.new(items_2)
    end)

    local tween = tween_service:Create(number_value, tween_info, {
        Value = enabled_2 == true and 0 or 1,
    })

    tween.Completed:Once(function()
        number_value:Destroy()
    end)

    tween:Play()
end

function animationPreview(child_name, child_name_2)
    for _, item in customization_dummy.Humanoid.Animator:GetPlayingAnimationTracks() do
        if item.Priority ~= Enum.AnimationPriority.Idle then
            item:Stop()
        end
    end

    local first_child = game.ReplicatedStorage.AnimFolder:FindFirstChild(child_name):FindFirstChild(child_name_2)

    if first_child.Name == "Idle" then
        return
    end

    if not first_child then
        return
    end

    customization_dummy.Humanoid.Animator:LoadAnimation(first_child):Play()
end

function randomthingFromParent(instance)
    local children = instance:GetChildren()

    return children[math.random(1, #children)]
end

local function show_category(argument)
    for _, child in ipairs(items_frame2:GetChildren()) do
        if child:IsA("ScrollingFrame") or child:IsA("Frame") then
            child.Visible = false
        end
    end

    local value_entry = values[argument]

    if value_entry then
        value_entry.Visible = true
    end
end

function previewTeam(child_name: any, child_name_2: string)
    for _, child in customization_dummy:GetChildren() do
        if child:HasTag("Clothing") then
            child:Destroy()
        end
    end

    local first_child = game.ReplicatedStorage.Cosmetics.Jerseys:FindFirstChild(child_name)

    if not first_child then
        return
    end

    for _, child_2 in customization_dummy:GetChildren() do
        if child_2:IsA("Shirt") then
            child_2:Destroy()
        end

        if child_2:IsA("Pants") then
            child_2:Destroy()
        end
    end

    if not first_child:FindFirstChild(child_name_2) then
        return
    end

    local clone = first_child:FindFirstChild(child_name_2):Clone()
    local clone_2 = first_child:FindFirstChild("Pants"):Clone()
    print(child_name)

    if child_name_2 == "Tracksuit" then
        local clone_3 = game.ReplicatedStorage.Cosmetics.Torso.TracksuitNeck:Clone()
        clone_3.Parent = customization_dummy
        clone_3.TorsoWeld.Part0 = customization_dummy.Torso
        clone_3.SpecialMesh.VertexColor = values_4[child_name]
        clone_3:AddTag("Clothing")
    end

    clone.Parent = customization_dummy
    clone_2.Parent = customization_dummy
    clone:AddTag("Clothing")
    clone_2:AddTag("Clothing")
end

function doAura(argument, child_name)
    task.spawn(function()
        local first_child = game.ReplicatedStorage.Cosmetics.Auras:FindFirstChild(child_name)

        for _, descendant in customization_dummy:GetDescendants() do
            if descendant:HasTag("MVPEyes") then
                descendant:Destroy()
            end
        end

        for _, descendant_2 in customization_dummy:GetDescendants() do
            if descendant_2:HasTag("Aura") then
                descendant_2:Destroy()
            end
        end

        if not first_child then
            return
        end

        for _, descendant_3 in pairs(first_child:GetDescendants()) do
            if descendant_3:IsA("Part") then
                descendant_3:AddTag("Aura")
            elseif descendant_3:IsA("ParticleEmitter") then
                descendant_3:AddTag("Aura")
                local _ = descendant_3:GetAttribute("colorable")
            elseif descendant_3:IsA("Beam") then
                descendant_3:AddTag("Aura")
            elseif descendant_3:IsA("Trail") then
                descendant_3:AddTag("Aura")
            end
        end

        for _, child in pairs(first_child:GetChildren()) do
            if child.Name == "Torso" then
                local aura = child:Clone()
                aura.Name = "Aura"
                aura.Parent = customization_dummy.Torso
            end

            if child.Name == "Left Arm" then
                local aura_2 = child:Clone()
                aura_2.Name = "Aura"
                aura_2.Parent = customization_dummy["Left Arm"]
            end

            if child.Name == "Left Leg" then
                local aura_3 = child:Clone()
                aura_3.Name = "Aura"
                aura_3.Parent = customization_dummy["Left Leg"]
            end

            if child.Name == "Right Leg" then
                local aura_4 = child:Clone()
                aura_4.Name = "Aura"
                aura_4.Parent = customization_dummy["Right Leg"]
            end

            if child.Name == "Right Arm" then
                local aura_5 = child:Clone()
                aura_5.Name = "Aura"
                aura_5.Parent = customization_dummy["Right Arm"]
            end

            if child.Name == "Head" then
                local aura_6 = child:Clone()
                aura_6.Name = "Aura"
                aura_6.Parent = customization_dummy.Head
            end

            local child_3 = child

            for _, descendant_4 in ipairs(child:GetDescendants()) do
                if descendant_4:IsA("Light") or descendant_4:IsA("Script") then
                    descendant_4:Destroy()
                end
            end

            if child_3.Name == "AttachmentHolder" then
                for _, child2 in pairs(child_3:GetChildren()) do
                    if child2.Name == "HRP" then
                        local aura_7 = child2:Clone()
                        aura_7.Name = "Aura"
                        aura_7.Parent = customization_dummy.HumanoidRootPart

                        if aura_7:IsA("Part") and aura_7:FindFirstChildOfClass("Weld") then
                            aura_7:FindFirstChildOfClass("Weld").Part0 = customization_dummy.HumanoidRootPart
                            game.Debris:AddItem(aura_7, argument)
                        end

                        if first_child.Name == "Flaming Wings" then
                            for _, descendant_5 in ipairs(aura_7:GetDescendants()) do
                                if descendant_5:IsA("ParticleEmitter") then
                                    descendant_5.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 1),
                                        NumberSequenceKeypoint.new(0.5, 0.95),
                                        NumberSequenceKeypoint.new(1, 1),
                                    })
                                    descendant_5.Rate = descendant_5.Rate / 2
                                end
                            end
                        elseif first_child.Name == "Blue Death" or first_child.Name == "Determination" then
                            for _, descendant_6 in ipairs(aura_7:GetDescendants()) do
                                if descendant_6:IsA("ParticleEmitter") then
                                    descendant_6.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 1),
                                        NumberSequenceKeypoint.new(0.25, 0.95),
                                        NumberSequenceKeypoint.new(1, 1),
                                    })
                                    descendant_6.Rate = descendant_6.Rate / 2
                                end
                            end
                        elseif first_child.Name == "A Certain Gambler" then
                            for _, descendant_7 in ipairs(aura_7:GetDescendants()) do
                                if descendant_7:IsA("ParticleEmitter") then
                                    descendant_7.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 1),
                                        NumberSequenceKeypoint.new(0.259, 1),
                                        NumberSequenceKeypoint.new(0.26, 0.7),
                                        NumberSequenceKeypoint.new(0.76, 0.7),
                                        NumberSequenceKeypoint.new(1, 1),
                                    })
                                    descendant_7.Rate = descendant_7.Rate / 2
                                end
                            end
                        elseif first_child.Name == "Sakura" then
                            for _, descendant_8 in ipairs(aura_7:GetDescendants()) do
                                if descendant_8:IsA("ParticleEmitter") then
                                    descendant_8.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 1),
                                        NumberSequenceKeypoint.new(0.5, 0.1),
                                        NumberSequenceKeypoint.new(0.85, 0.1),
                                        NumberSequenceKeypoint.new(1, 1),
                                    })
                                    descendant_8.Rate = descendant_8.Rate / 2
                                end
                            end
                        end

                        local beam = aura_7:FindFirstChildOfClass("Beam")

                        if beam then
                            if first_child.Name == "Calculated Destruction" then
                                beam.Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 0.3),
                                    NumberSequenceKeypoint.new(1, 0.3),
                                })
                            else
                                beam.Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 0.8),
                                    NumberSequenceKeypoint.new(1, 0.8),
                                })
                            end
                        end
                    elseif child2.Name == "Head" then
                        local aura_8 = child2:Clone()
                        aura_8.Name = "Aura"
                        aura_8.Parent = customization_dummy.Head

                        if aura_8:IsA("Part") then
                            game.Debris:AddItem(aura_8, argument)
                            local weld = aura_8:FindFirstChildOfClass("Weld") or aura_8:FindFirstChildOfClass("Motor6D")

                            if weld then
                                weld.Part0 = customization_dummy.Head
                            end
                        end

                        if aura_8:GetAttribute("disband") then
                            task.spawn(function()
                                for _, child3 in pairs(aura_8:GetChildren()) do
                                    if child3:IsA("Attachment") then
                                        task.spawn(function()
                                            for _, child4 in pairs(child3:GetChildren()) do
                                                child4.Name = "Aura"
                                            end
                                        end)
                                    else
                                        child3.Name = "Aura"
                                    end

                                    child3.Parent = customization_dummy.Head
                                end

                                aura_8:Destroy()
                            end)
                        end

                        local beam_2 = aura_8:FindFirstChildOfClass("Beam")

                        if beam_2 and first_child.Name ~= "Monster" then
                            beam_2.Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0.8),
                                NumberSequenceKeypoint.new(1, 0.8),
                            })
                        end
                    elseif child2.Name == "Torso" then
                        local aura_9 = child2:Clone()
                        aura_9.Name = "Aura"
                        aura_9.Parent = customization_dummy.Torso

                        if aura_9:FindFirstChildOfClass("Weld") then
                            game.Debris:AddItem(aura_9, argument)
                            aura_9:FindFirstChildOfClass("Weld").Part0 = customization_dummy.Torso
                        end

                        if aura_9:GetAttribute("disband") then
                            task.spawn(function()
                                for _, child3 in pairs(aura_9:GetChildren()) do
                                    if child3:IsA("Attachment") then
                                        task.spawn(function()
                                            for _, child4 in pairs(child3:GetChildren()) do
                                                child4.Name = "Aura"
                                            end
                                        end)
                                    else
                                        child3.Name = "Aura"
                                    end

                                    child3.Parent = customization_dummy.Torso
                                end

                                aura_9:Destroy()
                            end)
                        end

                        local beam_3 = aura_9:FindFirstChildOfClass("Beam")

                        if first_child.Name == "Flaming Wings" then
                            for _, descendant_9 in ipairs(aura_9:GetDescendants()) do
                                if descendant_9:IsA("ParticleEmitter") then
                                    descendant_9.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 1),
                                        NumberSequenceKeypoint.new(0.5, 0.95),
                                        NumberSequenceKeypoint.new(1, 1),
                                    })
                                    descendant_9.Rate = descendant_9.Rate / 2
                                end
                            end
                        elseif first_child.Name == "Godly" then
                            for _, descendant_10 in ipairs(aura_9:GetDescendants()) do
                                if descendant_10:IsA("ParticleEmitter") then
                                    descendant_10.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 1),
                                        NumberSequenceKeypoint.new(0.5, 0.9),
                                        NumberSequenceKeypoint.new(1, 1),
                                    })
                                    descendant_10.Rate = descendant_10.Rate / 3
                                end
                            end
                        elseif first_child.Name == "Death" then
                            for _, descendant_11 in ipairs(aura_9:GetDescendants()) do
                                if descendant_11:IsA("ParticleEmitter") then
                                    descendant_11.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 1),
                                        NumberSequenceKeypoint.new(0.5, 0.8),
                                        NumberSequenceKeypoint.new(1, 1),
                                    })
                                    descendant_11.Rate = descendant_11.Rate / 2
                                end
                            end
                        end

                        if beam_3 then
                            beam_3.Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0.8),
                                NumberSequenceKeypoint.new(1, 0.8),
                            })
                        end
                    elseif child2.Name == "Left Arm" then
                        local aura_10 = child2:Clone()
                        aura_10.Name = "Aura"
                        aura_10.Parent = customization_dummy["Left Arm"]

                        if aura_10:FindFirstChildOfClass("Weld") then
                            game.Debris:AddItem(aura_10, argument)
                            aura_10:FindFirstChildOfClass("Weld").Part0 = customization_dummy["Left Arm"]
                        end

                        if aura_10:GetAttribute("disband") then
                            task.spawn(function()
                                for _, child3 in pairs(aura_10:GetChildren()) do
                                    child3.Name = "Aura"
                                    child3.Parent = customization_dummy["Left Arm"]
                                end

                                aura_10:Destroy()
                            end)
                        end

                        local beam_4 = aura_10:FindFirstChildOfClass("Beam")

                        if first_child.Name == "Blue Rose" then
                            for _, descendant_12 in ipairs(aura_10:GetDescendants()) do
                                if descendant_12:IsA("ParticleEmitter") then
                                    descendant_12.Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 1),
                                        NumberSequenceKeypoint.new(0.5, 0.95),
                                        NumberSequenceKeypoint.new(1, 1),
                                    })
                                    descendant_12.Rate = descendant_12.Rate / 2
                                end
                            end
                        end

                        if beam_4 then
                            beam_4.Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0.8),
                                NumberSequenceKeypoint.new(1, 0.8),
                            })
                        end
                    elseif child2.Name == "Left Leg" then
                        local aura_11 = child2:Clone()
                        aura_11.Name = "Aura"
                        aura_11.Parent = customization_dummy["Left Leg"]

                        if aura_11:FindFirstChildOfClass("Weld") then
                            game.Debris:AddItem(aura_11, argument)
                            aura_11:FindFirstChildOfClass("Weld").Part0 = customization_dummy["Left Leg"]
                        end

                        if aura_11:GetAttribute("disband") then
                            task.spawn(function()
                                for _, child3 in pairs(aura_11:GetChildren()) do
                                    if child3:IsA("Attachment") then
                                        task.spawn(function()
                                            for _, child4 in pairs(child3:GetChildren()) do
                                                child4.Name = "Aura"
                                            end
                                        end)
                                    else
                                        child3.Name = "Aura"
                                    end

                                    child3.Parent = customization_dummy["Left Leg"]
                                end

                                aura_11:Destroy()
                            end)
                        end

                        local beam_5 = aura_11:FindFirstChildOfClass("Beam")

                        if beam_5 and first_child.Name ~= "Monster" then
                            beam_5.Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0.8),
                                NumberSequenceKeypoint.new(1, 0.8),
                            })
                        end
                    elseif child2.Name == "Right Leg" then
                        local aura_12 = child2:Clone()
                        aura_12.Name = "Aura"
                        aura_12.Parent = customization_dummy["Right Leg"]

                        if aura_12:FindFirstChildOfClass("Weld") then
                            game.Debris:AddItem(aura_12, argument)
                            aura_12:FindFirstChildOfClass("Weld").Part0 = customization_dummy["Right Leg"]
                        end

                        if aura_12:GetAttribute("disband") then
                            task.spawn(function()
                                for _, child3 in pairs(aura_12:GetChildren()) do
                                    if child3:IsA("Attachment") then
                                        task.spawn(function()
                                            for _, child4 in pairs(child3:GetChildren()) do
                                                child4.Name = "Aura"
                                            end
                                        end)
                                    else
                                        child3.Name = "Aura"
                                    end

                                    child3.Parent = customization_dummy["Right Leg"]
                                end

                                aura_12:Destroy()
                            end)
                        end

                        local beam_6 = aura_12:FindFirstChildOfClass("Beam")

                        if beam_6 and first_child.Name ~= "Monster" then
                            beam_6.Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0.8),
                                NumberSequenceKeypoint.new(1, 0.8),
                            })
                        end
                    elseif child2.Name == "Right Arm" then
                        local aura_13 = child2:Clone()
                        aura_13.Name = "Aura"
                        aura_13.Parent = customization_dummy["Right Arm"]

                        if aura_13:FindFirstChildOfClass("Weld") then
                            game.Debris:AddItem(aura_13, argument)
                            aura_13:FindFirstChildOfClass("Weld").Part0 = customization_dummy["Right Arm"]
                        end

                        if aura_13:GetAttribute("disband") then
                            task.spawn(function()
                                for _, child3 in pairs(aura_13:GetChildren()) do
                                    if child3:IsA("Attachment") then
                                        task.spawn(function()
                                            for _, child4 in pairs(child3:GetChildren()) do
                                                child4.Name = "Aura"
                                            end
                                        end)
                                    else
                                        child3.Name = "Aura"
                                    end

                                    child3.Parent = customization_dummy["Right Arm"]
                                end

                                aura_13:Destroy()
                            end)
                        end

                        local beam_7 = aura_13:FindFirstChildOfClass("Beam")

                        if beam_7 and first_child.Name ~= "Monster" then
                            beam_7.Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0.8),
                                NumberSequenceKeypoint.new(1, 0.8),
                            })
                        end
                    end
                end
            end
        end

        for _, child_2 in pairs(customization_dummy:GetChildren()) do
            if
                child_2.Name == "Right Arm"
                or (
                    child_2.Name == "Left Arm"
                    or (
                        child_2.Name == "Left Leg"
                        or (child_2.Name == "Right Leg" or (child_2.Name == "Head" or child_2.Name == "Torso"))
                    )
                )
            then
                local parent = child_2

                for _, child2_2 in pairs(first_child:GetChildren()) do
                    if
                        child2_2:IsA("ParticleEmitter") and child2_2.Name == "Aura"
                        or child2_2:IsA("Attachment") and child2_2.Name ~= "Torso"
                    then
                        local aura_14 = child2_2:Clone()
                        aura_14.Name = "Aura"
                        aura_14.Parent = parent
                    end
                end
            end
        end

        task.delay(argument, function()
            for _, descendant_13 in pairs(customization_dummy:GetDescendants()) do
                if descendant_13.Name == "HasAura" then
                    descendant_13:Destroy()
                end

                if descendant_13.Name == "Orbit" then
                    descendant_13:Destroy()
                end

                if descendant_13.Name == "Aura" then
                    if descendant_13:IsA("ParticleEmitter") then
                        descendant_13.Enabled = false

                        task.delay(3, function()
                            descendant_13:Destroy()
                        end)
                    elseif descendant_13:IsA("Script") then
                        descendant_13:Destroy()
                    elseif descendant_13:IsA("Attachment") then
                        for _, descendant2 in pairs(descendant_13:GetDescendants()) do
                            if descendant2:IsA("ParticleEmitter") then
                                descendant2.Enabled = false

                                task.delay(3, function()
                                    descendant2:Destroy()
                                end)
                            elseif descendant2:IsA("Beam") then
                                task.spawn(function()
                                    tween_beam_transparency(
                                        descendant2,
                                        NumberSequence.new({
                                            NumberSequenceKeypoint.new(0, 1),
                                            NumberSequenceKeypoint.new(1, 1),
                                        }),
                                        TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                        false
                                    )
                                end)
                            elseif descendant2:IsA("PointLight") then
                                game:GetService("TweenService")
                                    :Create(
                                        descendant2,
                                        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                        {
                                            Brightness = 0,
                                            Range = 0,
                                        }
                                    )
                                    :Play()
                            end
                        end

                        game.Debris:AddItem(descendant_13, 3)
                    end
                end
            end
        end)
    end)
end

local function search4_cosmetic(argument, child_name)
    for _, child in game.ReplicatedStorage.Cosmetics:GetChildren() do
        if child.Name == argument and child:FindFirstChild(child_name) then
            return child:FindFirstChild(child_name)
        end
    end

    return nil
end

local values_5 = {
    Cleats = function(argument, part0)
        argument.Main.Main.Part0 = part0
    end,

    Hands = function(instance, part0)
        if instance == nil then
            return
        end

        if not instance:FindFirstChild("ArmWeld", true) then
            return
        end

        if instance.Name ~= "Glove" then
            instance:FindFirstChild("ArmWeld", true).Part0 = part0

            return
        end

        if part0.Name == "Left Arm" then
            instance:FindFirstChild("ArmWeld", true).Part0 = part0

            return
        end

        instance:FindFirstChild("ArmWeldR", true).Part0 = part0
    end,
}

local function converter_string(argument: string)
    local _ = argument == "LeftFoot"

    return "Cleats"
end

function loadCosmetics()
    customization_dummy:WaitForChild("Left Arm", 20)
    customization_dummy:WaitForChild("Right Arm", 20)
    customization_dummy:WaitForChild("Left Leg", 20)
    customization_dummy:WaitForChild("Right Leg", 20)
    local values_6 = { "LeftFoot", "RightFoot", "LeftHand", "RightHand", "Torso", "Head" }

    for _, child in customization_dummy:GetChildren() do
        if child:HasTag("Cosmetic") then
            child:Destroy()
        end
    end

    for _, child_2 in local_player:WaitForChild("Data"):GetChildren() do
        if table.find(values_6, child_2.Name) then
            local _ = child_2.Name == "LeftFoot"

            if search4_cosmetic("Cleats", child_2.Value) then
                local _ = child_2.Name == "LeftFoot"
                local clone = search4_cosmetic("Cleats", child_2.Value):Clone()
                clone:AddTag("Cosmetic")
                clone.Parent = customization_dummy

                if child_2.Name == "LeftFoot" or child_2.Name == "RightFoot" then
                    if child_2.Name == "LeftFoot" then
                        clone:AddTag("CleatL")
                    else
                        clone:AddTag("CleatR")
                    end

                    local customization_dummy_entry

                    if child_2.Name == "LeftFoot" then
                        customization_dummy_entry = customization_dummy["Left Leg"]
                    else
                        customization_dummy_entry = customization_dummy["Right Leg"]
                    end

                    values_5.Cleats(clone, customization_dummy_entry)
                elseif child_2.Name == "LeftHand" or child_2.Name == "RightHand" then
                    local customization_dummy_entry_2

                    if child_2.Name == "LeftArm" then
                        customization_dummy_entry_2 = customization_dummy["Left Arm"]
                    else
                        customization_dummy_entry_2 = customization_dummy["Right Arm"]
                    end

                    values_5.Hands(clone, customization_dummy_entry_2)
                end
            end
        end
    end
end

function doMVPEye(argument, child_name)
    for _, descendant in customization_dummy:GetDescendants() do
        if descendant:HasTag("Aura") then
            descendant:Destroy()
        end
    end

    for _, descendant_2 in customization_dummy:GetDescendants() do
        if descendant_2:HasTag("MVPEyes") then
            descendant_2:Destroy()
        end
    end

    local first_child = game.ReplicatedStorage.Cosmetics.MVPEyes:FindFirstChild(child_name)

    if not first_child then
        return
    end

    local parent = first_child:Clone()
    parent.Parent = customization_dummy
    parent:AddTag("MVPEyes")
    parent.Anchored = false
    local clone = script.Weld:Clone()
    clone.Parent = parent
    clone.Part0 = customization_dummy.Head
    clone.Part1 = parent

    task.delay(argument, function()
        for _, descendant_3 in parent:GetDescendants() do
            if descendant_3:IsA("ParticleEmitter") then
                descendant_3.Enabled = false
            elseif descendant_3:IsA("Beam") then
                tween_beam_transparency(
                    descendant_3,
                    NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 1) }),
                    TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    false
                )
            end
        end

        task.wait(3)
        parent:Destroy()
    end)
end

function showConfirmation(instance)
    customization_frame.PopupContainer.Visible = true
    customization_frame.PopupContainer.PurchaseText.Text = "WOULD YOU LIKE TO PURCHASE <"
        .. instance.Type.Text
        .. "> for "
        .. instance.Price.Text
        .. "?"
    local connection_2 = nil
    local connection_3 = nil
    connection_3 = customization_frame.PopupContainer.YesButton.MouseButton1Click:Connect(function()
        if key:InvokeServer(instance.Name) ~= nil then
            if instance:FindFirstChild("Locked") then
                instance.Locked.Visible = false
                instance.LockedBG.Visible = false

                if instance:FindFirstChild("Price") then
                    instance.Price.Visible = false
                end

                local clone = game.ReplicatedStorage.UISounds.Item_Box_Get2:Clone()
                clone.Parent = game.Workspace
                clone:Play()
                game.Debris:AddItem(clone, 2)
            end

            connection_3:Disconnect()
            customization_frame.PopupContainer.Visible = false

            return
        end

        local clone_2 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
        clone_2.Parent = game.Workspace
        clone_2:Play()
        game.Debris:AddItem(clone_2, 3)

        task.spawn(function()
            game:GetService("TweenService")
                :Create(instance.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Rotation = 45,
                })
                :Play()
            task.wait(0.1)
            game:GetService("TweenService")
                :Create(instance.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Rotation = -45,
                })
                :Play()
            task.wait(0.1)
            game:GetService("TweenService")
                :Create(instance.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Rotation = 0,
                })
                :Play()
        end)
    end)
    connection_2 = customization_frame.PopupContainer.NoButton.MouseButton1Click:Connect(function()
        connection_3:Disconnect()
        connection_2:Disconnect()
        customization_frame.PopupContainer.Visible = false
    end)
end

function doSelection(instance: userdata)
    local parts = string.split(local_player.Data.Inventory.Value)

    if not table.find(parts, instance.Name) and instance:FindFirstChild("Price") then
        game:GetService("TweenService")
            :Create(equip_frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 1, 150),
            })
            :Play()
        showConfirmation(instance)

        return
    end

    if text_3 == instance.Name then
        text_3 = nil
        game:GetService("TweenService")
            :Create(equip_frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 1, 150),
            })
            :Play()
        game:GetService("TweenService")
            :Create(instance.UIStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Thickness = 2,
                Transparency = 0.25,
                Color = Color3.new(0.498039, 0.529412, 0.560784),
            })
            :Play()

        return
    end

    for _, child in pairs(instance.Parent:GetChildren()) do
        if child ~= instance and child:IsA("ImageButton") then
            game:GetService("TweenService")
                :Create(child.UIStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Thickness = 2,
                    Transparency = 0.25,
                    Color = Color3.new(0.498039, 0.529412, 0.560784),
                })
                :Play()
        end
    end

    text_3 = instance.Name
    game:GetService("TweenService")
        :Create(equip_frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, -125),
        })
        :Play()
    game:GetService("TweenService")
        :Create(instance.UIStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Thickness = 3,
            Transparency = 0,
            Color = Color3.new(1, 1, 1),
        })
        :Play()
    equip_frame.EquipButton.Text = "EQUIP"

    for _, child_2 in pairs(local_player.Data:GetChildren()) do
        if child_2:IsA("StringValue") and child_2.Value == instance.Name then
            equip_frame.EquipButton.Text = "EQUIPPED"

            return
        end
    end
end

function runCustomizationSetup()
    for _, child in pairs(items_frame2.AurasFrame:GetChildren()) do
        if child:IsA("ImageButton") then
            child:Destroy()
        end
    end

    for _, child_2 in pairs(items_frame2.AnimationFrame:GetChildren()) do
        if child_2:IsA("ImageButton") then
            child_2:Destroy()
        end
    end

    for _, child_3 in pairs(items_frame2.GoalieGlovesFrame:GetChildren()) do
        if child_3:IsA("ImageButton") then
            child_3:Destroy()
        end
    end

    for _, child_4 in pairs(items_frame2.EyesFrame:GetChildren()) do
        if child_4:IsA("ImageButton") then
            child_4:Destroy()
        end
    end

    for _, child_5 in pairs(items_frame2.GoalCelebFrame:GetChildren()) do
        if child_5:IsA("ImageButton") then
            child_5:Destroy()
        end
    end

    for _, child_6 in pairs(items_frame2.WinCelebFrame:GetChildren()) do
        if child_6:IsA("ImageButton") then
            child_6:Destroy()
        end
    end

    local parts = string.split(local_player.Data.Inventory.Value)

    for _, descendant in pairs(items_frame2:GetDescendants()) do
        if descendant:IsA("ImageButton") then
            if table.find(parts, descendant.Name) then
                if descendant:FindFirstChild("Locked") then
                    descendant.Locked.Visible = false
                    descendant.LockedBG.Visible = false

                    if descendant:FindFirstChild("Price") then
                        descendant.Price.Visible = false
                    end
                end
            else
                descendant.Locked.Visible = true
                descendant.LockedBG.Visible = true

                if descendant:FindFirstChild("Price") then
                    descendant.Price.Visible = true
                end
            end
        end
    end

    for _, child_name in pairs(parts) do
        local first_child = item_info:FindFirstChild(child_name)

        if first_child then
            local instance = script.itemTemplate:Clone()
            instance.Name = first_child.Name
            instance.itemName.Text = string.upper(first_child.Name)
            instance.itemName.TextColor3 = values_3[first_child.Rarity.Value]
            instance.Icon.Image = first_child.itemIcon.Texture

            instance.MouseButton1Click:Connect(function()
                if first_child.Type.Value == "Aura" then
                    doAura(999, first_child.Name)
                elseif first_child.Type.Value == "Eyes" then
                    doMVPEye(999, first_child.Name)
                elseif first_child.Type.Value ~= "GoalCeleb" then
                    local _ = first_child.Type.Value == "WinCeleb"
                end

                doSelection(instance)
            end)

            local parent = values[first_child.Type.Value]

            if parent then
                instance.Parent = parent
            end
        end
    end
end

local enabled = false

function camera()
    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    workspace.CurrentCamera.CameraSubject = nil
    workspace.CurrentCamera.CFrame = workspace:WaitForChild("CameraPOS").CFrame
    enabled = true

    while player_gui.Menu.CustomizationFrame:GetAttribute("vis") do
        task.wait()
        workspace.CurrentCamera.CFrame = workspace:WaitForChild("CameraPOS").CFrame
        local _ = text_2 == "None"
    end

    enabled = false
    workspace.CurrentCamera.CameraSubject = local_player.Character:FindFirstChild("Neck_CameraSubject")
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
end

function newList(parent: any, child_name_2: string, child_name_3: any)
    if not parent.Visible then
        if parent.Name == "ListContainer" then
            parent.Visible = true
            parent.Position = UDim2.new(1.25, 0, 0.5, 0)
            tween_service
                :Create(parent, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    Position = UDim2.new(0.871, 0, 0.5, 0),
                })
                :Play()
            tween_service
                :Create(
                    player_gui.customization.container.CosmeticContainer,
                    TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    {
                        Position = UDim2.new(-1, 0, 0.5, 0),
                    }
                )
                :Play()
            task.wait(1)
            player_gui.customization.container.CosmeticContainer.Visible = false
        else
            parent.Visible = true
            parent.Position = UDim2.new(-1, 0, 0.5, 0)
            tween_service
                :Create(parent, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                    Position = UDim2.new(0.12, 0, 0.5, 0),
                })
                :Play()
            tween_service
                :Create(
                    player_gui.customization.container.ListContainer,
                    TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    {
                        Position = UDim2.new(1.25, 0, 0.5, 0),
                    }
                )
                :Play()
            task.wait(1)
            player_gui.customization.container.ListContainer.Visible = false
        end
    end

    if child_name_2 == "Cosmetic" then
        print(child_name_3)

        for _, child in game.ReplicatedStorage.Cosmetics:FindFirstChild(child_name_3):GetChildren() do
            local clone = parent.Folder.Template:Clone()
            clone.Parent = parent
            clone.Visible = true
            clone.Text = child.Name
            clone.Name = child.Name
            local connection_2 = clone.MouseButton1Click:Connect(function()
                if value.Name == "Left Leg" then
                    for _, child2 in customization_dummy:GetChildren() do
                        if child2:HasTag("CleatL") then
                            child2:Destroy()
                        end
                    end
                elseif value.Name == "Right Leg" then
                    for _, child2_2 in customization_dummy:GetChildren() do
                        if child2_2:HasTag("CleatR") then
                            child2_2:Destroy()
                        end
                    end
                elseif value.Name == "Left Arm" then
                    for _, child2_3 in customization_dummy:GetChildren() do
                        if child2_3:HasTag("HandL") then
                            child2_3:Destroy()
                        end
                    end
                elseif value.Name == "Right Arm" then
                    for _, child2_4 in customization_dummy:GetChildren() do
                        if child2_4:HasTag("HandR") then
                            child2_4:Destroy()
                        end
                    end
                end

                local clone_4 =
                    game.ReplicatedStorage.Cosmetics:FindFirstChild(child_name_3):FindFirstChild(clone.Name):Clone()
                clone_4.Parent = customization_dummy
                clone_4:AddTag("Cosmetic")

                if value.Name == "Left Leg" then
                    clone_4:AddTag("CleatL")
                elseif value.Name == "Right Leg" then
                    clone_4:AddTag("CleatR")
                elseif value.Name == "Left Arm" then
                    clone_4:AddTag("HandL")
                elseif value.Name == "Right Arm" then
                    clone_4:AddTag("HandR")
                end

                for _, item in values_2 do
                    if item.Priority ~= Enum.AnimationPriority.Idle then
                        item:Stop()
                    end
                end

                if
                    not string.find(value.Name, "Arm")
                    and values_2[value.Name == "Left Leg" and "LeftFoot" or "RightFoot"]
                then
                    values_2[value.Name == "Left Leg" and "LeftFoot" or "RightFoot"]:Play()
                end

                if
                    not string.find(value.Name, "Leg")
                    and values_2[value.Name == "Left Arm" and "LeftHand" or "RightHand"]
                then
                    values_2[value.Name == "Left Arm" and "LeftHand" or "RightHand"]:Play()
                end

                values_5[child_name_3](clone_4, value)
            end)

            clone.Destroying:Once(function()
                connection_2:Disconnect()
            end)
        end

        return
    end

    if child_name_2 == "JerseyType" then
        for _, child_name in { "Shirt", "Undershirt", "LongSleeve", "Tracksuit" } do
            local clone_2 = parent.Folder.Template:Clone()
            clone_2.Parent = parent
            clone_2.Visible = true
            clone_2.Text = child_name
            clone_2.Name = child_name
            local connection_3 = clone_2.MouseButton1Click:Connect(function()
                text = "Jersey"
                text_2 = child_name
                previewTeam(randomthingFromParent(game.ReplicatedStorage.Cosmetics.Jerseys).Name, child_name)
            end)

            clone_2.Destroying:Once(function()
                connection_3:Disconnect()
            end)
        end

        return
    end

    for _, child_2 in game.ReplicatedStorage:FindFirstChild(child_name_2):GetChildren() do
        local clone_3 = parent.Folder.Template:Clone()
        clone_3.Parent = parent
        clone_3.Visible = true
        clone_3.Text = child_2.Name
        clone_3.Name = child_2.Name
        local connection_4 = clone_3.MouseButton1Click:Connect(function()
            if child_name_2 == "AnimFolder" then
                text = "None"
                text_2 = child_2.Name
                text = "AnimLoop"

                return
            end

            if child_name_2 ~= "MVPEyes" then
                if child_name_2 == "Auras" then
                    text = "None"
                    text_2 = child_2.Name
                    doAura(9999, child_2.Name)
                end

                return
            end

            text = "None"
            text_2 = child_2.Name
            doMVPEye(9999, child_2.Name)
        end)

        clone_3.Destroying:Once(function()
            connection_4:Disconnect()
        end)
    end
end

local connection = nil
local value_2 = nil

local function cam_look_at(argument, field_of_view)
    if argument == nil then
        if connection then
            tween_service
                :Create(workspace.CurrentCamera, TweenInfo.new(0.5), {
                    FieldOfView = 70,
                })
                :Play()
            connection:Disconnect()
            connection = nil
            value_2 = nil
            game.TweenService
                :Create(workspace.CurrentCamera, TweenInfo.new(1), {
                    CFrame = workspace:WaitForChild("CameraPOS").CFrame,
                })
                :Play()

            return "noAnim"
        end

        return
    end

    if connection and value_2 == argument then
        connection:Disconnect()
        connection = nil
        tween_service
            :Create(workspace.CurrentCamera, TweenInfo.new(0.5), {
                FieldOfView = 70,
            })
            :Play()
        game.TweenService
            :Create(workspace.CurrentCamera, TweenInfo.new(1), {
                CFrame = workspace:WaitForChild("CameraPOS").CFrame,
            })
            :Play()
        value_2 = nil

        return "noAnim"
    end

    if connection then
        connection:Disconnect()
        connection = nil
    end

    value_2 = argument
    tween_service
        :Create(workspace.CurrentCamera, TweenInfo.new(0.5), {
            FieldOfView = field_of_view,
        })
        :Play()
    connection = game["Run Service"].RenderStepped:Connect(function()
        if not enabled then
            connection:Disconnect()
            connection = nil
        end

        workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(
            CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, argument.Position),
            0.5
        )
    end)
end

local function init_click_detectors()
    values_2.Idle = customization_dummy.Humanoid.Animator:LoadAnimation(script.InspectAnims.Idle)
    values_2.LeftFoot = customization_dummy.Humanoid.Animator:LoadAnimation(script.InspectAnims.Feet.Left)
    values_2.RightFoot = customization_dummy.Humanoid.Animator:LoadAnimation(script.InspectAnims.Feet.Right)
    values_2.LeftHand = customization_dummy.Humanoid.Animator:LoadAnimation(script.InspectAnims.Hand.Left)
    values_2.RightHand = customization_dummy.Humanoid.Animator:LoadAnimation(script.InspectAnims.Hand.Right)
    values_2.Idle.Priority = Enum.AnimationPriority.Idle
    values_2.Idle.Looped = true
    values_2.Idle:Play()
    print("Attempted To Init??")
    task.wait(2)

    for _, right_hand in customization_dummy:QueryDescendants("ClickDetector") do
        print("Clicker Initted")

        if right_hand.Parent.Name == "Right Arm" then
            right_hand.Name = "RightHand"
            right_hand:AddTag("Hands")
        elseif right_hand.Parent.Name == "Left Arm" then
            right_hand.Name = "LeftHand"
            right_hand:AddTag("Hands")
        elseif right_hand.Parent.Name == "Left Leg" then
            right_hand.Name = "LeftFoot"
            right_hand:AddTag("Cleats")
        elseif right_hand.Parent.Name == "Right Leg" then
            right_hand.Name = "RightFoot"
            right_hand:AddTag("Cleats")
        else
            right_hand:AddTag(right_hand.Parent.Name)
        end

        right_hand.MouseClick:Connect(function()
            print("CLICKED")
            value = right_hand.Parent

            if cam_look_at(right_hand.Parent, 50) == "noAnim" then
                value = nil

                return
            end

            for _, item in values_2 do
                if item.Priority ~= Enum.AnimationPriority.Idle then
                    item:Stop()
                end
            end

            if values_2[right_hand.Name] then
                values_2[right_hand.Name]:Play()
            end
        end)
    end
end

function customization.init()
    local_player:WaitForChild("SelectedTeam").Changed:Connect(function()
        if local_player:FindFirstChild("SelectedTeam").Value ~= "N/A" then
            enabled = false
            player_gui.Menu.CustomizationFrame:SetAttribute("vis", false)
        end
    end)

    init_click_detectors()
    previewTeam(
        randomthingFromParent(game.ReplicatedStorage.Cosmetics.Jerseys).Name,
        local_player:GetAttribute("JerseyType") or "Shirt"
    )
    loadCosmetics()
    runCustomizationSetup()
    local menu_buttons = player_gui.Menu:WaitForChild("MenuButtons")
    local customize_button = menu_buttons:WaitForChild("CustomizeButton")
    local play_button = player_gui.Menu:WaitForChild("PlayButton")
    local color_selector = customization_frame:WaitForChild("ColorSelector")

    customize_button.MouseButton1Click:Connect(function()
        color_selector.Visible = false
        customization_frame:SetAttribute("vis", true)
        runCustomizationSetup()
        tween_service
            :Create(
                customization_frame.ItemsFrame,
                TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    Position = UDim2.new(0, 0, 0.5, 0),
                }
            )
            :Play()
        tween_service
            :Create(
                customization_frame.SelectFrame,
                TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    Position = UDim2.new(1, 0, 1, 0),
                }
            )
            :Play()
        tween_service
            :Create(
                customization_frame.CancelButton,
                TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    Position = UDim2.new(0.5, 0, 0.95, 0),
                }
            )
            :Play()
        tween_service
            :Create(player_gui.Menu.ClubFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 1.5, 0),
            })
            :Play()

        task.delay(0.35, function()
            player_gui.Menu.ClubFrame.Visible = false
        end)

        menu_buttons.Visible = false
        play_button.Visible = false
        camera()
    end)

    customization_frame.CancelButton.MouseButton1Click:Connect(function()
        customization_frame:SetAttribute("vis", false)
        color_selector.Visible = false
        tween_service
            :Create(
                customization_frame.ItemsFrame,
                TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    Position = UDim2.new(0, -350, 0.5, 0),
                }
            )
            :Play()
        tween_service
            :Create(
                customization_frame.SelectFrame,
                TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    Position = UDim2.new(1, 800, 1, 0),
                }
            )
            :Play()
        tween_service
            :Create(
                customization_frame.CancelButton,
                TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    Position = UDim2.new(0.5, 0, 0.95, 200),
                }
            )
            :Play()
        tween_service
            :Create(equip_frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 1, 150),
            })
            :Play()
        menu_buttons.Visible = true
        play_button.Visible = true
    end)
end

return customization
