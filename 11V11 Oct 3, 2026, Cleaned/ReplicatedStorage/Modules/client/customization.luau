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
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key_handler_service = knit.GetService("KeyHandlerService")
local _ = key_handler_service:GetKey("customize")
local remote_function = key_handler_service:GetKey("BuyCheck")
local values = {}
values.Aura = items_frame:WaitForChild("AurasFrame")
values.AnimationPack = items_frame:WaitForChild("AnimationFrame")
values.Eyes = items_frame:WaitForChild("EyesFrame")
values.Glove = items_frame:WaitForChild("GoalieGlovesFrame")
values.GoalCeleb = items_frame:WaitForChild("GoalCelebFrame")
values.WinCeleb = items_frame:WaitForChild("WinCelebFrame")
local tween_service = game:GetService("TweenService")
local text = require("@game/ReplicatedStorage/Modules/ColorPicker")
local text_2 = "None"
local name = "None"
local value = nil
local text_3 = ""
local values_2 = {}
local values_3 = {}
values_3.Common = Color3.new(1, 1, 1)
values_3.Rare = Color3.new(0.262745, 0.462745, 0.792157)
values_3.Epic = Color3.new(0.792157, 0, 0.862745)
values_3.Legendary = Color3.new(1, 0, 0)
values_3.Exclusive = Color3.new(1, 0.968627, 0)
local items_frame_2 = player_gui:WaitForChild("Menu"):WaitForChild("CustomizationFrame").ItemsFrame
local item_info = game.ReplicatedStorage:WaitForChild("ItemInfo")
local values_4 = {}
values_4.Argentina = Vector3.new(0.5882350206375122, 0.7725489735603333, 0.8862749934196472)
values_4.Brazil = Vector3.new(0.21899999678134918, 0.6700000166893005, 0.5450000166893005)
values_4.Flamengo = Vector3.new(0.050980400294065475, 0.050980400294065475, 0.050980400294065475)
values_4.AstonVilla = Vector3.new(0.5333330035209656, 0.6862750053405762, 0.8274509906768799)
values_4.Barcelona = Vector3.new(0.6499999761581421, 0.13699999451637268, 0.19200000166893005)
values_4.Dortmund = Vector3.new(0.20000000298023224, 0.20000000298023224, 0.20000000298023224)
values_4.Japan = Vector3.new(0.8389999866485596, 0.15600000321865082, 0.125)
values_4.InterMiami = Vector3.new(0.10000000149011612, 0.10000000149011612, 0.10000000149011612)
values_4.ManchesterU = Vector3.new(0.47200000286102295, 0.07999999821186066, 0.125)
values_4.Munich = Vector3.new(0.0430000014603138, 0.164000004529953, 0.36399999260902405)
values_4.ParisSaints = Vector3.new(0.0860000029206276, 0.11299999803304672, 0.257999986410141)
values_4.Italy = Vector3.new(0.12941177189350128, 0.2862745225429535, 0.6823529601097107)
values_4.Croatia = Vector3.new(0.11299999803304672, 0.2070000022649765, 0.3799999952316284)
values_4.Morocco = Vector3.new(0.12099999934434891, 0.37599998712539673, 0.28999999165534973)
values_4.Canada = Vector3.new(0.9150000214576721, 0.10000000149011612, 0.10000000149011612)
values_4.Portugal = Vector3.new(0.6230000257492065, 0.125, 0.15600000321865082)
values_4.Mexico = Vector3.new(0.0430000014603138, 0.4779999852180481, 0.31299999356269836)
values_4.Netherlands = Vector3.new(0.9129999876022339, 0.44999998807907104, 0.07400000095367432)
values_4.RealMadrid = Vector3.new(1, 1, 1)
values_4.LiverpoolFC = Vector3.new(0.1294119954109192, 0.1294119954109192, 0.1294119954109192)
values_4.SeattleSoundersFC = Vector3.new(0.3409999907016754, 0.5600000023841858, 0.23100000619888306)
values_4.JuventusFC = Vector3.new(0.11999999731779099, 0.11999999731779099, 0.11999999731779099)
values_4.Newcastle = Vector3.new(1, 1, 1)
values_4.ManchesterCity = Vector3.new(0.5333333611488342, 0.7137255072593689, 0.8784313797950745)
values_4.Germany = Vector3.new(0.9900000095367432, 0.9900000095367432, 0.9900000095367432)
values_4.England = Vector3.new(0.003921568859368563, 0.16862745583057404, 0.7372549176216125)
values_4.Arsenal = Vector3.new(1, 1, 1)
values_4.InterMilan = Vector3.new(0.10980392247438431, 0.29411765933036804, 0.5411764979362488)
values_4.USA = Vector3.new(0.0784313753247261, 0.06666667014360428, 0.6392157077789307)
values_4.Chelsea = Vector3.new(0.20000000298023224, 0.20000000298023224, 0.6666666865348816)
values_4.Napoli = Vector3.new(1, 1, 1)
values_4.France = Vector3.new(0.029999999329447746, 0.029999999329447746, 0.029999999329447746)
values_4.Uruguay = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
values_4.Roma = Vector3.new(0.45490196347236633, 0.07450980693101883, 0.11764705926179886)
values_4.Lazio = Vector3.new(0.9800000190734863, 0.9800000190734863, 0.9800000190734863)
values_4.SouthKorea = Vector3.new(0.9900000095367432, 0.9900000095367432, 0.9900000095367432)
values_4.VascoDaGama = Vector3.new(0.9599999785423279, 0.9599999785423279, 0.9599999785423279)
values_4.Ajax = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
values_4.Atletico = Vector3.new(0.7568627595901489, 0, 0.0313725508749485)
values_4.Leverkusen = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
values_4.Wales = Vector3.new(0.18431372940540314, 0.1882352977991104, 0.2235294133424759)
values_4.Fiorentina = Vector3.new(0.27843138575553894, 0.12156862765550613, 0.40392157435417175)
values_4.Spurs = Vector3.new(0.9900000095367432, 0.9900000095367432, 0.9900000095367432)
values_4.ACMilan = Vector3.new(0.03999999910593033, 0.03999999910593033, 0.03999999910593033)
values_4.Belgium = Vector3.new(0.6078431606292725, 0.10196078568696976, 0.16470588743686676)
values_4.Spain = Vector3.new(0.5137255191802979, 0, 0)
values_4.Scotland = Vector3.new(0.14901961386203766, 0.2549019753932953, 0.4901960790157318)
values_4.Poland = Vector3.new(1, 0.0784313976764679, 0.09411759674549103)
values_4.Sweden = Vector3.new(0.10588199645280838, 0.18039199709892273, 0.3882350027561188)
values_4.Bosnia = Vector3.new(0.03921569883823395, 0.10980399698019028, 0.3882350027561188)
values_4.Denmark = Vector3.new(0.6000000238418579, 0.10980399698019028, 0.1254899948835373)
values_4.Romania = Vector3.new(0.9686269760131836, 0.8156859874725342, 0.1254899948835373)
values_4.Switzerland = Vector3.new(0.49411800503730774, 0.08627449721097946, 0.1254899948835373)

