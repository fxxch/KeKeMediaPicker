//
//  KKMediaPickerBaseNavigationController.m
//  KeKeMediaPicker
//
//  Created by edward lannister on 2022/08/25.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import "KKMediaPickerBaseNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "KKMediaPickerBaseViewController.h"

@interface KKMediaPickerBaseNavigationController ()

@property (nonatomic,assign)BOOL kkmp_needHideStatusBarApplication;
@property (nonatomic,assign)UIStatusBarStyle kkmp_statusBarStyleApplication;

@end

@implementation KKMediaPickerBaseNavigationController


#pragma mark ==================================================
#pragma mark == 内存相关
#pragma mark ==================================================
- (void)dealloc
{

}

#pragma mark ==================================================
#pragma mark == 实例化
#pragma mark ==================================================
- (instancetype)init{
    self = [super init];
    if (self) {
        self.kkmp_needHideStatusBarApplication = UIApplication.sharedApplication.statusBarHidden;
        self.kkmp_statusBarStyleApplication = UIApplication.sharedApplication.statusBarStyle;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    [attributes setValue:[UIFont systemFontOfSize:16]
                  forKey:NSFontAttributeName];
    
    [attributes setObject:[UIColor blackColor]
                   forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes = attributes;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.viewControllers.lastObject isKindOfClass:[KKMediaPickerBaseViewController class]]) {
        [(KKMediaPickerBaseViewController*)self.viewControllers.lastObject kkmp_setStatusBarHidden:self.kkmp_needHideStatusBarApplication statusBarStyle:self.kkmp_statusBarStyleApplication withAnimation:UIStatusBarAnimationNone];
    }
}


//是否自动旋转
//返回导航控制器的顶层视图控制器的自动旋转属性，因为导航控制器是以栈的原因叠加VC的
//topViewController是其最顶层的视图控制器，
-(BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}

//支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

//默认方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden{
    return self.topViewController;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.viewControllers.count == 1){
        return NO;
    }
    return YES;
}
@end
