--[[ 
	Module to provide autocomplete functions needed by the different subcommands, e.g. to autocomplete package names

	Authors: PentagonLP 2021, 2025
	@module autocomplete_helpers_subcommands
]]

-- Load module dependencies
local autocomplete_common = _G.ccpt.loadmodule("autocomplete/autocomplete_common")
local fileutils = _G.ccpt.loadmodule("/lib/fileutils")

-- Module interface table
local autocomplete_helpers = {}

-- ## START OF MODULE ##

-- Cache for autocompleteable package IDs, if the user is currently typing a parameter
local autocompletepackagecache

--[[ Generate suggestions for a package ID the user has started to type
	@tparam string curText The currently typed start of the parameter which this function is supposed to generate suggestions for
	@tparam string filterstate nil to consider all known package IDs for suggestions, "installed" to only consider installed packages, "not installed" to only consider not installed packages
    @treturn {string,...} Array of suggestions to autocomplete curText
]]
function autocomplete_helpers.completepackageid(curText, filterstate)
	-- If we are starting over with a new parameter to complete, renew the cached package IDs in autocompletepackagecache
	if (autocompletepackagecache == nil) or (curText == "") or (curText == nil) then
		local packagedata = fileutils.readData(fs.combine(_G.ccpt.progdir, "packagedata"), false)
		if packagedata == false then
			autocompletepackagecache = nil
			return {}
		else
			autocompletepackagecache = packagedata
		end
	end

	-- If we should filter by any state, we need to load the information on what packages are installed
	local installedversions
	if not (filterstate == nil) then
		installedversions = fileutils.readData(fs.combine(_G.ccpt.progdir, "installedpackages"), true)
	end

	-- Add package IDs to result, according to the filterstate
	local result = {}
	for i, _ in pairs(autocompletepackagecache) do
		if filterstate == "installed" then
			if not (installedversions[i] == nil) then
				result = autocomplete_common.addtoresultifitfits(i, curText, result)
			end
		elseif filterstate == "not installed" then
			if installedversions[i] == nil then
				result = autocomplete_common.addtoresultifitfits(i, curText, result)
			end
		else
			result = autocomplete_common.addtoresultifitfits(i, curText, result)
		end
	end
	return result
end

--[[ Generate suggestions for a user-defined package ID the user has started to type
	@tparam string curText The currently typed start of the parameter which this function is supposed to generate suggestions for
    @treturn {string,...} Array of suggestions to autocomplete curText
]]
function autocomplete_helpers.completecustompackageid(curText)
	local custompackages = fileutils.readData(fs.combine(_G.ccpt.progdir, "custompackages"), true)

	local result = {}
	for i, _ in pairs(custompackages) do
		result = autocomplete_common.addtoresultifitfits(i, curText, result)
	end
	return result
end

-- ## END OF MODULE ##

return autocomplete_helpers
