//
//  DetailVC.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/10/18.
//  Copyright © 2019 default. All rights reserved.
//

#import "DetailVC.h"
#import "AFNRequestManager.h"
#import <LCBannerView.h>
#import "RouteTableViewCell.h"

@interface DetailVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSMutableArray *roads;
@property (nonatomic, strong) UINavigationItem *navigationBarTitle;
@end

@implementation DetailVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.roads = [[NSMutableArray alloc]init];
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
    
    //设置barbutton
    _navigationBarTitle.leftBarButtonItem = item;
    
    [self getDetail];
}

- (void)buildViews {
    
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    CGFloat topHeight = 44.0f;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, rect.size.height + topHeight, rScreen.size.width, rScreen.size.height - rect.size.height - topHeight )];
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:scrollView];
    
    NSDictionary *privateConsume = [_data objectForKey:@"private_consume"];
    
    NSString *images = [privateConsume objectForKey:@"images"];
    NSArray *URLs = [images length] > 0 ? [images componentsSeparatedByString:@","] :@[];
    
    LCBannerView *bannerView = [LCBannerView bannerViewWithFrame:CGRectMake(0,0, rScreen.size.width, rScreen.size.width/2.0)
                                                        delegate:nil
                                                       imageURLs:URLs
                                            placeholderImageName:nil
                                                    timeInterval:2.0f
                                   currentPageIndicatorTintColor:[UIColor redColor]
                                          pageIndicatorTintColor:[UIColor whiteColor]];
    [scrollView addSubview:bannerView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, rScreen.size.width/2, rScreen.size.width - 40, 60.0)];
    [titleLab setText:[NSString stringWithFormat:@"%@", [privateConsume objectForKey:@"name"]]];
    [titleLab setFont:[UIFont boldSystemFontOfSize:25]];
    [titleLab setNumberOfLines:0];
    [titleLab sizeToFit];
    [scrollView addSubview:titleLab];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(20, titleLab.frame.origin.y + titleLab.frame.size.height + 10, rScreen.size.width - 40,rScreen.size.height - rect.size.height - topHeight) style:UITableViewStylePlain];
    
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [scrollView addSubview:self.tableView];
    
    scrollView.contentSize = CGSizeMake(rScreen.size.width,self.tableView.frame.origin.y + self.tableView.frame.size.height);
    
}

- (void)navigationBackButton: (id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createRoads {
    if (_data) {
        NSArray *roads = [[NSMutableArray alloc] initWithArray:[_data objectForKey:@"roads"]];
        [self.roads removeAllObjects];
        CGRect rScreen = [[UIScreen mainScreen] bounds];
        for (NSInteger i = 0; i < roads.count; i++) {
            NSDictionary *road = [roads objectAtIndex:i];
            CGFloat height = 25.0f;
            CGFloat contentWidth = rScreen.size.width - 40;
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentWidth - 70, 0)];
            [title setFont:[UIFont boldSystemFontOfSize:20]];
            title.text = [NSString stringWithFormat:@"%@", [_data objectForKey:@"name"]];
            [title setNumberOfLines:0];
            [title sizeToFit];
            height += title.frame.size.height;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:road];
            NSString *images = [NSString stringWithFormat:@"%@", [road objectForKey:@"images"]];
            if (images != nil && ![images isEqual:[NSNull null]]) {
                height += (contentWidth - 70)/2;
            }
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentWidth - 70, 0)];
            [label setFont:[UIFont systemFontOfSize:20]];
            label.text = [NSString stringWithFormat:@"%@", [road objectForKey:@"day_road"]];
            [label setNumberOfLines:0];
            [label sizeToFit];
            height += label.frame.size.height;
            height -= 90;
            [dict setObject:[NSString stringWithFormat:@"%f", height] forKey:@"height"];
            if (i == roads.count - 1) {
                [dict setObject:[NSNumber numberWithBool:YES] forKey:@"last"];
            } else {
                [dict setObject:[NSNumber numberWithBool:NO] forKey:@"last"];
            }
            [self.roads addObject:dict];
        }
    }
}

- (void)getDetail {
    if (!self.detailID) {
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    [AFNRequestManager requestAFURL:@"/travel/private_consume/get" httpMethod:METHOD_GET params:@{@"private_consume_id": self.detailID} data:nil succeed:^(NSDictionary *ret) {
        if (ret == nil)
        {
            return;
        }
        weakSelf.data = [ret objectForKey:@"data"];
        [weakSelf createRoads];
        NSLog(@"%@", weakSelf.data);
        [weakSelf buildViews];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UITableView Delegate Implementation
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowIndex = indexPath.row;
    NSDictionary *cellData = [NSDictionary dictionaryWithDictionary:[self.roads objectAtIndex:rowIndex]];
    return [[cellData objectForKey:@"height"] floatValue] + 100.0f;
}

#pragma mark - UITableView Datasource Impletation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_data) {
        return self.roads.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowIndex = indexPath.row;
    NSDictionary *cellData = [NSDictionary dictionaryWithDictionary:[self.roads objectAtIndex:rowIndex]];
    RouteTableViewCell *cell = [RouteTableViewCell cellWithTableView:self.tableView];
    [cell setData:cellData];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}
@end