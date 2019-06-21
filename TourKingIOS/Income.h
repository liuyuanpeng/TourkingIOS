//
//  Income.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/16.
//  Copyright © 2019 default. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Income : NSObject

+ (Income *)shareInstance;
- (void)getListWithMonth:(NSDate *)month callback:(void(^)(BOOL ok))loadingOK;
- (void)getListCurrentMonth:(void(^)(BOOL ok))loadingOK;
- (void)getListToday:(void(^)(BOOL ok))loadingOK;

@property (nonatomic, strong) NSArray *orders;
@property (nonatomic, assign) double total;
@property (nonatomic, assign) double todayTotal;
@end

NS_ASSUME_NONNULL_END
