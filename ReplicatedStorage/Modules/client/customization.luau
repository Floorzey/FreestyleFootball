--[[
    Script Path: Game/ReplicatedStorage/Modules/client/customization
    Class: ModuleScript
    Time: 2026-10-03 12:27:09
--]]

local tbl_1 = {}
repeat
    task.wait()
until game:IsLoaded()
local LocalPlayer_upv_1 = game.Players.LocalPlayer
local PlayerGui_upv_1 = LocalPlayer_upv_1.PlayerGui
local CustomizationDummy_upv_1 = workspace:FindFirstChild("CustomizationDummy")
local CustomizationFrame_upv_1 = PlayerGui_upv_1.Menu.CustomizationFrame
local ItemsFrame_1 = CustomizationFrame_upv_1.ItemsFrame
local EquipFrame_upv_1 = CustomizationFrame_upv_1.EquipFrame
local Knit_1 = require(game:GetService("ReplicatedStorage").Packages.Knit)
Knit_1.OnStart():await()
local v1 = Knit_1.GetService("KeyHandlerService")
local _ = v1:GetKey("customize")
local u1 = v1:GetKey("BuyCheck")
local tbl_upv_2 = {}
tbl_upv_2.Aura = ItemsFrame_1:WaitForChild("AurasFrame")
tbl_upv_2.AnimationPack = ItemsFrame_1:WaitForChild("AnimationFrame")
tbl_upv_2.Eyes = ItemsFrame_1:WaitForChild("EyesFrame")
tbl_upv_2.Glove = ItemsFrame_1:WaitForChild("GoalieGlovesFrame")
tbl_upv_2.GoalCeleb = ItemsFrame_1:WaitForChild("GoalCelebFrame")
tbl_upv_2.WinCeleb = ItemsFrame_1:WaitForChild("WinCelebFrame")
local TweenService_upv_1 = game:GetService("TweenService")
local v2 = require("@game/ReplicatedStorage/Modules/ColorPicker")
local u2 = "None"
local Name_upv_1 = "None"
local u3 = nil
local u4 = ""
local tbl_upv_3 = {}
local tbl_upv_4 = {}
tbl_upv_4.Common = Color3.new(1, 1, 1)
tbl_upv_4.Rare = Color3.new(0.262745, 0.462745, 0.792157)
tbl_upv_4.Epic = Color3.new(0.792157, 0, 0.862745)
tbl_upv_4.Legendary = Color3.new(1, 0, 0)
tbl_upv_4.Exclusive = Color3.new(1, 0.968627, 0)
local ItemsFrame_upv_2 = PlayerGui_upv_1:WaitForChild("Menu"):WaitForChild("CustomizationFrame").ItemsFrame
local ItemInfo_upv_1 = game.ReplicatedStorage:WaitForChild("ItemInfo")
local tbl_upv_5 = {}
tbl_upv_5.Argentina = Vector3.new(0.5882350206375122, 0.7725489735603333, 0.8862749934196472)
tbl_upv_5.Brazil = Vector3.new(0.21899999678134918, 0.6700000166893005, 0.5450000166893005)
tbl_upv_5.Flamengo = Vector3.new(0.050980400294065475, 0.050980400294065475, 0.050980400294065475)
tbl_upv_5.AstonVilla = Vector3.new(0.5333330035209656, 0.6862750053405762, 0.8274509906768799)
tbl_upv_5.Barcelona = Vector3.new(0.6499999761581421, 0.13699999451637268, 0.19200000166893005)
tbl_upv_5.Dortmund = Vector3.new(0.20000000298023224, 0.20000000298023224, 0.20000000298023224)
tbl_upv_5.Japan = Vector3.new(0.8389999866485596, 0.15600000321865082, 0.125)
tbl_upv_5.InterMiami = Vector3.new(0.10000000149011612, 0.10000000149011612, 0.10000000149011612)
tbl_upv_5.ManchesterU = Vector3.new(0.47200000286102295, 0.07999999821186066, 0.125)
tbl_upv_5.Munich = Vector3.new(0.0430000014603138, 0.164000004529953, 0.36399999260902405)
tbl_upv_5.ParisSaints = Vector3.new(0.0860000029206276, 0.11299999803304672, 0.257999986410141)
tbl_upv_5.Italy = Vector3.new(0.12941177189350128, 0.2862745225429535, 0.6823529601097107)
tbl_upv_5.Croatia = Vector3.new(0.11299999803304672, 0.2070000022649765, 0.3799999952316284)
tbl_upv_5.Morocco = Vector3.new(0.12099999934434891, 0.37599998712539673, 0.28999999165534973)
tbl_upv_5.Canada = Vector3.new(0.9150000214576721, 0.10000000149011612, 0.10000000149011612)
tbl_upv_5.Portugal = Vector3.new(0.6230000257492065, 0.125, 0.15600000321865082)
tbl_upv_5.Mexico = Vector3.new(0.0430000014603138, 0.4779999852180481, 0.31299999356269836)
tbl_upv_5.Netherlands = Vector3.new(0.9129999876022339, 0.44999998807907104, 0.07400000095367432)
tbl_upv_5.RealMadrid = Vector3.new(1, 1, 1)
tbl_upv_5.LiverpoolFC = Vector3.new(0.1294119954109192, 0.1294119954109192, 0.1294119954109192)
tbl_upv_5.SeattleSoundersFC = Vector3.new(0.3409999907016754, 0.5600000023841858, 0.23100000619888306)
tbl_upv_5.JuventusFC = Vector3.new(0.11999999731779099, 0.11999999731779099, 0.11999999731779099)
tbl_upv_5.Newcastle = Vector3.new(1, 1, 1)
tbl_upv_5.ManchesterCity = Vector3.new(0.5333333611488342, 0.7137255072593689, 0.8784313797950745)
tbl_upv_5.Germany = Vector3.new(0.9900000095367432, 0.9900000095367432, 0.9900000095367432)
tbl_upv_5.England = Vector3.new(0.003921568859368563, 0.16862745583057404, 0.7372549176216125)
tbl_upv_5.Arsenal = Vector3.new(1, 1, 1)
tbl_upv_5.InterMilan = Vector3.new(0.10980392247438431, 0.29411765933036804, 0.5411764979362488)
tbl_upv_5.USA = Vector3.new(0.0784313753247261, 0.06666667014360428, 0.6392157077789307)
tbl_upv_5.Chelsea = Vector3.new(0.20000000298023224, 0.20000000298023224, 0.6666666865348816)
tbl_upv_5.Napoli = Vector3.new(1, 1, 1)
tbl_upv_5.France = Vector3.new(0.029999999329447746, 0.029999999329447746, 0.029999999329447746)
tbl_upv_5.Uruguay = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
tbl_upv_5.Roma = Vector3.new(0.45490196347236633, 0.07450980693101883, 0.11764705926179886)
tbl_upv_5.Lazio = Vector3.new(0.9800000190734863, 0.9800000190734863, 0.9800000190734863)
tbl_upv_5.SouthKorea = Vector3.new(0.9900000095367432, 0.9900000095367432, 0.9900000095367432)
tbl_upv_5.VascoDaGama = Vector3.new(0.9599999785423279, 0.9599999785423279, 0.9599999785423279)
tbl_upv_5.Ajax = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
tbl_upv_5.Atletico = Vector3.new(0.7568627595901489, 0, 0.0313725508749485)
tbl_upv_5.Leverkusen = Vector3.new(0.05000000074505806, 0.05000000074505806, 0.05000000074505806)
tbl_upv_5.Wales = Vector3.new(0.18431372940540314, 0.1882352977991104, 0.2235294133424759)
tbl_upv_5.Fiorentina = Vector3.new(0.27843138575553894, 0.12156862765550613, 0.40392157435417175)
tbl_upv_5.Spurs = Vector3.new(0.9900000095367432, 0.9900000095367432, 0.9900000095367432)
tbl_upv_5.ACMilan = Vector3.new(0.03999999910593033, 0.03999999910593033, 0.03999999910593033)
tbl_upv_5.Belgium = Vector3.new(0.6078431606292725, 0.10196078568696976, 0.16470588743686676)
tbl_upv_5.Spain = Vector3.new(0.5137255191802979, 0, 0)
tbl_upv_5.Scotland = Vector3.new(0.14901961386203766, 0.2549019753932953, 0.4901960790157318)
tbl_upv_5.Poland = Vector3.new(1, 0.0784313976764679, 0.09411759674549103)
tbl_upv_5.Sweden = Vector3.new(0.10588199645280838, 0.18039199709892273, 0.3882350027561188)
tbl_upv_5.Bosnia = Vector3.new(0.03921569883823395, 0.10980399698019028, 0.3882350027561188)
tbl_upv_5.Denmark = Vector3.new(0.6000000238418579, 0.10980399698019028, 0.1254899948835373)
tbl_upv_5.Romania = Vector3.new(0.9686269760131836, 0.8156859874725342, 0.1254899948835373)
tbl_upv_5.Switzerland = Vector3.new(0.49411800503730774, 0.08627449721097946, 0.1254899948835373)
function animationPreview(a1, a2)
    --[[
      name: animationPreview
      line: 196
      upvalues:
        CustomizationDummy_upv_1 (copy, index: 1)
    ]]
    for _, value_1 in CustomizationDummy_upv_1.Humanoid.Animator:GetPlayingAnimationTracks() do
        if value_1.Priority ~= Enum.AnimationPriority.Idle then
            value_1:Stop()
        end
    end
    local v2 = game.ReplicatedStorage.AnimFolder:FindFirstChild(a1):FindFirstChild(a2)
    if v2.Name == "Idle" or not v2 then
        return
    end
    CustomizationDummy_upv_1.Humanoid.Animator:LoadAnimation(v2):Play()
