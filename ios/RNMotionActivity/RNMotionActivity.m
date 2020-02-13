#import "RNMotionActivity.h"
#import "RNMotionActivityError.h"
#import <CoreMotion/CoreMotion.h>

@interface RNMotionActivity()
    
@property (nonatomic, strong) CMMotionActivityManager *motionActivityManager;
@property (nonatomic, strong) NSISO8601DateFormatter *dateFormatter;

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
        self.dateFormatter = [[NSISO8601DateFormatter alloc] init];
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

- (NSDictionary *)convertActivityToMap: (CMMotionActivity *) activity API_AVAILABLE(ios(11.0)) {
    return @{
        @"automotive": @(activity.automotive),
        @"confidence": @(activity.confidence),
        @"cycling": @(activity.cycling),
        @"running": @(activity.running),
        @"startDate": [self.dateFormatter stringFromDate:activity.startDate],
        @"stationary": @(activity.stationary),
        @"unknown": @(activity.unknown),
        @"walking": @(activity.walking),
        @"timestamp": [self.dateFormatter stringFromDate:[NSDate date]],
    };
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


RCT_REMAP_METHOD(queryActivities,
                 fromDate: (NSDate *)fromDate
                 toDate: (NSDate *)toDate
                 withAuthorizedResolver:(RCTPromiseResolveBlock)resolve
                 andAuthorizedRejecter:(RCTPromiseRejectBlock)reject)
{
    if (@available(iOS 11.0, *)) {
        [self.motionActivityManager queryActivityStartingFromDate:fromDate toDate:toDate toQueue:[NSOperationQueue mainQueue] withHandler:^(NSArray<CMMotionActivity *> * _Nullable activities, NSError * _Nullable error) {
            if (error) {
                [RNMotionActivityError handleRejectBlock: reject error: error];
            } else {
                NSMutableArray *data = [NSMutableArray arrayWithCapacity:[activities count]];
                [activities enumerateObjectsUsingBlock:^(CMMotionActivity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [data addObject:[self convertActivityToMap:obj]];
                }];
                
                resolve(data);
            }
        }];
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
    NSDictionary *data = [self convertActivityToMap:activity];

    [self sendEventWithName:@"activity_update" body: data];
}

@end
