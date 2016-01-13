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

#import "Location.h"
#import "LogAgent.h"
#import "LogUtil.h"
#import "LogSdkConfig.h"

@implementation Location

+(id)sharedInstance
{
    static Location *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init
{    self = [super init];
    if (self != nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        //8.0以上需要显式请求定位(在使用中请求定位)
        if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) ? YES : NO) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    return self;
}

- (void)startLocation:(NSString *)userId
{
    _userID = [[NSString alloc]init];
    _userID = userId;
    [_locationManager startUpdatingLocation];
}

- (void)stopLocation
{
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [_locationManager requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
    }
}

//6.0及其以上版本调用该回调
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self stopLocation];
    _location = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:_location
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       for (CLPlacemark *place in placemarks) {
                           NSString *locationInfo = [NSString stringWithFormat:@"ldp_latitude[%g],ldp_longitude[%g],ldp_place_name[%@]",_location.coordinate.latitude,_location.coordinate.longitude, place.name];
                           [LogAgent sendLocationInfo:_userID locationInfo:locationInfo];
                       }
                   }];
}

//6.0以下调用该回调函数
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self stopLocation];
    _location = newLocation;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:_location
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       for (CLPlacemark *place in placemarks) {
                           NSString *locationInfo = [NSString stringWithFormat:@"ldp_latitude[%g],ldp_longitude[%g],ldp_place_name[%@]",_location.coordinate.latitude,_location.coordinate.longitude, place.name];
                           [LogAgent sendLocationInfo:_userID locationInfo:locationInfo];
                       }
                   }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSMutableString *errorString = [[NSMutableString alloc] init];
    if ([error domain] == kCLErrorDomain) {
        switch ([error code]) {
            case kCLErrorDenied:
                [LogUtil debug:kLogTag message:@"User denied our request."];
                break;
            case kCLErrorLocationUnknown:
                [LogUtil debug:kLogTag message:@"Can't get location info"];
            default:
                break;
        }
    } else {
        [errorString appendFormat:@"Error domain: \"%@\"  Error code: %ld\n", [error domain], (long)[error code]];
        [errorString appendFormat:@"Description: \"%@\"\n", [error localizedDescription]];
        [LogUtil debug:kLogTag message:errorString];
    }
}

@end
