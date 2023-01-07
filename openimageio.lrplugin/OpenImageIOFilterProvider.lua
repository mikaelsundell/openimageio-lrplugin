--
--  OpenImageIOFilterProvider.lua
--  openimageio.lrplugin
--
--  Copyright (c) 2023 - present Mikael Sundell.
--  All Rights Reserved.
--
--  openimageio.lrplugin is a lightroom plugin to post-process Lightroom exports
--  using openimageio image processing tools.

require "PluginConfig"

-- imports
local LrLogger = import 'LrLogger'
local LrView = import "LrView"
local LrTasks = import "LrTasks"
local LrBinding = import "LrBinding"
local LrFunctionContext = import "LrFunctionContext"

-- Common shortcuts
local bind = LrView.bind

-- plugin config
-- use { default = true } to default prefs
PluginConfig_init()

-- 
--  OpenImageIOFilterProvider.lua
-- 

-- openimageio filter provider
local OpenImageIOFilterProvider = {}

-- export fields
-- note: the export preset fields are stored after 'Export',
-- default values are used only on the first invocation.
OpenImageIOFilterProvider.exportPresetFields = {
	-- general
	{ key = 'force_srgb', default = false },
	-- formats
	{ key = 'turn_on_formats', default = false },
	{ key = 'four_k', default = false },
	{ key = 'scale', default = 100 },
	{ key = 'aspect_ratio', default = 
		{ key = "Original", value = { 2048, 2048 } } 
	},
	{ key = 'aspect_ratio_width', default = 0 },
	{ key = 'aspect_ratio_height', default = 0 },
	{ key = 'show_resolution', default = false },
	{ key = 'background', default = 
		{
			{ key = 'red', default = '0' },
			{ key = 'green', default = '0' },
			{ key = 'blue', default = '0' },
			{ key = 'alpha', default = '1' },
		},
	},
}

function OpenImageIOFilterProvider.getAspectRatioResolution( propertyTable )
	-- aspect ratio
	aspectRatio = propertyTable.aspect_ratio.value
	_width = aspectRatio.width
	_height = aspectRatio.height
	-- 4k
	if propertyTable.four_k then
		_width = _width * 2
		_height = _height * 2
	end
	return { width = _width, height = _height }
end

function OpenImageIOFilterProvider.updateAspectRatioFields( propertyTable )
	-- resolution
	resolution = OpenImageIOFilterProvider.getAspectRatioResolution( propertyTable )
	width = resolution.width
	height = resolution.height

	if not (propertyTable.aspect_ratio_width == width) then
		propertyTable.aspect_ratio_width = width
	end

	if not (propertyTable.aspect_ratio_height == height) then
		propertyTable.aspect_ratio_height = height
	end

end

function OpenImageIOFilterProvider.updateExportPresetFields( propertyTable, key, value )
	-- aspect ratio
	if (key == "aspect_ratio" ) then
		if (value.key == "Original") then
			propertyTable.show_resolution = false
		else
			propertyTable.show_resolution = true
		end
		-- skip custom aspect ratio
		if not (value.key == "Custom") then
			OpenImageIOFilterProvider.updateAspectRatioFields( propertyTable )
		end
		
	-- width
	elseif (key == "aspect_ratio_width" ) then
		resolution = OpenImageIOFilterProvider.getAspectRatioResolution( propertyTable )
		width = resolution.width

		if not (width == value) then
			-- set custom aspect ratio
			if not (propertyTable.aspect_ratio.key == "Custom") then
				propertyTable.aspect_ratio = OpenImageIOFilterProvider.getAspectRatioFieldByName("Custom")
			end
		end

	-- height
	elseif (key == "aspect_ratio_height") then
		resolution = OpenImageIOFilterProvider.getAspectRatioResolution( propertyTable )
		width = resolution.height

		if not (height == value) then
			-- set custom aspect ratio
			if not (propertyTable.aspect_ratio.key == "Custom") then
				propertyTable.aspect_ratio = OpenImageIOFilterProvider.getAspectRatioFieldByName("Custom")
			end
		end
	elseif (key == "four_k") then

		-- skip custom aspect ratio
		if not (propertyTable.aspect_ratio.key == "Custom") then		
			OpenImageIOFilterProvider.updateAspectRatioFields( propertyTable )
		end
	end
end

-- user data fields
-- note: userdata types are not supported in export preset fields, 
-- translate to tables and update when changed
OpenImageIOFilterProvider.exportUserDataFields = {}

