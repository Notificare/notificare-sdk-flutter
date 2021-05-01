#import "NotificarePushPlugin.h"
#if __has_include(<notificare_push/notificare_push-Swift.h>)
#import <notificare_push/notificare_push-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "notificare_push-Swift.h"
#endif

@implementation NotificarePushPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNotificarePushPlugin registerWithRegistrar:registrar];
}
@end
