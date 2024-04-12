#import "NotificareGeoPlugin.h"
#if __has_include(<notificare_geo/notificare_geo-Swift.h>)
#import <notificare_geo/notificare_geo-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "notificare_geo-Swift.h"
#endif

@implementation NotificareGeoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [NotificareGeoPluginBackgroundService registerWithRegistrar:registrar];
  [SwiftNotificareGeoPlugin registerWithRegistrar:registrar];
}
@end