function animationPreview(child_name, child_name_2)
    for _, item in customization_dummy.Humanoid.Animator:GetPlayingAnimationTracks() do
        if item.Priority ~= Enum.AnimationPriority.Idle then
            item:Stop()
        end
    end
    local first_child = game.ReplicatedStorage.AnimFolder:FindFirstChild(child_name):FindFirstChild(child_name_2)
    if first_child.Name == "Idle" or not first_child then
        return
    end
    customization_dummy.Humanoid.Animator:LoadAnimation(first_child):Play()
end

function randomthingFromParent(instance)
    local children = instance:GetChildren()
    return children[math.random(1, #children)]
end

local function show_category(argument)
    for _, child in ipairs(items_frame_2:GetChildren()) do
        if child:IsA("ScrollingFrame") or child:IsA("Frame") then
            child.Visible = false
        end
    end
    local value_entry = values[argument]
    if not value_entry then
        return
    end
    value_entry.Visible = true
end

function previewTeam(child_name, child_name_2)
    for _, instance in customization_dummy:GetChildren() do
        if instance:HasTag("Clothing") then
            instance:Destroy()
        end
    end
    local first_child = game.ReplicatedStorage.Cosmetics.Jerseys:FindFirstChild(child_name)
    if not first_child then
        return
    end
    for _, instance_2 in customization_dummy:GetChildren() do
        if instance_2:IsA("Shirt") then
            instance_2:Destroy()
        end
        if instance_2:IsA("Pants") then
            instance_2:Destroy()
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

local function tween_beam_transparency(argument, argument_2, tween_info, enabled_2)
    local number_value = Instance.new("NumberValue")
    number_value.Value = ((enabled_2 ~= true) and 0) or 1
    local items = {}
    for n = 1, #argument_2.Keypoints do
        table.insert(items, n, argument_2.Keypoints[n])
    end
    number_value.Changed:Connect(function(argument_3)
        local items_2 = {}
        local value_3 = nil
        for index, item in ipairs(items) do
            value_3 = ((enabled_2 == true) and (item.Value + argument_3)) or (item.Value * argument_3)
            if item.Value == 1 then
                value_3 = 1
            end
            table.insert(items_2, index, NumberSequenceKeypoint.new(item.Time, value_3))
        end
        argument.Transparency = NumberSequence.new(items_2)
    end)
    local tween_properties = { Value = 0 }
    tween_properties.Value = ((enabled_2 ~= true) and 1) or 0
    local tween = tween_service:Create(number_value, tween_info, tween_properties)
    tween.Completed:Once(function()
        number_value:Destroy()
    end)
    tween:Play()
end

function doAura(argument, child_name)
    task.spawn(function()
        local first_child = game.ReplicatedStorage.Cosmetics.Auras:FindFirstChild(child_name)
        for _, instance in customization_dummy:GetDescendants() do
            if instance:HasTag("MVPEyes") then
                instance:Destroy()
            end
        end
        for _, instance_2 in customization_dummy:GetDescendants() do
            if instance_2:HasTag("Aura") then
                instance_2:Destroy()
            end
        end
        if not first_child then
            return
        end
        for _, descendant in pairs(first_child:GetDescendants()) do
            if descendant:IsA("Part") then
                descendant:AddTag("Aura")
                continue
            end
            if descendant:IsA("ParticleEmitter") then
                descendant:AddTag("Aura")
                if descendant:GetAttribute("colorable") then
                    continue
                else
                    continue
                end
            elseif descendant:IsA("Beam") or descendant:IsA("Trail") then
                descendant:AddTag("Aura")
            end
        end
        local instance_3 = nil
        local value_3 = nil
        local instance_4 = nil
        local value_4 = nil
        local instance_5 = nil
        local value_5 = nil
        local instance_6 = nil
        local instance_7 = nil
        local instance_8 = nil
        local value_6 = nil
        local value_7 = nil
        local value_8 = nil
        for _, child in pairs(first_child:GetChildren()) do
            if child.Name == "Torso" then
                local clone = child:Clone()
                clone.Name = "Aura"
                clone.Parent = customization_dummy.Torso
            end
            if child.Name == "Left Arm" then
                local clone_2 = child:Clone()
                clone_2.Name = "Aura"
                clone_2.Parent = customization_dummy["Left Arm"]
            end
            if child.Name == "Left Leg" then
                local clone_3 = child:Clone()
                clone_3.Name = "Aura"
                clone_3.Parent = customization_dummy["Left Leg"]
            end
            if child.Name == "Right Leg" then
                local clone_4 = child:Clone()
                clone_4.Name = "Aura"
                clone_4.Parent = customization_dummy["Right Leg"]
            end
            if child.Name == "Right Arm" then
                local clone_5 = child:Clone()
                clone_5.Name = "Aura"
                clone_5.Parent = customization_dummy["Right Arm"]
            end
            if child.Name == "Head" then
                local clone_6 = child:Clone()
                clone_6.Name = "Aura"
                clone_6.Parent = customization_dummy.Head
            end
            for index, descendant_2 in ipairs(child:GetDescendants()) do
                if descendant_2:IsA("Light") or descendant_2:IsA("Script") then
                    descendant_2:Destroy()
                end
            end
            if child.Name ~= "AttachmentHolder" then
                continue
            end
            for key, child_2 in pairs(child:GetChildren()) do
                if child_2.Name == "HRP" then
                    value_7 = child_2:Clone()
                    value_7.Name = "Aura"
                    value_7.Parent = customization_dummy.HumanoidRootPart
                    if value_7:IsA("Part") and value_7:FindFirstChildOfClass("Weld") then
                        value_7:FindFirstChildOfClass("Weld").Part0 = customization_dummy.HumanoidRootPart
                        game.Debris:AddItem(value_7, argument)
                    end
                    if first_child.Name == "Flaming Wings" then
                        for index_2, descendant_3 in ipairs(value_7:GetDescendants()) do
                            if descendant_3:IsA("ParticleEmitter") then
                                descendant_3.Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 1),
                                    NumberSequenceKeypoint.new(0.5, 0.95),
                                    NumberSequenceKeypoint.new(1, 1),
                                })
                                descendant_3.Rate = descendant_3.Rate / 2
                            end
                        end
                    elseif first_child.Name == "Blue Death" or first_child.Name == "Determination" then
                        for index_3, descendant_4 in ipairs(value_7:GetDescendants()) do
                            if descendant_4:IsA("ParticleEmitter") then
                                descendant_4.Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 1),
                                    NumberSequenceKeypoint.new(0.25, 0.95),
                                    NumberSequenceKeypoint.new(1, 1),
                                })
                                descendant_4.Rate = descendant_4.Rate / 2
                            end
                        end
                    elseif first_child.Name == "A Certain Gambler" then
                        for index_4, descendant_5 in ipairs(value_7:GetDescendants()) do
                            if descendant_5:IsA("ParticleEmitter") then
                                descendant_5.Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 1),
                                    NumberSequenceKeypoint.new(0.259, 1),
                                    NumberSequenceKeypoint.new(0.26, 0.7),
                                    NumberSequenceKeypoint.new(0.76, 0.7),
                                    NumberSequenceKeypoint.new(1, 1),
                                })
                                descendant_5.Rate = descendant_5.Rate / 2
                            end
                        end
                    elseif first_child.Name == "Sakura" then
                        for index_5, descendant_6 in ipairs(value_7:GetDescendants()) do
                            if descendant_6:IsA("ParticleEmitter") then
                                descendant_6.Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 1),
                                    NumberSequenceKeypoint.new(0.5, 0.1),
                                    NumberSequenceKeypoint.new(0.85, 0.1),
                                    NumberSequenceKeypoint.new(1, 1),
                                })
                                descendant_6.Rate = descendant_6.Rate / 2
                            end
                        end
                    end
                    value_8 = value_7:FindFirstChildOfClass("Beam")
                    if not value_8 then
                        continue
                    end
                    if first_child.Name ~= "Calculated Destruction" then
                        value_8.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.8),
                            NumberSequenceKeypoint.new(1, 0.8),
                        })
                    else
                        value_8.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.3),
                            NumberSequenceKeypoint.new(1, 0.3),
                        })
                    end
                elseif child_2.Name == "Head" then
                    instance_8 = child_2:Clone()
                    instance_8.Name = "Aura"
                    instance_8.Parent = customization_dummy.Head
                    if instance_8:IsA("Part") then
                        game.Debris:AddItem(instance_8, argument)
                        local weld = instance_8:FindFirstChildOfClass("Weld")
                            or (instance_8:FindFirstChildOfClass("Motor6D"))
                        if weld then
                            weld.Part0 = customization_dummy.Head
                        end
                    end
                    if instance_8:GetAttribute("disband") then
                        task.spawn(function()
                            for _, value_9 in pairs(instance_8:GetChildren()) do
                                if value_9:IsA("Attachment") then
                                    task.spawn(function()
                                        for _, child_4 in pairs(value_9:GetChildren()) do
                                            child_4.Name = "Aura"
                                        end
                                    end)
                                else
                                    value_9.Name = "Aura"
                                end
                                value_9.Parent = customization_dummy.Head
                            end
                            instance_8:Destroy()
                        end)
                    end
                    value_6 = instance_8:FindFirstChildOfClass("Beam")
                    if not value_6 then
                        continue
                    end
                    if first_child.Name ~= "Monster" then
                        value_6.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.8),
                            NumberSequenceKeypoint.new(1, 0.8),
                        })
                    end
                elseif child_2.Name == "Torso" then
                    instance_7 = child_2:Clone()
                    instance_7.Name = "Aura"
                    instance_7.Parent = customization_dummy.Torso
                    if instance_7:FindFirstChildOfClass("Weld") then
                        game.Debris:AddItem(instance_7, argument)
                        instance_7:FindFirstChildOfClass("Weld").Part0 = customization_dummy.Torso
                    end
                    if instance_7:GetAttribute("disband") then
                        task.spawn(function()
                            for _, value_9 in pairs(instance_7:GetChildren()) do
                                if value_9:IsA("Attachment") then
                                    task.spawn(function()
                                        for _, child_4 in pairs(value_9:GetChildren()) do
                                            child_4.Name = "Aura"
                                        end
                                    end)
                                else
                                    value_9.Name = "Aura"
                                end
                                value_9.Parent = customization_dummy.Torso
                            end
                            instance_7:Destroy()
                        end)
                    end
                    local beam = instance_7:FindFirstChildOfClass("Beam")
                    if first_child.Name == "Flaming Wings" then
                        for index_6, descendant_7 in ipairs(instance_7:GetDescendants()) do
                            if descendant_7:IsA("ParticleEmitter") then
                                descendant_7.Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 1),
                                    NumberSequenceKeypoint.new(0.5, 0.95),
                                    NumberSequenceKeypoint.new(1, 1),
                                })
                                descendant_7.Rate = descendant_7.Rate / 2
                            end
                        end
                    elseif first_child.Name == "Godly" then
                        for index_7, descendant_8 in ipairs(instance_7:GetDescendants()) do
                            if descendant_8:IsA("ParticleEmitter") then
                                descendant_8.Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 1),
                                    NumberSequenceKeypoint.new(0.5, 0.9),
                                    NumberSequenceKeypoint.new(1, 1),
                                })
                                descendant_8.Rate = descendant_8.Rate / 3
                            end
                        end
                    elseif first_child.Name == "Death" then
                        for index_8, descendant_9 in ipairs(instance_7:GetDescendants()) do
                            if descendant_9:IsA("ParticleEmitter") then
                                descendant_9.Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 1),
                                    NumberSequenceKeypoint.new(0.5, 0.8),
                                    NumberSequenceKeypoint.new(1, 1),
                                })
                                descendant_9.Rate = descendant_9.Rate / 2
                            end
                        end
                    end
                    if beam then
                        beam.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.8),
                            NumberSequenceKeypoint.new(1, 0.8),
                        })
                    end
                elseif child_2.Name == "Left Arm" then
                    instance_6 = child_2:Clone()
                    instance_6.Name = "Aura"
                    instance_6.Parent = customization_dummy["Left Arm"]
                    if instance_6:FindFirstChildOfClass("Weld") then
                        game.Debris:AddItem(instance_6, argument)
                        instance_6:FindFirstChildOfClass("Weld").Part0 = customization_dummy["Left Arm"]
                    end
                    if instance_6:GetAttribute("disband") then
                        task.spawn(function()
                            for _, child_4 in pairs(instance_6:GetChildren()) do
                                child_4.Name = "Aura"
                                child_4.Parent = customization_dummy["Left Arm"]
                            end
                            instance_6:Destroy()
                        end)
                    end
                    local beam_2 = instance_6:FindFirstChildOfClass("Beam")
                    if first_child.Name == "Blue Rose" then
                        for index_9, descendant_10 in ipairs(instance_6:GetDescendants()) do
                            if descendant_10:IsA("ParticleEmitter") then
                                descendant_10.Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 1),
                                    NumberSequenceKeypoint.new(0.5, 0.95),
                                    NumberSequenceKeypoint.new(1, 1),
                                })
                                descendant_10.Rate = descendant_10.Rate / 2
                            end
                        end
                    end
                    if beam_2 then
                        beam_2.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.8),
                            NumberSequenceKeypoint.new(1, 0.8),
                        })
                    end
                elseif child_2.Name == "Left Leg" then
                    instance_5 = child_2:Clone()
                    instance_5.Name = "Aura"
                    instance_5.Parent = customization_dummy["Left Leg"]
                    if instance_5:FindFirstChildOfClass("Weld") then
                        game.Debris:AddItem(instance_5, argument)
                        instance_5:FindFirstChildOfClass("Weld").Part0 = customization_dummy["Left Leg"]
                    end
                    if instance_5:GetAttribute("disband") then
                        task.spawn(function()
                            for _, value_9 in pairs(instance_5:GetChildren()) do
                                if value_9:IsA("Attachment") then
                                    task.spawn(function()
                                        for _, child_4 in pairs(value_9:GetChildren()) do
                                            child_4.Name = "Aura"
                                        end
                                    end)
                                else
                                    value_9.Name = "Aura"
                                end
                                value_9.Parent = customization_dummy["Left Leg"]
                            end
                            instance_5:Destroy()
                        end)
                    end
                    value_5 = instance_5:FindFirstChildOfClass("Beam")
                    if not value_5 then
                        continue
                    end
                    if first_child.Name ~= "Monster" then
                        value_5.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.8),
                            NumberSequenceKeypoint.new(1, 0.8),
                        })
                    end
                elseif child_2.Name == "Right Leg" then
                    instance_4 = child_2:Clone()
                    instance_4.Name = "Aura"
                    instance_4.Parent = customization_dummy["Right Leg"]
                    if instance_4:FindFirstChildOfClass("Weld") then
                        game.Debris:AddItem(instance_4, argument)
                        instance_4:FindFirstChildOfClass("Weld").Part0 = customization_dummy["Right Leg"]
                    end
                    if instance_4:GetAttribute("disband") then
                        task.spawn(function()
                            for _, value_9 in pairs(instance_4:GetChildren()) do
                                if value_9:IsA("Attachment") then
                                    task.spawn(function()
                                        for _, child_4 in pairs(value_9:GetChildren()) do
                                            child_4.Name = "Aura"
                                        end
                                    end)
                                else
                                    value_9.Name = "Aura"
                                end
                                value_9.Parent = customization_dummy["Right Leg"]
                            end
                            instance_4:Destroy()
                        end)
                    end
                    value_4 = instance_4:FindFirstChildOfClass("Beam")
                    if not value_4 then
                        continue
                    end
                    if first_child.Name ~= "Monster" then
                        value_4.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.8),
                            NumberSequenceKeypoint.new(1, 0.8),
                        })
                    end
                elseif child_2.Name == "Right Arm" then
                    instance_3 = child_2:Clone()
                    instance_3.Name = "Aura"
                    instance_3.Parent = customization_dummy["Right Arm"]
                    if instance_3:FindFirstChildOfClass("Weld") then
                        game.Debris:AddItem(instance_3, argument)
                        instance_3:FindFirstChildOfClass("Weld").Part0 = customization_dummy["Right Arm"]
                    end
                    if instance_3:GetAttribute("disband") then
                        task.spawn(function()
                            for _, value_9 in pairs(instance_3:GetChildren()) do
                                if value_9:IsA("Attachment") then
                                    task.spawn(function()
                                        for _, child_4 in pairs(value_9:GetChildren()) do
                                            child_4.Name = "Aura"
                                        end
                                    end)
                                else
                                    value_9.Name = "Aura"
                                end
                                value_9.Parent = customization_dummy["Right Arm"]
                            end
                            instance_3:Destroy()
                        end)
                    end
                    value_3 = instance_3:FindFirstChildOfClass("Beam")
                    if not value_3 then
                        continue
                    end
                    if first_child.Name ~= "Monster" then
                        value_3.Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.8),
                            NumberSequenceKeypoint.new(1, 0.8),
                        })
                    end
                end
            end
        end
        for _, parent in pairs(customization_dummy:GetChildren()) do
            if
                parent.Name == "Right Arm"
                or parent.Name ~= "Right Arm" and parent.Name == "Left Arm"
                or parent.Name ~= "Right Arm" and parent.Name ~= "Left Arm" and parent.Name == "Left Leg"
                or parent.Name ~= "Right Arm" and parent.Name ~= "Left Arm" and parent.Name ~= "Left Leg" and parent.Name == "Right Leg"
                or parent.Name ~= "Right Arm" and parent.Name ~= "Left Arm" and parent.Name ~= "Left Leg" and parent.Name ~= "Right Leg" and parent.Name == "Head"
                or parent.Name ~= "Right Arm"
                    and parent.Name ~= "Left Arm"
                    and parent.Name ~= "Left Leg"
                    and parent.Name ~= "Right Leg"
                    and parent.Name ~= "Head"
                    and parent.Name == "Torso"
            then
                for key_2, child_3 in pairs(first_child:GetChildren()) do
                    if
                        child_3:IsA("ParticleEmitter") and child_3.Name == "Aura"
                        or child_3:IsA("Attachment") and child_3.Name ~= "Torso"
                    then
                        local clone_7 = child_3:Clone()
                        clone_7.Name = "Aura"
                        clone_7.Parent = parent
                    end
                end
            end
        end
        task.delay(argument, function()
            for _, value_9 in pairs(customization_dummy:GetDescendants()) do
                if value_9.Name == "HasAura" then
                    value_9:Destroy()
                end
                if value_9.Name == "Orbit" then
                    value_9:Destroy()
                end
                if value_9.Name ~= "Aura" then
                    continue
                end
                if value_9:IsA("ParticleEmitter") then
                    value_9.Enabled = false
                    task.delay(3, function()
                        value_9:Destroy()
                    end)
                    continue
                end
                if value_9:IsA("Script") then
                    value_9:Destroy()
                    continue
                end
                if not (value_9:IsA("Attachment")) then
                    continue
                end
                for key_3, value_10 in pairs(value_9:GetDescendants()) do
                    if value_10:IsA("ParticleEmitter") then
                        value_10.Enabled = false
                        task.delay(3, function()
                            value_10:Destroy()
                        end)
                        continue
                    end
                    if value_10:IsA("Beam") then
                        task.spawn(function()
                            tween_beam_transparency(
                                value_10,
                                NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 1),
                                    NumberSequenceKeypoint.new(1, 1),
                                }),
                                TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                false
                            )
                        end)
                        continue
                    end
                    if value_10:IsA("PointLight") then
                        local tween_properties = { Range = 0, Brightness = 0 }
                        game:GetService("TweenService")
                            :Create(
                                value_10,
                                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                tween_properties
                            )
                            :Play()
                    end
                end
                game.Debris:AddItem(value_9, 3)
            end
        end)
    end)
