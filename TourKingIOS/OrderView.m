//
//  OrderView.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/12.
//  Copyright © 2019 default. All rights reserved.
//

#import "OrderView.h"
#import "UIButton+countDown.h"
#import <SRMModalViewController.h>
#import <DateTools/DateTools.h>
#import "NowOrders.h"
#import "HomeVC.h"
#import "AFNRequestManager.h"
#import "User.h"
#import "TKLocationManager.h"

@interface OrderView ()
{
    UILabel *_orderId;
    UILabel *_startPlace;
    UILabel *_endPlace;
    UILabel *_startTime;
    UILabel *_kilo;
    UIButton *_acceptBtn;
    NSDictionary *_data;
}
@property (nonatomic, weak) HomeVC *homeVC;
@end

@implementation OrderView

- (instancetype)initWithData:(nonnull NSDictionary *)order homeVC:(nonnull HomeVC *)vc {
    self = [self init];
    if (self) {
        _homeVC = vc;
        _data = [NSDictionary dictionaryWithDictionary:order];
        _orderId.text = [order objectForKey:@"id"];
        _startPlace.text = [order objectForKey:@"start_place"];
        if ([[order objectForKey:@"target_place"] isEqual:[NSNull null]]) {
            _endPlace.text = @"";
        } else {
            _endPlace.text = [order objectForKey:@"target_place"];
        }
        _startTime.text = [[NSDate dateWithTimeIntervalSince1970:[[order objectForKey:@"start_time"] doubleValue]/1000] formattedDateWithFormat:@"时间: yyyy-MM-dd HH:mm"];
        double distance = [[TKLocationManager shareInstance] getDistanceWithLatitude:[[order objectForKey:@"start_latitude"]doubleValue] longitude:[[order objectForKey:@"start_longitude"]doubleValue]];
        _kilo.text = [NSString stringWithFormat:@"距离您%.2fkm", distance/1000.0];
    }
    return self;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CGRect rScreen = [[UIScreen mainScreen] bounds];
        self.frame = CGRectMake(35, 10, rScreen.size.width - 70, 390);
        [self.layer setCornerRadius:10.0f];
        [self.layer setMasksToBounds:YES];
        
        UILabel *missionTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, self.frame.size.width - 30, 24)];
        [missionTitle setFont:[UIFont boldSystemFontOfSize:24]];
        missionTitle.text = @"新指派任务";
        [missionTitle setTextColor:[UIColor colorWithRed:53/255.0 green:178/255.0 blue:111/255.0 alpha:1.0]];
        missionTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:missionTitle];
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 30, 8, 18, 18)];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(onCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        UIImageView *orderImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 62, 9, 12)];
        [orderImg setImage:[UIImage imageNamed:@"订单号"]];
        [self addSubview:orderImg];
        
        _orderId = [[UILabel alloc] initWithFrame:CGRectMake(30, 60, self.frame.size.width - 45, 15)];
        [_orderId setFont:[UIFont systemFontOfSize:15]];
        _orderId.text = @"djfasdlj的案件发垃圾发开发家具就阿拉斯加发加";
        [self addSubview:_orderId];
        
        UIImageView *startPlaceImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 93, 7, 7)];
        [startPlaceImg setImage:[UIImage imageNamed:@"Oval 1"]];
        [self addSubview:startPlaceImg];
        
        _startPlace = [[UILabel alloc] initWithFrame:CGRectMake(30, 90, self.frame.size.width - 45, 15)];
        [_startPlace setFont:[UIFont systemFontOfSize:15]];
        _startPlace.text = @"djfasdlj的案件发垃圾发开发家具就阿拉斯加发加";
        [self addSubview:_startPlace];
        
        UIImageView *endPlaceImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 123, 7, 7)];
        [endPlaceImg setImage:[UIImage imageNamed:@"Oval 2"]];
        [self addSubview:endPlaceImg];
        
        _endPlace = [[UILabel alloc] initWithFrame:CGRectMake(30, 120, self.frame.size.width - 45, 15)];
        [_endPlace setFont:[UIFont systemFontOfSize:15]];
        _endPlace.text = @"djfasdlj的案件发垃圾发开发家具就阿拉斯加发加";
        [self addSubview:_endPlace];
        
        UIImageView *startTimeImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 152, 10, 10)];
        [startTimeImg setImage:[UIImage imageNamed:@"时间 "]];
        [self addSubview:startTimeImg];
        
        _startTime = [[UILabel alloc] initWithFrame:CGRectMake(30, 150, self.frame.size.width - 45, 15)];
        [_startTime setFont:[UIFont systemFontOfSize:15]];
        _startTime.text = @"djfasdlj的案件发垃圾发开发家具就阿拉斯加发加";
        [self addSubview:_startTime];

        _acceptBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 40, 215, 80, 80)];
        [_acceptBtn setBackgroundImage:[UIImage imageNamed:@"Group 7"] forState:UIControlStateNormal];
        [_acceptBtn addTarget:self action:@selector(onAccept:) forControlEvents:UIControlEventTouchUpInside];
        _acceptBtn.titleEdgeInsets = UIEdgeInsetsMake(40, 0, 10, 0);
        __weak __typeof(self)weakSelf = self;
        [_acceptBtn startWithTime:30 title:@"" completion:^{
            [weakSelf onClose];
        }];
        [self addSubview:_acceptBtn];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 44, self.frame.size.width, 44)];
        [bottomView setBackgroundColor:[UIColor colorWithRed:0x53/255.0 green:0x6d/255.0 blue:88/255.0 alpha:1.0]];
        [self addSubview:bottomView];
        
        _kilo = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.frame.size.width-30, 24)];
        [_kilo setFont:[UIFont systemFontOfSize:24]];
        _kilo.textAlignment = NSTextAlignmentCenter;
        [_kilo setTextColor:[UIColor whiteColor]];
        [bottomView addSubview:_kilo];
    }
    return self;
}

- (void)onCloseBtn:(id)sender {
    [_acceptBtn makeItStop];
    [self onClose];
}

- (void)onClose {
    if (_data != nil) {
        [[NowOrders shareInstance] insertTrashOrder:[_data objectForKey:@"id"]];
    }
    [[SRMModalViewController sharedInstance] hide];
    
}

- (void)onAccept:(id)sender {
    if ([User shareInstance].id == nil) return;
    if (_data != nil) {
        [[NowOrders shareInstance] insertTrashOrder:[_data objectForKey:@"id"]];
    }
    if ([_data objectForKey:@"id"] == nil) return;
    __weak HomeVC *homeVC = self.homeVC;
    [AFNRequestManager requestAFURL:@"/travel/driver/accept_order" httpMethod:METHOD_POST params:@{@"order_id":[_data objectForKey:@"id"], @"driver_user_id":[User shareInstance].id} data:nil succeed:^(NSDictionary *ret) {
        if (ret == nil) {
            return;
        }
        // 更新任务列表
        if (homeVC) {
            [homeVC refreshData];
        }
    } failure:nil];
    [[SRMModalViewController sharedInstance] hide];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
