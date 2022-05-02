#import "NotificarePlugin.h"
#if __has_include(<notificare_flutter/notificare_flutter-Swift.h>)
#import <notificare_flutter/notificare_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "notificare_flutter-Swift.h"
#endif

@implementation NotificarePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNotificarePlugin registerWithRegistrar:registrar];
}
@end
