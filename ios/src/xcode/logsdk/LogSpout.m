/**
 Copyright (c) 2015, LambdaCloud
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 */

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
    id req = [self firstReqInCache];
    while (req) {
        if ([req isKindOfClass:[LogRequest class]]) {
            BOOL success = [LogSender sendRequest:req];
            if (success) {
                [self removeReqInCache:req];
            }
            else {
                break;
            }
        } else {
            // array element type should be LogRequest here
            NSLog(@"%@: element type of log request queue should only be LogRequest", kLogTag);
            [self removeReqInCache:req];
        }
        req = [self firstReqInCache];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kSpoutSleepTimeMS * 0.001 * NSEC_PER_SEC)), timerQueue, ^{
        [self checkRequests];
    });
}

- (NSUInteger)getReqCountInCache
{
    __block NSUInteger count;
    dispatch_sync(reqQueue, ^{
        count = [cache count];
    });
    return count;
}

- (id)firstReqInCache
{
    __block id obj;
    dispatch_sync(reqQueue, ^{
        obj = [cache firstObject] ;
    });
    return obj;
}

- (void)removeReqInCache:(LogRequest *)req
{
    dispatch_barrier_sync(reqQueue, ^{
        [cache removeObject:req];
    });
}

#pragma mark - API methods

- (BOOL) addRequest:(NSString *)message
{
    return [self addRequest:message tags:nil];
}

- (BOOL) addRequest:(NSString *)message tags:(NSArray *)tags
{
    // For performance issue, use dispatch_sync to read count here. Count may not be very accurate since there may be some blocks in the queue.
    NSUInteger count = [self getReqCountInCache];
    if (count >= kQueueSize)
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