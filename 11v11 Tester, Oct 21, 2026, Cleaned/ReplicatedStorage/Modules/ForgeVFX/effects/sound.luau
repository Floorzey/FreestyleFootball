local run_service = game:GetService("RunService")
local collection_service = game:GetService("CollectionService")
local attributes = require("../mod/attributes")
local tween = require("../mod/tween")
require("../types")
local utility = require("../mod/utility")
local promise = require("../pkg/Promise")
local random = Random.new()
local sound = {}
local vfx_forge_sound_player = nil

local function select_random_sound(argument: userdata)
    local get_result = attributes.get(argument, "SoundPoolTag", "")

    if get_result == "" then
        return argument
    end

    local items = {}
    local items_2 = {}
    local number = 0

    for _, item in collection_service:GetTagged(get_result) do
        if item:IsA("Sound") then
            table.insert(items, item)
            local get_result_2 = attributes.get(item, "SoundPoolWeight", 1)
            table.insert(items_2, get_result_2)
            number += get_result_2
        end
    end

    if #items == 0 then
        return argument
    end

    if number > 0 then
        local product = random:NextNumber() * number
        local number_2 = 0

        for key, item_2 in items_2 do
            number_2 += item_2

            if product <= number_2 then
                return items[key]
            end
        end
    end

    return items[random:NextInteger(1, #items)]
end

local function create_sound_clone(argument: userdata, argument_2: userdata, items: any)
    local clone = argument_2:Clone()

    for _, item in clone:GetTags() do
        clone:RemoveTag(item)
    end

    local parent = argument:FindFirstAncestorWhichIsA("BasePart")
    local sound_emitter = nil

    if utility.PLUGIN_CONTEXT then
        if parent then
            sound_emitter = Instance.new("Part")
            sound_emitter.Name = "SoundEmitter"
            sound_emitter.Anchored = true
            sound_emitter.CanCollide = false
            sound_emitter.CanQuery = false
            sound_emitter.CanTouch = false
            sound_emitter.Transparency = 1
            sound_emitter.Size = Vector3.new(1, 1, 1)
            sound_emitter.CFrame = parent.CFrame
            sound_emitter.Parent = vfx_forge_sound_player
            clone.Parent = sound_emitter
            table.insert(items, sound_emitter)
        else
            clone.Parent = vfx_forge_sound_player
            table.insert(items, clone)
        end
    else
        if parent then
            clone.Parent = parent
        else
            clone.Parent = workspace.Terrain
        end

        table.insert(items, clone)
    end

    return clone, sound_emitter
end

local function play_single_sound(
    argument: userdata,
    argument_2: userdata,
    instance: userdata,
    argument_3: userdata?,
    items: any,
    argument_4: number
)
    local playback_speed = instance.PlaybackSpeed
    local get_result = attributes.get(argument_2, "Volume_End", instance.Volume)
    local volume = attributes.get(argument_2, "Volume_Start", instance.Volume)
    instance.Volume = volume

    if volume == get_result then
        instance.Volume = volume
    else
        local get_result_2 = attributes.get(argument_2, "Volume_Duration", instance.TimeLength)
        local from_params = tween.fromParams
        local get_result_3 = attributes.get(argument_2, "Volume_Curve", utility.default_bezier)
        table.insert(
            items,
            from_params(get_result_3, get_result_2, function(argument_5, argument_6)
                instance.Volume = utility.lerp(volume, get_result, argument_5)

                return argument_6 * playback_speed
            end)
        )
    end

    local get_result_4 = attributes.get(argument_2, "Speed_End", instance.PlaybackSpeed)
    local playback_speed_2 = attributes.get(argument_2, "Speed_Start", instance.PlaybackSpeed)
    local playback_speed_3 = playback_speed_2
    local value = nil

    if playback_speed_2 == get_result_4 then
        instance.PlaybackSpeed = playback_speed_2
    else
        local get_result_5 = attributes.get(argument_2, "Speed_Duration", instance.TimeLength)
        value = tween.fromParams(
            attributes.get(argument_2, "Speed_Curve", utility.default_bezier),
            get_result_5,
            function(argument_5, argument_6)
                playback_speed_3 = utility.lerp(playback_speed_2, get_result_4, argument_5)
                instance.PlaybackSpeed = playback_speed_3

                return argument_6
            end
        )
        table.insert(items, value)
    end

    local get_result_6 = attributes.get(argument_2, "RollOff_End", instance.RollOffMinDistance)
    local get_result_7 = attributes.get(argument_2, "RollOff_Start", instance.RollOffMinDistance)

    if get_result_7 ~= get_result_6 then
        local get_result_8 = attributes.get(argument_2, "RollOff_Duration", instance.TimeLength)
        local from_params_2 = tween.fromParams
        local get_result_9 = attributes.get(argument_2, "RollOff_Curve", utility.default_bezier)
        table.insert(
            items,
            from_params_2(get_result_9, get_result_8, function(argument_5, argument_6)
                instance.RollOffMinDistance = utility.lerp(get_result_7, get_result_6, argument_5)

                return argument_6 * playback_speed_3
            end, value)
        )
    end

    if instance.PlayOnRemove and not utility.PLUGIN_CONTEXT then
        instance:Destroy()
    else
        instance:Play()
    end

    local first_ancestor_which_is_a = argument_3 and argument:FindFirstAncestorWhichIsA("BasePart")

    if first_ancestor_which_is_a then
        table.insert(
            items,
            run_service.Heartbeat:Connect(function()
                if argument_3.Parent then
                    argument_3.CFrame = first_ancestor_which_is_a.CFrame
                end
            end)
        )
    end

    if argument_4 > 0 then
        task.wait(argument_4)
        instance:Stop()
    else
        tween.timer(instance.TimeLength, function(argument_5, argument_6)
            if instance.PlaybackSpeed > 0 or argument_6 > 0 and (value and value.Connected) then
                return argument_5 * instance.PlaybackSpeed
            end

            return nil
        end, value, items)
    end

    return value
end

function sound.init()
    if not utility.PLUGIN_CONTEXT then
        return
    end

    local first_ancestor_of_class = script:FindFirstAncestorOfClass("Plugin")

    if not first_ancestor_of_class then
        return
    end

    vfx_forge_sound_player = first_ancestor_of_class:CreateDockWidgetPluginGui(
        "VFXForgeSoundPlayer",
        DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, true, 200, 100, 100, 50)
    )

    if vfx_forge_sound_player then
        vfx_forge_sound_player.Name = "VFXForgeSoundPlayer"
    end
end

function sound.deinit()
    if vfx_forge_sound_player then
        vfx_forge_sound_player:Destroy()
        vfx_forge_sound_player = nil
    end
end

function sound.emit(result: userdata, items: any)
    if result.Playing then
        result:Stop()
    end

    local get_result = attributes.get(result, "SoundPoolIsSource", false)
    local get_result_2 = attributes.get(result, "SoundPoolInheritAttributes", false)

    if get_result_2 and not get_result then
        result = select_random_sound(result) or result
    end

    local get_result_3 = attributes.get(result, "EmitDelay", 0)
    local get_result_4 = attributes.get(result, "EmitDuration", 0)
    local get_result_5 = attributes.get(result, "EmitCount", 1)
    local range = attributes.getRange(result, "EmitInterval", NumberRange.new(0, 0))
    local get_result_6 = attributes.get(result, "RepeatCount", 1)
    local range2 = attributes.getRange(result, "RepeatInterval", NumberRange.new(0, 0))
    task.wait(get_result_3)
    local items_2 = {}

    for index = 1, get_result_5 do
        local result_2 = get_result_2 and result

        if not result_2 then
            if get_result then
                result_2 = result
            else
                result_2 = select_random_sound(result) or result
            end
        end

        local index_3

        if result_2 then
            local result_3

            if get_result_2 and result_2 ~= result then
                result_3 = result_2
            else
                result_3 = result
            end

            index_3 = index

            for index_2 = 1, get_result_6 do
                table.insert(
                    items_2,
                    promise.new(function(callback)
                        local instance, instance_2 = create_sound_clone(result, result_2, items)
                        play_single_sound(result, result_3, instance, instance_2, items, get_result_4)

                        if instance_2 then
                            instance_2:Destroy()
                        else
                            instance:Destroy()
                        end

                        callback()
                    end)
                )
                local index_4

                if index_2 < get_result_6 and range2.Max > 0 then
                    task.wait(random:NextNumber(range2.Min, range2.Max))
                    index_4 = index_2
                else
                    index_4 = index_2
                end
            end

            if index_3 < get_result_5 and range.Max > 0 then
                task.wait(random:NextNumber(range.Min, range.Max))
            end
        else
            index_3 = index
        end
    end

    promise.all(items_2):await()
end

return sound
