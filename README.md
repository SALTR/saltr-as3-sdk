#SALTR AS3 SDK (Adobe AIR, Flash)
* Modified: May 22th, 2015
* AS3 SDK Version: 1.3.6 

Other Supported Platforms:
* [Unity Plug-in Version: 1.4.0](https://github.com/SALTR/saltr-unity-sdk)
* [iOS SDK Version: 1.3.3](https://github.com/SALTR/saltr-ios-sdk)
* [Android SDK Version: 1.1.1](https://github.com/SALTR/saltr-android-sdk)

##Getting Started with SALTR AS3
Please read [SALTR AS3 SDK Setup](https://saltr.com/setup#/flash-as3) doc.

###SALTR SDK Contains:
* `/src` - root folder of the library;
* `saltr` - main package of library;
  * `saltr.game` - package contains game related classes;
    * `saltr.game.canvas2d` - classes related to 2D games;
    * `saltr.game.matching` - classes related to matching or board based games;
  * `saltr.repository` - local data repository classes (implementation widely varies through platforms);
  * `saltr.resource` - resource loading classes;
  * `saltr.status` - status classes representing warnings and error statuses used within library code;
  * `saltr.utils` - helper or utility classes;


##To Download
The SALTR AS3 SDK archive is [Available Here for download](https://github.com/SALTR/saltr-as3-sdk/archive/master.zip).


##To Install
To use the SDK you need to download/clone SDK repository, and then import files to your
project.

To clone Git repository via command line:
```
$ git clone https://github.com/SALTR/saltr-as3-sdk.git
```

The recommended IDE's for Flash/AS3 are <a href="http://www.adobe.com/products/flash-builder.html">Adobe Flash Builder</a> or <a href="http://www.jetbrains.com/idea/">IntelliJ Idea</a>.

The entry point classes in SDK are different if the project is mobile or web based application:

- For Mobile Apps <code>SLTSaltrMobile</code> is the main class.
- Fow Web Apps <code>SLTSaltrWeb</code> is the main class.

Each have some differences of initialization and usage.

Note: All classes in the package start with `SLT` prefix.


##Introduction

Easily integrate SALTR Unity SDK into your games or apps to get real-time control over settings, user experience tweaking, customization and level design. 
With SALTR you and your team will have availability to:
* Update any app settings, prices and values for your users. 
* Target you most important users by delivering specific configurations only to them. Use segmentation with user filtering based on advances set of standard and custom criteria.
* Create experiments testing any feature and level modifications against each other. Manage intensity and type of user traffic flowing into your experiments partitions.
* Design levels in real-time. Connect team memeber devices and allow them to tweak levels, features and setting simultainously without interfeering with each other. Continue balancing your levels in real-time even after game is released, without need to bother your dev team to deliver next app update.
* Measure your impact on each segment, experiment partition, and be able to take action right-away. 
* No updates needed on App Store, Google Play or etc.. 
* Do all this in real-time, and much more...

This SDK performs all necessary and possible action with SALTR REST API to connect, update, set 
and download data related to game's features or levels.

All data received from SALTR REST API is parsed and represented through set of instances of classes, 
each carrying specific objects and their properties.

Basically SDK, as the REST API, has few simple actions. The most important one is connecting `getAppData()`, 
which loads the app data objects containing features, experiments and level headers.

##Contact Us
For more information, please visit [saltr.com](https://saltr.com). For questions or assistance, please email us at support@saltr.com.
