#import "NotificareMonetizePlugin.h"
#if __has_include(<notificare_monetize/notificare_monetize-Swift.h>)
#import <notificare_monetize/notificare_monetize-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "notificare_monetize-Swift.h"
#endif

@implementation NotificareMonetizePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNotificareMonetizePlugin registerWithRegistrar:registrar];
}
@end
