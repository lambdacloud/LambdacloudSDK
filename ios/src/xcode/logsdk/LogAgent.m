//
//  logsdk.m
//  logsdk
//
//  Created by sky4star on 15/2/12.
//  Copyright (c) 2015年 lambdacloud. All rights reserved.
//

#import "LogAgent.h"
#import "LogSdkConfig.h"
#import "LogSpout.h"

@implementation LogAgent

+ (void) setToken:(NSString *)token
{
    [LogSdkConfig SetLogSdkToken:token];
}

+ (BOOL) addLog:(NSString *)message
{
    return [[LogSpout sharedInstance] addRequest:message];
}

+ (BOOL) addLog:(NSString *)message tags:(NSArray *)tags
{
    return [[LogSpout sharedInstance] addRequest:message tags:tags];
}

@end
