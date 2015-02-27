//
//  LogSpout.m
//  logsdk
//
//  Created by sky4star on 15/2/13.
//  Copyright (c) 2015年 lambdacloud. All rights reserved.
//

#import "LogSpout.h"
#import "LogRequest.h"
#import "LogSender.h"
#import "LogSdkConfig.h"

@implementation LogSpout

static LogSpout *instance = nil;

+ (instancetype) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LogSpout alloc]init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        cache = [NSMutableArray array];
        reqQueue = dispatch_queue_create("com.lambdacloud.reqqueue", DISPATCH_QUEUE_CONCURRENT);
        
        timerQueue = dispatch_queue_create("com.lambdacloud.timerqueue", DISPATCH_QUEUE_SERIAL);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kSpoutSleepTimeMS * 0.001 * NSEC_PER_SEC)), timerQueue, ^{
            [self checkRequests];
        });
    }
    return self;
}

#pragma mark - private methods

- (void)checkRequests
{
    while ([cache count]) {
        id req = [self firstReqInCache];
            
        if ([req isKindOfClass:[LogRequest class]]) {
            BOOL success = [LogSender sendRequest:req];
            if (success)
            {
                dispatch_barrier_async(reqQueue, ^{
                    [cache removeObject:req];
                });
            }
        } else {
            // array element type should be LogRequest here
            NSLog(@"%@: element type of log request queue should only be LogRequest", kLogTag);
            dispatch_barrier_async(reqQueue, ^{
                [cache removeObject:req];
            });
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kSpoutSleepTimeMS * 0.001 * NSEC_PER_SEC)), timerQueue, ^{
        [self checkRequests];
    });
}

- (id)firstReqInCache
{
    __block id obj;
    dispatch_sync(reqQueue, ^{
        obj = [cache firstObject] ;
    });
    return obj;
}

#pragma mark - API methods

- (BOOL) addRequest:(NSString *)message
{
    return [self addRequest:message tags:nil];
}

- (BOOL) addRequest:(NSString *)message tags:(NSArray *)tags
{
    if ([cache count] >= kQueueSize)
    {
        NSLog(@"%@: Log is discard since queue size is %lu", kLogTag, (unsigned long)[cache count]);
        return false;
    }
    
    LogRequest *req = [LogRequest createLogRequest:message tags:tags];
    dispatch_barrier_async(reqQueue, ^{
        [cache addObject:req];
    });
    return true;
}

@end