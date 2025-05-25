--[[ 
	ComputerCraft Package Tool
	Author: PentagonLP
	Version: 1.1
]]

-- Load properprint library
os.loadAPI("lib/properprint")
-- Load fileutils library
os.loadAPI("lib/fileutils")
-- Load httputils library
os.loadAPI("lib/httputils")

dofile(fs.combine(fs.getDir(shell.getRunningProgram()),"../autocomplete.lua"))
dofile(fs.combine(fs.getDir(shell.getRunningProgram()),"../counters.lua"))
dofile(fs.combine(fs.getDir(shell.getRunningProgram()),"../misc.lua"))
dofile(fs.combine(fs.getDir(shell.getRunningProgram()),"../package.lua"))

-- Read arguments
local args = {...}

-- CONFIG ARRAYS --
_G.ccpt = {}

--[[ Array to store subcommands, help comment and function
]]--
_G.ccpt.subcommands = {}

--[[ Array to store different installation methodes and corresponding functions
]]--
_G.ccpt.installtypes = {}

--[[ Array to store autocomplete information
]]--
_G.ccpt.autocomplete = {
	func = completeaction,
	funcargs = {},
	next = {}
}

-- Pass shell onto submodules
_G.ccpt.shell = shell

-- Load variable submodules
loadfolder("../subcommands")
loadfolder("../installtypes")

-- Add to working path
if string.find(shell.path(),regexEscape(":.ccpt/program/shell"))==nil then
	shell.setPath(shell.path()..":.ccpt/program/shell")
end

-- Register autocomplete function
shell.setCompletionFunction(".ccpt/program/shell7ccpt.lua", tabcomplete)

-- Add to startup file to run at startup
local startup = fileutils.readFile("startup","") or ""
if string.find(startup,"shell.run(\".ccpt/program/ccpt\",\"startup\")",1,true)==nil then
	startup = "-- ccpt: Search for updates\nshell.run(\".ccpt/program/ccpt\",\"startup\")\n\n" .. startup
	fileutils.storeFile("startup",startup)
	print("[Installer] Startup entry created!")
end

-- Call required function
if #args==0 then
	properprint.pprint("Incomplete command, missing: 'Action'; Type 'ccpt help' for syntax.")
else
	if _G.ccpt.subcommands[args[1]]==nil then
		properprint.pprint("Action '" .. args[1] .. "' is unknown. Type 'ccpt help' for syntax.")
	else
		_G.ccpt.subcommands[args[1]]["func"](args)
	end
end

-- List stats of operations in this run
printcounters()