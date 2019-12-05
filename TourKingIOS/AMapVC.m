//
//  AMapVC.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/12.
//  Copyright © 2019 default. All rights reserved.
//

#import "AMapVC.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import "AFNRequestManager.h"
#import "User.h"
#import "AlertView.h"
#import <SRMModalViewController.h>
#import "AcceptedOrders.h"

@interface AMapVC ()<AMapNaviDriveManagerDelegate, AMapNaviDriveDataRepresentable, AMapNaviDriveViewDelegate>

@property(nonatomic, strong) AMapNaviDriveView *driveView;
@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;

@property (nonatomic, strong) UIView *topInfoBgView;  //顶部黑框
@property (nonatomic, strong) UIImageView *topTurnImageView; // 转向提示图
@property (nonatomic, strong) UILabel *topRemainLabel;  //xxx米/公里后
@property (nonatomic, strong) UILabel *topRoadLabel; // xx路
@property (nonatomic, strong) UIImageView *crossImageView; // 复杂路口路况图

@property (nonatomic, strong) UIView *routeRemianInfoView; // 剩余公里、时间
@property (nonatomic, strong) UILabel *routeRemainInfoLabel; // 剩余公里、时间
@property (nonatomic, strong) UIButton *rightBrowserBtn; //全览, 退出全览
@property (nonatomic, strong) AMapNaviTrafficBarView *trafficBarView; //交通状况bar
@property (nonatomic, strong) UIButton *rightTrafficBtn; // 开启路况按钮
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) UILabel *customLab;
@property (nonatomic, strong) UINavigationItem *navigationBarTitle;
@end

