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

@interface TKViewController ()

@end

@implementation TKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomeVC *homeVC = [[HomeVC alloc] init];
    MissionVC *missionVC = [[MissionVC alloc] init];
    ProfileVC *profileVC = [[ProfileVC alloc] init];
    
    NSDictionary *textAttribute = @{NSForegroundColorAttributeName: [UIColor colorWithRed:0xAD / 255.0 green:0xAD / 255.0 blue:0xAD / 255.0 alpha:1]};
    NSDictionary *textSelectedAttribute = @{NSForegroundColorAttributeName: [UIColor colorWithRed:0x59 / 255.0 green:0xC4 / 255.0 blue:0x8C / 255.0 alpha:1]};

    NSDictionary *titleTextAttribute = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];    homeNav.tabBarItem.title = @"首页";
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
    homeVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:listenButton];
    
    
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
}

// 关闭/开启抢单
- (void)onToggleListen:(UIButton*)sender {
    NSLog(@"关闭/开启抢单");
    [SRMModalViewController sharedInstance].enableTapOutsideToDismiss = NO;
    [[SRMModalViewController sharedInstance] showView:[[OrderView alloc]init]];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
