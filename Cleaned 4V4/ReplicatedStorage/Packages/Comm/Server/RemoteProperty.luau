local players = game:GetService("Players")
local util = require(script.Parent.Parent.Util)
local _ = require(script.Parent.Parent.Types)
local remote_signal = require(script.Parent.RemoteSignal)
local none = util.None
local remote_property = {}
remote_property.__index = remote_property

function remote_property.new(parent, name, value, enabled, argument)
    local instance = setmetatable({}, remote_property)
    instance._rs = remote_signal.new(parent, name, enabled, argument)
    instance._value = value
    instance._perPlayer = {}
    instance._playerRemoving = players.PlayerRemoving:Connect(function(player)
        instance._perPlayer[player] = nil
    end)

    instance._rs:Connect(function(argument_2)
        local per_player_entry = instance._perPlayer[argument_2]
        local value_2

        if per_player_entry == nil then
            value_2 = instance._value
        elseif per_player_entry ~= none then
            value_2 = per_player_entry
        else
            value_2 = nil
        end

        instance._rs:Fire(argument_2, value_2)
    end)

    return instance
end

function remote_property.Set(argument, value)
    argument._value = value
    table.clear(argument._perPlayer)
    argument._rs:FireAll(value)
end

function remote_property.SetTop(argument, value)
    argument._value = value

    for _, player in ipairs(players:GetPlayers()) do
        if argument._perPlayer[player] == nil then
            argument._rs:Fire(player, value)
        end
    end
end

function remote_property.SetFilter(argument, callback, argument_2)
    for _, player in ipairs(players:GetPlayers()) do
        if callback(player, argument_2) then
            argument:SetFor(player, argument_2)
        end
    end
end

function remote_property.SetFor(argument, argument_2, argument_3)
    if argument_2.Parent then
        local per_player = argument._perPlayer
        local argument_4

        if argument_3 ~= nil then
            argument_4 = argument_3
        else
            argument_4 = none
        end

        per_player[argument_2] = argument_4
    end

    argument._rs:Fire(argument_2, argument_3)
end

function remote_property.SetForList(argument, argument_2, argument_3)
    for _, item in ipairs(argument_2) do
        argument:SetFor(item, argument_3)
    end
end

function remote_property.ClearFor(argument, argument_2)
    if argument._perPlayer[argument_2] == nil then
        return
    end

    argument._perPlayer[argument_2] = nil
    argument._rs:Fire(argument_2, argument._value)
end

function remote_property.ClearForList(argument, argument_2)
    for _, item in ipairs(argument_2) do
        argument:ClearFor(item)
    end
end

function remote_property.ClearFilter(argument, callback)
    for _, player in ipairs(players:GetPlayers()) do
        if callback(player) then
            argument:ClearFor(player)
        end
    end
end

function remote_property.Get(argument)
    return argument._value
end

function remote_property.GetFor(argument, argument_2)
    local per_player_entry = argument._perPlayer[argument_2]

    if per_player_entry ~= nil then
        if per_player_entry ~= none then
            return per_player_entry
        end

        return nil
    end

    return argument._value
end

function remote_property.Destroy(argument)
    argument._rs:Destroy()
    argument._playerRemoving:Disconnect()
end

return remote_property
