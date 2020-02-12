//
//  MotionActivityError.h
//  MotionActivity
//
//  Created by Arturs Vonda on 11/02/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

extern NSString * const RCT_ERROR_UNAVAILABLE;

typedef NS_ENUM(NSInteger, MotionActivityErrorCode)
{
    ErrorUnavailable   = -100,
};

@interface RNMotionActivityError : NSObject
+(NSError *)createErrorWithCode: (NSInteger) code andDescription: (NSString *) description;
+(void)handleRejectBlock: (RCTPromiseRejectBlock) reject error: (NSError *) error;
@end
