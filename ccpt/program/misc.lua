--[[ 
	Module to implement various helper functions used throughout the program

	Authors: PentagonLP 2021, 2025
	@module misc
]]

-- Load module dependencies
local properprint = _G.ccpt.loadmodule("/lib/properprint")

-- Module interface table
local misc = {}

-- ## START OF MODULE ##

--[[ Checks wether a String starts with another one
	@tparam string haystack String to check wether is starts with another one
	@tparam string needle String to check wether another one starts with it
	@treturn bool Wether the first string starts with the second one
]]
function misc.startsWith(haystack, needle)
	return string.sub(haystack, 1, string.len(needle)) == needle
end

--[[ Presents a choice in console to wich the user can anser with 'y' ('yes') or 'n' ('no'). Captialisation doesn't matter.
	@treturn boolean The users choice ('yes' => true, 'no' => false)
]]
function misc.ynchoice()
	while true do
		local input = io.read()
		if (input == "y") or (input == "Y") then
			return true
		elseif (input == "n") or (input == "N") then
			return false
		else
			print("Invalid input! Please use 'y' or 'n':")
		end
	end
end

--[[ Prints only if a given boolean is 'false'
	@tparam string text Text to print
	@tparam bool booleantocheck Boolean wether not to print
]]
function misc.bprint(text, booleantocheck)
	if not booleantocheck then
		properprint.pprint(text)
	end
end

--[[ Converts an array to a String; array entrys are split with spaces
	@tparam {string,...} array: The array to convert
	@tparam[opt] bool If true, not the content but the address of the content within the array is converted to a string
	@treturn string The String biult from the array
]]
function misc.arraytostring(array, iterator)
	iterator = iterator or false
	local result = ""
	if iterator then
		for k, _ in pairs(array) do
			result = result .. k .. " "
		end
	else
		for _, v in pairs(array) do
			result = result .. v .. " "
		end
	end
	return result
end

--[[ Escape the regex characters in a given string
	@tparam string str The string to escape
	@treturn string the escaped string
]]
function misc.regexEscape(str)
	return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end

--[[ Split string into array using a certain character as seperator
	@tparam string inputstr The string to split
	@tparam string sep The character to split by
	@treturn {string,...} The array of split strings
]]
function misc.splitstr(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

-- ## END OF MODULE ##

return misc
