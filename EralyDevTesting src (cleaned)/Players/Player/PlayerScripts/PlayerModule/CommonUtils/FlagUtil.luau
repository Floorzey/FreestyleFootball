return {
    getUserFlag = function(argument)
        local success, result = pcall(function()
            return UserSettings():IsUserFeatureEnabled(argument)
        end)

        return success and result
    end,
}