end
function randomthingFromParent(a1)
    --[[
      name: randomthingFromParent
      line: 218
    ]]
    local v3 = a1:GetChildren()
    return v3[math.random(1, #v3)]
end
local function showCategory(a1)
    --[[
      name: showCategory
      line: 225
      upvalues:
        ItemsFrame_upv_2 (copy, index: 1)
        tbl_upv_2 (copy, index: 2)
    ]]
    for _, value_2 in ipairs(ItemsFrame_upv_2:GetChildren()) do
        if value_2:IsA("ScrollingFrame") or value_2:IsA("Frame") then
            value_2.Visible = false
        end
    end
    local v4 = tbl_upv_2[a1]
    if not v4 then
        return
    end
    v4.Visible = true
end
function previewTeam(a1, a2)
    --[[
      name: previewTeam
      line: 239
      upvalues:
        CustomizationDummy_upv_1 (copy, index: 1)
        tbl_upv_5 (copy, index: 2)
    ]]
    for _, value_3 in CustomizationDummy_upv_1:GetChildren() do
        if value_3:HasTag("Clothing") then
            value_3:Destroy()
        end
    end
    local v5 = game.ReplicatedStorage.Cosmetics.Jerseys:FindFirstChild(a1)
    if not v5 then
        return
    end
    for _, value_4 in CustomizationDummy_upv_1:GetChildren() do
        if value_4:IsA("Shirt") then
            value_4:Destroy()
        end
        if value_4:IsA("Pants") then
            value_4:Destroy()
        end
    end
    if not v5:FindFirstChild(a2) then
        return
    end
    local v6 = v5:FindFirstChild(a2):Clone()
    local v7 = v5:FindFirstChild("Pants"):Clone()
    print(a1)
    if a2 == "Tracksuit" then
        local v8 = game.ReplicatedStorage.Cosmetics.Torso.TracksuitNeck:Clone()
        v8.Parent = CustomizationDummy_upv_1
        v8.TorsoWeld.Part0 = CustomizationDummy_upv_1.Torso
        v8.SpecialMesh.VertexColor = tbl_upv_5[a1]
        v8:AddTag("Clothing")
    end
    v6.Parent = CustomizationDummy_upv_1
    v7.Parent = CustomizationDummy_upv_1
    v6:AddTag("Clothing")
    v7:AddTag("Clothing")
end
local function tweenBeamTransparency(a1, a2, a3, a4)
    --[[
      name: tweenBeamTransparency
      line: 168
      upvalues:
        TweenService_upv_1 (copy, index: 1)
    ]]
    local u5 = Instance.new("NumberValue")
    u5.Value = ((a4 ~= true) and 0) or 1
    local tbl_upv_6 = {}
    for n_1 = 1, #a2.Keypoints do
        table.insert(tbl_upv_6, n_1, a2.Keypoints[n_1])
    end
    u5.Changed:Connect(
        function(a5)
            --[[
              line: 176
              upvalues:
                tbl_upv_6 (copy, index: 1)
                a4 (copy, index: 2)
                a1 (copy, index: 3)
            ]]
            local tbl_7 = {}
            local v9 = nil
            for key_1, value_5 in ipairs(tbl_upv_6) do
                v9 = ((a4 == true) and (value_5.Value + a5)) or (value_5.Value * a5)
                if value_5.Value == 1 then
                    v9 = 1
                end
                table.insert(tbl_7, key_1, NumberSequenceKeypoint.new(value_5.Time, v9))
            end
            a1.Transparency = NumberSequence.new(tbl_7)
        end
    )
    local tbl_8 = {Value = 0}
    tbl_8.Value = ((a4 ~= true) and 1) or 0
    local v10 = TweenService_upv_1:Create(u5, a3, tbl_8)
    v10.Completed:Once(
        function()
            --[[
              line: 189
              upvalues:
                u5 (copy, index: 1)
            ]]
            u5:Destroy()
        end
    )
    v10:Play()
end
function doAura(a1, a2)
    --[[
      name: doAura
      line: 288
      upvalues:
        CustomizationDummy_upv_1 (copy, index: 1)
        tweenBeamTransparency (copy, index: 2)
    ]]
    task.spawn(
        function()
            --[[
              line: 289
              upvalues:
                a2 (copy, index: 1)
                CustomizationDummy_upv_1 (copy, index: 2)
                a1 (copy, index: 3)
                tweenBeamTransparency (copy, index: 4)
            ]]
            local v11 = game.ReplicatedStorage.Cosmetics.Auras:FindFirstChild(a2)
            for _, value_6 in CustomizationDummy_upv_1:GetDescendants() do
                if value_6:HasTag("MVPEyes") then
                    value_6:Destroy()
                end
            end
            for _, value_7 in CustomizationDummy_upv_1:GetDescendants() do
                if value_7:HasTag("Aura") then
                    value_7:Destroy()
                end
            end
            if not v11 then
                return
            end
            for _, value_8 in pairs(v11:GetDescendants()) do
                if value_8:IsA("Part") then
                    value_8:AddTag("Aura")
                    continue
                end
                if value_8:IsA("ParticleEmitter") then
                    value_8:AddTag("Aura")
                    if value_8:GetAttribute("colorable") then
                        continue
                    else
                        continue
                    end
                elseif value_8:IsA("Beam") or value_8:IsA("Trail") then
                    value_8:AddTag("Aura")
                end
            end
            local u6 = nil
            local v12 = nil
            local u7 = nil
            local v13 = nil
            local u8 = nil
            local v14 = nil
            local u9 = nil
            local u10 = nil
            local u11 = nil
            local v15 = nil
            local v16 = nil
            local v17 = nil
            for _, value_9 in pairs(v11:GetChildren()) do
                if value_9.Name == "Torso" then
                    local v18 = value_9:Clone()
                    v18.Name = "Aura"
                    v18.Parent = CustomizationDummy_upv_1.Torso
                end
                if value_9.Name == "Left Arm" then
                    local v19 = value_9:Clone()
                    v19.Name = "Aura"
                    v19.Parent = CustomizationDummy_upv_1["Left Arm"]
                end
                if value_9.Name == "Left Leg" then
                    local v20 = value_9:Clone()
                    v20.Name = "Aura"
                    v20.Parent = CustomizationDummy_upv_1["Left Leg"]
                end
                if value_9.Name == "Right Leg" then
                    local v21 = value_9:Clone()
                    v21.Name = "Aura"
                    v21.Parent = CustomizationDummy_upv_1["Right Leg"]
                end
                if value_9.Name == "Right Arm" then
                    local v22 = value_9:Clone()
                    v22.Name = "Aura"
                    v22.Parent = CustomizationDummy_upv_1["Right Arm"]
                end
                if value_9.Name == "Head" then
                    local v23 = value_9:Clone()
                    v23.Name = "Aura"
                    v23.Parent = CustomizationDummy_upv_1.Head
                end
                for v28, value_10 in ipairs(value_9:GetDescendants()) do
                    if value_10:IsA("Light") or value_10:IsA("Script") then
                        value_10:Destroy()
                    end
                end
                if value_9.Name ~= "AttachmentHolder" then
                    continue
                end
                for v29, value_11 in pairs(value_9:GetChildren()) do
                    if value_11.Name == "HRP" then
                        v16 = value_11:Clone()
                        v16.Name = "Aura"
                        v16.Parent = CustomizationDummy_upv_1.HumanoidRootPart
                        if v16:IsA("Part") and v16:FindFirstChildOfClass("Weld") then
                            v16:FindFirstChildOfClass("Weld").Part0 = CustomizationDummy_upv_1.HumanoidRootPart
                            game.Debris:AddItem(v16, a1)
                        end
                        if v11.Name == "Flaming Wings" then
                            for v30, value_12 in ipairs(v16:GetDescendants()) do
                                if value_12:IsA("ParticleEmitter") then
                                    value_12.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.95), NumberSequenceKeypoint.new(1, 1)})
                                    value_12.Rate = value_12.Rate / 2
                                end
                            end
                        elseif v11.Name == "Blue Death" or v11.Name == "Determination" then
                            for v31, value_13 in ipairs(v16:GetDescendants()) do
                                if value_13:IsA("ParticleEmitter") then
                                    value_13.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.25, 0.95), NumberSequenceKeypoint.new(1, 1)})
                                    value_13.Rate = value_13.Rate / 2
                                end
                            end
                        elseif v11.Name == "A Certain Gambler" then
                            for v32, value_14 in ipairs(v16:GetDescendants()) do
                                if value_14:IsA("ParticleEmitter") then
                                    value_14.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.259, 1), NumberSequenceKeypoint.new(0.26, 0.7), NumberSequenceKeypoint.new(0.76, 0.7), NumberSequenceKeypoint.new(1, 1)})
                                    value_14.Rate = value_14.Rate / 2
                                end
                            end
                        elseif v11.Name == "Sakura" then
                            for v33, value_15 in ipairs(v16:GetDescendants()) do
                                if value_15:IsA("ParticleEmitter") then
                                    value_15.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.1), NumberSequenceKeypoint.new(0.85, 0.1), NumberSequenceKeypoint.new(1, 1)})
                                    value_15.Rate = value_15.Rate / 2
                                end
                            end
                        end
                        v17 = v16:FindFirstChildOfClass("Beam")
                        if not (v17) then
                            continue
                        end
                        if v11.Name ~= "Calculated Destruction" then
                            v17.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0.8)})
                        else
                            v17.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 0.3)})
                        end
                    elseif value_11.Name == "Head" then
                        u11 = value_11:Clone()
                        u11.Name = "Aura"
                        u11.Parent = CustomizationDummy_upv_1.Head
                        if u11:IsA("Part") then
                            game.Debris:AddItem(u11, a1)
                            local v24 = u11:FindFirstChildOfClass("Weld") or (u11:FindFirstChildOfClass("Motor6D"))
                            if v24 then
                                v24.Part0 = CustomizationDummy_upv_1.Head
                            end
                        end
                        if u11:GetAttribute("disband") then
                            task.spawn(
                                function()
                                    --[[
                                      line: 449
                                      upvalues:
                                        u11 (copy, index: 1)
                                        CustomizationDummy_upv_1 (copy, index: 2)
                                    ]]
                                    for _, value_upv_16 in pairs(u11:GetChildren()) do
                                        if value_upv_16:IsA("Attachment") then
                                            task.spawn(
                                                function()
                                                    --[[
                                                      line: 454
                                                      upvalues:
                                                        value_upv_16 (copy, index: 1)
                                                    ]]
                                                    for _, value_17 in pairs(value_upv_16:GetChildren()) do
                                                        value_17.Name = "Aura"
                                                    end
                                                end
                                            )
                                        else
                                            value_upv_16.Name = "Aura"
                                        end
                                        value_upv_16.Parent = CustomizationDummy_upv_1.Head
                                    end
                                    u11:Destroy()
                                end
                            )
                        end
                        v15 = u11:FindFirstChildOfClass("Beam")
                        if not (v15) then
                            continue
                        end
                        if v11.Name ~= "Monster" then
                            v15.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0.8)})
                        end
                    elseif value_11.Name == "Torso" then
                        u10 = value_11:Clone()
                        u10.Name = "Aura"
                        u10.Parent = CustomizationDummy_upv_1.Torso
                        if u10:FindFirstChildOfClass("Weld") then
                            game.Debris:AddItem(u10, a1)
                            u10:FindFirstChildOfClass("Weld").Part0 = CustomizationDummy_upv_1.Torso
                        end
                        if u10:GetAttribute("disband") then
                            task.spawn(
                                function()
                                    --[[
                                      line: 481
                                      upvalues:
                                        u10 (copy, index: 1)
                                        CustomizationDummy_upv_1 (copy, index: 2)
                                    ]]
                                    for _, value_upv_18 in pairs(u10:GetChildren()) do
                                        if value_upv_18:IsA("Attachment") then
                                            task.spawn(
                                                function()
                                                    --[[
                                                      line: 486
                                                      upvalues:
                                                        value_upv_18 (copy, index: 1)
                                                    ]]
                                                    for _, value_19 in pairs(value_upv_18:GetChildren()) do
                                                        value_19.Name = "Aura"
                                                    end
                                                end
                                            )
                                        else
                                            value_upv_18.Name = "Aura"
                                        end
                                        value_upv_18.Parent = CustomizationDummy_upv_1.Torso
                                    end
                                    u10:Destroy()
                                end
                            )
                        end
                        local v25 = u10:FindFirstChildOfClass("Beam")
                        if v11.Name == "Flaming Wings" then
                            for v34, value_20 in ipairs(u10:GetDescendants()) do
                                if value_20:IsA("ParticleEmitter") then
                                    value_20.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.95), NumberSequenceKeypoint.new(1, 1)})
                                    value_20.Rate = value_20.Rate / 2
                                end
                            end
                        elseif v11.Name == "Godly" then
                            for v35, value_21 in ipairs(u10:GetDescendants()) do
                                if value_21:IsA("ParticleEmitter") then
                                    value_21.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.9), NumberSequenceKeypoint.new(1, 1)})
                                    value_21.Rate = value_21.Rate / 3
                                end
                            end
                        elseif v11.Name == "Death" then
                            for v36, value_22 in ipairs(u10:GetDescendants()) do
                                if value_22:IsA("ParticleEmitter") then
                                    value_22.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.8), NumberSequenceKeypoint.new(1, 1)})
                                    value_22.Rate = value_22.Rate / 2
                                end
                            end
                        end
                        if v25 then
                            v25.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0.8)})
                        end
                    elseif value_11.Name == "Left Arm" then
                        u9 = value_11:Clone()
                        u9.Name = "Aura"
                        u9.Parent = CustomizationDummy_upv_1["Left Arm"]
                        if u9:FindFirstChildOfClass("Weld") then
                            game.Debris:AddItem(u9, a1)
                            u9:FindFirstChildOfClass("Weld").Part0 = CustomizationDummy_upv_1["Left Arm"]
                        end
                        if u9:GetAttribute("disband") then
                            task.spawn(
                                function()
                                    --[[
                                      line: 548
                                      upvalues:
                                        u9 (copy, index: 1)
                                        CustomizationDummy_upv_1 (copy, index: 2)
                                    ]]
                                    for _, value_23 in pairs(u9:GetChildren()) do
                                        value_23.Name = "Aura"
                                        value_23.Parent = CustomizationDummy_upv_1["Left Arm"]
                                    end
                                    u9:Destroy()
                                end
                            )
                        end
                        local v26 = u9:FindFirstChildOfClass("Beam")
                        if v11.Name == "Blue Rose" then
                            for v37, value_24 in ipairs(u9:GetDescendants()) do
                                if value_24:IsA("ParticleEmitter") then
                                    value_24.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.95), NumberSequenceKeypoint.new(1, 1)})
                                    value_24.Rate = value_24.Rate / 2
                                end
                            end
                        end
                        if v26 then
                            v26.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0.8)})
                        end
                    elseif value_11.Name == "Left Leg" then
                        u8 = value_11:Clone()
                        u8.Name = "Aura"
                        u8.Parent = CustomizationDummy_upv_1["Left Leg"]
                        if u8:FindFirstChildOfClass("Weld") then
                            game.Debris:AddItem(u8, a1)
                            u8:FindFirstChildOfClass("Weld").Part0 = CustomizationDummy_upv_1["Left Leg"]
                        end
                        if u8:GetAttribute("disband") then
                            task.spawn(
                                function()
                                    --[[
                                      line: 585
                                      upvalues:
                                        u8 (copy, index: 1)
                                        CustomizationDummy_upv_1 (copy, index: 2)
                                    ]]
                                    for _, value_upv_25 in pairs(u8:GetChildren()) do
                                        if value_upv_25:IsA("Attachment") then
                                            task.spawn(
                                                function()
                                                    --[[
                                                      line: 590
                                                      upvalues:
                                                        value_upv_25 (copy, index: 1)
                                                    ]]
                                                    for _, value_26 in pairs(value_upv_25:GetChildren()) do
                                                        value_26.Name = "Aura"
                                                    end
                                                end
                                            )
                                        else
                                            value_upv_25.Name = "Aura"
                                        end
                                        value_upv_25.Parent = CustomizationDummy_upv_1["Left Leg"]
                                    end
                                    u8:Destroy()
                                end
                            )
                        end
                        v14 = u8:FindFirstChildOfClass("Beam")
                        if not (v14) then
                            continue
                        end
                        if v11.Name ~= "Monster" then
                            v14.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0.8)})
                        end
                    elseif value_11.Name == "Right Leg" then
                        u7 = value_11:Clone()
                        u7.Name = "Aura"
                        u7.Parent = CustomizationDummy_upv_1["Right Leg"]
                        if u7:FindFirstChildOfClass("Weld") then
                            game.Debris:AddItem(u7, a1)
                            u7:FindFirstChildOfClass("Weld").Part0 = CustomizationDummy_upv_1["Right Leg"]
                        end
                        if u7:GetAttribute("disband") then
                            task.spawn(
                                function()
                                    --[[
                                      line: 617
                                      upvalues:
                                        u7 (copy, index: 1)
                                        CustomizationDummy_upv_1 (copy, index: 2)
                                    ]]
                                    for _, value_upv_27 in pairs(u7:GetChildren()) do
                                        if value_upv_27:IsA("Attachment") then
                                            task.spawn(
                                                function()
                                                    --[[
                                                      line: 622
                                                      upvalues:
                                                        value_upv_27 (copy, index: 1)
                                                    ]]
                                                    for _, value_28 in pairs(value_upv_27:GetChildren()) do
                                                        value_28.Name = "Aura"
                                                    end
                                                end
                                            )
                                        else
                                            value_upv_27.Name = "Aura"
                                        end
                                        value_upv_27.Parent = CustomizationDummy_upv_1["Right Leg"]
                                    end
                                    u7:Destroy()
                                end
                            )
                        end
                        v13 = u7:FindFirstChildOfClass("Beam")
                        if not (v13) then
                            continue
                        end
                        if v11.Name ~= "Monster" then
                            v13.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0.8)})
                        end
                    elseif value_11.Name == "Right Arm" then
                        u6 = value_11:Clone()
                        u6.Name = "Aura"
                        u6.Parent = CustomizationDummy_upv_1["Right Arm"]
                        if u6:FindFirstChildOfClass("Weld") then
                            game.Debris:AddItem(u6, a1)
                            u6:FindFirstChildOfClass("Weld").Part0 = CustomizationDummy_upv_1["Right Arm"]
                        end
                        if u6:GetAttribute("disband") then
                            task.spawn(
                                function()
                                    --[[
                                      line: 649
                                      upvalues:
                                        u6 (copy, index: 1)
                                        CustomizationDummy_upv_1 (copy, index: 2)
                                    ]]
                                    for _, value_upv_29 in pairs(u6:GetChildren()) do
                                        if value_upv_29:IsA("Attachment") then
                                            task.spawn(
                                                function()
                                                    --[[
                                                      line: 654
                                                      upvalues:
                                                        value_upv_29 (copy, index: 1)
                                                    ]]
                                                    for _, value_30 in pairs(value_upv_29:GetChildren()) do
                                                        value_30.Name = "Aura"
                                                    end
                                                end
                                            )
                                        else
                                            value_upv_29.Name = "Aura"
                                        end
                                        value_upv_29.Parent = CustomizationDummy_upv_1["Right Arm"]
                                    end
                                    u6:Destroy()
                                end
                            )
                        end
                        v12 = u6:FindFirstChildOfClass("Beam")
                        if not (v12) then
                            continue
                        end
                        if v11.Name ~= "Monster" then
                            v12.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0.8)})
                        end
                    end
                end
            end
            for _, value_31 in pairs(CustomizationDummy_upv_1:GetChildren()) do
                if value_31.Name == "Right Arm" or value_31.Name ~= "Right Arm" and value_31.Name == "Left Arm" or value_31.Name ~= "Right Arm" and value_31.Name ~= "Left Arm" and value_31.Name == "Left Leg" or value_31.Name ~= "Right Arm" and value_31.Name ~= "Left Arm" and value_31.Name ~= "Left Leg" and value_31.Name == "Right Leg" or value_31.Name ~= "Right Arm" and value_31.Name ~= "Left Arm" and value_31.Name ~= "Left Leg" and value_31.Name ~= "Right Leg" and value_31.Name == "Head"
                    or value_31.Name ~= "Right Arm" and value_31.Name ~= "Left Arm" and value_31.Name ~= "Left Leg" and value_31.Name ~= "Right Leg" and value_31.Name ~= "Head" and value_31.Name == "Torso" then
                    for v38, value_32 in pairs(v11:GetChildren()) do
                        if value_32:IsA("ParticleEmitter") and value_32.Name == "Aura" or value_32:IsA("Attachment") and value_32.Name ~= "Torso" then
                            local v27 = value_32:Clone()
                            v27.Name = "Aura"
                            v27.Parent = value_31
                        end
                    end
                end
            end
            task.delay(
                a1,
                function()
                    --[[
                      line: 690
                      upvalues:
                        CustomizationDummy_upv_1 (copy, index: 1)
                        tweenBeamTransparency (copy, index: 2)
                    ]]
                    for _, value_upv_33 in pairs(CustomizationDummy_upv_1:GetDescendants()) do
                        if value_upv_33.Name == "HasAura" then
                            value_upv_33:Destroy()
                        end
                        if value_upv_33.Name == "Orbit" then
                            value_upv_33:Destroy()
                        end
                        if value_upv_33.Name ~= "Aura" then
                            continue
                        end
                        if value_upv_33:IsA("ParticleEmitter") then
                            value_upv_33.Enabled = false
                            task.delay(
                                3,
                                function()
                                    --[[
                                      line: 701
                                      upvalues:
                                        value_upv_33 (copy, index: 1)
                                    ]]
                                    value_upv_33:Destroy()
                                end
                            )
                            continue
                        end
                        if value_upv_33:IsA("Script") then
                            value_upv_33:Destroy()
                            continue
                        end
                        if not (value_upv_33:IsA("Attachment")) then
                            continue
                        end
                        for v1, value_upv_34 in pairs(value_upv_33:GetDescendants()) do
                            if value_upv_34:IsA("ParticleEmitter") then
                                value_upv_34.Enabled = false
                                task.delay(
                                    3,
                                    function()
                                        --[[
                                          line: 710
                                          upvalues:
                                            value_upv_34 (copy, index: 1)
                                        ]]
                                        value_upv_34:Destroy()
                                    end
                                )
                                continue
                            end
                            if value_upv_34:IsA("Beam") then
                                task.spawn(
                                    function()
                                        --[[
                                          line: 714
                                          upvalues:
                                            tweenBeamTransparency (copy, index: 1)
                                            value_upv_34 (copy, index: 2)
                                        ]]
                                        tweenBeamTransparency(value_upv_34, NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 1)}), TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), false)
                                    end
                                )
                                continue
                            end
                            if value_upv_34:IsA("PointLight") then
                                local tbl_9 = {Range = 0, Brightness = 0}
                                game:GetService("TweenService"):Create(value_upv_34, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_9):Play()
                            end
                        end
                        game.Debris:AddItem(value_upv_33, 3)
                    end
                end
            )
        end
    )
