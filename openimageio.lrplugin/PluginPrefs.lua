--
--  PluginInit.lua
--  openimageio.lrplugin
--
--  Copyright (c) 2022 - present Mikael Sundell.
--  All Rights Reserved.
--
--  openimageio.lrplugin is a lightroom plugin to post-process Lightroom exports
--  using openimageio image processing tools.

local LrPrefs = import 'LrPrefs'
local LrColor = import 'LrColor'
local plugin = _PLUGIN

-- 
--  PluginPrefs.lua
-- 

PluginPrefs = {
    oiiotool_path = "",
    write_log = false,
    init = false
}

-- init prefs
function PluginPrefs_init( default )
    PluginPrefs = LrPrefs.prefsForPlugin()
    -- oiio path
    -- note: always updated, may have changed
    PluginPrefs.oiiotool_path = plugin:resourceId("oiiotool/oiiotool")
    default = default or false
    if ( not PluginPrefs.init or default ) then
        -- log path
        PluginPrefs.write_log = false
        PluginPrefs.init = true

    end
end
