//
//  Income.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/16.
//  Copyright © 2019 default. All rights reserved.
//

#import "Income.h"
#import "AFNRequestManager.h"
#import "User.h"
#import "Utils.h"

@implementation Income
+ (Income *)shareInstance {
    static dispatch_once_t onceToken;
    static Income *instance;
    dispatch_once(&onceToken, ^{
        instance = [[Income alloc] init];
    });
    return instance;
}

- (void)getListWithMonth:(NSDate *)month callback:(void(^)(BOOL ok))loadingOK {
    if ([User shareInstance].id == nil) {
        loadingOK(NO);
        return;
    }
    NSDictionary *data = @{
                           @"driver_user_id": [User shareInstance].id,
                           @"start": [NSNumber numberWithDouble:[Utils getMonthBeginOfDate:month]*1000],
                           @"end": [NSNumber numberWithDouble:[Utils getMonthEndOfDate:month]*1000]
                           };
    __weak __typeof(self)weakSelf = self;
    [AFNRequestManager requestAFURL:@"/travel/order/driver/settled_list" httpMethod:METHOD_POST params:nil data:data succeed:^(NSDictionary *ret) {
        if (ret == nil) {
            loadingOK(NO);
            return;
        }
        NSDictionary *data = [ret objectForKey:@"data"];
        weakSelf.orders = [NSArray arrayWithArray:[data objectForKey:@"travel_order_list"]];
        weakSelf.total = [[data objectForKey:@"total"] doubleValue];
        loadingOK(YES);
    } failure:^(NSError *error) {
        loadingOK(NO);
    }];
}

- (void)getListToday:(void (^)(BOOL))loadingOK {
    if ([User shareInstance].id == nil) {
        loadingOK(NO);
        return;
    }
    NSDictionary *dayPeriod = [Utils getDayPeriod:[NSDate date]];
    NSDictionary *data = @{
                           @"driver_user_id": [User shareInstance].id,
                           @"start": [dayPeriod objectForKey:@"start"],
                           @"end": [dayPeriod objectForKey:@"end"]
                           };
    __weak __typeof(self)weakSelf = self;
    [AFNRequestManager requestAFURL:@"/travel/order/driver/settled_list" httpMethod:METHOD_POST params:nil data:data succeed:^(NSDictionary *ret) {
        if (ret == nil) {
            loadingOK(NO);
            return;
        }
        NSDictionary *data = [ret objectForKey:@"data"];
        weakSelf.todayTotal = [[data objectForKey:@"total"] doubleValue];
        loadingOK(YES);
    } failure:^(NSError *error) {
        loadingOK(NO);
    }];
}

- (void)getListCurrentMonth:(void(^)(BOOL ok))loadingOK {
    if ([User shareInstance].id == nil) {
        loadingOK(NO);
        return;
    }
    NSDate *month = [NSDate date];
    NSDictionary *data = @{
                           @"driver_user_id": [User shareInstance].id,
                           @"start": [NSNumber numberWithDouble: [Utils getMonthBeginOfDate:month]*1000],
                           @"end": [NSNumber numberWithDouble:[Utils getMonthEndOfDate:month]*1000]
                           };
    __weak __typeof(self)weakSelf = self;
    [AFNRequestManager requestAFURL:@"/travel/order/driver/settled_list" httpMethod:METHOD_POST params:nil data:data succeed:^(NSDictionary *ret) {
        if (ret == nil) {
            loadingOK(NO);
            return;
        }
        NSDictionary *data = [ret objectForKey:@"data"];
        weakSelf.orders = [NSArray arrayWithArray:[data objectForKey:@"travel_order_list"]];
        weakSelf.total = [[data objectForKey:@"total"] doubleValue];
        loadingOK(YES);
    } failure:^(NSError *error) {
        loadingOK(NO);
    }];
}
@end
