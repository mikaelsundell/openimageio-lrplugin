--
--  PluginConfig.lua
--  openimageio.lrplugin
--
--  Copyright (c) 2023 - present Mikael Sundell.
--  All Rights Reserved.
--
--  openimageio.lrplugin is a lightroom plugin to post-process Lightroom exports
--  using openimageio image processing tools.

-- requires
require "PluginUtils"

local LrPrefs = import 'LrPrefs'
local LrColor = import 'LrColor'
local LrLogger = import 'LrLogger'
local plugin = _PLUGIN

-- 
--  PluginConfig.lua
-- 

PluginConfig = {
    oiiotool_path = "",
    log_name = 'OpenImageIOLog',
    log = nil,
    log_path = nil,
    init = false
}

PluginPrefs = {
    log_write = false,
    init = false
}

-- init config
function PluginConfig_init( default )
    -- prefs
    -- note: one-time call, saved between sessions
    PluginPrefs = LrPrefs.prefsForPlugin()
    if ( not PluginPrefs.init or default ) then
        PluginPrefs.log_write = false
        PluginPrefs.init = true
    end
    -- oiio path
    -- note: may have been updated, based on plugin
    PluginConfig.oiiotool_path = plugin:resourceId("oiiotool/oiiotool")
    default = default or false
    if ( not PluginConfig.init or default ) then
        -- log path
        PluginConfig.log = LrLogger( PluginConfig.log_name )
        -- print to log file
        PluginConfig.log:enable( 'logfile' )
        -- note: we need full system path, not just ~/ for utils
        PluginConfig.log_path = PluginUtils.get_home() .. "/Documents/LrClassicLogs/" .. PluginConfig.log_name .. ".log"
        PluginConfig.init = true
    end
end

-- messages
function LogInfo( message )
    if PluginPrefs.log_write then
        PluginConfig.log:trace( "[info]: " .. message )
    end
end

function LogWarning( message )
    if PluginPrefs.log_write then
        PluginConfig.log:trace( "[warning]: " .. message )
    end
end

function LogDebug( message )
    if PluginPrefs.log_write then
        PluginConfig.log:trace( "[debug]: " .. message )
    end
end

function LogError( message )
    if PluginPrefs.log_write then
        PluginConfig.log:trace( "[error]: " .. message )
    end
end

-- lightroom
function LogExportSettings( exportSettings )
    LogInfo("Render settings")
    LogInfo("  LR_format: " .. exportSettings.LR_format)
    LogInfo("  LR_export_colorSpace: " .. exportSettings.LR_export_colorSpace)
    LogInfo("  LR_export_bitDepth: " .. exportSettings.LR_export_bitDepth)
    LogInfo("  LR_jpeg_quality: " .. exportSettings.LR_jpeg_quality)
    LogInfo("  LR_jpeg_useLimitSize: " .. tostring(exportSettings.LR_jpeg_useLimitSize))
    LogInfo("  LR_jpeg_limitSize: " .. exportSettings.LR_jpeg_limitSize)
    LogInfo("  LR_tiff_compressionMethod: " .. exportSettings.LR_tiff_compressionMethod)
    LogInfo("  LR_DNG_previewSize: " .. exportSettings.LR_DNG_previewSize)
    LogInfo("  LR_DNG_compatability: " .. tostring(exportSettings.LR_DNG_compatability))
    LogInfo("  LR_DNG_conversionMethod: " .. exportSettings.LR_DNG_conversionMethod)
    LogInfo("  LR_DNG_embedRAW: " .. tostring(exportSettings.LR_DNG_embedRAW))

    LogInfo("Image sizing settings")
    LogInfo("  LR_size_doConstrain: " .. tostring(exportSettings.LR_size_doConstrain))
    LogInfo("  LR_size_doNotEnlarge: " .. tostring(exportSettings.LR_size_doNotEnlarge))
    LogInfo("  LR_size_maxHeight: " .. exportSettings.LR_size_maxHeight)
    LogInfo("  LR_size_maxWidth: " .. exportSettings.LR_size_maxWidth)
    LogInfo("  LR_size_megapixels: " .. exportSettings.LR_size_megapixels)
    LogInfo("  LR_size_resizeType: " .. exportSettings.LR_size_resizeType)
    LogInfo("  LR_size_resolution: " .. exportSettings.LR_size_resolution)
    LogInfo("  LR_size_resolutionUnits: " .. exportSettings.LR_size_resolutionUnits)

    LogInfo("Sharpening settings")
    LogInfo("  LR_outputSharpeningOn: " .. tostring(exportSettings.LR_outputSharpeningOn))
    LogInfo("  LR_outputSharpeningMedia: " .. exportSettings.LR_outputSharpeningMedia)
    LogInfo("  LR_outputSharpeningLevel: " .. exportSettings.LR_outputSharpeningLevel)

    LogInfo("Metadata settings")
    LogInfo("  LR_minimizeEmbeddedMetadata: " .. tostring(exportSettings.LR_minimizeEmbeddedMetadata))
    LogInfo("  LR_metadata_keywordOptions: " .. tostring(exportSettings.LR_metadata_keywordOptions))
    LogInfo("  LR_removeLocationMetadata: " .. tostring(exportSettings.LR_removeLocationMetadata))
    LogInfo("  LR_embeddedMetadataOption: " .. tostring(exportSettings.LR_embeddedMetadataOption))

    LogInfo("Video settings")
    LogInfo("  LR_includeVideoFiles: " .. tostring(exportSettings.LR_includeVideoFiles))

    LogInfo("Watermarking settings")
    LogInfo("  LR_useWatermark: " .. tostring(exportSettings.LR_useWatermark))
    LogInfo("  LR_watermarking_id: " .. exportSettings.LR_watermarking_id)

    LogInfo("Export settings")
    LogInfo("  LR_watermarking_id: " .. exportSettings.LR_watermarking_id)
end

