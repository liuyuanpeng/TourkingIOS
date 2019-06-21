//
//  MissionView.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/11.
//  Copyright © 2019 default. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MissionView : UIView
@property (nonatomic,strong) UIViewController * viewcontroller;
- (void) setData:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
