//
//  PljLocationManager.h
//  BackgroundLocationUpdateDemo
//
//  Created by Edward on 2018/5/15.
//  Copyright © 2018年 coolpeng. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface PljLocationManager : CLLocationManager

+ (instancetype)sharedManager;
- (void)uploadUserLocationInfo;

@end
