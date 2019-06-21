//
//  User.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/14.
//  Copyright © 2019 default. All rights reserved.
//

#import "User.h"
#import "AFNRequestManager.h"
#import "DBManager.h"
#import "NowOrders.h"

@interface User ()
{
    dispatch_source_t _timer;
}
@end

@implementation User
+ (User *)shareInstance {
    static dispatch_once_t onceToken;
    static User *instance;
    dispatch_once(&onceToken, ^{
        instance = [[User alloc] init];
    });
    return instance;
}

- (void)setData:(NSDictionary *)data {
    NSDictionary *user = [data objectForKey:@"user"];
    NSDictionary *token_session = [data objectForKey:@"token_session"];
    self.id = [user objectForKey:@"id"];
    self.name = [user objectForKey:@"name"];
    self.phone =[user objectForKey:@"mobile"];
    self.avatar = [user objectForKey:@"avatar"];
//    self.evaluate = [data valueForKey:@"evaluate"];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.id forKey:@"USER_ID"];
    [userDefault setObject:[token_session objectForKey:@"token"] forKey:@"TOKEN"];
    [userDefault setObject:@"ISLOGIN" forKey:@"ISLOGIN"];
    [userDefault synchronize];
}

- (void)loginSuccess {
    [self startSync];
}

- (void)logOut {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"ISLOGIN"];
    [userDefault removeObjectForKey:@"USER_ID"];
    [userDefault removeObjectForKey:@"TOKEN"];
    [self removeSync];
    [[NowOrders shareInstance] removeListen];
    self.id = nil;
}

- (void)getDriverInfo:(void(^)(BOOL ok))loadingOK {
    if (self.id == nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.id = [userDefaults objectForKey:@"USER_ID"];
    }
    if (self.id == nil) {
        return;
    }
    [AFNRequestManager requestAFURL:@"/travel/driver/get" httpMethod:METHOD_GET params:@{@"user_id": self.id} data:nil succeed:^(NSDictionary *ret) {
        if (ret == nil)
        {
            loadingOK(NO);
            return;
        }
        NSDictionary *data = [ret objectForKey:@"data"];
        NSDictionary *driver = [data objectForKey:@"driver"];
        self.evaluate =[[driver valueForKey:@"evaluate"] doubleValue];
        NSDictionary *user = [data objectForKey:@"user"];
        self.id = [user objectForKey:@"id"];
        self.name = [user objectForKey:@"name"];
        self.phone =[user objectForKey:@"mobile"];
        self.avatar = [user objectForKey:@"avatar"];
        loadingOK(YES);
    } failure:^(NSError *error) {
        loadingOK(NO);
    }];
}

- (void)startSync {
    if (_timer == nil) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        uint64_t interval = (uint64_t)(3.0 * NSEC_PER_SEC);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), interval, 0);
        // 设置回调
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self syncInfo];
                
            });
        });
    }
    dispatch_resume(_timer);
}

- (void)stopSync {
    if(_timer)dispatch_suspend(_timer);
}

- (void)removeSync {
    if (_timer) dispatch_cancel(_timer);
    _timer = nil;
}

- (void)dealloc {
    if (_timer) dispatch_cancel(_timer);
    _timer = nil;
}

- (void)syncInfo {
    if (self.id == nil || self.coordinate == nil) {
        return;
    }
    NSDictionary *data = @{
                           @"driver_user_id": self.id,
                           @"status": self.bBusy ? @"WORK" : @"UNKNOWN",
                           @"latitude": [self.coordinate objectForKey:@"latitude"],
                           @"longitude": [self.coordinate objectForKey:@"longitude"]
                           };
    [AFNRequestManager requestAFURL:@"/travel/driver/sync" httpMethod:METHOD_POST params:nil data:data succeed:^(NSDictionary *ret) {
    } failure:nil];
}

- (void)updateAvatar:(NSString *)path {
    NSDictionary *data = @{
                          @"avatar": [NSString stringWithString:path],
                          @"user_id": [NSString stringWithString:self.id],
                          @"mobile": self.phone,
                          @"name": self.name
                          };
    [AFNRequestManager requestAFURL:@"/user/update" httpMethod:METHOD_POST params:nil data:data succeed:^(NSDictionary *ret) {
        if (ret != nil) {
            NSLog(@"更新头像成功");
            self.avatar = [NSString stringWithString:path];
        }
    } failure:nil];
}

@end
