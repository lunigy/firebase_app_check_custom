// Copyright 2023
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check_custom/firebase_app_check_custom.dart';
import 'package:flutter/material.dart';

/// Example demonstrating how to use custom debug tokens with Firebase App Check
class CustomDebugTokenExample extends StatefulWidget {
  const CustomDebugTokenExample({Key? key}) : super(key: key);

  @override
  State<CustomDebugTokenExample> createState() => _CustomDebugTokenExampleState();
}

class _CustomDebugTokenExampleState extends State<CustomDebugTokenExample> {
  bool _initialized = false;
  String? _token;
  String? _error;
  String _statusMessage = 'Initializing Firebase...';

  // Controller for custom debug token input
  final TextEditingController _debugTokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  @override
  void dispose() {
    _debugTokenController.dispose();
    super.dispose();
  }

  // Initialize Firebase with App Check
  Future<void> _initializeFirebase() async {
    try {
      // Initialize Firebase
      await Firebase.initializeApp();
      setState(() {
        _statusMessage = 'Firebase initialized. App Check not yet activated.';
      });
      
      // Don't automatically activate App Check - we'll do that through the UI
      _initialized = true;
    } catch (e) {
      setState(() {
        _error = 'Firebase initialization failed: $e';
      });
    }
  }

  // Activate App Check with a custom debug token
  Future<void> _activateWithCustomToken(String customToken) async {
    try {
      setState(() {
        _statusMessage = 'Activating App Check with custom debug token...';
        _token = null;
      });

      // Activate App Check with debug provider and custom token
      await FirebaseAppCheck.instance.activate(
        // Use debug provider for both platforms in this example
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
        // Set the custom debug token
        customDebugToken: customToken,
      );

      // Fetch token to verify it worked
      final token = await FirebaseAppCheck.instance.getToken(true);
      
      setState(() {
        _statusMessage = 'App Check activated with custom debug token!';
        _token = token;
      });
    } catch (e) {
      setState(() {
        _error = 'App Check activation failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Debug Token Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(_statusMessage),
                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Error: $_error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Custom Debug Token Section
            if (_initialized) ...[
              Text(
                'Custom Debug Token',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _debugTokenController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your custom debug token',
                  hintText: 'Example: AAAA-BBBB-CCCC-DDDD',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_debugTokenController.text.isNotEmpty) {
                    _activateWithCustomToken(_debugTokenController.text);
                  }
                },
                child: const Text('Activate with Custom Token'),
              ),
              const SizedBox(height: 24),
            ],

            // Token Information Section
            if (_token != null) ...[
              Text(
                'Current App Check Token',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your App Check token:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _token!,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'This token will be automatically sent with requests to '
                        'Firebase services when using the Firebase SDKs.',
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Instructions Section
            const SizedBox(height: 24),
            Text(
              'Instructions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1. Enter your custom debug token above (any string format you want)',
                      style: TextStyle(height: 1.5),
                    ),
                    Text(
                      '2. Click "Activate with Custom Token"',
                      style: TextStyle(height: 1.5),
                    ),
                    Text(
                      '3. Add this token to your Firebase App Check debug tokens in the '
                      'Firebase Console to allow requests to succeed',
                      style: TextStyle(height: 1.5),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Note: You can also set the DEBUG_APP_CHECK_TOKEN environment '
                      'variable instead of using the input field above.',
                      style: TextStyle(fontStyle: FontStyle.italic, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
