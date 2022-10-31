--
--  PluginInfoProvider.lua
--  openimageio.lrplugin
--
--  Copyright (c) 2022 - present Mikael Sundell.
--  All Rights Reserved.
--
--  openimageio.lrplugin is a lightroom plugin to post-process Lightroom exports
--  using openimageio image processing tools.

-- requires
require "PluginPrefs"
require "PluginLog"
require "PluginUtils"

-- imports
local LrColor = import "LrColor"
local LrView = import "LrView"

local bind = LrView.bind
local plugin = _PLUGIN

-- plugin prefs
-- use { default = true } to default prefs
PluginPrefs_init()

-- plugin log
PluginLog_init()

-- 
--  OpenImageIOPluginInfoProvider.lua
-- 

local OpenImageIOPluginInfoProvider = {}

-- actions
function OpenImageIO_open_oiiopath()
	PluginUtils.open_shell( PluginPrefs.oiiotool_path )
end

function OpenImageIO_copy_oiiopath()
	PluginUtils.execute( "echo '" .. PluginPrefs.oiiotool_path .. "' | pbcopy" )
end

function OpenImageIO_open_log()
	PluginUtils.open_app( { PluginLog.log_path }, "/System/Applications/TextEdit.app" )
end

function OpenImageIO_copy_log()
	PluginUtils.execute( "echo '" .. PluginLog.log_path .. "' | pbcopy" )
end

-- dialog
function OpenImageIOPluginInfoProvider.sectionsForTopOfDialog( viewFactory, propertyTable )
	return {
			{
				title = "OpenImageIO",
				synopsis = "Collapsed Description",

				viewFactory:row {
					spacing = viewFactory:control_spacing(),
					viewFactory:static_text {
						title = "OpenImageIO",
						font = "<system/bold>",
					},
				},
				viewFactory:row({
					spacing = viewFactory:control_spacing(),
					viewFactory:static_text({
						title = "OIIO tool",
						width_in_chars = 5
					}),
					viewFactory:static_text({
						title = PluginPrefs.oiiotool_path,
						width_in_chars = 45,
						size = "mini"
					}),
					viewFactory:push_button({
						title = "Show in finder",
						action = function()
							OpenImageIO_open_oiiopath()
						end,
					}),
					viewFactory:push_button({
						title = "Copy",
						action = function()
							OpenImageIO_copy_oiiopath()
						end,
					})
				}),
				viewFactory:row({
					spacing = viewFactory:control_spacing(),
					viewFactory:static_text({
						title = "Log path",
						width_in_chars = 5
					}),
					viewFactory:static_text({
						title = PluginLog.log_path,
						width_in_chars = 45,
						size = "mini"				
					}),
					viewFactory:push_button({
						title = "Show in finder",
						action = function()
							OpenImageIO_open_log()
						end,
					}),
					viewFactory:push_button({
						title = "Copy",
						action = function()
							OpenImageIO_copy_log()
						end,
					})
				}),
				viewFactory:row({
					spacing = viewFactory:control_spacing(),
					viewFactory:static_text({
						title = "Write log",
						width_in_chars = 5
					}),
					viewFactory:checkbox({
						value = bind { key = "write_log", bind_to_object = PluginPrefs }
					}),
				}),

			},
		}
end

-- sections for bottom of dialog in plugin manager
function OpenImageIOPluginInfoProvider.sectionsForBottomOfDialog( viewFactory, propertyTable )
	return {
			{
				title = "Licenses",
				synopsis = "Collapsed Description",

				viewFactory:row {
					spacing = viewFactory:control_spacing(),
					viewFactory:static_text {
						title = "OpenImageIO License",
						font = "<system/bold>",
					},
				},
				viewFactory:row {
					spacing = viewFactory:control_spacing(),
					viewFactory:static_text {
						title = PluginUtils.read_file( plugin:resourceId("oiiotool/license.txt") ),
					},
				},
			},
		}
end

return OpenImageIOPluginInfoProvider
