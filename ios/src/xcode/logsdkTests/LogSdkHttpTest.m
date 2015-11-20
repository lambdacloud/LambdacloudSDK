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
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OHHTTPStubs.h"
#import "LogSdkConfig.h"
#import "LogRequest.h"
#import "LogSender.h"
#import "LogSpout.h"

@interface LogSdkHttpTest : XCTestCase

@end

@implementation LogSdkHttpTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testHttpRequest
{
    // Open http stubs
    [OHHTTPStubs stubRequestsPassingTest:^BOOL (NSURLRequest *request) {
        NSString *content = [NSString stringWithUTF8String:[request.HTTPBody bytes]];
        return [content isEqualToString:@"{\n  \"message\" : \"test testHttpRequest\"\n}"]
        && [request.URL.absoluteString isEqualToString:@"http://api.lambdacloud.com/log/v2"]
        && [request.HTTPMethod isEqualToString:@"PUT"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"wsresponse.json", nil)
                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];

    // Send request
    [LogSdkConfig SetLogSdkToken:@"testtoken"];
    LogRequest  *req = [LogRequest createLogRequest:@"test testHttpRequest" tags:nil];
    BOOL        success = [LogSender sendRequest:req];
    XCTAssertTrue(success);

    // Close http stubs
    [OHHTTPStubs removeAllStubs];
}

- (void)testHttpRequestWithTags
{
    // Open http stubs
    [OHHTTPStubs stubRequestsPassingTest:^BOOL (NSURLRequest *request) {
        NSString *content = [NSString stringWithUTF8String:[request.HTTPBody bytes]];
        return [content isEqualToString:@"{\n  \"message\" : \"test testHttpRequestWithTags\",\n  \"tags\" : [\n    \"test\",\n    \"tag\",\n    \"cocoa\"\n  ]\n}"]
        && [request.URL.absoluteString isEqualToString:@"http://api.lambdacloud.com/log/v2"]
        && [request.HTTPMethod isEqualToString:@"PUT"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"wsresponse.json", nil)
                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];

    // Send request
    [LogSdkConfig SetLogSdkToken:@"testtoken"];
    NSArray     *tags = [NSArray arrayWithObjects:@"test", @"tag", @"cocoa", nil];
    LogRequest  *req = [LogRequest createLogRequest:@"test testHttpRequestWithTags" tags:tags];
    BOOL        success = [LogSender sendRequest:req];
    XCTAssertTrue(success);

    // Close http stubs
    [OHHTTPStubs removeAllStubs];
}

- (void)testHttpRequestWithIllegalToken
{
    // Open http stubs
    [OHHTTPStubs stubRequestsPassingTest:^BOOL (NSURLRequest *request) {
        NSString *content = [NSString stringWithUTF8String:[request.HTTPBody bytes]];
        return [content isEqualToString:@"{\n  \"message\" : \"test testHttpRequestWithIllegalToken\",\n  \"tags\" : [\n    \"test\",\n    \"tag\",\n    \"cocoa\"\n  ]\n}"]
        && [request.URL.absoluteString isEqualToString:@"http://api.lambdacloud.com/log/v2"]
        && [request.HTTPMethod isEqualToString:@"PUT"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"wsresponse.json", nil)
                                    statusCode:406 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    // Send request
    [LogSdkConfig SetLogSdkToken:@"illegalToken"];
    NSArray     *tags = [NSArray arrayWithObjects:@"test", @"tag", @"cocoa", nil];
    LogRequest  *req = [LogRequest createLogRequest:@"test testHttpRequestWithIllegalToken" tags:tags];
    BOOL        fail = [LogSender sendRequest:req];
    XCTAssertFalse(fail);
    fail = [LogSender sendRequest:req];
    XCTAssertFalse(fail);
    
    // Close http stubs
    [OHHTTPStubs removeAllStubs];
}

- (void)testLogSpout
{
    NSMutableArray *cacheReqs = [NSMutableArray array];

    [OHHTTPStubs stubRequestsPassingTest:^BOOL (NSURLRequest *request) {
        [cacheReqs addObject:request];
        return [request.URL.absoluteString isEqualToString:@"http://api.lambdacloud.com/log/v2"]
        && [request.HTTPMethod isEqualToString:@"PUT"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"wsresponse.json", nil)
                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];

    [LogSdkConfig SetLogSdkToken:@"testtoken"];
    NSArray     *tags = [NSArray arrayWithObjects:@"test", @"logspout", @"cocoa", nil];
    LogSpout    *logSpout = [LogSpout sharedInstance];
    [logSpout addRequest:@"test testLogSpout" tags:tags];
    [NSThread sleepForTimeInterval:2.5f];

    // Number should be 2, because stubRequestsPassingTest is called twice per request, to "Make super sure that we never use a cached response"
    XCTAssertEqual([cacheReqs count], 2);

    // Close http stubs
    [OHHTTPStubs removeAllStubs];
}

- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end