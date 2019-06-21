//
//  IncomeTableViewCell.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/13.
//  Copyright © 2019 default. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IncomeTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setName:(NSString *)name phone:(NSString *)phone time:(NSString *)time income:(NSString *)income;
@end

NS_ASSUME_NONNULL_END
