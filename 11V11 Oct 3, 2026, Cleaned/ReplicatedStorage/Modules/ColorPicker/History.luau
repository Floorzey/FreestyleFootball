local history = {}
history.__index = history

function history.new()
    local instance = setmetatable({}, history)
    instance._currentIndex = 0
    instance.Records = {}
    return instance
end

function history.WriteHistory(self, argument)
    self._currentIndex = self._currentIndex + 1
    if self._currentIndex < #self.Records then
        for n = self._currentIndex + 1, #self.Records do
            self.Records[n] = nil
        end
    end
    self.Records[self._currentIndex] = argument
end

function history.GetRecord(self, argument)
    return self.Records[argument or self._currentIndex]
end

function history.IncrementHistory(self, argument)
    if not (self._currentIndex <= 1) or not (argument < 0) then
        self._currentIndex = math.clamp(self._currentIndex + argument, 1, #self.Records)
        return self.Records[self._currentIndex]
    end
end

function history.ClearHistory(self)
    self.Records = {}
    self._currentIndex = 0
end

function history.Destroy(self)
    self:ClearHistory()
end

return history
