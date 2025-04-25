# Firebase App Check Custom Debug Token Guide

This guide explains how to use custom debug tokens with Firebase App Check in your Flutter applications, for both Android and iOS platforms.

## Overview

Firebase App Check normally generates a random debug token when using the debug provider. This enhancement allows you to:

1. Specify your own debug token instead of using the randomly generated one
2. Use the same debug token across different devices or development environments
3. Set the token via code parameter or environment variable

## Setup Instructions

### 1. Basic Integration

First, follow the [standard Firebase App Check setup](https://firebase.google.com/docs/app-check/flutter/default-providers) to add the package to your project and initialize Firebase.

### 2. Using Custom Debug Tokens

You can provide a custom debug token in two ways:

#### Option A: Direct Parameter

```dart
await FirebaseAppCheck.instance.activate(
  androidProvider: AndroidProvider.debug,
  appleProvider: AppleProvider.debug,
  // Specify your own custom debug token here
  customDebugToken: 'your-custom-debug-token',
);
```

#### Option B: Environment Variable

Set the `DEBUG_APP_CHECK_TOKEN` environment variable before running your app:

**macOS/Linux**:
```bash
export DEBUG_APP_CHECK_TOKEN=your-custom-debug-token
flutter run
```

**Windows**:
```cmd
set DEBUG_APP_CHECK_TOKEN=your-custom-debug-token
flutter run
```

**IDE Configuration**:
You can also set environment variables in your IDE's run configurations.

- **VS Code**: Add to `launch.json`:
  ```json
  {
    "name": "Flutter",
    "request": "launch",
    "type": "dart",
    "env": {
      "DEBUG_APP_CHECK_TOKEN": "your-custom-debug-token"
    }
  }
  ```

- **Android Studio/IntelliJ**: Add to run configuration environment variables

## Platform-Specific Configuration

### Android Setup

The custom debug token functionality works without any additional configuration on Android. Just ensure you:

1. Use the debug provider in your `activate()` call:
   ```dart
   androidProvider: AndroidProvider.debug
   ```

2. Add your custom debug token to the Firebase Console:
   - Go to the [Firebase Console](https://console.firebase.google.com/)
   - Select your project
   - Navigate to App Check in the left-side menu
   - Choose "Apps" tab
   - Find your Android app and click "Add debug token"
   - Enter your custom debug token

### iOS Setup

For iOS, you'll need to:

1. Use the debug provider in your `activate()` call:
   ```dart
   appleProvider: AppleProvider.debug
   ```

2. Add your custom debug token to the Firebase Console (same as Android steps)

3. If needed, update your Info.plist to enable debug token verification in development:
   ```xml
   <key>FirebaseAppCheckDebugProviderFactory</key>
   <true/>
   ```

## Example Code

### Basic Integration

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> initializeFirebase() async {
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Get custom debug token from environment variable or use default
  String? customToken = const String.fromEnvironment('DEBUG_APP_CHECK_TOKEN');
  
  // Activate App Check with custom debug token
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
    customDebugToken: customToken.isNotEmpty ? customToken : 'my-custom-debug-token',
  );
}
```

### Loading Custom Token from File or Secure Storage

For teams that want to share a token without hardcoding it:

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> activateAppCheckWithSecureToken() async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'app_check_debug_token');
  
  // Fallback to environment variable if not in secure storage
  token ??= const String.fromEnvironment('DEBUG_APP_CHECK_TOKEN');
  
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
    customDebugToken: token,
  );
}
```

## Registering Your Debug Token in Firebase Console

For your custom debug token to work, you must register it in the Firebase Console:

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to App Check in the left-side menu
4. Choose "Apps" tab
5. Find your app (Android or iOS) and click "Add debug token"
6. Enter the exact same token you're using in your app
7. Click "Add token"

## Testing Your Integration

To verify your custom token is working:

```dart
// Fetch the token to confirm it's working
final token = await FirebaseAppCheck.instance.getToken();
print('App Check token: $token');

// Make a request to a protected Firebase service
// If the request succeeds, your custom debug token is registered correctly
```

## Best Practices

1. **Don't hardcode tokens in production code**: Use environment variables or secure storage
2. **Use different tokens for different environments**: Consider having separate tokens for dev, staging, etc.
3. **Protect your debug tokens**: Treat them as secrets, especially if they have access to production resources
4. **Verify token registration**: Always confirm your token is properly registered in the Firebase Console
5. **Disable in production**: Remember to switch to a proper attestation provider (not debug) for production builds

## Troubleshooting

**Token Not Working**:
- Verify the exact same token is registered in Firebase Console
- Check that you're using the debug provider in your activate() call
- Ensure the token format is valid (no special characters unless intentional)

**Platform-Specific Issues**:
- Android: Check logcat for any Firebase App Check related errors
- iOS: Check Xcode console for debug token related messages

**Permission Issues**:
- Verify your Firebase service permissions are correctly configured
- Check that App Check enforcement is properly set up for your services

## Implementation Notes

This feature is implemented by modifying the standard debug provider initialization in the native Firebase SDK:

- **Android**: Uses `DebugAppCheckProviderFactory.getInstance(customToken)` when a custom token is provided
- **iOS**: Sets the debug token on the provider instance using KVC to modify the internal `debugToken` property

The custom token is passed through the plugin's method channel and applied when initializing the respective debug providers on each platform.
