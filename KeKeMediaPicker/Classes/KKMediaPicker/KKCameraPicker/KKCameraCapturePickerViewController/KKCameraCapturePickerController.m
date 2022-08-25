//
//  KKCameraCapturePickerController.m
//  KeKeMediaPicker
//
//  Created by edward lannister on 2022/08/25.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import "KKCameraCapturePickerController.h"
#import "KKCameraCaptureViewController.h"

@interface KKCameraCapturePickerController ()<KKCameraCaptureViewControllerDelegate>

@property(nonatomic,weak)id<KKCameraCapturePickerDelegate> delegate;

@end

@implementation KKCameraCapturePickerController
@dynamic delegate;

// .h中警告说delegate在父类已经声明过了，子类再声明也不会重新生成新的方法了。我们就在这里使用@dynamic告诉系统delegate的setter与getter方法由用户自己实现，不由系统自动生成
#pragma mark ==================================================
#pragma mark == delegate 重设
#pragma mark ==================================================
- (void)setDelegate:(id<KKCameraCapturePickerDelegate>)delegate{
    super.delegate = delegate;
}

- (id<KKCameraCapturePickerDelegate>)delegate{
    id curDelegate = super.delegate;
    return curDelegate;
}


/* 初始化 */
- (instancetype)initWithDelegate:(id<KKCameraCapturePickerDelegate>)aDelegate{
    self = [super init];
    if (self) {
        self.delegate = aDelegate;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        KKCameraCaptureViewController *vc = [[KKCameraCaptureViewController alloc] init];
        vc.delegate = self;
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

/// 完成拍摄
/// @param aFileFullPath 拍摄保存的文件路径
/// @param aFileName 拍摄保存的文件的文件名
/// @param aExtention 拍摄保存的文件的扩展名（png、mp4、mov）
/// @param aTimeDuration 如果是拍摄的视频，这个是视频的时长
- (void)KKCameraCaptureViewController_FinishedWithFilaFullPath:(NSString*)aFileFullPath
                                                      fileName:(NSString*)aFileName
                                                 fileExtention:(NSString*)aExtention
                                                  timeDuration:(NSString*)aTimeDuration{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraCapturePicker_FinishedWithFilaFullPath:fileName:fileExtention:timeDuration:)]) {
        [self.delegate KKCameraCapturePicker_FinishedWithFilaFullPath:aFileFullPath fileName:aFileName fileExtention:aExtention timeDuration:aTimeDuration];
    }
}


@end
