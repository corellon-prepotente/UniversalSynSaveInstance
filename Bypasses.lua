-- Dex Bypasses
-- Various bypasses for Roblox security features

local Bypasses = {}

function Bypasses.Enable()
    -- Hook detection bypasses
    local oldHook = hookfunction or function() end
    
    -- Anti-detection hooks
    if hookmetamethod then
        local oldIndex
        oldIndex = hookmetamethod(game, "__index", function(self, key)
            if key == "GetObjects" then
                return function(...) return game:GetObjects(...) end
            end
            return oldIndex(self, key)
        end)
    end
    
    return true
end

return Bypasses
