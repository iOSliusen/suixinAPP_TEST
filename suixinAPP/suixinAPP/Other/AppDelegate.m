//
//  AppDelegate.m
//  suixinAPP
//
//  Created by 刘殿武 on 2017/3/7.
//  Copyright © 2017年 YGTechnology. All rights reserved.
//

#import "AppDelegate.h"
#import "SXLoginViewController.h"
#import "MerchantViewController.h"
 #import <SMS_SDK/SMSSDK.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
//    //未登录
//    SXLoginViewController * mainView = [[SXLoginViewController alloc]initWithNibName:@"SXLoginViewController" bundle:[NSBundle mainBundle]];
    //已登录
    MerchantViewController * mainView = [[MerchantViewController alloc]initWithNibName:@"MerchantViewController" bundle:[NSBundle mainBundle]];
    
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:mainView];
    
//    navi.navigationBar.backgroundColor = [UIColor redColor];
    
    [self.window setRootViewController:navi];
    [self.window makeKeyAndVisible];
    
    //mob 短信sdk 初始化
    [SMSSDK registerApp:@"1bf68ed6e78f8" withSecret:@"836700f130ca652ddd47c97ae66fc673"];
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
