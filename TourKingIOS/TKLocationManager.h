//
//  TKLocationManager.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/19.
//  Copyright © 2019 default. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TKLocationManager : CLLocationManager
+ (TKLocationManager *)shareInstance;
- (CLLocationDistance)getDistanceWithLatitude:(double)latitude longitude:(double)longitude;

@end

NS_ASSUME_NONNULL_END
