//
//  LogSdkConfig.h
//  logsdk
//
//  Created by sky4star on 15/2/25.
//  Copyright (c) 2015年 lambdacloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogSdkConfig : NSObject

extern NSString* const kHttpUrl;

extern NSString* const kLogTag;

extern NSInteger const kHttpTimeoutSec;

extern NSInteger const kQueueSize;

extern NSInteger const kSpoutSleepTimeMS;

extern NSInteger const kHttpStatusCode;

+ (NSString*) LogSdkToken;

+ (void) SetLogSdkToken:(NSString*)token;

@end