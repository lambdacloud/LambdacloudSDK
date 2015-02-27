//
//  LogSender.h
//  logsdk
//
//  Created by sky4star on 15/2/13.
//  Copyright (c) 2015年 lambdacloud. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LogRequest.h"

@interface LogSender : NSObject

+ (BOOL) sendRequest:(LogRequest *)request;
@end
