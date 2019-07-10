//
//  TKLocationManager.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/19.
//  Copyright © 2019 default. All rights reserved.
//

#import "TKLocationManager.h"
#import "User.h"
#import <AMapNaviKit/AMapNaviKit.h>

@interface TKLocationManager () <CLLocationManagerDelegate>

@end

@implementation TKLocationManager

+ (TKLocationManager *)shareInstance {
    static dispatch_once_t onceToken;
    static TKLocationManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[TKLocationManager alloc] init];
    });
    return instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
        self.desiredAccuracy = kCLLocationAccuracyBest;
        [self requestAlwaysAuthorization];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    /*
     *  用户的坐标点
     */
    CLLocation *location = [locations firstObject];
    if (location) {
        [User shareInstance].coordinate = [NSDictionary dictionaryWithDictionary: [self locationMarsFromEarth_earthLat:location.coordinate.latitude earthLon:location.coordinate.longitude]];
    }
    
}

- (NSDictionary *)locationMarsFromEarth_earthLat:(double)latitude earthLon:(double)longitude {
    // 首先判断坐标是否属于天朝
    if (![self isInChinaWithlat:latitude lon:longitude]) {
        return @{@"latitude":@(latitude),
                 @"longitude":@(longitude)
                 };
    }
    double a = 6378245.0;
    double ee = 0.00669342162296594323;
    
    double dLat = [self transform_earth_from_mars_lat_lat:(latitude - 35.0) lon:(longitude - 35.0)];
    double dLon = [self transform_earth_from_mars_lng_lat:(latitude - 35.0) lon:(longitude - 35.0)];
    double radLat = latitude / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    
    double newLatitude = latitude + dLat;
    double newLongitude = longitude + dLon;
    NSDictionary *dic = @{@"latitude":@(newLatitude),
                          @"longitude":@(newLongitude)
                          };
    return dic;
}
- (BOOL)isInChinaWithlat:(double)lat lon:(double)lon {
    if (lon < 72.004 || lon > 137.8347)
        return NO;
    if (lat < 0.8293 || lat > 55.8271)
        return NO;
    return YES;
}
- (double)transform_earth_from_mars_lat_lat:(double)y lon:(double)x {
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 3320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

- (double)transform_earth_from_mars_lng_lat:(double)y lon:(double)x {
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}

- (CLLocationDistance)getDistanceWithLatitude:(double)latitude longitude:(double)longitude {
    if ([User shareInstance].id == nil || [User shareInstance].coordinate == nil) return 0.0f;
    NSDictionary *coordinate = [User shareInstance].coordinate;
    double _latitude = [[coordinate objectForKey:@"latitude"]doubleValue];
    double _longitude = [[coordinate objectForKey:@"longitude"] doubleValue];
    
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(_latitude,_longitude));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(latitude,longitude));
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    return distance;
}


@end
