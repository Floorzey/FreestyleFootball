local players = game:GetService("Players")
local run_service = game:GetService("RunService")
local sound_service = game:GetService("SoundService")
local character_added = require(script:WaitForChild("AtomicBinding"))

local function load_flag(argument)
    local success_5, value_9 = pcall(function() end)

    return success_5 and value_9
end

local _ = "UserSoundsUseRelativeVelocity2"
local success, value = pcall(function() end)
local value_2 = success and value
local text = "UserNewCharacterSoundsApi3"
local success_2, value_3 = pcall(function() end)
local value_4 = success_2 and value_3
local text_2 = "UserFixCharSoundsEmitters"
local success_3, value_5 = pcall(function() end)
local value_6 = success_3 and value_5
local text_3 = "UserFixCharSoundsEmitterRootPart"
local success_4, value_7 = pcall(function()
    return UserSettings():IsUserFeatureEnabled(text_3)
end)
local value_8 = success_4 and value_7
local values = {}
values.Climbing = { SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3", Looped = true }
values.Died = { SoundId = "rbxasset://sounds/uuhhh.mp3" }
values.FreeFalling = { SoundId = "rbxasset://sounds/action_falling.ogg", Looped = true }
values.GettingUp = { SoundId = "rbxasset://sounds/action_get_up.mp3" }
values.Jumping = { SoundId = "rbxasset://sounds/action_jump.mp3" }
values.Landing = { SoundId = "rbxasset://sounds/action_jump_land.mp3" }
values.Running = { SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3", Looped = true, Pitch = 1.85 }
values.Splash = { SoundId = "rbxasset://sounds/impact_water.mp3" }
values.Swimming = { SoundId = "rbxasset://sounds/action_swim.mp3", Looped = true, Pitch = 1.6 }
local values_2 = {}
values_2.Climbing = { Looping = true, AssetId = "rbxasset://sounds/action_footsteps_plastic.mp3" }
values_2.Died = { AssetId = "rbxasset://sounds/uuhhh.mp3" }
values_2.FreeFalling = { Looping = true, AssetId = "rbxasset://sounds/action_falling.ogg" }
values_2.GettingUp = { AssetId = "rbxasset://sounds/action_get_up.mp3" }
values_2.Jumping = { AssetId = "rbxasset://sounds/action_jump.mp3" }
values_2.Landing = { AssetId = "rbxasset://sounds/action_jump_land.mp3" }
values_2.Running = { Looping = true, AssetId = "rbxasset://sounds/action_footsteps_plastic.mp3", PlaybackSpeed = 1.85 }
values_2.Splash = { AssetId = "rbxasset://sounds/impact_water.mp3" }
values_2.Swimming = { Looping = true, AssetId = "rbxasset://sounds/action_swim.mp3", PlaybackSpeed = 1.6 }

local function map(argument, argument_2, argument_3, argument_4, argument_5)
    return (((argument - argument_2) * (argument_5 - argument_4)) / (argument_3 - argument_2)) + argument_4
end

local function play_sound(argument, argument_2)
    if not argument_2 then
        argument.TimePosition = 0
    end

    if value_4 and argument:IsA("AudioPlayer") then
        argument:Play()
    else
        argument.Playing = true
    end
end

local function stop_sound(argument)
    if value_4 and argument:IsA("AudioPlayer") then
        argument:Stop()
    else
        argument.Playing = false
    end
end

local function play_sound_if(argument, playing)
    if value_4 and argument:IsA("AudioPlayer") then
        if argument.IsPlaying and not playing then
            argument:Stop()

            return
        end

        if not argument.IsPlaying and playing then
            argument:Play()
        end

        return
    end

    argument.Playing = playing
end

local function set_sound_looped(argument, looping)
    if value_4 and argument:IsA("AudioPlayer") then
        argument.Looping = looping
    else
        argument.Looped = looping
    end
end

local function shallow_copy(argument)
    local values_4 = {}

    for key, item in pairs(argument) do
        values_4[key] = item
    end

    return values_4
end

local function get_relative_velocity(argument, argument_2)
    if not argument then
        return argument_2
    end

    local ground_sensor = argument.ActiveController
        and (
            (argument.ActiveController:IsA("GroundController") and argument.GroundSensor)
            or (argument.ActiveController:IsA("ClimbController") and argument.ClimbSensor)
        )

    if ground_sensor and ground_sensor.SensedPart then
        return argument_2 - ground_sensor.SensedPart:GetVelocityAtPosition(argument.RootPart.Position)
    end

    return argument_2
end

local function initialize_sound_system(argument)
    local humanoid = argument.humanoid
    local root_part = argument.rootPart
    local rbx_character_sounds_emitter = nil
    local value_9 = nil

    if value_2 then
        local _ = humanoid.Parent:FindFirstChild("ControllerManager")
    end

    local values_4 = {}

    if value_4 then
        if sound_service.CharacterSoundsUseNewApi ~= Enum.RolloutState.Enabled then
            for name, item in pairs(values) do
                local sound = Instance.new("Sound")
                sound.Name = name
                sound.Archivable = false
                sound.RollOffMinDistance = 5
                sound.RollOffMaxDistance = 150
                sound.Volume = 0.65

                for key, item_2 in pairs(item) do
                    sound[key] = item_2
                end

                sound.Parent = root_part
                values_4[name] = sound
            end
        else
            local value_10 = nil
            local value_11 = nil

            if value_6 then
                if value_8 then
                    value_11 = humanoid.RootPart or humanoid.Parent
                else
                    value_11 = humanoid.RootPart
                end
            else
                value_10 = players.LocalPlayer.Character
            end

            local values_5 = {}
            local number = 5

            while number < 150 do
                values_5[number] = 5 / number
                number *= 1.25
            end

            values_5[150] = 0

            if value_6 then
                rbx_character_sounds_emitter = Instance.new("AudioEmitter", value_11)
            else
                rbx_character_sounds_emitter = Instance.new("AudioEmitter", value_10)
            end

            rbx_character_sounds_emitter.Name = "RbxCharacterSoundsEmitter"
            rbx_character_sounds_emitter:SetDistanceAttenuation(values_5)

            for name_2, item_3 in pairs(values_2) do
                local audio_player = Instance.new("AudioPlayer")
                value_11 = Instance.new("Wire")
                audio_player.Name = name_2
                value_11.Name = name_2 .. "Wire"
                audio_player.Archivable = false
                audio_player.Volume = 0.65

                for key_2, item_4 in pairs(item_3) do
                    audio_player[key_2] = item_4
                end

                audio_player.Parent = root_part
                value_11.Parent = audio_player
                value_11.SourceInstance = audio_player
                value_11.TargetInstance = rbx_character_sounds_emitter
                values_4[name_2] = audio_player
            end
        end
    else
        for name_3, item_5 in pairs(values) do
            local sound_2 = Instance.new("Sound")
            sound_2.Name = name_3
            sound_2.Archivable = false
            sound_2.RollOffMinDistance = 5
            sound_2.RollOffMaxDistance = 150
            sound_2.Volume = 0.65

            for key_3, item_6 in pairs(item_5) do
                sound_2[key_3] = item_6
            end

            sound_2.Parent = root_part
            values_4[name_3] = sound_2
        end
    end

    local values_6 = {}
    local values_7 = {}

    local function stop_playing_looped_sounds(argument_2)
        local values_10 = {}

        for key_4, item_7 in pairs(values_6) do
            values_10[key_4] = item_7
        end

        for key_5 in pairs(values_10) do
            if key_5 == (argument_2 or nil) then
                continue
            end

            if not value_4 then
                key_5.Playing = false
                values_6[key_5] = nil
                continue
            end

            if key_5:IsA("AudioPlayer") then
                key_5:Stop()
            else
                key_5.Playing = false
            end

            values_6[key_5] = nil
        end
    end

    values_7[Enum.HumanoidStateType.FallingDown] = function()
        stop_playing_looped_sounds()
    end
    values_7[Enum.HumanoidStateType.GettingUp] = function()
        stop_playing_looped_sounds()
        local getting_up = values_4.GettingUp
        getting_up.TimePosition = 0

        if value_4 and getting_up:IsA("AudioPlayer") then
            getting_up:Play()
        else
            getting_up.Playing = true
        end
    end
    values_7[Enum.HumanoidStateType.Jumping] = function()
        stop_playing_looped_sounds()
        local jumping = values_4.Jumping
        jumping.TimePosition = 0

        if value_4 and jumping:IsA("AudioPlayer") then
            jumping:Play()
        else
            jumping.Playing = true
        end
    end
    values_7[Enum.HumanoidStateType.Swimming] = function()
        local absolute_value = math.abs(root_part.AssemblyLinearVelocity.Y)

        if absolute_value > 0.1 then
            values_4.Splash.Volume = math.clamp((((absolute_value - 100) * 0.72) / 250) + 0.28, 0, 1)
            local splash = values_4.Splash
            splash.TimePosition = 0

            if value_4 and splash:IsA("AudioPlayer") then
                splash:Play()
            else
                splash.Playing = true
            end
        end

        stop_playing_looped_sounds(values_4.Swimming)
        local swimming = values_4.Swimming

        if value_4 and swimming:IsA("AudioPlayer") then
            swimming:Play()
        else
            swimming.Playing = true
        end

        values_6[values_4.Swimming] = true
    end
    values_7[Enum.HumanoidStateType.Freefall] = function()
        values_4.FreeFalling.Volume = 0
        stop_playing_looped_sounds(values_4.FreeFalling)
        local free_falling = values_4.FreeFalling

        if value_4 and free_falling:IsA("AudioPlayer") then
            free_falling.Looping = true
        else
            free_falling.Looped = true
        end

        if values_4.FreeFalling:IsA("Sound") then
            values_4.FreeFalling.PlaybackRegionsEnabled = true
        end

        values_4.FreeFalling.LoopRegion = NumberRange.new(2, 9)
        local free_falling_2 = values_4.FreeFalling
        free_falling_2.TimePosition = 0

        if value_4 and free_falling_2:IsA("AudioPlayer") then
            free_falling_2:Play()
        else
            free_falling_2.Playing = true
        end

        values_6[values_4.FreeFalling] = true
    end
    values_7[Enum.HumanoidStateType.Landed] = function()
        stop_playing_looped_sounds()
        local absolute_value = math.abs(root_part.AssemblyLinearVelocity.Y)

        if not (absolute_value > 75) then
            return
        end

        values_4.Landing.Volume = math.clamp((((absolute_value - 50) * 1) / 50) + 0, 0, 1)
        local landing = values_4.Landing
        landing.TimePosition = 0

        if not value_4 or not landing:IsA("AudioPlayer") then
            landing.Playing = true
        end

        landing:Play()
    end
    values_7[Enum.HumanoidStateType.Running] = function()
        stop_playing_looped_sounds(values_4.Running)
        local running = values_4.Running

        if value_4 and running:IsA("AudioPlayer") then
            running:Play()
        else
            running.Playing = true
        end

        values_6[values_4.Running] = true
    end
    values_7[Enum.HumanoidStateType.Climbing] = function()
        local climbing = values_4.Climbing
        local assembly_linear_velocity = root_part.AssemblyLinearVelocity
        local result

        if value_2 then
            result = get_relative_velocity(value_9, assembly_linear_velocity)
        else
            result = assembly_linear_velocity
        end

        if math.abs(result.Y) > 0.1 then
            if value_4 and climbing:IsA("AudioPlayer") then
                climbing:Play()
            else
                climbing.Playing = true
            end

            stop_playing_looped_sounds(climbing)
        else
            stop_playing_looped_sounds()
        end

        values_6[climbing] = true
    end
    values_7[Enum.HumanoidStateType.Seated] = function()
        stop_playing_looped_sounds()
    end
    values_7[Enum.HumanoidStateType.Dead] = function()
        stop_playing_looped_sounds()
        local died = values_4.Died
        died.TimePosition = 0

        if value_4 and died:IsA("AudioPlayer") then
            died:Play()
        else
            died.Playing = true
        end
    end
    local values_8 = {}
    values_8[values_4.Climbing] = function(argument_2, argument_3, argument_4)
        local vector

        if value_2 then
            vector = get_relative_velocity(value_9, argument_4)
        else
            vector = argument_4
        end

        local playing

        if vector.Magnitude > 0.1 then
            playing = true
        else
            playing = false
        end

        if value_4 and argument_3:IsA("AudioPlayer") then
            if argument_3.IsPlaying and not playing then
                argument_3:Stop()

                return
            end

            if not argument_3.IsPlaying and playing then
                argument_3:Play()
            end

            return
        end

        argument_3.Playing = playing
    end
    values_8[values_4.FreeFalling] = function(argument_2, argument_3, vector)
        if vector.Magnitude > 75 then
            argument_3.Volume = math.clamp(argument_3.Volume + (argument_2 * 0.9), 0, 1)
        else
            argument_3.Volume = 0
        end
    end
    values_8[values_4.Running] = function(argument_2, argument_3, vector)
        local playing = (vector.Magnitude > 0.5) and (humanoid.MoveDirection.Magnitude > 0.5)

        if value_4 and argument_3:IsA("AudioPlayer") then
            if argument_3.IsPlaying and not playing then
                argument_3:Stop()

                return
            end

            if not argument_3.IsPlaying and playing then
                argument_3:Play()
            end

            return
        end

        argument_3.Playing = playing
    end
    local values_9 = {}
    values_9[Enum.HumanoidStateType.RunningNoPhysics] = Enum.HumanoidStateType.Running
    local value_entry = values_9[humanoid:GetState()]
    local state = value_entry or humanoid:GetState()

    local function transition_to(argument_2)
        local callback_2 = values_7[argument_2]

        if callback_2 then
            callback_2()
        end

        state = argument_2
    end

    local state_2 = state
    local callback = values_7[state_2]

    if callback then
        callback()
    end

    state = state_2
    local connection = humanoid.StateChanged:Connect(function(argument_2, value_entry_2)
        value_entry_2 = values_9[value_entry_2] or value_entry_2

        if value_entry_2 == state then
            return
        end

        local callback_2 = values_7[value_entry_2]

        if callback_2 then
            callback_2()
        end

        state = value_entry_2
    end)
    local connection_2 = run_service.Stepped:Connect(function(elapsed_time, delta_time)
        for key_4 in pairs(values_6) do
            local callback_2 = values_8[key_4]

            if callback_2 then
                callback_2(delta_time, key_4, root_part.AssemblyLinearVelocity)
            end
        end
    end)

    local function terminate()
        connection:Disconnect()
        connection_2:Disconnect()

        if value_8 and rbx_character_sounds_emitter then
            rbx_character_sounds_emitter:Destroy()
        end

        for _, instance in pairs(values_4) do
            instance:Destroy()
        end

        table.clear(values_4)
    end

    return terminate
end

local character_added_2 =
    character_added.new({ rootPart = "HumanoidRootPart", humanoid = "Humanoid" }, initialize_sound_system)
local values_3 = {}

local function character_removing(argument)
    character_added_2:unbindRoot(argument)
end

character_added = function(argument)
    character_added_2:bindRoot(argument)
end

local function player_removing(player_2)
    local value_entry = values_3[player_2]

    if value_entry then
        for _, connection in ipairs(value_entry) do
            connection:Disconnect()
        end

        values_3[player_2] = nil
    end

    if not player_2.Character then
        return
    end

    character_added_2:unbindRoot(player_2.Character)
end

local function player_added(player_2)
    local value_entry = values_3[player_2]

    if not value_entry then
        local values_4 = {}
        values_3[player_2] = values_4
        value_entry = values_4
    end

    if player_2.Character then
        character_added_2:bindRoot(player_2.Character)
    end

    table.insert(value_entry, player_2.CharacterAdded:Connect(character_added))
    table.insert(value_entry, player_2.CharacterRemoving:Connect(character_removing))
end

for index, player in ipairs(players:GetPlayers()) do
    task.spawn(player_added, player)
end

players.PlayerAdded:Connect(player_added)
players.PlayerRemoving:Connect(player_removing)
