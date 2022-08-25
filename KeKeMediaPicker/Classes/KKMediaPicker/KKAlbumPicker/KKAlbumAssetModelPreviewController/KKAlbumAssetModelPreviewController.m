//
//  KKAlbumAssetModelPreviewController.m
//  BM
//
//  Created by sjyt on 2020/4/7.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKAlbumAssetModelPreviewController.h"
#import "KKAlbumAssetModelPreviewView.h"
#import "KKAlbumAssetModel.h"
#import "UIWindow+KKMediaPicker.h"

@interface KKAlbumAssetModelPreviewController ()

@property (nonatomic , strong) UIImageView *imageView;

@property (nonatomic , strong) NSArray *itemsArray;
@property (nonatomic , assign) NSInteger selectIndex;
@property (nonatomic , weak) UINavigationController *NavController;
@property (nonatomic , assign) CGRect fromRect;

@end

@implementation KKAlbumAssetModelPreviewController

+ (void)showFromNavigationController:(UINavigationController*_Nullable)aNavController
                               items:(NSArray<KKAlbumAssetModel*>*_Nullable)aItemsArray
                       selectedIndex:(NSInteger)aSelectedIndex
                            fromRect:(CGRect)aFromRect{
    if ([aItemsArray count]<=0 ||
        aNavController == nil) {
        return;
    }

    if (CGRectEqualToRect(aFromRect, CGRectZero)) {
        KKAlbumAssetModelPreviewController *viewController = [[KKAlbumAssetModelPreviewController alloc] initWithNavigationController:aNavController items:aItemsArray selectedIndex:aSelectedIndex fromRect:aFromRect];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        [aNavController presentViewController:nav animated:YES completion:^{

        }];
    } else {
        KKAlbumAssetModelPreviewController *viewController = [[KKAlbumAssetModelPreviewController alloc] initWithNavigationController:aNavController items:aItemsArray selectedIndex:aSelectedIndex fromRect:aFromRect];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        [aNavController presentViewController:nav animated:NO completion:^{

        }];
    }
    
}

- (instancetype)initWithNavigationController:(UINavigationController*)aNavController
                                       items:(NSArray<KKAlbumAssetModel*>*_Nullable)aItemsArray
                               selectedIndex:(NSInteger)aSelectedIndex
                                    fromRect:(CGRect)aFromRect{
    self = [super init];
    if (self) {
        self.fromRect = aFromRect;
        self.NavController = aNavController;
        self.itemsArray = aItemsArray;
        self.selectIndex = aSelectedIndex;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.01];

    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIWindow.kkmp_screenWidth, UIWindow.kkmp_screenHeight)];
    [self.view addSubview:self.imageView];
    
    UIGraphicsBeginImageContextWithOptions(self.NavController.view.bounds.size,NO,[UIScreen mainScreen].scale);
    [self.NavController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.imageView.image = snapshotImage;
}

- (void)show{
    if (self.itemsArray) {
        KKAlbumAssetModelPreviewView *windowImageView = [[KKAlbumAssetModelPreviewView alloc]initWithFrame:CGRectMake(0, 0, UIWindow.kkmp_screenWidth, UIWindow.kkmp_screenHeight) items:self.itemsArray selectedIndex:self.selectIndex fromRect:self.fromRect];
        windowImageView.tag = 2020040701;
        windowImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:windowImageView];

        [windowImageView show];

        self.itemsArray = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self show];
}


@end
