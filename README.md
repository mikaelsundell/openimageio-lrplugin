Readme for openimageio.lrplugin
===============================

[![License](https://img.shields.io/badge/license-BSD%203--Clause-blue.svg?style=flat-square)](https://github.com/mikaelsundell/icloud-snapshot/blob/master/license.md)

Introduction
------------
openimageio.lrplugin is a lightroom plugin to post-process Lightroom exports using openimageio image processing tools


Documentation
-------------

The openimageio.lrplugin is essentially a post-process plugin that runs oiiotool after Lightroom exports one or several images. The plugin is a boilerplate for developing more advanced post-processing functionality and is a starting point for everyone interested in getting started with Lightroom, lua and openimageio.




Packaging
---------

The openimageio-lrplugin project uses 3rdparty to copy the oiiotool to the plugin:

```shell
./macdeploy.sh -e <path>/oiiotool -d <dependencies>/lib -p <plugin>/openimageio.lrplugin/oiiotool
```
