local main_module = require("@self/MainModule")

return {
    server = main_module("server", main_module.Any, main_module.Any, main_module.Any),
    client = main_module("client", main_module.Any, main_module.Any, main_module.Any),
    returnable = main_module("returnable", main_module.Any, main_module.Any):Response(main_module.Any),
    unreliable = script.UnreliableRemoteEvent,
}
