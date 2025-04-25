// Copyright 2023
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check_custom/firebase_app_check_custom.dart';
import 'package:flutter/foundation.dart';

/// This file contains examples of different ways to set up custom debug tokens
/// with Firebase App Check.

/// Example 1: Basic setup with hardcoded token
/// Only suitable for local development, never use in production or shared code
Future<void> setupWithHardcodedToken() async {
  await Firebase.initializeApp();
  
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
    customDebugToken: 'my-custom-debug-token-123',
  );
}

/// Example 2: Using environment variables
/// Better approach that doesn't expose tokens in code
Future<void> setupWithEnvironmentVariable() async {
  await Firebase.initializeApp();
  
  // Check both compile-time and runtime environment variables
  String? debugToken = const String.fromEnvironment('DEBUG_APP_CHECK_TOKEN');
  
  if (debugToken.isEmpty) {
    // Fallback to runtime environment variable
    debugToken = Platform.environment['DEBUG_APP_CHECK_TOKEN'];
  }
  
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
    customDebugToken: debugToken,
  );
}

/// Example 3: Platform-specific setup (debug builds only)
/// This is useful when you need different configurations per platform
Future<void> setupPlatformSpecific() async {
  await Firebase.initializeApp();
  
  // Only use debug provider and custom token in debug mode
  if (kDebugMode) {
    String? debugToken = Platform.environment['DEBUG_APP_CHECK_TOKEN'];
    
    if (Platform.isAndroid) {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        // Use default provider for iOS
        appleProvider: AppleProvider.deviceCheck, 
        customDebugToken: debugToken,
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      await FirebaseAppCheck.instance.activate(
        // Use default provider for Android
        androidProvider: AndroidProvider.playIntegrity,
        appleProvider: AppleProvider.debug,
        customDebugToken: debugToken,
      );
    } else {
      // Other platforms - use standard configuration
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.playIntegrity,
        appleProvider: AppleProvider.deviceCheck,
      );
    }
  } else {
    // Production setup with proper attestation providers
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.deviceCheck,
    );
  }
}

/// Example 4: Combined approach with different tokens per environment
/// Best practice for team environments
Future<void> setupForDifferentEnvironments() async {
  await Firebase.initializeApp();
  
  // Select provider based on build mode
  final AndroidProvider androidProvider = kDebugMode 
      ? AndroidProvider.debug
      : AndroidProvider.playIntegrity;
      
  final AppleProvider appleProvider = kDebugMode
      ? AppleProvider.debug
      : AppleProvider.deviceCheck;
  
  // Only use custom token in debug mode
  String? customDebugToken;
  
  if (kDebugMode) {
    // Check for environment-specific tokens first
    if (const bool.fromEnvironment('DEV_ENV')) {
      customDebugToken = Platform.environment['DEV_APP_CHECK_TOKEN'];
    } else if (const bool.fromEnvironment('STAGING_ENV')) {
      customDebugToken = Platform.environment['STAGING_APP_CHECK_TOKEN'];
    } else {
      // Default token
      customDebugToken = Platform.environment['DEBUG_APP_CHECK_TOKEN'];
    }
    
    if (customDebugToken?.isNotEmpty == true) {
      debugPrint('Using custom debug token for environment');
    }
  }
  
  await FirebaseAppCheck.instance.activate(
    androidProvider: androidProvider,
    appleProvider: appleProvider,
    customDebugToken: customDebugToken,
  );
}
