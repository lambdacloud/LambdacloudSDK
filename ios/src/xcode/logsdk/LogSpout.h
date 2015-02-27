//
//  LogSpout.h
//  logsdk
//
//  Created by sky4star on 15/2/13.
//  Copyright (c) 2015年 lambdacloud. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LogSender.h"

@interface LogSpout : NSObject {
    NSMutableArray* cache;
    dispatch_queue_t reqQueue;
    dispatch_queue_t timerQueue;
}

+ (instancetype) sharedInstance;

- (BOOL) addRequest:(NSString *)message;
- (BOOL) addRequest:(NSString *)message tags:(NSArray *)tags;
@end