//
//  Utils.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/8.
//  Copyright © 2019 default. All rights reserved.
//

#import "Utils.h"
#import <DateTools/DateTools.h>
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <CoreLocation/CoreLocation.h>

@implementation Utils

// 验证手机号
+ (BOOL)validatePhoneNumber:(NSString *)mobileNum{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,175,176,185,186
     * 电信：133,1349,153,177,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,175,176,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|7[56]|8[56])\\d{8}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,177,180,189
     22         */
    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    //    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    //    NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if(([regextestmobile evaluateWithObject:mobileNum] == YES)
       || ([regextestcm evaluateWithObject:mobileNum] == YES)
       || ([regextestct evaluateWithObject:mobileNum] == YES)
       || ([regextestcu evaluateWithObject:mobileNum] == YES)
       //       || ([regextestPHS evaluateWithObject:mobileNum] == YES)
       ){
        return YES;
    }else{
        return NO;
    }
}

+ (NSTimeInterval)getDeleteTimeInterval {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:[NSDate date]];
    [comps setHour:3];
    return [calendar dateFromComponents:comps].timeIntervalSince1970;
}

+ (NSDictionary *) getDayPeriod:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSTimeInterval startInterval = [calendar dateFromComponents:comps].timeIntervalSince1970;
    NSTimeInterval endInterval = startInterval + 24*60*60;
    return @{@"start": @(startInterval*1000), @"end":@(endInterval*1000 - 1)};
}

+ (NSTimeInterval) getMonthBeginOfDate:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    
    return [calendar dateFromComponents:comps].timeIntervalSince1970;
}

+ (NSTimeInterval) getMonthEndOfDate:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    
    return [[calendar dateFromComponents:comps] dateByAddingMonths:1].timeIntervalSince1970 - 1;
}

- (NSDictionary*)getCuttentDayPeriod {
    NSDate*date = [NSDate date];
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps = [calendar components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate: date];
    [comps setHour:0];//设置开始时间为0点
    NSDate*beginDate =[calendar dateFromComponents:comps];
    NSDate*endDate = [beginDate dateByAddingTimeInterval:3600*24-1];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    NSString* startTime = [formatter stringFromDate:beginDate];
    NSString* endTime = [formatter stringFromDate:endDate];
    NSDictionary*dct = [[NSDictionary alloc] initWithObjects:@[startTime, endTime]forKeys:@[@"StartTime",@"EndTime"]];
    return dct;
}

+ (BOOL)photoAccess {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
    {
        return NO;
    }
    return YES;
}

+ (BOOL)cameraAccess {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied)
    {
        return NO;
    }
    return YES;
}


+ (BOOL)locationAccess {
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        return YES;
    }
    return NO;
}

@end
