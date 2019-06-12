//
//  HomeVC.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/8.
//  Copyright © 2019 default. All rights reserved.
//

#import "HomeVC.h"
#import "MissionTableViewCell.h"
#import <ODRefreshControl.h>

@interface HomeVC ()<UITableViewDelegate, UITableViewDataSource>
{
    UITextField *_phone;
    UITextField *_captcha;
    UIButton *_sendCaptcha;
    UIButton *_login;
    ODRefreshControl *_refreshControl;
}
@end

@implementation HomeVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:244/255.0 alpha:1.0]];
    
    CGRect rNav = self.navigationController.navigationBar.frame;
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    CGRect rView =CGRectMake(0, rNav.origin.y + rNav.size.height, rScreen.size.width, rScreen.size.height - rNav.origin.y - rNav.size.height - self.tabBarController.tabBar.frame.size.height);
    
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rScreen.size.width, 200)];
    [topView setImage:[UIImage imageNamed:@"Rectangle"]];
    [self.view addSubview:topView];
    
    self.tableView = [[UITableView alloc] initWithFrame:rView style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
     _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [_refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
}

- (void) dropViewDidBeginRefreshing: (id)sender {
    [_refreshControl endRefreshing];
}

#pragma mark - UITableView Delegate Implementation
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableView Datasource Impletation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MissionTableViewCell *cell = [MissionTableViewCell cellWithTableView:tableView viewController:self];
    return cell;
}

@end
