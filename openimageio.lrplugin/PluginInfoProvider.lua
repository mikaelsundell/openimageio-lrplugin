--
--  PluginInfoProvider.lua
--  openimageio.lrplugin
--
--  Copyright (c) 2023 - present Mikael Sundell.
--  All Rights Reserved.
--
--  openimageio.lrplugin is a lightroom plugin to post-process Lightroom exports
--  using openimageio image processing tools.

-- requires
require "PluginConfig"
require "PluginUtils"

-- imports
local LrColor = import "LrColor"
local LrView = import "LrView"
local LrDialogs = import 'LrDialogs'

local bind = LrView.bind
local plugin = _PLUGIN

-- plugin config
-- use { default = true } to default prefs
PluginConfig_init()

-- 
--  OpenImageIOPluginInfoProvider.lua
-- 

local OpenImageIOPluginInfoProvider = {}

-- actions
function OpenImageIO_open_oiiopath()
	PluginUtils.open_shell( PluginConfig.oiiotool_path )
end

function OpenImageIO_copy_oiiopath()
	PluginUtils.execute( "echo '" .. PluginConfig.oiiotool_path .. "' | pbcopy" )
end

function OpenImageIO_open_log()
	if ( PluginUtils.file_exists( PluginConfig.log_path ) ) then
		PluginUtils.open_app( { PluginConfig.log_path }, "/System/Applications/TextEdit.app" )
	else
		LrDialogs.message("OpenImageIO", "Could not open log path, enable 'Write log' and run export to create log file.")
	end
end

function OpenImageIO_copy_log()
	PluginUtils.execute( "echo '" .. PluginConfig.log_path .. "' | pbcopy" )
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
						title = PluginConfig.oiiotool_path,
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
						title = PluginConfig.log_path,
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
						value = bind { key = "log_write", bind_to_object = PluginPrefs }
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
