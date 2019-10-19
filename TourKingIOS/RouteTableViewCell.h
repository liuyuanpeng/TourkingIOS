//
//  RouteTableViewCell.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/10/19.
//  Copyright © 2019 default. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RouteTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setData:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
