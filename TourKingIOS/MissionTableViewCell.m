//
//  MissionTableViewCell.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/11.
//  Copyright © 2019 default. All rights reserved.
//

#import "MissionTableViewCell.h"
#import "MissionView.h"
#import "CharteredView.h"
#import "DayView.h"

@interface MissionTableViewCell ()
{
    MissionView *_missionView;
    CharteredView *_charteredView;
    DayView *_dayView;
}
@end

@implementation MissionTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView viewController:(nonnull UIViewController *)viewControlelr scene:(nonnull NSString *)scene{
    static NSString *cellIdentifier = @"mission_view_cell";
    // 该动态高度cell的reuse有问题，不再使用reuse
    MissionTableViewCell *cell = nil;
    [cell prepareForReuse];
    if (cell == nil) {
        cell.scene = scene;
        MissionTableViewCell *viewCell = [MissionTableViewCell alloc];
        viewCell.scene = scene;
        cell = [viewCell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier viewController: viewControlelr];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier viewController: (UIViewController *) viewController {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // UI code here
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        if ([self.scene compare:@"ROAD_PRIVATE"] == NSOrderedSame) {
            _charteredView = [[CharteredView alloc] init];
            _charteredView.viewcontroller = viewController;
            [self.contentView addSubview:_charteredView];
        } else if ([self.scene compare:@"DAY_PRIVATE"] == NSOrderedSame) {
            _dayView = [[DayView alloc] init];
            _dayView.viewcontroller = viewController;
            [self.contentView addSubview:_dayView];
        }
        else {
            _missionView = [[MissionView alloc] init];
            _missionView.viewcontroller = viewController;
            [self.contentView addSubview:_missionView];
        }
    }
    return self;
}

- (void)setData:(NSDictionary *)data {
    if ([self.scene compare:@"ROAD_PRIVATE"] == NSOrderedSame) {
        [_charteredView setData:data];
    } else if ([self.scene compare:@"DAY_PRIVATE"] == NSOrderedSame) {
        [_dayView setData:data];
    }else {
        [_missionView setData: data];
    }
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
