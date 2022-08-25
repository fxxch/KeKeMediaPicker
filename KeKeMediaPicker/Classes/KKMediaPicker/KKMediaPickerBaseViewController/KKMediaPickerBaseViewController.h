//
//  KKMediaPickerBaseViewController.h
//  KeKeMediaPicker
//
//  Created by edward lannister on 2022/08/25.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMediaPickerDefine.h"

@interface UINavigationController (KKMediaPickerStatusBar)

@end



@interface KKMediaPickerBaseViewController : KKMPBaseViewController

#pragma mark ==================================================
#pragma mark == StatusBar
#pragma mark ==================================================
- (void)kkmp_setStatusBarHidden:(BOOL)hidden;

- (void)kkmp_setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation;

- (void)kkmp_setStatusBarHidden:(BOOL)hidden
                 statusBarStyle:(UIStatusBarStyle)barStyle
                  withAnimation:(UIStatusBarAnimation)animation;

@end
