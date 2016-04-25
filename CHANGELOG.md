# Change Log
All notable changes to this project will be documented in this file.

## Android-3.2.1 - iOS-3.1.0 <> 2016-04-25
Built with TiSDK 5.2.2 for compatibility with Marshmallow

## Android-3.2.0 - iOS-3.1.0 <> 2015-08-18
Brought Google Play Services up to version 7.8

## Android-3.1.0 - iOS-3.1.0 <> 2015-03-22
### Added
- `trackException` method added to Android and iOS to track caught exceptions. [[mokesmokes]](https://github.com/mokesmokes)
- `GA.trackUncaughtExceptions` method added to Android to track uncaught exceptions. [[mokesmokes]](https://github.com/mokesmokes)
- Added note to README about common Google Play Services issues.

### Fixed
- Restructured github repo and android module to avoid case-sensitivity issues and unable to find android module error.
- Regression on minimum Titanium SDK requirement for android. [[mokesmokes]](https://github.com/mokesmokes)

## Android-3.0.0 - iOS-3.0.2 <> 2015-01-16
### Added
- Update iOS module to use SDK 3.10. IDFA warning in logs is no longer present.

## Android-3.0.0 - iOS-3.0.1 <> 2015-01-14
### Fixed
- Forgot to change the SDK definition to 3.5.0.GA in the titanium.xcconfig file.

## Android-3.0.0 - iOS-3.0.0 <> 2015-01-14
### Added
- The module now depends on Titanium 3.5.0.GA
- 64bit capability for iOS. If you are updating your application from a lower version than 3.5.0.GA and you are having compiling issues, try removing the files in the `build` and `Resources` folders.

## Android-2.2.0 - iOS-2.1.0 <> 2014-12-13
### Fixed
- Changed moduleid so that new users of the module will not receive unlicensed module if they haven't downloaded the legacy version through the Titanium Marketplace.

## Android-2.1.1 - iOS-2.0-1 <> 2014-11-03
### Added
- This changelog.

### Deprecated
- None.

### Removed
- None.

### Fixed
- Corrected optional currency parameter on trackTransactionItem on ios. [[ndizazzo]](https://github.com/ndizazzo)
- Corrected module API version on android. [[ndizazzo]](https://github.com/ndizazzo)

### Security
- None.


## Android-2.1.0 - iOS-2.0-0 <> 2014-11-03
### Added
- Google Analytics SDK for iOS v3.
- Google Analytics SDK v4 for Android.
- Custom Dimensions and Metrics on all methods.
- Detailed examples under example/app.js for android and ios.
- Added setUser method.

### Deprecated
- Options object for trackScreen has changed from a string to an object.
- Transactions format has changed entirely and is now based on two separate methods.
- Changed 'debug' to 'dryrun' to specify when analytics data should not be sent to google.

### Removed
- None.

### Fixed
- Documentation was improved on main README file.

### Security
- None.


## Prior Versions
- Prior versions were the responsibility of [MattTuttle](https://github.com/MattTuttle/titanium-google-analytics)
