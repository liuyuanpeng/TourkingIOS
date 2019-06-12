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
        
        
        CGRect rScreen = [[UIScreen mainScreen] bounds];
        CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
        
        UINavigationBar *navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, rect.size.height, rScreen.size.width, 44)];
        
        //创建UINavigationItem
        
        UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:title];
        
        [navigationBar pushNavigationItem: navigationBarTitle animated:YES];
        
        [self.view addSubview: navigationBar];
        
        //创建UIBarButton 可根据需要选择适合自己的样式
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(navigationBackButton:)];
        
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
