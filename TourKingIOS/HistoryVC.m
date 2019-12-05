//
//  HistoryVC.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/13.
//  Copyright © 2019 default. All rights reserved.
//

#import "HistoryVC.h"
#import "HistoryTableViewCell.h"
#import "HistoryOrders.h"
#import <MJRefresh.h>

@interface HistoryVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HistoryVC
- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshData {
    __weak UITableView *tableView = self.tableView;
    [[HistoryOrders shareInstance] getList:^(BOOL ok) {
        if (ok){
            [tableView reloadData];
            [tableView.mj_header endRefreshing];
        }
    }];
}

- (void)loadMoreData {
    if ([HistoryOrders shareInstance].noMore) {
        // 没有更多数据了
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    __weak UITableView *tableView = self.tableView;
    [[HistoryOrders shareInstance] loadMore:^(BOOL ok) {
        [tableView.mj_footer endRefreshing];
        [tableView reloadData];
    }];
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
    //创建UINavigationItem
    
    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] init];
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"历史订单"];
    customLab.font = [UIFont systemFontOfSize:20];
    navigationBarTitle.titleView = customLab;
    [navigationBar pushNavigationItem: navigationBarTitle animated:YES];
    
    [self.view addSubview: navigationBar];
    
    //创建UIBarButton 可根据需要选择适合自己的样式
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0,25,25)];
    [button setBackgroundImage:[UIImage imageNamed:@"i_back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navigationBackButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //设置barbutton
    
    navigationBarTitle.leftBarButtonItem = item;
    
    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
    CGRect rcTop = navigationBar.frame;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, rcTop.origin.y + rcTop.size.height, rScreen.size.width, rScreen.size.height - rcTop.origin.y - rcTop.size.height) style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor colorWithWhite:244/255.0 alpha:1.0]];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)navigationBackButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UITableView Delegate Implementation
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 205.0;
}

#pragma mark - UITableView Datasource Impletation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [HistoryOrders shareInstance].orders ? [HistoryOrders shareInstance].orders.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryTableViewCell *cell = [HistoryTableViewCell cellWithTableView:tableView];
    [cell setData:[[HistoryOrders shareInstance].orders objectAtIndex:indexPath.row]];
    return cell;
}

@end