function OpenImageIOFilterProvider.updateUserDataFields( propertyTable, key, value )
	if (key == "background") then
		propertyTable.table.background = PluginUtils.color_to_table(value)

	end
end

-- background
-- note: may seem overambitious but needed if rendering is done 
-- during first invocation using default values.
function OpenImageIOFilterProvider.getBackground( propertyTable )
	if (propertyTable.background["red"] and propertyTable.background["green"] and
		propertyTable.background["blue"] and propertyTable.background["alpha"] ) then
		return propertyTable.background
	else
		return PluginUtils.color_to_table(exportUserDataFields.background)
	end
end

-- 
-- aspect ratio fields
-- note: popup_menu bind to value of pair for aspect ratio fields,
-- title and key need to be identical for correct lookup as resolutions
-- only are not unique across entries.
OpenImageIOFilterProvider.aspectRatioFields = {
	{ title = "Original", value = { key = "Original", value = { width = 0, height = 0 } } },
	{ separator = true }, 
	{ title = "  1:1 ", value = { key = "1:1", value = { width = 2048, height = 2048 } } },
	{ title = "  2:3 ", value = { key = "2:3", value = { width = 2048, height = 3072 } } },
	{ title = "  3:1", value = { key = "3:1", value = { width = 2048, height = 683 } } },
	{ title = "  4:3", value = { key = "4:3", value = { width = 2048, height = 1536 } } },
	{ title = "  4:7", value = { key = "4:7", value = { width = 2048, height = 3584 } } },
	{ title = "  5:5", value = { key = "5:5", value = { width = 2048, height = 2048 } } },
	{ title = "  1.33:1 ", value = { key = "1.33:1", value = { width = 2048, height = 1540 } } },
	{ title = "  1.85:1", value = { key = "1.85:1", value = { width = 2048, height = 1107 } } },
	{ title = "  9:16", value = { key = "9:16", value = { width = 2048, height = 3641 } } },
	{ title = "  16:9", value = { key = "16:9", value = { width = 2048, height = 1152 } } },
	{ title = "  16:10", value = { key = "16:10", value = { width = 2048, height = 1280 } } },
	{ separator = true }, 
	{ title = "  DCI FF 1.90:1", value = { key = "DCI FF 1.90:1", value = { width = 2048, height = 1080 } } },
	{ title = "  DCI Cinemascope 2.39:1",	value = { key = "DCI Cinemascope 2.39:1", value = { width = 2048, height = 858 } } },
	{ title = "  DCI flat cropped 1.85:1",	value = { key = "DCI flat cropped 1.85:1", value = { width = 1998, height = 1080 } } },
	{ separator = true }, 
	{ title = "  35mm 3:2", value = { key = "35mm 3:2", value = { width = 2048, height = 1365 } } },
	{ title = "  MF 56mm 6x6 1:1", value = { key = "MF 56mm 6x6 1:1", value = { width = 2048, height = 2048 } } },
	{ title = "  IMAX 1.43:1", value = { key = "IMAX 1.43:1", value = { width = 2048, height = 1432 } } },
	{ separator = true },
	{ title = "Custom", value = { key = "Custom", value = { width = 2048, height = 2048 } } },
}

function OpenImageIOFilterProvider.getAspectRatioFieldByName( name )
	for i, aspectRatio in pairs( OpenImageIOFilterProvider.aspectRatioFields ) do
		if ( aspectRatio.title == name ) then
			return aspectRatio.value
		end
	end
end

function OpenImageIOFilterProvider.getAspectRatioFieldByResolution( width, height )
	for i, aspectRatio in pairs( OpenImageIOFilterProvider.aspectRatioFields ) do
		if aspectRatio.value.width == width and aspectRatio.value.height then
			return value.value
		end
	end
end

