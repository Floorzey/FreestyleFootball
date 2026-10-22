local players = game:GetService("Players")
local sound_service = game:GetService("SoundService")
local replicated_storage = game:GetService("ReplicatedStorage")
local local_player = players.LocalPlayer
local character = local_player.Character or local_player.CharacterAdded:wait()
local humanoid = character.Humanoid
local id = nil
local volume = nil
local playback_speed = nil
local floor_material = nil
local value = nil
local current_sound = character:WaitForChild("HumanoidRootPart"):WaitForChild("CurrentSound")
local update_walkspeed = replicated_storage:WaitForChild("UpdateWalkspeed")
local update_floor_material = replicated_storage:WaitForChild("updateFloorMaterial")
local current_sound_2 = Instance.new("Sound", sound_service)
current_sound_2.Name = "CurrentSound"
local module_script = require(script.Parent:FindFirstChildWhichIsA("ModuleScript"))
character.HumanoidRootPart:FindFirstChild("Running"):Destroy()

local function get_floor_material()
    floor_material = humanoid.FloorMaterial
    value = string.split(tostring(floor_material), "Enum.Material.")[2]

    return value
end

local function get_sound_properties()
    for key, item in pairs(module_script) do
        if key == value then
            id = item.id
            volume = 0.35

            if value == "Air" then
                volume = 0
            end

            playback_speed = (((humanoid.WalkSpeed < 16) and (humanoid.WalkSpeed / 14)) or (humanoid.WalkSpeed / 24))
                * item.speed

            return
        end
    end
end

local function update()
    current_sound_2.SoundId = id
    current_sound_2.Volume = volume
    current_sound_2.PlaybackSpeed = playback_speed
end

floor_material = humanoid.FloorMaterial
local parts = string.split(tostring(floor_material), "Enum.Material.")
value = parts[2]
get_sound_properties()
current_sound_2.SoundId = id
current_sound_2.Volume = volume
current_sound_2.PlaybackSpeed = playback_speed

humanoid:GetPropertyChangedSignal("FloorMaterial"):Connect(function()
    floor_material = humanoid.FloorMaterial
    value = string.split(tostring(floor_material), "Enum.Material.")[2]
    get_sound_properties()
    current_sound_2.SoundId = id
    current_sound_2.Volume = volume
    current_sound_2.PlaybackSpeed = playback_speed
    update_floor_material:FireServer(humanoid.FloorMaterial)

    if not (humanoid.MoveDirection.Magnitude > 0) then
        return
    end

    current_sound_2.Playing = true
end)

humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
    if not (humanoid.WalkSpeed > 20) and not (humanoid.WalkSpeed < 15) then
        return
    end

    update_walkspeed:FireServer(humanoid.WalkSpeed)
end)

humanoid.Running:Connect(function(argument)
    if
        humanoid.MoveDirection.Magnitude > 0
        and argument > 0
        and humanoid:GetState() ~= Enum.HumanoidStateType.Climbing
        and humanoid.FloorMaterial ~= Enum.Material.Air
    then
        get_sound_properties()
        current_sound_2.SoundId = id
        current_sound_2.Volume = volume
        current_sound_2.PlaybackSpeed = playback_speed
        current_sound_2.Playing = true
        current_sound_2.Looped = true

        return
    end

    current_sound_2:Stop()
end)

current_sound.Changed:Connect(function(argument)
    if argument == 0 then
        return
    end

    current_sound.Volume = 0
end)

local_player.CharacterAdded:Connect(function()
    task.wait(1)

    if not current_sound_2.IsPlaying then
        return
    end

    current_sound_2:Stop()
end)

print("Walking sounds successfully loaded!")
