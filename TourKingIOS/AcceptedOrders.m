//
//  AcceptedOrders.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/14.
//  Copyright © 2019 default. All rights reserved.
//

#import "AcceptedOrders.h"
#import "AFNRequestManager.h"
#import "User.h"

@implementation AcceptedOrders
+ (AcceptedOrders *)shareInstance {
    static dispatch_once_t onceToken;
    static AcceptedOrders *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AcceptedOrders alloc] init];
    });
    return instance;
}

- (void)getList:(void(^)(BOOL ok))loadingOK {
    if ([User shareInstance].id == nil) {
        loadingOK(NO);
        return;
    }
    __weak __typeof(self)weakSelf = self;
    [AFNRequestManager requestAFURL:@"/travel/order/driver/accepted_list" httpMethod:METHOD_POST params:@{@"driver_user_id":[User shareInstance].id} data:nil succeed:^(NSDictionary *ret) {
        if (ret == nil) {
            loadingOK(NO);
            return;
        }
        weakSelf.orders = [NSArray arrayWithArray:[ret objectForKey:@"data"]];
        [weakSelf checkBusy];
        
        loadingOK(YES);
//        [AFNRequestManager requestAFURL:@"/travel/driver/driver_cancel_page" httpMethod:METHOD_POST params:@{@"driver_user_id": [User shareInstance].id} data:@[] succeed:^(NSDictionary *cancelRet) {
//            if (cancelRet == nil) {
//                loadingOK(NO);
//                return;
//            }
//            NSMutableArray *arr = [NSMutableArray arrayWithArray:weakSelf.orders];
//            NSArray *cacelArray = [cancelRet objectForKey:@"data"];
//            for (NSArray *a in cacelArray) {
//                [arr addObject:a];
//            }
//            weakSelf.orders = [NSArray arrayWithArray:arr];
//            loadingOK(YES);
//        } failure:^(NSError *error) {
//            loadingOK(NO);
//        }];
    } failure:^(NSError *error) {
        loadingOK(NO);
    }];
}

- (void)checkBusy {
    if (self.orders && self.orders.count) {
        for (NSInteger i = 0; i < self.orders.count; i++) {
            if ([[[self.orders objectAtIndex:i] objectForKey:@"order_status"] compare:@"ON_THE_WAY"] == NSOrderedSame) {
                [User shareInstance].bBusy = YES;
                return;
            }
        }
    }
    [User shareInstance].bBusy = NO;
}
@end