end

local values_5 = { Cleats = 0, Hands = 0 }

function values_5.Cleats(self, part0)
    self.Main.Main.Part0 = part0
end

function values_5.Hands(self, part0)
    if self == nil or not self:FindFirstChild("ArmWeld", true) then
        return
    end
    if self.Name == "Glove" and part0.Name ~= "Left Arm" then
        self:FindFirstChild("ArmWeldR", true).Part0 = part0
    else
        self:FindFirstChild("ArmWeld", true).Part0 = part0
    end
end

local function converter_string(argument)
    return "Cleats"
end

local function search4_cosmetic(argument, child_name)
    for _, instance in game.ReplicatedStorage.Cosmetics:GetChildren() do
        if instance.Name ~= argument or not (instance:FindFirstChild(child_name)) then
            continue
        end
        return (instance:FindFirstChild(child_name))
    end
    return nil
end

function loadCosmetics()
    local values_6 = { "LeftFoot", "RightFoot", "LeftHand", "RightHand", "Torso", "Head" }
    customization_dummy:WaitForChild("Left Arm", 20)
    customization_dummy:WaitForChild("Right Arm", 20)
    customization_dummy:WaitForChild("Left Leg", 20)
    customization_dummy:WaitForChild("Right Leg", 20)
    for _, instance in customization_dummy:GetChildren() do
        if instance:HasTag("Cosmetic") then
            instance:Destroy()
        end
    end
    local value_3 = nil
    for key, item in local_player:WaitForChild("Data"):GetChildren() do
        local match_index = table.find(values_6, item.Name)
        if not match_index then
            continue
        end
        local hands = "Cleats"
        local search4_cosmetic_2 = search4_cosmetic
        match_index = search4_cosmetic_2(hands, item.Value)
        if not match_index then
            continue
        end
        hands = "Cleats"
        local search4_cosmetic_3 = search4_cosmetic
        search4_cosmetic_3 = search4_cosmetic_3(hands, item.Value):Clone()
        search4_cosmetic_3:AddTag("Cosmetic")
        search4_cosmetic_3.Parent = customization_dummy
        if item.Name == "LeftFoot" or item.Name == "RightFoot" then
            if item.Name ~= "LeftFoot" then
                search4_cosmetic_3:AddTag("CleatR")
            else
                search4_cosmetic_3:AddTag("CleatL")
            end
            local cleats = values_5.Cleats
            if item.Name ~= "LeftFoot" then
                value_3 = customization_dummy["Right Leg"]
            else
                value_3 = customization_dummy["Left Leg"]
            end
            cleats(search4_cosmetic_3, value_3)
        end
        if item.Name == "LeftHand" or item.Name == "RightHand" then
            hands = values_5.Hands
            if item.Name ~= "LeftArm" then
                value_3 = customization_dummy["Right Arm"]
            else
                value_3 = customization_dummy["Left Arm"]
            end
            hands(search4_cosmetic_3, value_3)
        end
    end
