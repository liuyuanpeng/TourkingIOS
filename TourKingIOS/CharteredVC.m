//
//  CharteredVC.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/10/18.
//  Copyright © 2019 default. All rights reserved.
//

#import "CharteredVC.h"
#import "MissionTableViewCell.h"
#import "OnlineOrders.h"
#import <MJRefresh.h>

@interface CharteredVC ()<UITableViewDelegate, UITableViewDataSource>
{
    UITextField *_phone;
    UITextField *_captcha;
    UIButton *_sendCaptcha;
    UIButton *_login;
}
@end

@implementation CharteredVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"包车";
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:0x3F/255.0 green:0xB7/255.0 blue:0x62/255.0 alpha:1.0]];

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
    [super viewWillAppear:animated];
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
    NSInteger rowIndex = indexPath.row;
    NSDictionary *rowData = [OnlineOrders shareInstance].charteredOrders[rowIndex];
    NSString *scene = [rowData objectForKey:@"scene"];
    if ([scene compare:@"DAY_PRIVATE"] == NSOrderedSame) {
        return 250.0;
    } else {
        return 220.0;
    }
}

#pragma mark - UITableView Datasource Impletation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [OnlineOrders shareInstance].charteredOrders == nil ? 0 : [OnlineOrders shareInstance].charteredOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowIndex = indexPath.row;
    NSDictionary *rowData = [OnlineOrders shareInstance].charteredOrders[rowIndex];
    NSString *scene = [rowData objectForKey:@"scene"];
    MissionTableViewCell *cell = [MissionTableViewCell cellWithTableView:tableView viewController:self scene: scene];
    [cell setData:rowData];
    return cell;
}

@end
