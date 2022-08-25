//
//  KKCameraImageShowNavBar.h
//  HeiPa
//
//  Created by liubo on 2019/3/15.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark ==================================================
#pragma mark == KKCameraImageShowNavBarDelegate
#pragma mark ==================================================
@protocol KKCameraImageShowNavBarDelegate <NSObject>
@optional

- (void)KKCameraImageShowNavBar_LeftButtonClicked;
- (void)KKCameraImageShowNavBar_RightButtonClicked;

@end


@interface KKCameraImageShowNavBar : UIView

@property (nonatomic , strong) UIButton *backButton;
@property (nonatomic , strong) UIButton *rightButton;
@property (nonatomic , strong) UILabel  *titleLabel;
@property (nonatomic , weak) id<KKCameraImageShowNavBarDelegate> delegate;

@end
