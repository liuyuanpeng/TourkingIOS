//
//  DetailVC.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/10/18.
//  Copyright © 2019 default. All rights reserved.
//

#import "DetailVCEx.h"
#import "AFNRequestManager.h"
#import <LCBannerView.h>
#import "RouteTableViewCell.h"
#import "AlertView.h"
#import <SRMModalViewController.h>
#import "User.h"
#import <Toast/UIView+Toast.h>


@interface DetailVCEx ()
@property (nonatomic, strong) UINavigationItem *navigationBarTitle;
@property (nonatomic, strong) UIButton *bottomBtn;
@end

@implementation DetailVCEx

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:57/255.0 green:180/255.0 blue:105/255.0 alpha:1.0];
    
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    UINavigationBar *navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, rect.size.height, rScreen.size.width, 44)];
    [navigationBar setBackgroundColor:nil];
    [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];//以及隐隐都得设置为[UIImage new]
    navigationBar.shadowImage = [UIImage new];
    _navigationBarTitle = [[UINavigationItem alloc] init];
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"包车详情"];
    customLab.font = [UIFont systemFontOfSize:20];
    _navigationBarTitle.titleView = customLab;
    [navigationBar pushNavigationItem: _navigationBarTitle animated:YES];
    [self.view addSubview: navigationBar];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"i_back"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBackButton:)];
    
    CGFloat topHeight = 44.0f;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height + topHeight, rScreen.size.width, rScreen.size.height - rect.size.height - topHeight )];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    //设置barbutton
    _navigationBarTitle.leftBarButtonItem = item;
    
    [self buildViews];
}

- (void)buildViews {
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    NSString *orderStatus = [NSString stringWithFormat:@"%@", [self.data objectForKey:@"order_status"]];
    if ([orderStatus compare:@"ACCEPTED"] == NSOrderedSame || [orderStatus compare:@"ON_THE_WAY"] == NSOrderedSame) {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, rScreen.size.height - 50, rScreen.size.width, 50)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bottomView];
        
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _bottomBtn.layer.cornerRadius = 15;
        [_bottomBtn.layer setMasksToBounds:YES];
        _bottomBtn.frame = CGRectMake(10, 5, rScreen.size.width - 20, 40);
        _bottomBtn.backgroundColor = [UIColor colorWithRed:57/255.0 green:180/255.0 blue:105/255.0 alpha:1.0];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:20.0]];
        [_bottomBtn setTitle:@"结束行程" forState:UIControlStateNormal];
        if ([orderStatus compare:@"ACCEPTED"] == NSOrderedSame) {
            [_bottomBtn setTitle:@"到达约定点" forState:UIControlStateNormal];
        }
        [_bottomBtn addTarget:self action:@selector(onBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:_bottomBtn];
        
    }
}

- (void)onBottomBtn: (id)sender {
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
                [self.bottomBtn setTitle:@"结束行程" forState:UIControlStateNormal];
            }
        } failure:nil];
        
    } else if([orderStatus compare:@"ON_THE_WAY"] == NSOrderedSame) {
        //结束行程    __weak __typeof(self)weakSelf = self;
    AlertView *alertView = [AlertView initWithCancelBlock:^{
        NSLog(@"cancel");
    } okBlock:^{
        __weak __typeof(self)weakweakSelf = weakSelf;
        [AFNRequestManager requestAFURL:@"/travel/driver/done_order" httpMethod:METHOD_POST params:@{@"order_id": [NSString stringWithFormat:@"%@", [self.data objectForKey:@"id"]], @"driver_user_id":[User shareInstance].id} data:nil succeed:^(NSDictionary *ret) {
            if (ret == nil) {
                [self.view makeToast:@"用户还未付款，不能结束该订单！" duration:2 position:CSToastPositionCenter];

                return;
            }
            [weakweakSelf dismissViewControllerAnimated:NO completion:nil];
            
        } failure:nil];

    }];
    [SRMModalViewController sharedInstance].enableTapOutsideToDismiss = NO;
    [[SRMModalViewController sharedInstance] showView:alertView];
    }
}

- (void)navigationBackButton: (id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
