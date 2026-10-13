local raycast_hitbox_v3 = { WarningMessage = false, AttachmentName = "DmgPoint", Version = "3.2", DebugMode = false }
local main_handler = require(script.MainHandler)
local hitbox_object = require(script.HitboxObject)

function raycast_hitbox_v3.Initialize(self, argument, argument_2)
    assert(argument, "You must provide an object instance.")
    local check_result = main_handler:check(argument)
    if not check_result then
        local hitbox_object_2 = hitbox_object:new()
        hitbox_object_2:config(argument, argument_2)
        hitbox_object_2:seekAttachments(raycast_hitbox_v3.AttachmentName, raycast_hitbox_v3.WarningMessage)
        hitbox_object_2.debugMode = raycast_hitbox_v3.DebugMode
        main_handler:add(hitbox_object_2)
        check_result = hitbox_object_2
    end
    return check_result
end

function raycast_hitbox_v3.Deinitialize(self, argument)
    main_handler:remove(argument)
end

function raycast_hitbox_v3.GetHitbox(self, argument)
    return main_handler:check(argument)
end

return raycast_hitbox_v3
