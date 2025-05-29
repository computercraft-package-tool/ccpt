--[[ 
	ComputerCraft Package Tool
	Author: PentagonLP
	Version: 1.1
]]

-- Initialize global ccpt namespace
_G.ccpt = {}
-- Set program directory
_G.ccpt.progdir = fs.combine(fs.getDir(shell.getRunningProgram()), "../../")
-- Pass shell onto submodules
_G.ccpt.shell = shell
-- Initialize statcouters array
_G.ccpt.statcounters = {}

-- Load properprint library
os.loadAPI("lib/properprint")
-- Load fileutils library
os.loadAPI("lib/fileutils")
-- Load httputils library
os.loadAPI("lib/httputils")

local autocomplete = dofile(fs.combine(_G.ccpt.progdir, "program/autocomplete/autocomplete.lua"))
local misc = dofile(fs.combine(_G.ccpt.progdir, "program/misc.lua"))
local statcounters = dofile(fs.combine(_G.ccpt.progdir, "program/statcounters.lua"))

-- Read arguments
local args = {...}

-- Load variable submodules for subcommands
local subcommands = misc.loadfolder("program/subcommands")

-- Add to working path
local workingpathentry = ":" .. fs.combine(_G.ccpt.progdir, "program/shell")
if string.find(shell.path(), misc.regexEscape(workingpathentry)) == nil then
	shell.setPath(shell.path() .. workingpathentry)
end

-- Register autocomplete function
shell.setCompletionFunction(shell.getRunningProgram(), autocomplete.tabcomplete)

-- Add to startup file to run at startup
local startup = fileutils.readFile("startup","") or ""
if string.find(startup,"shell.run(\"" .. shell.getRunningProgram() .. "\",\"startup\")",1,true)==nil then
	startup = "-- ccpt: Search for updates\nshell.run(\"" .. shell.getRunningProgram() .. "\",\"startup\")\n\n" .. startup
	fileutils.storeFile("startup",startup)
	print("[Installer] Startup entry created!")
end

-- Call required function
if #args==0 then
	properprint.pprint("Incomplete command, missing: 'Action'; Type 'ccpt help' for syntax.")
else
	if subcommands[args[1]]==nil then
		properprint.pprint("Action '" .. args[1] .. "' is unknown. Type 'ccpt help' for syntax.")
	else
		subcommands[args[1]]["func"](args)
	end
end

-- List stats of operations in this run
statcounters.printcounters()