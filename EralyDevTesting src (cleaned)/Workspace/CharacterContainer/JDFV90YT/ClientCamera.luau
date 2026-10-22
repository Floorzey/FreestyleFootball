local character = game:GetService("Players").LocalPlayer.Character
    or game:GetService("Players").LocalPlayer.CharacterAdded:Wait()
local user_input_service = game:GetService("UserInputService")
local run_service = game:GetService("RunService")
local workspace_current_camera = workspace.CurrentCamera
workspace_current_camera.CameraSubject = character:WaitForChild("Neck_CameraSubject")

if workspace_current_camera.CameraType ~= Enum.CameraType.Custom then
    workspace_current_camera.CameraType = Enum.CameraType.Custom
end

local status = character.Status
game.Players.LocalPlayer:GetMouse()
local camera_shaker = require(game:GetService("ReplicatedStorage").Modules.CameraShaker)
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key_handler_service = knit.GetService("KeyHandlerService")
UserSettings().GameSettings.RotationType = Enum.RotationType.MovementRelative

local function cam_shake_handler(argument)
    if argument ~= CFrame.new(0, 0, 0) then
        local workspace_current_camera_2 = workspace_current_camera
        workspace_current_camera_2.CFrame = workspace_current_camera_2.CFrame * argument
    end
end

local enabled = false

for _, descendant in character:GetDescendants() do
    if descendant:IsA("BasePart") then
        descendant.LocalTransparencyModifier = 0
    end
end

local camera_shaker_2 = camera_shaker.new(Enum.RenderPriority.Camera.Value + 1, cam_shake_handler)
local values = {
    ["Right Shoulder"] = Vector3.new(2, 0, 0),
    ["Left Shoulder"] = Vector3.new(-2, 0, 0),
    ["Above Head"] = Vector3.new(0, 2, 0),
}
camera_shaker_2:Start()

function input_Began(input, enabled_3)
    if enabled_3 == true then
        return
    end

    if not (input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.DPadDown) then
        return
    end

    enabled = not enabled

    if enabled == true then
        user_input_service.MouseBehavior = Enum.MouseBehavior.LockCenter

        if character.Humanoid ~= nil then
            local _ = values[game.Players.LocalPlayer.Settings.Misc.POV.Value]
            game:GetService("TweenService")
                :Create(character.Humanoid, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    CameraOffset = values[game.Players.LocalPlayer.Settings.Misc.POV.Value],
                })
                :Play()
        end
    else
        user_input_service.MouseBehavior = Enum.MouseBehavior.Default

        if character.Humanoid ~= nil then
            game:GetService("TweenService")
                :Create(character.Humanoid, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    CameraOffset = Vector3.new(0, 0, 0),
                })
                :Play()
        end
    end
end

local timestamp = tick()

game.ReplicatedStorage.MobileControlEvents.shiftLock.Event:Connect(function()
    input_Began({
        KeyCode = Enum.KeyCode.LeftControl,
    }, false)
end)

user_input_service.InputBegan:Connect(input_Began)
user_input_service.MouseBehavior = Enum.MouseBehavior.Default
local enabled_2 = false
local key = key_handler_service:GetKey("ac")

