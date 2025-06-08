This file is unfinished!
# Contributing Guidelines
## Repository structure
### About branches
This repository has no releases because of how the way CCPT updates itself. It always downloads its newest version from the main branch. There must be no commits changing CCPT's code directly to the main branch. The part of "packageinfo.ccpt" that is relevant to the installment process ("newestversion", "dependencies" and the "install"-section) must also not be directly commited to the main branch. Commiting to other files like the installer (after extensive testing! You are still affecting files that are needed in the ongoing operation!) is allowed.  
The next version of "CCPT" has its own branch where developement changes (eg. implementing a new feature or fixing a bug) have to be commited to. Once everything is tested and enough new features and bugfixes are impemented, a new version is released (don't forget to change the readme, social preview, packageinfo, documentation, and, if necessary, installer!) and the "version branch" is merged with the main branch.
### About the folder and file structure
```
ccpt  
| - .gitattributes: .gitattributes file for this repo  
| - .gitignore: .gitignore file for this repo  
| - CONTRIBUTING.md: This file :)  
| - LICENSE: License file under which ccpt is published   
| - README.md: Readme file for this repo  
| - ccpt: Main code file for CCPT (lua)  
| - ccptinstall.lua: Installer for CCPT (also hosted on pastebin) (lua)  
| - defaultpackages.ccpt: List of default packages able to be installed  
| - packageinfo.ccpt: packageinfo file for ccpt  
|  
| - .github: Github-related files  
|   \ - ISSUE_TEMPLATES: Templates to create issues  
|       | - apply-for-default-package-list.md: Template for applying for DPL  
|       | - bug_report.md: Template for applying for reporting a bug  
|       \ - feature_request.md: Template for requesting a feature  
|  
| - img: Images for Github presence  
|   | - (images used in readme)  
|   | - social-preview.gif: Social preview picture (Updating this does not automaticly change the social preview picture!)  
|   \ - work: Folder to store image presets like backgrounds and unexported gimp files  
|       \ - (raw image files and gimp files to reuse in new images)  
|  
\ - testing: Test data to test CCPT's features  
    \ - (different packageinfo files and other files only used for testing CCPT's features without habing to use real packages)
```

## Code structure
- If not specified otherwise in the following, [the comment structure used by LDoc](https://stevedonovan.github.io/ldoc/manual/doc.md.html) is used. Other features of LDoc (like e.g. module IDs) are currently not implemented.
- Every codefile must have the following comment making up the first few lines:
```lua
--[[ 
	<Purpose/function of the file>

	Authors: <GitHub username> <year(s), ranges allowed>
			 <GitHub username> <year(s), ranges allowed>
			 ...
	<@module-tag if required for this file>
]]
```
- Modules should announce the beginnning and end of their implementation code, using the comments ```## START OF MODULE ##``` and ```## END OF MODULE ##``` as delimiters:
```lua
--[[
	<File header comment>
]]

-- Load module dependencies
local mydependency = _G.ccpt.loadmodule(...)
...

-- Module interface table
local interfacetable = {}

-- ## START OF MODULE ##

--[[
	<Function header comment>
]]
function interfacetable.myfunction()
	...
end

...

-- ## END OF MODULE ##

return interfacetable
```
- All functions that don't just do one thing, but follow different steps, one after the other (like first fetch a file, then store it somewhere) in order to achive a result, must have these different steps commented.
## Dealing with issues
The first thing to do when dealing with an issue is always to write a comment that you are dealing with the issue so that no issue is dealt with by two people at the same time!
## Process applies for default package list
TODO
