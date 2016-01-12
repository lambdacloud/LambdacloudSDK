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

#import "LogSdkConfig.h"
#import "LogUtil.h"

@implementation LogUtil : NSObject 

+ (void)debug:(NSString *)tag message:(NSString *)message
{
    if([LogSdkConfig kDebug]){
        NSLog(@"%@:%@",tag,message);
    }
}

+ (NSString *)getBasicInfo:(NSString *)logType userId:(NSString *)userId
{
    NSString *basicInfo = [[NSString alloc]initWithFormat:@"日志类型[%@],时间[%@],用户[%@],来源[客户端],设备平台[IOS]",logType,[LogUtil getTimeStamp],userId];
    return basicInfo;
}

+ (NSString *)getTimeStamp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSXXX"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //输出格式为：2015-12-21T17:26:24.267+08:00
    return currentDateStr;
}

+ (NSString *)dic2str:(NSMutableDictionary *)properties
{
    if (properties == NULL || [properties count] == 0) {
        return @"";
    }
    NSMutableString *str = [[NSMutableString alloc]init];
    for (NSString *key in properties) {
        [str appendString:@","];
        [str appendString:key];
        [str appendString:@"["];
        [str appendString:[properties objectForKey:key]];
        [str appendString:@"]"];
    }
    return str;
}

@end