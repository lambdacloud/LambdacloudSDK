//
//  logsdk.h
//  logsdk
//
//  Created by sky4star on 15/2/12.
//  Copyright (c) 2015年 lambdacloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogAgent : NSObject

+ (void) setToken:(NSString *)token;
+ (BOOL) addLog:(NSString *)message;
+ (BOOL) addLog:(NSString *)message tags:(NSArray *)tags;
@end
