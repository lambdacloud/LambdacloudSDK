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
#import "DeviceInfo.h"
#import "Location.h"

@interface DeviceInfoTest : XCTestCase
{
    Location *testLocation;
}
@end

@implementation DeviceInfoTest

- (void)setUp
{
    [super setUp];
    testLocation = [Location sharedInstance];
}

- (void)tearDown
{
    testLocation = nil;
    [super tearDown];
}

- (void)testGetDeviceInfo
{
    XCTAssertNoThrow([DeviceInfo getDeviceName]);
    XCTAssertNoThrow([DeviceInfo getInternetConnectionStatus]);
    XCTAssertNoThrow([DeviceInfo getOperationInfo]);
    XCTAssertNoThrow([DeviceInfo getSystemOS]);
    XCTAssertNoThrow([DeviceInfo getBatteryPower]);
    XCTAssertNoThrow([DeviceInfo getLocation:@"lambdacloud"]);

    NSLog(@"%@", [DeviceInfo getDeviceName]);
    NSLog(@"%@", [DeviceInfo getInternetConnectionStatus]);
    NSLog(@"%@", [DeviceInfo getOperationInfo]);
    NSLog(@"%@", [DeviceInfo getSystemOS]);
    NSLog(@"%@", [DeviceInfo getBatteryPower]);
}

//获取位置信息功能测试
//初始化测试
- (void)testClassInitializes
{
    XCTAssertNotNil(testLocation);
}
//单例化测试
- (void)testSharedInstance
{
    XCTAssertEqualObjects(testLocation, [Location sharedInstance]);
}
//更新位置信息为最新数据测试(6.0版本以上)
- (void)testLocationUpdatedWithTheLatestLocationOverSixVersion
{
    [testLocation.locationManager.delegate locationManager:testLocation.locationManager
                                       didUpdateLocations:@[
                                                            [[CLLocation alloc] initWithLatitude:-79.4000
                                                                                       longitude:43.7000],
                                                            [[CLLocation alloc] initWithLatitude:-79.5000
                                                                                       longitude:43.8000],
                                                            [[CLLocation alloc] initWithLatitude:111.222
                                                                                       longitude:333.444]]];

    XCTAssertEqual(testLocation.location.coordinate.latitude, 111.222);
    XCTAssertEqual(testLocation.location.coordinate.longitude, 333.444);
    
    [testLocation.locationManager.delegate locationManager:testLocation.locationManager
                                        didUpdateLocations:@[
                                                             [[CLLocation alloc] initWithLatitude:-79.4000
                                                                                        longitude:43.7000],
                                                             [[CLLocation alloc] initWithLatitude:-79.5000
                                                                                        longitude:43.8000],
                                                             [[CLLocation alloc] initWithLatitude:11.22
                                                                                        longitude:33.44]]];

    XCTAssertEqual(testLocation.location.coordinate.latitude, 11.22);
    XCTAssertEqual(testLocation.location.coordinate.longitude, 33.44);
}

//更新位置信息为最新数据测试(6.0版本以下)
- (void)testLocationUpdatedWithTheLatestLocation
{
    [testLocation.locationManager.delegate locationManager:testLocation.locationManager didUpdateToLocation:[[CLLocation alloc]initWithLatitude:111.222 longitude:333.444] fromLocation:[[CLLocation alloc]initWithLatitude:11.22 longitude:33.44]];
    XCTAssertEqual(testLocation.location.coordinate.latitude, 11.22);
    XCTAssertEqual(testLocation.location.coordinate.longitude, 33.44);
    [testLocation.locationManager.delegate locationManager:testLocation.locationManager didUpdateToLocation:[[CLLocation alloc]initWithLatitude:11.22 longitude:33.44] fromLocation:[[CLLocation alloc]initWithLatitude:11.222 longitude:33.444]];
    XCTAssertEqual(testLocation.location.coordinate.latitude, 11.222);
    XCTAssertEqual(testLocation.location.coordinate.longitude, 33.444);
}

@end