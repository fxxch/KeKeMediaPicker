//
//  KKAlbumImagePickerNavTitleBar.h
//  BM
//
//  Created by sjyt on 2020/3/23.
//  Copyright © 2020 bm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKAlbumDirectoryModel;

NS_ASSUME_NONNULL_BEGIN

@protocol KKAlbumImagePickerNavTitleBarDelegate;

@interface KKAlbumImagePickerNavTitleBar : UIView

@property (nonatomic , strong) UIButton *backgroundView;
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) UIButton *arrowButton;

@property (nonatomic , assign) BOOL isOpen;

@property (nonatomic , weak) id<KKAlbumImagePickerNavTitleBarDelegate> delegate;

- (void)close;

- (void)open;

- (void)reloadWithDirectoryModel:(KKAlbumDirectoryModel*)aModel;

@end


#pragma mark ==================================================
#pragma mark == KKAlbumImagePickerNavTitleBarDelegate
#pragma mark ==================================================
@protocol KKAlbumImagePickerNavTitleBarDelegate <NSObject>
@optional

- (void)KKAlbumImagePickerNavTitleBar_Open:(BOOL)aOpen;

@end


NS_ASSUME_NONNULL_END
