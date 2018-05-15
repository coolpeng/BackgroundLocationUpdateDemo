//
//  PljLocationManager.m
//  BackgroundLocationUpdateDemo
//
//  Created by Edward on 2018/5/15.
//  Copyright © 2018年 coolpeng. All rights reserved.
//

#import "PljLocationManager.h"
#import <UIKit/UIKit.h>

@interface PljLocationManager ()<CLLocationManagerDelegate>

@property (nonatomic, assign) CGFloat minSpeed;     //最小速度
@property (nonatomic, assign) CGFloat minFilter;    //最小范围
@property (nonatomic, assign) CGFloat minInteval;   //最小时间间隔

@end

@implementation PljLocationManager

+ (instancetype)sharedManager {
    static PljLocationManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self)
    {
        [self defaultParameterSettings];
    }
    return self;
}

- (void)defaultParameterSettings {
    
    self.minSpeed = 0.5;
    self.minFilter = 25;
    self.minInteval = 120;
    self.delegate = self;
    //设置默认的定位的频率,这里我们设置精度为25,也就是25米定位一次
    self.distanceFilter  = self.minFilter;
    self.pausesLocationUpdatesAutomatically = NO;
    self.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([self respondsToSelector:@selector(allowsBackgroundLocationUpdates)]){
        self.allowsBackgroundLocationUpdates = YES;
    }
    
    if ( [self respondsToSelector:@selector(requestAlwaysAuthorization)] )
    {
        [self requestAlwaysAuthorization];
    }
}

#pragma mark CLLocationManagerDelegate
// 获取用户位置数据失败的回调方法，在此通知用户
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error:%@",error);
    if ([error code] == kCLErrorDenied){
        //访问被拒绝
    } else if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *currentLocation = locations.lastObject;
    
    // 系统获取位置信息所用的时间
    //    NSTimeInterval locationAge = -[currentLocation.timestamp timeIntervalSinceNow];
    
//    _latitude = currentLocation.coordinate.latitude;
//    _longitude = currentLocation.coordinate.longitude;
//    _speed = currentLocation.speed;
    
    NSLog(@"========\n纬度:%f\n经度:%f\n速度:%f米/秒",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude,currentLocation.speed);
    
    //根据实际情况来调整触发范围
    [self adjustDistanceFilter:currentLocation];
    
    //TODO: 一有位置更新就上传数据
    [self uploadUserLocationInfo];
}

/**
 *  规则: 如果速度小于minSpeed m/s 则把触发范围设定为25m
 *  否则将触发范围设定为minSpeed*minInteval
 *  此时若速度变化超过10% 则更新当前的触发范围(这里限制是因为不能不停的设置distanceFilter,
 *  否则uploadLocation会不停被触发)
 */
- (void)adjustDistanceFilter:(CLLocation*)location {
    
    if (location.speed < self.minSpeed )
    {
        if ( fabs(self.distanceFilter-self.minFilter) > 0.1f )
        {
            self.distanceFilter = self.minFilter;
        }
    }
    else
    {
        CGFloat lastSpeed = self.distanceFilter/self.minInteval;
        
        if ( (fabs(lastSpeed-location.speed)/lastSpeed > 0.1f) || (lastSpeed < 0) )
        {
            CGFloat newSpeed  = (int)(location.speed+0.5f);
            CGFloat newFilter = newSpeed*self.minInteval;
            self.distanceFilter = newFilter;
        }
    }
}

- (void)uploadUserLocationInfo {
    
}

@end
