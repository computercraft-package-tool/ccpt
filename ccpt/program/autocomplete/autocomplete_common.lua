local misc = dofile(fs.combine(_G.ccpt.progdir, "program/misc.lua"))

local autocomplete_common = {}

--[[ Add Text to result array if it fits
	@param String option: Autocomplete option to check
	@param String texttocomplete: The already typed in text to.. complete...
	@param Table result: Array to add the option to if it passes the check
]]--
function autocomplete_common.addtoresultifitfits(option,texttocomplete,result)
	if misc.startsWith(option,texttocomplete) then
		result[#result+1] = string.sub(option,#texttocomplete+1)
	end
	return result
end

return autocomplete_common