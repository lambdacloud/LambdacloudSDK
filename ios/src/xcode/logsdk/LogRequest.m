//
//  LogRequest.m
//  logsdk
//
//  Created by sky4star on 15/2/13.
//  Copyright (c) 2015年 lambdacloud. All rights reserved.
//

#import "LogRequest.h"
#import "LogSdkConfig.h"

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

- (NSData *) toJsonStr
{
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys: _message, @"message", nil];
    if (_tags) {
        [info setObject:_tags forKey:@"tags"];
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info
            options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        NSLog(@"%@: Got an exception while generating json data for log %@", kLogTag, error);
    }
    return jsonData;
}

@end