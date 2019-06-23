//
//  MissionVC.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/11.
//  Copyright © 2019 default. All rights reserved.
//

#import "MissionVC.h"
#import "MissionTableViewCell.h"
#import "OnlineOrders.h"
#import <MJRefresh.h>

@interface MissionVC ()<UITableViewDelegate, UITableViewDataSource>
{
    UITextField *_phone;
    UITextField *_captcha;
    UIButton *_sendCaptcha;
    UIButton *_login;
}
@end

@implementation MissionVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"未指派任务";
    
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
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
}


- (void) viewWillAppear:(BOOL)animated {
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshData {
    
    __weak UITableView *tableView = self.tableView;

    [[OnlineOrders shareInstance] getList:^(BOOL ok) {
        if (ok) {
            [tableView reloadData];
        }
        [tableView.mj_header endRefreshing];
    }];
}


#pragma mark - UITableView Delegate Implementation
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250.0;
}

#pragma mark - UITableView Datasource Impletation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [OnlineOrders shareInstance].orders == nil ? 0 : [OnlineOrders shareInstance].orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MissionTableViewCell *cell = [MissionTableViewCell cellWithTableView:tableView viewController:self];
    NSInteger rowIndex = indexPath.row;
    NSDictionary *rowData = [OnlineOrders shareInstance].orders[rowIndex];
    [cell setData:rowData];
    return cell;
}

@end
