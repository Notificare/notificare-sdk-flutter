#import "NotificareAssetsPlugin.h"
#if __has_include(<notificare_assets/notificare_assets-Swift.h>)
#import <notificare_assets/notificare_assets-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "notificare_assets-Swift.h"
#endif

@implementation NotificareAssetsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNotificareAssetsPlugin registerWithRegistrar:registrar];
}
@end
