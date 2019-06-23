//
//  LoginVC.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/6.
//  Copyright © 2019 default. All rights reserved.
//

#import "LoginVC.h"
#import "AFNRequestManager.h"
#import "UICheckBox.h"
#import "Utils.h"
#import <Toast/UIView+Toast.h>
#import "UIButton+countDown.h"
#import "WebVC.h"
#import "User.h"

NSString *TEST_ACCOUNT = @"18559643214";

@interface LoginVC ()
{
    UICheckBox *_checkbox;
    UITextField *_phone;
    UITextField *_captcha;
    UIButton *_sendCaptcha;
    UIButton *_login;
}
@end

@implementation LoginVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    
    UILabel *welcome = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, rScreen.size.width - 40, 50)];
    [welcome setText:@"欢迎来到旅王驾到"];
    [welcome setFont:[UIFont systemFontOfSize:40]];
    [self.view addSubview:welcome];
    
    _phone = [[UITextField alloc] initWithFrame:CGRectMake(20, welcome.frame.origin.y + 100, rScreen.size.width - 40, 20)];
    [_phone setPlaceholder:@"请输入手机号"];
    [_phone setFont:[UIFont systemFontOfSize:20]];
    [_phone setKeyboardType:UIKeyboardTypePhonePad];
    [_phone addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_phone];
    
    UIView *lineSep1 = [[UIView alloc] initWithFrame:CGRectMake(20, _phone.frame.origin.y + 28, rScreen.size.width - 40, 1)];
    [lineSep1 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:lineSep1];
    
    _captcha = [[UITextField alloc] initWithFrame:CGRectMake(20, lineSep1.frame.origin.y + 31, rScreen.size.width - 40, 20)];
    [_captcha setPlaceholder:@"请输入验证码"];
    [_captcha setKeyboardType:UIKeyboardTypeNumberPad];
    [_captcha addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_captcha];
    
    _sendCaptcha = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _sendCaptcha.frame = CGRectMake(rScreen.size.width - 175, lineSep1.frame.origin.y + 25, 150, 30);
    _sendCaptcha.layer.cornerRadius = 15.0;
    _sendCaptcha.layer.borderWidth = 1.0;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0x2F/255.0, 0xB4/255.0, 0x6E/255.0, 1 });
    _sendCaptcha.layer.borderColor = colorref;
    [_sendCaptcha.layer setMasksToBounds:YES];
    [_sendCaptcha addTarget:self action:@selector(getCAPTCHA:) forControlEvents:UIControlEventTouchUpInside];
    [_sendCaptcha.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_sendCaptcha setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_sendCaptcha setTitleColor:[UIColor colorWithRed:0x2F/255.0 green:0xB4/255.0 blue:0x6E/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.view addSubview:_sendCaptcha];
    
    UIView *lineSep2 = [[UIView alloc] initWithFrame:CGRectMake(20, _captcha.frame.origin.y + 28, rScreen.size.width - 40, 1)];
    [lineSep2 setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:lineSep2];
    
    
    _checkbox = [[UICheckBox alloc]initWithFrame:CGRectMake(20, lineSep2.frame.origin.y + 31, 20, 20)];
    // 设置复选框选中和未选中时的图片
    [_checkbox setImageWithName:@"Circle" andSelectedName:@"Float_click"];
    [self.view addSubview:_checkbox];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(_checkbox.frame.origin.x + _checkbox.frame.size.width + 4, _checkbox.frame.origin.y, 70, 20)];
    textLabel.text = @"我已阅读";
    [self.view addSubview:textLabel];
    
    UIButton *clauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(textLabel.frame.origin.x + textLabel.frame.size.width, textLabel.frame.origin.y, 150, 20)];
    [clauseBtn addTarget:self action:@selector(onViewClause:) forControlEvents:UIControlEventTouchUpInside];
    [clauseBtn setTitle:@"《旅王服务条款》" forState:UIControlStateNormal];
    [clauseBtn setTitleColor:[UIColor colorWithRed:0xF9/255.0 green:0xa1/255.0 blue:0x60/255.0 alpha:1.0] forState:UIControlStateNormal];
    clauseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:clauseBtn];
    
    _login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _login.frame = CGRectMake(20, clauseBtn.frame.origin.y + 50, rScreen.size.width - 40, 50);
    _login.layer.cornerRadius = 25.0;
    [_login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_login.titleLabel setFont:[UIFont systemFontOfSize: 20]];
    [_login setTitle:@"登录" forState:UIControlStateNormal];
    [_login setEnabled:NO];
    [_login setBackgroundColor:[UIColor lightGrayColor]];
    [_login addTarget:self action:@selector(onLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_login];
    
    // 记住最近登录的账号
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:@"USER"] != nil) {
        [_phone setText:[userDefault objectForKey:@"USER"]];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
}

