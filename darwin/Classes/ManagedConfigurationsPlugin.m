#import "ManagedConfigurationsPlugin.h"
#if __has_include(<managed_configurations/managed_configurations-Swift.h>)
#import <managed_configurations/managed_configurations-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "managed_configurations-Swift.h"
#endif

@implementation ManagedConfigurationsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftManagedConfigurationsPlugin registerWithRegistrar:registrar];
}
@end
