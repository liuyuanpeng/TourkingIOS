//
//  UIButton+countDown.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/11.
//  Copyright © 2019 default. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonEnd)(void);

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (countDown)
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color;

- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title completion:(buttonEnd)completion;

-(void)makeItStop;
@end

NS_ASSUME_NONNULL_END