end

function doMVPEye(argument, child_name)
    for _, instance in customization_dummy:GetDescendants() do
        if instance:HasTag("Aura") then
            instance:Destroy()
        end
    end
    for _, instance_2 in customization_dummy:GetDescendants() do
        if instance_2:HasTag("MVPEyes") then
            instance_2:Destroy()
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
        for _, item in parent:GetDescendants() do
            if item:IsA("ParticleEmitter") then
                item.Enabled = false
                continue
            end
            if item:IsA("Beam") then
                tween_beam_transparency(
                    item,
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
    local connection_4 = nil
    local connection_5 = nil
    local connection_2 = customization_frame.PopupContainer.YesButton.MouseButton1Click:Connect(function()
        if remote_function:InvokeServer(instance.Name) ~= nil then
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
            connection_5:Disconnect()
            customization_frame.PopupContainer.Visible = false
        else
            local clone_2 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
            clone_2.Parent = game.Workspace
            clone_2:Play()
            game.Debris:AddItem(clone_2, 3)
            task.spawn(function()
                local tween_properties = { Rotation = 45 }
                game:GetService("TweenService")
                    :Create(
                        instance.Locked,
                        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        tween_properties
                    )
                    :Play()
                task.wait(0.1)
                local tween_properties_2 = { Rotation = -45 }
                game:GetService("TweenService")
                    :Create(
                        instance.Locked,
                        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        tween_properties_2
                    )
                    :Play()
                task.wait(0.1)
                local tween_properties_3 = { Rotation = 0 }
                game:GetService("TweenService")
                    :Create(
                        instance.Locked,
                        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        tween_properties_3
                    )
                    :Play()
            end)
        end
    end)
    connection_5 = connection_2
    local connection_3 = customization_frame.PopupContainer.NoButton.MouseButton1Click:Connect(function()
        connection_5:Disconnect()
        connection_4:Disconnect()
        customization_frame.PopupContainer.Visible = false
    end)
    connection_4 = connection_3
end

function doSelection(instance)
    if
        not (table.find(string.split(local_player.Data.Inventory.Value), instance.Name))
        and instance:FindFirstChild("Price")
    then
        local tween_service_2 = game:GetService("TweenService")
        local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties = {}
        tween_properties.Position = UDim2.new(0.5, 0, 1, 150)
        tween_service_2:Create(equip_frame, tween_info, tween_properties):Play()
        showConfirmation(instance)
        return
    end
    if text_3 ~= instance.Name then
        for _, child in pairs(instance.Parent:GetChildren()) do
            if child == instance then
                continue
            end
            if child:IsA("ImageButton") then
                local tween_service_3 = game:GetService("TweenService")
                local tween_info_2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tween_properties_2 = { Transparency = 0.25, Thickness = 2 }
                tween_properties_2.Color = Color3.new(0.498039, 0.529412, 0.560784)
                tween_service_3:Create(child.UIStroke, tween_info_2, tween_properties_2):Play()
            end
        end
        text_3 = instance.Name
        local tween_service_4 = game:GetService("TweenService")
        local tween_info_3 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_3 = {}
        tween_properties_3.Position = UDim2.new(0.5, 0, 1, -125)
        tween_service_4:Create(equip_frame, tween_info_3, tween_properties_3):Play()
        tween_service_4 = game:GetService("TweenService")
        local tween_info_4 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_4 = { Transparency = 0, Thickness = 3 }
        tween_properties_4.Color = Color3.new(1, 1, 1)
        tween_service_4:Create(instance.UIStroke, tween_info_4, tween_properties_4):Play()
        equip_frame.EquipButton.Text = "EQUIP"
        for _, child_2 in pairs(local_player.Data:GetChildren()) do
            if not (child_2:IsA("StringValue")) or child_2.Value ~= instance.Name then
                continue
            end
            equip_frame.EquipButton.Text = "EQUIPPED"
            return
        end
    else
        text_3 = nil
        local tween_service_5 = game:GetService("TweenService")
        local tween_info_5 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_5 = {}
        tween_properties_5.Position = UDim2.new(0.5, 0, 1, 150)
        tween_service_5:Create(equip_frame, tween_info_5, tween_properties_5):Play()
        local tween_service_6 = game:GetService("TweenService")
        local tween_info_6 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_6 = { Transparency = 0.25, Thickness = 2 }
        tween_properties_6.Color = Color3.new(0.498039, 0.529412, 0.560784)
        tween_service_6:Create(instance.UIStroke, tween_info_6, tween_properties_6):Play()
    end
end

function runCustomizationSetup()
    for _, child in pairs(items_frame_2.AurasFrame:GetChildren()) do
        if child:IsA("ImageButton") then
            child:Destroy()
        end
    end
    for _, child_2 in pairs(items_frame_2.AnimationFrame:GetChildren()) do
        if child_2:IsA("ImageButton") then
            child_2:Destroy()
        end
    end
    for _, child_3 in pairs(items_frame_2.GoalieGlovesFrame:GetChildren()) do
        if child_3:IsA("ImageButton") then
            child_3:Destroy()
        end
    end
    for _, child_4 in pairs(items_frame_2.EyesFrame:GetChildren()) do
        if child_4:IsA("ImageButton") then
            child_4:Destroy()
        end
    end
    for _, child_5 in pairs(items_frame_2.GoalCelebFrame:GetChildren()) do
        if child_5:IsA("ImageButton") then
            child_5:Destroy()
        end
    end
    for _, child_6 in pairs(items_frame_2.WinCelebFrame:GetChildren()) do
        if child_6:IsA("ImageButton") then
            child_6:Destroy()
        end
    end
    local parts = string.split(local_player.Data.Inventory.Value)
    for _, descendant in pairs(items_frame_2:GetDescendants()) do
        if not (descendant:IsA("ImageButton")) then
            continue
        end
        if table.find(parts, descendant.Name) then
            if not (descendant:FindFirstChild("Locked")) then
                continue
            end
            descendant.Locked.Visible = false
            descendant.LockedBG.Visible = false
            if descendant:FindFirstChild("Price") then
                descendant.Price.Visible = false
            end
        else
            descendant.Locked.Visible = true
            descendant.LockedBG.Visible = true
            if descendant:FindFirstChild("Price") then
                descendant.Price.Visible = true
            end
        end
    end
    for _, child_name in pairs(parts) do
        local first_child = item_info:FindFirstChild(child_name)
        if not first_child then
            continue
        end
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
            end
            doSelection(instance)
        end)
        local parent = values[first_child.Type.Value]
        if parent then
            instance.Parent = parent
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
        if name ~= "None" then
            continue
        end
    end
    enabled = false
    workspace.CurrentCamera.CameraSubject = local_player.Character:FindFirstChild("Neck_CameraSubject")
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
end

