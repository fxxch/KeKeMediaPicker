//
//  KKAlbumImagePickerDirectoryList.h
//  BM
//
//  Created by sjyt on 2020/3/23.
//  Copyright © 2020 bm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKAlbumImagePickerManager.h"

@protocol KKAlbumImagePickerDirectoryListDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface KKAlbumImagePickerDirectoryList : UIView

@property (nonatomic , weak) id<KKAlbumImagePickerDirectoryListDelegate> delegate;

- (void)beginHide;

- (void)beginShow;

@end

#pragma mark ==================================================
#pragma mark == KKAlbumImagePickerDirectoryListDelegate
#pragma mark ==================================================
@protocol KKAlbumImagePickerDirectoryListDelegate <NSObject>
@optional

- (void)KKAlbumImagePickerDirectoryList:(KKAlbumImagePickerDirectoryList*)aListView
                 selectedDirectoryModel:(KKAlbumDirectoryModel*)aModel;

- (void)KKAlbumImagePickerDirectoryList_WillHide:(KKAlbumImagePickerDirectoryList*)aListView;

- (void)KKAlbumImagePickerDirectoryList_WillShow:(KKAlbumImagePickerDirectoryList*)aListView;

@end



NS_ASSUME_NONNULL_END
