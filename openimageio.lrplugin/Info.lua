--
--  PluginInfoProvider.lua
--  openimageio.lrplugin
--
--  Copyright (c) 2022 - present Mikael Sundell.
--  All Rights Reserved.
--
--  openimageio.lrplugin is a lightroom plugin to post-process Lightroom exports
--  using openimageio image processing tools.

local OpenImageIOInfo = {

	-- sdk
	LrSdkVersion = 4.0,
	LrSdkMinimumVersion = 3.0,

	-- plugin info
	LrPluginName = "OpenImageIO",
	LrToolkitIdentifier = 'com.github.openimageio.lrplugin',
	LrPluginInfoUrl = "https://github.com/mikaelsundell/openimageio-lrplugin",

	-- plugin manager
	LrPluginInfoProvider = 'PluginInfoProvider.lua',

	-- export filter
	LrExportFilterProvider = {
		title = "Post-Process with OpenImageIO",
		file = 'OpenImageIOFilterProvider.lua',
		id = 'OpenImageIO',
		sectionsForTopOfDialog = function( viewFactory, propertyTable ) 
			return {
				title = "About OpenImageIO.lrplugin",
				viewFactory:row {
					viewFactory:static_text {
						title = "openimageio.lrplugin is a lightroom plugin to post-process Lightroom exports using openimageio image processing tools",
					},
				},
			}
		end
	},

	-- version
	VERSION = { major=0, minor=0, revision=1, build=0, },
}

return OpenImageIOInfo