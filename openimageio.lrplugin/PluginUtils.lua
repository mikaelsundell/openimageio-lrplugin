--
--  PluginInit.lua
--  openimageio.lrplugin
--
--  Copyright (c) 2023 - present Mikael Sundell.
--  All Rights Reserved.
--
--  openimageio.lrplugin is a lightroom plugin to post-process Lightroom exports
--  using openimageio image processing tools.

-- imports
local LrPathUtils = import 'LrPathUtils'
local LrFileUtils = import 'LrFileUtils'
local LrColor = import 'LrColor'
local LrShell = import "LrShell"
local LrTasks = import "LrTasks"

-- 
--  PluginUtils.lua
-- 

PluginUtils = {}

-- files
function PluginUtils.read_file( file_path )
	local f = io.open(file_path, "r")
    local data = f:read("*all")
    f:close()
    return data
end

-- paths
function PluginUtils.get_home()
    return LrPathUtils.getStandardFilePath( "home" )
end

function PluginUtils.file_exists( file )
    return LrFileUtils.exists( file )
end

-- system
function PluginUtils.execute( command )
    LrTasks.execute( command ) -- will not block application
end

function PluginUtils.open_shell( command )
	LrShell.revealInShell( command )
end

function PluginUtils.open_app( arguments, app )
    LrShell.openFilesInApp( arguments, app )
end

-- string
function PluginUtils.string_to_number( number )
    if number >= 0 then
        return string.format("+%d", number)
    else
        return number
    end
end

-- tables
function PluginUtils.color_to_table( color )
    return { red = color:red(), green = color:green(), blue = color:blue(), alpha = color:alpha() }
end

function PluginUtils.table_to_color( table )
    return LrColor(table.red, table.green, table.blue, table.alpha)
end

function PluginUtils.rgba_to_color( red, green, blue, alpha )
    return LrColor(red, green, blue, alpha)
end

-- math
function PluginUtils.transform_format( format, image )
    return {
        x = (format.width - image.width) / 2,
        y = (format.height - image.height) / 2
    }
end