-- start dialog
function OpenImageIOFilterProvider.startDialog( propertyTable )

	LrFunctionContext.callWithContext("startDialog", function( context ) 
		exportUserDataFields = LrBinding.makePropertyTable( context )
	end)
	-- export user data fields
	-- note: background contains default values from exportPresetFields
	-- during first invocation. Fill in values from property table if
	-- exists else initialise to default color
	if (propertyTable.background["red"] and propertyTable.background["green"] and
		propertyTable.background["blue"] and propertyTable.background["alpha"] ) then
		exportUserDataFields.background = PluginUtils.table_to_color(propertyTable.background)
	else
		exportUserDataFields.background = PluginUtils.rgba_to_color(0, 0, 0, 1)
	end
	exportUserDataFields.table = propertyTable
	-- observers
	propertyTable:addObserver('four_k', OpenImageIOFilterProvider.updateExportPresetFields)
	propertyTable:addObserver('aspect_ratio', OpenImageIOFilterProvider.updateExportPresetFields)
	propertyTable:addObserver('aspect_ratio_width', OpenImageIOFilterProvider.updateExportPresetFields)
	propertyTable:addObserver('aspect_ratio_height', OpenImageIOFilterProvider.updateExportPresetFields)
	exportUserDataFields:addObserver('background', OpenImageIOFilterProvider.updateUserDataFields)
end

-- action dialog
function OpenImageIOFilterProvider.sectionForFilterInDialog( viewFactory, propertyTable )

	OpenImageIOFilterProvider.startDialog(propertyTable)
	return {
		title = 'Post-processing with OpenImageIO',

		-- general
		viewFactory:row({
			spacing = viewFactory:control_spacing(),
			viewFactory:static_text {
				title = "General",
				font = "<system/small/bold>",
			},			
		}),
		viewFactory:row({
			spacing = viewFactory:control_spacing(),
			viewFactory:static_text({
				title = "Force sRGB",
				width_in_chars = 10,
			}),
			viewFactory:checkbox {
				value = bind { key = "force_srgb", bind_to_object = propertyTable }
			},		
		}),			
		-- aspect ratio
		viewFactory:row({
			spacing = viewFactory:control_spacing(),
			viewFactory:static_text {
				title = "Formats",
				font = "<system/small/bold>",
			},			
		}),
		viewFactory:row({
			spacing = viewFactory:control_spacing(),
			viewFactory:static_text({
				title = "Turn on",
				width_in_chars = 10
			}),
			viewFactory:checkbox {
				value = bind { key = "turn_on_formats", bind_to_object = propertyTable }
			},				
		}),
		viewFactory:row({
			spacing = viewFactory:control_spacing(),
			viewFactory:static_text({
				title = "4K",
				width_in_chars = 10,
				enabled = LrBinding.keyEquals( "turn_on_formats", true, propertyTable ),
			}),
			viewFactory:checkbox {
				value = bind { key = "four_k", bind_to_object = propertyTable },
				enabled = LrBinding.keyEquals( "turn_on_formats", true, propertyTable ),
			},				
		}),
		viewFactory:row({
			spacing = viewFactory:control_spacing(),
			viewFactory:static_text({
				title = "Scale",
				width_in_chars = 10,
				enabled = LrBinding.keyEquals( "turn_on_formats", true, propertyTable ),
			}),
			viewFactory:edit_field({
				value = bind { key = "scale", bind_to_object = propertyTable },
				enabled = LrBinding.keyEquals( "turn_on_formats", true, propertyTable ),
				immediate = true,
				width_in_chars = 2,
				min = 50,
				max = 150,
				precision = 1,
			}),
			viewFactory:slider({
				value = bind { key = "scale", bind_to_object = propertyTable },
				enabled = LrBinding.keyEquals( "turn_on_formats", true, propertyTable ),
				min = 50,
				max = 150,
				size = "regular",
				integral = true,
				fill_horizontal = 1,
			}),
		}),
		viewFactory:row({
			spacing = viewFactory:control_spacing(),
			viewFactory:static_text({
				title = "Aspect ratio",
				width_in_chars = 10,
				enabled = LrBinding.keyEquals( "turn_on_formats", true, propertyTable ),
			}),
			viewFactory:popup_menu {
				value = bind { key = "aspect_ratio", bind_to_object = propertyTable },
				items = OpenImageIOFilterProvider.aspectRatioFields,
				enabled = LrBinding.keyEquals( "turn_on_formats", true, propertyTable ),
				value_equal = function( value1, value2 )
					return ( value1.key == value2.key )
				end,
			},
			viewFactory:edit_field({
				value = bind { key = "aspect_ratio_width", bind_to_object = propertyTable },
				enabled = LrBinding.keyEquals( "turn_on_formats", true, propertyTable ),
				visible = bind { key = "show_resolution", bind_to_object = propertyTable },
				immediate = true,
				min = 1,
				max = 32767,
				width_in_chars = 5,
				precision = 1,
			}),
			viewFactory:static_text({
				title = "x",
				enabled = LrBinding.keyEquals( "turn_on_formats", true, propertyTable ),
				visible = bind { key = "show_resolution", bind_to_object = propertyTable },
			}),
			viewFactory:edit_field({
				value = bind { key = "aspect_ratio_height", bind_to_object = propertyTable },
				enabled = LrBinding.keyEquals( "turn_on_formats", true, propertyTable ),
				visible = bind { key = "show_resolution", bind_to_object = propertyTable },
				immediate = true,
				min = 1,
				max = 32767,
				width_in_chars = 5,
				precision = 1,
			}),
		}),
		viewFactory:row({
			spacing = viewFactory:control_spacing(),

			viewFactory:column({
				margin_top = 5,
				margin_left = 0,
	
				viewFactory:static_text({
					title = "Background",
					enabled = LrBinding.keyEquals( "turn_on_formats", true, propertyTable ),
					width_in_chars = 10,
					margin_left = 15,
				}),
			}),
			viewFactory:column ({
				margin_top = 0,
				margin_left = 0,

				viewFactory:color_well ({
					value = bind { key = "background", bind_to_object = exportUserDataFields },
					enabled = LrBinding.keyEquals( "turn_on_formats", true, propertyTable ),
				}),
			}),
		}),		
	}
