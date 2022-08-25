//
//  AppDelegate.m
//  KKLibrary_Demo
//
//  Created by beartech on 14-10-20.
//  Copyright (c) 2014年 KeKeStudio. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];

    HomeViewController * viewController = [[HomeViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    window.rootViewController = nav;
    [window makeKeyAndVisible];

    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

@end
