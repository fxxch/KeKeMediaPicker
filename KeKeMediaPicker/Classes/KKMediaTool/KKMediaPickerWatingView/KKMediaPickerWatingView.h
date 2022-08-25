//
//  KKMediaPickerWatingView.h
//  KeKeMediaPicker
//
//  Created by edward lannister on 2022/08/15.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKMediaPickerWatingView : UIView

@property (nonatomic,assign)BOOL blackBackground;

- (void)startAnimating;

- (void)stopAnimating;

+ (KKMediaPickerWatingView*)showInView:(UIView*)aView
                       blackBackground:(BOOL)aBlackBackground;

+ (void)hideForView:(UIView*)aView;

+ (void)hideForView:(UIView*)aView animation:(BOOL)animation;

@end
