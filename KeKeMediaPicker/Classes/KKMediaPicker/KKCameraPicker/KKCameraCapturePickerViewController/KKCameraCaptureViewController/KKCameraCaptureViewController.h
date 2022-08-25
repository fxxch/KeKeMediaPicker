//
//  KKCameraCaptureViewController.h
//  BM
//
//  Created by 刘波 on 2020/2/29.
//  Copyright © 2020 bm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMediaPickerDefine.h"
#import "KKMediaPickerBaseViewController.h"

@protocol KKCameraCaptureViewControllerDelegate;


@interface KKCameraCaptureViewController : KKMediaPickerBaseViewController

@property(nonatomic,weak)id<KKCameraCaptureViewControllerDelegate> delegate;



@end


#pragma mark ==================================================
#pragma mark == KKCameraCaptureViewControllerDelegate
#pragma mark ==================================================
@protocol KKCameraCaptureViewControllerDelegate <NSObject>
@optional


/// 完成拍摄
/// @param aFileFullPath 拍摄保存的文件路径
/// @param aFileName 拍摄保存的文件的文件名
/// @param aExtention 拍摄保存的文件的扩展名（png、mp4、mov）
/// @param aTimeDuration 如果是拍摄的视频，这个是视频的时长
- (void)KKCameraCaptureViewController_FinishedWithFilaFullPath:(NSString*)aFileFullPath
                                                      fileName:(NSString*)aFileName
                                                 fileExtention:(NSString*)aExtention
                                                  timeDuration:(NSString*)aTimeDuration;
@end
