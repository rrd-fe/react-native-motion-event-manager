
#import "RNMagnetometerModule.h"
#import <CoreMotion/CoreMotion.h>

#import "RCTEventDispatcher.h"
#import "RCTLog.h"
#import "UIView+React.h"

@interface RCTMagnetometerEvent : NSObject <RCTEvent>

- (instancetype)initWithEventName:(NSString *)eventName
                         reactTag:(NSNumber *)reactTag
                             data:(CMMagnetometerData *)data
                    coalescingKey:(uint16_t)coalescingKey NS_DESIGNATED_INITIALIZER;

@end

@implementation RCTMagnetometerEvent
{
    CMMagnetometerData *_data;
    uint16_t _coalescingKey;
}

@synthesize viewTag = _viewTag;
@synthesize eventName = _eventName;

- (instancetype)initWithEventName:(NSString *)eventName
                         reactTag:(NSNumber *)reactTag
                             data:(CMMagnetometerData *)data
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
                           @"magneticField":@{
                                   @"x":@(_data.magneticField.x),
                                   @"y":@(_data.magneticField.y),
                                   @"z":@(_data.magneticField.z),
                                   }
                           };
    
    return body;
}

- (BOOL)canCoalesce
{
    return YES;
}

- (RCTMagnetometerEvent *)coalesceWithEvent:(RCTMagnetometerEvent *)newEvent
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

@interface RNMagnetometerModule ()
{
    uint16_t _coalescingKey;
    NSString *_lastEmittedEventName;
}

@end

@implementation RNMagnetometerModule

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

+ (CMMotionManager *)sharedManager
{
    if (!mManager) {
        mManager = [CMMotionManager new];
    }
    return mManager;
}

RCT_EXPORT_METHOD(startMagnetometerUpdates:(nonnull NSNumber *)viewTag eventName:(nonnull NSString *)eventName) {
    if (isRunning) {
        RCTLogError(@"Magnetometer has started already!");
        return;
    }
    if ([[self class] sharedManager].isMagnetometerAvailable) {
        isRunning = YES;
        [[self class] sharedManager].magnetometerUpdateInterval = 1.0 / 60.0;
        [[[self class] sharedManager] startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
            if (magnetometerData) {
                [self sendEventWithName:eventName viewTag:viewTag data:magnetometerData];
            }
        }];
    }
}

RCT_EXPORT_METHOD(stopMagnetometerUpdates) {
    [[[self class] sharedManager] stopMagnetometerUpdates];
    isRunning = NO;
}

- (void)sendEventWithName:(NSString *)eventName
                  viewTag:(NSNumber *)viewTag
                     data:(CMMagnetometerData *)data
{
    if (![_lastEmittedEventName isEqualToString:eventName]) {
        _coalescingKey++;
        _lastEmittedEventName = [eventName copy];
    }
    RCTMagnetometerEvent *event = [[RCTMagnetometerEvent alloc] initWithEventName:eventName reactTag:viewTag data:data coalescingKey:_coalescingKey];
    [_bridge.eventDispatcher sendEvent:event];
}

@end
