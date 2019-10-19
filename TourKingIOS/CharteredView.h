//
//  CharteredView.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/10/18.
//  Copyright © 2019 default. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CharteredView : UIView

@property (nonatomic,strong) UIViewController * viewcontroller;
- (void) setData:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