@implementation AMapVC
- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}
- (void)onChangeOrder:(id)sender {
    // 申请改派
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确定要申请改派该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
    __weak UIAlertController* weakAlertContrller = alertController;
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [weakAlertContrller dismissViewControllerAnimated:NO completion:nil];
        
    }]];
    
    __weak __typeof(self)weakSelf = self;

    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakAlertContrller dismissViewControllerAnimated:NO completion:nil];
        if ([User shareInstance].id == nil) {
            return;
        }
        // 改派订单
        __weak __typeof(self)weakweakSelf = weakSelf;
        [AFNRequestManager requestAFURL:@"/travel/driver/change_order" httpMethod:METHOD_POST params:@{@"order_id":[self.data objectForKey:@"id"], @"driver_user_id":[User shareInstance].id} data:nil succeed:^(NSDictionary *ret) {
            if (ret == nil) {
                return;
            }
            [weakweakSelf dismissViewControllerAnimated:NO completion:nil];
        } failure:nil];
        
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) refreshView {
    if (self.data == nil) {
        return;
    }
    NSString *orderStatus = [self.data objectForKey:@"order_status"];
    
    if ([orderStatus compare:@"ACCEPTED"] == NSOrderedSame) {
        //去接乘客
        self.customLab.text = @"去接乘客";
        UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        changeButton.frame = CGRectMake(0, 0, 80, 20);
        [changeButton addTarget:self action:@selector(onChangeOrder:) forControlEvents:UIControlEventTouchUpInside];
        [changeButton setTitle:@"申请改派" forState:UIControlStateNormal];
        [changeButton setBackgroundColor:[UIColor whiteColor]];
        [changeButton setTitleColor:[UIColor colorWithRed:0x2B/255.0 green:0xB3/255.0 blue:0x6B/255.0 alpha:1.0] forState:UIControlStateNormal];
        changeButton.layer.cornerRadius = 10.0;
        
        _navigationBarTitle.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:changeButton];
        [self.bottomBtn setTitle:@"到达约定点" forState:UIControlStateNormal];
        self.endPoint = [AMapNaviPoint locationWithLatitude:[[self.data objectForKey:@"start_latitude"] doubleValue] longitude:[[self.data objectForKey:@"start_longitude"] doubleValue]];
    } else {
        // 服务中
        self.customLab.text = @"服务中";
        [self.bottomBtn setTitle:@"结束行程" forState:UIControlStateNormal];
        _navigationBarTitle.rightBarButtonItem = nil;
        self.endPoint = [AMapNaviPoint locationWithLatitude:[[self.data objectForKey:@"target_latitude"] doubleValue] longitude:[[self.data objectForKey:@"target_longitude"] doubleValue]];
       
    }
    [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithEndPoints:@[self.endPoint] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategySingleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //是否接到乘客
    BOOL bOnTheWay = NO;
    if (self.data) {
        bOnTheWay = [[self.data objectForKey:@"order_status"] compare:@"ACCEPTED"] != NSOrderedSame;
    }
    
    // 设置目的地
    self.endPoint = bOnTheWay ? [AMapNaviPoint locationWithLatitude:[[self.data objectForKey:@"target_latitude"] doubleValue] longitude:[[self.data objectForKey:@"target_longitude"] doubleValue]] : [AMapNaviPoint locationWithLatitude:[[self.data objectForKey:@"start_latitude"] doubleValue] longitude:[[self.data objectForKey:@"start_longitude"] doubleValue]];

    self.view.backgroundColor = [UIColor colorWithRed:57/255.0 green:180/255.0 blue:105/255.0 alpha:1.0];
    
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    UINavigationBar *navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, rect.size.height, rScreen.size.width, 44)];
    [navigationBar setBackgroundColor:nil];
    [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];//以及隐隐都得设置为[UIImage new]
    navigationBar.shadowImage = [UIImage new];
    //创建UINavigationItem
    
    _navigationBarTitle = [[UINavigationItem alloc] init];
    _customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [_customLab setTextColor:[UIColor whiteColor]];
    [_customLab setText:@"服务中"];
    _customLab.font = [UIFont systemFontOfSize:20];
    _navigationBarTitle.titleView = _customLab;
    [navigationBar pushNavigationItem: _navigationBarTitle animated:YES];
    [self.view addSubview: navigationBar];
    
    //创建UIBarButton 可根据需要选择适合自己的样式
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0,25,25)];
    [button setBackgroundImage:[UIImage imageNamed:@"i_back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navigationBackButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //设置barbutton
    
    _navigationBarTitle.leftBarButtonItem = item;
    
    [navigationBar setItems:[NSArray arrayWithObject: _navigationBarTitle]];
    CGRect rcTop = navigationBar.frame;
    
    self.topInfoBgView = [[UIView alloc] initWithFrame:CGRectMake(0, rcTop.origin.y + rcTop.size.height, rScreen.size.width, 45)];
    [self.topInfoBgView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.topInfoBgView];
    self.topRemainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 100, 16)];
    self.topRemainLabel.textColor = [UIColor whiteColor];
    [self.topInfoBgView addSubview:self.topRemainLabel];
    self.topTurnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 0, 45, 45)];
    [self.topInfoBgView addSubview:self.topTurnImageView];
    UILabel *enterLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 20, 30, 11)];
    [enterLabel setFont:[UIFont systemFontOfSize:12]];
    [enterLabel setTextColor:[UIColor whiteColor]];
    enterLabel.text = @"进入";
    [self.topInfoBgView addSubview:enterLabel];
    self.topRoadLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 12, rScreen.size.width - 210, 22)];
    [self.topRoadLabel setFont:[UIFont systemFontOfSize:22]];
    [self.topRoadLabel setTextAlignment:NSTextAlignmentCenter];
    self.topRoadLabel.textColor = [UIColor whiteColor];
    [self.topInfoBgView addSubview:self.topRoadLabel];
    
    self.crossImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, rcTop.origin.y + rcTop.size.height + 45, rScreen.size.width, rScreen.size.width/300.0*192.0)];
    [self.view addSubview:self.crossImageView];
    
    self.routeRemianInfoView = [[UIView alloc]initWithFrame:CGRectMake(15, rcTop.origin.y + rcTop.size.height + 60, 180, 35)];
    [self.routeRemianInfoView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.routeRemianInfoView];
    
    self.routeRemainInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 35)];
    [self.routeRemainInfoLabel setFont:[UIFont systemFontOfSize:16]];
    [self.routeRemainInfoLabel setTextColor:[UIColor whiteColor]];
    self.routeRemainInfoLabel.textAlignment = NSTextAlignmentCenter;
    [self.routeRemianInfoView addSubview:self.routeRemainInfoLabel];
    
    self.trafficBarView = [[AMapNaviTrafficBarView alloc] initWithFrame:CGRectMake(15, rcTop.origin.y + rcTop.size.height + 105, 13, rScreen.size.height - rcTop.origin.y - rcTop.size.height - 225)];
    [self.view addSubview:self.trafficBarView];
    
    self.rightTrafficBtn = [[UIButton alloc] initWithFrame:CGRectMake(rScreen.size.width - 50, rcTop.origin.y + rcTop.size.height + 55, 40, 40)];
    [self.rightTrafficBtn setImage:[UIImage imageNamed:@"default_navi_traffic_close_normal"] forState:UIControlStateNormal];
    [self.rightTrafficBtn setImage:[UIImage imageNamed:@"default_navi_traffic_open_normal"] forState:UIControlStateSelected];
    [self.rightTrafficBtn addTarget:self action:@selector(trafficBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightTrafficBtn];
    
    
    self.rightBrowserBtn = [[UIButton alloc] initWithFrame:CGRectMake(rScreen.size.width - 50, rScreen.size.height - 110, 40, 40)];
    [self.rightBrowserBtn setImage:[UIImage imageNamed:@"default_navi_browse_ver_normal"] forState:UIControlStateNormal];
    [self.rightBrowserBtn setImage:[UIImage imageNamed:@"default_navi_browse_ver_selected"] forState:UIControlStateSelected];
    [self.rightBrowserBtn addTarget:self action:@selector(browserBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightBrowserBtn];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, rScreen.size.height - 50, rScreen.size.width, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    self.bottomBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.bottomBtn.layer.cornerRadius = 15;
    [self.bottomBtn.layer setMasksToBounds:YES];
    self.bottomBtn.frame = CGRectMake(10, 5, rScreen.size.width - 20, 40);
    self.bottomBtn.backgroundColor = [UIColor colorWithRed:57/255.0 green:180/255.0 blue:105/255.0 alpha:1.0];
    [self.bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:20.0]];
    [self.bottomBtn setTitle:@"结束行程" forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(onBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.bottomBtn];
    
    [self initProperties];
    self.driveView = [[AMapNaviDriveView alloc] initWithFrame:CGRectMake(0, rcTop.origin.y + rcTop.size.height + 45, rScreen.size.width, rScreen.size.height - rcTop.origin.y - rcTop.size.height - 95)];
    self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.driveView.delegate = self;
    self.driveView.showUIElements = NO;
    self.driveView.showGreyAfterPass = YES;
    self.driveView.autoZoomMapLevel = YES;
    self.driveView.mapViewModeType = AMapNaviViewMapModeTypeNight;
    self.driveView.autoSwitchShowModeToCarPositionLocked = YES;
    self.driveView.trackingMode = AMapNaviViewTrackingModeCarNorth;
    self.driveView.logoCenter = CGPointMake(self.driveView.logoCenter.x + 2, self.driveView.logoCenter.y + 60);
    [self.view addSubview:self.driveView];
    [self.view sendSubviewToBack:self.driveView];
    
    
    if ([self isiPhoneX]) {
        bottomView.frame = CGRectMake(0, rScreen.size.height - 70, rScreen.size.width, 70);
        
        self.driveView.frame = CGRectMake(0, rcTop.origin.y + rcTop.size.height + 45, rScreen.size.width, rScreen.size.height - rcTop.origin.y - rcTop.size.height - 115);
    }
    
    [self updateMapViewScreenAnchor]; // 设置锚点
    [self initDriveManager];
    
    [self refreshView];
}

- (void)navigationBackButton: (id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - AMapNaviDriveManager Delegate
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onCalculateRouteSuccess");
    
    //显示路径或开启导航
    [[AMapNaviDriveManager sharedInstance] startGPSNavi];
}

//更新地图锚点
- (void)updateMapViewScreenAnchor {
    
    [self.view layoutIfNeeded];
    
    CGFloat x = 0.5;
    CGFloat y = 0.75;
    
    
    if (self.driveView.screenAnchor.x != x || self.driveView.screenAnchor.y != y) {
        self.driveView.screenAnchor = CGPointMake(x, y);
    }
}


- (void)initDriveManager
{
    //driveManager 请在 dealloc 函数中执行 [AMapNaviDriveManager destroyInstance] 来销毁单例
    [[AMapNaviDriveManager sharedInstance] setDelegate:self];
    [[AMapNaviDriveManager sharedInstance] setIsUseInternalTTS:YES];
    
    // 这是系统后台定位，没有相关设置会崩溃，而且上架时也要选择特殊权限，故没有必要开启
    //    [[AMapNaviDriveManager sharedInstance] setAllowsBackgroundLocationUpdates:YES];
    [[AMapNaviDriveManager sharedInstance] setPausesLocationUpdatesAutomatically:NO];
    
    //将self 、driveView、trafficBarView 添加为导航数据的Representative，使其可以接收到导航诱导数据
    [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self.driveView];
    [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self.trafficBarView];
    [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self];
}

- (void)initProperties
{
    self.startPoint = [AMapNaviPoint locationWithLatitude:39.993135 longitude:116.474175];
    self.endPoint   = [AMapNaviPoint locationWithLatitude:39.908791 longitude:116.321257];
}


- (void)dealloc
{
    [[AMapNaviDriveManager sharedInstance] stopNavi];
    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self.driveView];
    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self.trafficBarView];
    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self];
    [[AMapNaviDriveManager sharedInstance] setDelegate:nil];
    
    BOOL success = [AMapNaviDriveManager destroyInstance];
    NSLog(@"单例是否销毁成功 : %d",success);
    
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.driveView.isLandscape ?  UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//处理路口放大图
- (void)handleWhenCrossImageShowAndHide:(UIImage *)crossImage {
    if (crossImage && self.driveView.showMode == AMapNaviDriveViewShowModeCarPositionLocked) {
        self.crossImageView.hidden = NO;
        self.crossImageView.image = crossImage;
        self.rightBrowserBtn.hidden = YES;
        self.rightTrafficBtn.hidden = YES;
        self.routeRemianInfoView.hidden = YES;
        self.trafficBarView.hidden = YES;
    } else {
        self.crossImageView.hidden = YES;
        self.crossImageView.image = nil;
        self.rightBrowserBtn.hidden = NO;
        self.rightTrafficBtn.hidden = NO;
        self.routeRemianInfoView.hidden = NO;
        self.trafficBarView.hidden = NO;
    }
    [self updateMapViewScreenAnchor];
}