function newList(parent, child_name, child_name_2)
    if not parent.Visible then
        if parent.Name ~= "ListContainer" then
            parent.Visible = true
            parent.Position = UDim2.new(-1, 0, 0.5, 0)
            local tween_info = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            local tween_properties = {}
            tween_properties.Position = UDim2.new(0.12, 0, 0.5, 0)
            tween_service:Create(parent, tween_info, tween_properties):Play()
            local tween_info_2 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            local tween_properties_2 = {}
            tween_properties_2.Position = UDim2.new(1.25, 0, 0.5, 0)
            tween_service
                :Create(player_gui.customization.container.ListContainer, tween_info_2, tween_properties_2)
                :Play()
            task.wait(1)
            player_gui.customization.container.ListContainer.Visible = false
        else
            parent.Visible = true
            parent.Position = UDim2.new(1.25, 0, 0.5, 0)
            local tween_info_3 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            local tween_properties_3 = {}
            tween_properties_3.Position = UDim2.new(0.871, 0, 0.5, 0)
            tween_service:Create(parent, tween_info_3, tween_properties_3):Play()
            local tween_info_4 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            local tween_properties_4 = {}
            tween_properties_4.Position = UDim2.new(-1, 0, 0.5, 0)
            tween_service
                :Create(player_gui.customization.container.CosmeticContainer, tween_info_4, tween_properties_4)
                :Play()
            task.wait(1)
            player_gui.customization.container.CosmeticContainer.Visible = false
        end
    end
    if child_name == "Cosmetic" then
        print(child_name_2)
        for _, item in game.ReplicatedStorage.Cosmetics:FindFirstChild(child_name_2):GetChildren() do
            local clone = parent.Folder.Template:Clone()
            clone.Parent = parent
            clone.Visible = true
            clone.Text = item.Name
            clone.Name = item.Name
            local connection_2 = clone.MouseButton1Click:Connect(function()
                if value.Name == "Left Leg" then
                    for _, instance in customization_dummy:GetChildren() do
                        if instance:HasTag("CleatL") then
                            instance:Destroy()
                        end
                    end
                elseif value.Name == "Right Leg" then
                    for _, instance_2 in customization_dummy:GetChildren() do
                        if instance_2:HasTag("CleatR") then
                            instance_2:Destroy()
                        end
                    end
                elseif value.Name == "Left Arm" then
                    for _, instance_3 in customization_dummy:GetChildren() do
                        if instance_3:HasTag("HandL") then
                            instance_3:Destroy()
                        end
                    end
                elseif value.Name == "Right Arm" then
                    for _, instance_4 in customization_dummy:GetChildren() do
                        if instance_4:HasTag("HandR") then
                            instance_4:Destroy()
                        end
                    end
                end
                local clone_4 =
                    game.ReplicatedStorage.Cosmetics:FindFirstChild(child_name_2):FindFirstChild(clone.Name):Clone()
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
                for _, item_2 in values_2 do
                    if item_2.Priority ~= Enum.AnimationPriority.Idle then
                        item_2:Stop()
                    end
                end
                if not (string.find(value.Name, "Arm")) then
                    local is_name = ((value.Name ~= "Left Leg") and "RightFoot") or "LeftFoot"
                    if values_2[is_name] then
                        local is_name_2 = ((value.Name ~= "Left Leg") and "RightFoot") or "LeftFoot"
                        values_2[is_name_2]:Play()
                    end
                end
                local match_index = string.find(value.Name, "Leg")
                if not match_index then
                    local is_name_3 = ((value.Name ~= "Left Arm") and "RightHand") or "LeftHand"
                    if values_2[is_name_3] then
                        local is_name_4 = ((value.Name ~= "Left Arm") and "RightHand") or "LeftHand"
                        values_2[is_name_4]:Play()
                    end
                end
                values_5[child_name_2](clone_4, value)
            end)
            local connection_5 = connection_2
            clone.Destroying:Once(function()
                connection_5:Disconnect()
            end)
        end
    elseif child_name == "JerseyType" then
        for _, value_3 in { "Shirt", "Undershirt", "LongSleeve", "Tracksuit" } do
            local clone_2 = parent.Folder.Template:Clone()
            clone_2.Parent = parent
            clone_2.Visible = true
            clone_2.Text = value_3
            clone_2.Name = value_3
            local connection_3 = clone_2.MouseButton1Click:Connect(function()
                text_2 = "Jersey"
                name = value_3
                previewTeam(randomthingFromParent(game.ReplicatedStorage.Cosmetics.Jerseys).Name, value_3)
            end)
            local connection_6 = connection_3
            clone_2.Destroying:Once(function()
                connection_6:Disconnect()
            end)
        end
    else
        for _, value_4 in game.ReplicatedStorage:FindFirstChild(child_name):GetChildren() do
            local clone_3 = parent.Folder.Template:Clone()
            clone_3.Parent = parent
            clone_3.Visible = true
            clone_3.Text = value_4.Name
            clone_3.Name = value_4.Name
            local connection_4 = clone_3.MouseButton1Click:Connect(function()
                if child_name == "AnimFolder" then
                    text_2 = "None"
                    name = value_4.Name
                    text_2 = "AnimLoop"
                elseif child_name == "MVPEyes" then
                    text_2 = "None"
                    name = value_4.Name
                    doMVPEye(9999, value_4.Name)
                elseif child_name == "Auras" then
                    text_2 = "None"
                    name = value_4.Name
                    doAura(9999, value_4.Name)
                end
            end)
            local connection_7 = connection_4
            clone_3.Destroying:Once(function()
                connection_7:Disconnect()
            end)
        end
    end
