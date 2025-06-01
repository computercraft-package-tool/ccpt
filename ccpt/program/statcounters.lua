local properprint = _G.ccpt.loadmodule("/lib/properprint")

local statcounters = {}

local counters = {}
local printorder = {"installed", "upgraded", "removed"}

function statcounters.increasecounter(action, amount)
    amount = amount or 1

    counters[action] = counters[action] or 0
    counters[action] = counters[action] + 1
end

function statcounters.printcounters()
    if next(counters) then
        local actionmessage = "";
        for i, v in ipairs(printorder) do
            if not (i == 1) then
                actionmessage = actionmessage .. ", "
            end

            if counters[v] == 1 then
                actionmessage =	actionmessage .. "1 package " .. v
            else
                actionmessage = actionmessage .. (counters[v] or 0) .. " packages " .. v
            end
        end
        actionmessage = actionmessage .. "."

        properprint.pprint(actionmessage)
    end
end

return statcounters