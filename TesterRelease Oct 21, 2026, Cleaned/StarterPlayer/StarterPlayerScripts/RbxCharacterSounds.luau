local players = game:GetService("Players")
local run_service = game:GetService("RunService")
local sound_service = game:GetService("SoundService")
local atomic_binding = require(script:WaitForChild("AtomicBinding"))

local function load_flag(argument: string)
    local success_2, result_3 = pcall(function()
        return UserSettings():IsUserFeatureEnabled(argument)
    end)

    return success_2 and result_3
end

local text = "UserSoundsUseRelativeVelocity2"
local success, result = pcall(function()
    return UserSettings():IsUserFeatureEnabled(text)
end)
local result_2 = success and result
local text_2 = "UserNewCharacterSoundsApi3"
local success2, result2 = pcall(function()
    return UserSettings():IsUserFeatureEnabled(text_2)
end)
local result2_2 = success2 and result2
local text_3 = "UserFixCharSoundsEmitters"
local success3, result3 = pcall(function()
    return UserSettings():IsUserFeatureEnabled(text_3)
end)
local result3_2 = success3 and result3
local text_4 = "UserFixCharSoundsEmitterRootPart"
local success4, result4 = pcall(function()
    return UserSettings():IsUserFeatureEnabled(text_4)
end)
local result4_2 = success4 and result4
local values = {
    Climbing = {
        SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3",
        Looped = true,
    },
    Died = {
        SoundId = "rbxasset://sounds/uuhhh.mp3",
    },
    FreeFalling = {
        SoundId = "rbxasset://sounds/action_falling.ogg",
        Looped = true,
    },
    GettingUp = {
        SoundId = "rbxasset://sounds/action_get_up.mp3",
    },
    Jumping = {
        SoundId = "rbxasset://sounds/action_jump.mp3",
    },
    Landing = {
        SoundId = "rbxasset://sounds/action_jump_land.mp3",
    },
    Running = {
        SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3",
        Looped = true,
        Pitch = 1.85,
    },
    Splash = {
        SoundId = "rbxasset://sounds/impact_water.mp3",
    },
    Swimming = {
        SoundId = "rbxasset://sounds/action_swim.mp3",
        Looped = true,
        Pitch = 1.6,
    },
}
local values_2 = {
    Climbing = {
        AssetId = "rbxasset://sounds/action_footsteps_plastic.mp3",
        Looping = true,
    },
    Died = {
        AssetId = "rbxasset://sounds/uuhhh.mp3",
    },
    FreeFalling = {
        AssetId = "rbxasset://sounds/action_falling.ogg",
        Looping = true,
    },
    GettingUp = {
        AssetId = "rbxasset://sounds/action_get_up.mp3",
    },
    Jumping = {
        AssetId = "rbxasset://sounds/action_jump.mp3",
    },
    Landing = {
        AssetId = "rbxasset://sounds/action_jump_land.mp3",
    },
    Running = {
        AssetId = "rbxasset://sounds/action_footsteps_plastic.mp3",
        Looping = true,
        PlaybackSpeed = 1.85,
    },
    Splash = {
        AssetId = "rbxasset://sounds/impact_water.mp3",
    },
    Swimming = {
        AssetId = "rbxasset://sounds/action_swim.mp3",
        Looping = true,
        PlaybackSpeed = 1.6,
    },
}

local function map(argument: number, argument_2: number, argument_3: number, argument_4: number, argument_5: number)
    return (argument - argument_2) * (argument_5 - argument_4) / (argument_3 - argument_2) + argument_4
end

local function get_relative_velocity(argument, argument_2)
    if not argument then
        return argument_2
    end

    local ground_sensor = argument.ActiveController
        and (
            argument.ActiveController:IsA("GroundController") and argument.GroundSensor
            or argument.ActiveController:IsA("ClimbController") and argument.ClimbSensor
        )

    if ground_sensor and ground_sensor.SensedPart then
        return argument_2 - ground_sensor.SensedPart:GetVelocityAtPosition(argument.RootPart.Position)
    end

    return argument_2
