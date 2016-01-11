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

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import <stdlib.h>
#import "LogUtil.h"

@interface LogUtilTest : XCTestCase

@end

@implementation LogUtilTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testGetBasicInfo
{
    XCTAssertNoThrow([LogUtil getBasicInfo:@"test" userId:@"testId"]);

    NSLog(@"%@",[LogUtil getBasicInfo:@"test" userId:@"testId"]);
}

- (void)testGetTimeStamp
{
    XCTAssertNoThrow([LogUtil getTimeStamp]);

    NSLog(@"时间为：%@",[LogUtil getTimeStamp]);
}

- (void)testDic2Str
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"value1",@"key1",@"value2",@"key2",@"value3",@"key3", nil];
    XCTAssertNoThrow([LogUtil dic2str:dic]);

    NSLog(@"DIC2STR: %@",[LogUtil dic2str:dic]);
}

@end