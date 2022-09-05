//
//  KKAlbumPickerToolBar.h
//  KeKeMediaPicker
//
//  Created by edward lannister on 2022/09/05.
//  Copyright © 2022 KKLibrary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMediaPickerCountBoxView.h"

@class KKAlbumPickerToolBar;
#pragma mark ==================================================
#pragma mark == KKAlbumPickerToolBarDelegate
#pragma mark ==================================================
@protocol KKAlbumPickerToolBarDelegate <NSObject>
@optional

- (void)KKAlbumPickerToolBar_EditButtonClicked:(KKAlbumPickerToolBar*)toolView;

- (void)KKAlbumPickerToolBar_CountBoxButtonClicked:(KKAlbumPickerToolBar*)toolView;

- (void)KKAlbumPickerToolBar_DoneButtonClicked:(KKAlbumPickerToolBar*)toolView;


@end


@interface KKAlbumPickerToolBar : UIView

@property(nonatomic,strong)UIButton *editButton;

@property(nonatomic,strong)KKMediaPickerCountBoxView *countBoxButton;

@property(nonatomic,strong)UIButton *originButton;

@property(nonatomic,strong)UIButton *doneButton;


@property (nonatomic , weak) id<KKAlbumPickerToolBarDelegate> delegate;

- (void)setNumberOfPic:(NSInteger)numberOfPic maxNumberOfPic:(NSInteger)maxNumberOfPic;

@end
