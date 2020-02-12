#import "RNMotionActivity.h"
#import "RNMotionActivityError.h"
#import <CoreMotion/CoreMotion.h>

@interface RNMotionActivity()
    
@property (nonatomic, strong) CMMotionActivityManager *motionActivityManager;

@end

@implementation RNMotionActivity
{
  bool hasListeners;
}

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.motionActivityManager = [[CMMotionActivityManager alloc] init];
    }
    return self;
}


// Will be called when this module's first listener is added.
-(void)startObserving {
    hasListeners = YES;
    
    [self.motionActivityManager startActivityUpdatesToQueue: [NSOperationQueue mainQueue] withHandler:^(CMMotionActivity * _Nullable activity) {
        [self motionActivityReceived: activity];
    }];
}

// Will be called when this module's last listener is removed, or on dealloc.
-(void)stopObserving {
    hasListeners = NO;
    
    [self.motionActivityManager stopActivityUpdates];
}

RCT_EXPORT_MODULE(MotionActivity);

- (NSString *)convertStatusToString: (CMAuthorizationStatus) status API_AVAILABLE(ios(11.0)) {
    switch (status) {
        case CMAuthorizationStatusNotDetermined:
            return @"NOT_DETERMINED";
        case CMAuthorizationStatusRestricted:
            return @"RESTRICTED";
        case CMAuthorizationStatusDenied:
            return @"DENIED";
        case CMAuthorizationStatusAuthorized:
            return @"AUTHORISED";
    }
}

RCT_REMAP_METHOD(getAuthorisationStatus,
                 withAuthorizedResolver:(RCTPromiseResolveBlock)resolve
                 andAuthorizedRejecter:(RCTPromiseRejectBlock)reject)
{
    if (@available(iOS 11.0, *)) {
        CMAuthorizationStatus status = [CMMotionActivityManager authorizationStatus];

        resolve(@[[self convertStatusToString: status]]);
    } else {
        NSError *error = [RNMotionActivityError createErrorWithCode:ErrorUnavailable andDescription: RCT_ERROR_UNAVAILABLE];
        [RNMotionActivityError handleRejectBlock: reject error: error];
    }
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"activity_update"];
}

- (void)motionActivityReceived:(CMMotionActivity *) activity
{
    NSDictionary *data = @{
        @"automotive": @(activity.automotive),
        @"confidence": @(activity.confidence),
        @"cycling": @(activity.cycling),
        @"running": @(activity.running),
        @"startDate": activity.startDate,
        @"stationary": @(activity.stationary),
        @"unknown": @(activity.unknown),
        @"walking": @(activity.walking),
    };

    [self sendEventWithName:@"activity_update" body: data];
}

@end