#pragma mark - AMapNaviDriveDataRepresentable

//诱导信息
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateNaviInfo:(AMapNaviInfo *)naviInfo {
    if (naviInfo) {
        
        if (self.topInfoBgView.hidden) {
            self.topInfoBgView.hidden = self.routeRemianInfoView.hidden = NO;
        }
        
        self.topRemainLabel.text = [NSString stringWithFormat:@"%@后",[self normalizedRemainDistance:naviInfo.segmentRemainDistance]];
        self.topRoadLabel.text = naviInfo.nextRoadName;
        
        NSString *remainTime = [self normalizedRemainTime:naviInfo.routeRemainTime];
        NSString *remainDis = [self normalizedRemainDistance:naviInfo.routeRemainDistance];
        self.routeRemainInfoLabel.text = [NSString stringWithFormat:@"剩余 %@ %@",remainDis,remainTime];
        
    }
}

//转向图标
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateTurnIconImage:(UIImage *)turnIconImage turnIconType:(AMapNaviIconType)turnIconType {
    if (turnIconImage) {
        self.topTurnImageView.image = turnIconImage;
    }
}

//显示路口放大图
- (void)driveManager:(AMapNaviDriveManager *)driveManager showCrossImage:(UIImage *)crossImage {
    [self handleWhenCrossImageShowAndHide:crossImage];
}

