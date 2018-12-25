
#import "DeviceMotionViewManager.h"
#import "DeviceMotionView.h"
#import "RCTUIManager.h"

@implementation DeviceMotionViewManager

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(onDeviceMotionChange, RCTDirectEventBlock);

- (UIView *)view {
    return [[DeviceMotionView alloc] initWithEventDispatcher:self.bridge.eventDispatcher];
}

RCT_EXPORT_METHOD(startDeviceMotionUpdate:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, DeviceMotionView *> *viewRegistry) {
        DeviceMotionView *view = viewRegistry[reactTag];
        if ([view isKindOfClass:[DeviceMotionView class]]) {
            [view startDeviceMotionUpdate];
        }
    }];
}

RCT_EXPORT_METHOD(stopDeviceMotionUpdate:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, DeviceMotionView *> *viewRegistry) {
        DeviceMotionView *view = viewRegistry[reactTag];
        if ([view isKindOfClass:[DeviceMotionView class]]) {
            [view stopDeviceMotionUpdate];
        }
    }];
}

@end
