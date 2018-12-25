
#import <UIKit/UIKit.h>

#import <React/RCTEventDispatcher.h>
#import <React/RCTView.h>

@interface DeviceMotionView : RCTView

- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher NS_DESIGNATED_INITIALIZER;

@property (copy, nonatomic) RCTDirectEventBlock onDeviceMotionChange;

- (void)startDeviceMotionUpdate;
- (void)stopDeviceMotionUpdate;

@end
