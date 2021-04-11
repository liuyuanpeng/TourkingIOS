//
//  MissionView.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/11.
//  Copyright © 2019 default. All rights reserved.
//

#import "MissionViewEx.h"
#import "AMapVC.h"
#import <DateTools/DateTools.h>
#import "AFNRequestManager.h"
#import "User.h"
#import "HomeVC.h"
#import "MissionVC.h"
#import "Utils.h"
#import "AlertView.h"
#import "UILabel+align.h"
#import <SRMModalViewController.h>

@interface MissionViewEx ()
{
    UILabel *_missionTitle;
    UILabel *_missionTime;
    UILabel *_startPlace;
    UILabel *_contact;
    UILabel *_endPlace;
    UILabel *_airNO;
    UILabel *_startTime;
    UILabel *_price;
    UILabel *_backup;
    UILabel *_order;
    UIButton *_right;
    UIButton *_rightEx;
    UIButton *_mapBtn;
}
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) HomeVC *homeVC;
@property (nonatomic, strong) MissionVC *missionVC;
@end

@implementation MissionViewEx

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
    } else if ([status rangeOfString:@"CANCEL"].location != NSNotFound) {
        _missionTitle.text = @"已取消";
        _missionTitle.textColor = [UIColor grayColor];
        [_right removeFromSuperview];
        [_rightEx removeFromSuperview];
        [_mapBtn removeFromSuperview];
    }
    else {
        _missionTitle.text = @"未指派任务";
        [_mapBtn setHidden:YES];
        [self setRightBtnTitle:@"我要接单"];
    }
    
    NSDate *startTime = [[NSDate alloc] initWithTimeIntervalSince1970:[[data objectForKey:@"start_time"] doubleValue]/1000];
    _missionTime.text = [startTime formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
    _startTime.text = [startTime formattedDateWithFormat:@"上车时间: MM月dd日 HH:mm"];
    
    _startPlace.text = [data objectForKey:@"start_place"];
    if ([[data objectForKey:@"target_place"] isEqual:[NSNull null]]) {
        _endPlace.text = @"";
    } else {
        _endPlace.text = [data objectForKey:@"target_place"];
    }

    _airNO.text = [NSString stringWithFormat:@"航班号: %@", [data objectForKey:@"air_no"]];
    _contact.text = [NSString stringWithFormat:@"备用手机号: %@", [data objectForKey:@"contact_mobile"]];
    _price.text = [NSString stringWithFormat:@"一口价: %.2f", [[data objectForKey:@"price"] doubleValue]];
    if ([[data objectForKey:@"remark"] isEqual:[NSNull null]]) {
        _backup.text = @"备注:";
    } else {
        _backup.text = [NSString stringWithFormat:@"备注: %@", [data objectForKey:@"remark"]];
    }
    _order.text = [NSString stringWithFormat:@"订单号: %@", [data objectForKey:@"id"]];
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CGRect rScreen = [[UIScreen mainScreen] bounds];
        self.frame = CGRectMake(15, 10, rScreen.size.width - 30, 350);
        [self.layer setCornerRadius:10.0f];
        [self.layer setMasksToBounds:YES];
        
        _missionTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 150, 20)];
        [_missionTitle setFont:[UIFont boldSystemFontOfSize:20]];
        _missionTitle.text = @"未指派任务";
        [self addSubview:_missionTitle];
        
        UIImageView *timeImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 170, 23, 15, 15)];
        [timeImg setImage:[UIImage imageNamed:@"时间 (1)"]];
        [self addSubview:timeImg];
        
        _missionTime = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 165, 20, 150, 20)];
        [_missionTime setText:@"2019-00-00 10:45"];
        [_missionTime setTextAlignment:NSTextAlignmentRight];
        [_missionTime setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:_missionTime];
        
        UIView *lineSep1 = [[UIView alloc] initWithFrame:CGRectMake(15, 50, self.frame.size.width - 30, 1)];
        [lineSep1 setBackgroundColor:[UIColor colorWithWhite:244/255.0 alpha:1.0]];
        [self addSubview:lineSep1];
        
        UIImageView *startPlaceImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 72, 7, 7)];
        [startPlaceImg setImage:[UIImage imageNamed:@"Oval 1"]];
        [self addSubview:startPlaceImg];
        
        _startPlace = [[UILabel alloc] initWithFrame:CGRectMake(30, 60, self.frame.size.width - 75, 32)];
        [_startPlace setFont:[UIFont systemFontOfSize:13]];
        _startPlace.text = @"";
        [_startPlace setNumberOfLines:2];
        [self addSubview:_startPlace];
        
        UIImageView *endPlaceImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 102, 7, 7)];
        [endPlaceImg setImage:[UIImage imageNamed:@"Oval 2"]];
        [self addSubview:endPlaceImg];
        
        _endPlace = [[UILabel alloc] initWithFrame:CGRectMake(30, 90, self.frame.size.width - 75, 32)];
        [_endPlace setFont:[UIFont systemFontOfSize:13]];
        _endPlace.text = @"";
        [_endPlace setNumberOfLines:2];
        [self addSubview:_endPlace];
        
        UIImageView *airImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 127, 10, 10)];
        [airImg setImage:[UIImage imageNamed:@"航班号"]];
        [self addSubview:airImg];
        
        _airNO = [[UILabel alloc] initWithFrame:CGRectMake(30, 125, self.frame.size.width - 115, 13)];
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
        
        UIImageView *contactImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 182, 7, 7)];
        [contactImg setImage:[UIImage imageNamed:@"Oval 1"]];
        [self addSubview:contactImg];
        
        _contact = [[UILabel alloc] initWithFrame:CGRectMake(30, 170, self.frame.size.width - 75, 32)];
        [_contact setFont:[UIFont systemFontOfSize:13]];
        _contact.text = @"";
        [self addSubview:_contact];
        
        UIImageView *priceImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 212, 10, 10)];
        [priceImg setImage:[UIImage imageNamed:@"价格"]];
        [self addSubview:priceImg];
        
        _price = [[UILabel alloc] initWithFrame:CGRectMake(30, 210, self.frame.size.width - 115, 13)];
        [_price setFont:[UIFont systemFontOfSize:13]];
        _price.text = @"";
        [self addSubview:_price];
        
        UIImageView *backupImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 242, 10, 10)];
        [backupImg setImage:[UIImage imageNamed:@"backup"]];
        [self addSubview:backupImg];
        
        _backup = [[UILabel alloc] initWithFrame:CGRectMake(30, 240, self.frame.size.width - 115, 13)];
        [_backup setFont:[UIFont systemFontOfSize:13]];
        _backup.text = @"";
        [self addSubview:_backup];

        UIImageView *orderImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 272, 10, 10)];
        [orderImg setImage:[UIImage imageNamed:@"order"]];
        [self addSubview:orderImg];
        
        _order = [[UILabel alloc] initWithFrame:CGRectMake(30, 270, self.frame.size.width - 115, 13)];
        [_order setFont:[UIFont systemFontOfSize:13]];
        _order.text = @"";
        [self addSubview:_order];

        UIView *lineSep2 = [[UIView alloc] initWithFrame:CGRectMake(15, 305, self.frame.size.width - 30, 1)];
        [lineSep2 setBackgroundColor:[UIColor colorWithWhite:244/255.0 alpha:1.0]];
        [self addSubview:lineSep2];
        
        UIView *lineSep3 = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 305, 1, 45)];
        [lineSep3 setBackgroundColor:[UIColor colorWithWhite:244/255.0 alpha:1.0]];
        [self addSubview:lineSep3];
        
        _mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 85, 120, 70, 70)];
        [_mapBtn setBackgroundImage:[UIImage imageNamed:@"Group 6"] forState:UIControlStateNormal];
        [_mapBtn addTarget:self action:@selector(onMap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_mapBtn];
        
        UIButton *phone = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/4 - 50, 315, 20, 20)];
        [phone setBackgroundImage:[UIImage imageNamed:@"联系客户"] forState:UIControlStateNormal];
        [phone addTarget:self action:@selector(onPhone:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:phone];
        
        UIButton *phoneEx = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        phoneEx.frame = CGRectMake(self.frame.size.width/4 - 20, 315, 80, 20);
        [phoneEx addTarget:self action:@selector(onPhone:) forControlEvents:UIControlEventTouchUpInside];
        [phoneEx setTitle:@"联系乘客" forState:UIControlStateNormal];
        [phoneEx.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [phoneEx setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:phoneEx];
        
        _right = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width*0.75 - 50, 315, 20, 20)];
        [_right setBackgroundImage:[UIImage imageNamed:@"接单"] forState:UIControlStateNormal];
        [_right addTarget:self action:@selector(onRight:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_right];
        
        _rightEx = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _rightEx.frame = CGRectMake(self.frame.size.width*0.75 - 20, 315, 80, 20);
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
        __weak UIAlertController *weakAlertController = alertController;
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [weakAlertController dismissViewControllerAnimated:NO completion:nil];
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @(NO)} completionHandler:nil];
            [weakAlertController dismissViewControllerAnimated:NO completion:nil];
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
    if ([User shareInstance].id == nil) {
        return;
    }
    UIButton *target = sender;
    __weak UIViewController *viewController = self.viewcontroller;
    if ([target.titleLabel.text compare:@"我要接单"] == NSOrderedSame) {
        // 接单
        [AFNRequestManager requestAFURL:@"/travel/driver/accept_order" httpMethod:METHOD_POST params:@{@"order_id":[_data objectForKey:@"id"], @"driver_user_id":[User shareInstance].id} data:nil succeed:^(NSDictionary *ret) {
            if (ret == nil) {
                return;
            }
            // 更新任务列表
            MissionVC *missionVC = (MissionVC *)viewController;
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
                HomeVC *homeVC = (HomeVC *)viewController;
                [homeVC refreshData];
                
            } failure:nil];

        }];
        [SRMModalViewController sharedInstance].enableTapOutsideToDismiss = NO;
        [[SRMModalViewController sharedInstance] showView:alertView];
    } else {
        //申请改派
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确定要申请改派该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
        __weak UIAlertController *weakAlertController = alertController;
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [weakAlertController dismissViewControllerAnimated:NO completion:nil];
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakAlertController dismissViewControllerAnimated:NO completion:nil];
            // 改派订单
            [AFNRequestManager requestAFURL:@"/travel/driver/change_order" httpMethod:METHOD_POST params:@{@"order_id":[self.data objectForKey:@"id"], @"driver_user_id":[User shareInstance].id} data:nil succeed:^(NSDictionary *ret) {
                if (ret == nil) {
                    return;
                }
                // 更新已接单列表
                HomeVC *homeVC = (HomeVC *)viewController;
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
