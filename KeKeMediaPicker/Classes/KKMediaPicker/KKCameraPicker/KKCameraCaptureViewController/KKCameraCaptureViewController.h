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

- (void)KKCameraCaptureViewController_FinishedWithFilaFullPath:(NSString*)aFileFullPath
                                                      fileName:(NSString*)aFileName
                                                 fileExtention:(NSString*)aExtention
                                                  timeDuration:(NSString*)aTimeDuration;
@end