end

local function play_sound(argument: userdata, argument_2: boolean?)
    if not argument_2 then
        argument.TimePosition = 0
    end

    if result2_2 and argument:IsA("AudioPlayer") then
        argument:Play()

        return
    end

    argument.Playing = true
end

local function stop_sound(argument: userdata)
    if result2_2 and argument:IsA("AudioPlayer") then
        argument:Stop()

        return
    end

    argument.Playing = false
end

local function play_sound_if(argument: userdata, playing: boolean)
    if result2_2 and argument:IsA("AudioPlayer") then
        if argument.IsPlaying and not playing then
            argument:Stop()

            return
        end

        if not argument.IsPlaying and playing then
            argument:Play()
        end
    else
        argument.Playing = playing
    end
end

local function set_sound_looped(argument: userdata, looping: boolean)
    if result2_2 and argument:IsA("AudioPlayer") then
        argument.Looping = looping

        return
    end

    argument.Looped = looping
end

local function shallow_copy(argument)
    local values_4 = {}

    for key, item in pairs(argument) do
        values_4[key] = item
    end

    return values_4
end

local atomic_binding_2 = atomic_binding.new({
    humanoid = "Humanoid",
    rootPart = "HumanoidRootPart",
}, function(argument: table)
    local humanoid = argument.humanoid
    local root_part = argument.rootPart
    local rbx_character_sounds_emitter = nil
    local controller_manager

    if result_2 then
        controller_manager = humanoid.Parent:FindFirstChild("ControllerManager")
    else
        controller_manager = nil
    end

    local values_4 = {}

    if result2_2 and sound_service.CharacterSoundsUseNewApi == Enum.RolloutState.Enabled then
        local value = nil
        local value_2 = nil

        if result3_2 then
            if result4_2 then
                value_2 = humanoid.RootPart or humanoid.Parent
            else
                value_2 = humanoid.RootPart
            end
        else
            value = players.LocalPlayer.Character
        end

        local number = 5
        local values_5 = {}

        while number < 150 do
            values_5[number] = 5 / number
            number *= 1.25
        end

        values_5[150] = 0

        if result3_2 then
            rbx_character_sounds_emitter = Instance.new("AudioEmitter", value_2)
        else
            rbx_character_sounds_emitter = Instance.new("AudioEmitter", value)
        end

        rbx_character_sounds_emitter.Name = "RbxCharacterSoundsEmitter"
        rbx_character_sounds_emitter:SetDistanceAttenuation(values_5)

        for name, item in pairs(values_2) do
            local audio_player = Instance.new("AudioPlayer")
            local wire = Instance.new("Wire")
            audio_player.Name = name
            wire.Name = name .. "Wire"
            audio_player.Archivable = false
            audio_player.Volume = 0.65

            for key, item_2 in pairs(item) do
                audio_player[key] = item_2
            end

            audio_player.Parent = root_part
            wire.Parent = audio_player
            wire.SourceInstance = audio_player
            wire.TargetInstance = rbx_character_sounds_emitter
            values_4[name] = audio_player
        end
    else
        for name_2, item_3 in pairs(values) do
            local sound = Instance.new("Sound")
            sound.Name = name_2
            sound.Archivable = false
            sound.RollOffMinDistance = 5
            sound.RollOffMaxDistance = 150
            sound.Volume = 0.65

            for key_2, item_4 in pairs(item_3) do
                sound[key_2] = item_4
            end

            sound.Parent = root_part
            values_4[name_2] = sound
        end
    end

    local values_6 = {}

    local function stop_playing_looped_sounds(argument_2: userdata?)
        local pairs_2 = pairs
        local values_10 = {}
        local argument_3 = argument_2 or nil

        for key_3, item_5 in pairs(values_6) do
            values_10[key_3] = item_5
        end

        for key_4 in pairs_2(values_10) do
            if key_4 ~= argument_3 then
                if result2_2 and key_4:IsA("AudioPlayer") then
                    key_4:Stop()
                else
                    key_4.Playing = false
                end

                values_6[key_4] = nil
            end
        end
    end

    local values_7 = {
        [Enum.HumanoidStateType.FallingDown] = function()
            stop_playing_looped_sounds()
        end,

        [Enum.HumanoidStateType.GettingUp] = function()
            stop_playing_looped_sounds()
            local getting_up = values_4.GettingUp
            getting_up.TimePosition = 0

            if result2_2 and getting_up:IsA("AudioPlayer") then
                getting_up:Play()

                return
            end

            getting_up.Playing = true
        end,

        [Enum.HumanoidStateType.Jumping] = function()
            stop_playing_looped_sounds()
            local jumping = values_4.Jumping
            jumping.TimePosition = 0

            if result2_2 and jumping:IsA("AudioPlayer") then
                jumping:Play()

                return
            end

            jumping.Playing = true
        end,

        [Enum.HumanoidStateType.Swimming] = function()
            local absolute_value = math.abs(root_part.AssemblyLinearVelocity.Y)

            if absolute_value > 0.1 then
                values_4.Splash.Volume = math.clamp((absolute_value - 100) * 0.72 / 250 + 0.28, 0, 1)
                local splash = values_4.Splash
                splash.TimePosition = 0

                if result2_2 and splash:IsA("AudioPlayer") then
                    splash:Play()
                else
                    splash.Playing = true
                end
            end

            stop_playing_looped_sounds(values_4.Swimming)
            local swimming = values_4.Swimming

            if result2_2 and swimming:IsA("AudioPlayer") then
                swimming:Play()
            else
                swimming.Playing = true
            end

            values_6[values_4.Swimming] = true
        end,

        [Enum.HumanoidStateType.Freefall] = function()
            values_4.FreeFalling.Volume = 0
            stop_playing_looped_sounds(values_4.FreeFalling)
            local free_falling = values_4.FreeFalling

            if result2_2 and free_falling:IsA("AudioPlayer") then
                free_falling.Looping = true
            else
                free_falling.Looped = true
            end

            if values_4.FreeFalling:IsA("Sound") then
                values_4.FreeFalling.PlaybackRegionsEnabled = true
            end

            values_4.FreeFalling.LoopRegion = NumberRange.new(2, 9)
            local free_falling2 = values_4.FreeFalling
            free_falling2.TimePosition = 0

            if result2_2 and free_falling2:IsA("AudioPlayer") then
                free_falling2:Play()
            else
                free_falling2.Playing = true
            end

            values_6[values_4.FreeFalling] = true
        end,

        [Enum.HumanoidStateType.Landed] = function()
            stop_playing_looped_sounds()
            local absolute_value = math.abs(root_part.AssemblyLinearVelocity.Y)

            if not (absolute_value > 75) then
                return
            end

            values_4.Landing.Volume = math.clamp((absolute_value - 50) * 1 / 50 + 0, 0, 1)
            local landing = values_4.Landing
            landing.TimePosition = 0

            if result2_2 and landing:IsA("AudioPlayer") then
                landing:Play()

                return
            end

            landing.Playing = true
        end,

        [Enum.HumanoidStateType.Running] = function()
            stop_playing_looped_sounds(values_4.Running)
            local running = values_4.Running

            if result2_2 and running:IsA("AudioPlayer") then
                running:Play()
            else
                running.Playing = true
            end

            values_6[values_4.Running] = true
        end,

        [Enum.HumanoidStateType.Climbing] = function()
            local climbing = values_4.Climbing
            local assembly_linear_velocity = root_part.AssemblyLinearVelocity

            if result_2 then
                assembly_linear_velocity = get_relative_velocity(controller_manager, assembly_linear_velocity)
            end

            if math.abs(assembly_linear_velocity.Y) > 0.1 then
                if result2_2 and climbing:IsA("AudioPlayer") then
                    climbing:Play()
                else
                    climbing.Playing = true
                end

                stop_playing_looped_sounds(climbing)
            else
                stop_playing_looped_sounds()
            end

            values_6[climbing] = true
        end,

        [Enum.HumanoidStateType.Seated] = function()
            stop_playing_looped_sounds()
        end,

        [Enum.HumanoidStateType.Dead] = function()
            stop_playing_looped_sounds()
            local died = values_4.Died
            died.TimePosition = 0

            if result2_2 and died:IsA("AudioPlayer") then
                died:Play()

                return
            end

            died.Playing = true
        end,
    }
    local values_8 = {
        [values_4.Climbing] = function(argument_2: number, argument_3: userdata, vector: vector)
            if result_2 then
                vector = get_relative_velocity(controller_manager, vector)
            end

            local playing = vector.Magnitude > 0.1

            if result2_2 and argument_3:IsA("AudioPlayer") then
                if argument_3.IsPlaying and not playing then
                    argument_3:Stop()

                    return
                end

                if not argument_3.IsPlaying and playing then
                    argument_3:Play()
                end
            else
                argument_3.Playing = playing
            end
        end,

        [values_4.FreeFalling] = function(argument_2: number, argument_3: userdata, vector: vector)
            if vector.Magnitude > 75 then
                argument_3.Volume = math.clamp(argument_3.Volume + argument_2 * 0.9, 0, 1)

                return
            end

            argument_3.Volume = 0
        end,

        [values_4.Running] = function(argument_2: number, argument_3: userdata, vector: vector)
            local playing

            if vector.Magnitude > 0.5 then
                playing = humanoid.MoveDirection.Magnitude > 0.5
            else
                playing = false
            end

            if result2_2 and argument_3:IsA("AudioPlayer") then
                if argument_3.IsPlaying and not playing then
                    argument_3:Stop()

                    return
                end

                if not argument_3.IsPlaying and playing then
                    argument_3:Play()
                end
            else
                argument_3.Playing = playing
            end
        end,
    }
    local values_9 = {
        [Enum.HumanoidStateType.RunningNoPhysics] = Enum.HumanoidStateType.Running,
    }
    local state = values_9[humanoid:GetState()] or humanoid:GetState()

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
    local connection = humanoid.StateChanged:Connect(function(argument_2, argument_3)
        local value_entry = values_9[argument_3] or argument_3

        if value_entry == state then
            return
        end

        local callback_2 = values_7[value_entry]

        if callback_2 then
            callback_2()
        end

        state = value_entry
    end)
    local connection_2 = run_service.Stepped:Connect(function(elapsed_time: any, delta_time: number)
        for key_3 in pairs(values_6) do
            local callback_2 = values_8[key_3]

            if callback_2 then
                callback_2(delta_time, key_3, root_part.AssemblyLinearVelocity)
            end
        end
    end)

    return function()
        connection:Disconnect()
        connection_2:Disconnect()

        if result4_2 and rbx_character_sounds_emitter then
            rbx_character_sounds_emitter:Destroy()
        end

        for _, instance in pairs(values_4) do
            instance:Destroy()
        end

        table.clear(values_4)
    end
end)
local values_3 = {}

local function character_added(argument)
    atomic_binding_2:bindRoot(argument)
end

local function character_removing(argument)
    atomic_binding_2:unbindRoot(argument)
end

local function player_added(player_2: userdata)
    local value_entry = values_3[player_2]

    if not value_entry then
        value_entry = {}
        values_3[player_2] = value_entry
    end

    if player_2.Character then
        atomic_binding_2:bindRoot(player_2.Character)
    end

    table.insert(value_entry, player_2.CharacterAdded:Connect(character_added))
    table.insert(value_entry, player_2.CharacterRemoving:Connect(character_removing))
end

local function player_removing(player_2: userdata)
    local value_entry = values_3[player_2]

    if value_entry then
        for _, connection in ipairs(value_entry) do
            connection:Disconnect()
        end

        values_3[player_2] = nil
    end

    if player_2.Character then
        atomic_binding_2:unbindRoot(player_2.Character)
    end
end

for _, player in ipairs(players:GetPlayers()) do
    task.spawn(player_added, player)
end

players.PlayerAdded:Connect(player_added)
players.PlayerRemoving:Connect(player_removing)
