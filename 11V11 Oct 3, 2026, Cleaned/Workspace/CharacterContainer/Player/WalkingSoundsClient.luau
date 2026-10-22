local players = game:GetService("Players")
local sound_service = game:GetService("SoundService")
local _ = game:GetService("ReplicatedStorage")
local local_player = players.LocalPlayer
local character = local_player.Character or (local_player.CharacterAdded:wait())
local humanoid = character.Humanoid
local id = nil
local volume = nil
local playback_speed = nil
local floor_material = nil
local value = nil
local humanoid_root_part = character:WaitForChild("HumanoidRootPart")
local current_sound = sound_service:FindFirstChild("CurrentSound") or (Instance.new("Sound", sound_service))
current_sound.Name = "CurrentSound"
local i_dlist = require(script.IDlist)
if character.HumanoidRootPart:FindFirstChild("Running") then
    character.HumanoidRootPart:FindFirstChild("Running"):Destroy()
end

local function get_floor_material()
    floor_material = humanoid.FloorMaterial
    value = string.split(tostring(floor_material), "Enum.Material.")[2]
    return value
end

local function get_sound_properties()
    for key, item in pairs(i_dlist) do
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
    current_sound.SoundId = id
    current_sound.Volume = volume
    current_sound.PlaybackSpeed = playback_speed
end

floor_material = humanoid.FloorMaterial
local parts = string.split(tostring(floor_material), "Enum.Material.")
value = parts[2]
get_sound_properties()
current_sound.SoundId = id
current_sound.Volume = volume
current_sound.PlaybackSpeed = playback_speed
humanoid:GetPropertyChangedSignal("FloorMaterial"):Connect(function()
    floor_material = humanoid.FloorMaterial
    value = string.split(tostring(floor_material), "Enum.Material.")[2]
    get_sound_properties()
    current_sound.SoundId = id
    current_sound.Volume = volume
    current_sound.PlaybackSpeed = playback_speed
    if not (humanoid.MoveDirection.Magnitude > 0) then
        return
    end
    current_sound.Playing = true
end)
humanoid.Running:Connect(function(argument)
    if
        humanoid.MoveDirection.Magnitude > 0
        and argument > 0
        and humanoid:GetState() ~= Enum.HumanoidStateType.Climbing
        and humanoid.FloorMaterial ~= Enum.Material.Air
    then
        get_sound_properties()
        current_sound.SoundId = id
        current_sound.Volume = volume
        current_sound.PlaybackSpeed = playback_speed
        current_sound.Playing = true
        current_sound.Looped = true
        return
    end
    current_sound:Stop()
end)
local_player.CharacterAdded:Connect(function()
    task.wait(1)
    if not current_sound.IsPlaying then
        return
    end
    current_sound:Stop()
end)
