TRAIT = {}

function TRAIT:Callback(id, func)
    mvp.utils.callback.UnHook(id, self)

    mvp.utils.callback.Hook(id, self, func)
end

function TRAIT:Request(id, data)
    mvp.utils.callback.Request(id, data)
end

mvp.ui.g.RegisterTrait("callback", TRAIT)