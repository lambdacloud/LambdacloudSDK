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

#import "LogSender.h"
#import "LogSdkConfig.h"
#import "LogAgent.h"
#import "LogUtil.h"

static NSString *illegalToken = nil;

@implementation LogSender


+ (BOOL)sendRequest:(LogRequest *)request
{
    NSData      *json = [request toJsonStr];
    NSString *content = [[NSString alloc] initWithData:json  encoding:NSUTF8StringEncoding];
    
    [LogUtil debug:kLogTag message:content];
    
    if (![LogSdkConfig LogSdkToken]){
        [LogUtil debug:kLogTag message:@"Token shouldn't be empty."];
        return false;
    } else if (illegalToken != NULL&&[illegalToken compare:[LogSdkConfig LogSdkToken] options:NSCaseInsensitiveSearch] == NSOrderedSame){
        [LogUtil debug:kLogTag message:@"Token is illegal, so we won't send this log any more."];
        
        return false;
    }

    if (!json) {
        [LogUtil debug:kLogTag message:@"json data is null, skip this log."];
        
        return true;
    }

    NSMutableURLRequest *http = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kHttpUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kHttpTimeoutSec];
    [http setHTTPMethod:@"PUT"];
    [http setValue:[LogSdkConfig LogSdkToken] forHTTPHeaderField:@"Token"];
    [http setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [http setHTTPBody:json];

    NSHTTPURLResponse   *response = nil;
    NSError             *error = nil;
    [NSURLConnection sendSynchronousRequest:http returningResponse:&response error:&error];

    if (!response) {
        [LogUtil debug:kLogTag message:@"response from server side is null."];
        return false;
    }
    
    if ([response statusCode] != kHttpStatusCodeSuccess) {
        NSString *message = [[NSString alloc]initWithFormat:@"value of response status code is not expected. detail is:%ld", (long)[response statusCode]];
        [LogUtil debug:kLogTag message:message];
        if([response statusCode] == kHttpStatusCodeTokenIllegal){
            NSString *message = [[NSString alloc]initWithFormat:@"The response code %ld means that the token is illegal, so we won't send this log any more.",(long)[response statusCode]];
            [LogUtil debug:kLogTag message:message];
            illegalToken = [LogSdkConfig LogSdkToken];
                  }
        return false;
    }

    [LogUtil debug:kLogTag message:@"sent one log message to lambda cloud successfully"];
    return true;
}

@end