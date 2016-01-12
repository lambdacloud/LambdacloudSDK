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

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/utsname.h>
#import "DeviceInfo.h"
#import "Reachability.h"
#import "Location.h"

@implementation DeviceInfo

NSString *const kNetworkNotReachable = @"NOT_REACHABLE";
NSString *const kNetworkReachableViaWifi = @"WIFI";
NSString *const kNetworkReachableViaWwan = @"WWAN";
NSString *const kUnknown = @"UNKNOWN";
NSString *const kIOS4OrEarlier = @"iOS4";
NSString *const kIOS5 = @"iOS5";
NSString *const kIOS6 = @"iOS6";
NSString *const kIOS7 = @"iOS7";
NSString *const kIOS8 = @"iOS8";
NSString *const kIOS9 = @"iOS9";

+ (NSString *)getInternetConnectionStatus
{
    NetworkStatus status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];

    if (status == ReachableViaWiFi) {
        return kNetworkReachableViaWifi;
    }

    if (status == ReachableViaWWAN) {
        return kNetworkReachableViaWwan;
    }

    return kNetworkNotReachable;
}

+ (NSString *)getDeviceName
{
    struct utsname systemInfo;

    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
           encoding:NSUTF8StringEncoding];
}

+ (NSString *)getOperationInfo
{
    CTTelephonyNetworkInfo  *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier               *carrier = [netinfo subscriberCellularProvider];

    if (carrier != nil) {
        NSString *carrierName = [carrier carrierName];
        return carrierName;
    } else {
        return kUnknown;
    }
}

+ (NSString *)getSystemOS
{
    double iOSVersion = floor(NSFoundationVersionNumber);

    if (iOSVersion < NSFoundationVersionNumber_iOS_5_0) {
        return kIOS4OrEarlier;
    } else if (iOSVersion < NSFoundationVersionNumber_iOS_6_0) {
        return kIOS5;
    } else if (iOSVersion < NSFoundationVersionNumber_iOS_7_0) {
        return kIOS6;
    } else if (iOSVersion < NSFoundationVersionNumber_iOS_8_0) {
        return kIOS7;
    } else if (iOSVersion <= NSFoundationVersionNumber_iOS_8_3){
        return kIOS8;
    } else {
        return kIOS9;
    }
}

+ (NSString *)getBatteryPower
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    double deviceLevel = [UIDevice currentDevice].batteryLevel;
    NSString *batteryPower = [NSString stringWithFormat:@"%g%%",deviceLevel * 100];
    return batteryPower;
}

+ (void)getLocation:(NSString *)userId
{
    Location *location = [Location sharedInstance];
    [location startLocation:userId];
}
@end