//
//  KKMediaPickerBaseViewController.m
//  KeKeMediaPicker
//
//  Created by edward lannister on 2022/08/25.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import "KKMediaPickerBaseViewController.h"

#define KKNavigationBarButtonTitleFont [UIFont systemFontOfSize:14]

@implementation UINavigationController (KKMediaPickerStatusBar)

- (UIViewController *)kkmp_childViewControllerForStatusBarStyle{
    return self.topViewController;
}

- (UIViewController *)kkmp_childViewControllerForStatusBarHidden{
    return self.topViewController;
}

@end

@interface KKMediaPickerBaseViewController ()

@property (nonatomic,assign)BOOL kkmp_needHideStatusBar;
@property (nonatomic,assign)UIStatusBarStyle kkmp_statusBarStyle;
@property (nonatomic,assign)UIStatusBarAnimation kkmp_statusBarAnimation;

@end

@implementation KKMediaPickerBaseViewController

#pragma mark ==================================================
#pragma mark == 内存相关
#pragma mark ==================================================
- (instancetype)init{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.kkmp_statusBarStyle = UIStatusBarStyleDefault;
        self.kkmp_statusBarAnimation = UIStatusBarAnimationFade;
        self.kkmp_needHideStatusBar = NO;
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == 实例化
#pragma mark ==================================================
- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self kkmp_initNavigatonBarUI];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self kkmp_setStatusBarHidden:NO];
}


#pragma mark ==================================================
#pragma mark == 状态栏
#pragma mark ==================================================
/* 外部调用接口方法 */
- (void)kkmp_setStatusBarHidden:(BOOL)hidden{
    [self kkmp_setStatusBarHidden:hidden statusBarStyle:UIApplication.sharedApplication.statusBarStyle withAnimation:UIStatusBarAnimationNone];
}

- (void)kkmp_setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation{
    [self kkmp_setStatusBarHidden:hidden statusBarStyle:UIApplication.sharedApplication.statusBarStyle withAnimation:animation];
}

- (void)kkmp_setStatusBarHidden:(BOOL)hidden
                 statusBarStyle:(UIStatusBarStyle)barStyle
                  withAnimation:(UIStatusBarAnimation)animation{
    self.kkmp_needHideStatusBar = hidden;
    self.kkmp_statusBarStyle = barStyle;
    self.kkmp_statusBarAnimation = animation;
    [self prefersStatusBarHidden];
    [self setNeedsStatusBarAppearanceUpdate];
    UIApplication.sharedApplication.statusBarStyle = self.kkmp_statusBarStyle;
}

/* 重写方法 */
- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.kkmp_statusBarStyle;
}

- (BOOL)prefersStatusBarHidden{
    return  self.kkmp_needHideStatusBar;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return self.kkmp_statusBarAnimation;
}

#pragma mark ==================================================
#pragma mark == NavigationBar UI
#pragma mark ==================================================
- (void)kkmp_initNavigatonBarUI{
    self.extendedLayoutIncludesOpaqueBars = NO;
    /*
     当 automaticallyAdjustsScrollViewInsets 为 NO 时，tableview 是从屏幕的最上边开始，也就是被 导航栏 & 状态栏覆盖
     当 automaticallyAdjustsScrollViewInsets 为 YES 时，也是默认行为，表现就比较正常了，和edgesForExtendedLayout = UIRectEdgeNone 有啥区别？ 不注意可能很难觉察， automaticallyAdjustsScrollViewInsets 为YES 时，tableView 上下滑动时，是可以穿过导航栏&状态栏的，在他们下面有淡淡的浅浅红色
     */
    //self.automaticallyAdjustsScrollViewInsets = YES;
    /*
     在IOS7以后 ViewController 开始使用全屏布局的，而且是默认的行为通常涉及到布局，就离不开这个属性 edgesForExtendedLayout，它是一个类型为UIExtendedEdge的属性，指定边缘要延伸的方向，它的默认值很自然地是UIRectEdgeAll，四周边缘均延伸，就是说，如果即使视图中上有navigationBar，下有tabBar，那么视图仍会延伸覆盖到四周的区域。因为一般为了不让tableView 不延伸到 navigationBar 下面， 属性设置为 UIRectEdgeNone
     
     这时会发现导航栏变灰了，处理如下就OK了，self.navigationController.navigationBar.translucent = NO;
     */
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIColor *navigationBarColor = [self kkmp_DefaultNavigationBarBackgroundColor];
    [self.navigationController.navigationBar setBarTintColor:navigationBarColor];
    [self.navigationController.navigationBar setTintColor:navigationBarColor];
    [self.navigationController.navigationBar setBackgroundColor:navigationBarColor];
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = navigationBarColor;
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance=self.navigationController.navigationBar.standardAppearance;
    }
    
    //导航栏背景透明
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //导航栏底部线清除
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

/* 子类可重写该方法，不重写的话默认是白色 */
- (UIColor*)kkmp_DefaultNavigationBarBackgroundColor{
    return [UIColor blackColor];
}

#pragma mark ==================================================
#pragma mark == 屏幕方向
#pragma mark ==================================================
//1.决定当前界面是否开启自动转屏，如果返回NO，后面两个方法也不会被调用，只是会支持默认的方向
- (BOOL)shouldAutorotate {
    return YES;
}

//2.返回支持的旋转方向（当前viewcontroller支持哪些转屏方向）
//iPad设备上，默认返回值UIInterfaceOrientationMaskAllButUpSideDwon
//iPad设备上，默认返回值是UIInterfaceOrientationMaskAll
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

//3.返回进入界面默认显示方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}




@end
