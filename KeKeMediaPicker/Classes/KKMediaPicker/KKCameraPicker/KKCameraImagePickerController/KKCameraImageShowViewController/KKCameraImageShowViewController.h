//
//  KKCameraImageShowViewController.h
//  HeiPa
//
//  Created by liubo on 2019/3/15.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMediaPickerDefine.h"
#import "KKCameraImagePickerController.h"
#import "KKMediaPickerBaseViewController.h"

#pragma mark ==================================================
#pragma mark == KKCameraImageShowViewControllerDelegate
#pragma mark ==================================================
@protocol KKCameraImageShowViewControllerDelegate <NSObject>
@optional

- (void)KKCameraImageShowViewController_DeleteItemAtIndex:(NSInteger)aIndex;

@end


@interface KKCameraImageShowViewController : KKMediaPickerBaseViewController

/* 初始化 */
- (instancetype)initWithDelegate:(id<KKCameraImageShowViewControllerDelegate>)aDelegate
                  pickerDelegate:(id<KKCameraImagePickerDelegate>)aPickerDelegate
                     imagesArray:(NSArray*)aImageArray
                       maxNumber:(NSInteger)amax;
@end
