local character = game:GetService("Players").LocalPlayer.Character
    or game:GetService("Players").LocalPlayer.CharacterAdded:Wait()
local user_input_service = game:GetService("UserInputService")
local run_service = game:GetService("RunService")
local current_camera = workspace.CurrentCamera
current_camera.CameraSubject = character:WaitForChild("Neck_CameraSubject")

if current_camera.CameraType ~= Enum.CameraType.Custom then
    current_camera.CameraType = Enum.CameraType.Custom
end

local status = character.Status
local _ = game.Players.LocalPlayer:GetMouse()
local camera_shaker = require(game:GetService("ReplicatedStorage").Modules.CameraShaker)
local enabled = false
UserSettings().GameSettings.RotationType = Enum.RotationType.MovementRelative

for key, item in character:GetDescendants() do
    local is_a_result = item:IsA("BasePart")

    if is_a_result then
        item.LocalTransparencyModifier = 0
    end
end

local function cam_shake_handler(argument)
    if argument == CFrame.new(0, 0, 0) then
        return
    end

    current_camera.CFrame = current_camera.CFrame * argument
end

local camera_shaker_2 = camera_shaker.new(Enum.RenderPriority.Camera.Value + 1, cam_shake_handler)
local values = {}
values["Right Shoulder"] = Vector3.new(2, 0, 0)
values["Left Shoulder"] = Vector3.new(-2, 0, 0)
values["Above Head"] = Vector3.new(0, 2, 0)
camera_shaker_2:Start()

function input_Began(input, enabled_3)
    if enabled_3 == true then
        return
    end

    if not (input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.DPadDown) then
        return
    end

    enabled = not enabled

    if enabled ~= true then
        user_input_service.MouseBehavior = Enum.MouseBehavior.Default

        if character.Humanoid ~= nil then
            local tween_properties = { CameraOffset = Vector3.new(0, 0, 0) }
            game:GetService("TweenService")
                :Create(
                    character.Humanoid,
                    TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                    tween_properties
                )
                :Play()
        end
    else
        user_input_service.MouseBehavior = Enum.MouseBehavior.LockCenter

        if character.Humanoid ~= nil then
            local tween_service_2 = game:GetService("TweenService")
            local humanoid = character.Humanoid
            local tween_info = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local tween_properties_2 = {}
            tween_properties_2.CameraOffset = values[game.Players.LocalPlayer.Settings.Misc.POV.Value]
            tween_service_2:Create(humanoid, tween_info, tween_properties_2):Play()

            return
        end
    end
end

game.ReplicatedStorage.MobileControlEvents.shiftLock.Event:Connect(function()
    input_Began({ KeyCode = Enum.KeyCode.LeftControl }, false)
end)

user_input_service.InputBegan:Connect(input_Began)
user_input_service.MouseBehavior = Enum.MouseBehavior.Default
local enabled_2 = false

run_service.RenderStepped:Connect(function()
    local camera_subject = current_camera.CameraSubject
    local is_a_result_2 = camera_subject:IsA("Humanoid")

    if is_a_result_2 then
        camera_subject = camera_subject.Parent.HumanoidRootPart
    end

    local magnitude = (camera_subject.Position - current_camera.CFrame.Position).Magnitude

    if magnitude < 1 then
        if not enabled then
            enabled_2 = true
            input_Began({ KeyCode = Enum.KeyCode.LeftControl }, false)
        end

        current_camera.CFrame = current_camera.CFrame * CFrame.new(0, 0.35, -0.6)

        if not (current_camera.CameraSubject:IsA("Humanoid")) then
            current_camera.CameraSubject = character.Head
        end

        if character.Head.Transparency ~= 1 then
            for _, descendant in pairs(character:GetDescendants()) do
                if
                    descendant:IsA("BasePart")
                    and (
                        descendant.Name == "Head"
                        or descendant.Parent:isA("Accessory")
                        or descendant:FindFirstChild("HeadWeld")
                    )
                then
                    descendant:SetAttribute("OldTransparency", descendant.Transparency)
                    descendant.Transparency = 1
                end
            end
        end

        for _, descendant_2 in pairs(character:GetDescendants()) do
            if descendant_2:IsA("ParticleEmitter") or descendant_2:IsA("Trail") then
                descendant_2:SetAttribute("wasEnabled", descendant_2.Enabled)
                descendant_2.Enabled = false
            end
        end

        if user_input_service:IsKeyDown(Enum.KeyCode.LeftAlt) then
            user_input_service.MouseBehavior = Enum.MouseBehavior.Default
            game.Players.LocalPlayer.PlayerGui.MouseIcon.MouseIcon.Visible = false
            user_input_service.MouseIconEnabled = true
        else
            user_input_service.MouseIconEnabled = false

            if enabled ~= true then
                user_input_service.MouseBehavior = Enum.MouseBehavior.Default
                game.Players.LocalPlayer.PlayerGui.MouseIcon.MouseIcon.Visible = false
            else
                game.Players.LocalPlayer.PlayerGui.MouseIcon.MouseIcon.Visible = true
                user_input_service.MouseBehavior = Enum.MouseBehavior.LockCenter
            end
        end
    else
        if game.Players.LocalPlayer.PlayerGui:FindFirstChild("MouseIcon") then
            if enabled == true then
                game.Players.LocalPlayer.PlayerGui.MouseIcon.MouseIcon.Visible = true
            elseif enabled == false then
                game.Players.LocalPlayer.PlayerGui.MouseIcon.MouseIcon.Visible = false
            end
        end

        user_input_service.MouseIconEnabled = not enabled

        if not (current_camera.CameraSubject:IsA("Humanoid")) then
            current_camera.CameraSubject = character.Neck_CameraSubject
        end

        if character.Head.Transparency == 1 then
            if enabled_2 == true then
                enabled_2 = false
                input_Began({ KeyCode = Enum.KeyCode.LeftControl }, false)
            end

            for _, descendant_3 in pairs(character:GetDescendants()) do
                if descendant_3:IsA("ParticleEmitter") or descendant_3:IsA("Trail") then
                    descendant_3.Enabled = descendant_3:GetAttribute("wasEnabled") or false
                end

                if
                    (
                        descendant_3.Name == "Head"
                        or descendant_3.Parent:isA("Accessory")
                        or descendant_3:FindFirstChild("HeadWeld")
                    ) and descendant_3:IsA("BasePart")
                then
                    descendant_3.Transparency = descendant_3:GetAttribute("OldTransparency")
                end
            end
        end
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local humanoid_root_part = character:FindFirstChild("HumanoidRootPart")

    if humanoid and humanoid_root_part and not (status:FindFirstChild("CameraOverride")) then
        humanoid.AutoRotate = not enabled

        if magnitude > 1 then
            current_camera.CFrame = current_camera.CFrame
                * CFrame.new(humanoid.CameraOffset.X, 0.5 + humanoid.CameraOffset.Y, 0)
        end
    end

    if
        not enabled
        or status:FindFirstChild("CameraLocked")
        or status:FindFirstChild("Ragdoll")
        or status:FindFirstChild("Dead")
        or not humanoid
        or not humanoid_root_part
    then
        return
    end

    if humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
        local _, value_4 = current_camera.CFrame:ToOrientation()
        humanoid_root_part.CFrame = CFrame.new(humanoid_root_part.Position) * CFrame.Angles(0, value_4, 0)
    end
end)

