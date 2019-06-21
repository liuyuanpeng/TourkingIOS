//
//  MissionTableViewCell.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/11.
//  Copyright © 2019 default. All rights reserved.
//

#import "MissionTableViewCell.h"
#import "MissionView.h"

@interface MissionTableViewCell ()
{
    MissionView *_missionView;
}
@end

@implementation MissionTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView viewController:(nonnull UIViewController *)viewControlelr {
    static NSString *cellIdentifier = @"mission_view_cell";
    MissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MissionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier viewController: viewControlelr];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier viewController: (UIViewController *) viewController {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // UI code here
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _missionView = [[MissionView alloc] init];
        _missionView.viewcontroller = viewController;
        [self.contentView addSubview:_missionView];
    }
    return self;
}

- (void)setData:(NSDictionary *)data {
    [_missionView setData: data];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end