end

function OpenImageIOFilterProvider.postProcessRenderedPhotos(functionContext, filterContext )
	local propertyTable = filterContext.propertyTable

	local renditionOptions = {
		filterSettings = function( renditionToSatisfy, exportSettings )
			-- force srgb
			if propertyTable.force_srgb then
				-- log export settings
				LogExportSettings( exportSettings )

				LR_export_colorSpace = "sRGB"
			end		
		end,
	}

	for sourceRendition, renditionToSatisfy in filterContext:renditions( renditionOptions ) do
		-- wait for the upstream task to finish its work on this photo. 
		local success, pathOrMessage = sourceRendition:waitForRender()

		-- post processing
		if propertyTable.turn_on_formats then

			if success then 
				LogInfo("Post processing photo")

				local photo = sourceRendition.photo
				if photo:getRawMetadata( "isCropped" ) then
					dimensions = photo:getRawMetadata( "croppedDimensions" )
				else
					dimensions = photo:getRawMetadata( "dimensions" )
				end

				-- aspect ratio
				width = propertyTable.aspect_ratio_width
				height = propertyTable.aspect_ratio_height
				
				LogInfo("width: " .. width)

				-- photo
				photo_width = dimensions.width
				photo_height = dimensions.height
				relative_scale = 0
				
				if photo_width > photo_height then
					relative_scale = width / photo_width
				else
					relative_scale = height / photo_height
				end
				scale = propertyTable.scale / 100
				
				-- resize
				resize_width = scale * photo_width * relative_scale
				resize_height = scale * photo_height * relative_scale

				--  transform			
				transform = PluginUtils.transform_format( 
					{ width = width, height = height }, 
					{ width = resize_width, height = resize_height } )

				-- oiio tool
				color = OpenImageIOFilterProvider.getBackground( propertyTable )
				command = PluginConfig.oiiotool_path ..  
					" \"" .. sourceRendition.destinationPath .. "\"" ..
					" --pattern constant:color=" .. color.red .. "," .. color.green .. "," .. color.blue .. "," .. color.alpha .. " " ..
					"\"{" .. width .. "}x{" .. height .. "}\" \"{TOP.nchannels}\" " ..
					"--swap --resize \"{" .. PluginUtils.string_to_number(math.ceil(resize_width)) .."}x{" .. PluginUtils.string_to_number(math.ceil(resize_height)) .. "}\" " ..
					"--swap --paste \"" .. PluginUtils.string_to_number(math.ceil(transform.x)) .. "" .. PluginUtils.string_to_number(math.ceil(transform.y)) .."\"" ..
					" -o \"" .. sourceRendition.destinationPath .. "\""

				LogInfo("Command: " .. command)

				-- execute
				if LrTasks.execute( command ) ~= 0 then
					LogInfo("Failed when trying to execute command, see log.")

					renditionToSatisfy:renditionIsDone( false, "Failed when trying to execute command, see log" )
				end
				LogInfo("Post processing finished")

			else
				LogInfo("Post processing failed")
			
			end
		end
	end
end

return OpenImageIOFilterProvider
