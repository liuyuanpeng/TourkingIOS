//
//  ProfileVC.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/11.
//  Copyright © 2019 default. All rights reserved.
//

#import "ProfileVC.h"
#import "WebVC.h"
#import "LoginVC.h"

@interface ProfileVC ()
{
    UIImageView *_avatar;
    UILabel *_username;
    UIView *_starsView;
}
@end

@implementation ProfileVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人中心";
    [self.view setBackgroundColor:[UIColor colorWithWhite:244/255.0 alpha:1.0]];
    
    CGRect rScreen = [[UIScreen mainScreen] bounds];
    
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rScreen.size.width, 200)];
    [topView setImage:[UIImage imageNamed:@"Rectangle"]];
    [self.view addSubview:topView];
    
    CGRect rcTop = self.navigationController.navigationBar.frame;
    
    UIView *avatarView = [[UIView alloc] initWithFrame:CGRectMake(0, rcTop.origin.y + rcTop.size.height, rScreen.size.width, 140)];
    [avatarView setBackgroundColor:[UIColor whiteColor]];
    avatarView.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAvatar:)];
    [avatarView addGestureRecognizer:labelTapGestureRecognizer];
    [self.view addSubview:avatarView];
    
    _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    _avatar.layer.cornerRadius = 50.0;
    _avatar.clipsToBounds = YES;
    [_avatar setImage:[UIImage imageNamed:@"Rectangle"]];
    [avatarView addSubview:_avatar];
    
    UIImageView *rightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Shape"]];
    rightImg.frame = CGRectMake(rScreen.size.width - 27, (140-13)/2, 7, 13);
    [avatarView addSubview:rightImg];
    
    _username = [[UILabel alloc] initWithFrame:CGRectMake(_avatar.frame.origin.x + _avatar.frame.size.width + 20, 40, rScreen.size.width - 170, 20)];
    [_username setFont:[UIFont systemFontOfSize:20]];
    _username.text = @"刘远鹏";
    [avatarView addSubview:_username];
    
    _starsView = [[UIView alloc] initWithFrame:CGRectMake(_avatar.frame.origin.x + _avatar.frame.size.width + 20, 80, rScreen.size.width - 170, 20)];    [avatarView addSubview:_starsView];
    
    [self setStars:3];
    
    UIView *formView = [[UIView alloc] initWithFrame:CGRectMake(0, avatarView.frame.origin.y + avatarView.frame.size.height + 10, rScreen.size.width, 48*3+2)];
    formView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:formView];
    
    UIView *incomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rScreen.size.width, 80)];
    incomView.userInteractionEnabled=YES;
    UITapGestureRecognizer *inComeTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showIncome:)];
    [incomView addGestureRecognizer:inComeTapGestureRecognizer];
    [formView addSubview:incomView];

    UIImageView *income = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"我的收入"]];
    income.frame = CGRectMake(20, 12, 24, 24);
    [incomView addSubview:income];
    UIImageView *incomeRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Shape"]];
    incomeRight.frame = CGRectMake(rScreen.size.width - 27, (48-13)/2, 7, 13);
    [incomView addSubview:incomeRight];
    UILabel *incomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(54, 14, 100, 20)];
    incomeLabel.text = @"我的收入";
    [incomView addSubview:incomeLabel];
    UILabel *incomeTip = [[UILabel alloc] initWithFrame:CGRectMake(rScreen.size.width - 237, 14, 200, 20)];
    incomeTip.text = @"今日收入23123.2元";
    [incomeTip setTextAlignment:NSTextAlignmentRight];
    [incomeTip setTextColor:[UIColor colorWithRed:235/255.0 green:88/255.0 blue:88/255.0 alpha:1.0]];
    [incomView addSubview:incomeTip];
    
    
    UIView *lineSep1 = [[UIView alloc] initWithFrame:CGRectMake(20, 48, rScreen.size.width - 40, 1)];
    [lineSep1 setBackgroundColor:[UIColor colorWithWhite:244/255.0 alpha:1.0]];
    [formView addSubview:lineSep1];
    
    UIView *historyView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, rScreen.size.width, 80)];
    historyView.userInteractionEnabled=YES;
    UITapGestureRecognizer *historyTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showHistory:)];
    [historyView addGestureRecognizer:historyTapGestureRecognizer];
    [formView addSubview:historyView];
    
    UIImageView *history = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"历史订单"]];
    history.frame = CGRectMake(20, 12, 24, 24);
    [historyView addSubview:history];
    UIImageView *historyRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Shape"]];
    historyRight.frame = CGRectMake(rScreen.size.width - 27, (48-13)/2, 7, 13);
    [historyView addSubview:historyRight];
    UILabel *historyLabel = [[UILabel alloc]initWithFrame:CGRectMake(54, 14, 100, 20)];
    historyLabel.text = @"历史订单";
    [historyView addSubview:historyLabel];

    
    UIView *lineSep2 = [[UIView alloc] initWithFrame:CGRectMake(20, 97, rScreen.size.width - 40, 1)];
    [lineSep2 setBackgroundColor:[UIColor colorWithWhite:244/255.0 alpha:1.0]];
    [formView addSubview:lineSep2];
    
    UIView *aboutView = [[UIView alloc] initWithFrame:CGRectMake(0, 98, rScreen.size.width, 80)];
    aboutView.userInteractionEnabled=YES;
    UITapGestureRecognizer *aboutTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAbout:)];
    [aboutView addGestureRecognizer:aboutTapGestureRecognizer];
    [formView addSubview:aboutView];
    
    UIImageView *about = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"关于我们"]];
    about.frame = CGRectMake(20, 12, 24, 24);
    [aboutView addSubview:about];
    UIImageView *aboutRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Shape"]];
    aboutRight.frame = CGRectMake(rScreen.size.width - 27, (48-13)/2, 7, 13);
    [aboutView addSubview:aboutRight];
    UILabel *aboutLabel = [[UILabel alloc]initWithFrame:CGRectMake(54, 14, 100, 20)];
    aboutLabel.text = @"关于我们";
    [aboutView addSubview:aboutLabel];

    UIButton* logout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    logout.frame = CGRectMake(20, formView.frame.origin.y + formView.frame.size.height + 45, rScreen.size.width - 40, 50);
    logout.layer.cornerRadius = 25.0;
    [logout.titleLabel setFont:[UIFont systemFontOfSize:40]];
    [logout setTitle:@"退出" forState:UIControlStateNormal];
    [logout setBackgroundColor:[UIColor whiteColor]];
    [logout setTitleColor:[UIColor colorWithRed:92/255.0 green:196/255.0 blue:142/255.0 alpha:1.0] forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(onLogout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logout];
    
}

