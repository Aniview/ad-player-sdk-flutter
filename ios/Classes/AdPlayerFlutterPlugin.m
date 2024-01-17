#import "AdPlayerFlutterPlugin.h"
#if __has_include(<adplayer_flutter_plugin/adplayer_flutter_plugin-Swift.h>)
#import <adplayer_flutter_plugin/adplayer_flutter_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "adplayer_flutter_plugin-Swift.h"
#endif

@implementation AdPlayerFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAdPlayerFlutterPlugin registerWithRegistrar:registrar];
}
@end
