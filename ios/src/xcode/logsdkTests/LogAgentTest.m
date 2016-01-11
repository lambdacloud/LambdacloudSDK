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
#import "LogAgent.h"

@interface LogAgentTest : XCTestCase

@end

@implementation LogAgentTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}
//设备信息日志发送接口测试
- (void)testSendDeviceInfo
{
    // Open http stubs
    [OHHTTPStubs stubRequestsPassingTest:^BOOL (NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://api.lambdacloud.com/log/v2"]
        && [request.HTTPMethod isEqualToString:@"PUT"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"wsresponse.json", nil)
                                                statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    // Send request
    [LogSdkConfig SetLogSdkToken:@"testtoken"];
    [LogAgent setDebugMode:true];
    
    //测试数据
    NSString *userId = @"testId";
    NSArray *methods = [[NSArray alloc]initWithObjects:@"getDeviceName",@"getSystemOs",@"getOperationInfo",nil];
    
    //发送所有设备信息日志测试
    BOOL  s1 = [LogAgent sendDeviceInfo:userId properties:NULL];
    XCTAssertTrue(s1);
    
    //发送指定设备信息日志测试
    BOOL  s2 = [LogAgent sendDeviceInfo:userId methods:methods properties:NULL];
    XCTAssertTrue(s2);
    
    //发送空方法名
    XCTAssertFalse([LogAgent sendDeviceInfo:userId methods:NULL properties:NULL]);
    
    //发送大小为0的methods
    NSArray *method = [[NSArray alloc]init];
    XCTAssertFalse([LogAgent sendDeviceInfo:userId methods:method properties:NULL]);
    // Close http stubs
    [OHHTTPStubs removeAllStubs];
}

//渠道信息日志发送接口测试
- (void)testSendChannelInfo
{
    // Open http stubs
    [OHHTTPStubs stubRequestsPassingTest:^BOOL (NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://api.lambdacloud.com/log/v2"]
        && [request.HTTPMethod isEqualToString:@"PUT"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"wsresponse.json", nil)
                                                statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    // Send request
    [LogSdkConfig SetLogSdkToken:@"testtoken"];
    
    //测试数据
    NSString *userId = @"testUserId";
    NSString *channelId = @"testChannelId";
    [LogAgent setDebugMode:true];

    //渠道信息日志发送接口测试
    BOOL  success = [LogAgent sendChannelInfo:userId channelId:channelId properties:NULL];
    XCTAssertTrue(success);
    
    // Close http stubs
    [OHHTTPStubs removeAllStubs];
}

//登录登出信息日志发送接口测试
- (void)testSendLoginAndLogoutInfo
{
    // Open http stubs
    [OHHTTPStubs stubRequestsPassingTest:^BOOL (NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://api.lambdacloud.com/log/v2"]
        && [request.HTTPMethod isEqualToString:@"PUT"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"wsresponse.json", nil)
                                                statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    // Send request
    [LogSdkConfig SetLogSdkToken:@"testtoken"];
    [LogAgent setDebugMode:true];

    //测试数据
    NSString *userId = @"testUserId";
    NSString *serverId = @"testServerId";
    
    //登录信息日志发送接口测试
    BOOL  s1 = [LogAgent sendLoginInfo:userId serverId:serverId properties:NULL];
    XCTAssertTrue(s1);
    
    //登出信息日志发送接口测试
    BOOL  success = [LogAgent sendLogoutInfo:userId  properties:NULL];
    XCTAssertTrue(success);
    
    // Close http stubs
    [OHHTTPStubs removeAllStubs];
}

//关卡信息日志发送接口测试
- (void)testSendLevelInfo
{
    // Open http stubs
    [OHHTTPStubs stubRequestsPassingTest:^BOOL (NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://api.lambdacloud.com/log/v2"]
        && [request.HTTPMethod isEqualToString:@"PUT"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"wsresponse.json", nil)
                                                statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    // Send request
    [LogSdkConfig SetLogSdkToken:@"testtoken"];
    [LogAgent setDebugMode:true];
    
    //测试数据
    NSString *userId = @"西游记";
    NSString *beginLevelName = @"大闹天宫";
    NSString *completeLevelName = @"三打白骨精";
    NSString *failLevelName = @"女儿国";
    
    //开始关卡信息日志发送接口测试
    XCTAssertTrue([LogAgent sendLevelBeginInfo:userId levelName:beginLevelName properties:NULL]);
    
    //完成关卡信息日志发送接口测试
    XCTAssertTrue([LogAgent sendLevelComleteInfo:userId levelName:completeLevelName properties:NULL]);
    
    //失败关卡信息日志发送接口测试
    XCTAssertTrue([LogAgent sendLevelFailInfo:userId levelName:failLevelName properties:NULL]);
    
    // Close http stubs
    [OHHTTPStubs removeAllStubs];
}

//用户标签信息日志发送接口测试
- (void)testSendUserTagInfo
{
    // Open http stubs
    [OHHTTPStubs stubRequestsPassingTest:^BOOL (NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://api.lambdacloud.com/log/v2"]
        && [request.HTTPMethod isEqualToString:@"PUT"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"wsresponse.json", nil)
                                                statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    // Send request
    [LogSdkConfig SetLogSdkToken:@"testtoken"];
    [LogAgent setDebugMode:true];

    //测试数据
    NSString *userId = @"西游记";
    NSString *tag = @"付费玩家";
    NSString *subTag = @"小额付费玩家";
    //用户标签信息发送接口测试
    XCTAssertTrue([LogAgent sendUserTag:userId tag:tag subTag:subTag]);
    
    // Close http stubs
    [OHHTTPStubs removeAllStubs];
}

//任务信息日志发送接口测试
- (void)testSendTaskInfo
{
    // Open http stubs
    [OHHTTPStubs stubRequestsPassingTest:^BOOL (NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://api.lambdacloud.com/log/v2"]
        && [request.HTTPMethod isEqualToString:@"PUT"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"wsresponse.json", nil)
                                                statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    // Send request
    [LogSdkConfig SetLogSdkToken:@"testtoken"];
    [LogAgent setDebugMode:true];
    
    //测试数据
    NSString *userId = @"猪八戒";
    NSString *beginTaskName = @"高老庄娶亲";
    NSString *completeTaskName = @"情迷盘丝洞";
    NSString *failTaskName = @"八戒大战流沙河";
    
    //开始任务信息日志发送接口测试
    XCTAssertTrue([LogAgent sendTaskBeginInfo:userId taskName:beginTaskName properties:NULL]);
    
    //完成任务信息日志发送接口测试
    XCTAssertTrue([LogAgent sendTaskComleteInfo:userId taskName:completeTaskName properties:NULL]);
    
    //失败任务信息日志发送接口测试
    XCTAssertTrue([LogAgent sendTaskFailInfo:userId taskName:failTaskName properties:NULL]);
    
    // Close http stubs
    [OHHTTPStubs removeAllStubs];
}

//物品信息日志发送接口测试
- (void)testSendItemInfo
{
    // Open http stubs
    [OHHTTPStubs stubRequestsPassingTest:^BOOL (NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://api.lambdacloud.com/log/v2"]
        && [request.HTTPMethod isEqualToString:@"PUT"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"wsresponse.json", nil)
                                                statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    // Send request
    [LogSdkConfig SetLogSdkToken:@"testtoken"];
    [LogAgent setDebugMode:true];
    
    //测试数据
    NSString *userId = @"孙悟空";
    NSString *getItemName = @"金箍棒";
    NSString *buyItemName = @"恢复魔力值药水";
    NSString *consumeItmeName = @"长生不老丹药";
    
    //获得物品信息日志发送接口测试
    XCTAssertTrue([LogAgent sendGetItemInfo:userId itemName:getItemName properties:NULL]);
    
    //购买物品信息日志发送接口测试
    XCTAssertTrue([LogAgent sendBuyItemInfo:userId itemName:buyItemName properties:NULL]);
    
    //消耗物品信息日志发送接口测试
    XCTAssertTrue([LogAgent sendConsumeItemInfo:userId itemName:consumeItmeName properties:NULL]);
    
    // Close http stubs
    [OHHTTPStubs removeAllStubs];
}

//金币信息日志发送接口测试
- (void)testSendCoinInfo
{
    // Open http stubs
    [OHHTTPStubs stubRequestsPassingTest:^BOOL (NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://api.lambdacloud.com/log/v2"]
        && [request.HTTPMethod isEqualToString:@"PUT"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"wsresponse.json", nil)
                                                statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    // Send request
    [LogSdkConfig SetLogSdkToken:@"testtoken"];
    [LogAgent setDebugMode:true];
    
    //测试数据
    NSString *userId = @"沙和尚";
    NSString *coinType = @"钻石";
    long gain = 1000;
    long use = 388;
    long total = 3000;
    NSString *gainReason = @"打败黑风怪";
    NSString *useReason = @"被白骨精打伤";
 
    //获得金币信息日志发送接口测试
    XCTAssertTrue([LogAgent sendGainCoinInfo:userId coinType:coinType gain:gain total:total reason:gainReason properties:NULL]);
    
    //消耗金币信息日志发送接口测试
    XCTAssertTrue([LogAgent sendConsumeCoinInfo:userId coinType:coinType use:use total:total reason:useReason properties:NULL]);
    
    // Close http stubs
    [OHHTTPStubs removeAllStubs];
}

- (void)testSendPayInfo
{
    // Open http stubs
    [OHHTTPStubs stubRequestsPassingTest:^BOOL (NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://api.lambdacloud.com/log/v2"]
        && [request.HTTPMethod isEqualToString:@"PUT"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"wsresponse.json", nil)
                                                statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    // Send request
    [LogSdkConfig SetLogSdkToken:@"testtoken"];
    [LogAgent setDebugMode:true];
    
    //测试数据
    NSString *userId = @"唐僧";
    NSString *orderId = @"支付宝：12345667889";
    NSString *iapId = @"付费模式";
    NSString *amount = @"200";
    NSString *currencyType = @"RMB";
    NSString *paymentType = @"支付宝";
    
    //支付信息日志发送接口测试
    XCTAssertTrue([LogAgent sendCurrencyPaymentInfo:userId orderId:orderId iapId:iapId amount:amount currencyType:currencyType paymentType:paymentType properties:NULL]);
    
    // Close http stubs
    [OHHTTPStubs removeAllStubs];
}

//自定义日志发送接口测试
- (void)testSendCustomizedInfo
{
    // Open http stubs
    [OHHTTPStubs stubRequestsPassingTest:^BOOL (NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://api.lambdacloud.com/log/v2"]
        && [request.HTTPMethod isEqualToString:@"PUT"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"wsresponse.json", nil)
                                                statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    // Send request
    [LogSdkConfig SetLogSdkToken:@"testtoken"];
    [LogAgent setDebugMode:true];
    
    //测试数据
    NSString *userId = @"唐僧";
    NSString *logType = @"partner_info";
    NSMutableDictionary *properties = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"孙悟空",@"大师兄",@"猪八戒",@"二师兄",@"沙僧",@"三师兄",nil];
    //自定义日志发送接口测试
    XCTAssertTrue([LogAgent sendCustomizedInfo:userId logType:logType properties:properties]);
    
    // Close http stubs
    [OHHTTPStubs removeAllStubs];
}

//漏斗日志发送接口测试
- (void)testSendCustomizedFunnel
{
    // Open http stubs
    [OHHTTPStubs stubRequestsPassingTest:^BOOL (NSURLRequest *request) {
        return [request.URL.absoluteString isEqualToString:@"http://api.lambdacloud.com/log/v2"]
        && [request.HTTPMethod isEqualToString:@"PUT"];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"wsresponse.json", nil)
                                                statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    // Send request
    [LogSdkConfig SetLogSdkToken:@"testtoken"];
    [LogAgent setDebugMode:true];
    
    //测试数据
    NSString *userId = @"西游记";
    NSString *funnelType = @"da_nao_tian_gong";
    NSString *stepName = @"da_zhan_erlangshen";
    NSString *stepStatus = @"begin";
    NSString *decsription = @"大战二郎神";
    //自定义日志发送接口测试
    XCTAssertTrue([LogAgent sendCustomizedFunnel:userId funnelType:funnelType stepName:stepName stepStatus:stepStatus description:decsription properties:NULL]);
    
    // Close http stubs
    [OHHTTPStubs removeAllStubs];
}

@end