- (void)changeAvatar:(UITapGestureRecognizer *)recognizer {
    
}

- (void)showIncome:(UITapGestureRecognizer *)recognizer {
    
}

- (void)showHistory:(UITapGestureRecognizer *)recognizer {
    
}

- (void) onLogout:(id)sender {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"ISLOGIN"];
    [self.navigationController.tabBarController setSelectedIndex:0];
    [self presentViewController:[[LoginVC alloc] init] animated:NO completion:nil];
}

- (void)showAbout:(UITapGestureRecognizer *)recognizer {
    [self presentViewController:[[WebVC alloc] initWithURL:@"http://www.kingtrip.vip/html/aboutdriver.html" title:@"关于我们"] animated:YES completion:nil];
}



- (void) setStars: (NSInteger) number {
    
    for (UIView* subView in _starsView.subviews) {
        [subView removeFromSuperview];
    }

    NSInteger half = number%2;
    NSInteger stars = number/2;
    NSInteger i = 0;
    for (; i < stars; i++) {
        UIImageView *star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Star1"]];
        star.frame = CGRectMake(i*20, 0, 15, 14);
        [_starsView addSubview:star];
    }
    if (half != 0) {
        UIImageView *halfStar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_"]];
        halfStar.frame = CGRectMake(i*20, 0, 15, 14);
        [_starsView addSubview:halfStar];
        i++;
    }
    for (; i <= 5; i++) {
        UIImageView *grayStar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Star2"]];
        grayStar.frame = CGRectMake(i*20, 0, 15, 14);
        [_starsView addSubview:grayStar];
    }
}

@end
