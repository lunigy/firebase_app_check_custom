# Changelog

## 0.1.4

- Critical fix: Implemented direct method channel registration for iOS and macOS
- Resolved persistent MissingPluginException issue with complete channel registration
- Fixed plugin communication between Flutter and native platforms
- Ensured proper registration for Firebase App Check methods on iOS/macOS

## 0.1.3

- Fixed iOS and macOS plugin registration to properly handle method channel integration
- Added proper Flutter plugin registration files to ensure automatic plugin loading
- Completely resolved MissingPluginException without requiring client-side workarounds
- Improved package structure following Flutter plugin best practices

## 0.1.2

- Fixed iOS and macOS implementation by adding properly named podspec files
- Resolved MissingPluginException for Firebase App Check methods on iOS/macOS platforms
- Improved cross-platform compatibility

## 0.1.1

- Fixed plugin registration and import issues to ensure proper functionality
- Updated example app to properly use the custom implementation
- Improved documentation

## 0.1.0

This is the initial release of `firebase_app_check_custom`, a fork of `firebase_app_check` (version 0.3.2+5) with enhanced debug token support.

### Added
- Support for custom debug tokens via the `customDebugToken` parameter in the `activate()` method
- Environment variable support through `DEBUG_APP_CHECK_TOKEN`
- Documentation for the new custom debug token features

### Maintained
- Full compatibility with the original Firebase App Check API
- All existing providers and functionality from the original package

## Original Package History

For the changelog of the original `firebase_app_check` package that this fork is based on, please visit the [official Firebase App Check plugin changelog](https://github.com/firebase/flutterfire/blob/main/packages/firebase_app_check/firebase_app_check/CHANGELOG.md).
