//
//  UIWindow+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (KKMediaPicker)

//获取当前屏幕显示的viewcontroller
- (nullable UIViewController *)kkmp_currentTopViewController;

+ (UIWindow*_Nullable)kkmp_currentKeyWindow;

+ (CGFloat)kkmp_safeAreaBottomHeight;

+ (CGFloat)kkmp_screenWidth;

+ (CGFloat)kkmp_screenHeight;

+ (CGFloat)kkmp_statusBarHeight;

+ (CGFloat)kkmp_navigationBarHeight;

+ (CGFloat)kkmp_statusBarAndNavBarHeight;

+ (nullable UIViewController *)kkmp_viewControllerOfView:(nullable UIView*)aView;

@end
