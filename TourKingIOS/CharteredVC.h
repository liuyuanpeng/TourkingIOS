//
//  CharteredVC.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/10/18.
//  Copyright © 2019 default. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CharteredVC : UIViewController

@property (nonatomic, strong) UITableView *tableView;

- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