game.ReplicatedStorage.CameraShake.Event:Connect(function(argument)
    if game.Players.LocalPlayer.Settings.CameraShake.Value == true then
        return
    end

    camera_shaker_2:ShakeOnce(
        argument.magnitude or 0,
        argument.roughness or 0,
        argument.fadeIn or 0,
        argument.fadeOut or 0,
        nil,
        Vector3.new(0, 0, 0)
    )
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function(character_2)
    character = character_2
    status = character.Status
    enabled = false
    user_input_service.MouseBehavior = Enum.MouseBehavior.Default
    current_camera.CameraSubject = character_2:WaitForChild("Neck_CameraSubject")
end)

local players = game:GetService("Players")
local tween_service = game:GetService("TweenService")
local local_player = players.LocalPlayer
local value = nil
local value_2 = nil
local value_3 = nil

function HandleCharacter(instance_2)
    local humanoid_root_part = instance_2:WaitForChild("HumanoidRootPart")
    local neck = instance_2.Torso:FindFirstChild("Neck", true)
    value = humanoid_root_part
    value_2 = neck

    while not value_2 do
        wait()
        value_2 = instance_2:FindFirstChild("Neck", true)
    end

    while not (instance_2:FindFirstChildOfClass("Humanoid")) do
        wait()
    end

    local condition = instance_2:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6
    value_3 = condition
end

local instance = local_player.Character or local_player.CharacterAdded:Wait()
HandleCharacter(instance)
local_player.CharacterAdded:Connect(HandleCharacter)
local head_rotation_remote = game:GetService("ReplicatedStorage"):WaitForChild("HeadRotationRemote")

head_rotation_remote.OnClientEvent:Connect(function(argument)
    for _, item_2 in ipairs(argument) do
        if not (item_2[1].Character:FindFirstChild("Torso")) then
            continue
        end

        local neck = item_2[1].Character and item_2[1].Character.Torso:FindFirstChild("Neck", true)

        if neck then
            local tween_info = TweenInfo.new(0.05, Enum.EasingStyle.Linear)
            local tween_properties = {}
            tween_properties.C1 = item_2[2]
            tween_service:Create(neck, tween_info, tween_properties):Play()
        end
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if
        value
        and value_2
        and workspace.CurrentCamera.CameraSubject
        and workspace.CurrentCamera.CameraSubject.Parent == local_player.Character
    then
        local unit = value.CFrame:toObjectSpace(workspace.CurrentCamera.CFrame).lookVector.unit
        value_2.C1 = CFrame.new(value_2.C1.p)
            * CFrame.Angles(0, math.asin(unit.x), 0)
            * CFrame.Angles(-1.5707963267948966 + -math.asin(unit.y), 0, math.pi)
    end

    for _, player in ipairs(players:GetPlayers()) do
        if not player.Character or not (player.Character:FindFirstChild("Head")) then
            continue
        end

        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

        if not humanoid then
            continue
        end

        if humanoid.Health ~= 0 then
            player.Character.Head.CanCollide = false
        end
    end
end)

while wait(0.05) do
    if not value_2 then
        continue
    end

    if Last ~= value_2.C1 then
        head_rotation_remote:FireServer(value_2.C1)
        Last = value_2.C1
    end
end
