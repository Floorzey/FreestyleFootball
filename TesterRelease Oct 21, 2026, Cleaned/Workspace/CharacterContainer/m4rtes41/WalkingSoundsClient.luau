local players = game:GetService("Players")
local sound_service = game:GetService("SoundService")
game:GetService("ReplicatedStorage")
local local_player = players.LocalPlayer
local character = local_player.Character or local_player.CharacterAdded:wait()
local humanoid = character.Humanoid
local sound_id = nil
local volume = nil
local playback_speed = nil
local value = nil
local value_2 = nil
character:WaitForChild("HumanoidRootPart")
local current_sound = sound_service:FindFirstChild("CurrentSound") or Instance.new("Sound", sound_service)
current_sound.Name = "CurrentSound"
local script_i_dlist = require(script.IDlist)

if character.HumanoidRootPart:FindFirstChild("Running") then
    character.HumanoidRootPart:FindFirstChild("Running"):Destroy()
end

local function get_floor_material()
    value = humanoid.FloorMaterial
    value_2 = string.split(tostring(value), "Enum.Material.")[2]

    return value_2
end

local function get_sound_properties()
    for key, item in pairs(script_i_dlist) do
        if key == value_2 then
            sound_id = item.id
            volume = 0.35

            if value_2 == "Air" then
                volume = 0
            end

            playback_speed = (humanoid.WalkSpeed < 16 and humanoid.WalkSpeed / 14 or humanoid.WalkSpeed / 24)
                * item.speed

            return
        end
    end
end

local function update()
    current_sound.SoundId = sound_id
    current_sound.Volume = volume
    current_sound.PlaybackSpeed = playback_speed
end

value = humanoid.FloorMaterial
value_2 = string.split(tostring(value), "Enum.Material.")[2]
get_sound_properties()
current_sound.SoundId = sound_id
current_sound.Volume = volume
current_sound.PlaybackSpeed = playback_speed

humanoid:GetPropertyChangedSignal("FloorMaterial"):Connect(function()
    value = humanoid.FloorMaterial
    value_2 = string.split(tostring(value), "Enum.Material.")[2]
    get_sound_properties()
    current_sound.SoundId = sound_id
    current_sound.Volume = volume
    current_sound.PlaybackSpeed = playback_speed

    if humanoid.MoveDirection.Magnitude > 0 then
        current_sound.Playing = true
    end
end)

humanoid.Running:Connect(function(argument)
    if
        humanoid.MoveDirection.Magnitude <= 0
        or (
            argument <= 0
            or (humanoid:GetState() == Enum.HumanoidStateType.Climbing or humanoid.FloorMaterial == Enum.Material.Air)
        )
    then
        current_sound:Stop()

        return
    end

    get_sound_properties()
    current_sound.SoundId = sound_id
    current_sound.Volume = volume
    current_sound.PlaybackSpeed = playback_speed
    current_sound.Playing = true
    current_sound.Looped = true
end)

local_player.CharacterAdded:Connect(function()
    task.wait(1)

    if current_sound.IsPlaying then
        current_sound:Stop()
    end
end)
