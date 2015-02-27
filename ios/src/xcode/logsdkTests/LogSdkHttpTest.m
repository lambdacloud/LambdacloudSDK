//
//  LogSdkHttpTest.m
//  logsdk
//
//  Created by sky4star on 15/2/26.
//  Copyright (c) 2015年 lambdacloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OHHTTPStubs.h"
#import "LogSdkConfig.h"
#import "LogRequest.h"
#import "LogSender.h"

@interface LogSdkHttpTest : XCTestCase

@end

@implementation LogSdkHttpTest

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testHttpRequest {
    // Open http stubs
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSString *content = [NSString stringWithUTF8String:[request.HTTPBody bytes]];
        return [content isEqualToString:@"{\n  \"message\" : \"test testHttpRequest\"\n}"]
        && [request.URL.absoluteString isEqualToString:@"http://api.lambdacloud.com/log"]
        && [request.HTTPMethod isEqualToString:@"POST"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"wsresponse.json",nil)
                                                statusCode:204 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    // Send request
    [LogSdkConfig SetLogSdkToken:@"testtoken"];
    LogRequest *req = [LogRequest createLogRequest:@"test testHttpRequest" tags:nil];
    BOOL success = [LogSender sendRequest:req];
    XCTAssertTrue(success);
    
    // Close http stubs
    [OHHTTPStubs removeAllStubs];
}

- (void)testHttpRequestWithTags {
    // Open http stubs
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSString *content = [NSString stringWithUTF8String:[request.HTTPBody bytes]];
        return [content isEqualToString:@"{\n  \"message\" : \"test testHttpRequestWithTags\",\n  \"tags\" : [\n    \"test\",\n    \"tag\",\n    \"cocoa\"\n  ]\n}"]
        && [request.URL.absoluteString isEqualToString:@"http://api.lambdacloud.com/log"]
        && [request.HTTPMethod isEqualToString:@"POST"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"wsresponse.json",nil)
                                                statusCode:204 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    // Send request
    [LogSdkConfig SetLogSdkToken:@"testtoken"];
    NSArray *tags = [NSArray arrayWithObjects: @"test", @"tag", @"cocoa", nil];
    LogRequest *req = [LogRequest createLogRequest:@"test testHttpRequestWithTags" tags:tags];
    BOOL success = [LogSender sendRequest:req];
    XCTAssertTrue(success);
    
    // Close http stubs
    [OHHTTPStubs removeAllStubs];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end