#import "NotificareAuthenticationPlugin.h"
#if __has_include(<notificare_authentication/notificare_authentication-Swift.h>)
#import <notificare_authentication/notificare_authentication-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "notificare_authentication-Swift.h"
#endif

@implementation NotificareAuthenticationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNotificareAuthenticationPlugin registerWithRegistrar:registrar];
}
@end
