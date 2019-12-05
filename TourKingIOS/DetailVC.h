//
//  DetailVC.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/10/18.
//  Copyright © 2019 default. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailVC : UIViewController
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableDictionary *data;
@end

NS_ASSUME_NONNULL_END
