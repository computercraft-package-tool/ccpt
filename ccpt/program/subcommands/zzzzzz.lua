--[[ 
	Subcommand to create a hole in the ground

	Authors: PentagonLP 2021, 2025
	@module zzzzzz
]]

-- Load module dependencies
local properprint = _G.ccpt.loadmodule("/lib/properprint")

-- Module interface table
local zzzzzz = {}

-- ## START OF MODULE ##

--[[ Print a scientific description of what just happend
	 https://en.wikipedia.org/wiki/Ohnosecond
]]
function zzzzzz.func()
	properprint.pprint("The 'ohnosecond':")
	properprint.pprint("An 'ohnosecond' is the second after one makes a terrible mistake, such as deleting the wrong file or sending a text message to the wrong person, where the person in question can do nothing but say 'oh no'.")
	properprint.pprint("(Oh, and please fix the hole you've created)")
end

-- ## END OF MODULE ##

return zzzzzz
