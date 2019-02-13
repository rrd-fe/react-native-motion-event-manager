
#import "RNGyroscopeModule.h"
#import <CoreMotion/CoreMotion.h>

#import "RCTEventDispatcher.h"
#import "RCTLog.h"
#import "UIView+React.h"

@interface RCTGyroscopeEvent : NSObject <RCTEvent>

- (instancetype)initWithEventName:(NSString *)eventName
                         reactTag:(NSNumber *)reactTag
                             data:(CMGyroData *)data
                    coalescingKey:(uint16_t)coalescingKey NS_DESIGNATED_INITIALIZER;

@end

@implementation RCTGyroscopeEvent
{
    CMGyroData *_data;
    uint16_t _coalescingKey;
}

@synthesize viewTag = _viewTag;
@synthesize eventName = _eventName;

- (instancetype)initWithEventName:(NSString *)eventName
                         reactTag:(NSNumber *)reactTag
                             data:(CMGyroData *)data
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
                           @"rotationRate":@{
                                   @"x":@(_data.rotationRate.x),
                                   @"y":@(_data.rotationRate.y),
                                   @"z":@(_data.rotationRate.z),
                                   }
                           };
    
    return body;
}

- (BOOL)canCoalesce
{
    return YES;
}

- (RCTGyroscopeEvent *)coalesceWithEvent:(RCTGyroscopeEvent *)newEvent
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

@interface RNGyroscopeModule ()
{
    uint16_t _coalescingKey;
    NSString *_lastEmittedEventName;
}

@end

@implementation RNGyroscopeModule

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

+ (CMMotionManager *)sharedManager
{
    if (!mManager) {
        mManager = [CMMotionManager new];
    }
    return mManager;
}

RCT_EXPORT_METHOD(startGyroscopeUpdates:(nonnull NSNumber *)viewTag eventName:(nonnull NSString *)eventName) {
    if (isRunning) {
        RCTLogError(@"Gyroscope has started already!");
        return;
    }
    if ([[self class] sharedManager].isGyroAvailable) {
        isRunning = YES;
        [[self class] sharedManager].gyroUpdateInterval = 1.0 / 60.0;
        [[[self class] sharedManager] startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
            if (gyroData) {
                [self sendEventWithName:eventName viewTag:viewTag data:gyroData];
            }
        }];
    }
}

RCT_EXPORT_METHOD(stopGyroscopeUpdates) {
    [[[self class] sharedManager] stopGyroUpdates];
    isRunning = NO;
}

- (void)sendEventWithName:(NSString *)eventName
                  viewTag:(NSNumber *)viewTag
                     data:(CMGyroData *)data
{
    if (![_lastEmittedEventName isEqualToString:eventName]) {
        _coalescingKey++;
        _lastEmittedEventName = [eventName copy];
    }
    RCTGyroscopeEvent *event = [[RCTGyroscopeEvent alloc] initWithEventName:eventName reactTag:viewTag data:data coalescingKey:_coalescingKey];
    [_bridge.eventDispatcher sendEvent:event];
}

@end
