local flag_util = {}

function flag_util.getUserFlag(self)
    local success, value = pcall(function()
        return UserSettings():IsUserFeatureEnabled(self)
    end)
    return success and value
end

return flag_util
