-- CloneRef support for JJsploit/Temple/Electron and other exploits
-- that don't have cloneref or have really shit versions of it

local cloneref = cloneref or function(instance)
    return instance
end

getgenv().cloneref = cloneref

return cloneref