run_service.RenderStepped:Connect(function()
    local camera_subject = workspace_current_camera.CameraSubject

    if camera_subject:IsA("Humanoid") then
        camera_subject = camera_subject.Parent.HumanoidRootPart
    end

    local magnitude = (camera_subject.Position - workspace_current_camera.CFrame.Position).Magnitude

    if magnitude > 80 and (tick() - timestamp > 10 and not status:FindFirstChild("CameraOverride")) then
        timestamp = tick()
        key:FireServer()
    end

    if magnitude < 1 then
        if not enabled then
            enabled_2 = true
            input_Began({
                KeyCode = Enum.KeyCode.LeftControl,
            }, false)
        end

        workspace_current_camera.CFrame = workspace_current_camera.CFrame * CFrame.new(0, 0.35, -0.6)

        if not workspace_current_camera.CameraSubject:IsA("Humanoid") then
            workspace_current_camera.CameraSubject = character.Head
        end

        if character.Head.Transparency ~= 1 then
            for _, descendant_2 in pairs(character:GetDescendants()) do
                if
                    descendant_2:IsA("BasePart")
                    and (
                        descendant_2.Name == "Head"
                        or (descendant_2.Parent:isA("Accessory") or descendant_2:FindFirstChild("HeadWeld"))
                    )
                then
                    descendant_2:SetAttribute("OldTransparency", descendant_2.Transparency)
                    descendant_2.Transparency = 1
                end
            end
        end

        for _, descendant_3 in pairs(character:GetDescendants()) do
            if descendant_3:IsA("ParticleEmitter") or descendant_3:IsA("Trail") then
                descendant_3:SetAttribute("wasEnabled", descendant_3.Enabled)
                descendant_3.Enabled = false
            end
        end

        if user_input_service:IsKeyDown(Enum.KeyCode.LeftAlt) then
            user_input_service.MouseBehavior = Enum.MouseBehavior.Default
            game.Players.LocalPlayer.PlayerGui.MouseIcon.MouseIcon.Visible = false
            user_input_service.MouseIconEnabled = true
        else
            user_input_service.MouseIconEnabled = false

            if enabled == true then
                game.Players.LocalPlayer.PlayerGui.MouseIcon.MouseIcon.Visible = true
                user_input_service.MouseBehavior = Enum.MouseBehavior.LockCenter
            else
                user_input_service.MouseBehavior = Enum.MouseBehavior.Default
                game.Players.LocalPlayer.PlayerGui.MouseIcon.MouseIcon.Visible = false
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

        if not workspace_current_camera.CameraSubject:IsA("Humanoid") then
            workspace_current_camera.CameraSubject = character.Neck_CameraSubject
        end

        if character.Head.Transparency == 1 then
            if enabled_2 == true then
                enabled_2 = false
                input_Began({
                    KeyCode = Enum.KeyCode.LeftControl,
                }, false)
            end

            for _, descendant_4 in pairs(character:GetDescendants()) do
                if descendant_4:IsA("ParticleEmitter") or descendant_4:IsA("Trail") then
                    descendant_4.Enabled = descendant_4:GetAttribute("wasEnabled") or false
                end

                if
                    (
                        descendant_4.Name == "Head"
                        or (descendant_4.Parent:isA("Accessory") or descendant_4:FindFirstChild("HeadWeld"))
                    ) and descendant_4:IsA("BasePart")
                then
                    descendant_4.Transparency = descendant_4:GetAttribute("OldTransparency")
                end
            end
        end
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local humanoid_root_part = character:FindFirstChild("HumanoidRootPart")

    if humanoid and (humanoid_root_part and not status:FindFirstChild("CameraOverride")) then
        humanoid.AutoRotate = not enabled

        if magnitude > 1 then
            workspace_current_camera.CFrame = workspace_current_camera.CFrame
                * CFrame.new(humanoid.CameraOffset.X, 0.5 + humanoid.CameraOffset.Y, 0)
        end
    end

    if
        enabled
        and not (
            status:FindFirstChild("CameraLocked")
            or (
                status:FindFirstChild("Ragdoll")
                or (
                    status:FindFirstChild("Dead")
                    or not (humanoid and (humanoid_root_part and humanoid:GetState() ~= Enum.HumanoidStateType.Dead))
                )
            )
        )
    then
        local _, value_4, _ = workspace_current_camera.CFrame:ToOrientation()
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
    workspace_current_camera.CameraSubject = character_2:WaitForChild("Neck_CameraSubject")
end)

local players = game:GetService("Players")
local tween_service = game:GetService("TweenService")
local local_player = players.LocalPlayer
local value = nil
local value_2 = nil
local value_3 = nil

function HandleCharacter(instance)
    local humanoid_root_part = instance:WaitForChild("HumanoidRootPart")
    local neck = instance.Torso:FindFirstChild("Neck", true)
    value = humanoid_root_part
    value_2 = neck

    while not value_2 do
        wait()
        value_2 = instance:FindFirstChild("Neck", true)
    end

    while not instance:FindFirstChildOfClass("Humanoid") do
        wait()
    end

    value_3 = instance:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6
end

HandleCharacter(local_player.Character or local_player.CharacterAdded:Wait())
local_player.CharacterAdded:Connect(HandleCharacter)
local head_look_remote = game.ReplicatedStorage:WaitForChild("HeadLookRemote")

head_look_remote.OnClientEvent:Connect(function(argument)
    for _, item in ipairs(argument) do
        if item[1].Character:FindFirstChild("Torso") then
            local neck = item[1].Character and item[1].Character.Torso:FindFirstChild("Neck", true)

            if neck then
                tween_service
                    :Create(neck, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {
                        C1 = item[2],
                    })
                    :Play()
            end
        end
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if
        value
        and (
            value_2
            and (
                workspace.CurrentCamera.CameraSubject
                and workspace.CurrentCamera.CameraSubject.Parent == local_player.Character
            )
        )
    then
        local unit = value.CFrame:toObjectSpace(workspace.CurrentCamera.CFrame).lookVector.unit
        local _ = value_2.C1 - value_2.C1.Position
        value_2.C1 = CFrame.new(value_2.C1.p)
            * CFrame.Angles(0, math.asin(unit.x), 0)
            * CFrame.Angles(-1.5707963267948966 + -math.asin(unit.y), 0, 3.141592653589793)
    end

    for _, player in ipairs(players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Head") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

            if humanoid and humanoid.Health ~= 0 then
                player.Character.Head.CanCollide = false
            end
        end
    end
end)

while wait(0.05) do
    if
        value_2 and (Last ~= value_2.C1 and not game.ReplicatedStorage.Modules.client.cutscene:GetAttribute("StopHead"))
    then
        head_look_remote:FireServer(value_2.C1)
        Last = value_2.C1
    end
end
