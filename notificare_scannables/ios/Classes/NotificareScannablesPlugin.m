#import "NotificareScannablesPlugin.h"
#if __has_include(<notificare_scannables/notificare_scannables-Swift.h>)
#import <notificare_scannables/notificare_scannables-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "notificare_scannables-Swift.h"
#endif

@implementation NotificareScannablesPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNotificareScannablesPlugin registerWithRegistrar:registrar];
}
@end
