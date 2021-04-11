//
//  MissionTableViewCell.h
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/11.
//  Copyright © 2019 default. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MissionTableViewCellEx : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView viewController:(UIViewController *)viewControlelr scene:(NSString *)scene;
- (void)setData:(NSDictionary *)data;
@property (nonatomic, copy) NSString* scene;
@end


NS_ASSUME_NONNULL_END
