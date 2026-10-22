local raycast_hitbox_v3 = {
    Version = "3.2",
    AttachmentName = "DmgPoint",
    DebugMode = false,
    WarningMessage = false,
}
local script_main_handler = require(script.MainHandler)
local script_hitbox_object = require(script.HitboxObject)

function raycast_hitbox_v3.Initialize(argument, argument_2, argument_3)
    assert(argument_2, "You must provide an object instance.")
    local check_result = script_main_handler:check(argument_2)

    if not check_result then
        check_result = script_hitbox_object:new()
        check_result:config(argument_2, argument_3)
        check_result:seekAttachments(raycast_hitbox_v3.AttachmentName, raycast_hitbox_v3.WarningMessage)
        check_result.debugMode = raycast_hitbox_v3.DebugMode
        script_main_handler:add(check_result)
    end

    return check_result
end

function raycast_hitbox_v3.Deinitialize(argument, argument_2)
    script_main_handler:remove(argument_2)
end

function raycast_hitbox_v3.GetHitbox(argument, argument_2)
    return script_main_handler:check(argument_2)
end

return raycast_hitbox_v3
