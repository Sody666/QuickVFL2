//
//  AppDelegate.m
//  QuickVFL2
//
//  Created by 苏第 on 17/11/8.
//  Copyright © 2017年 Quick. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow* myWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    myWindow.backgroundColor = [UIColor whiteColor];
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    nvc.navigationBar.translucent = NO;
    myWindow.rootViewController = nvc;
    
    self.window = myWindow;
    [myWindow makeKeyAndVisible];
    return YES;
}

@end
