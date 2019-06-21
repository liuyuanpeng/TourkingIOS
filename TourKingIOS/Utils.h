//
//  Utils.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/8.
//  Copyright © 2019 default. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject

+ (BOOL)validatePhoneNumber:(NSString *)mobileNum;
+ (NSTimeInterval) getMonthBeginOfDate: (NSDate *)date;
+ (NSTimeInterval) getMonthEndOfDate: (NSDate *)date;
+ (NSDictionary *)getDayPeriod: (NSDate *)date;
+ (BOOL)locationAccess;
+ (BOOL)photoAccess;
+ (BOOL)cameraAccess;
+ (NSTimeInterval)getDeleteTimeInterval;
@end

NS_ASSUME_NONNULL_END
