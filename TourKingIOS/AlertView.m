//
//  AlertView.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/20.
//  Copyright © 2019 default. All rights reserved.
//

#import "AlertView.h"
#import <SRMModalViewController.h>


@implementation AlertView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CGRect rScreen = [[UIScreen mainScreen] bounds];
        self.frame = CGRectMake(40, 160, rScreen.size.width - 80, 250);
        [self.layer setCornerRadius:10.0f];
        [self.layer setMasksToBounds:YES];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(rScreen.size.width/2 - 62, 30, 44, 44)];
        imgView.image = [UIImage imageNamed:@"提示"];
        [self addSubview:imgView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, rScreen.size.width - 80, 18)];
        titleLabel.text = @"确认送达";
        [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [titleLabel setTextColor:[UIColor colorWithRed:0x2b/255.0 green:0xb3/255.0 blue:0x6c/255.0 alpha:1.0]];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 120, rScreen.size.width - 140, 65)];
        [messageLabel setFont:[UIFont systemFontOfSize:15]];
        messageLabel.textColor = [UIColor colorWithWhite:0x33/255.0 alpha:1.0];
        messageLabel.text = @"您确认乘客已到达目的地并结束行程\r\n乘客未到达目的地会有投诉风险！";
        messageLabel.numberOfLines = 2;
        [self addSubview:messageLabel];
        
        UIButton *cancelBtn =[UIButton buttonWithType:UIButtonTypeSystem];
        cancelBtn.frame = CGRectMake(rScreen.size.width/4 - 20 - 50, 205, 100, 25);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize: 18]];
        [cancelBtn addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        okBtn.frame = CGRectMake(rScreen.size.width*3/4 - 60 - 50, 205, 100, 25);
        [okBtn setTitle:@"确认" forState:UIControlStateNormal];
        [okBtn.titleLabel setFont:[UIFont systemFontOfSize: 18]];
        [okBtn addTarget:self action:@selector(onOK:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:okBtn];
    }
    return self;
}

+ (instancetype)initWithCancelBlock:(btnBlock)cancelBlock okBlock:(btnBlock)okBlock {
    AlertView *alert = [[AlertView alloc] init];
    alert.okBlock = okBlock;
    alert.cancelBlock = cancelBlock;
    return alert;
}

- (void)onCancel:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [[SRMModalViewController sharedInstance] hide];
}

- (void)onOK:(id)sender {
    if (self.okBlock) {
        self.okBlock();
    }
    [[SRMModalViewController sharedInstance] hide];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
