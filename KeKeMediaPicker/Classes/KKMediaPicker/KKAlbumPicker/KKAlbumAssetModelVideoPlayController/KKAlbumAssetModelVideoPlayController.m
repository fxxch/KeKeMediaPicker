//
//  KKAlbumAssetModelVideoPlayController.m
//  BM
//
//  Created by sjyt on 2020/4/7.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKAlbumAssetModelVideoPlayController.h"
#import "KKAlbumAssetModelVideoPlayBar.h"
#import "KKAlbumAssetModelVideoPlayView.h"
#import "NSBundle+KKMediaPicker.h"
#import "UIWindow+KKMediaPicker.h"
#import "KKAlbumManager.h"

#define HiddenPlayerBarTimerMax 3

@interface KKAlbumAssetModelVideoPlayController ()
<KKAlbumAssetModelVideoPlayBarDelegate,UIGestureRecognizerDelegate,KKAlbumAssetModelVideoPlayViewDelegate>

@property (nonatomic,strong)KKAlbumAssetModelVideoPlayBar *toolBarView;
@property (nonatomic,strong)KKAlbumAssetModelVideoPlayView *player;
@property (nonatomic,strong)UIButton *playButton;
@property (nonatomic,assign)BOOL isGestureON;
@property (nonatomic,assign)CGSize videoFrameSize;
@property (nonatomic,assign) BOOL isVideo;
@property (nonatomic,strong) NSTimer *myTimer;//定时隐藏操作Bar
@property (nonatomic,assign) NSInteger myTimerCount;//定时隐藏操作Bar
@property (nonatomic,assign) BOOL isBarHidden;

@property (nonatomic , strong) KKAlbumAssetModel *albumAssetModel;

@end

@implementation KKAlbumAssetModelVideoPlayController

- (void)dealloc{
    [self destroyTimer];
}

