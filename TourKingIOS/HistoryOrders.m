//
//  HistoryOrders.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/14.
//  Copyright © 2019 default. All rights reserved.
//

#import "HistoryOrders.h"
#import "AFNRequestManager.h"
#import "User.h"

@implementation HistoryOrders
+ (HistoryOrders *)shareInstance {
    static dispatch_once_t onceToken;
    static HistoryOrders *instance;
    dispatch_once(&onceToken, ^{
        instance = [[HistoryOrders alloc] init];
    });
    return instance;
}

- (HistoryOrders *)init {
    self = [super init];
    if (self) {
        self.page = 0;
        self.noMore = NO;
    }
    return self;
}
- (void)getList:(void (^)(BOOL))loadingOK {
    if ([User shareInstance].id == nil) {
        loadingOK(NO);
        return;
    }
    self.page = 0;
    __weak __typeof(self)weakSelf = self;
    [AFNRequestManager requestAFURL:@"/travel/driver/driver_order_page" httpMethod:METHOD_POST params:@{@"driver_user_id":[User shareInstance].id} data:@{@"page":@0, @"size":@5, @"sort_data_list":@[]} succeed:^(NSDictionary *ret) {
        if (ret == nil) {
            loadingOK(NO);
            return;
        }
        NSDictionary *data = [ret objectForKey:@"data"];
        weakSelf.orders = [NSArray arrayWithArray:[data objectForKey:@"data_list"]];
        if (weakSelf.orders.count < 5) {
            weakSelf.noMore = YES;
        } else {
            weakSelf.noMore = NO;
        }
        loadingOK(YES);
    } failure:^(NSError *error) {
        loadingOK(NO);
    }];
}


- (void)loadMore:(void(^)(BOOL ok))loadingOK{
    if (self.noMore || [User shareInstance].id == nil) {
        loadingOK(NO);
        return;
    }
    self.page++;
    __weak __typeof(self)weakSelf = self;
    [AFNRequestManager requestAFURL:@"/travel/driver/driver_order_page" httpMethod:METHOD_POST params:@{@"driver_user_id":[User shareInstance].id} data:@{@"page":[NSNumber numberWithInteger:self.page], @"size":@5} succeed:^(NSDictionary *ret) {
        if (ret == nil)
        {
            loadingOK(NO);
            return;
        }
        NSDictionary *data = [ret objectForKey:@"data"];
        weakSelf.orders = [weakSelf.orders arrayByAddingObjectsFromArray:[data objectForKey:@"data_list"]];
        if (weakSelf.orders.count%5 == 0) {
            weakSelf.noMore = NO;
        } else {
            weakSelf.noMore = YES;
        }
        loadingOK(YES);
    } failure:^(NSError *error) {
        loadingOK(NO);
    }];
}
@end
