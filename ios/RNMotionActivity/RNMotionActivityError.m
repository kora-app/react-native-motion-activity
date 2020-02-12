#import "RNMotionActivityError.h"

NSString * const RCT_ERROR_UNAVAILABLE = @"Motion data not available";

static NSString *const RCTErrorDomain = @"app.kora.motion-activity";

@implementation RNMotionActivityError : NSObject

+ (NSError *) createErrorWithCode: (NSInteger) code andDescription: (NSString *) description
{
    NSString *safeDescription = (description == nil) ? @"" : description;
    return [NSError errorWithDomain:RCTErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey: safeDescription}];
}

+ (void) handleRejectBlock: (RCTPromiseRejectBlock) reject error: (NSError *) error
{
    reject([NSString stringWithFormat: @"%ld", (long)error.code], error.localizedDescription, error);
}

@end


