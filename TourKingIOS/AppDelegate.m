//
//  AppDelegate.m
//  TourKingIOS
//
//  Created by liuyuanpeng on 2019/6/3.
//  Copyright © 2019 default. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginVC.h"
#import "TKViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "TKLocationManager.h"
#import "User.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [[userDefault objectForKey:@"ISLOGIN"] isEqualToString:@"ISLOGIN"];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 高德地图key
    [AMapServices sharedServices].apiKey =@"aac824a5f853939bc7c4c284807ca232" ;
    
    self.window.rootViewController = [[TKViewController alloc] init];
    if (isLogin) {
        [[TKLocationManager shareInstance] startUpdatingLocation];
        [[User shareInstance] startSync];
    }

    if (!isLogin){
        [self.window.rootViewController presentViewController:[[LoginVC alloc] init] animated:NO completion:nil];
    }
    return YES;
}

- (void)logout {
    [[User shareInstance] logOut];
    [self.window.rootViewController presentViewController:[[LoginVC alloc] init] animated:NO completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[TKLocationManager shareInstance] stopUpdatingLocation];
    [[User shareInstance] stopSync];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[TKLocationManager shareInstance] startUpdatingLocation];
    [[User shareInstance] startSync];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
