-- MAIN AUTOCOMLETE FUNCTION --
local autocomplete_helpers_ccpt = _G.ccpt.loadmodule("autocomplete/autocomplete_helpers_ccpt")
local subcommands = _G.ccpt.loadmodule("subcommands")

local autocomplete = {}

local autocomplete_data

--[[ Recursive function to go through the 'autocomplete' array and complete commands accordingly
	@param Table lookup: Part of the 'autocomplete' array to look autocomplete up in
	@param String lastText: Numeric array of parameters before the current one
	@param String curText: The already typed in text to.. complete...
	@param int iterator: Last position in the lookup array
	@return Table completeoptions: Availible complete options
]]--
local function tabcompletehelper(lookup,lastText,curText,iterator)
	-- If table does not exist or is empty, no autocomplete data is availible
	if lookup[lastText[iterator]]==nil or next(lookup[lastText[iterator]]) == nil then
		return {}
	end
	if #lastText==iterator then
		return lookup[lastText[iterator]]["func"](curText,unpack(lookup[lastText[iterator]]["funcargs"]))
	elseif lookup[lastText[iterator]]["next"]==nil then
		return {}
	else
		return tabcompletehelper(lookup[lastText[iterator]]["next"],lastText,curText,iterator+1)
	end
end

local function tabcomplete_errorsafe(shell, parNumber, curText, lastText)
	-- Build lookup array
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

	-- Recursive function call
	return tabcompletehelper(autocomplete_data, lastText, curText or "", 1)
end

function autocomplete.tabcomplete(shell, parNumber, curText, lastText)
    local success, retval = pcall(tabcomplete_errorsafe, shell, parNumber, curText, lastText)

	if not success then
		print(retval)
		retval = {}
	end

	return retval
end

return autocomplete