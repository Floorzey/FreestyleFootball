local cutscene = {}
local run_service = game:GetService("RunService")
local local_player = game.Players.LocalPlayer
local character = local_player.Character or local_player.CharacterAdded:Wait()
local workspace_current_camera = workspace.CurrentCamera
local cam_rig_with_letter_box = script:WaitForChild("CamRigWithLetterBox")
local connection = nil
local knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
knit.OnStart():await()
local key = knit.GetService("KeyHandlerService"):GetKey("cutscene")

local_player.CharacterAdded:Connect(function(character_2)
    character = character_2
end)

local values = {
    NagiU20 = function(character_2)
        local clone = cam_rig_with_letter_box:Clone()
        clone.Parent = workspace
        clone.RootPart.RootPart.Part0 = character_2.HumanoidRootPart
        clone.letterboxbot.Transparency = 1
        clone.letterboxtop.Transparency = 1
        script:SetAttribute("StopHead", true)
        local clone_2 = script.VFX.NagiU20.breath:Clone()
        clone_2.Parent = character_2.Head
        local clone_3 = script.VFX.NagiU20.Vignette:Clone()
        clone_3.Parent = local_player.PlayerGui.HUD
        local values_2 = {}

        for _, child in script.VFX.NagiU20.HumanoidRootPart:GetChildren() do
            local clone_4 = child:Clone()
            clone_4.Parent = character_2.HumanoidRootPart
            clone_4[clone_4.Name].Part0 = character_2.HumanoidRootPart
            values_2[clone_4.Name] = clone_4
        end

        local player_track = character_2.Humanoid.Animator:LoadAnimation(script.Animations.NagiU20.Player)
        local camera_track = clone.AnimationController.Animator:LoadAnimation(script.Animations.NagiU20.Camera)
        camera_track:Play()
        player_track.Priority = Enum.AnimationPriority.Action4
        player_track:Play()
        workspace_current_camera.CameraType = Enum.CameraType.Scriptable
        workspace_current_camera.CameraSubject = nil

        task.delay(0.333, function()
            values_2.Sweat.SweatP:Emit(6)
        end)

        task.delay(0.983, function()
            for _, descendant in ipairs(values_2.NagiVFX:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = true
                end
            end
        end)

        task.delay(4.65, function()
            for _, descendant in ipairs(values_2.NagiVFX:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = false
                end
            end
        end)

        task.delay(4.7, function()
            for _, descendant in ipairs(values_2.NagiVFXBeam:GetDescendants()) do
                if descendant:IsA("Beam") then
                    descendant.Enabled = true
                end
            end
        end)

        task.delay(7.333, function()
            for _, descendant in pairs(clone_2:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    descendant:Emit(descendant:GetAttribute("EmitCount"))
                end
            end
        end)

        task.delay(10, function()
            for _, descendant in ipairs(values_2.NagiVFXBeam:GetDescendants()) do
                if descendant:IsA("Beam") then
                    descendant.Enabled = false
                end
            end
        end)

        camera_track.Stopped:Once(function()
            if connection then
                connection:Disconnect()
                connection = nil
            end

            script:SetAttribute("StopHead", false)
            character.Humanoid.AutoRotate = true
            clone_3:Destroy()
            clone_2:Destroy()

            for _, instance in values_2 do
                instance:Destroy()
            end

            workspace_current_camera.CameraType = Enum.CameraType.Custom
            clone:Destroy()
            workspace_current_camera.FieldOfView = 70

            if character_2 == local_player.Character then
                workspace_current_camera.CameraSubject = character_2.Neck_CameraSubject

                return
            end

            workspace_current_camera.CameraSubject = character_2.Humanoid
        end)

        local number = 0
        connection = run_service.RenderStepped:Connect(function()
            character.Humanoid.AutoRotate = false
            character_2.Torso.Neck.C1 = script.Neck.C1

            if workspace_current_camera.CameraSubject ~= nil then
                workspace_current_camera.CameraSubject = nil
            end

            workspace_current_camera.CFrame = clone.camera.CFrame

            if script.VFX.NagiU20.FOV:FindFirstChild((tostring(number))) then
                workspace_current_camera.FieldOfView = script.VFX.NagiU20.FOV:FindFirstChild((tostring(number))).Value
            end

            number = number + 1
        end)
    end,

    NagiNEL = function(character_2)
        local clone = cam_rig_with_letter_box:Clone()
        clone.Parent = workspace
        clone.RootPart.RootPart.Part0 = character_2.HumanoidRootPart
        clone.letterboxbot.Transparency = 1
        clone.letterboxtop.Transparency = 1
        script:SetAttribute("StopHead", true)
        local clone_2 = script.VFX.NagiNEL.NagiVFX:Clone()
        clone_2.Parent = character_2.HumanoidRootPart
        clone_2.HumanoidRootPart.Part1 = clone_2.Parent
        local player_track = character_2.Humanoid.Animator:LoadAnimation(script.Animations.NagiNEL.Player)
        local camera_track = clone.AnimationController.Animator:LoadAnimation(script.Animations.NagiNEL.Camera)
        camera_track:Play()
        player_track.Priority = Enum.AnimationPriority.Action4
        player_track:Play()
        workspace_current_camera.CameraType = Enum.CameraType.Scriptable
        workspace_current_camera.CameraSubject = nil

        task.delay(1.25, function()
            for _, descendant in pairs(character_2.HumanoidRootPart.NagiVFX:GetDescendants()) do
                if descendant.ClassName == "ParticleEmitter" or descendant.ClassName == "Beam" then
                    descendant.Enabled = true
                end
            end
        end)

        camera_track.Stopped:Once(function()
            if connection then
                connection:Disconnect()
                connection = nil
            end

            script:SetAttribute("StopHead", false)
            character.Humanoid.AutoRotate = true
            clone_2:Destroy()
            workspace_current_camera.CameraType = Enum.CameraType.Custom
            clone:Destroy()
            workspace_current_camera.CameraSubject = character_2.Humanoid
        end)

        connection = run_service.RenderStepped:Connect(function()
            character.Humanoid.AutoRotate = false
            character_2.Torso.Neck.C1 = script.Neck.C1
            workspace_current_camera.CFrame = clone.camera.CFrame
        end)
    end,
}

function cutscene.init()
    key.OnClientEvent:Connect(function(argument, argument_2)
        if values[argument_2] then
            values[argument_2](argument)
        end
    end)
end

cutscene.init()

return cutscene
