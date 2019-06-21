//
//  WebVC.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/11.
//  Copyright © 2019 default. All rights reserved.
//

#import "WebVC.h"

@implementation WebVC

- (instancetype) initWithURL:(NSString *)url title:(NSString *)title {
    self = [super init];
    if (self) {
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        
        self.view.backgroundColor = [UIColor colorWithRed:57/255.0 green:180/255.0 blue:105/255.0 alpha:1.0];

        CGRect rScreen = [[UIScreen mainScreen] bounds];
        CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
        
        UINavigationBar *navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, rect.size.height, rScreen.size.width, 44)];
        [navigationBar setBackgroundColor:nil];
        [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];//以及隐隐都得设置为[UIImage new]
        navigationBar.shadowImage = [UIImage new];

        
        //创建UINavigationItem
        
        UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] init];
        UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        [customLab setTextColor:[UIColor whiteColor]];
        [customLab setText:title];
        customLab.font = [UIFont systemFontOfSize:20];
        navigationBarTitle.titleView = customLab;
        [navigationBar pushNavigationItem: navigationBarTitle animated:YES];
        
        [self.view addSubview: navigationBar];
        
        //创建UIBarButton 可根据需要选择适合自己的样式        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"i_back"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBackButton:)];
        
        //设置barbutton
        
        navigationBarTitle.leftBarButtonItem = item;
        
        [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, rect.size.height + 44, rect.size.width, rScreen.size.height - rect.size.height - 44)];
        [self.view addSubview:webView];
        
        [webView loadRequest:request];    }
    return self;
}

- (void)navigationBackButton: (id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