end
local tbl_upv_10 = {Cleats = 0, Hands = 0}
function tbl_upv_10.Cleats(a1, a2)
    --[[
      name: Cleats
      line: 749
    ]]
    a1.Main.Main.Part0 = a2
end
function tbl_upv_10.Hands(a1, a2)
    --[[
      name: Hands
      line: 753
    ]]
    if a1 == nil or not a1:FindFirstChild("ArmWeld", true) then
        return
    end
    if a1.Name == "Glove" and a2.Name ~= "Left Arm" then
        a1:FindFirstChild("ArmWeldR", true).Part0 = a2
    else
        a1:FindFirstChild("ArmWeld", true).Part0 = a2
    end
end
local function converterString(a1)
    --[[
      name: converterString
      line: 776
    ]]
    return "Cleats"
end
local function search4Cosmetic(a1, a2)
    --[[
      name: search4Cosmetic
      line: 733
    ]]
    for _, value_35 in game.ReplicatedStorage.Cosmetics:GetChildren() do
        if value_35.Name ~= a1 or not (value_35:FindFirstChild(a2)) then
            continue
        end
        return (value_35:FindFirstChild(a2))
    end
    return nil
end
function loadCosmetics()
    --[[
      name: loadCosmetics
      line: 797
      upvalues:
        CustomizationDummy_upv_1 (copy, index: 1)
        LocalPlayer_upv_1 (copy, index: 2)
        search4Cosmetic (copy, index: 3)
        tbl_upv_10 (copy, index: 4)
    ]]
    local tbl_11 = {"LeftFoot", "RightFoot", "LeftHand", "RightHand", "Torso", "Head"}
    CustomizationDummy_upv_1:WaitForChild("Left Arm", 20)
    CustomizationDummy_upv_1:WaitForChild("Right Arm", 20)
    CustomizationDummy_upv_1:WaitForChild("Left Leg", 20)
    CustomizationDummy_upv_1:WaitForChild("Right Leg", 20)
    for _, value_36 in CustomizationDummy_upv_1:GetChildren() do
        if value_36:HasTag("Cosmetic") then
            value_36:Destroy()
        end
    end
    local v28 = nil
    for v33, value_37 in LocalPlayer_upv_1:WaitForChild("Data"):GetChildren() do
        local v29 = table.find(tbl_11, value_37.Name)
        if not (v29) then
            continue
        end
        local Hands_1 = "Cleats"
        local v30 = search4Cosmetic
        v29 = v30(Hands_1, value_37.Value)
        if not (v29) then
            continue
        end
        Hands_1 = "Cleats"
        local v31 = search4Cosmetic
        v31 = v31(Hands_1, value_37.Value):Clone()
        v31:AddTag("Cosmetic")
        v31.Parent = CustomizationDummy_upv_1
        if value_37.Name == "LeftFoot" or value_37.Name == "RightFoot" then
            if value_37.Name ~= "LeftFoot" then
                v31:AddTag("CleatR")
            else
                v31:AddTag("CleatL")
            end
            local Cleats_1 = tbl_upv_10.Cleats
            if value_37.Name ~= "LeftFoot" then
                v28 = CustomizationDummy_upv_1["Right Leg"]
            else
                v28 = CustomizationDummy_upv_1["Left Leg"]
            end
            Cleats_1(v31, v28)
        end
        if value_37.Name == "LeftHand" or value_37.Name == "RightHand" then
            Hands_1 = tbl_upv_10.Hands
            if value_37.Name ~= "LeftArm" then
                v28 = CustomizationDummy_upv_1["Right Arm"]
            else
                v28 = CustomizationDummy_upv_1["Left Arm"]
            end
            Hands_1(v31, v28)
        end
    end
