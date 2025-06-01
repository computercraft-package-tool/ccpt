-- TAB AUTOCOMLETE HELPER FUNCTIONS --
local autocomplete_common = _G.ccpt.loadmodule("autocomplete/autocomplete_common")
local fileutils = _G.ccpt.loadmodule("/lib/fileutils")

local autocomplete_helpers = {}

-- Complete packageid (filter can be nil to display all, "installed" to only recommend installed packages or "not installed" to only recommend not installed packages)
local autocompletepackagecache = {}
function autocomplete_helpers.completepackageid(curText, filterstate)
	local result = {}
	if (curText == "") or (curText == nil) then
		local packagedata = fileutils.readData(fs.combine(_G.ccpt.progdir, "packagedata"), false)
		if not packagedata then
			return {}
		end
		autocompletepackagecache = packagedata
	end
    local installedversion
	if not (filterstate == nil) then
		installedversion = fileutils.readData(fs.combine(_G.ccpt.progdir, "installedpackages"), true)
	end
	for i, _ in pairs(autocompletepackagecache) do
		if filterstate == "installed" and not (installedversion[i] == nil) then
			result = autocomplete_common.addtoresultifitfits(i, curText, result)
		elseif filterstate == "not installed" and installedversion[i] == nil then
			result = autocomplete_common.addtoresultifitfits(i, curText, result)
		else
			result = autocomplete_common.addtoresultifitfits(i, curText, result)
		end
	end
	return result
end

-- Complete packageid, but only for custom packages, which is much simpler
function autocomplete_helpers.completecustompackageid(curText)
	local result = {}
	local custompackages = fileutils.readData(fs.combine(_G.ccpt.progdir, "custompackages"), true)
	for i, _ in pairs(custompackages) do
		result = autocomplete_common.addtoresultifitfits(i, curText, result)
	end
	return result
end

return autocomplete_helpers