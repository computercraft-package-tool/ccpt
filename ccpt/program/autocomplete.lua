-- TAB AUTOCOMLETE HELPER FUNCTIONS --
--[[ Add Text to result array if it fits
	@param String option: Autocomplete option to check
	@param String texttocomplete: The already typed in text to.. complete...
	@param Table result: Array to add the option to if it passes the check
]]--
function addtoresultifitfits(option,texttocomplete,result)
	if startsWith(option,texttocomplete) then
		result[#result+1] = string.sub(option,#texttocomplete+1)
	end
	return result
end

-- Functions to complete different subcommands of a command
-- Complete action (eg. "update" or "list")
function completeaction(curText)
	local result = {}
	for i,v in pairs(_G.ccpt.autocomplete) do
		if (not (v["comment"] == nil)) then
			result = addtoresultifitfits(i,curText,result)
		end
	end
	return result
end

-- Complete packageid (filter can be nil to display all, "installed" to only recommend installed packages or "not installed" to only recommend not installed packages)
autocompletepackagecache = {}
function completepackageid(curText,filterstate)
	local result = {}
	if curText=="" or curText==nil then
		local packagedata = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../packagedata"),false)
		if not packagedata then
			return {}
		end
		autocompletepackagecache = packagedata
	end
    local installedversion
	if not (filterstate==nil) then
		installedversion = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../installedpackages"),true)
	end
	for i,v in pairs(autocompletepackagecache) do
		if filterstate=="installed" then
			if not (installedversion[i]==nil) then
				result = addtoresultifitfits(i,curText,result)
			end
		elseif filterstate=="not installed" then
			if installedversion[i]==nil then
				result = addtoresultifitfits(i,curText,result)
			end
		else
			result = addtoresultifitfits(i,curText,result)
		end
	end
	return result
end

-- Complete packageid, but only for custom packages, which is much simpler
function completecustompackageid(curText)
	local result = {}
	local custompackages = fileutils.readData(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()),"../../custompackages"),true)
	for i,v in pairs(custompackages) do
		result = addtoresultifitfits(i,curText,result)
	end
	return result
end

--[[ Recursive function to go through the 'autocomplete' array and complete commands accordingly
	@param Table lookup: Part of the 'autocomplete' array to look autocomplete up in
	@param String lastText: Numeric array of parameters before the current one
	@param String curText: The already typed in text to.. complete...
	@param int iterator: Last position in the lookup array
	@return Table completeoptions: Availible complete options
]]--
function tabcompletehelper(lookup,lastText,curText,iterator)
	if lookup[lastText[iterator]]==nil then
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

-- MAIN AUTOCOMLETE FUNCTION --
function tabcomplete(shell, parNumber, curText, lastText)
	local result = {}
	tabcompletehelper(
		{
			ccpt = autocomplete
		},
	lastText,curText or "",1)
	return result
end