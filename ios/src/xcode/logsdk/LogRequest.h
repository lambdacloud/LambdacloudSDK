//
//  LogRequest.h
//  logsdk
//
//  Created by sky4star on 15/2/13.
//  Copyright (c) 2015年 lambdacloud. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LogRequest : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSArray *tags;

+ (instancetype) createLogRequest:(NSString *)message tags:(NSArray *)tags;
- (NSData *) toJsonStr;
@end