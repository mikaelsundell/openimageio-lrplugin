Readme for openimageio.lrplugin
===============================

[![License](https://img.shields.io/badge/license-BSD%203--Clause-blue.svg?style=flat-square)](https://github.com/mikaelsundell/icloud-snapshot/blob/master/license.md)

Introduction
------------
openimageio.lrplugin is a lightroom plugin to post-process Lightroom exports using openimageio image processing tools


Documentation
-------------

The openimageio.lrplugin is essentially a post-process plugin that runs oiiotool after Lightroom exports one or several images. The plugin is a boilerplate for developing more advanced post-processing functionality and is a starting point for everyone interested in getting started with Lightroom, lua and openimageio.

**Plugin information**

Load the plugin from `Lightroom Plug-in Manager`. The upper section contains information about where oiio tool is installed and where to find log path. Log files are written during export if the `Write log` is checked.

**Post-processing with OpenImageIO**

The plugin is a Post-Process Action and can be added to the current Export by selecting `Post-Process width OpenImageIO` and insert. The main functionality of the plugin is to enable export to different formats and aspect ratios.

**General**

`Force sRGB`  Forces sRGB output for all converts

**Formats**

`Turn on`       Turn on use of formats

`4K`            Use 4K resolution for aspect ratio

`Scale`         Scale or zoom for image in aspect ratio

`Aspect ratio`  Format aspect ratio

`Background`    Background fill color


Packaging
---------

The openimageio-lrplugin project uses oiiotool for image processing, copy oiiotool to plugin:

```shell
./macdeploy.sh -e <path>/oiiotool -d <dependencies>/lib -p <plugin>/openimageio.lrplugin/oiiotool
```

The `macdeploy.sh` script will copy and change all dependencies to use @executable as install names.


Create a new package

```shell
> mkdir openimageio-lrplugin_macOS12_amd64-<version>
> cp -R openimageio.lrplugin openimageio-lrplugin_macOS12_amd64-<version>
> cp README.md LICENSE openimageio-lrplugin_macOS12_amd64-<version>
> tar -czf openimageio-lrplugin_macOS12_amd64-<version>.tar.gz openimageio-lrplugin_macOS12_amd64-<version>
```

Web Resources
-------------

GitHub page:        http://github.com/mikaelsundell/openimageio-lrplugin
