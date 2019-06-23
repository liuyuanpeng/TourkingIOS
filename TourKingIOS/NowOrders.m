//
//  NowOrders.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/14.
//  Copyright © 2019 default. All rights reserved.
//

#import "NowOrders.h"
#import "AFNRequestManager.h"
#import "User.h"
#import "DBManager.h"
#import "Utils.h"

@interface NowOrders()
{
    dispatch_source_t _remoteTimer;
    dispatch_source_t _delegateTimer;
}
@end

@implementation NowOrders
+ (NowOrders *)shareInstance {
    static dispatch_once_t onceToken;
    static NowOrders *instance;
    dispatch_once(&onceToken, ^{
        instance = [[NowOrders alloc] init];
    });
    return instance;
}

- (void)insertTrashOrder:(NSString *)OrderId {
    [[DBManager shareInstance] insertData:OrderId];
}

- (NSDictionary *)getFilterOrder {
    if (self.orders == nil) {
        return nil;
    }
    for (NSInteger i = 0; i < self.orders.count; i++) {
        NSDictionary *order = [self.orders objectAtIndex:i];
        NSString *orderId = [order objectForKey:@"id"];
        if ([[DBManager shareInstance] selectData:orderId]) {
            continue;
        }
        return order;
    }
    return nil;
}

- (void)getRemoteData {
    if ([User shareInstance].id == nil) {
        return;
    }
    __weak __typeof(self)weakSelf = self;
    [AFNRequestManager requestAFURL:@"/travel/order/driver/now" httpMethod:METHOD_POST params:@{@"driver_user_id": [User shareInstance].id} data:nil succeed:^(NSDictionary *ret) {
        if (ret == nil) {
            return;
        }
        weakSelf.orders = [NSArray arrayWithArray:[ret objectForKey:@"data"]];
    } failure:nil];
}

- (void)checkDelete {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber *lastUpdate = [userDefault valueForKey:@"LAST_UPDATE"];
    NSTimeInterval preInterval = lastUpdate ? [lastUpdate doubleValue] : 0;
    NSLog(@"%f", preInterval);
    NSTimeInterval deleteInterval = [Utils getDeleteTimeInterval];
    NSTimeInterval nowInterval = [NSDate date].timeIntervalSince1970;
    if (nowInterval >= deleteInterval && preInterval <= deleteInterval) {
        // 凌晨3点清理order
        [[DBManager shareInstance] deleteOrders];
    }
}

- (void)startListen {
    [self checkDelete];
    // 立即执行...
    [self getRemoteData];
    if (_remoteTimer == nil) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        _remoteTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        uint64_t interval = (uint64_t)(20.0 * NSEC_PER_SEC);
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20.0 * NSEC_PER_SEC));
        dispatch_source_set_timer(_remoteTimer, start, interval, 0);
        // 设置回调
        __weak __typeof(self)weakSelf = self;
        dispatch_source_set_event_handler(_remoteTimer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf getRemoteData];
            });
        });
    }
    if (_delegateTimer == nil) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        _delegateTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        uint64_t interval = (uint64_t)(3.0 * NSEC_PER_SEC);
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_source_set_timer(_delegateTimer, start, interval, 0);
        // 设置回调
        __weak __typeof(self)weakSelf = self;
        dispatch_source_set_event_handler(_delegateTimer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([weakSelf.delegate respondsToSelector:@selector(showModalWithOrder:)]) {
                    [weakSelf.delegate showModalWithOrder:[weakSelf getFilterOrder]];
                }
            });
        });
    }
    self.isListening = YES;
    dispatch_resume(_remoteTimer);
    dispatch_resume(_delegateTimer);
}

- (void)stopListen {
    // 记录关闭时间戳
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:@([NSDate date].timeIntervalSince1970) forKey:@"LAST_UPDATE"];
    [userDefault synchronize];
    if(_remoteTimer)dispatch_suspend(_remoteTimer);
    if(_delegateTimer)dispatch_suspend(_delegateTimer);
    self.isListening = NO;
}

- (void)removeListen {
    if (_remoteTimer) dispatch_cancel(_remoteTimer);
    _remoteTimer = nil;
    if (_delegateTimer) dispatch_cancel(_delegateTimer);
    _delegateTimer = nil;
    self.isListening = NO;
}

- (void)dealloc {
    self.isListening = NO;
    if (_remoteTimer) dispatch_cancel(_remoteTimer);
    _remoteTimer = nil;
    if (_delegateTimer) dispatch_cancel(_delegateTimer);
    _delegateTimer = nil;
}
@end
