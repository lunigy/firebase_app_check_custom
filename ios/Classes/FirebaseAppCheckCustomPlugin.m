#import "FirebaseAppCheckCustomPlugin.h"
#import "../firebase_app_check/Sources/firebase_app_check/include/FLTFirebaseAppCheckPlugin.h"

// Define this constant locally to match what's used in FLTFirebaseAppCheckPlugin
static NSString *const kFLTFirebaseAppCheckChannelName = @"plugins.flutter.io/firebase_app_check";

@implementation FirebaseAppCheckCustomPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  // Create our own channel with the exact same name as in the original implementation
  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:kFLTFirebaseAppCheckChannelName
                                  binaryMessenger:[registrar messenger]];
  
  // Initialize the plugin instance with the messenger
  FLTFirebaseAppCheckPlugin *instance =
      [[FLTFirebaseAppCheckPlugin alloc] init:registrar.messenger];
  
  // Add the method delegate
  [registrar addMethodCallDelegate:instance channel:channel];
}

@end
