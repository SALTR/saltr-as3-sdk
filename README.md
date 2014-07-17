SALTR ActionScript3 SDK
=============

This is the README file of the SALTR ActionScript3 iOS SDK.

CONTENTS
========
1. INTRODUCTION
2. USAGE
3. DIRECTORY STRUCTURE
4. DOCUMENTATION

----

1. INTRODUCTION
===============

Saltr ActionScript3 SDK is a library of classes which will help you to develop mobile/web 
games that are integrated with SALTR platform.

SDK performs all necessary and possible action with SALTR REST API to connect, update, set 
and download data related to application's or game's  features or levels.

All data received from SALTR REST API is parsed and represented through set of classes, 
each carrying specific object and its properties.

Basically SDK, as the REST API, has few simple actions. The most important one is to connecting, 
which loads the app data objects containing features, experiments and level headers.

This and other actions will be descibed in the sections below.


2. USAGE
========

To use the SDK you need to download/checkout SDK repository, and then import files to your
project.

The recommended IDE's for Flash/ActionScript projects are Adobe Flash Builder or IntelliJ Idea.

The entry point classes in SDK are different if the project is mobile or web based application.
For mobile apps: SLTSaltrMobile.as is the main class.
For web apps: SLTSaltrWeb.as is the main class.
Each have some differences of initialization and usage.

Note: All classes in the package start with "SLT" prefix.

3. DIRECTORY STRUCTURE
======================

Library and test app source code is available on github with the following URL:

https://github.com/plexonic/saltr-ios-sdk.git

The sdk has the following directory structure:

- Saltr.xcodeproj - xcode main project configuration file
- Saltr - the sources of the sdk
- SaltrResource - the bundle of the sdk resources
- SaltrTests - sdk unit tests built with XCTestFramework
- SaltrTestApp - a sample app which uses the sdk
- SaltrTestAppTests - an empty test project for the sample app
- testdata - test data samples

4. DOCUMENTATION
================

The ChangeLog and ReleaseNotes of the project are available within the sources.

The detailed SDK documentation is generated with doxygen after building the project.