end
function doMVPEye(a1, a2)
    --[[
      name: doMVPEye
      line: 857
      upvalues:
        CustomizationDummy_upv_1 (copy, index: 1)
        tweenBeamTransparency (copy, index: 2)
    ]]
    for _, value_38 in CustomizationDummy_upv_1:GetDescendants() do
        if value_38:HasTag("Aura") then
            value_38:Destroy()
        end
    end
    for _, value_39 in CustomizationDummy_upv_1:GetDescendants() do
        if value_39:HasTag("MVPEyes") then
            value_39:Destroy()
        end
    end
    local v32 = game.ReplicatedStorage.Cosmetics.MVPEyes:FindFirstChild(a2)
    if not v32 then
        return
    end
    local u12 = v32:Clone()
    u12.Parent = CustomizationDummy_upv_1
    u12:AddTag("MVPEyes")
    u12.Anchored = false
    local v33 = script.Weld:Clone()
    v33.Parent = u12
    v33.Part0 = CustomizationDummy_upv_1.Head
    v33.Part1 = u12
    task.delay(
        a1,
        function()
            --[[
              line: 887
              upvalues:
                u12 (copy, index: 1)
                tweenBeamTransparency (copy, index: 2)
            ]]
            for _, value_40 in u12:GetDescendants() do
                if value_40:IsA("ParticleEmitter") then
                    value_40.Enabled = false
                    continue
                end
                if value_40:IsA("Beam") then
                    tweenBeamTransparency(value_40, NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 1)}), TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), false)
                end
            end
            task.wait(3)
            u12:Destroy()
        end
    )
