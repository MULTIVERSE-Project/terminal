mvp = mvp or {}
mvp.utils = mvp.utils or {}

mvp.utils.callback = mvp.utils.callback or {}
mvp.utils.callback.hooks = mvp.utils.callback.hooks or {}

if (SERVER) then
    util.AddNetworkString("mvp.callback")

    local getResponseFunc = function(id, ply, data)
        return function(responseData)
            mvp.utils.callback.Respond(ply, id, responseData)
        end
    end

    function mvp.utils.callback.Hook(id, ident, callback)
        hook.Add("mvp.callback", id .. "." .. ident, function(_id, data, ply)
            if (_id == id) then
                callback(ply, data, getResponseFunc(id, ply, data))
            end
        end)
    end
    function mvp.utils.callback.UnHook(id, ident)
        hook.Remove("mvp.callback", id .. "." .. ident)
    end

    function mvp.utils.callback.Respond(ply, id, data)
        data = data and {data} or {}

        net.Start("mvp.callback")
        net.WriteString(id)
        net.WriteTable(data or {})
        net.Send(ply)        
    end

    function mvp.utils.callback.Recieve(_, ply)
        local id = net.ReadString()
        local data = net.ReadTable()

        hook.Run("mvp.callback", id, data[1], ply)
    end
    net.Receive("mvp.callback", mvp.utils.callback.Recieve)
else
    function mvp.utils.callback.Hook(id, ident, callback)
        local f = ispanel(ident) and function(_pnl, recievedId, data)
            if (recievedId == id and IsValid(_pnl)) then
                callback(_pnl, data)
            end
        end or function(recievedId, data)
            if (recievedId == id) then
                callback(data)
            end            
        end

        hook.Add("mvp.callback", ispanel(ident) and ident or (id .. "." .. ident), f)
    end
    function mvp.utils.callback.UnHook(id, ident)
        hook.Remove("mvp.callback", ispanel(ident) and ident or (id .. "." .. ident))
    end
    function mvp.utils.callback.Once(id, ident, callback)
        local f = function(...)
            callback(...)
            mvp.utils.callback.UnHook(id, ident)
        end
        mvp.utils.callback.Hook(id, ident, f)
    end

    function mvp.utils.callback.Request(id, data)
        data = data and {data} or {}

        net.Start("mvp.callback")
        net.WriteString(id)
        net.WriteTable(data or {})
        net.SendToServer()
    end

    function mvp.utils.callback.Receive()
        local id = net.ReadString()
        local data = net.ReadTable()

        hook.Run("mvp.callback", id, data[1])
    end
    net.Receive("mvp.callback", mvp.utils.callback.Receive)
end