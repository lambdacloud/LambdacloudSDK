//
//  LogSdkConfig.m
//  logsdk
//
//  Created by sky4star on 15/2/25.
//  Copyright (c) 2015年 lambdacloud. All rights reserved.
//

#import "LogSdkConfig.h"

static NSString* logSdkToken = nil;

@implementation LogSdkConfig
NSString* const kHttpUrl = @"http://api.lambdacloud.com/log";

NSString* const kLogTag = @"LambdacloudSDK";

NSInteger const kHttpTimeoutSec = 60;

NSInteger const kQeueuSize = 100;

NSInteger const kSpoutSleepTimeMS = 1000;

NSInteger const kHttpStatusCode = 204;

+ (NSString*) LogSdkToken { @synchronized(self) {return logSdkToken; } }

+ (void) SetLogSdkToken:(NSString*)token {
    @synchronized(self) {
        logSdkToken = token;
    }
}
@end


