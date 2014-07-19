SALTR ActionScript3 SDK
=============

This is the README file of the SALTR ActionScript3 iOS SDK.

To check out the project from GitHub:
<a href="https://github.com/plexonic/saltr-ios-sdk.git">https://github.com/plexonic/saltr-ios-sdk.git</a>

To download the latest ZIP:
<a href="https://github.com/plexonic/saltr-as3-sdk/archive/master.zip">https://github.com/plexonic/saltr-as3-sdk/archive/master.zip</a>



CONTENTS
========
1. INTRODUCTION
2. USAGE
3. PACKAGES
4. DOCUMENTATION

----

1. INTRODUCTION
===============

SALTR Flash/AS3 SDK is a library of classes which help to develop mobile and web
games that are to be integrated with SALTR platform.

SDK performs all necessary and possible action with SALTR REST API to connect, update, set 
and download data related to game's  features or levels.

All data received from SALTR REST API is parsed and represented through set of instances of classes,
each carrying specific objects and their properties.

Basically SDK, as the REST API, has few simple actions. The most important one is connecting (getAppData),
which loads the app data objects containing features, experiments and level headers.

This and other actions will be described in the sections below.


2. USAGE
========

To use the SDK you need to download/checkout SDK repository, and then import files to your
project.

The recommended IDE's for Flash/AS3 are <a href="http://www.adobe.com/products/flash-builder.html">Adobe Flash Builder</a> or <a href="http://www.jetbrains.com/idea/">IntelliJ Idea</a>.

The entry point classes in SDK are different if the project is mobile or web based application:

- For Mobile Apps <code>SLTSaltrMobile</code> is the main class.
- Fow Web Apps <code>SLTSaltrWeb</code> is the main class.

Each have some differences of initialization and usage.

Note: All classes in the package start with "SLT" prefix.

3. PACKAGES
======================

The SDK's library classes have the following packages:

- saltr - main and root package for the library;
- saltr.game - the game related classes contained here;
- saltr.game.canvas2d - classes related to 2D games;
- saltr.game.matching - classes related to matching or board based games;
- saltr.game.repository - local data repository classes (implementation widely varies with the platform);
- saltr.game.status - status classes representing warnings and error statuses withing library code;
- saltr.game.utils - helper or utility classes;

New packages supporting new gameplays and genres will be be added to saltr.game package.


4. DOCUMENTATION
================

Detailed documentation for all public classes and methods is coming soon.
