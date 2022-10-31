--
--  PluginInit.lua
--  openimageio.lrplugin
--
--  Copyright (c) 2022 - present Mikael Sundell.
--  All Rights Reserved.
--
--  openimageio.lrplugin is a lightroom plugin to post-process Lightroom exports
--  using openimageio image processing tools.

-- requires
require "PluginPrefs"
require "PluginUtils"

-- imports
local LrLogger = import 'LrLogger'

-- 
--  PluginLog.lua
-- 

PluginLog = {
    log = nil,
    log_name = 'OpenImageIOLog',
    log_path = nil,
    init = false
}

-- init log
function PluginLog_init()   
    if ( not PluginLog.init ) then
        PluginLog.log = LrLogger( PluginLog.log_name )
        -- print to log file
        PluginLog.log:enable( 'logfile' )
        -- note: we need full system path, not just ~/ for utils
        PluginLog.log_path = PluginUtils.get_home() .. "/Documents/LrClassicLogs/" .. PluginLog.log_name .. ".log"
        PluginLog.init = true

    end
end

-- messages
function LogInfo( message )
    if PluginPrefs.write_log then
        PluginLog.log:trace( "[info]: " .. message )
    end
end

function LogWarning( message )
    if PluginPrefs.write_log then
        PluginLog.log:trace( "[warning]: " .. message )
    end
end

function LogDebug( message )
    if PluginPrefs.write_log then
        PluginLog.log:trace( "[debug]: " .. message )
    end
end

function LogError( message )
    if PluginPrefs.write_log then
        PluginLog.log:trace( "[error]: " .. message )
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

