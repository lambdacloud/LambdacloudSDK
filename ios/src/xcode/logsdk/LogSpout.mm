/**
 *   Copyright (c) 2015, LambdaCloud
 *   All rights reserved.
 *
 *   Redistribution and use in source and binary forms, with or without
 *   modification, are permitted provided that the following conditions are met:
 *
 *   1. Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 *
 *   2. Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 *   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 *   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 *   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 *   ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 *   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 *   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 *   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 *   POSSIBILITY OF SUCH DAMAGE.
 */

#import "LogSpout.h"
#import "LogRequest.h"
#import "LogSender.h"
#import "LogSdkConfig.h"
#import "LogAgent.h"

@implementation LogSpout

static LogSpout *instance = nil;

+ (instancetype)sharedInstance
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
        reqQueue = dispatch_queue_create("com.lambdacloud.reqqueue", DISPATCH_QUEUE_CONCURRENT);//并发执行队列
        timerQueue = dispatch_queue_create("com.lambdacloud.timerqueue", DISPATCH_QUEUE_SERIAL);//串行执行队列
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kSpoutSleepTimeMS * 0.001 * NSEC_PER_SEC)), timerQueue, ^{
                [self checkRequests];
            });//延迟执行
    }

    return self;
}

#pragma mark - private methods

- (void)checkRequests
{
    id req = [self firstReqInCache];
    if([self getReqCountInCache] != 0){
        if ([req isKindOfClass:[LogRequest class]]) {
            if ( req != NULL ) {
            [self removeReqInCache:req];
            [LogSender sendRequest:req];
            }
        
        } else {
            [LogAgent debug:kLogTag message:@"element type of log request queue should only be LogRequest"];
            [self removeReqInCache:req];
        }
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
            obj = [cache firstObject];
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

- (BOOL)addRequest:(NSString *)message
{
    return [self addRequest:message tags:nil];
}

- (BOOL)addRequest:(NSString *)message tags:(NSArray *)tags
{
    // For performance issue, use dispatch_sync to read count here. Count may not be very accurate since there may be some blocks in the queue.
    NSUInteger count = [self getReqCountInCache];

    if (count >= kQueueSize) {
        NSString *message = [[NSString alloc]initWithFormat:@"Log is discard since queue size is %lu",(unsigned long)[cache count]];
        [LogAgent debug:kLogTag message:message];
        return false;
    }

    LogRequest *req = [LogRequest createLogRequest:message tags:tags];
    dispatch_barrier_async(reqQueue, ^{
            [cache addObject:req];
        });//该方法会在之前block执行完之后才会执行该block
    return true;
}

@end