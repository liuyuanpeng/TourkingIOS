//
//  UIButton+countDown.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/11.
//  Copyright © 2019 default. All rights reserved.
//

#import "UIButton+countDown.h"

BOOL stop = NO;

@implementation UIButton (countDown)
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color {
    
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    __weak __typeof(self)weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        
        __weak __typeof(self)weakweakSelf = weakSelf;
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakweakSelf setTitleColor:mColor forState:UIControlStateNormal];                [weakweakSelf setTitle:title forState:UIControlStateNormal];
                weakweakSelf.userInteractionEnabled = YES;
            });
        } else {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakweakSelf setTitleColor:color forState:UIControlStateNormal];
                [weakweakSelf setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
                weakweakSelf.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

- (void) makeItStop {
    stop = YES;
}

- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title completion:(buttonEnd)completion {
    //倒计时时间
    stop = NO;
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    __weak __typeof(self)weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (stop) {
            dispatch_source_cancel(_timer);
            return;
        }
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        } else {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setTitle:[NSString stringWithFormat:@"%@%@",timeStr,title] forState:UIControlStateNormal];
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}
@end
