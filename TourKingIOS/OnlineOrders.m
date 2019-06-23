//
//  OnlineOrders.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/14.
//  Copyright © 2019 default. All rights reserved.
//

#import "OnlineOrders.h"
#import "AFNRequestManager.h"
#import "User.h"

@implementation OnlineOrders
+ (OnlineOrders *)shareInstance {
    static dispatch_once_t onceToken;
    static OnlineOrders *instance;
    dispatch_once(&onceToken, ^{
        instance = [[OnlineOrders alloc] init];
    });
    return instance;
}

- (void)getList:(void(^)(BOOL ok))loadingOK {
    if ([User shareInstance].id == nil) {
        loadingOK(NO);
        return;
    }
    __weak __typeof(self)weakSelf = self;
    [AFNRequestManager requestAFURL:@"/travel/order/driver/task_list" httpMethod:METHOD_POST params:@{@"driver_user_id":[User shareInstance].id} data:@{@"page":@0,@"size":@30,@"sort_data_list":@[@{@"direction":@"ASC", @"property":@"startTime"}]} succeed:^(NSDictionary *ret) {
        if (ret == nil) {
            loadingOK(NO);
            return;
        }
        weakSelf.orders = [NSArray arrayWithArray:[[ret objectForKey:@"data"] objectForKey:@"data_list"]];
        loadingOK(YES);
    } failure:^(NSError *error) {
        loadingOK(NO);
    }];
}
@end
