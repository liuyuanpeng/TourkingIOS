//
//  OrderView.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/12.
//  Copyright © 2019 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeVC;

NS_ASSUME_NONNULL_BEGIN

@interface OrderView : UIView
- (instancetype)initWithData:(NSDictionary *)order homeVC:(HomeVC *)vc;
@end

NS_ASSUME_NONNULL_END
