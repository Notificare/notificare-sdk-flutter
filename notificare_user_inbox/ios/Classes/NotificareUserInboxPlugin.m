#import "NotificareUserInboxPlugin.h"
#if __has_include(<notificare_user_inbox/notificare_user_inbox-Swift.h>)
#import <notificare_user_inbox/notificare_user_inbox-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "notificare_user_inbox-Swift.h"
#endif

@implementation NotificareUserInboxPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNotificareUserInboxPlugin registerWithRegistrar:registrar];
}
@end
