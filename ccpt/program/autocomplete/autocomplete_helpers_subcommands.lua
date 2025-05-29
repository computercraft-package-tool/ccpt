-- TAB AUTOCOMLETE HELPER FUNCTIONS --
local autocomplete_common = dofile(fs.combine(_G.ccpt.progdir, "program/autocomplete/autocomplete_common.lua"))
local misc = dofile(fs.combine(_G.ccpt.progdir, "program/misc.lua"))

local autocomplete_helpers = {}

-- Complete packageid (filter can be nil to display all, "installed" to only recommend installed packages or "not installed" to only recommend not installed packages)
_G.ccpt.autocompletepackagecache = {}
function autocomplete_helpers.completepackageid(curText,filterstate)
	local result = {}
	if curText=="" or curText==nil then
		local packagedata = fileutils.readData(fs.combine(_G.ccpt.progdir,"packagedata"),false)
		if not packagedata then
			return {}
		end
		_G.ccpt.autocompletepackagecache = packagedata
	end
    local installedversion
	if not (filterstate==nil) then
		installedversion = fileutils.readData(fs.combine(_G.ccpt.progdir,"installedpackages"),true)
	end
	for i,v in pairs(_G.ccpt.autocompletepackagecache) do
		if filterstate=="installed" then
			if not (installedversion[i]==nil) then
				result = autocomplete_common.addtoresultifitfits(i,curText,result)
			end
		elseif filterstate=="not installed" then
			if installedversion[i]==nil then
				result = autocomplete_common.addtoresultifitfits(i,curText,result)
			end
		else
			result = autocomplete_common.addtoresultifitfits(i,curText,result)
		end
	end
	return result
end

-- Complete packageid, but only for custom packages, which is much simpler
function autocomplete_helpers.completecustompackageid(curText)
	local result = {}
	local custompackages = fileutils.readData(fs.combine(_G.ccpt.progdir,"custompackages"),true)
	for i,v in pairs(custompackages) do
		result = autocomplete_common.addtoresultifitfits(i,curText,result)
	end
	return result
end

return autocomplete_helpers