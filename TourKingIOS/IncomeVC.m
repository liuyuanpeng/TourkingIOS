//
//  ImcomeVC.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/13.
//  Copyright © 2019 default. All rights reserved.
//

#import "IncomeVC.h"
#import <MJRefresh.h>
#import "IncomeTableViewCell.h"
#import <DateTools/DateTools.h>
#import "SRMonthPicker.h"
#import "Income.h"
#import "Utils.h"

@interface IncomeVC () <UITableViewDataSource, UITableViewDelegate, SRMonthPickerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *income;
@property (nonatomic, strong) UIView *pickerView;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) SRMonthPicker *monthPickerView;
@property (nonatomic, strong) UIButton *dateBtn;
@property (nonatomic, strong) NSDate *keyMonth;

@end

@implementation IncomeVC
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
    __weak __typeof(self)weakSelf = self;
    [[Income shareInstance] getListWithMonth:_keyMonth callback:^(BOOL ok) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.income.text = [NSString stringWithFormat:@"收入 ￥%.2f", [Income shareInstance].total];
        if (ok){
            [weakSelf.tableView reloadData];
        }
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
    [customLab setText:@"我的收入"];
    customLab.font = [UIFont systemFontOfSize:20];
    navigationBarTitle.titleView = customLab;
    [navigationBar pushNavigationItem: navigationBarTitle animated:YES];
    
    [self.view addSubview: navigationBar];
    
    //创建UIBarButton 可根据需要选择适合自己的样式
    
    //创建UIBarButton 可根据需要选择适合自己的样式
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"i_back"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBackButton:)];
    
    
    //设置barbutton
    
    navigationBarTitle.leftBarButtonItem = item;
    
    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
    CGRect rcTop = navigationBar.frame;
    
    UIView *summaryView = [[UIView alloc] initWithFrame:CGRectMake(0, rcTop.origin.y + rcTop.size.height, rScreen.size.width, 48)];
    summaryView.backgroundColor = [UIColor colorWithWhite:216/255.0 alpha:1.0];
    [self.view addSubview:summaryView];
    
    _dateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _dateBtn.frame = CGRectMake(15, 8, 100, 32);
    _dateBtn.layer.cornerRadius = 16;
    [_dateBtn.layer setMasksToBounds:YES];
    _dateBtn.backgroundColor = [UIColor whiteColor];
    [_dateBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_dateBtn setTitle:@"本月" forState:UIControlStateNormal];
    [_dateBtn addTarget:self action:@selector(onDateBtn:) forControlEvents:UIControlEventTouchUpInside];
    [summaryView addSubview:_dateBtn];
    
    self.income = [[UILabel alloc] initWithFrame:CGRectMake(rScreen.size.width - 315, 15, 300, 18)];
    [self.income setTextColor:[UIColor blackColor]];
    self.income.textAlignment = NSTextAlignmentRight;
    [self.income setFont:[UIFont systemFontOfSize:18]];
    [summaryView addSubview:self.income];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, rcTop.origin.y + rcTop.size.height + 48, rScreen.size.width, rScreen.size.height - rcTop.origin.y - rcTop.size.height - 48) style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor colorWithWhite:244/255.0 alpha:1.0]];
    //    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    
    self.pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, rScreen.size.height - rScreen.size.width*3/4, rScreen.size.width, rScreen.size.width*3/4)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.layer.shadowOpacity = 0.5;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(10, 5, 100, 30);
    [cancelBtn addTarget:self action:@selector(onPickerCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerView addSubview:cancelBtn];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    okBtn.frame = CGRectMake(rScreen.size.width - 110, 5, 100, 30);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(onPickerOK:) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerView addSubview:okBtn];
    self.monthPickerView = [[SRMonthPicker alloc] init];
    self.monthPickerView.frame = CGRectMake(0, 40, rScreen.size.width, self.pickerView.frame.size.height - 30);
    NSDate *currentDate = [NSDate date];
    self.monthPickerView.date = currentDate;
    self.selectedDate = currentDate;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear fromDate:currentDate];
    self.monthPickerView.minimumYear = 2018;
    self.monthPickerView.maximumYear = [components year];
    self.monthPickerView.yearFirst = YES;
    self.monthPickerView.wrapMonths = YES;
    self.monthPickerView.layer.borderWidth = 0.5;
    self.monthPickerView.layer.borderColor = [UIColor colorWithWhite:100/255.0 alpha:0.5].CGColor;
    self.monthPickerView.monthPickerDelegate = self;
    [self.pickerView addSubview:self.monthPickerView];
    
    self.keyMonth = [NSDate date];
}

- (void)onPickerOK:(id)sender{
    _keyMonth = [NSDate date];
    if (self.selectedDate.timeIntervalSince1970 >= [Utils getMonthBeginOfDate:[NSDate date]]) {
        [_dateBtn setTitle:@"本月" forState:UIControlStateNormal];
    } else {
        [_dateBtn setTitle:[self.selectedDate formattedDateWithFormat:@"yyyy-MM"] forState:UIControlStateNormal];
        _keyMonth = self.selectedDate;
    }
    
    [self refreshData];
    
    [self.pickerView removeFromSuperview];
}

- (void)onPickerCancel: (id)sender {
    [self.pickerView removeFromSuperview];
}

- (void)navigationBackButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)onDateBtn: (id)sender {
    if (self.selectedDate) {
        self.monthPickerView.date = self.selectedDate;
    }
    [self.view addSubview:self.pickerView];
}

#pragma mark - UITableView Delegate Implementation
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

#pragma mark - UITableView Datasource Impletation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [Income shareInstance].orders ? [Income shareInstance].orders.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IncomeTableViewCell *cell = [IncomeTableViewCell cellWithTableView:tableView];
    NSInteger rowIndex = indexPath.row;
    NSDictionary *data = [[Income shareInstance].orders objectAtIndex:rowIndex];
    NSTimeInterval settledTimeInterval = [[data objectForKey:@"done_time"] doubleValue]/1000;
    NSDate *settledTime = [NSDate dateWithTimeIntervalSince1970:settledTimeInterval];
    [cell setName:[data objectForKey:@"username"] phone:[data objectForKey:@"mobile"] time:[settledTime formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"] income:[NSString stringWithFormat:@"+%.2f", [[data objectForKey:@"price"] doubleValue]]];
    return cell;
}

#pragma mark - MonthPickerView Delegate
- (void)monthPickerDidChangeDate:(SRMonthPicker *)monthPicker {
    self.selectedDate = monthPicker.date;
}
@end