// 点击空白处收键盘
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

-(UIView*)createView:(Class)cls
                Name:(NSString*)name
{
    if([@"_checkbox" compare:name]==0){    }
    return nil;
}


- (void)getCAPTCHA: (id) sender{
    if (![Utils validatePhoneNumber:_phone.text]) {
        [self.view makeToast:@"请输入正确的手机号" duration:2 position:CSToastPositionCenter];
        return;
    }
    [_sendCaptcha startWithTime:60 title:@"发送验证码" countDownTitle:@"秒后重新发送" mainColor:[UIColor colorWithRed:43.0/255.0 green:179.0/255.0 blue:108.0/255.0 alpha:1.0] countColor: [UIColor lightGrayColor]];
    
    // 发送验证码
    [AFNRequestManager requestAFURL:@"/session/captcha" httpMethod:METHOD_POST params:nil
                               data:@{
                                      @"captcha_type":@"MOBILE",
                                      @"username":_phone.text
                                      }
                            succeed:^(NSDictionary * _Nonnull ret) {
                                if (ret == nil) return;
                                [User shareInstance].captcha_session_id = [NSString stringWithString:[[ret objectForKey:@"data"] objectForKey:@"captcha_session_id"]];
                            } failure:nil];
}

- (void)onLogin: (id)sender {
    if ([_checkbox isChecked] == NO) {
        [self.view makeToast:@"请先勾选已阅读《旅王服务条款》" duration:2 position:CSToastPositionCenter];
        return;
    }
    
    if ([_phone.text compare:TEST_ACCOUNT] == NSOrderedSame) {
        //测试账号登录
        [[User shareInstance] setData:
         @{
           @"user": @{
                   @"id":@"47244988445097984",@"name": @"lyp",
                   @"avatar":@"http://www.kingtrip.vip/travel_file/20190620154404.png",
                   @"mobile": @"18559643214"
                   },
           @"token_session": @{
                   @"token": @"b2ec4eafcb4949ac912a45e10a61599f"
                   }
           }];
        // 登录成功后退出登录窗口
        [[User shareInstance] loginSuccess];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if ([User shareInstance].captcha_session_id == nil) {
        [self.view makeToast:@"验证码不正确" duration:2 position:CSToastPositionCenter];
        return;
    }
    __weak __typeof(self) weakSelf = self;

    [AFNRequestManager requestAFURL:@"/user/captcha_login" httpMethod:METHOD_POST params:nil data:@{@"captcha":_captcha.text, @"captcha_session_id":[User shareInstance].captcha_session_id, @"username":_phone.text} succeed:^(NSDictionary *ret) {
        if (ret == nil) return;
        [[User shareInstance] setData:[ret objectForKey:@"data"]];
        // 登录成功后退出登录窗口
        [[User shareInstance] loginSuccess];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    } failure:nil];
    
    
}

- (void)onViewClause: (id) sender {
    [self presentViewController:[[WebVC alloc] initWithURL:@"http://www.kingtrip.vip/html/clausedriver.html" title:@"旅王服务条款"] animated:YES completion:nil];
}

- (void)textFieldChanged:(UITextField *)textField {
    if ([_captcha.text compare:@""] != NSOrderedSame && [Utils validatePhoneNumber: _phone.text]) {
        [_login setEnabled:YES];
        [_login setBackgroundColor:[UIColor colorWithRed:43/255.0 green:179/255.0 blue:108/255.0 alpha:1.0]];
    } else {
        [_login setEnabled:NO];
        [_login setBackgroundColor:[UIColor lightGrayColor]];
    }
}

@end


