local statcounters = {}

local printorder = {"installed", "updated", "removed"}

function statcounters.increasecounter(action, amount)
    amount = amount or 1

    if _G.ccpt.statcounters[action] == nil then
        _G.ccpt.statcounters[action] = 0
    end
    _G.ccpt.statcounters[action] = _G.ccpt.statcounters[action] + 1
end

function statcounters.printcounters()
    if next(_G.ccpt.statcounters) then
        local actionmessage = "";
        for i, v in ipairs(printorder) do
            if not (i == 1) then
                actionmessage = actionmessage .. ", "
            end

            if _G.ccpt.statcounters[v] == 1 then
                actionmessage =	actionmessage .. "1 package " .. v
            else
                actionmessage = actionmessage .. (_G.ccpt.statcounters[v] or 0) .. " packages " .. v
            end
        end
        actionmessage = actionmessage .. "."

        properprint.pprint(actionmessage)
    end
end

return statcounters