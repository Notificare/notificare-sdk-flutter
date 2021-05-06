#import "NotificarePushUIPlugin.h"
#if __has_include(<notificare_push_ui/notificare_push_ui-Swift.h>)
#import <notificare_push_ui/notificare_push_ui-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "notificare_push_ui-Swift.h"
#endif

@implementation NotificarePushUIPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNotificarePushUIPlugin registerWithRegistrar:registrar];
}
@end
