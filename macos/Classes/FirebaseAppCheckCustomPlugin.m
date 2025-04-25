#import "FirebaseAppCheckCustomPlugin.h"
#import "../firebase_app_check/Sources/firebase_app_check/include/FLTFirebaseAppCheckPlugin.h"

@implementation FirebaseAppCheckCustomPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  // Forward the registration to the actual implementation
  [FLTFirebaseAppCheckPlugin registerWithRegistrar:registrar];
}

@end
