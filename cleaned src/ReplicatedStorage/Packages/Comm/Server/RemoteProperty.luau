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

function remote_property.Set(self, value)
    self._value = value
    table.clear(self._perPlayer)
    self._rs:FireAll(value)
end

function remote_property.SetTop(self, value)
    self._value = value
    for _, player in ipairs(players:GetPlayers()) do
        if self._perPlayer[player] == nil then
            self._rs:Fire(player, value)
        end
    end
end

function remote_property.SetFilter(self, callback, argument)
    for _, player in ipairs(players:GetPlayers()) do
        if callback(player, argument) then
            self:SetFor(player, argument)
        end
    end
end

function remote_property.SetFor(self, argument, argument_2)
    if argument.Parent then
        local per_player = self._perPlayer
        local argument_3
        if argument_2 ~= nil then
            argument_3 = argument_2
        else
            argument_3 = none
        end
        per_player[argument] = argument_3
    end
    self._rs:Fire(argument, argument_2)
end

function remote_property.SetForList(self, argument, argument_2)
    for _, item in ipairs(argument) do
        self:SetFor(item, argument_2)
    end
end

function remote_property.ClearFor(self, argument)
    if self._perPlayer[argument] == nil then
        return
    end
    self._perPlayer[argument] = nil
    self._rs:Fire(argument, self._value)
end

function remote_property.ClearForList(self, argument)
    for _, item in ipairs(argument) do
        self:ClearFor(item)
    end
end

function remote_property.ClearFilter(self, callback)
    for _, player in ipairs(players:GetPlayers()) do
        if callback(player) then
            self:ClearFor(player)
        end
    end
end

function remote_property.Get(self)
    return self._value
end

function remote_property.GetFor(self, argument)
    local per_player_entry = self._perPlayer[argument]
    if per_player_entry ~= nil then
        if per_player_entry ~= none then
            return per_player_entry
        end
        return nil
    end
    return self._value
end

function remote_property.Destroy(self)
    self._rs:Destroy()
    self._playerRemoving:Disconnect()
end

return remote_property
