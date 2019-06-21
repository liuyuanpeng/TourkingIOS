//
//  IncomeTableViewCell.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/13.
//  Copyright © 2019 default. All rights reserved.
//

#import "IncomeTableViewCell.h"

@interface IncomeTableViewCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *incomeLabel;
@end

@implementation IncomeTableViewCell

- (void)setName:(NSString *)name phone:(NSString *)phone time:(NSString *)time income:(NSString *)income {
    self.nameLabel.text = name;
    self.phoneLabel.text = phone;
    self.timeLabel.text = time;
    self.incomeLabel.text = income;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"incom_view_cell";
    IncomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[IncomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // UI code here
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        CGRect rScreen = [[UIScreen mainScreen] bounds];
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rScreen.size.width, 100)];
        contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:contentView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 18)];
        [self.nameLabel setFont:[UIFont systemFontOfSize:18.0]];
        [self.nameLabel setTextColor:[UIColor blackColor]];
        [contentView addSubview:self.nameLabel];
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 200, 18)];
        [self.phoneLabel setFont:[UIFont systemFontOfSize:18]];
        [self.phoneLabel setTextColor:[UIColor blackColor]];
        [contentView addSubview:self.phoneLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 58, 200, 16)];
        [self.timeLabel setFont:[UIFont systemFontOfSize:16]];
        [self.timeLabel setTextColor:[UIColor colorWithWhite:194/255.0 alpha:1.0]];
        [contentView addSubview:self.timeLabel];
        
        self.incomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(rScreen.size.width - 165, 23, 150, 20)];
        [self.incomeLabel setFont:[UIFont systemFontOfSize:20.0]];
        [self.incomeLabel setTextColor:[UIColor colorWithRed:232/255.0 green:71/255.0 blue:71/255.0 alpha:1.0]];
        self.incomeLabel.textAlignment = NSTextAlignmentRight;
        [contentView addSubview:self.incomeLabel];
    }
    return self;
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
