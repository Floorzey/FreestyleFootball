local flag_util = {}

function flag_util.getUserFlag(argument)
    local success, value = pcall(function()
        return UserSettings():IsUserFeatureEnabled(argument)
    end)

    return success and value
end

return flag_util
