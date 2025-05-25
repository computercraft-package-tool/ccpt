-- MISC HELPER FUNCTIONS --
--[[ Checks wether a String starts with another one
	@param String haystack: String to check wether is starts with another one
	@param String needle: String to check wether another one starts with it
	@return boolean result: Wether the firest String starts with the second one
]]--
function startsWith(haystack,needle)
	return string.sub(haystack,1,string.len(needle))==needle
end

--[[ Presents a choice in console to wich the user can anser with 'y' ('yes') or 'n' ('no'). Captialisation doesn't matter.
	@return boolean choice: The users choice
]]--
function ynchoice()
	while true do
		local input = io.read()
		if (input=="y") or (input == "Y") then
			return true
		elseif (input=="n") or (input == "N") then
			return false
		else
			print("Invalid input! Please use 'y' or 'n':")
		end
	end
end

--[[ Prints only if a given boolean is 'false'
	@param String text: Text to print
	@param boolean booleantocheck: Boolean wether not to print
]]--
function bprint(text, booleantocheck)
	if not booleantocheck then
		properprint.pprint(text)
	end
end

--[[ Converts an array to a String; array entrys are split with spaces
	@param Table array: The array to convert
	@param boolean|nil iterator|nil: If true, not the content but the address of the content within the array is converted to a string
	@return String convertedstring: The String biult from the array
]]--
function arraytostring(array,iterator)
	iterator = iterator or false
	local result = ""
	if iterator then
		for k,v in pairs(array) do
			result = result .. k .. " "
		end
	else
		for k,v in pairs(array) do
			result = result .. v .. " "
		end
	end
	return result
end

function regexEscape(str)
	return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end

function loadfolder(path)
    for i, v in ipairs(fs.list(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()), path))) do
        dofile(fs.combine(fs.combine(fs.getDir(_G.ccpt.shell.getRunningProgram()), path), v))
    end
end