end

local connection = nil
local value_2 = nil

local function cam_look_at(argument, field_of_view)
    if argument == nil then
        if not connection then
            return
        end
        local tween_properties = { FieldOfView = 70 }
        tween_service:Create(workspace.CurrentCamera, TweenInfo.new(0.5), tween_properties):Play()
        connection:Disconnect()
        connection = nil
        value_2 = nil
        local tween_info = TweenInfo.new(1)
        local tween_properties_2 = {}
        tween_properties_2.CFrame = workspace:WaitForChild("CameraPOS").CFrame
        game.TweenService:Create(workspace.CurrentCamera, tween_info, tween_properties_2):Play()
        return "noAnim"
    else
        if connection and value_2 == argument then
            connection:Disconnect()
            connection = nil
            local tween_properties_3 = { FieldOfView = 70 }
            tween_service:Create(workspace.CurrentCamera, TweenInfo.new(0.5), tween_properties_3):Play()
            local tween_info_2 = TweenInfo.new(1)
            local tween_properties_4 = {}
            tween_properties_4.CFrame = workspace:WaitForChild("CameraPOS").CFrame
            game.TweenService:Create(workspace.CurrentCamera, tween_info_2, tween_properties_4):Play()
            value_2 = nil
            return "noAnim"
        end
        if connection then
            connection:Disconnect()
            connection = nil
        end
        value_2 = argument
        local tween_properties_5 = {}
        tween_properties_5.FieldOfView = field_of_view
        tween_service:Create(workspace.CurrentCamera, TweenInfo.new(0.5), tween_properties_5):Play()
        local connection_2 = game["Run Service"].RenderStepped:Connect(function()
            if not enabled then
                connection:Disconnect()
                connection = nil
            end
            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(
                CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, argument.Position),
                0.5
            )
        end)
        connection = connection_2
    end
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
    for _, value_3 in customization_dummy:QueryDescendants("ClickDetector") do
        print("Clicker Initted")
        if value_3.Parent.Name == "Right Arm" then
            value_3.Name = "RightHand"
            value_3:AddTag("Hands")
            value_3.MouseClick:Connect(function()
                print("CLICKED")
                value = value_3.Parent
                if cam_look_at(value_3.Parent, 50) ~= "noAnim" then
                    for _, item in values_2 do
                        if item.Priority ~= Enum.AnimationPriority.Idle then
                            item:Stop()
                        end
                    end
                    if values_2[value_3.Name] then
                        values_2[value_3.Name]:Play()
                    end
                else
                    value = nil
                end
            end)
            continue
        end
        if value_3.Parent.Name == "Left Arm" then
            value_3.Name = "LeftHand"
            value_3:AddTag("Hands")
            value_3.MouseClick:Connect(function()
                print("CLICKED")
                value = value_3.Parent
                if cam_look_at(value_3.Parent, 50) ~= "noAnim" then
                    for _, item in values_2 do
                        if item.Priority ~= Enum.AnimationPriority.Idle then
                            item:Stop()
                        end
                    end
                    if values_2[value_3.Name] then
                        values_2[value_3.Name]:Play()
                    end
                else
                    value = nil
                end
            end)
            continue
        end
        if value_3.Parent.Name == "Left Leg" then
            value_3.Name = "LeftFoot"
            value_3:AddTag("Cleats")
            value_3.MouseClick:Connect(function()
                print("CLICKED")
                value = value_3.Parent
                if cam_look_at(value_3.Parent, 50) ~= "noAnim" then
                    for _, item in values_2 do
                        if item.Priority ~= Enum.AnimationPriority.Idle then
                            item:Stop()
                        end
                    end
                    if values_2[value_3.Name] then
                        values_2[value_3.Name]:Play()
                    end
                else
                    value = nil
                end
            end)
            continue
        end
        if value_3.Parent.Name ~= "Right Leg" then
            value_3:AddTag(value_3.Parent.Name)
        else
            value_3.Name = "RightFoot"
            value_3:AddTag("Cleats")
        end
        value_3.MouseClick:Connect(function()
            print("CLICKED")
            value = value_3.Parent
            if cam_look_at(value_3.Parent, 50) ~= "noAnim" then
                for _, item in values_2 do
                    if item.Priority ~= Enum.AnimationPriority.Idle then
                        item:Stop()
                    end
                end
                if values_2[value_3.Name] then
                    values_2[value_3.Name]:Play()
                end
            else
                value = nil
            end
        end)
    end
