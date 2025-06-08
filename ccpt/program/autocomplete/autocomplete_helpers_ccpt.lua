--[[ 
	Module to provide functions hat the main.lua file needs to autocomplete the main command

	Authors: PentagonLP 2021, 2025
	@module autocomplete_helpers_ccpt
]]

-- Load module dependencies
local autocomplete_common = _G.ccpt.loadmodule("autocomplete/autocomplete_common")
local subcommands = _G.ccpt.loadmodule("subcommands")

-- Module interface table
local autocomplete_helpers_ccpt = {}

-- ## START OF MODULE ##

-- Cache for all possible subcommands to complete
local completable_subcommands

--[[ Generate suggestions for the subcommand the user has started to type
	@tparam string curText The currently typed start of the parameter which this function is supposed to generate suggestions for
    @treturn {string,...} Array of suggestions to autocomplete curText
]]
function autocomplete_helpers_ccpt.completeaction(curText)
    -- Collect and cache all completable subcommands
    if completable_subcommands == nil then
        completable_subcommands = {}

        for subcommand_name, subcommand_data in pairs(subcommands) do
            -- Autocomplete only commmands which allow it by adding at least an empty table to the 'autocomplete' field of their module table
            if (not (subcommand_data["autocomplete"] == nil)) then
                table.insert(completable_subcommands, subcommand_name)
            end
        end
    end

    -- Filter completable_subcommands to only return the suggestions which fit curText
    local result = {}
    for _, subcommand_name in pairs(completable_subcommands) do
        result = autocomplete_common.addtoresultifitfits(subcommand_name, curText, result)
    end
    return result
end

-- ## END OF MODULE ##

return autocomplete_helpers_ccpt
