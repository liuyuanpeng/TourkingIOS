//
//  TKViewController.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/11.
//  Copyright © 2019 default. All rights reserved.
//

#import "TKViewController.h"
#import "HomeVC.h"
#import "MissionVC.h"
#import "ProfileVC.h"
#import <SRMModalViewController.h>
#import "OrderView.h"
#import "NowOrders.h"
#import <AVFoundation/AVFoundation.h>
#import "Utils.h"

@interface TKViewController ()<SRMModalViewControllerDelegate, NowOrdersDelegate>
{
    BOOL _bModalShow;
    HomeVC *_homeVC;
}
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation TKViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _homeVC = [[HomeVC alloc] init];
    MissionVC *missionVC = [[MissionVC alloc] init];
    ProfileVC *profileVC = [[ProfileVC alloc] init];
    
    NSDictionary *textAttribute = @{NSForegroundColorAttributeName: [UIColor colorWithRed:0xAD / 255.0 green:0xAD / 255.0 blue:0xAD / 255.0 alpha:1]};
    NSDictionary *textSelectedAttribute = @{NSForegroundColorAttributeName: [UIColor colorWithRed:0x59 / 255.0 green:0xC4 / 255.0 blue:0x8C / 255.0 alpha:1]};

    NSDictionary *titleTextAttribute = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:_homeVC];
    homeNav.tabBarItem.title = @"首页";
    [homeNav.tabBarItem setImage:[[UIImage imageNamed:@"首页"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [homeNav.tabBarItem setSelectedImage:[[UIImage imageNamed:@"首页_click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [homeNav.tabBarItem setTitleTextAttributes:textSelectedAttribute forState:UIControlStateSelected];
    [homeNav.tabBarItem setTitleTextAttributes:textAttribute forState:UIControlStateNormal];
    [homeNav.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [homeNav.navigationBar setShadowImage:[[UIImage alloc] init]];
    [homeNav.navigationBar setTitleTextAttributes:titleTextAttribute];
    
    // 开启/关闭抢单按钮
    UIButton *listenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    listenButton.frame = CGRectMake(0, 0, 80, 20);
    [listenButton addTarget:self action:@selector(onToggleListen:) forControlEvents:UIControlEventTouchUpInside];
    [listenButton setTitle:@"开启抢单" forState:UIControlStateNormal];
    [listenButton setBackgroundColor:[UIColor whiteColor]];
    [listenButton setTitleColor:[UIColor colorWithRed:0x2B/255.0 green:0xB3/255.0 blue:0x6B/255.0 alpha:1.0] forState:UIControlStateNormal];
    listenButton.layer.cornerRadius = 10.0;
    _homeVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:listenButton];
    
    
    UINavigationController *missionNav = [[UINavigationController alloc] initWithRootViewController:missionVC];
    missionNav.tabBarItem.title = @"任务 ";
    [missionNav.tabBarItem setImage:[[UIImage imageNamed:@"任务 "] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [missionNav.tabBarItem setSelectedImage:[[UIImage imageNamed:@"任务 _click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [missionNav.tabBarItem setTitleTextAttributes:textSelectedAttribute forState:UIControlStateSelected];
    [missionNav.tabBarItem setTitleTextAttributes:textAttribute forState:UIControlStateNormal];
    [missionNav.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [missionNav.navigationBar setShadowImage:[[UIImage alloc] init]];
    [missionNav.navigationBar setTitleTextAttributes:titleTextAttribute];
    
    UINavigationController *profileNav = [[UINavigationController alloc] initWithRootViewController:profileVC];
    profileNav.tabBarItem.title = @"我的";
    [profileNav.tabBarItem setImage:[[UIImage imageNamed:@"我的"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [profileNav.tabBarItem setSelectedImage:[[UIImage imageNamed:@"我的_click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [profileNav.tabBarItem setTitleTextAttributes:textSelectedAttribute forState:UIControlStateSelected];
    [profileNav.tabBarItem setTitleTextAttributes:textAttribute forState:UIControlStateNormal];
    [profileNav.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [profileNav.navigationBar setShadowImage:[[UIImage alloc] init]];
    [profileNav.navigationBar setTitleTextAttributes:titleTextAttribute];
    self.viewControllers = @[homeNav, missionNav, profileNav];
    [SRMModalViewController sharedInstance].delegate = self;
    [NowOrders shareInstance].delegate = self;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"reminder.mp3" withExtension:nil];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
}

// 关闭/开启抢单
- (void)onToggleListen:(UIButton*)sender {
    if ([sender.titleLabel.text compare:@"开启抢单"] == NSOrderedSame) {
        [sender setTitle:@"关闭抢单" forState:UIControlStateNormal];
        [[NowOrders shareInstance] startListen];
    } else {
        if ([Utils locationAccess] == NO) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"要使用定位需要打开权限!" preferredStyle:UIAlertControllerStyleAlert];
            __weak UIAlertController *weakAlertController = alertController;
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [weakAlertController dismissViewControllerAnimated:NO completion:nil];
                
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @(NO)} completionHandler:nil];
                [weakAlertController dismissViewControllerAnimated:NO completion:nil];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }

        
        [sender setTitle:@"开启抢单" forState:UIControlStateNormal];
        [[NowOrders shareInstance] stopListen];
    }
}

#pragma mark - SRMModalViewControllerDelegate
- (void)modalViewWillShow:(SRMModalViewController *)modalViewController {
    _bModalShow = YES;
}
- (void)modalViewDidShow:(SRMModalViewController *)modalViewController {
    _bModalShow = YES;
}
- (void)modalViewWillHide:(SRMModalViewController *)modalViewController {
    _bModalShow = NO;
}
- (void)modalViewDidHide:(SRMModalViewController *)modalViewController {
    _bModalShow = NO;
}

#pragma mark - NowOrdersDelegate
- (void)showModalWithOrder:(NSDictionary *)order {
    if (_bModalShow || order == nil) {
        return;
    }
    [self.audioPlayer play];
    OrderView *orderView = [[OrderView alloc] initWithData:order homeVC:_homeVC];
    [[SRMModalViewController sharedInstance] showView:orderView];
}

@end