end

function customization.init()
    local_player:WaitForChild("SelectedTeam").Changed:Connect(function()
        if local_player:FindFirstChild("SelectedTeam").Value == "N/A" then
            return
        end
        enabled = false
        player_gui.Menu.CustomizationFrame:SetAttribute("vis", false)
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
        local tween_info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties = {}
        tween_properties.Position = UDim2.new(0, 0, 0.5, 0)
        tween_service:Create(customization_frame.ItemsFrame, tween_info, tween_properties):Play()
        local tween_info_2 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_2 = {}
        tween_properties_2.Position = UDim2.new(1, 0, 1, 0)
        tween_service:Create(customization_frame.SelectFrame, tween_info_2, tween_properties_2):Play()
        local tween_info_3 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_3 = {}
        tween_properties_3.Position = UDim2.new(0.5, 0, 0.95, 0)
        tween_service:Create(customization_frame.CancelButton, tween_info_3, tween_properties_3):Play()
        local tween_info_4 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_4 = {}
        tween_properties_4.Position = UDim2.new(0.5, 0, 1.5, 0)
        tween_service:Create(player_gui.Menu.ClubFrame, tween_info_4, tween_properties_4):Play()
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
        local tween_info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties = {}
        tween_properties.Position = UDim2.new(0, -350, 0.5, 0)
        tween_service:Create(customization_frame.ItemsFrame, tween_info, tween_properties):Play()
        local tween_info_2 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_2 = {}
        tween_properties_2.Position = UDim2.new(1, 800, 1, 0)
        tween_service:Create(customization_frame.SelectFrame, tween_info_2, tween_properties_2):Play()
        local tween_info_3 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_3 = {}
        tween_properties_3.Position = UDim2.new(0.5, 0, 0.95, 200)
        tween_service:Create(customization_frame.CancelButton, tween_info_3, tween_properties_3):Play()
        local tween_info_4 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween_properties_4 = {}
        tween_properties_4.Position = UDim2.new(0.5, 0, 1, 150)
        tween_service:Create(equip_frame, tween_info_4, tween_properties_4):Play()
        menu_buttons.Visible = true
        play_button.Visible = true
    end)
end

return customization
