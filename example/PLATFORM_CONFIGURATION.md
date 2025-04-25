# Platform-Specific Configuration Guide

This document provides detailed platform-specific configuration instructions for using custom debug tokens with Firebase App Check in your forked package.

## Android Configuration

### 1. AndroidManifest.xml Setup

No additional AndroidManifest.xml changes are required specifically for custom debug tokens. The standard Firebase App Check configuration applies:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.your_app">
    
    <application
        ...
        android:name=".YourApplication">
        
        <!-- Standard App Check debug configuration (optional) -->
        <meta-data
            android:name="firebase_app_check_debug_enabled"
            android:value="true" />
            
    </application>
</manifest>
```

### 2. Application Class (Optional)

If you want to set up App Check in Kotlin/Java code rather than Flutter:

```kotlin
// YourApplication.kt
class YourApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        
        if (BuildConfig.DEBUG) {
            // For environment variables or build config values
            val customToken = BuildConfig.APP_CHECK_DEBUG_TOKEN 
            
            // Initialize with custom token if available
            if (customToken.isNotEmpty()) {
                val debugAppCheckProviderFactory = 
                    DebugAppCheckProviderFactory.getInstance(customToken)
                FirebaseAppCheck.getInstance().installAppCheckProviderFactory(
                    debugAppCheckProviderFactory
                )
            } else {
                // Fallback to standard debug token
                FirebaseAppCheck.getInstance().installAppCheckProviderFactory(
                    DebugAppCheckProviderFactory.getInstance()
                )
            }
        }
    }
}
```

### 3. ProGuard Configuration

No special ProGuard rules are needed specifically for custom debug tokens.

## iOS Configuration

### 1. Info.plist Setup

Standard Firebase App Check debug configuration:

```xml
<!-- Info.plist -->
<key>FirebaseAppCheckDebugProviderFactory</key>
<true/>
```

### 2. AppDelegate Setup (Optional Swift Example)

If you want to set up App Check in Swift rather than Flutter:

```swift
// AppDelegate.swift
import UIKit
import Firebase
import FirebaseAppCheck

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        
        #if DEBUG
        // Get custom token from environment or configuration
        if let customToken = ProcessInfo.processInfo.environment["DEBUG_APP_CHECK_TOKEN"] {
            let debug = AppCheckDebugProviderFactory()
            // Using KVC to set the debug token 
            // Note: This approach is based on implementation details and might change
            debug.setValue(customToken, forKey: "debugToken")
            AppCheck.setAppCheckProviderFactory(debug)
        } else {
            // Fallback to standard debug token
            AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
        }
        #else
        // Use device check for production
        AppCheck.setAppCheckProviderFactory(
            DeviceCheckProviderFactory()
        )
        #endif
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

### 3. Swift Integration (Alternative Approach)

Another approach for Swift projects:

```swift
// Save this in a utility file like AppCheckUtils.swift

import FirebaseAppCheck

class AppCheckUtils {
    static func configureWithCustomToken(_ customToken: String?) {
        if let token = customToken, !token.isEmpty {
            let debugProvider = AppCheckDebugProviderFactory()
            debugProvider.setValue(token, forKey: "debugToken")
            AppCheck.setAppCheckProviderFactory(debugProvider)
        } else {
            // Fallback to standard debug token
            AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
        }
    }
}
```

## Checking Debug Token Setup

### Android

To verify your custom debug token is being used correctly:

```kotlin
// In any Activity or Fragment
val provider = FirebaseAppCheck.getInstance().appCheckProviderFactory
if (provider is DebugAppCheckProviderFactory) {
    // The provider is using debug mode
    // Log the debug token from Firebase to verify it's your custom one
    Log.d("AppCheck", "Debug token: " + FirebaseAppCheck.getInstance().getToken(true).result.token)
}
```

### iOS

To verify your custom debug token is being used:

```swift
if let provider = AppCheck.appCheck().appCheckProviderFactory as? AppCheckDebugProviderFactory {
    // The provider is using debug mode
    // You can validate the token by requesting one:
    AppCheck.appCheck().token(forcingRefresh: true) { token, error in
        if let token = token {
            print("Debug token: \(token.token)")
        }
    }
}
```

## Registering Your Debug Token in Firebase Console

Regardless of platform, you must register your custom debug token in the Firebase Console:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to App Check
4. Go to "Apps" tab
5. Find your app and click "Add debug token"
6. Enter your custom debug token exactly as used in the app
7. Click "Add"

## Environment Variable Setup in CI/CD

For team environments, you can set up environment variables in your CI/CD systems:

### GitHub Actions Example

```yaml
name: Flutter Build

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        
      - name: Flutter Build with Custom Debug Token
        env:
          DEBUG_APP_CHECK_TOKEN: ${{ secrets.DEBUG_APP_CHECK_TOKEN }}
        run: flutter build apk
```

### Fastlane Example

```ruby
# Fastfile
lane :debug do
  ENV["DEBUG_APP_CHECK_TOKEN"] = "your-custom-debug-token"
  build_ios_app(...)
end
```
