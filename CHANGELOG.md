Saltr: Changelog
===================

version 1.3.8 - 2015-09-11
------------------------

- added "boards" getter in class SLTLevel.
- added verbose logging.
- added checkpoints.
- added async level content loading.
- updated level content retrieving logic. As a result loadLevelContent() method of SLTSaltrMobile removed and initLevelContentLocally() and initLevelContentFromSaltr() methods are added.
- updated static data requesting from server to use "GET" method instead of "POST".
- removed useCache state.
- removed useNoLevels state.
- removed useNoFeatures state.

version 1.3.7 - 2015-06-02
------------------------

- added scaling support for asset instances. Affected classes are: SLT2DAssetInstance and SLT2DAssetState.
- added alternative positions list support for asset instances. Affected class is SLT2DAssetInstance.