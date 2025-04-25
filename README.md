# Firebase App Check Custom

[![pub package](https://img.shields.io/pub/v/firebase_app_check_custom.svg)](https://pub.dev/packages/firebase_app_check_custom)

This package is a **fork** of the official [Firebase App Check](https://pub.dev/packages/firebase_app_check) plugin with added support for custom debug tokens.

## Version Information

- **Current Version**: 0.1.3
- **Based on**: firebase_app_check 0.3.2+5

Note that this package uses its own versioning scheme, starting at 0.1.0, while the original package is at version 0.3.2+5. Features and fixes from the original package will be incorporated into this fork as they become available.

## Enhanced Features

This fork adds the following enhancements to the original package:

- **Custom Debug Tokens**: Specify your own debug tokens when using the debug provider, giving you more control over your testing process
- **Environment Variable Support**: Set debug tokens via the `DEBUG_APP_CHECK_TOKEN` environment variable
- **Full compatibility** with the original API, making migration easy

## Getting Started

To get started with Firebase App Check Custom, please [see the documentation](https://firebase.google.com/docs/app-check/flutter/default-providers) for the original plugin. The setup process is identical.

## Usage

Initialize Firebase App Check just like the original package, with the additional option to specify a custom debug token:

```dart
await FirebaseAppCheck.instance.activate(
  androidProvider: AndroidProvider.debug,
  appleProvider: AppleProvider.debug,
  // New parameter for custom debug token:
  customDebugToken: 'your-custom-debug-token',
);
```

### Alternative: Using Environment Variables

You can also set the debug token via environment variable:

1. Set the `DEBUG_APP_CHECK_TOKEN` environment variable before running your app
2. The token will be automatically detected and used when using the debug provider

If both the environment variable and the parameter are provided, the parameter takes precedence.

## Attribution

This package is a fork of the [official Firebase App Check plugin](https://pub.dev/packages/firebase_app_check) developed by the Firebase team. All credit for the original implementation goes to them.

The enhancements in this fork were developed to address the specific need for custom debug tokens in testing scenarios.

## License

This package is licensed under the same license as the original Firebase App Check plugin, which is the BSD license.

## Issues and Contributions

Please file issues specific to this fork in our [issue tracker](https://github.com/yourusername/firebase_app_check_custom/issues/new).

For issues with the core Firebase App Check functionality, please consider filing them in the [official FlutterFire repository](https://github.com/firebase/flutterfire/issues/new).
