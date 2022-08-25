//
//  KKImageCropperViewController.m
//  HeiPa
//
//  Created by liubo on 2019/3/12.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKImageCropperViewController.h"
#import "UIImage+KKMediaPicker.h"
#import "KKMediaPickerDefine.h"
#import "UIWindow+KKMediaPicker.h"

@interface KKImageCropperViewController ()

@property (nonatomic , strong) KKAlbumAssetModal *inModal;
@property (nonatomic , strong) UIImage *inImage;
@property (nonatomic , assign) CGSize inCropSize;
@property (nonatomic , strong) KKImageCropperView  *imageCropperView;
@property (nonatomic , copy) KKImageCropperFinishedBlock _Nullable finishedBlock;

@end


@implementation KKImageCropperViewController

- (void)dealloc{

}

- (id)initWithAssetModal:(KKAlbumAssetModal *)aModal cropSize:(CGSize)cropSize{
    if (self = [super init]) {
        self.inModal = aModal;
        UIImage *tempImage = [UIImage imageWithData:aModal.img_originData];
        self.inImage = [tempImage kkmp_fixOrientation];
        self.inCropSize = cropSize;
    }
    return self;
}

- (id)initWithImage:(UIImage *)aImage cropSize:(CGSize)cropSize{
    if (self = [super init]) {
        self.inImage = [aImage kkmp_fixOrientation];
        self.inCropSize = cropSize;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    
    //左导航
    UIImage *leftImage = [KKAlbumManager themeImageForName:@"NavBack"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton setImage:leftImage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(navigationLeftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    leftButton.exclusiveTouch = YES;//关闭多点
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSeperator,leftItem, nil];
    
    //右导航
    UIImage *rightImage = [KKAlbumManager themeImageForName:@"NavGou"];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(croppedImage) forControlEvents:UIControlEventTouchUpInside];
    rightButton.exclusiveTouch = YES;//关闭多点
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *negativeSeperator2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSeperator2,rightItem, nil];

    
    [self initUI];
}

- (void)initUI{
    [self.view setBackgroundColor:[UIColor blackColor]];

    self.imageCropperView = [[KKImageCropperView alloc] initWithFrame:CGRectMake(0,0,UIWindow.kkmp_screenWidth,UIWindow.kkmp_screenHeight-UIWindow.kkmp_statusBarAndNavBarHeight)];
    [self.imageCropperView setImage:self.inImage];
    [self.imageCropperView setCropSize:self.inCropSize];
    [self.view addSubview:self.imageCropperView];
}

- (void)navigationLeftButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cropImage:(KKImageCropperFinishedBlock)block{
    if (self.finishedBlock != block) {
        self.finishedBlock = block;
    }
}

- (void)croppedImage {
    if (self.finishedBlock != nil) {
        self.finishedBlock(self.inModal,self.imageCropperView.croppedImage);
    }
}

#pragma mark ==================================================
#pragma mark == 主体颜色
#pragma mark ==================================================
/* 子类可重写该方法，不重写的话默认是白色 */
- (UIColor*)kk_DefaultNavigationBarBackgroundColor{
    return [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //导航栏底部线清除
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self prefersStatusBarHidden];
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark ==================================================
#pragma mark == 状态栏
#pragma mark ==================================================
/* 重写方法 */
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden{
    return  NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationNone;
}

@end