end
function showConfirmation(a1)
    --[[
      name: showConfirmation
      line: 900
      upvalues:
        CustomizationFrame_upv_1 (copy, index: 1)
        u1 (copy, index: 2)
    ]]
    CustomizationFrame_upv_1.PopupContainer.Visible = true
    CustomizationFrame_upv_1.PopupContainer.PurchaseText.Text = "WOULD YOU LIKE TO PURCHASE <" .. a1.Type.Text .. "> for " .. a1.Price.Text .. "?"
    local u13 = nil
    local u14 = nil
    local v34 = CustomizationFrame_upv_1.PopupContainer.YesButton.MouseButton1Click:Connect(
        function()
            --[[
              line: 904
              upvalues:
                u1 (copy, index: 1)
                a1 (copy, index: 2)
                u14 (ref,  index: 3)
                CustomizationFrame_upv_1 (copy, index: 4)
            ]]
            if u1:InvokeServer(a1.Name) ~= nil then
                if a1:FindFirstChild("Locked") then
                    a1.Locked.Visible = false
                    a1.LockedBG.Visible = false
                    if a1:FindFirstChild("Price") then
                        a1.Price.Visible = false
                    end
                    local v35 = game.ReplicatedStorage.UISounds.Item_Box_Get2:Clone()
                    v35.Parent = game.Workspace
                    v35:Play()
                    game.Debris:AddItem(v35, 2)
                end
                u14:Disconnect()
                CustomizationFrame_upv_1.PopupContainer.Visible = false
            else
                local v36 = game.ReplicatedStorage.UISounds["ui-error4"]:Clone()
                v36.Parent = game.Workspace
                v36:Play()
                game.Debris:AddItem(v36, 3)
                task.spawn(
                    function()
                        --[[
                          line: 911
                          upvalues:
                            a1 (copy, index: 1)
                        ]]
                        local tbl_12 = {Rotation = 45}
                        game:GetService("TweenService"):Create(a1.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_12):Play()
                        task.wait(0.1)
                        local tbl_13 = {Rotation = -45}
                        game:GetService("TweenService"):Create(a1.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_13):Play()
                        task.wait(0.1)
                        local tbl_14 = {Rotation = 0}
                        game:GetService("TweenService"):Create(a1.Locked, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl_14):Play()
                    end
                )
            end
        end
    )
    u14 = v34
    local v37 = CustomizationFrame_upv_1.PopupContainer.NoButton.MouseButton1Click:Connect(
        function()
            --[[
              line: 939
              upvalues:
                u14 (ref,  index: 1)
                u13 (ref,  index: 2)
                CustomizationFrame_upv_1 (copy, index: 3)
            ]]
            u14:Disconnect()
            u13:Disconnect()
            CustomizationFrame_upv_1.PopupContainer.Visible = false
        end
    )
    u13 = v37
end
function doSelection(a1)
    --[[
      name: doSelection
      line: 946
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        EquipFrame_upv_1 (copy, index: 2)
        u4 (ref,  index: 3)
    ]]
    if not (table.find(string.split(LocalPlayer_upv_1.Data.Inventory.Value), a1.Name)) and a1:FindFirstChild("Price") then
        local TweenService_2 = game:GetService("TweenService")
        local v38 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_15 = {}
        tbl_15.Position = UDim2.new(0.5, 0, 1, 150)
        TweenService_2:Create(EquipFrame_upv_1, v38, tbl_15):Play()
        showConfirmation(a1)
        return
    end
    if u4 ~= a1.Name then
        for _, value_41 in pairs(a1.Parent:GetChildren()) do
            if value_41 == a1 then
                continue
            end
            if value_41:IsA("ImageButton") then
                local TweenService_3 = game:GetService("TweenService")
                local v39 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tbl_16 = {Transparency = 0.25, Thickness = 2}
                tbl_16.Color = Color3.new(0.498039, 0.529412, 0.560784)
                TweenService_3:Create(value_41.UIStroke, v39, tbl_16):Play()
            end
        end
        u4 = a1.Name
        local TweenService_4 = game:GetService("TweenService")
        local v40 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_17 = {}
        tbl_17.Position = UDim2.new(0.5, 0, 1, -125)
        TweenService_4:Create(EquipFrame_upv_1, v40, tbl_17):Play()
        TweenService_4 = game:GetService("TweenService")
        local v41 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_18 = {Transparency = 0, Thickness = 3}
        tbl_18.Color = Color3.new(1, 1, 1)
        TweenService_4:Create(a1.UIStroke, v41, tbl_18):Play()
        EquipFrame_upv_1.EquipButton.Text = "EQUIP"
        for _, value_42 in pairs(LocalPlayer_upv_1.Data:GetChildren()) do
            if not (value_42:IsA("StringValue")) or value_42.Value ~= a1.Name then
                continue
            end
            EquipFrame_upv_1.EquipButton.Text = "EQUIPPED"
            return
        end
    else
        u4 = nil
        local TweenService_5 = game:GetService("TweenService")
        local v42 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_19 = {}
        tbl_19.Position = UDim2.new(0.5, 0, 1, 150)
        TweenService_5:Create(EquipFrame_upv_1, v42, tbl_19):Play()
        local TweenService_6 = game:GetService("TweenService")
        local v43 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tbl_20 = {Transparency = 0.25, Thickness = 2}
        tbl_20.Color = Color3.new(0.498039, 0.529412, 0.560784)
        TweenService_6:Create(a1.UIStroke, v43, tbl_20):Play()
    end
