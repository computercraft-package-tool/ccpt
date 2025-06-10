--[[ 
	Module to track and print statistics during a single run of CCPT

	Authors: PentagonLP 2021, 2025
	@module statcounters
]]

-- Load module dependencies
local properprint = _G.ccpt.loadmodule("/lib/properprint")

-- Module interface table
local statcounters = {}

-- ## START OF MODULE ##

--[[ Storage for current values of statistic counters
    @table statcounters
    @field <countername> int Current value of the specific counter
]]
local counters = {}

--[[ Order in which to print the different statistics in statcounters.printcounters(), in the format of {string,...} containing the different names of the counters
]]
local printorder = { "installed", "upgraded", "removed" }

--[[ Increase a certain statistics counter
    @tparam string action The name of the counter as registered in @ref{printorder}
    @tparam[opt] int amount The amount by which to increase the counter
]]
function statcounters.increasecounter(action, amount)
    amount = amount or 1

    counters[action] = counters[action] or 0
    counters[action] = counters[action] + 1
end

--[[ Print all counters in the order specified by @ref{printorder} in a nicely formatted string
]]
function statcounters.printcounters()
    if next(counters) then
        local actionmessage = "";
        for i, v in ipairs(printorder) do
            if not (i == 1) then
                actionmessage = actionmessage .. ", "
            end

            if counters[v] == 1 then
                actionmessage = actionmessage .. "1 package " .. v
            else
                actionmessage = actionmessage .. (counters[v] or 0) .. " packages " .. v
            end
        end
        actionmessage = actionmessage .. "."

        properprint.pprint(actionmessage)
    end
end

-- ## END OF MODULE ##

return statcounters
