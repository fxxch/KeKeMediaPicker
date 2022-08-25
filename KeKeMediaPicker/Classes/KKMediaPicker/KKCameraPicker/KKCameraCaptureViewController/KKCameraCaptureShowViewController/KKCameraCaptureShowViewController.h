//
//  KKCameraCaptureShowViewController.h
//  BM
//
//  Created by 刘波 on 2020/2/29.
//  Copyright © 2020 bm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMediaPickerDefine.h"
#import "KKCameraCaptureDataModal.h"
#import "KKMediaPickerBaseViewController.h"

@protocol KKCameraCaptureShowDelegate;

@interface KKCameraCaptureShowViewController : KKMediaPickerBaseViewController

- (instancetype _Nullable)initWithDataModal:(KKCameraCaptureDataModal*_Nullable)aDataModal
                            placholderImage:(UIImage*_Nullable)aImage;

@property (nonatomic , weak) id<KKCameraCaptureShowDelegate> _Nullable delegate;

@end

#pragma mark ==================================================
#pragma mark == KKCameraCaptureShowDelegate
#pragma mark ==================================================
@protocol KKCameraCaptureShowDelegate <NSObject>
@optional

- (void)KKCameraCaptureShowViewController_ClickedOK:(NSString*_Nullable)aFilepath;

@end
