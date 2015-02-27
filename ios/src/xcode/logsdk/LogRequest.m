//
//  LogRequest.m
//  logsdk
//
//  Created by sky4star on 15/2/13.
//  Copyright (c) 2015年 lambdacloud. All rights reserved.
//

#import "LogRequest.h"

@implementation LogRequest

+ (instancetype)createLogRequest:(NSString *)message tags:(NSArray *)tags
{
    LogRequest *_instance = [[LogRequest alloc]init];
    
    [_instance setMessage:message];
    [_instance setTags:tags];

    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _message = nil;
        _tags = nil;
    }
    return self;
}

@end