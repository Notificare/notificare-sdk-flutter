#import "NotificareInAppMessagingPlugin.h"
#if __has_include(<notificare_in_app_messaging/notificare_in_app_messaging-Swift.h>)
#import <notificare_in_app_messaging/notificare_in_app_messaging-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "notificare_in_app_messaging-Swift.h"
#endif

@implementation NotificareInAppMessagingPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNotificareInAppMessagingPlugin registerWithRegistrar:registrar];
}
@end
