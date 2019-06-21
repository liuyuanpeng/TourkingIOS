//
//  MissionVC.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/11.
//  Copyright © 2019 default. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MissionVC : UIViewController

@property (nonatomic, strong) UITableView *tableView;
- (void)refreshData;
@end


