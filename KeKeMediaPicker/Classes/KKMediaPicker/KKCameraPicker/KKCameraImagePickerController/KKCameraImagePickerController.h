//
//  KKCameraImagePickerController.h
//  HeiPa
//
//  Created by liubo on 2019/3/12.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMediaPickerDefine.h"
#import "KKMediaPickerBaseNavigationController.h"

@protocol KKCameraImagePickerDelegate <NSObject,UINavigationControllerDelegate>
@required

- (void)KKCameraImagePicker_didFinishedPickImages:(NSArray <UIImage*>*)aImageArray;

@end


@interface KKCameraImagePickerController : KKMediaPickerBaseNavigationController

/// 初始化
/// @param aDelegate 代理
/// @param aNumberOfPhotosNeedSelected 拍摄的照片最大数量
/// @param aCropEnable 是否需要裁剪，仅在拍摄数量为1的时候有效（即numberOfPhotosNeedSelected为1的时候有效）
/// @param aCropSize 图片的裁剪大小，仅在拍摄数量为1的时候有效（即numberOfPhotosNeedSelected为1的时候有效）
/// @param aImageFileMaxSize 拍摄的图片的大小（KB），如果过大会自动压缩
- (instancetype)initWithDelegate:(id<KKCameraImagePickerDelegate>)aDelegate
      numberOfPhotosNeedSelected:(NSInteger)aNumberOfPhotosNeedSelected
                      cropEnable:(BOOL)aCropEnable
                        cropSize:(CGSize)aCropSize
                imageFileMaxSize:(NSInteger)aImageFileMaxSize;

@end
