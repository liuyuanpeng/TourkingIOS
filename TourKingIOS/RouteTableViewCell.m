//
//  RouteTableViewCell.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/10/19.
//  Copyright © 2019 default. All rights reserved.
//

#import "RouteTableViewCell.h"
#import <LCBannerView.h>
#import <DateTools/DateTools.h>

@implementation RouteTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"route_tableview_cell";
    RouteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[RouteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // UI code here
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setData:(NSDictionary *)data {
    CGFloat contentWidth = [[UIScreen mainScreen] bounds].size.width - 40;
    NSDate *startTime = [[NSDate alloc] initWithTimeIntervalSince1970:[[data objectForKey:@"start_time"] doubleValue]/1000];
    
    UILabel *startLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 50, 20)];
    [startLab setFont:[UIFont systemFontOfSize:15]];
    startLab.text = [startTime formattedDateWithFormat: @"HH:ss"];
    [self.contentView addSubview:startLab];
    
    UIView *splitBubble = [[UIView alloc] initWithFrame:CGRectMake(50, 5, 15, 15)];
    [splitBubble setBackgroundColor: [UIColor colorWithRed:0x2b/255.0 green:0xb3/255.0 blue:0x6c/255.0 alpha:1.0]];
    splitBubble.layer.cornerRadius = 7.5f;
    [self.contentView addSubview:splitBubble];
    
    if ([[data objectForKey:@"last"] boolValue] == NO) {
        UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(57, 20, 1, [[data objectForKey:@"height"] floatValue] + 85)];
        [splitView setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:splitView];
    }
        
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, contentWidth - 70, 0)];
    [title setFont:[UIFont boldSystemFontOfSize:20]];
    [title setNumberOfLines:0];
    title.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"name"]];
    [title sizeToFit];
    [self.contentView addSubview:title];
    
    UIImageView *timeImg = [[UIImageView alloc] initWithFrame:CGRectMake(70, title.frame.size.height + 7, 10, 10)];
    [timeImg setImage:[UIImage imageNamed:@"时间 "]];
    [self.contentView addSubview:timeImg];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, title.frame.size.height + 5, 300, 15)];
    [timeLabel setFont:[UIFont systemFontOfSize:15]];
    timeLabel.text = [NSString stringWithFormat:@"%@小时", [data objectForKey:@"play_time"]];
    [self.contentView addSubview:timeLabel];
    
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(70, title.frame.size.height + 25, contentWidth - 70, 0)];
    
    NSString *images = [data objectForKey:@"images"];
    if (images && ![images isEqual:[NSNull null]]) {
        NSArray* URLs = [images componentsSeparatedByString:@","];
        BOOL hasBanner = [images length] > 0;
        if (hasBanner) {
            LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(70, title.frame.size.height + 25,contentWidth - 70, (contentWidth - 70)/2.0)
                                 delegate:nil
                                imageURLs:URLs
                     placeholderImageName:nil
                             timeInterval:10.0f
            currentPageIndicatorTintColor:[UIColor redColor]
                   pageIndicatorTintColor:[UIColor whiteColor]];
            [self.contentView addSubview:bannerView];
        }
        
        desc.frame = CGRectMake(70,  title.frame.size.height + 25 + (hasBanner ?  (contentWidth - 70)/2.0 : 0), contentWidth - 70, 0);
    }
    
    [desc setFont:[UIFont systemFontOfSize:20]];
    [desc setNumberOfLines:0];
    desc.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"day_road"]];
    [desc sizeToFit];
    [self.contentView addSubview:desc];
    
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