//隐藏路口放大图
- (void)driveManagerHideCrossImage:(AMapNaviDriveManager *)driveManager {
    [self handleWhenCrossImageShowAndHide:nil];
}

#pragma mark - AMapNaviDriveViewDelegate

- (void)driveView:(AMapNaviDriveView *)driveView didChangeDayNightType:(BOOL)showStandardNightType {
    NSLog(@"didChangeDayNightType:%ld", (long)showStandardNightType);
}

- (void)driveView:(AMapNaviDriveView *)driveView didChangeOrientation:(BOOL)isLandscape {
    NSLog(@"didChangeOrientation:%ld", (long)isLandscape);
    [self updateMapViewScreenAnchor];
    [self setNeedsStatusBarAppearanceUpdate];  //更新状态栏颜色
    if (self.driveView.showMode == AMapNaviDriveViewShowModeOverview) {  //如果是全览状态，重新适应一下全览路线，让其均可见
        [self.driveView updateRoutePolylineInTheVisualRangeWhenTheShowModeIsOverview];
    }
}

- (void)driveView:(AMapNaviDriveView *)driveView didChangeShowMode:(AMapNaviDriveViewShowMode)showMode {
    if (showMode == AMapNaviDriveViewShowModeOverview) {
        self.rightBrowserBtn.selected = YES;
    } else {
        self.rightBrowserBtn.selected = NO;
    }
    
    if (showMode != AMapNaviDriveViewShowModeCarPositionLocked) {  //非锁车，隐藏路口放大图
        [self handleWhenCrossImageShowAndHide:nil];
    }
}

