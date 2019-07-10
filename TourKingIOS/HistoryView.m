//
//  HistoryView.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/13.
//  Copyright © 2019 default. All rights reserved.
//

#import "HistoryView.h"
#import <DateTools/DateTools.h>

@interface HistoryView ()
@property (nonatomic, strong) UILabel *startPlace;
@property (nonatomic, strong) UILabel *endPlace;
@property (nonatomic, strong) UILabel *airNO;
@property (nonatomic, strong) UILabel *startTime;
@property (nonatomic, strong) UILabel *price;
@end

@implementation HistoryView
- (void)setData:(NSDictionary *)data {
    self.startPlace.text = [data objectForKey:@"start_place"];
    self.endPlace.text = [data objectForKey:@"target_place"];
    self.airNO.text = [NSString stringWithFormat:@"航班号: %@", [data objectForKey:@"air_no"]];
    self.startTime.text = [[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"execute_time"] doubleValue]/1000] formattedDateWithFormat:@"上车时间: MM月dd日 HH:mm"];
    self.price.text = [NSString stringWithFormat:@"一口价: %.2f",[[data objectForKey:@"price"] doubleValue]];
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CGRect rScreen = [[UIScreen mainScreen] bounds];
        self.frame = CGRectMake(15, 10, rScreen.size.width - 30, 165);
        [self.layer setCornerRadius:10.0f];
        [self.layer setMasksToBounds:YES];
        
        UIImageView *startPlaceImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 18, 7, 7)];
        [startPlaceImg setImage:[UIImage imageNamed:@"Oval 1"]];
        [self addSubview:startPlaceImg];
        
        self.startPlace = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, self.frame.size.width - 45, 15)];
        [self.startPlace setFont:[UIFont systemFontOfSize:15]];
        self.startPlace.text = @"djfasdlj的案件发垃圾发开发家具就阿拉斯加发加";
        [self addSubview:self.startPlace];
        
        UIImageView *endPlaceImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 48, 7, 7)];
        [endPlaceImg setImage:[UIImage imageNamed:@"Oval 2"]];
        [self addSubview:endPlaceImg];
        
        self.endPlace = [[UILabel alloc] initWithFrame:CGRectMake(30, 45, self.frame.size.width - 45, 15)];
        [self.endPlace setFont:[UIFont systemFontOfSize:15]];
        self.endPlace.text = @"djfasdlj的案件发垃圾发开发家具就阿拉斯加发加";
        [self addSubview:self.endPlace];
        
        UIImageView *aireImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 77, 10, 10)];
        [aireImg setImage:[UIImage imageNamed:@"航班号"]];
        [self addSubview:aireImg];
        
        self.airNO = [[UILabel alloc] initWithFrame:CGRectMake(30, 75, self.frame.size.width - 45, 15)];
        [self.airNO setFont:[UIFont systemFontOfSize:15]];
        self.airNO.text = @"djfasdlj的案件发垃圾发开发家具就阿拉斯加发加";
        [self addSubview:self.airNO];
        
        UIImageView *startTimeImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 107, 10, 10)];
        [startTimeImg setImage:[UIImage imageNamed:@"时间 "]];
        [self addSubview:startTimeImg];
        
        self.startTime = [[UILabel alloc] initWithFrame:CGRectMake(30, 105, self.frame.size.width - 45, 15)];
        [self.startTime setFont:[UIFont systemFontOfSize:15]];
        self.startTime.text = @"djfasdlj的案件发垃圾发开发家具就阿拉斯加发加";
        [self addSubview:self.startTime];

        UIImageView *priceImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 137, 10, 10)];
        [priceImg setImage:[UIImage imageNamed:@"价格"]];
        [self addSubview:priceImg];
        
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(30, 135, self.frame.size.width - 45, 15)];
        [self.price setFont:[UIFont systemFontOfSize:15]];
        self.price.text = @"djfasdlj的案件发垃圾发开发家具就阿拉斯加发加";
        [self addSubview:self.price];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
