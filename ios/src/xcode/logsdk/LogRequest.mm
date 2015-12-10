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

#import "LogRequest.h"
#import "LogSdkConfig.h"
#import "LogAgent.h"

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

- (NSData *)toJsonStr
{
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:_message, @"message", nil];

    if (_tags) {
        [info setObject:_tags forKey:@"tags"];
    }

    NSError *error = nil;
    NSData  *jsonData = [NSJSONSerialization    dataWithJSONObject:info
                                                options:NSJSONWritingPrettyPrinted error:&error];

    if (!jsonData) {
        NSString *message = [[NSString alloc]initWithFormat:
                             @"Got an exception while generating json data for log %@", error];
        [LogAgent debug:kLogTag message:message];
    }

    return jsonData;
}

@end