--[[ 
	Module to provide the main autocomplete function called by the shell

	Authors: PentagonLP 2021, 2025
	@module autocomplete
]]

-- Load module dependencies
local autocomplete_helpers_ccpt = _G.ccpt.loadmodule("autocomplete/autocomplete_helpers_ccpt")
local subcommands = _G.ccpt.loadmodule("subcommands")

-- Module interface table
local autocomplete = {}

-- ## START OF MODULE ##

--[[ Lookup array for autocomplete, holding functions needed to complete all parts of the 'ccpt'-command
	@table autocomplete_lookup
	@field <subcommandname> autocomplete_lookup_information Name of the subcommand as an index to specify for which subcommand the completion path stored under the index is for
	@table autocomplete_lookup_information
	@field func function to autocomplete the first parameter of the subcommand
	@field funcargs {...} Static parameters for the completion function, which will be unwraped and passed on to the funtion
	@field next autocomplete_lookup Autocomplete options for the parameter followed by the current one
]]
local autocomplete_data

--[[ Recursive function to go through the 'autocomplete' array and complete commands accordingly
	@tparam autocomplete_lookup lookup Part of the 'autocomplete' array to look autocomplete up in
	@tparam string lastText Numeric array of parameters before the current one
	@tparam string curText The already typed in text to.. complete...
	@tparam int iterator Last position in the lookup array
	@treturn {string,...} Availible complete options
]]
local function tabcompletehelper(lookup, lastText, curText, iterator)
	-- If table does not exist or is empty, no autocomplete data is availible
	if lookup[lastText[iterator]] == nil or next(lookup[lastText[iterator]]) == nil then
		return {}
	end

	-- If the parameter at the current is supposed to be autocompleted, call the according function from the lookup array
	if #lastText == iterator then
		return lookup[lastText[iterator]]["func"](curText, unpack(lookup[lastText[iterator]]["funcargs"]))
	-- If there is no parameter left to autocomplete in this parameter chain, return an empty result
	elseif lookup[lastText[iterator]]["next"] == nil then
		return {}
	-- If we are not yet at the end of the chain, make a recursive call to further traverse to the end
	else
		return tabcompletehelper(lookup[lastText[iterator]]["next"], lastText, curText, iterator + 1)
	end
end

--[[ Function to actually execute the tab completion, without error catching
	See also https://tweaked.cc/module/shell.html#v:setCompletionFunction; This function follows the interface specification of the completion function
	@tparam shell shell The current shell. As completion functions are inherited, this is not guaranteed to be the shell you registered this function in.
	@tparam int parNumber The index of the argument currently being completed.
	@tparam string curText The current argument. This may be the empty string.
	@tparam {string,...} lastText A list of the previous arguments.
	@treturn {string,...} Array of suggestions to autocomplete curText
]]
local function tabcomplete_executor(shell, parNumber, curText, lastText)
	-- Build lookup array if not done before
	if autocomplete_data == nil then
		autocomplete_data = {
			ccpt = {
				func = autocomplete_helpers_ccpt.completeaction,
				funcargs = {},
				next = {}
			}
		}
		for subcommand_name, subcommand_data in pairs(subcommands) do
			autocomplete_data.ccpt.next[subcommand_name] = subcommand_data.autocomplete
		end
	end

	-- Recursive function call to complete the last parameter in the chain specified by lastText
	return tabcompletehelper(autocomplete_data, lastText, curText or "", 1)
end

--[[ Function to execute the tab completion, registered by @ref{main} and called by the shell to autocomplete the 'ccpt' command. It does error catching for @ref{tabcomplete_executor}, which executes the actual autocomplete.
	See also https://tweaked.cc/module/shell.html#v:setCompletionFunction; This function follows the interface specification of the completion function
	@tparam shell shell The current shell. As completion functions are inherited, this is not guaranteed to be the shell you registered this function in.
	@tparam int parNumber The index of the argument currently being completed.
	@tparam string curText The current argument. This may be the empty string.
	@tparam {string,...} lastText A list of the previous arguments.
	@treturn {string,...} Array of suggestions to autocomplete curText
]]
function autocomplete.tabcomplete(shell, parNumber, curText, lastText)
	local success, retval = pcall(tabcomplete_executor, shell, parNumber, curText, lastText)

	if not success then
		print(retval)
		retval = {}
	end

	return retval
end

-- ## END OF MODULE ##

return autocomplete
