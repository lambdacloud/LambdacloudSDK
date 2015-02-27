//
//  LogSpout.h
//  logsdk
//
//  Created by sky4star on 15/2/13.
//  Copyright (c) 2015年 lambdacloud. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface LogSpout : NSObject {
    dispatch_source_t _worker;
    NSArray *_reqQueue;
}

+ (instancetype) sharedInstance;

- (BOOL) addRequest:(NSString *)message;
- (BOOL) addRequest:(NSString *)message tags:(NSArray *)tags;
@end