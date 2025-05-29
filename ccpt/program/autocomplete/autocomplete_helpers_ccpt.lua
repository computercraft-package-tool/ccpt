local autocomplete_common = dofile(fs.combine(_G.ccpt.progdir, "program/autocomplete/autocomplete_common.lua"))
local misc = dofile(fs.combine(_G.ccpt.progdir, "program/misc.lua"))

local autocomplete_helpers_ccpt = {}

local completable_subcommands

-- Functions to complete different subcommands of a command
-- Complete action (eg. "update" or "list")
function autocomplete_helpers_ccpt.completeaction(curText)
	if completable_subcommands == nil then
        completable_subcommands = {}
        local subcommands = misc.loadfolder("program/subcommands")

		for subcommand_name, subcommand_data in pairs(subcommands) do
            -- Autocomplete only commmands which also appear in 'ccpt help'
            if (not (subcommand_data["comment"] == nil)) then
                table.insert(completable_subcommands, subcommand_name)
            end
		end
    end

    local result = {}
	for _, subcommand_name in pairs(completable_subcommands) do
		result = autocomplete_common.addtoresultifitfits(subcommand_name,curText,result)
	end
	return result
end

return autocomplete_helpers_ccpt