--[[ 
	Module to provide shared functions for the autocomplete system

	Authors: PentagonLP 2021, 2025
	@module autocomplete_common
]]

-- Load module dependencies
local misc = _G.ccpt.loadmodule("misc")

-- Module interface table
local autocomplete_common = {}

-- ## START OF MODULE ##

--[[ Add Text to result array if the suggestion fits with the already typed text
	@tparam string option Autocomplete option to check
	@tparam string texttocomplete The already typed in text to complete
	@tparam {string,...} result Array to add the option to if it passes the check
    @treturn {string,...} Array with added the option, if it passed the check
]]
function autocomplete_common.addtoresultifitfits(option, texttocomplete, result)
    if misc.startsWith(option, texttocomplete) then
        result[#result + 1] = string.sub(option, #texttocomplete + 1)
    end
    return result
end

-- ## END OF MODULE ##

return autocomplete_common
