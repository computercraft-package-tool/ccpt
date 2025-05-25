local printorder = {"installed", "updated", "removed"}
local counters = {}

function increasecounter(action, amount)
    amount = amount or 1

    if counters[action] == nil then
        counters[action] = 0
    end
    counters[action] = counters[action] + 1
end

function printcounters()
    if #counters == 0 then
        return
    end

    local actionmessage = "";
    for i, v in ipairs(printorder) do
        if not i == 1 then
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