end
function runCustomizationSetup()
    --[[
      name: runCustomizationSetup
      line: 994
      upvalues:
        ItemsFrame_upv_2 (copy, index: 1)
        LocalPlayer_upv_1 (copy, index: 2)
        ItemInfo_upv_1 (copy, index: 3)
        tbl_upv_4 (copy, index: 4)
        tbl_upv_2 (copy, index: 5)
    ]]
    for _, value_43 in pairs(ItemsFrame_upv_2.AurasFrame:GetChildren()) do
        if value_43:IsA("ImageButton") then
            value_43:Destroy()
        end
    end
    for _, value_44 in pairs(ItemsFrame_upv_2.AnimationFrame:GetChildren()) do
        if value_44:IsA("ImageButton") then
            value_44:Destroy()
        end
    end
    for _, value_45 in pairs(ItemsFrame_upv_2.GoalieGlovesFrame:GetChildren()) do
        if value_45:IsA("ImageButton") then
            value_45:Destroy()
        end
    end
    for _, value_46 in pairs(ItemsFrame_upv_2.EyesFrame:GetChildren()) do
        if value_46:IsA("ImageButton") then
            value_46:Destroy()
        end
    end
    for _, value_47 in pairs(ItemsFrame_upv_2.GoalCelebFrame:GetChildren()) do
        if value_47:IsA("ImageButton") then
            value_47:Destroy()
        end
    end
    for _, value_48 in pairs(ItemsFrame_upv_2.WinCelebFrame:GetChildren()) do
        if value_48:IsA("ImageButton") then
            value_48:Destroy()
        end
    end
    local v44 = string.split(LocalPlayer_upv_1.Data.Inventory.Value)
    for _, value_49 in pairs(ItemsFrame_upv_2:GetDescendants()) do
        if not (value_49:IsA("ImageButton")) then
            continue
        end
        if table.find(v44, value_49.Name) then
            if not (value_49:FindFirstChild("Locked")) then
                continue
            end
            value_49.Locked.Visible = false
            value_49.LockedBG.Visible = false
            if value_49:FindFirstChild("Price") then
                value_49.Price.Visible = false
            end
        else
            value_49.Locked.Visible = true
            value_49.LockedBG.Visible = true
            if value_49:FindFirstChild("Price") then
                value_49.Price.Visible = true
            end
        end
    end
    for _, value_50 in pairs(v44) do
        local u15 = ItemInfo_upv_1:FindFirstChild(value_50)
        if not (u15) then
            continue
        end
        local u16 = script.itemTemplate:Clone()
        u16.Name = u15.Name
        u16.itemName.Text = string.upper(u15.Name)
        u16.itemName.TextColor3 = tbl_upv_4[u15.Rarity.Value]
        u16.Icon.Image = u15.itemIcon.Texture
        u16.MouseButton1Click:Connect(
            function()
                --[[
                  line: 1053
                  upvalues:
                    u15 (copy, index: 1)
                    u16 (copy, index: 2)
                ]]
                if u15.Type.Value == "Aura" then
                    doAura(999, u15.Name)
                elseif u15.Type.Value == "Eyes" then
                    doMVPEye(999, u15.Name)
                end
                doSelection(u16)
            end
        )
        local v45 = tbl_upv_2[u15.Type.Value]
        if v45 then
            u16.Parent = v45
        end
    end
end
local u17 = false
function camera()
    --[[
      name: camera
      line: 1076
      upvalues:
        u17 (ref,  index: 1)
        PlayerGui_upv_1 (copy, index: 2)
        Name_upv_1 (ref,  index: 3)
        LocalPlayer_upv_1 (copy, index: 4)
    ]]
    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    workspace.CurrentCamera.CameraSubject = nil
    workspace.CurrentCamera.CFrame = workspace:WaitForChild("CameraPOS").CFrame
    u17 = true
    while PlayerGui_upv_1.Menu.CustomizationFrame:GetAttribute("vis") do
        task.wait()
        workspace.CurrentCamera.CFrame = workspace:WaitForChild("CameraPOS").CFrame
        if Name_upv_1 ~= "None" then
            continue
        end
    end
    u17 = false
    workspace.CurrentCamera.CameraSubject = LocalPlayer_upv_1.Character:FindFirstChild("Neck_CameraSubject")
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
end
function newList(a1, a2, a3)
    --[[
      name: newList
      line: 1094
      upvalues:
        TweenService_upv_1 (copy, index: 1)
        PlayerGui_upv_1 (copy, index: 2)
        u3 (ref,  index: 3)
        CustomizationDummy_upv_1 (copy, index: 4)
        tbl_upv_3 (copy, index: 5)
        tbl_upv_10 (copy, index: 6)
        u2 (ref,  index: 7)
        Name_upv_1 (ref,  index: 8)
    ]]
    if not (a1.Visible) then
        if a1.Name ~= "ListContainer" then
            a1.Visible = true
            a1.Position = UDim2.new(-1, 0, 0.5, 0)
            local v46 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            local tbl_21 = {}
            tbl_21.Position = UDim2.new(0.12, 0, 0.5, 0)
            TweenService_upv_1:Create(a1, v46, tbl_21):Play()
            local v47 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            local tbl_22 = {}
            tbl_22.Position = UDim2.new(1.25, 0, 0.5, 0)
            TweenService_upv_1:Create(PlayerGui_upv_1.customization.container.ListContainer, v47, tbl_22):Play()
            task.wait(1)
            PlayerGui_upv_1.customization.container.ListContainer.Visible = false
        else
            a1.Visible = true
            a1.Position = UDim2.new(1.25, 0, 0.5, 0)
            local v48 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            local tbl_23 = {}
            tbl_23.Position = UDim2.new(0.871, 0, 0.5, 0)
            TweenService_upv_1:Create(a1, v48, tbl_23):Play()
            local v49 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            local tbl_24 = {}
            tbl_24.Position = UDim2.new(-1, 0, 0.5, 0)
            TweenService_upv_1:Create(PlayerGui_upv_1.customization.container.CosmeticContainer, v49, tbl_24):Play()
            task.wait(1)
            PlayerGui_upv_1.customization.container.CosmeticContainer.Visible = false
        end
    end
    if a2 == "Cosmetic" then
        print(a3)
        for _, value_51 in game.ReplicatedStorage.Cosmetics:FindFirstChild(a3):GetChildren() do
            local u18 = a1.Folder.Template:Clone()
            u18.Parent = a1
            u18.Visible = true
            u18.Text = value_51.Name
            u18.Name = value_51.Name
            local v50 = u18.MouseButton1Click:Connect(
                function()
                    --[[
                      line: 1128
                      upvalues:
                        u3 (ref,  index: 1)
                        CustomizationDummy_upv_1 (copy, index: 2)
                        a3 (copy, index: 3)
                        u18 (copy, index: 4)
                        tbl_upv_3 (copy, index: 5)
                        tbl_upv_10 (copy, index: 6)
                    ]]
                    if u3.Name == "Left Leg" then
                        for _, value_52 in CustomizationDummy_upv_1:GetChildren() do
                            if value_52:HasTag("CleatL") then
                                value_52:Destroy()
                            end
                        end
                    elseif u3.Name == "Right Leg" then
                        for _, value_53 in CustomizationDummy_upv_1:GetChildren() do
                            if value_53:HasTag("CleatR") then
                                value_53:Destroy()
                            end
                        end
                    elseif u3.Name == "Left Arm" then
                        for _, value_54 in CustomizationDummy_upv_1:GetChildren() do
                            if value_54:HasTag("HandL") then
                                value_54:Destroy()
                            end
                        end
                    elseif u3.Name == "Right Arm" then
                        for _, value_55 in CustomizationDummy_upv_1:GetChildren() do
                            if value_55:HasTag("HandR") then
                                value_55:Destroy()
                            end
                        end
                    end
                    local v51 = game.ReplicatedStorage.Cosmetics:FindFirstChild(a3):FindFirstChild(u18.Name):Clone()
                    v51.Parent = CustomizationDummy_upv_1
                    v51:AddTag("Cosmetic")
                    if u3.Name == "Left Leg" then
                        v51:AddTag("CleatL")
                    elseif u3.Name == "Right Leg" then
                        v51:AddTag("CleatR")
                    elseif u3.Name == "Left Arm" then
                        v51:AddTag("HandL")
                    elseif u3.Name == "Right Arm" then
                        v51:AddTag("HandR")
                    end
                    for _, value_56 in tbl_upv_3 do
                        if value_56.Priority ~= Enum.AnimationPriority.Idle then
                            value_56:Stop()
                        end
                    end
                    if not (string.find(u3.Name, "Arm")) then
                        local v52 = ((u3.Name ~= "Left Leg") and "RightFoot") or "LeftFoot"
                        if tbl_upv_3[v52] then
                            local v53 = ((u3.Name ~= "Left Leg") and "RightFoot") or "LeftFoot"
                            tbl_upv_3[v53]:Play()
                        end
                    end
                    local v54 = string.find(u3.Name, "Leg")
                    if not (v54) then
                        local v55 = ((u3.Name ~= "Left Arm") and "RightHand") or "LeftHand"
                        if tbl_upv_3[v55] then
                            local v56 = ((u3.Name ~= "Left Arm") and "RightHand") or "LeftHand"
                            tbl_upv_3[v56]:Play()
                        end
                    end
                    tbl_upv_10[a3](v51, u3)
                end
            )
            local u19 = v50
            u18.Destroying:Once(
                function()
                    --[[
                      line: 1192
                      upvalues:
                        u19 (ref, index: 1)
                    ]]
                    u19:Disconnect()
                end
            )
        end
    elseif a2 == "JerseyType" then
        for _, value_upv_57 in {"Shirt", "Undershirt", "LongSleeve", "Tracksuit"} do
            local v57 = a1.Folder.Template:Clone()
            v57.Parent = a1
            v57.Visible = true
            v57.Text = value_upv_57
            v57.Name = value_upv_57
            local v58 = v57.MouseButton1Click:Connect(
                function()
                    --[[
                      line: 1250
                      upvalues:
                        u2 (ref,  index: 1)
                        Name_upv_1 (ref,  index: 2)
                        value_upv_57 (copy, index: 3)
                    ]]
                    u2 = "Jersey"
                    Name_upv_1 = value_upv_57
                    previewTeam(randomthingFromParent(game.ReplicatedStorage.Cosmetics.Jerseys).Name, value_upv_57)
                end
            )
            local u20 = v58
            v57.Destroying:Once(
                function()
                    --[[
                      line: 1257
                      upvalues:
                        u20 (ref, index: 1)
                    ]]
                    u20:Disconnect()
                end
            )
        end
    else
        for _, value_upv_58 in game.ReplicatedStorage:FindFirstChild(a2):GetChildren() do
            local v59 = a1.Folder.Template:Clone()
            v59.Parent = a1
            v59.Visible = true
            v59.Text = value_upv_58.Name
            v59.Name = value_upv_58.Name
            local v60 = v59.MouseButton1Click:Connect(
                function()
                    --[[
                      line: 1209
                      upvalues:
                        a2 (copy, index: 1)
                        u2 (ref,  index: 2)
                        Name_upv_1 (ref,  index: 3)
                        value_upv_58 (copy, index: 4)
                    ]]
                    if a2 == "AnimFolder" then
                        u2 = "None"
                        Name_upv_1 = value_upv_58.Name
                        u2 = "AnimLoop"
                    elseif a2 == "MVPEyes" then
                        u2 = "None"
                        Name_upv_1 = value_upv_58.Name
                        doMVPEye(9999, value_upv_58.Name)
                    elseif a2 == "Auras" then
                        u2 = "None"
                        Name_upv_1 = value_upv_58.Name
                        doAura(9999, value_upv_58.Name)
                    end
                end
            )
            local u21 = v60
            v59.Destroying:Once(
                function()
                    --[[
                      line: 1225
                      upvalues:
                        u21 (ref, index: 1)
                    ]]
                    u21:Disconnect()
                end
            )
        end
    end
