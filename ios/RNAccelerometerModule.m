
#import "RNAccelerometerModule.h"
#import <CoreMotion/CoreMotion.h>

#import "RCTEventDispatcher.h"
#import "RCTLog.h"
#import "UIView+React.h"

@interface RCTAccelerometerEvent : NSObject <RCTEvent>

- (instancetype)initWithEventName:(NSString *)eventName
                         reactTag:(NSNumber *)reactTag
                             data:(CMAccelerometerData *)data
                    coalescingKey:(uint16_t)coalescingKey NS_DESIGNATED_INITIALIZER;

@end

@implementation RCTAccelerometerEvent
{
    CMAccelerometerData *_data;
    uint16_t _coalescingKey;
}

@synthesize viewTag = _viewTag;
@synthesize eventName = _eventName;

- (instancetype)initWithEventName:(NSString *)eventName
                         reactTag:(NSNumber *)reactTag
                             data:(CMAccelerometerData *)data
                    coalescingKey:(uint16_t)coalescingKey
{
    RCTAssertParam(reactTag);
    
    if ((self = [super init])) {
        _eventName = [eventName copy];
        _viewTag = reactTag;
        _data = data;
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
                           @"acceleration":@{
                                   @"x":@(_data.acceleration.x),
                                   @"y":@(_data.acceleration.y),
                                   @"z":@(_data.acceleration.z),
                                   }
                           };
    
    return body;
}

- (BOOL)canCoalesce
{
    return YES;
}

- (RCTAccelerometerEvent *)coalesceWithEvent:(RCTAccelerometerEvent *)newEvent
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

@interface RNAccelerometerModule ()
{
    uint16_t _coalescingKey;
    NSString *_lastEmittedEventName;
}

@end

@implementation RNAccelerometerModule

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

+ (CMMotionManager *)sharedManager
{
    if (!mManager) {
        mManager = [CMMotionManager new];
    }
    return mManager;
}

RCT_EXPORT_METHOD(startAccelerometerUpdates:(nonnull NSNumber *)viewTag eventName:(nonnull NSString *)eventName) {
    if (isRunning) {
        RCTLogError(@"Accelerometer has started already!");
        return;
    }
    if ([[self class] sharedManager].isAccelerometerAvailable) {
        isRunning = YES;
        [[self class] sharedManager].accelerometerUpdateInterval = 1.0 / 60.0;
        [[[self class] sharedManager] startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            if (accelerometerData) {
                [self sendEventWithName:eventName viewTag:viewTag data:accelerometerData];
            }
        }];
    }
}

RCT_EXPORT_METHOD(stopAccelerometerUpdates) {
    [[[self class] sharedManager] stopAccelerometerUpdates];
    isRunning = NO;
}

- (void)sendEventWithName:(NSString *)eventName
                  viewTag:(NSNumber *)viewTag
                     data:(CMAccelerometerData *)data
{
    if (![_lastEmittedEventName isEqualToString:eventName]) {
        _coalescingKey++;
        _lastEmittedEventName = [eventName copy];
    }
    RCTAccelerometerEvent *event = [[RCTAccelerometerEvent alloc] initWithEventName:eventName reactTag:viewTag data:data coalescingKey:_coalescingKey];
    [_bridge.eventDispatcher sendEvent:event];
}

@end
