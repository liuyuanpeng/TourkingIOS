//
//  User.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/14.
//  Copyright © 2019 default. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+ (User *)shareInstance;
- (void)setData: (NSDictionary *)data;
- (void)getDriverInfo:(void(^)(BOOL ok))loadingOK;
- (void)startSync;
- (void)stopSync;
- (void)removeSync;
- (void)updateAvatar: (NSString *)path;
- (void)logOut;
- (void)loginSuccess;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, assign) double evaluate;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *captcha_session_id;
@property (nonatomic, strong) NSDictionary *coordinate;
@property (nonatomic, assign) BOOL bBusy;
@end
