//
//  MissionView.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/11.
//  Copyright © 2019 default. All rights reserved.
//

#import "MissionView.h"
#import "AMapVC.h"
#import <DateTools/DateTools.h>
#import "AFNRequestManager.h"
#import "User.h"
#import "HomeVC.h"
#import "MissionVC.h"
#import "Utils.h"
#import "AlertView.h"
#import <SRMModalViewController.h>

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
    UIButton *_mapBtn;
}
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) HomeVC *homeVC;
@property (nonatomic, strong) MissionVC *missionVC;
@end

@implementation MissionView

- (void)setData:(NSDictionary *)data {
    _data = [NSDictionary dictionaryWithDictionary:data];
    NSString *status = [data objectForKey:@"order_status"];
    if ([status compare:@"ACCEPTED"] == NSOrderedSame) {
        _missionTitle.text = @"未开始任务";
        [self setRightBtnTitle:@"申请改派"];
    } else if ([status compare:@"ON_THE_WAY"] == NSOrderedSame) {
        _missionTitle.text = @"进行中任务";
        _missionTitle.textColor = [UIColor colorWithRed:0x2b/255.0 green:0xb3/255.0 blue:0x6c/255.0 alpha:1.0];
        [self setRightBtnTitle:@"确认送达"];
    } else {
        _missionTitle.text = @"未指派任务";
        [_mapBtn setHidden:YES];
        [self setRightBtnTitle:@"我要接单"];
    }
    
    NSDate *startTime = [[NSDate alloc] initWithTimeIntervalSince1970:[[data objectForKey:@"start_time"] doubleValue]/1000];
    _missionTime.text = [startTime formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
    _startTime.text = [startTime formattedDateWithFormat:@"上车时间: MM月dd日 HH:mm"];
    
    _startPlace.text = [data objectForKey:@"start_place"];
    _endPlace.text = [data objectForKey:@"target_place"];
    _airNO.text = [NSString stringWithFormat:@"航班号: %@", [data objectForKey:@"air_no"]];
    _price.text = [NSString stringWithFormat:@"一口价: %.2f", [[data objectForKey:@"price"] doubleValue]];
    
}

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
        
        _mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 85, 120, 70, 70)];
        [_mapBtn setBackgroundImage:[UIImage imageNamed:@"Group 6"] forState:UIControlStateNormal];
        [_mapBtn addTarget:self action:@selector(onMap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_mapBtn];
        
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
        [_right setBackgroundImage:[UIImage imageNamed:@"接单"] forState:UIControlStateNormal];
        [_right addTarget:self action:@selector(onRight:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_right];
        
        _rightEx = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _rightEx.frame = CGRectMake(self.frame.size.width*0.75 - 20, 215, 80, 20);
        [_rightEx addTarget:self action:@selector(onRight:) forControlEvents:UIControlEventTouchUpInside];
        [_rightEx setTitle:@"我要接单" forState:UIControlStateNormal];
        [_rightEx.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_rightEx setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_rightEx];
        
    }
    return self;
}

- (void) onMap: (id)sender {
    if ([Utils locationAccess] == NO) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"要使用导航需要打开定位权限!" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [alertController dismissViewControllerAnimated:NO completion:nil];
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @(NO)} completionHandler:nil];
            [alertController dismissViewControllerAnimated:NO completion:nil];
        }]];
        [self.viewcontroller presentViewController:alertController animated:YES completion:nil];
        return;
    }
    AMapVC *aMapVC = [[AMapVC alloc] init];
    aMapVC.data = [NSMutableDictionary dictionaryWithDictionary:self.data];
    [self.viewcontroller presentViewController:aMapVC animated:YES completion:nil];
}

- (void)onPhone: (id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [_data objectForKey:@"mobile"]]] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@(NO)} completionHandler:nil];
}

- (void)onRight: (id)sender {
    UIButton *target = sender;
    if ([target.titleLabel.text compare:@"我要接单"] == NSOrderedSame) {
        // 接单
        [AFNRequestManager requestAFURL:@"/travel/driver/accept_order" httpMethod:METHOD_POST params:@{@"order_id":[_data objectForKey:@"id"], @"driver_user_id":[User shareInstance].id} data:nil succeed:^(NSDictionary *ret) {
            if (ret == nil) {
                return;
            }
            // 更新任务列表
            MissionVC *missionVC = (MissionVC *)self.viewcontroller;
            [missionVC refreshData];
        } failure:nil];
    } else if ([target.titleLabel.text compare:@"确认送达"] == NSOrderedSame) {
        // 确认送达
        AlertView *alertView = [AlertView initWithCancelBlock:^{
            NSLog(@"cancel");
        } okBlock:^{
            [AFNRequestManager requestAFURL:@"/travel/driver/done_order" httpMethod:METHOD_POST params:@{@"order_id":[self.data objectForKey:@"id"], @"driver_user_id":[User shareInstance].id} data:nil succeed:^(NSDictionary *ret) {
                if (ret == nil) {
                    return;
                }
                // 更新已接单列表
                HomeVC *homeVC = (HomeVC *)self.viewcontroller;
                [homeVC refreshData];
                
            } failure:nil];

        }];
        [SRMModalViewController sharedInstance].enableTapOutsideToDismiss = NO;
        [[SRMModalViewController sharedInstance] showView:alertView];
    } else {
        //申请改派
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确定要申请改派该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [alertController dismissViewControllerAnimated:NO completion:nil];
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [alertController dismissViewControllerAnimated:NO completion:nil];
            // 改派订单
            [AFNRequestManager requestAFURL:@"/travel/driver/change_order" httpMethod:METHOD_POST params:@{@"order_id":[self.data objectForKey:@"id"], @"driver_user_id":[User shareInstance].id} data:nil succeed:^(NSDictionary *ret) {
                if (ret == nil) {
                    return;
                }
                // 更新已接单列表
                HomeVC *homeVC = (HomeVC *)self.viewcontroller;
                [homeVC refreshData];
                
            } failure:nil];

            
        }]];
        [self.viewcontroller presentViewController:alertController animated:YES completion:nil];

    }
}


- (void) setRightBtnTitle:(NSString *)title {
    [_rightEx setTitle:title forState:UIControlStateNormal];
    if ([title compare:@"确认送达"] == NSOrderedSame) {
        [_right setBackgroundImage:[UIImage imageNamed:@"确认送达"] forState:UIControlStateNormal];
    }
    if ([title compare:@"申请改派"] == NSOrderedSame) {
        [_right setBackgroundImage:[UIImage imageNamed:@"改派"] forState:UIControlStateNormal];
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