//返回边界Padding，来规定可见区域
- (UIEdgeInsets)driveViewEdgePadding:(AMapNaviDriveView *)driveView {
    
    //top left bottom right
    CGFloat offset = 20;
    CGFloat top = self.routeRemianInfoView.frame.origin.y + self.routeRemianInfoView.bounds.size.height + offset;
    CGFloat left = 40;
    CGFloat bottom = self.view.bounds.size.height -  + offset;
    CGFloat right = 80;
    if (self.driveView.isLandscape) {
        top =  offset;
        left = self.trafficBarView.frame.origin.x + self.trafficBarView.frame.size.width + offset;
        bottom = self.view.bounds.size.height  + offset;
        right = 80;
    }
    
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    return insets;
}

#pragma mark - Button Click

- (void) trafficBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    self.driveView.mapShowTraffic = !self.driveView.mapShowTraffic;
    btn.selected = !self.driveView.mapShowTraffic;
}

- (void)browserBtn:(id)sender {
    if (self.driveView.showMode == AMapNaviDriveViewShowModeOverview) {
        self.driveView.showMode = AMapNaviDriveViewShowModeCarPositionLocked;
    } else {
        self.driveView.showMode = AMapNaviDriveViewShowModeOverview;
    }
}

- (void)onBottomBtn:(id)sender {
    if (self.data == nil || [User shareInstance] == nil) {
        return;
    }
    NSString *orderStatus = [self.data objectForKey:@"order_status"];
    __weak __typeof(self)weakSelf = self;
    if ([orderStatus compare:@"ACCEPTED"] == NSOrderedSame) {
        //到达约定点
        if ([User shareInstance].bBusy) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"操作不允许" message:@"您现在有进行中的任务，请先完成任务" preferredStyle:UIAlertControllerStyleAlert];
            __weak UIAlertController *weakAlertController = alertController;
            [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakAlertController dismissViewControllerAnimated:NO completion:nil];
            }]];
            [self presentViewController:alertController animated:NO completion:nil];
            return;
        }

        [AFNRequestManager requestAFURL:@"/travel/driver/execute_order" httpMethod:METHOD_POST params:@{@"order_id": [self.data objectForKey:@"id"], @"driver_user_id": [User shareInstance].id} data:nil succeed:^(NSDictionary *ret) {
            if (ret == nil) {
                return;
            }
            if (weakSelf.data) {
                [weakSelf.data setObject:@"ON_THE_WAY" forKey:@"order_status"];
                [User shareInstance].bBusy = YES;
            }
            [weakSelf refreshView];
        } failure:nil];
        
    } else {
        //结束行程
        AlertView *alertView = [AlertView initWithCancelBlock:^{
            NSLog(@"cancel");
        } okBlock:^{
            __weak __typeof(self)weakweakSelf = weakSelf;
            [AFNRequestManager requestAFURL:@"/travel/driver/done_order" httpMethod:METHOD_POST params:@{@"order_id":[self.data objectForKey:@"id"], @"driver_user_id":[User shareInstance].id} data:nil succeed:^(NSDictionary *ret) {
                if (ret == nil) {
                    return;
                }
                [weakweakSelf dismissViewControllerAnimated:NO completion:nil];
                
            } failure:nil];

        }];
        [SRMModalViewController sharedInstance].enableTapOutsideToDismiss = NO;
        [[SRMModalViewController sharedInstance] showView:alertView];
    }
}

#pragma mark - Utility

- (BOOL)isiPhoneX {
    if (@available(iOS 11.0, *)) {
        // 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X以上设备。
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        if (window.safeAreaInsets.bottom > 0.0) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (NSString *)normalizedRemainDistance:(NSInteger)remainDistance {
    
    if (remainDistance < 0) {
        return nil;
    }
    
    if (remainDistance >= 1000) {
        CGFloat kiloMeter = remainDistance / 1000.0;
        return [NSString stringWithFormat:@"%.1f公里", kiloMeter];
    } else {
        return [NSString stringWithFormat:@"%ld米", (long)remainDistance];
    }
}

- (NSString *)normalizedRemainTime:(NSInteger)remainTime {
    if (remainTime < 0) {
        return nil;
    }
    
    if (remainTime < 60) {
        return [NSString stringWithFormat:@"< 1分钟"];
    } else if (remainTime >= 60 && remainTime < 60*60) {
        return [NSString stringWithFormat:@"%ld分钟", (long)remainTime/60];
    } else {
        NSInteger hours = remainTime / 60 / 60;
        NSInteger minute = remainTime / 60 % 60;
        if (minute == 0) {
            return [NSString stringWithFormat:@"%ld小时", (long)hours];
        } else {
            return [NSString stringWithFormat:@"%ld小时%ld分钟", (long)hours, (long)minute];
        }
    }
}


@end