- (instancetype)initWitKKAlbumAssetModel:(KKAlbumAssetModel*)aKKAlbumAssetModel{
    self = [super init];
    if (self) {
        self.albumAssetModel = aKKAlbumAssetModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    //播放器
    self.player = [[KKAlbumAssetModelVideoPlayView alloc] initWithFrame:self.view.bounds albumAssetModel:self.albumAssetModel];
    self.player.delegate = self;
    [self.view addSubview:self.player];
    //添加手势
    [self addGestureRecognizerOnView:self.player];
    
    //底部播放控制栏
    self.toolBarView = [[KKAlbumAssetModelVideoPlayBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-64, UIWindow.kkmp_screenWidth, 64)];
    self.toolBarView.delegate = self;
    self.toolBarView.durationtime = 1.0;
    self.toolBarView.currentTime = 0;
    [self.view addSubview:self.toolBarView];
    
    [self reloadSubViewsFrame];
    
    self.toolBarView.moreButton.hidden = YES;

    self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [self.playButton addTarget:self action:@selector(playButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton];
    UIImage *playImage = [NSBundle kkmp_imageInBundle:@"KKVideoPlay_Resource.bundle" imageName:@"VideoPlay_PlayBig"];
    [self.playButton setBackgroundImage:playImage forState:UIControlStateNormal];
    [self.playButton setCenter:self.player.center];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self kkmp_setStatusBarHidden:NO statusBarStyle:UIStatusBarStyleLightContent withAnimation:UIStatusBarAnimationFade];
//    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    delegate.onlySupportPortrait = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.player startPlay];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.player stopPlay];
}

- (void)navigationControllerPopBack{
//    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    delegate.onlySupportPortrait = YES;
    
    if (self.navigationController.presentingViewController) {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:^{

        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)playButtonClicked{
    [self.player startPlay];
}

#pragma mark ==================================================
#pragma mark == 屏幕旋转
#pragma mark ==================================================
//屏幕旋转之后，屏幕的宽高互换，我们借此判断重新布局
//横屏：size.width > size.height
//竖屏: size.width < size.height
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
        NSLog(@"转屏前调入");
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
        NSLog(@"转屏后调入");
        [self reloadSubViewsFrame];
    }];

    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)reloadSubViewsFrame{
    UIInterfaceOrientation currentIsPortrait = [UIApplication sharedApplication].statusBarOrientation;
    switch (currentIsPortrait) {
        case UIInterfaceOrientationUnknown:
        case UIInterfaceOrientationPortrait:{
            self.player.frame = CGRectMake(0, 0, UIWindow.kkmp_screenWidth, UIWindow.kkmp_screenHeight);

            self.toolBarView.frame = CGRectMake(0, self.player.frame.size.height-(UIWindow.kkmp_safeAreaBottomHeight+120), self.player.frame.size.width, 120+UIWindow.kkmp_safeAreaBottomHeight);
            [self.playButton setCenter:self.player.center];
            break;
        }
        case UIInterfaceOrientationPortraitUpsideDown:{
            CGFloat statusH = 0;
            //判断是否是iphoneX
//            if ([UIWindow kkmp_currentKeyWindow].safeAreaInsets.bottom > 0.0) {
//                statusH = UIWindow.kkmp_statusBarHeight;
//            }

            self.player.frame = CGRectMake(0, 0, UIWindow.kkmp_screenWidth, UIWindow.kkmp_screenHeight);

            self.toolBarView.frame = CGRectMake(0, self.player.frame.size.height-(statusH+120), self.player.frame.size.width, 120+statusH);
            [self.playButton setCenter:self.player.center];
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:{
            self.player.frame = CGRectMake(0, 0, UIWindow.kkmp_screenWidth, UIWindow.kkmp_screenHeight);
            /* 横屏 */
            self.toolBarView.frame = CGRectMake(0, self.player.frame.size.height-60, self.player.frame.size.width, 60);
            [self.playButton setCenter:self.player.center];
            break;
        }
        case UIInterfaceOrientationLandscapeRight:{
            CGFloat statusH = 0;
            //判断是否是iphoneX
            if ([UIWindow kkmp_currentKeyWindow].safeAreaInsets.bottom > 0.0) {
                statusH = UIWindow.kkmp_statusBarHeight;
            }

            self.player.frame = CGRectMake(0, 0, UIWindow.kkmp_screenWidth, UIWindow.kkmp_screenHeight);
            /* 横屏 */
            self.toolBarView.frame = CGRectMake(0, self.player.frame.size.height-60, self.player.frame.size.width, 60);
            [self.playButton setCenter:self.player.center];
            break;
        }
        default:
            break;
    }
}

#pragma mark ****************************************
#pragma mark 屏幕方向
#pragma mark ****************************************
//1.决定当前界面是否开启自动转屏，如果返回NO，后面两个方法也不会被调用，只是会支持默认的方向
- (BOOL)shouldAutorotate {
    return YES;
}

//2.返回支持的旋转方向（当前viewcontroller支持哪些转屏方向）
//iPad设备上，默认返回值UIInterfaceOrientationMaskAllButUpSideDwon
//iPad设备上，默认返回值是UIInterfaceOrientationMaskAll
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

//3.返回进入界面默认显示方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark ==================================================
#pragma mark == 手势
#pragma mark ==================================================
//添加手势
- (void)addGestureRecognizerOnView:(UIView*)aView{

    //单击手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognizer.delegate = self;
    [aView addGestureRecognizer:tapGestureRecognizer];

    UITapGestureRecognizer *doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognizer:)];
    doubleRecognizer.numberOfTapsRequired = 2;// 双击
    //关键语句，给self.view添加一个手势监测；
    [aView addGestureRecognizer:doubleRecognizer];
    // 关键在这一行，双击手势确定监测失败才会触发单击手势的相应操作
    [tapGestureRecognizer requireGestureRecognizerToFail:doubleRecognizer];
}

- (void)singleTapGestureRecognizer:(UITapGestureRecognizer*)recognizer{
    if ([self.player isPlaying]) {
        [self setAllBarHidden:!self.isBarHidden];
    }
}

- (void)doubleTapGestureRecognizer:(UITapGestureRecognizer*)recognizer{
    if ([self.player isPlaying]) {
        [self.player pausePlay];
    }
    else{
        [self.player startPlay];
    }
}

#pragma mark ==================================================
#pragma mark == 代理事件
#pragma mark ==================================================
- (void)KKAlbumAssetModelVideoPlayBar_BackButtonClicked:(KKAlbumAssetModelVideoPlayBar*)aView{
    UIInterfaceOrientation nowOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (nowOrientation==UIInterfaceOrientationLandscapeLeft ||
        nowOrientation==UIInterfaceOrientationLandscapeRight) {
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [self performSelector:@selector(navigationControllerPopBack) withObject:nil afterDelay:duration*0.5];
    }
    else{
        [self performSelector:@selector(navigationControllerPopBack) withObject:nil afterDelay:0];
    }
}

- (void)KKAlbumAssetModelVideoPlayBar_MoreButtonClicked:(KKAlbumAssetModelVideoPlayBar*)aView{

}

