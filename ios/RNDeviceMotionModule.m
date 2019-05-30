
#import "RNDeviceMotionModule.h"
#import <CoreMotion/CoreMotion.h>

#import <React/RCTEventDispatcher.h>
#import <React/RCTLog.h>
#import <React/UIView+React.h>

@interface RCTMotionEvent : NSObject <RCTEvent>

- (instancetype)initWithEventName:(NSString *)eventName
                         reactTag:(NSNumber *)reactTag
                             data:(CMDeviceMotion *)data
                    coalescingKey:(uint16_t)coalescingKey NS_DESIGNATED_INITIALIZER;

@end

@implementation RCTMotionEvent
{
    CMDeviceMotion *_motion;
    uint16_t _coalescingKey;
}

@synthesize viewTag = _viewTag;
@synthesize eventName = _eventName;

- (instancetype)initWithEventName:(NSString *)eventName
                         reactTag:(NSNumber *)reactTag
                             data:(CMDeviceMotion *)data
                    coalescingKey:(uint16_t)coalescingKey
{
    RCTAssertParam(reactTag);
    
    if ((self = [super init])) {
        _eventName = [eventName copy];
        _viewTag = reactTag;
        _motion = data;
        _coalescingKey = coalescingKey;
    }
    return self;
}

RCT_NOT_IMPLEMENTED(- (instancetype)init)

- (uint16_t)coalescingKey
{
    return _coalescingKey;
}

- (NSDictionary *)body
{
    NSDictionary *body = @{
                           @"attitude":@{
                                   @"pitch":@(_motion.attitude.pitch),
                                   @"roll":@(_motion.attitude.roll),
                                   @"yaw":@(_motion.attitude.yaw),
                                   },
                           @"rotationRate":@{
                                   @"x":@(_motion.rotationRate.x),
                                   @"y":@(_motion.rotationRate.y),
                                   @"z":@(_motion.rotationRate.z)
                                   },
                           @"gravity":@{
                                   @"x":@(_motion.gravity.x),
                                   @"y":@(_motion.gravity.y),
                                   @"z":@(_motion.gravity.z)
                                   },
                           @"userAcceleration":@{
                                   @"x":@(_motion.userAcceleration.x),
                                   @"y":@(_motion.userAcceleration.y),
                                   @"z":@(_motion.userAcceleration.z)
                                   },
                           @"magneticField":@{
                                   @"field":@{
                                           @"x":@(_motion.magneticField.field.x),
                                           @"y":@(_motion.magneticField.field.y),
                                           @"z":@(_motion.magneticField.field.z)
                                           },
                                   @"accuracy":@(_motion.magneticField.accuracy)
                                   }
                           };
    
    return body;
}

- (BOOL)canCoalesce
{
    return YES;
}

- (RCTMotionEvent *)coalesceWithEvent:(RCTMotionEvent *)newEvent
{
    return newEvent;
}

+ (NSString *)moduleDotMethod
{
    return @"RCTEventEmitter.receiveEvent";
}

- (NSArray *)arguments
{
    return @[self.viewTag, RCTNormalizeInputEventName(self.eventName), [self body]];
}

@end

static CMMotionManager *mManager;
static BOOL isRunning;

@interface RNDeviceMotionModule ()
{
    uint16_t _coalescingKey;
    NSString *_lastEmittedEventName;
}

@end

@implementation RNDeviceMotionModule

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

+ (CMMotionManager *)sharedManager
{
    if (!mManager) {
        mManager = [CMMotionManager new];
    }
    return mManager;
}

RCT_EXPORT_METHOD(startDeviceMotionUpdates:(nonnull NSNumber *)viewTag eventName:(nonnull NSString *)eventName) {
    if (isRunning) {
        RCTLogError(@"DeviceMotion has started already!");
        return;
    }
    if ([RNDeviceMotionModule sharedManager].isDeviceMotionAvailable) {
        isRunning = YES;
        [RNDeviceMotionModule sharedManager].deviceMotionUpdateInterval = 1.0 / 60.0;
        [[RNDeviceMotionModule sharedManager] startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            if (motion) {
                [self sendEventWithName:eventName viewTag:viewTag data:motion];
            }
        }];
    }
}

RCT_EXPORT_METHOD(stopDeviceMotionUpdates) {
    [[RNDeviceMotionModule sharedManager] stopDeviceMotionUpdates];
    isRunning = NO;
}

- (void)sendEventWithName:(NSString *)eventName
                  viewTag:(NSNumber *)viewTag
                     data:(CMDeviceMotion *)data
{
    if (![_lastEmittedEventName isEqualToString:eventName]) {
        _coalescingKey++;
        _lastEmittedEventName = [eventName copy];
    }
    RCTMotionEvent *event = [[RCTMotionEvent alloc] initWithEventName:eventName reactTag:viewTag data:data coalescingKey:_coalescingKey];
    [_bridge.eventDispatcher sendEvent:event];
}

@end
