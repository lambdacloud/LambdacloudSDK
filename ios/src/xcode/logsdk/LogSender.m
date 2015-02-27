//
//  LogSender.m
//  logsdk
//
//  Created by sky4star on 15/2/13.
//  Copyright (c) 2015年 lambdacloud. All rights reserved.
//
#import "LogSender.h"
#import "LogSdkConfig.h"

@implementation LogSender

+ (BOOL) sendRequest:(LogRequest *)request
{
    NSData *json = [request toJsonStr];
    if (!json) {
        NSLog(@"%@: json data is null, skip this log", kLogTag);
        return true;
    }
    
    NSMutableURLRequest *http = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kHttpUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kHttpTimeoutSec];
    [http setHTTPMethod:@"POST"];
    [http setValue:@"Token" forHTTPHeaderField:LogSdkToken];
    [http setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [http setHTTPBody:json];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:http returningResponse:&response error:&error];
    
    if (!response) {
        NSLog(@"%@: response from server side is null", kLogTag);
        return false;
    }
        
    if ([response statusCode] != 204) {
        NSLog(@"%@: value of response status code is not expected. detail is:%ld", kLogTag, (long)[response statusCode]);
        return false;
    }
    
    NSLog(@"%@: sent one log message to lambda cloud successfully", kLogTag);
    return true;
}

@end