end
local u22 = nil
local u23 = nil
local function camLookAt(a1, a2)
    --[[
      name: camLookAt
      line: 1269
      upvalues:
        u22 (ref,  index: 1)
        u23 (ref,  index: 2)
        TweenService_upv_1 (copy, index: 3)
        u17 (ref,  index: 4)
    ]]
    if a1 == nil then
        if not u22 then
            return
        end
        local tbl_25 = {FieldOfView = 70}
        TweenService_upv_1:Create(workspace.CurrentCamera, TweenInfo.new(0.5), tbl_25):Play()
        u22:Disconnect()
        u22 = nil
        u23 = nil
        local v61 = TweenInfo.new(1)
        local tbl_26 = {}
        tbl_26.CFrame = workspace:WaitForChild("CameraPOS").CFrame
        game.TweenService:Create(workspace.CurrentCamera, v61, tbl_26):Play()
        return "noAnim"
    else
        if u22 and u23 == a1 then
            u22:Disconnect()
            u22 = nil
            local tbl_27 = {FieldOfView = 70}
            TweenService_upv_1:Create(workspace.CurrentCamera, TweenInfo.new(0.5), tbl_27):Play()
            local v62 = TweenInfo.new(1)
            local tbl_28 = {}
            tbl_28.CFrame = workspace:WaitForChild("CameraPOS").CFrame
            game.TweenService:Create(workspace.CurrentCamera, v62, tbl_28):Play()
            u23 = nil
            return "noAnim"
        end
        if u22 then
            u22:Disconnect()
            u22 = nil
        end
        u23 = a1
        local tbl_29 = {}
        tbl_29.FieldOfView = a2
        TweenService_upv_1:Create(workspace.CurrentCamera, TweenInfo.new(0.5), tbl_29):Play()
        local v63 = game["Run Service"].RenderStepped:Connect(
            function()
                --[[
                  line: 1287
                  upvalues:
                    u17 (ref,  index: 1)
                    u22 (ref,  index: 2)
                    a1 (copy, index: 3)
                ]]
                if not (u17) then
                    u22:Disconnect()
                    u22 = nil
                end
                workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, a1.Position), 0.5)
            end
        )
        u22 = v63
    end
