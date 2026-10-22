local function msg(...)
    return `[Forge Emit API]: {table.concat({ ... }, " ")}`
end

return {
    error = function(...)
        error(msg(..., "\n"))
    end,

    warn = function(...)
        warn(msg(...))
        warn(msg(debug.traceback("stack trace:")))
    end,

    info = function(...)
        print(msg(...))
    end,
}
