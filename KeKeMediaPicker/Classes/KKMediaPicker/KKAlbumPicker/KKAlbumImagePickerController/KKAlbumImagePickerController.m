//
//  KKAlbumImagePickerController.m
//  HeiPa
//
//  Created by liubo on 2019/3/12.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKAlbumImagePickerController.h"
#import "KKAlbumImagePickerImageViewController.h"
#import "KKAlbumImagePickerManager.h"
#import "KKMediaPickerDefine.h"

@interface KKAlbumImagePickerController ()

@property (nonatomic , weak) id<KKAlbumImagePickerDelegate> delegate;

@end


@implementation KKAlbumImagePickerController
@dynamic delegate;

// .h中警告说delegate在父类已经声明过了，子类再声明也不会重新生成新的方法了。我们就在这里使用@dynamic告诉系统delegate的setter与getter方法由用户自己实现，不由系统自动生成
#pragma mark ==================================================
#pragma mark == delegate 重设
#pragma mark ==================================================
- (void)setDelegate:(id<KKAlbumImagePickerDelegate>)delegate{
    super.delegate = delegate;
}

- (id<KKAlbumImagePickerDelegate>)delegate{
    id curDelegate = super.delegate;
    return curDelegate;
}

- (void)dealloc
{
    [KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected = 0;
    [KKAlbumImagePickerManager defaultManager].cropEnable = NO;
    [KKAlbumImagePickerManager defaultManager].cropSize = CGSizeMake(200, 200);
    [KKAlbumImagePickerManager defaultManager].delegate = nil;
    [[KKAlbumImagePickerManager defaultManager] clearAllObjects];
    [KKAlbumImagePickerManager defaultManager].isSelectOrigin = NO;

    [KKAlbumManager deleteCachePathOfDirectory:@"KKMediaPicker"];
}

/* 初始化 */
- (instancetype)initWithDelegate:(id<KKAlbumImagePickerDelegate>)aDelegate
      numberOfPhotosNeedSelected:(NSInteger)aNumberOfPhotosNeedSelected
                      cropEnable:(BOOL)aCropEnable
                        cropSize:(CGSize)aCropSize
                  assetMediaType:(KKAssetMediaType)aMediaType{
    self = [super init];
    if (self) {
        [KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected = aNumberOfPhotosNeedSelected;
        [KKAlbumImagePickerManager defaultManager].cropEnable = aCropEnable;
        [KKAlbumImagePickerManager defaultManager].cropSize = aCropSize;
        [KKAlbumImagePickerManager defaultManager].mediaType = aMediaType;
        [KKAlbumImagePickerManager defaultManager].delegate = aDelegate;
        [[KKAlbumImagePickerManager defaultManager] clearAllObjects];
        self.delegate = aDelegate;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    KKAlbumImagePickerImageViewController *photoViewController = [[KKAlbumImagePickerImageViewController alloc] init];
    [self setViewControllers:@[photoViewController] animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (self.navigationBar.titleTextAttributes) {
        [attributes setValuesForKeysWithDictionary:self.navigationBar.titleTextAttributes];
        [attributes setObject:[UIColor whiteColor]
                       forKey:NSForegroundColorAttributeName];
    }
    else{
        [attributes setValue:[UIFont boldSystemFontOfSize:18]
                      forKey:NSFontAttributeName];
        [attributes setObject:[UIColor whiteColor]
                       forKey:NSForegroundColorAttributeName];
    }
    self.navigationBar.titleTextAttributes = attributes;
}

@end
