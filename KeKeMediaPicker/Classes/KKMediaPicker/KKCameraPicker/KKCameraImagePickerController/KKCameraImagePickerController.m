//
//  KKCameraImagePickerController.m
//  HeiPa
//
//  Created by liubo on 2019/3/12.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKCameraImagePickerController.h"
#import "KKCameraImagePickerViewController.h"

@interface KKCameraImagePickerController ()

/* 拍摄的照片最大数量 */
@property (nonatomic,assign)NSInteger numberOfPhotosNeedSelected;

/* 是否需要裁剪，仅在拍摄数量为1的时候有效（即numberOfPhotosNeedSelected为1的时候有效） */
@property (nonatomic,assign)BOOL cropEnable;

/* 图片的裁剪大小，仅在拍摄数量为1的时候有效（即numberOfPhotosNeedSelected为1的时候有效） */
@property (nonatomic,assign)CGSize cropSize;

/* 拍摄的图片的大小（KB），如果过大会自动压缩 */
@property (nonatomic,assign)NSInteger imageFileMaxSize;

/* KKCameraImagePickerDelegate */
@property(nonatomic,weak)id<KKCameraImagePickerDelegate> delegate;

@end

@implementation KKCameraImagePickerController
@dynamic delegate;

// .h中警告说delegate在父类已经声明过了，子类再声明也不会重新生成新的方法了。我们就在这里使用@dynamic告诉系统delegate的setter与getter方法由用户自己实现，不由系统自动生成
#pragma mark ==================================================
#pragma mark == delegate 重设
#pragma mark ==================================================
- (void)setDelegate:(id<KKCameraImagePickerDelegate>)delegate{
    super.delegate = delegate;
}

- (id<KKCameraImagePickerDelegate>)delegate{
    id curDelegate = super.delegate;
    return curDelegate;
}


/* 初始化 */
- (instancetype)initWithDelegate:(id<KKCameraImagePickerDelegate>)aDelegate
      numberOfPhotosNeedSelected:(NSInteger)aNumberOfPhotosNeedSelected
                      cropEnable:(BOOL)aCropEnable
                        cropSize:(CGSize)aCropSize
                imageFileMaxSize:(NSInteger)aImageFileMaxSize{
    self = [super init];
    if (self) {
        self.delegate = aDelegate;
        self.numberOfPhotosNeedSelected = aNumberOfPhotosNeedSelected;
        self.cropEnable = aCropEnable;
        self.cropSize = aCropSize;
        self.imageFileMaxSize = aImageFileMaxSize;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        KKCameraImagePickerViewController *vc = [[KKCameraImagePickerViewController alloc] initWithDelegate:self.delegate numberOfPhotosNeedSelected:self.numberOfPhotosNeedSelected cropEnable:self.cropEnable cropSize:self.cropSize imageFileMaxSize:self.imageFileMaxSize];
        [self pushViewController:vc animated:NO];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

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
