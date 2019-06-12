//
//  MissionView.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/11.
//  Copyright © 2019 default. All rights reserved.
//

#import "MissionView.h"

@interface MissionView ()
{
    UILabel *_missionTitle;
    UILabel *_missionTime;
    UILabel *_startPlace;
    UILabel *_endPlace;
    UILabel *_airNO;
    UILabel *_startTime;
    UILabel *_price;
    UIButton *_right;
    UIButton *_rightEx;
}
@end

@implementation MissionView

- (instancetype) init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CGRect rScreen = [[UIScreen mainScreen] bounds];
        self.frame = CGRectMake(15, 10, rScreen.size.width - 30, 240);
        [self.layer setCornerRadius:10.0f];
        [self.layer setMasksToBounds:YES];
        
        _missionTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 150, 20)];
        [_missionTitle setFont:[UIFont boldSystemFontOfSize:20]];
        _missionTitle.text = @"未指派任务";
        [self addSubview:_missionTitle];
        
        UIImageView *timeImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 180, 23, 15, 15)];
        [timeImg setImage:[UIImage imageNamed:@"时间 (1)"]];
        [self addSubview:timeImg];
        
        _missionTime = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 165, 20, 150, 20)];
        [_missionTime setText:@"2019-00-00 10:45"];
        [_missionTime setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_missionTime];
        
        UIView *lineSep1 = [[UIView alloc] initWithFrame:CGRectMake(15, 50, self.frame.size.width - 30, 1)];
        [lineSep1 setBackgroundColor:[UIColor colorWithWhite:244/255.0 alpha:1.0]];
        [self addSubview:lineSep1];
        
        UIImageView *startPlaceImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 63, 7, 7)];
        [startPlaceImg setImage:[UIImage imageNamed:@"Oval 1"]];
        [self addSubview:startPlaceImg];
        
        _startPlace = [[UILabel alloc] initWithFrame:CGRectMake(30, 60, self.frame.size.width - 75, 13)];
        [_startPlace setFont:[UIFont systemFontOfSize:13]];
        _startPlace.text = @"djfasdlj的案件发垃圾发开发家具就阿拉斯加发加";
        [self addSubview:_startPlace];
        
        UIImageView *endPlaceImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 93, 7, 7)];
        [endPlaceImg setImage:[UIImage imageNamed:@"Oval 2"]];
        [self addSubview:endPlaceImg];
        
        _endPlace = [[UILabel alloc] initWithFrame:CGRectMake(30, 90, self.frame.size.width - 75, 13)];
        [_endPlace setFont:[UIFont systemFontOfSize:13]];
        _endPlace.text = @"djfasdlj的案件发垃圾发开发家具就阿拉斯加发加";
        [self addSubview:_endPlace];
        
        
        UIImageView *airImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 122, 10, 10)];
        [airImg setImage:[UIImage imageNamed:@"航班号"]];
        [self addSubview:airImg];
        
        _airNO = [[UILabel alloc] initWithFrame:CGRectMake(30, 120, self.frame.size.width - 115, 13)];
        [_airNO setFont:[UIFont systemFontOfSize:13]];
        _airNO.text = @"djfasdlj的案件发垃圾发开发家具就阿拉斯加发加";
        [self addSubview:_airNO];
        
        UIImageView *startTimeImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 152, 10, 10)];
        [startTimeImg setImage:[UIImage imageNamed:@"时间 "]];
        [self addSubview:startTimeImg];
        
        _startTime = [[UILabel alloc] initWithFrame:CGRectMake(30, 150, self.frame.size.width - 115, 13)];
        [_startTime setFont:[UIFont systemFontOfSize:13]];
        _startTime.text = @"djfasdlj的案件发垃圾发开发家具就阿拉斯加发加";
        [self addSubview:_startTime];
        
        UIImageView *priceImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 182, 10, 10)];
        [priceImg setImage:[UIImage imageNamed:@"价格"]];
        [self addSubview:priceImg];
        
        _price = [[UILabel alloc] initWithFrame:CGRectMake(30, 180, self.frame.size.width - 115, 13)];
        [_price setFont:[UIFont systemFontOfSize:13]];
        _price.text = @"djfasdlj的案件发垃圾发开发家具就阿拉斯加发加";
        [self addSubview:_price];
        
        UIView *lineSep2 = [[UIView alloc] initWithFrame:CGRectMake(15, 205, self.frame.size.width - 30, 1)];
        [lineSep2 setBackgroundColor:[UIColor colorWithWhite:244/255.0 alpha:1.0]];
        [self addSubview:lineSep2];
        
        UIView *lineSep3 = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 205, 1, 45)];
        [lineSep3 setBackgroundColor:[UIColor colorWithWhite:244/255.0 alpha:1.0]];
        [self addSubview:lineSep3];
        
        UIButton *mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 85, 120, 70, 70)];
        [mapBtn setBackgroundImage:[UIImage imageNamed:@"Group 6"] forState:UIControlStateNormal];
        [mapBtn addTarget:self action:@selector(onMap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mapBtn];
        
        UIButton *phone = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/4 - 50, 215, 20, 20)];
        [phone setBackgroundImage:[UIImage imageNamed:@"联系客户"] forState:UIControlStateNormal];
        [phone addTarget:self action:@selector(onPhone:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:phone];
        
        UIButton *phoneEx = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        phoneEx.frame = CGRectMake(self.frame.size.width/4 - 20, 215, 80, 20);
        [phoneEx addTarget:self action:@selector(onPhone:) forControlEvents:UIControlEventTouchUpInside];
        [phoneEx setTitle:@"联系乘客" forState:UIControlStateNormal];
        [phoneEx.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [phoneEx setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:phoneEx];
        
        _right = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width*0.75 - 50, 215, 20, 20)];
        [_right setBackgroundImage:[UIImage imageNamed:@"改派"] forState:UIControlStateNormal];
        [_right addTarget:self action:@selector(onRight:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_right];
        
        _rightEx = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _rightEx.frame = CGRectMake(self.frame.size.width*0.75 - 20, 215, 80, 20);
        [_rightEx addTarget:self action:@selector(onRight:) forControlEvents:UIControlEventTouchUpInside];
        [_rightEx setTitle:@"申请改派" forState:UIControlStateNormal];
        [_rightEx.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_rightEx setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_rightEx];
        
    }
    return self;
}

- (void) onMap: (id)sender {}

- (void)onPhone: (id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", @"18559643214"]] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@(NO)} completionHandler:nil];
}

- (void)onRight: (id)sender {
    UIButton *target = sender;
    if ([target.titleLabel.text compare:@"我要接单"] == NSOrderedSame) {
        // 接单
        
    } else if ([target.titleLabel.text compare:@"确认送达"] == NSOrderedSame) {
        // 确认送达
    } else {
        //申请改派
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确定要申请改派该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [alertController dismissViewControllerAnimated:NO completion:nil];
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [alertController dismissViewControllerAnimated:NO completion:nil];
            
        }]];
        [self.viewcontroller presentViewController:alertController animated:YES completion:nil];

    }
}


- (void) setRightBtnTitle:(NSString *)title {
    [_rightEx setTitle:title forState:UIControlStateNormal];
    if ([title compare:@"确认送达"] == NSOrderedSame) {
        [_right setBackgroundImage:[UIImage imageNamed:@"确认送达"] forState:UIControlStateNormal];
    }
    if ([title compare:@"我要接单"] == NSOrderedSame) {
        [_right setBackgroundImage:[UIImage imageNamed:@"接单"] forState:UIControlStateNormal];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
