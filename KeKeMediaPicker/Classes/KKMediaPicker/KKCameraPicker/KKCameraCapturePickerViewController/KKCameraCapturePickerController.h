//
//  KKCameraCapturePickerController.h
//  KeKeMediaPicker
//
//  Created by edward lannister on 2022/08/25.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMediaPickerDefine.h"

#pragma mark ==================================================
#pragma mark == KKCameraCapturePickerDelegate
#pragma mark ==================================================
@protocol KKCameraCapturePickerDelegate <NSObject,UINavigationControllerDelegate>
@optional

/// 完成拍摄
/// @param aFileFullPath 拍摄保存的文件路径
/// @param aFileName 拍摄保存的文件的文件名
/// @param aExtention 拍摄保存的文件的扩展名（png、mp4、mov）
/// @param aTimeDuration 如果是拍摄的视频，这个是视频的时长
- (void)KKCameraCapturePicker_FinishedWithFilaFullPath:(NSString*)aFileFullPath
                                              fileName:(NSString*)aFileName
                                         fileExtention:(NSString*)aExtention
                                          timeDuration:(NSString*)aTimeDuration;
@end


@interface KKCameraCapturePickerController : UINavigationController

/* 初始化 */
- (instancetype)initWithDelegate:(id<KKCameraCapturePickerDelegate>)aDelegate;

@end
