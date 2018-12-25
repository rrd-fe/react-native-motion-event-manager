
#import "DeviceMotionView.h"
#import <CoreMotion/CoreMotion.h>

#import "RCTEventDispatcher.h"
#import "RCTLog.h"
#import "UIView+React.h"

@interface RCTMotionEvent : NSObject <RCTEvent>

- (instancetype)initWithEventName:(NSString *)eventName
                         reactTag:(NSNumber *)reactTag
                           motion:(CMDeviceMotion *)motion
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
                           motion:(CMDeviceMotion *)motion
                    coalescingKey:(uint16_t)coalescingKey
{
    RCTAssertParam(reactTag);
    
    if ((self = [super init])) {
        _eventName = [eventName copy];
        _viewTag = reactTag;
        _motion = motion;
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

@interface DeviceMotionView ()
{
    RCTEventDispatcher *_eventDispatcher;
    uint16_t _coalescingKey;
    NSString *_lastEmittedEventName;
}

@end

@implementation DeviceMotionView

+ (CMMotionManager *)sharedManager
{
    if (!mManager) {
        mManager = [CMMotionManager new];
    }
    return mManager;
}

- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher
{
    RCTAssertParam(eventDispatcher);
    
    if ((self = [super initWithFrame:CGRectZero])) {
        _eventDispatcher = eventDispatcher;
    }
    return self;
}

RCT_NOT_IMPLEMENTED(- (instancetype)initWithFrame:(CGRect)frame)
RCT_NOT_IMPLEMENTED(- (instancetype)initWithCoder:(NSCoder *)aDecoder)

- (void)startDeviceMotionUpdate {
    if (isRunning) {
        RCTLogError(@"There should be ONLY ONE DeviceMotionView!");
        return;
    }
    if ([DeviceMotionView sharedManager].isDeviceMotionAvailable) {
        isRunning = YES;
        [DeviceMotionView sharedManager].deviceMotionUpdateInterval = 1.0 / 60.0;
        [[DeviceMotionView sharedManager] startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            if (motion) {
                NSString *eventName = NSStringFromSelector(@selector(onDeviceMotionChange));
                [self sendMotionEventWithName:eventName motion:motion];
            }
        }];
    }
}

- (void)sendMotionEventWithName:(NSString *)eventName
                         motion:(CMDeviceMotion *)motion
{
    if (![_lastEmittedEventName isEqualToString:eventName]) {
        _coalescingKey++;
        _lastEmittedEventName = [eventName copy];
    }
    RCTMotionEvent *scrollEvent = [[RCTMotionEvent alloc] initWithEventName:eventName reactTag:self.reactTag motion:motion coalescingKey:_coalescingKey];
    [_eventDispatcher sendEvent:scrollEvent];
}

- (void)stopDeviceMotionUpdate
{
    [[DeviceMotionView sharedManager] stopDeviceMotionUpdates];
    isRunning = NO;
}

@end
