//
//  KKAlbumImageShowNavBar.h
//  HeiPa
//
//  Created by liubo on 2019/3/16.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKButton;
@class KKAlbumAssetModel;

#pragma mark ==================================================
#pragma mark == KKAlbumImageShowNavBarDelegate
#pragma mark ==================================================
@protocol KKAlbumImageShowNavBarDelegate <NSObject>
@optional

- (void)KKAlbumImageShowNavBar_LeftButtonClicked;
- (void)KKAlbumImageShowNavBar_RightButtonClicked;

@end


@interface KKAlbumImageShowNavBar : UIView

@property (nonatomic , strong) UIButton *backButton;
@property (nonatomic , strong) UIButton *rightButton;
@property (nonatomic , strong) UILabel  *titleLabel;
@property (nonatomic , weak) id<KKAlbumImageShowNavBarDelegate> delegate;

- (void)setSelect:(BOOL)select item:(KKAlbumAssetModel*)aModel;

- (BOOL)isSelect;

@end