end
local function initClickDetectors()
    --[[
      name: initClickDetectors
      line: 1309
      upvalues:
        tbl_upv_3 (copy, index: 1)
        CustomizationDummy_upv_1 (copy, index: 2)
        u3 (ref,  index: 3)
        camLookAt (copy, index: 4)
    ]]
    tbl_upv_3.Idle = CustomizationDummy_upv_1.Humanoid.Animator:LoadAnimation(script.InspectAnims.Idle)
    tbl_upv_3.LeftFoot = CustomizationDummy_upv_1.Humanoid.Animator:LoadAnimation(script.InspectAnims.Feet.Left)
    tbl_upv_3.RightFoot = CustomizationDummy_upv_1.Humanoid.Animator:LoadAnimation(script.InspectAnims.Feet.Right)
    tbl_upv_3.LeftHand = CustomizationDummy_upv_1.Humanoid.Animator:LoadAnimation(script.InspectAnims.Hand.Left)
    tbl_upv_3.RightHand = CustomizationDummy_upv_1.Humanoid.Animator:LoadAnimation(script.InspectAnims.Hand.Right)
    tbl_upv_3.Idle.Priority = Enum.AnimationPriority.Idle
    tbl_upv_3.Idle.Looped = true
    tbl_upv_3.Idle:Play()
    print("Attempted To Init??")
    task.wait(2)
    for _, value_upv_59 in CustomizationDummy_upv_1:QueryDescendants("ClickDetector") do
        print("Clicker Initted")
        if value_upv_59.Parent.Name == "Right Arm" then
            value_upv_59.Name = "RightHand"
            value_upv_59:AddTag("Hands")
            value_upv_59.MouseClick:Connect(
                function()
                    --[[
                      line: 1344
                      upvalues:
                        u3 (ref,  index: 1)
                        value_upv_59 (copy, index: 2)
                        camLookAt (copy, index: 3)
                        tbl_upv_3 (copy, index: 4)
                    ]]
                    print("CLICKED")
                    u3 = value_upv_59.Parent
                    if camLookAt(value_upv_59.Parent, 50) ~= "noAnim" then
                        for _, value_60 in tbl_upv_3 do
                            if value_60.Priority ~= Enum.AnimationPriority.Idle then
                                value_60:Stop()
                            end
                        end
                        if tbl_upv_3[value_upv_59.Name] then
                            tbl_upv_3[value_upv_59.Name]:Play()
                        end
                    else
                        u3 = nil
                    end
                end
            )
            continue
        end
        if value_upv_59.Parent.Name == "Left Arm" then
            value_upv_59.Name = "LeftHand"
            value_upv_59:AddTag("Hands")
            value_upv_59.MouseClick:Connect(
                function()
                    --[[
                      line: 1344
                      upvalues:
                        u3 (ref,  index: 1)
                        value_upv_59 (copy, index: 2)
                        camLookAt (copy, index: 3)
                        tbl_upv_3 (copy, index: 4)
                    ]]
                    print("CLICKED")
                    u3 = value_upv_59.Parent
                    if camLookAt(value_upv_59.Parent, 50) ~= "noAnim" then
                        for _, value_60 in tbl_upv_3 do
                            if value_60.Priority ~= Enum.AnimationPriority.Idle then
                                value_60:Stop()
                            end
                        end
                        if tbl_upv_3[value_upv_59.Name] then
                            tbl_upv_3[value_upv_59.Name]:Play()
                        end
                    else
                        u3 = nil
                    end
                end
            )
            continue
        end
        if value_upv_59.Parent.Name == "Left Leg" then
            value_upv_59.Name = "LeftFoot"
            value_upv_59:AddTag("Cleats")
            value_upv_59.MouseClick:Connect(
                function()
                    --[[
                      line: 1344
                      upvalues:
                        u3 (ref,  index: 1)
                        value_upv_59 (copy, index: 2)
                        camLookAt (copy, index: 3)
                        tbl_upv_3 (copy, index: 4)
                    ]]
                    print("CLICKED")
                    u3 = value_upv_59.Parent
                    if camLookAt(value_upv_59.Parent, 50) ~= "noAnim" then
                        for _, value_60 in tbl_upv_3 do
                            if value_60.Priority ~= Enum.AnimationPriority.Idle then
                                value_60:Stop()
                            end
                        end
                        if tbl_upv_3[value_upv_59.Name] then
                            tbl_upv_3[value_upv_59.Name]:Play()
                        end
                    else
                        u3 = nil
                    end
                end
            )
            continue
        end
        if value_upv_59.Parent.Name ~= "Right Leg" then
            value_upv_59:AddTag(value_upv_59.Parent.Name)
        else
            value_upv_59.Name = "RightFoot"
            value_upv_59:AddTag("Cleats")
        end
        value_upv_59.MouseClick:Connect(
            function()
                --[[
                  line: 1344
                  upvalues:
                    u3 (ref,  index: 1)
                    value_upv_59 (copy, index: 2)
                    camLookAt (copy, index: 3)
                    tbl_upv_3 (copy, index: 4)
                ]]
                print("CLICKED")
                u3 = value_upv_59.Parent
                if camLookAt(value_upv_59.Parent, 50) ~= "noAnim" then
                    for _, value_60 in tbl_upv_3 do
                        if value_60.Priority ~= Enum.AnimationPriority.Idle then
                            value_60:Stop()
                        end
                    end
                    if tbl_upv_3[value_upv_59.Name] then
                        tbl_upv_3[value_upv_59.Name]:Play()
                    end
                else
                    u3 = nil
                end
            end
        )
    end
end
function tbl_1.init()
    --[[
      name: init
      line: 1373
      upvalues:
        LocalPlayer_upv_1 (copy, index: 1)
        u17 (ref,  index: 2)
        PlayerGui_upv_1 (copy, index: 3)
        initClickDetectors (copy, index: 4)
        CustomizationFrame_upv_1 (copy, index: 5)
        TweenService_upv_1 (copy, index: 6)
        EquipFrame_upv_1 (copy, index: 7)
    ]]
    LocalPlayer_upv_1:WaitForChild("SelectedTeam").Changed:Connect(
        function()
            --[[
              line: 1374
              upvalues:
                LocalPlayer_upv_1 (copy, index: 1)
                u17 (ref,  index: 2)
                PlayerGui_upv_1 (copy, index: 3)
            ]]
            if LocalPlayer_upv_1:FindFirstChild("SelectedTeam").Value == "N/A" then
                return
            end
            u17 = false
            PlayerGui_upv_1.Menu.CustomizationFrame:SetAttribute("vis", false)
        end
    )
    initClickDetectors()
    previewTeam(randomthingFromParent(game.ReplicatedStorage.Cosmetics.Jerseys).Name, LocalPlayer_upv_1:GetAttribute("JerseyType") or "Shirt")
    loadCosmetics()
    runCustomizationSetup()
    local MenuButtons_upv_1 = PlayerGui_upv_1.Menu:WaitForChild("MenuButtons")
    local CustomizeButton_1 = MenuButtons_upv_1:WaitForChild("CustomizeButton")
    local PlayButton_upv_1 = PlayerGui_upv_1.Menu:WaitForChild("PlayButton")
    local ColorSelector_upv_1 = CustomizationFrame_upv_1:WaitForChild("ColorSelector")
    CustomizeButton_1.MouseButton1Click:Connect(
        function()
            --[[
              line: 1392
              upvalues:
                ColorSelector_upv_1 (copy, index: 1)
                CustomizationFrame_upv_1 (copy, index: 2)
                TweenService_upv_1 (copy, index: 3)
                PlayerGui_upv_1 (copy, index: 4)
                MenuButtons_upv_1 (copy, index: 5)
                PlayButton_upv_1 (copy, index: 6)
            ]]
            ColorSelector_upv_1.Visible = false
            CustomizationFrame_upv_1:SetAttribute("vis", true)
            runCustomizationSetup()
            local v64 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_30 = {}
            tbl_30.Position = UDim2.new(0, 0, 0.5, 0)
            TweenService_upv_1:Create(CustomizationFrame_upv_1.ItemsFrame, v64, tbl_30):Play()
            local v65 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_31 = {}
            tbl_31.Position = UDim2.new(1, 0, 1, 0)
            TweenService_upv_1:Create(CustomizationFrame_upv_1.SelectFrame, v65, tbl_31):Play()
            local v66 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_32 = {}
            tbl_32.Position = UDim2.new(0.5, 0, 0.95, 0)
            TweenService_upv_1:Create(CustomizationFrame_upv_1.CancelButton, v66, tbl_32):Play()
            local v67 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_33 = {}
            tbl_33.Position = UDim2.new(0.5, 0, 1.5, 0)
            TweenService_upv_1:Create(PlayerGui_upv_1.Menu.ClubFrame, v67, tbl_33):Play()
            task.delay(
                0.35,
                function()
                    --[[
                      line: 1410
                      upvalues:
                        PlayerGui_upv_1 (copy, index: 1)
                    ]]
                    PlayerGui_upv_1.Menu.ClubFrame.Visible = false
                end
            )
            MenuButtons_upv_1.Visible = false
            PlayButton_upv_1.Visible = false
            camera()
        end
    )
    CustomizationFrame_upv_1.CancelButton.MouseButton1Click:Connect(
        function()
            --[[
              line: 1420
              upvalues:
                CustomizationFrame_upv_1 (copy, index: 1)
                ColorSelector_upv_1 (copy, index: 2)
                TweenService_upv_1 (copy, index: 3)
                EquipFrame_upv_1 (copy, index: 4)
                MenuButtons_upv_1 (copy, index: 5)
                PlayButton_upv_1 (copy, index: 6)
            ]]
            CustomizationFrame_upv_1:SetAttribute("vis", false)
            ColorSelector_upv_1.Visible = false
            local v68 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_34 = {}
            tbl_34.Position = UDim2.new(0, -350, 0.5, 0)
            TweenService_upv_1:Create(CustomizationFrame_upv_1.ItemsFrame, v68, tbl_34):Play()
            local v69 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_35 = {}
            tbl_35.Position = UDim2.new(1, 800, 1, 0)
            TweenService_upv_1:Create(CustomizationFrame_upv_1.SelectFrame, v69, tbl_35):Play()
            local v70 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_36 = {}
            tbl_36.Position = UDim2.new(0.5, 0, 0.95, 200)
            TweenService_upv_1:Create(CustomizationFrame_upv_1.CancelButton, v70, tbl_36):Play()
            local v71 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tbl_37 = {}
            tbl_37.Position = UDim2.new(0.5, 0, 1, 150)
            TweenService_upv_1:Create(EquipFrame_upv_1, v71, tbl_37):Play()
            MenuButtons_upv_1.Visible = true
            PlayButton_upv_1.Visible = true
        end
    )
end
return tbl_1