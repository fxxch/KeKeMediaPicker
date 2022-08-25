//
//  UIWindow+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UIWindow+KKMediaPicker.h"

@implementation UIWindow (KKMediaPicker)

//获取当前屏幕显示的viewcontroller
- (nullable UIViewController *)kkmp_currentTopViewController{
    UIViewController *rootViewController = self.rootViewController;
    UIViewController *currentVC = [self kkmp_getTopViewControllerFrom:rootViewController];
    return currentVC;
}

- (nullable UIViewController *)kkmp_getTopViewControllerFrom:(nullable UIViewController *)rootVC{
    UIViewController *currentVC;
    //有从rootVC presented出来的视图
    if ([rootVC presentedViewController]) {
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self kkmp_getTopViewControllerFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self kkmp_getTopViewControllerFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}

+ (UIWindow*)kkmp_currentKeyWindow{
    
    UIWindow* window = nil;
    
    if (@available(iOS 13.0, *)) {
       for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
       {
           if (windowScene.activationState == UISceneActivationStateForegroundActive)
           {
               for (UIWindow *subWindow in [windowScene windows]) {
                   if (subWindow.hidden == NO) {
                       window = subWindow;
                       break;
                   }
               }
           }
       }
        
        if (window==nil) {
            for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
            {
                if (windowScene.activationState == UISceneActivationStateForegroundInactive)
                {
                    for (UIWindow *subWindow in [windowScene windows]) {
                        if (subWindow.hidden == NO) {
                            window = subWindow;
                            break;
                        }
                    }
                }
            }
        }
    }
    else {
        window = [UIApplication sharedApplication].keyWindow;
    }
    
    return window;
}

+ (CGFloat)kkmp_safeAreaBottomHeight{
    CGFloat safeAreaBottomHeight = ([UIWindow kkmp_currentKeyWindow].safeAreaInsets.bottom);
    return safeAreaBottomHeight;
}

+ (CGFloat)kkmp_screenWidth{
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)kkmp_screenHeight{
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)kkmp_statusBarHeight{
    if (@available(iOS 13.0,*)) {
        CGFloat statusBarHeight = [UIWindow kkmp_currentKeyWindow].windowScene.statusBarManager.statusBarFrame.size.height;
        return statusBarHeight;
    }
    else{
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        return statusBarHeight;
    }
}

+ (CGFloat)kkmp_navigationBarHeight{
    return 44;
}

+ (CGFloat)kkmp_statusBarAndNavBarHeight{
    return UIWindow.kkmp_statusBarHeight + UIWindow.kkmp_navigationBarHeight;
}

+ (nullable UIViewController *)kkmp_viewControllerOfView:(UIView*)aView{
    return (UIViewController *)[UIWindow kkmp_traverseResponderChainForUIViewController:aView];
}

+ (nullable id)kkmp_traverseResponderChainForUIViewController:(UIView*)aView {
    id nextResponder = [aView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [UIWindow kkmp_traverseResponderChainForUIViewController:nextResponder];
    } else {
        return nil;
    }
}


@end