//播放
- (void)KKAlbumAssetModelVideoPlayBar_PlayButtonClicked:(KKAlbumAssetModelVideoPlayBar*)aView{
    [self.player startPlay];
}

//暂停
- (void)KKAlbumAssetModelVideoPlayBar_PauseButtonClicked:(KKAlbumAssetModelVideoPlayBar*)aView{
    [self.player pausePlay];
}

//前进
- (void)KKAlbumAssetModelVideoPlayBar:(KKAlbumAssetModelVideoPlayBar*)aView currentTimeChanged:(NSTimeInterval)aCurrentTime{
    [self.player seekToBackTime:aCurrentTime];
}

#pragma mark ==================================================
#pragma mark == 视频播放代理
#pragma mark ==================================================
//播放开始
- (void)KKAlbumAssetModelVideoPlayView_PlayDidStart:(KKAlbumAssetModelVideoPlayView*)player{
    [self.toolBarView setButtonStatusPlaying];
    [self startTimer];
    self.playButton.hidden = YES;
}

//继续开始
- (void)KKAlbumAssetModelVideoPlayView_PlayDidContinuePlay:(KKAlbumAssetModelVideoPlayView*)player{
    [self.toolBarView setButtonStatusPlaying];
    [self startTimer];
    self.playButton.hidden = YES;
}

//播放结束
- (void)KKAlbumAssetModelVideoPlayView_PlayDidFinished:(KKAlbumAssetModelVideoPlayView*)player{
    [self.toolBarView setButtonStatusStop];
    self.toolBarView.currentTime = 0;
    self.toolBarView.durationtime = 1.0;
    self.toolBarView.mySlider.value = 0;
    
    [self destroyTimer];
    [self setAllBarHidden:NO];
    self.playButton.hidden = NO;
}

//播放暂停
- (void)KKAlbumAssetModelVideoPlayView_PlayDidPause:(KKAlbumAssetModelVideoPlayView*)player{
    [self.toolBarView setButtonStatusStop];
    [self destroyTimer];
    [self setAllBarHidden:NO];
    self.playButton.hidden = NO;
}

//播放时间改变
- (void)KKAlbumAssetModelVideoPlayView:(KKAlbumAssetModelVideoPlayView*)player
                   playBackTimeChanged:(NSTimeInterval)currentTime
                          durationtime:(NSTimeInterval)durationtime{
    if (self.isGestureON==NO && self.toolBarView.isSliderTouched==NO) {
        self.toolBarView.currentTime = currentTime;
        self.toolBarView.durationtime = durationtime;
        self.toolBarView.mySlider.value = currentTime;
    }
}

#pragma mark ==================================================
#pragma mark == 定时器
#pragma mark ==================================================
- (void)startTimer{
    self.myTimerCount = HiddenPlayerBarTimerMax;
    [self destroyTimer];
    __weak   typeof(self) weakself = self;
    self.myTimer = [NSTimer kkmp_scheduledTimerWithTimeInterval:1.0 block:^{
        [weakself timerLoop];
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.myTimer forMode:NSRunLoopCommonModes];
}

- (void)timerLoop{
    if (self.toolBarView.isSliderTouched==NO) {
        self.myTimerCount = self.myTimerCount - 1;
    } else {
        self.myTimerCount = HiddenPlayerBarTimerMax;
    }
    if (self.myTimerCount<=0) {
        [self setAllBarHidden:YES];
    }
}

- (void)destroyTimer{
    if (_myTimer) {
        [_myTimer invalidate];
        _myTimer = nil;
    }
}

- (void)setAllBarHidden:(BOOL)hidden{
    if (self.isBarHidden == hidden) {
        return;
    }
    
    self.isBarHidden = hidden;
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    if (self.isBarHidden) {
        [self kkmp_setStatusBarHidden:YES statusBarStyle:UIStatusBarStyleLightContent withAnimation:UIStatusBarAnimationFade];
        [UIView animateWithDuration:duration animations:^{
            self.toolBarView.alpha = 0;
        } completion:^(BOOL finished) {

        }];
    } else {
        self.myTimerCount = HiddenPlayerBarTimerMax;
        [self kkmp_setStatusBarHidden:NO statusBarStyle:UIStatusBarStyleLightContent withAnimation:UIStatusBarAnimationFade];

        [UIView animateWithDuration:duration animations:^{
            self.toolBarView.alpha = 1.0;
        } completion:^(BOOL finished) {

        }];
    }
}

@end
